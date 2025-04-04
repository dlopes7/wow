---@class Private
local Private = select(2, ...)

---@class Provider
---@field name string
---@field region string
---@field realm string
---@field date string
---@field data table<string, ProviderProfile>

---@type table<string, Provider>
local providers = {}

---@param dataset table<'realm'|'subscribers', string|number>
---@return string
local function CreateProviderKey(dataset)
	return dataset.realm .. "-" .. dataset.subscribers
end

---@param lookup table<string, string>
---@param value table|string|number|nil|boolean
---@return table|string|number|nil|boolean
local function hydrate(lookup, value)
	if type(value) == "string" then
		return lookup[value] or value
	end

	if type(value) == "table" then
		local result = {}
		for k, v in pairs(value) do
			result[hydrate(lookup, k)] = hydrate(lookup, v)
		end
		return result
	end

	return value
end

---@param lookup table<string, string>
---@param provider table
function ArchonTooltip.AddProvider(lookup, provider)
	assert(type(lookup) == "table", "ArchonTooltip.AddProvider(lookup, provider) expects a table lookup")
	assert(type(provider) == "table", "ArchonTooltip.AddProvider(lookup, provider) expects a table provider")
	assert(type(provider.name) == "string", "ArchonTooltip.AddProvider(lookup, provider) tables must have a string provider.name")
	assert(type(provider.region) == "string", "ArchonTooltip.AddProvider(lookup, provider) tables must have a string provider.region")
	assert(type(provider.realm) == "string", "ArchonTooltip.AddProvider(lookup, provider) tables must have a string provider.realm")
	assert(type(provider.date) == "string", "ArchonTooltip.AddProvider(lookup, provider) tables must have a string provider.date")
	assert(type(provider.data) == "table", "ArchonTooltip.AddProvider(lookup, provider) tables must have table provider.data")

	if provider.region ~= Private.CurrentRealm.region then
		Private.Print("Provider", "rejected Provider for region " .. provider.region)
		return
	end

	if provider.name ~= Private.CurrentRealm.database and not Private.SupportsLazyLoading(provider.realm) then
		Private.Print("Provider", "rejected Provider for database " .. provider.name .. " as it is not what we should be loading")
		return
	end

	local rawData = provider.data
	local count = 0

	if Private.IsTestCharacter then
		for _ in pairs(rawData) do
			count = count + 1
		end
	end

	provider.data = {}

	setmetatable(provider.data, {
		__index = function(table, key)
			local data = rawData[key]

			if data == nil then
				return nil
			end

			return hydrate(lookup, data)
		end,
	})

	local key = CreateProviderKey({
		realm = provider.realm,
		subscribers = string.find(provider.type, "subscribers") and 1 or 0,
		region = provider.region,
	})

	if count > 0 then
		Private.Print("Provider", "added provider: " .. key .. " with " .. count .. " datasets")
	end

	providers[key] = provider
end

---@class ProviderProfile
---@field progress number
---@field total number
---@field average number
---@field anySpec ProviderProfileSpec|nil
---@field perSpec table<number, ProviderProfileSpec>
---@field difficulty number
---@field subscriber boolean
---@field size number
---@field encounters table<number, ProviderProfileEncounter> | nil
---@field totalKillCount number
---@field mainCharacter MainCharacterProfileLink|MainCharacterInlineData|nil

---@class MainCharacterProfileLink
---@field name string
---@field server string

---@class MainCharacterInlineData
---@field spec string
---@field average number
---@field difficulty number
---@field size number
---@field progress number
---@field total number
---@field totalKillCount number

---@class ProviderProfileSpec
---@field progress number
---@field total number
---@field average number|nil
---@field spec string
---@field asp number
---@field rank number
---@field difficulty number
---@field encounters table<number, ProviderProfileEncounter>|nil
---@field size number

---@class ProviderProfileEncounter
---@field kills number
---@field best number

---@param name string
---@param maybeRealm string
---@return ProviderProfile|nil
function Private.GetProviderProfile(name, maybeRealm)
	local realm = Private.GetRealmOrDefault(maybeRealm)

	if realm == nil then
		return nil
	end

	local providerIsLoaded = false

	for i = 1, 0, -1 do
		local key = CreateProviderKey({ realm = realm, subscribers = i })
		local provider = providers[key]

		if provider ~= nil then
			providerIsLoaded = true
			local profile = provider.data[name]

			if profile then
				return profile
			end
		end
	end

	if not providerIsLoaded and Private.SupportsLazyLoading(realm) then
		local databaseKeyToLoad = Private.GetDatabaseKeyForRealm(realm)

		if databaseKeyToLoad then
			local loaded = Private.LoadAddOn(databaseKeyToLoad, realm)

			if loaded then
				return Private.GetProviderProfile(name, realm)
			end
		end
	end

	return nil
