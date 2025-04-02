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
 local lookup = {'Unknown-Unknown','Evoker-Devastation',}; local provider = {region='US',realm="Anub'arak",name='US',type='weekly',zone=42,date='2025-03-29',data={As='Asparagus:AwADCAUABAoAAA==.',Ay='Ayeka:AwADCAUABAoAAA==.',Be='Bettyseu:AwACCAIABAoAAA==.',Bo='Bookittyfk:AwABCAEABRQAAA==.',Br='Brruno:AwAGCAUABAoAAA==.',['BÃ']='BÃ¼buktyfuc:AwAGCAIABAoAAA==.',Ca='Castroph:AwACCAIABAoAAA==.',Ch='Chravis:AwADCAUABAoAAA==.',Cz='Czaedyn:AwAGCAYABAoAAA==.',Da='Daarkwater:AwAECAEABAoAAA==.Daslock:AwAECAYABAoAAA==.',De='Dervish:AwADCAUABAoAAA==.',Er='Eriqus:AwADCAUABAoAAA==.',Fa='Fatroph:AwACCAIABAoAAA==.',Fr='Frostpimp:AwAECAcABAoAAA==.',Gu='Gumba:AwAECAEABAoAAA==.',Hr='Hruid:AwADCAMABAoAAA==.',Ka='Kaoru:AwADCAUABAoAAA==.',Ki='Kier:AwAFCAgABAoAAA==.',Li='Lifegiver:AwAFCAEABAoAAA==.',Lo='Lommen:AwAECAYABAoAAA==.',Ma='Malcolm:AwADCAUABAoAAQEAAAAFCAkABAo=.',Mi='Misti:AwADCAUABAoAAA==.Miyafuji:AwADCAUABAoAAA==.',['MÃ']='MÃ­riel:AwADCAMABAoAAA==.',Ph='Phu:AwADCAUABAoAAA==.',Ra='Raanth:AwAGCAsABAoAAA==.',Sa='Santovaca:AwADCAgABAoAAA==.',Sc='Scales:AwAGCAYABAoAAA==.Schmerz:AwABCAIABRQCAgAGAQhlGAA1ancBBAoAAgAGAQhlGAA1ancBBAoAAA==.Scion:AwAFCAEABAoAAA==.',St='Strongtoast:AwAECAEABAoAAA==.',Th='Thonor:AwADCAMABAoAAA==.Throar:AwAICAgABAoAAA==.Thuglar:AwAGCAIABAoAAA==.',To='Tommyag:AwAFCAUABAoAAA==.Toso:AwAICAEABAoAAA==.',Xe='Xerc:AwAGCAsABAoAAA==.',Yo='Youaremopped:AwAICAgABAoAAA==.',Ze='Zebracake:AwAICA0ABAoAAA==.',Zh='Zharrgal:AwADCAUABAoAAA==.',Zo='Zooknock:AwAFCAkABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end