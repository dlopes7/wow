local V2_TAG_NUMBER = 3

---Parse a single set of spec data from `state`
---@param decoder BitDecoder
---@param state ParseState
---@param lookup table<number, string>
---@return ProviderProfileSpec
local function parseSpecData(decoder, state, lookup)
	local result = {}
	result.spec = decoder.decodeString(state, lookup)
	result.progress = decoder.decodeInteger(state, 1)
	result.partition = decoder.decodeInteger(state, 1)
	result.total = decoder.decodeInteger(state, 1)
	result.rank = decoder.decodeInteger(state, 3)
	result.average = decoder.decodeFixedFloat(state, 1, 1)
	result.asp = decoder.decodeInteger(state, 2)
	result.difficulty = decoder.decodeInteger(state, 1)
	result.size = decoder.decodeInteger(state, 1)

	local encounterCount = decoder.decodeInteger(state, 1)
	result.encounters = {}
	for i = 1, encounterCount do
		local id = decoder.decodeInteger(state, 4)
		local kills = decoder.decodeInteger(state, 2)
		local best = decoder.decodeInteger(state, 1)

		result.encounters[id] = { kills = kills, best = best }
	end
	return result
end

---Parse a binary-encoded data string into a ProviderProfile
---@param decoder BitDecoder
---@param content string
---@param lookup table<number, string>
---@return ProviderProfile|nil
local function parse(decoder, content, lookup) -- luacheck: ignore 211
	---@type ParseState
	local state = { content = content, position = 1 }

	local tag = decoder.decodeInteger(state, 1)
	if tag ~= V2_TAG_NUMBER then
		return nil
	end

	local result = {}

	-- user data
	result.subscriber = decoder.decodeInteger(state, 1)
	-- overall data
	result.progress = decoder.decodeInteger(state, 1)
	result.total = decoder.decodeInteger(state, 1)
	result.totalKillCount = decoder.decodeInteger(state, 2)
	result.difficulty = decoder.decodeInteger(state, 1)
	result.size = decoder.decodeInteger(state, 1)
	result.perSpec = {}

	local specCount = decoder.decodeInteger(state, 1)
	if specCount > 0 then
		result.anySpec = parseSpecData(decoder, state, lookup)

		for _i = 1, specCount - 1 do
			local spec = parseSpecData(decoder, state, lookup)
			table.insert(result.perSpec, spec)
		end
	end

	local hasMainCharacter = decoder.decodeBoolean(state)

	if hasMainCharacter then
		local main = {}
		main.spec = decoder.decodeString(state, lookup)
		main.average = decoder.decodeFixedFloat(state, 1, 1)
		main.progress = decoder.decodeInteger(state, 1)
		main.total = decoder.decodeInteger(state, 1)
		main.totalKillCount = decoder.decodeInteger(state, 2)
		main.difficulty = decoder.decodeInteger(state, 1)
		main.size = decoder.decodeInteger(state, 1)
		result.mainCharacter = main
	end

	return result
end
 local lookup = {'Druid-Balance','Druid-Restoration','Priest-Shadow','Priest-Discipline','Rogue-Subtlety','Rogue-Outlaw','Monk-Mistweaver',}; local provider = {region='US',realm='Kalecgos',name='US',type='weekly',zone=42,date='2025-03-29',data={Al='Alex:AwABCAEABRQAAA==.',Am='Ambrosia:AwAECAIABAoAAA==.',Ba='Barlartwo:AwACCAMABAoAAA==.',Bu='Bullievit:AwAICBYABAoDAQAIAQjrFgBIijwCBAoAAQAHAQjrFgBHTTwCBAoAAgABAQgQVwAW8jUABAoAAA==.',Ca='Caylleana:AwADCAMABAoAAA==.',Cl='Cliver:AwACCAMABAoAAA==.',Cr='Cronos:AwAICAgABAoAAA==.',Dr='Dracene:AwACCAMABAoAAA==.Dryotis:AwAICBMABAoAAA==.',Ev='Evilgary:AwAECAQABAoAAA==.',Fr='Frayjah:AwACCAIABAoAAA==.',Ga='Gangstabarny:AwAGCAIABAoAAA==.Gazdort:AwAGCAYABAoAAA==.',He='Hesperio:AwAGCAoABAoAAA==.',Ho='Holytrollie:AwAECAQABAoAAA==.',Ik='Ikinokoru:AwADCAcABAoAAA==.',Li='Linsay:AwAECAgABRQDAwAEAQg4AgA09UUBBRQAAwAEAQg4AgA09UUBBRQABAABAQhVEAAr9TgABRQAAA==.',Ma='Marcus:AwAFCAwABAoAAA==.Max:AwADCAMABAoAAA==.',Mo='Monker:AwACCAIABAoAAA==.',Re='Rebexha:AwACCAMABAoAAA==.',['RÃ']='RÃ¨drum:AwAECAQABAoAAA==.',Sn='Sncak:AwAICBoABAoDBQAIAQgLBgBM+cACBAoABQAIAQgLBgBM+cACBAoABgACAQgLDAAqMVgABAoAAA==.',So='Sockbowl:AwAICBYABAoCBAAIAQgbDAA5rj4CBAoABAAIAQgbDAA5rj4CBAoAAA==.',St='Starhawk:AwAECAcABAoAAA==.',Sy='Syrieal:AwAHCBMABAoAAA==.',Ta='Tallai:AwAGCAoABAoAAA==.Tash:AwAECAkABRQCBwAEAQjFAwAZDCYBBRQABwAEAQjFAwAZDCYBBRQAAA==.',Un='Uni:AwAICBMABAoAAA==.',Va='Valyrken:AwABCAEABAoAAA==.Vamperella:AwABCAEABAoAAA==.',Wn='Wnderbread:AwAECAQABAoAAA==.',Yi='Yiumi:AwAGCAsABAoAAA==.',Yu='Yulogee:AwACCAIABAoAAA==.',Ze='Zemzelett:AwACCAMABAoAAA==.',Zu='Zummev:AwACCAMABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end