end

---Helper function for `v2_find`. Locates the end of the character data blob containing `position`. This will always point to the suffix of the blob (current `.`)
---@param data string
---@param position integer
---@return integer
local function seek_character_end(data, position)
	local _, end_ = string.find(data, ".", position, true)
	return end_ and end_ or #data
end

---Helper function for `v2_find`. Locates the start of the character data blob containing `position`.
---@param data string
---@param position integer
---@return integer
local function seek_character_start(data, position)
	while position >= 1 do
		if string.sub(data, position, position) == "." then
			return position + 1
		end
		position = position - 1
	end

	-- reaching the start of the data without finding means that we start at the beginning of the string
	return 1
end

---Destructure the character blob starting at `position`. If you call this at a position that is not the start of a character, the name will include junk (but otherwise won't error).
---@param data string
---@param position integer
---@return string, string
local function get_current_character(data, position)
	local nameEnd = string.find(data, ":", position, true)
	if nameEnd == nil then
		return nil, nil
	end
	local charEnd = string.find(data, ".", nameEnd + 1, true)
	if charEnd == nil then
		return nil, nil
	end
	return string.sub(data, position, nameEnd - 1), string.sub(data, nameEnd + 1, charEnd - 1)
end

---Attempt to locate b64-encoded data with the name prefix `name` in the combined dataset `data` using binary search.
---@param data string
---@param name string
---@return string|nil, string|nil
local function v2_find(data, name)
	local position = string.len(data) / 2 + 1
	position = seek_character_start(data, position)

	-- we maintain the invariants that:
	-- 1. the `left` value is the start of a character entry (the first letter of the name)
	-- 2. the `right` value is the end of a character entry (the `.` at the end)
	local left, right = 1, string.len(data)

	while left <= position and right >= position do
		local current_name, b64_contents = get_current_character(data, position)
		if current_name == nil then
			return nil
		end
		if current_name == name then
			return name, b64_contents
		elseif current_name < name then
			-- we will find `name` to the right (if present)
			left = seek_character_end(data, position) + 1
			position = seek_character_start(data, left + math.floor((right - left) / 2))
		elseif current_name > name then
			-- we will find `name` to the left (if present)
			right = position - 1
			position = seek_character_start(data, left + math.floor((right - left) / 2))
		end
	end

	return nil
end

---@param lookup table
---@param provider table
function ArchonTooltip.AddProviderV2(lookup, provider)
	assert(type(lookup) == "table", "ArchonTooltip.AddProvider(lookup, provider) expects a table lookup")
	assert(type(provider) == "table", "ArchonTooltip.AddProvider(lookup, provider) expects a table provider")
	assert(type(provider.name) == "string", "ArchonTooltip.AddProvider(lookup, provider) tables must have a string provider.name")
	assert(type(provider.region) == "string", "ArchonTooltip.AddProvider(lookup, provider) tables must have a string provider.region")
	assert(type(provider.realm) == "string", "ArchonTooltip.AddProvider(lookup, provider) tables must have a string provider.realm")
	assert(type(provider.date) == "string", "ArchonTooltip.AddProvider(lookup, provider) tables must have a string provider.date")
	assert(type(provider.data) == "table", "ArchonTooltip.AddProvider(lookup, provider) tables must have table provider.data")

	if provider.region ~= Private.CurrentRealm.region then
		Private.Print("Provider", "rejected Provider for region " .. provider.region)
		return
	end

	if provider.name ~= Private.CurrentRealm.database then
		Private.Print("Provider", "rejected Provider for database " .. provider.name .. " as it is not what we should be loading")
		return
	end

	local rawData = provider.data

	provider.data = {}

	local cache = {}

	setmetatable(provider.data, {
		__index = function(table, key)
			if cache[key] then
				return cache[key]
			end

			local prefix = string.sub(key, 1, 2)
			if rawData[prefix] then
				local name, b64_contents = v2_find(rawData[prefix], key)
				local result = nil
				if name ~= nil then
					local bin_contents = Private.base64.decode(b64_contents)
					result = provider.parse(Private.BitDecoder, bin_contents, lookup)
				end
				cache[key] = result
				return result
			end

			return nil
		end,
	})

	local key = CreateProviderKey({
		realm = provider.realm,
		subscribers = string.find(provider.type, "subscribers") and 1 or 0,
		region = provider.region,
	})

	Private.Print("Provider", "added v2 provider: " .. key)

	providers[key] = provider
end
