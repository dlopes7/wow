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
 local lookup = {'Paladin-Retribution','Priest-Holy','Priest-Shadow','Priest-Discipline','Evoker-Devastation','DemonHunter-Havoc','Unknown-Unknown','Hunter-BeastMastery',}; local provider = {region='US',realm='Baelgun',name='US',type='weekly',zone=42,date='2025-03-29',data={Ac='Acidrain:AwAGCA8ABAoAAA==.',Ah='Ahrmanhamma:AwABCAIABRQCAQAIAQiJGwBM6pkCBAoAAQAIAQiJGwBM6pkCBAoAAA==.Ahu:AwAGCAkABAoAAA==.',Al='Alandramun:AwAFCAcABAoAAA==.Alien:AwADCAMABAoAAA==.',Am='Amoondai:AwABCAIABRQCAgAHAQhACgBR4nUCBAoAAgAHAQhACgBR4nUCBAoAAA==.',Ap='Apochryphael:AwAGCA8ABAoAAA==.',As='Assaultness:AwACCAIABAoAAA==.',Ba='Bacstabath:AwAICA4ABAoAAA==.',Be='Beryl:AwADCAMABAoAAA==.',Bi='Birb:AwABCAIABRQEAwAIAQhOGAAyzrkBBAoAAwAHAQhOGAAuErkBBAoABAAEAQjAKgAsUPgABAoAAgAEAQiENwAx8PEABAoAAA==.Birbdormu:AwABCAEABRQCBQAHAQhHDwBCQQwCBAoABQAHAQhHDwBCQQwCBAoAAQMAMs4BCAIABRQ=.',Bl='Blink:AwADCAMABAoAAA==.Bloodios:AwAHCBEABAoAAA==.Blínd:AwAHCBYABAoCBgAHAQgKFABPXIUCBAoABgAHAQgKFABPXIUCBAoAAA==.',Bo='Bobinchaos:AwADCAMABAoAAA==.',Ch='Chikñ:AwAGCA4ABAoAAA==.',Ci='Cindresh:AwABCAIABAoAAA==.',Co='Cornfed:AwADCAMABAoAAA==.',Cr='Craszhin:AwAGCA8ABAoAAA==.',Da='Darkdelight:AwAHCBAABAoAAA==.',De='Deanna:AwAECAkABAoAAA==.',El='Elchonk:AwAECAUABAoAAA==.',Ev='Evilmonkeymg:AwAFCAsABAoAAA==.',Fa='Farts:AwADCAMABAoAAA==.',Fh='Fherrys:AwABCAIABAoAAQcAAAAECAUABAo=.Fhyre:AwAECAUABAoAAA==.',Fi='Firefox:AwAFCAEABAoAAA==.',Fl='Flypig:AwADCAIABAoAAA==.',Fr='Frostymonk:AwABCAIABAoAAA==.Frostyred:AwAFCAkABAoAAA==.',Fu='Furrari:AwAGCAkABAoAAA==.',Ga='Gallaxie:AwABCAEABRQAAA==.',Ge='Gentlefinger:AwADCAMABAoAAA==.',Gn='Gnöamchomsky:AwACCAIABAoAAA==.',Gr='Greenwaffle:AwABCAEABAoAAA==.Grob:AwADCAMABAoAAA==.',Ha='Haladi:AwAFCAUABAoAAA==.',Ho='Hotcoffee:AwAFCAEABAoAAA==.',Hu='Hunternexus:AwABCAIABAoAAA==.',Il='Illfate:AwACCAEABAoAAA==.Illikicker:AwAHCBAABAoAAA==.',Is='Isabelle:AwAECAYABAoAAA==.Istayblunted:AwACCAMABAoAAA==.',It='Itlwao:AwAFCAcABAoAAA==.',Ji='Jinkuzo:AwAGCA4ABAoAAA==.',Jo='Joogie:AwAECAYABAoAAA==.',Ki='Kilyanev:AwAFCAwABAoAAA==.',Le='Leothandraa:AwADCAMABAoAAA==.',Lo='Lokiewoo:AwAFCA8ABAoAAA==.',Ma='Mandigosa:AwABCAEABAoAAA==.Marsawn:AwAHCBEABAoAAA==.',Mi='Mindlessness:AwAHCBEABAoAAA==.',Ni='Ninok:AwABCAEABAoAAA==.',Og='Ogre:AwAFCAEABAoAAA==.',Po='Pompompower:AwAHCBAABAoAAA==.Porritera:AwAECAcABAoAAA==.',Re='Redone:AwAGCAwABAoAAA==.',Rh='Rhavaniel:AwADCAUABRQCCAADAQjKCABIVfoABRQACAADAQjKCABIVfoABRQAAA==.',Sa='Sasukê:AwACCAQABRQCAwAIAQjvCQBQfJ4CBAoAAwAIAQjvCQBQfJ4CBAoAAA==.',Sc='Scrügemcmonk:AwADCAQABAoAAA==.',Se='Seroshade:AwACCAIABAoAAA==.',Sh='Shamannexus:AwAFCAsABAoAAA==.',So='Sortis:AwAHCBMABAoAAA==.',St='Strigo:AwAFCAwABAoAAA==.',Ta='Talas:AwAHCBAABAoAAA==.',Th='Thrann:AwAGCA8ABAoAAA==.',Tr='Trillbrill:AwAFCAgABAoAAA==.',Va='Vaadmar:AwAFCA0ABAoAAA==.',Vy='Vyxenn:AwAHCBAABAoAAA==.',Wa='Washbourne:AwADCAMABAoAAA==.Wasolka:AwAHCBAABAoAAA==.',Za='Zazreal:AwAGCA8ABAoAAA==.',Zy='Zywol:AwAHCBEABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end