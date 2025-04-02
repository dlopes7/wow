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
 local lookup = {'DeathKnight-Frost','Unknown-Unknown','Mage-Frost','Warlock-Destruction','Warrior-Fury','Monk-Mistweaver','Warrior-Arms','Warrior-Protection','Mage-Arcane','Mage-Fire','Hunter-BeastMastery','Paladin-Retribution','Shaman-Elemental','Shaman-Restoration',}; local provider = {region='US',realm='Thunderhorn',name='US',type='weekly',zone=42,date='2025-03-28',data={An='Anaelle:AwAECAkABAoAAA==.Andelanin:AwAHCAcABAoAAA==.Anomandaris:AwADCAQABAoAAA==.',Ar='Ariandell:AwACCAQABRQCAQAIAQhAAABhDYADBAoAAQAIAQhAAABhDYADBAoAAA==.Arkkin:AwACCAIABAoAAA==.Aruser:AwAGCAMABAoAAA==.',As='Ashvalis:AwADCAEABAoAAA==.Asillyhunter:AwABCAIABRQAAA==.Askr:AwABCAEABAoAAA==.',Az='Azamii:AwAFCA4ABAoAAQIAAAAGCA4ABAo=.Azarion:AwAHCAEABAoAAA==.',Ba='Bandicoot:AwABCAEABRQCAwAIAQgCDwA1fVACBAoAAwAIAQgCDwA1fVACBAoAAA==.',Be='Bearrific:AwADCAUABAoAAA==.Beekeeper:AwACCAIABAoAAA==.Bequestor:AwAHCAEABAoAAA==.',Bi='Billybutcher:AwACCAUABRQCBAACAQiFDQAdynUABRQABAACAQiFDQAdynUABRQAAA==.Biney:AwABCAEABAoAAA==.',Br='Breebbs:AwAHCAEABAoAAA==.Brud:AwABCAEABRQAAA==.',Ca='Camo:AwAFCAoABAoAAA==.Carolbaskin:AwAECAUABAoAAA==.',Ch='Chaosfiend:AwAECAoABAoAAA==.Cheezeburg:AwADCAcABAoAAA==.Chronosaren:AwADCAcABAoAAA==.',Co='Cons:AwADCAUABAoAAA==.',Cr='Cranium:AwAFCA0ABAoAAA==.Crazytasty:AwAGCAMABAoAAA==.Crepe:AwADCAMABAoAAA==.Crisbbacon:AwADCAUABAoAAA==.Croissants:AwACCAQABAoAAA==.',Da='Dabora:AwAGCAIABAoAAA==.Dahpeht:AwACCAMABAoAAA==.Darock:AwAICAYABAoCBQAGAQjhZgAAvy0ABAoABQAGAQjhZgAAvy0ABAoAAA==.Dartin:AwADCAMABAoAAA==.',De='Deathquack:AwAICAgABAoAAA==.Devitodevour:AwAFCAEABAoAAA==.',El='Eleathe:AwACCAMABRQCBgAIAQglEgA2ZiMCBAoABgAIAQglEgA2ZiMCBAoAAA==.',Em='Emt:AwABCAEABAoAAA==.',En='Enirei:AwADCAQABAoAAA==.',Fe='Felaids:AwADCAIABAoAAA==.Felidoria:AwAFCAUABAoAAA==.',Fi='Fixer:AwABCAEABAoAAA==.',Fr='Frimm:AwAFCBIABAoAAA==.Frostmaster:AwAECAMABAoAAA==.',Gh='Ghostayáme:AwACCAIABAoAAA==.',Go='Gokhan:AwACCAMABRQCBQAIAQgWCQBL89ECBAoABQAIAQgWCQBL89ECBAoAAA==.',Gr='Griffpal:AwAFCA4ABAoAAA==.',Gw='Gwaplord:AwAICAgABAoAAA==.',Ha='Hardord:AwACCAIABAoAAA==.',Ho='Holikow:AwADCAcABAoAAA==.Holypie:AwAHCA4ABAoAAA==.Honorlife:AwAHCAIABAoAAA==.',In='Inkwell:AwAHCAEABAoAAA==.',Jd='Jdiddy:AwAECAQABAoAAA==.',Jo='Johnnsnow:AwABCAEABAoAAA==.',Ka='Kaltonos:AwABCAEABAoAAA==.Katyenka:AwABCAEABAoAAA==.',Ke='Kerlin:AwAECAIABAoAAA==.',Kh='Khaaferos:AwAFCAgABAoAAA==.',Ki='Kinoxo:AwACCAQABRQDBwAIAQjcCgBaTzsCBAoABwAHAQjcCgBJtzsCBAoABQAFAQj2IQBVqLkBBAoAAA==.',Le='Legnase:AwAGCA4ABAoAAA==.Lessgibbon:AwAGCAIABAoAAA==.',Li='Lightning:AwADCAMABAoAAA==.',Lo='Locklocket:AwAGCAgABAoAAA==.Lowkied:AwADCAIABAoAAA==.',Ma='Mackenton:AwAGCAkABAoAAA==.Marypoppinss:AwAFCAwABAoAAA==.',Me='Mendool:AwAECAgABAoAAA==.Menise:AwABCAIABRQAAA==.',Mi='Mirage:AwAHCAoABAoAAQgAU3kCCAMABRQ=.',Mo='Mortimore:AwABCAEABRQECQAHAQjcAwBEQXUBBAoACgAHAQiHLgAqBIYBBAoACQAFAQjcAwBFKHUBBAoAAwAFAQifMwAxYRwBBAoAAA==.',Na='Naraku:AwADCAYABAoAAA==.Narberal:AwAICAgABAoAAA==.',Ne='Nes:AwAECAMABAoAAA==.',No='Noxveritas:AwAGCAMABAoAAA==.',Ph='Phaithfulnes:AwABCAEABAoAAA==.',Pi='Pinnie:AwAGCAEABAoAAA==.',Po='Pooner:AwADCAcABAoAAA==.Porteagarder:AwAECAkABAoAAA==.',Pp='Pp:AwADCAQABAoAAA==.',Pu='Puffthemagic:AwAGCA0ABAoAAA==.',Qu='Quacktotem:AwAGCAYABAoAAQIAAAAICAgABAo=.',Ra='Ravenscorn:AwAFCAYABAoAAA==.',Re='Rebuke:AwABCAEABAoAAA==.Rezduck:AwAGCAQABAoAAA==.',Sa='Salythia:AwAFCAIABAoAAQYANmYCCAMABRQ=.Sandvichus:AwAECAMABAoAAA==.Saphiro:AwAFCAkABAoAAA==.',Sc='Scone:AwAHCBIABAoAAA==.',Sh='Shamuel:AwABCAEABRQCCwAHAQgfGABTa44CBAoACwAHAQgfGABTa44CBAoAAA==.',Si='Silent:AwACCAMABRQCCAAIAQiqAQBTee4CBAoACAAIAQiqAQBTee4CBAoAAA==.',Sk='Skykomish:AwADCAIABAoAAA==.',Sp='Spinecrawler:AwAGCBEABAoAAA==.',St='Stibly:AwAICAYABAoAAA==.',Sw='Swaine:AwADCAMABAoAAA==.',Sz='Szy:AwAFCAYABAoAAA==.',Ta='Taelyx:AwAFCAMABAoAAA==.Taunted:AwADCAcABAoAAA==.',Ti='Titanbow:AwAFCAoABAoAAA==.',Tr='Traffiic:AwABCAEABAoAAA==.Tremblay:AwAGCBcABAoCDAAGAQidNgBWXAMCBAoADAAGAQidNgBWXAMCBAoAAA==.Trikery:AwAHCA4ABAoAAA==.Triketia:AwAHCAgABAoAAA==.Trogdorè:AwACCAQABAoAAA==.',Tw='Twilghtdawn:AwAHCAEABAoAAA==.',Un='Unholyherpes:AwAHCBMABAoAAA==.',Ur='Uranus:AwACCAMABAoAAA==.',Va='Vainagos:AwABCAEABAoAAA==.',Ve='Vernaria:AwABCAEABAoAAA==.',Vo='Voidsham:AwAGCBQABAoDDQAGAQgjFgBcHdQBBAoADQAFAQgjFgBeqtQBBAoADgAGAQjfIwA9B6UBBAoAAA==.',Wi='Wizbizzler:AwAFCAwABAoAAA==.',Wo='Wolfyre:AwAICAgABAoAAA==.',Ze='Zenainkor:AwADCAkABAoAAA==.Zennya:AwADCAEABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end