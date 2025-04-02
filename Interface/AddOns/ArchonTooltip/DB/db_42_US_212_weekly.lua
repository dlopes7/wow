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
 local lookup = {'Priest-Shadow','Warrior-Fury','Mage-Fire','Paladin-Retribution',}; local provider = {region='US',realm='Terokkar',name='US',type='weekly',zone=42,date='2025-03-28',data={Ab='Abuna:AwAFCAkABAoAAA==.',An='Antandra:AwADCAMABAoAAA==.',Aw='Awrina:AwAFCAkABAoAAA==.',Ca='Calliopê:AwAICAgABAoAAA==.',['C�']='Cærus:AwAFCAMABAoAAQEAKn8DCAYABRQ=.',Da='Daedrina:AwABCAEABAoAAA==.Dalkrim:AwAFCAkABAoAAA==.',De='Delaina:AwABCAEABRQAAA==.Derrick:AwADCAMABAoAAA==.',Di='Dibbsette:AwAFCAkABAoAAA==.',Dr='Dreamfyre:AwAFCAgABAoAAA==.',Ev='Evilssoul:AwABCAIABRQAAA==.',Fr='Frushy:AwACCAIABAoAAA==.',Ho='Hordecore:AwAECAEABAoAAA==.',Im='Imugi:AwAFCAcABAoAAA==.',Je='Jessdarklord:AwAECAUABAoAAA==.',Ji='Jiago:AwAICAYABAoAAA==.',Ke='Kevdog:AwAFCAkABAoAAA==.',Ko='Koldov:AwAHCAMABAoAAA==.',La='Lava:AwAFCAMABAoAAA==.',Li='Lifeblõõm:AwAFCAcABAoAAA==.',Ma='Maximillyon:AwABCAIABRQCAgAHAQizEABNVWcCBAoAAgAHAQizEABNVWcCBAoAAA==.',Or='Ororoe:AwAGCA0ABAoAAA==.',Ra='Raindrop:AwABCAIABRQAAA==.',Re='Reignstorm:AwAFCAkABAoAAA==.Rethelm:AwADCAMABAoAAA==.',So='Soß:AwADCAcABRQCAwADAQh/CQA40e8ABRQAAwADAQh/CQA40e8ABRQAAA==.',Su='Supadh:AwAGCA8ABAoAAA==.',To='Toes:AwADCAUABAoAAA==.',Ve='Veryundead:AwAFCAcABAoAAA==.',Vi='Viers:AwACCAQABRQCBAAIAQjBCwBVmQwDBAoABAAIAQjBCwBVmQwDBAoAAA==.Vierz:AwACCAIABAoAAA==.',Wu='Wunbranesell:AwABCAEABAoAAA==.',Wy='Wyrmheart:AwACCAQABAoAAA==.',Za='Zandarix:AwADCAMABAoAAA==.',['Z�']='Zèró:AwAICAgABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end