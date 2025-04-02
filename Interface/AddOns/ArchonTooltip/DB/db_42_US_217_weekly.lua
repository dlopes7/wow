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
 local lookup = {'Unknown-Unknown','DeathKnight-Unholy','Monk-Windwalker','Evoker-Preservation','Evoker-Devastation','Priest-Holy','Priest-Discipline',}; local provider = {region='US',realm='TheVentureCo',name='US',type='weekly',zone=42,date='2025-03-28',data={Am='Ampt:AwABCAEABAoAAA==.',Ba='Baegul:AwEECAcABAoAAA==.',Be='Beau:AwACCAUABAoAAA==.',Br='Brewster:AwACCAIABAoAAA==.',Ch='Chiise:AwAFCAcABAoAAA==.Chufeng:AwABCAEABAoAAQEAAAAHCBIABAo=.',Cu='Cucuy:AwACCAQABAoAAA==.',Cy='Cynikal:AwAFCAoABAoAAA==.',De='Deija:AwAECAQABAoAAQEAAAAFCAwABAo=.',Dr='Dreadfang:AwAGCBQABAoCAgAGAQiTFABToiQCBAoAAgAGAQiTFABToiQCBAoAAA==.',Em='Emerassi:AwAGCAYABAoAAA==.',Ex='Exodia:AwADCAUABAoAAA==.',Fe='Fellaria:AwAFCAUABAoAAQMAW2oGCBQABAo=.',Fh='Fhyllo:AwADCAYABAoAAA==.',He='Hellao:AwAGCA0ABAoAAA==.',Ho='Holykass:AwAECAcABAoAAA==.',Ja='Jango:AwAICAgABAoAAA==.',Ka='Kaladin:AwAGCAoABAoAAA==.',Ke='Kejiabaobei:AwAGCA0ABAoAAA==.Kestus:AwECCAIABAoAAQEAAAAECAUABAo=.',Kr='Krünk:AwAGCBQABAoDBAAGAQhwCQA9LrEBBAoABAAGAQhwCQA9LrEBBAoABQADAQjELgAKjWwABAoAAA==.',Ly='Lyreshade:AwAGCA0ABAoAAA==.',Mi='Minithell:AwAFCAEABAoAAA==.',Na='Nashal:AwEECAUABAoAAA==.',Ni='Nic:AwACCAIABAoAAQEAAAADCAQABAo=.Nilhaus:AwAFCAwABAoAAA==.Nimithriel:AwAGCAwABAoAAA==.',['N�']='Návain:AwAGCA0ABAoAAA==.',Py='Pyronae:AwAECAcABAoAAA==.',Re='Reya:AwAGCAEABAoAAA==.',Ro='Rollingember:AwAICAQABAoAAA==.',Se='Sesshoomaru:AwAICAYABAoAAA==.',Sh='Shadowstripe:AwADCAQABAoAAA==.',So='Sonatina:AwABCAEABRQCBgAIAQjpBwBQ1JcCBAoABgAIAQjpBwBQ1JcCBAoAAQcALhMFCA4ABRQ=.Soteria:AwABCAEABAoAAQEAAAAHCBIABAo=.',St='Stormbrother:AwABCAEABAoAAQEAAAAHCAwABAo=.',Sw='Sweets:AwAICAgABAoAAA==.',Th='Thrawnn:AwAHCBIABAoAAA==.',Tr='Trinia:AwACCAEABAoAAA==.',Ul='Ultear:AwADCAMABAoAAA==.',Va='Vathon:AwAICA4ABAoAAA==.',Xa='Xamanzinha:AwAICAIABAoAAA==.',Ze='Zelkiri:AwACCAUABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end