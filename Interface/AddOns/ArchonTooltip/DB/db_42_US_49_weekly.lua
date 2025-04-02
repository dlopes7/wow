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
 local lookup = {'Monk-Mistweaver','DeathKnight-Unholy','Druid-Feral','Unknown-Unknown','Paladin-Retribution','DemonHunter-Havoc','Warrior-Protection','Hunter-Survival','Warlock-Demonology','Warlock-Destruction','DeathKnight-Blood','Shaman-Enhancement',}; local provider = {region='US',realm='Cairne',name='US',type='weekly',zone=42,date='2025-03-29',data={Ae='Aellemman:AwADCAgABAoAAA==.',Am='Amorra:AwADCAYABAoAAA==.',Ar='Aramoonsong:AwAGCBIABAoAAA==.',As='Ashfuu:AwAECAcABAoAAA==.',Ba='Bamboosted:AwAHCBgABAoCAQAHAQhsCQBYha0CBAoAAQAHAQhsCQBYha0CBAoAAA==.',Bi='Biebert:AwAHCBAABAoAAA==.',Bl='Bloodegg:AwAFCAkABAoAAA==.',Br='Brewzlee:AwADCAcABAoAAA==.',Bu='Bunyuck:AwAGCA4ABAoAAA==.Buttmuscles:AwAHCBgABAoCAgAHAQiGDABVYZUCBAoAAgAHAQiGDABVYZUCBAoAAA==.',Ch='Chawn:AwADCAcABAoAAA==.Chronô:AwADCAEABAoAAA==.',Da='Daespells:AwAGCBAABAoAAA==.Daethör:AwAFCAcABAoAAA==.Darkmeat:AwAFCAUABAoAAA==.',De='Deathclaw:AwAFCAwABAoAAA==.Deroera:AwAHCBAABAoAAA==.',Di='Dionus:AwAECAcABAoAAA==.',Do='Donkeyman:AwACCAEABAoAAA==.',Du='Dumkiran:AwACCAIABAoAAA==.',Fl='Flubbergust:AwAHCBgABAoCAwAHAQjhAgBb68wCBAoAAwAHAQjhAgBb68wCBAoAAA==.',Fu='Furryfire:AwACCAIABAoAAA==.',Gw='Gwendolyn:AwAECAsABAoAAQQAAAAGCBIABAo=.',Ho='Holypowder:AwACCAMABRQCBQAIAQhdBABeMlwDBAoABQAIAQhdBABeMlwDBAoAAA==.Hopegorex:AwAECAYABAoAAA==.',Il='Illimommy:AwADCAQABRQCBgAIAQh0BQBY5TgDBAoABgAIAQh0BQBY5TgDBAoAAA==.',Iz='Izzyrael:AwAGCBQABAoCBwAGAQgoBABbJVwCBAoABwAGAQgoBABbJVwCBAoAAA==.',Ja='Jabbatroz:AwADCAMABAoAAA==.',Je='Jerey:AwAFCAYABAoAAA==.',Ji='Jitlo:AwAFCAMABAoAAA==.',Jr='Jromia:AwABCAEABAoAAA==.',Kh='Khaiduus:AwAECAgABAoAAA==.',Ko='Kobyy:AwACCAMABAoAAA==.Kottenmouth:AwABCAIABRQCCAAIAQh+AABbgToDBAoACAAIAQh+AABbgToDBAoAAA==.',Kr='Kritea:AwAGCAwABAoAAA==.',Ku='Kudd:AwAGCBAABAoAAA==.Kurastrasz:AwAGCAwABAoAAA==.',Ky='Kydie:AwAFCAkABAoAAA==.',La='Lastina:AwAFCAcABAoAAA==.',Le='Lebron:AwADCAYABAoAAA==.',Lu='Lumilad:AwABCAEABAoAAA==.',Mo='Movalon:AwAFCAUABAoAAA==.',My='Mymonk:AwAECAgABAoAAA==.Myrmidonos:AwAECAMABAoAAA==.',Na='Nativelock:AwADCAkABAoAAA==.',Ne='Nerishana:AwADCAMABAoAAA==.',Op='Opani:AwADCAQABAoAAA==.',Ot='Otisburgmagi:AwACCAIABAoAAA==.',Ox='Oxiousbeanz:AwACCAIABAoAAA==.',Pa='Papalock:AwAECAkABAoAAA==.',Pe='Persymphony:AwAHCBUABAoDCQAHAQiKDAAu25gBBAoACQAGAQiKDAA1GpgBBAoACgAFAQgCSgAbLOoABAoAAA==.',Ra='Railt:AwADCAYABAoAAA==.Rama:AwABCAIABAoAAA==.Rasz:AwAHCBEABAoAAA==.',Re='Rebelmonk:AwABCAIABAoAAQQAAAACCAQABAo=.',Ri='Ripsets:AwAHCBIABAoAAA==.',Ro='Rosalind:AwAECAUABAoAAA==.',Sa='Sarigos:AwADCAUABAoAAA==.',Sc='Schieldemon:AwAGCAoABAoAAA==.Scrythe:AwAHCBgABAoCCwAHAQhxFQAw0pABBAoACwAHAQhxFQAw0pABBAoAAA==.',Sh='Shrodwrah:AwAECAgABAoAAA==.Shrongo:AwAECAUABAoAAA==.',Sp='Spàrtan:AwAECAUABAoAAA==.',St='Steelehorn:AwACCAIABAoAAA==.Steeltotem:AwADCAEABAoAAA==.',Sw='Sweetjaïne:AwADCAQABAoAAA==.',Sy='Syla:AwACCAIABAoAAA==.',Ta='Talasacerdos:AwAGCAwABAoAAA==.',Th='Thickerson:AwADCAMABAoAAA==.Thundersrest:AwACCAIABAoAAA==.',To='Toxicwaste:AwADCAQABAoAAA==.',Tz='Tzzird:AwAHCBUABAoCBQAHAQhFKQBLeEsCBAoABQAHAQhFKQBLeEsCBAoAAA==.',Va='Varod:AwACCAIABAoAAA==.',Vi='Vizerianos:AwABCAIABAoAAA==.',Wa='Wartrick:AwAFCAwABAoAAA==.',Wh='Whoudini:AwAGCBAABAoAAA==.',Xe='Xerãth:AwAHCAsABAoAAA==.',Xi='Xisi:AwAICAgABAoAAA==.',Ya='Yaviel:AwADCAcABAoAAA==.',Za='Zaaren:AwAFCA4ABAoAAA==.Zackaran:AwAECAcABAoAAA==.',Zh='Zhenlim:AwAFCAkABAoAAA==.',Zo='Zortmier:AwAHCBcABAoCDAAHAQidDQBLoGYCBAoADAAHAQidDQBLoGYCBAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end