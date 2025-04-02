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
 local lookup = {'Evoker-Preservation','Druid-Restoration','Warrior-Fury','Priest-Shadow','Mage-Frost','Hunter-BeastMastery','DeathKnight-Unholy','DeathKnight-Frost','Paladin-Retribution','Druid-Guardian','Monk-Windwalker','Shaman-Enhancement','Shaman-Restoration','DemonHunter-Havoc',}; local provider = {region='US',realm='Jaedenar',name='US',type='weekly',zone=42,date='2025-03-29',data={Ab='Aberdeen:AwAFCAMABAoAAA==.',Al='Alphachik:AwAECAcABAoAAA==.',Ax='Axeldaur:AwACCAIABAoAAA==.',Ba='Barnte:AwAECAcABAoAAA==.',Bo='Boojum:AwAFCAoABAoAAA==.Booze:AwAECAoABAoAAA==.Borko:AwADCAMABAoAAA==.',Br='Breadquanda:AwACCAcABRQCAQACAQjgAQBUNrYABRQAAQACAQjgAQBUNrYABRQAAA==.',Cl='Clevelaire:AwAFCA4ABAoAAA==.',Cm='Cmpletebeans:AwADCAMABAoAAA==.',Da='Daretofail:AwAGCBQABAoCAgAGAQgkEABRsgICBAoAAgAGAQgkEABRsgICBAoAAA==.',De='Devastata:AwACCAcABRQCAwACAQg+CgAxJKoABRQAAwACAQg+CgAxJKoABRQAAA==.',Dr='Dracopuffs:AwADCAMABAoAAA==.Drakari:AwAGCA0ABAoAAA==.',Dy='Dyo:AwACCAIABRQCBAAIAQjjAwBafRsDBAoABAAIAQjjAwBafRsDBAoAAA==.',El='Elmono:AwACCAcABRQCBQACAQiqBAAmBYsABRQABQACAQiqBAAmBYsABRQAAA==.Elyda:AwABCAEABAoAAA==.',Fa='Faafo:AwABCAIABAoAAA==.Far:AwACCAQABRQCBgAIAQi7EQBSDcwCBAoABgAIAQi7EQBSDcwCBAoAAA==.',Ga='Gaskil:AwAECAQABAoAAA==.',Go='Gobbious:AwABCAIABRQDBwAIAQgHDwBMRXACBAoABwAIAQgHDwBMRXACBAoACAABAQgyJAA0vjIABAoAAA==.',Gr='Grahalin:AwABCAMABRQCCQAIAQjnGABKGawCBAoACQAIAQjnGABKGawCBAoAAA==.Grimgrun:AwAFCAsABAoAAA==.',Ha='Hades:AwABCAIABRQCBgAIAQjuEwBKebkCBAoABgAIAQjuEwBKebkCBAoAAA==.Halarda:AwACCAcABRQCBgACAQiUDwA+DZ0ABRQABgACAQiUDwA+DZ0ABRQAAA==.',Ho='Holyramen:AwAHCBIABAoAAA==.Hooves:AwACCAcABRQCCgACAQjoAAAz/YAABRQACgACAQjoAAAz/YAABRQAAA==.',In='Incideranus:AwAICAgABAoAAA==.',Iz='Izthefoofi:AwAFCA0ABAoAAA==.',Ja='Jaelana:AwAECAkABAoAAA==.',Ju='Juiceboxoxo:AwAGCA0ABAoAAA==.',Ka='Kasharas:AwAFCA8ABAoAAA==.',Kh='Khain:AwADCAMABAoAAA==.Khealer:AwAECAoABAoAAA==.',Ki='Kindi:AwAECAcABAoAAA==.Kitymeowmeow:AwACCAQABRQCCwAIAQgQAQBfR28DBAoACwAIAQgQAQBfR28DBAoAAA==.',Kl='Klausnomi:AwAICCUABAoDDAAIAQiSFwA3I84BBAoADAAHAQiSFwAyrM4BBAoADQABAQiodgAT3DkABAoAAA==.',Li='Lilithe:AwADCAoABAoAAA==.',Ma='Magnusbane:AwACCAIABAoAAA==.Magonorrea:AwAECAQABAoAAA==.Malaqor:AwAFCAUABAoAAA==.',Mi='Misslay:AwABCAEABAoAAA==.',Na='Nanalli:AwAECAEABAoAAA==.',Ni='Nightwarrior:AwACCAEABAoAAA==.',Pu='Pup:AwABCAEABAoAAA==.',Qk='Qkslvr:AwAFCAoABAoAAA==.',Ra='Randlidan:AwACCAMABRQCDgAIAQjwCgBRHewCBAoADgAIAQjwCgBRHewCBAoAAA==.',Sa='Saoirse:AwAECAQABAoAAA==.',Se='Setchypunch:AwAGCA0ABAoAAA==.',Sh='Shyhunts:AwACCAMABAoAAA==.',Sl='Slapnchop:AwAFCAwABAoAAA==.',St='Stoneward:AwAECAcABAoAAA==.',Su='Superspike:AwACCAQABRQCBQAIAQh6BQBQFfICBAoABQAIAQh6BQBQFfICBAoAAA==.Surlock:AwAGCAcABAoAAA==.',Th='Thehunter:AwAECAQABAoAAA==.Thunderfurry:AwAECAEABAoAAA==.',Tw='Twizz:AwAECAQABAoAAA==.',Va='Vaylon:AwACCAMABAoAAA==.',We='Wesdarian:AwAFCAcABAoAAA==.',Wh='Whoami:AwADCAYABAoAAA==.',['Í']='Ísolde:AwAECAgABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end