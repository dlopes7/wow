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
 local lookup = {'Monk-Mistweaver','Hunter-BeastMastery','DeathKnight-Frost','Priest-Shadow','Unknown-Unknown','Paladin-Retribution','Evoker-Augmentation','Evoker-Devastation','Warrior-Fury','Hunter-Survival',}; local provider = {region='US',realm='Executus',name='US',type='weekly',zone=42,date='2025-03-29',data={Aa='Aarthros:AwABCAEABAoAAA==.',Ai='Aishana:AwABCAIABRQCAQAIAQjKAgBbvzEDBAoAAQAIAQjKAgBbvzEDBAoAAA==.',Al='Allondre:AwADCAUABAoAAA==.',An='Andryu:AwAHCBMABAoAAA==.',Ar='Arïel:AwAFCAEABAoAAA==.',['A�']='Aélish:AwACCAIABAoAAA==.',Bo='Bonsai:AwACCAIABAoAAA==.',Br='Broadfang:AwAECAkABRQCAgAEAQiXAQBWLYkBBRQAAgAEAQiXAQBWLYkBBRQAAA==.',Bu='Bucknasty:AwAGCAsABAoAAA==.Bullorly:AwABCAIABRQCAwAIAQjwAQBYBgYDBAoAAwAIAQjwAQBYBgYDBAoAAA==.',Cl='Clickshot:AwAHCBUABAoCAgAHAQiPHgBLmWMCBAoAAgAHAQiPHgBLmWMCBAoAAA==.Clipe:AwABCAEABAoAAA==.Clipex:AwAHCBIABAoAAA==.',Cr='Crach:AwAGCA0ABAoAAA==.Crispicrits:AwABCAEABAoAAA==.',Da='Darenas:AwABCAIABRQCBAAIAQgJEgAwqhQCBAoABAAIAQgJEgAwqhQCBAoAAA==.Dasu:AwAHCBMABAoAAA==.',Du='Durgon:AwAICBMABAoAAA==.',Ei='Eiswein:AwAGCAgABAoAAA==.',El='Elderdorje:AwAHCBMABAoAAA==.',Ev='Evangeliné:AwABCAEABAoAAQUAAAACCAIABAo=.',Ex='Exavier:AwAICBUABAoCBgAIAQj0BABeWFUDBAoABgAIAQj0BABeWFUDBAoAAA==.',Ga='Galatea:AwAFCA4ABAoAAA==.Galifen:AwAHCBMABAoAAA==.Gank:AwAHCAoABAoAAA==.',Ho='Hobbz:AwAGCAkABAoAAA==.',In='Invain:AwADCAgABRQCBAADAQjBAQBhvlgBBRQABAADAQjBAQBhvlgBBRQAAA==.',Ji='Jiren:AwAICAkABAoAAA==.',Jo='Joran:AwACCAIABAoAAA==.',Li='Liera:AwAFCAkABAoAAA==.',Lu='Luminå:AwAICAsABAoAAA==.',Ma='Mackahuky:AwACCAMABAoAAA==.Maibisan:AwAGCAwABAoAAA==.Malificent:AwAGCAsABAoAAA==.Mangoleaf:AwAFCAcABAoAAQUAAAAGCAYABAo=.',Mo='Moonsliver:AwAGCAsABAoAAA==.',Na='Nax:AwAFCAEABAoAAA==.',Ni='Niccelndime:AwAFCAcABAoAAA==.',Nx='Nx:AwAFCAgABAoAAA==.',Or='Orwasitme:AwAECAgABAoAAA==.',Ph='Phoenixfire:AwABCAEABAoAAA==.',Pi='Pilatez:AwAECAQABAoAAA==.',Po='Polyvoke:AwAICBQABAoDBwAIAQhMAgAiZR8BBAoACAAIAQg2FgAg85YBBAoABwAGAQhMAgAkFx8BBAoAAA==.Powerchan:AwAHCAYABAoAAQUAAAAICBMABAo=.',Qi='Qiller:AwACCAEABAoAAA==.',Ra='Radical:AwACCAIABAoAAA==.Razius:AwADCAMABAoAAA==.',Re='Renatox:AwAGCAkABAoAAA==.Renus:AwAGCAkABAoAAA==.',Se='Senodin:AwAHCAgABAoAAA==.',Sh='Shasato:AwAECAkABAoAAA==.',So='Soejoedi:AwAFCAUABAoAAA==.Sou:AwAECAkABRQCCQAEAQhoAQBF2YQBBRQACQAEAQhoAQBF2YQBBRQAAA==.',Sp='Spicyburrito:AwAFCA0ABAoAAA==.',Su='Subparatbest:AwAFCAcABAoAAA==.',Ta='Taille:AwADCAIABAoAAA==.',Th='Thejigga:AwAHCBIABAoAAA==.',To='Tourin:AwACCAIABAoAAA==.',Tr='Tris:AwACCAMABAoAAA==.',Va='Vander:AwACCAMABAoAAA==.Vayper:AwAHCBMABAoAAA==.',Wi='Wildfire:AwABCAIABRQCCgAIAQgbAABhLYADBAoACgAIAQgbAABhLYADBAoAAA==.',Wo='Wolfhammer:AwADCAUABAoAAA==.Wolfmend:AwACCAMABAoAAA==.',Ze='Zerotwo:AwAICBMABAoAAA==.',['Z�']='Zîmìk:AwAECAYABAoAAA==.',['À']='Àsh:AwAHCBMABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end