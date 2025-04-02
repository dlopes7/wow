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
 local lookup = {'Warrior-Protection','Druid-Restoration','DemonHunter-Havoc','Warrior-Arms','Warlock-Demonology','Warlock-Destruction','Warlock-Affliction',}; local provider = {region='US',realm='Haomarush',name='US',type='weekly',zone=42,date='2025-03-29',data={Ar='Aralaria:AwADCAUABAoAAA==.',Au='Aundarr:AwAECAgABAoAAA==.',Bl='Blackrose:AwADCAQABAoAAA==.',Bu='Bubblepally:AwABCAEABAoAAA==.Buutron:AwAECAQABAoAAA==.',Ca='Calixta:AwADCAYABAoAAA==.Carburettor:AwAECAcABAoAAA==.',Ch='Cherrypie:AwADCAYABAoAAA==.',Cl='Clingy:AwADCAMABAoAAA==.',Do='Doson:AwAFCAsABAoAAA==.',Dr='Dratak:AwACCAQABRQCAQAIAQgwAABh1YEDBAoAAQAIAQgwAABh1YEDBAoAAA==.Drlove:AwAGCBIABAoAAA==.',Fa='Fanumtax:AwAFCAgABAoAAA==.Farstrider:AwAECAQABAoAAA==.',He='Helton:AwABCAIABAoAAA==.',Ja='Jalgo:AwAECAYABAoAAA==.',Kr='Kroth:AwAHCBQABAoCAgAHAQjRGQAvP5kBBAoAAgAHAQjRGQAvP5kBBAoAAA==.',Lu='Lunaci:AwAECAQABAoAAA==.',Ma='Magnusson:AwAECAcABAoAAA==.Mandrah:AwADCAQABAoAAA==.Masutado:AwAECAoABAoAAA==.Maven:AwAECAYABAoAAA==.Maypah:AwAECAcABAoAAA==.',Me='Mechalediah:AwABCAIABAoAAA==.Meesoholy:AwABCAEABAoAAA==.',Mu='Munco:AwAFCA4ABAoAAA==.',My='Mythhdh:AwAGCBQABAoCAwAGAQgdFwBdA2UCBAoAAwAGAQgdFwBdA2UCBAoAAA==.Myzara:AwAGCBQABAoCBAAGAQgkEABIMe0BBAoABAAGAQgkEABIMe0BBAoAAA==.',Na='Nacl:AwAFCAUABAoAAA==.',No='Notker:AwAECAcABAoAAA==.',Ph='Phatarse:AwAHCBMABAoAAA==.',Ra='Rasticune:AwACCAIABAoAAA==.',Re='Rennik:AwAGCBUABAoEBQAGAQjvFwBZdBoBBAoABgAEAQhFOwBISTIBBAoABQADAQjvFwBXHhoBBAoABwADAQhXEgBOjO4ABAoAAA==.Rentiak:AwAECAcABAoAAA==.',Sa='Sanise:AwACCAIABAoAAA==.',Sk='Skeetshootah:AwADCAQABAoAAA==.',Sl='Slowbadon:AwAECAkABAoAAA==.',['T�']='Tÿ:AwAGCAYABAoAAA==.',Ze='Zerene:AwAECAcABAoAAA==.',['Æ']='Æsc:AwADCAQABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end