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
 local lookup = {'Unknown-Unknown','Paladin-Retribution','Warrior-Fury','Warrior-Arms','Evoker-Devastation','Warlock-Destruction','Warlock-Affliction','Warlock-Demonology','Monk-Mistweaver','Shaman-Elemental','DeathKnight-Unholy','Mage-Frost','Hunter-BeastMastery',}; local provider = {region='US',realm="Vek'nilash",name='US',type='weekly',zone=42,date='2025-03-28',data={Ae='Aeidail:AwABCAEABAoAAQEAAAABCAEABRQ=.',Ai='Ailee:AwAFCB0ABAoCAgAFAQgvWgBFKXoBBAoAAgAFAQgvWgBFKXoBBAoAAA==.',Am='Ampersand:AwADCAMABAoAAA==.',Ar='Ardrithmage:AwACCAIABRQAAQMAPh0FCA0ABRQ=.Ardrithwar:AwAFCA0ABRQCAwAFAQhYAAA+HewBBRQAAwAFAQhYAAA+HewBBRQAAA==.',As='Ascension:AwAGCBAABAoAAA==.',At='Atma:AwABCAEABAoAAA==.',Ba='Balzdor:AwABCAEABAoAAA==.Barthyl:AwABCAEABAoAAA==.',Bl='Bludo:AwABCAIABRQDBAAIAQgdCQBMC14CBAoABAAHAQgdCQBMOV4CBAoAAwAFAQgmLQA9i1wBBAoAAA==.',Br='Brugg:AwAECAgABAoAAA==.',Bu='Bulan:AwABCAIABRQAAA==.',Da='Dalren:AwACCAMABRQCBQAIAQgMBQBUvuICBAoABQAIAQgMBQBUvuICBAoAAA==.',De='Dek:AwAICAgABAoAAA==.Deket:AwABCAIABAoAAA==.',Di='Dirtydotss:AwADCAQABAoAAA==.Disgraceful:AwAICAgABAoAAA==.',Do='Dowedoes:AwAGCA0ABAoAAA==.',En='Enable:AwAGCA8ABAoAAA==.',Ew='Ew:AwADCAYABAoAAA==.',Fa='Fallenmonkey:AwACCAIABRQAAA==.',Fe='Felfrost:AwACCAIABAoAAA==.Fenork:AwACCAIABRQEBgAIAQiUJAAybrwBBAoABgAIAQiUJAAlb7wBBAoABwAEAQi3FgAZPrYABAoACAACAQhdMwAfx18ABAoAAA==.',Fl='Flameology:AwABCAEABAoAAA==.',Fr='Freakadeek:AwADCAYABAoAAA==.Fruit:AwAHCBAABAoAAQEAAAAFCAEABRQ=.',Gh='Ghosty:AwAECAkABAoAAA==.',Go='Goldenflame:AwAECAIABAoAAA==.Goldenlily:AwAHCBUABAoCCQAHAQiRMwAOJgsBBAoACQAHAQiRMwAOJgsBBAoAAA==.',Ho='Holyidiot:AwADCAQABAoAAA==.Hornreaper:AwADCAQABAoAAA==.',Il='Illidiva:AwADCAYABAoAAA==.',Io='Iol:AwAHCBQABAoCCgAGAQigFABJ4ucBBAoACgAGAQigFABJ4ucBBAoAAA==.',Ju='Jujudajuuler:AwAHCBMABAoAAA==.',Ka='Kaeliana:AwAECAkABAoAAA==.',Ko='Koojo:AwAECAcABAoAAA==.',Le='Lealla:AwAGCA8ABAoAAA==.Letholas:AwACCAEABRQCCwAIAQh7EwA/3jACBAoACwAIAQh7EwA/3jACBAoAAA==.',Lo='Lokan:AwAGCA4ABAoAAA==.Lots:AwAGCBAABAoAAA==.',['L�']='Lîghtless:AwABCAIABRQCDAAIAQhUAABjF48DBAoADAAIAQhUAABjF48DBAoAAA==.Lúckÿ:AwAGCAIABAoAAA==.',Mm='Mmisty:AwAFCAsABAoAAA==.',Pa='Pandas:AwADCAYABAoAAA==.',Ph='Phokus:AwAICAEABAoAAA==.',Po='Poliahu:AwACCAIABAoAAA==.Polkadottz:AwAFCAIABAoAAA==.Portass:AwAECAkABAoAAA==.Powerplant:AwABCAEABRQCDQAIAQgOFwBIPpYCBAoADQAIAQgOFwBIPpYCBAoAAA==.',Ra='Raegar:AwACCAQABAoAAA==.Ragetality:AwAFCAEABRQAAA==.Rattelyr:AwAFCAMABAoAAA==.',Re='Redemption:AwACCAIABAoAAQEAAAAGCBAABAo=.Regicee:AwAHCAsABAoAAA==.',Rh='Rhysandra:AwAGCA8ABAoAAA==.',Ri='Rivven:AwAGCAEABAoAAA==.',Se='Seladia:AwAGCAsABAoAAA==.Serbsham:AwAGCAoABAoAAA==.Serdragon:AwADCAYABAoAAA==.',Si='Sicarrii:AwAHCAoABAoAAA==.',Sk='Skoogz:AwAICBAABAoAAA==.',So='Soulspear:AwACCAMABAoAAA==.',Sp='Spiritkeep:AwABCAIABRQCAgAIAQiOEQBR89oCBAoAAgAIAQiOEQBR89oCBAoAAA==.',Ta='Tanisong:AwABCAIABAoAAA==.',Ti='Tilladin:AwAGCA0ABAoAAA==.',Va='Vanillas:AwAGCAEABAoAAA==.',Ve='Velladoree:AwABCAEABAoAAA==.Vereye:AwACCAMABAoAAA==.',Xr='Xrayl:AwAGCBAABAoAAA==.',Ze='Zendezoth:AwAECAYABAoAAA==.',Zh='Zhiva:AwABCAEABAoAAA==.',Zi='Zi:AwAICAgABAoAAA==.',Zo='Zouras:AwADCAQABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end