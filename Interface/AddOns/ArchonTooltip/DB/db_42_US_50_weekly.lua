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
 local lookup = {'Mage-Arcane','Mage-Frost','Mage-Fire','Shaman-Restoration','Warrior-Fury','Warlock-Destruction','Warrior-Protection','Hunter-BeastMastery','Hunter-Marksmanship','Monk-Mistweaver','Monk-Windwalker','Paladin-Protection','Druid-Balance','DeathKnight-Unholy','Warrior-Arms','Unknown-Unknown','Priest-Discipline','Priest-Shadow','DeathKnight-Frost','Paladin-Retribution','DemonHunter-Havoc','Warlock-Demonology','Warlock-Affliction',}; local provider = {region='US',realm='CenarionCircle',name='US',type='weekly',zone=42,date='2025-03-29',data={Ab='Abrielle:AwADCAMABAoAAA==.',Ad='Adrrel:AwACCAMABRQEAQAIAQjjAgA8gMsBBAoAAgAIAQgMGQAy1/IBBAoAAQAFAQjjAgBOgMsBBAoAAwACAQg0ZQAj4GAABAoAAA==.',Ak='Aknologia:AwADCAgABAoAAA==.',Al='Albita:AwADCAgABAoAAA==.Alystriaz:AwAFCAwABAoAAA==.Alzheimerz:AwAFCAQABAoAAA==.',Am='Amaribo:AwAGCBEABAoAAA==.',An='Aninja:AwADCAMABAoAAA==.',Ar='Aragnir:AwAECAEABAoAAA==.Arcianna:AwAECAEABAoAAA==.Arcusaesopi:AwACCAIABAoAAA==.',As='Ashtyn:AwADCAUABAoAAA==.Astronema:AwADCAYABAoAAA==.',At='Atrayupryde:AwAECAcABAoAAA==.',Av='Avelina:AwAFCBAABAoAAA==.Avocat:AwAFCAwABAoAAA==.',Ay='Ayelle:AwADCAgABAoAAA==.',Az='Azeria:AwACCAUABRQCBAACAQiECAAw5JkABRQABAACAQiECAAw5JkABRQAAA==.',Ba='Balgar:AwADCAcABAoAAA==.',Bl='Bloodrayvn:AwAFCBAABAoAAA==.Blàck:AwADCAQABAoAAA==.',Bo='Boompupper:AwAECAEABAoAAQUAIV0CCAUABRQ=.',Ca='Cayleynne:AwAGCBEABAoAAA==.',Ch='Chromstrasza:AwADCAQABAoAAA==.',Cl='Claric:AwABCAIABRQCBgAIAQi4GgA3JhICBAoABgAIAQi4GgA3JhICBAoAAA==.',Co='Conjarr:AwAECAIABAoAAA==.Coranis:AwAICAsABAoAAA==.',De='Deathduke:AwACCAIABAoAAQcANn0CCAUABRQ=.Degen:AwACCAQABRQDCAAIAQgIEwBLAcECBAoACAAIAQgIEwBLAcECBAoACQABAQgaQQAbjy0ABAoAAA==.Desmádre:AwADCAMABAoAAA==.',Dj='Djthelock:AwAFCBAABAoAAA==.',Dr='Dragonnthese:AwADCAQABAoAAA==.Druen:AwAECAEABAoAAA==.Drunkxmonk:AwABCAEABRQDCgAHAQgGKQAkpV0BBAoACgAHAQgGKQAkpV0BBAoACwAFAQiQKwAtdQYBBAoAAA==.',Ea='Eaglesribs:AwAECAIABAoAAA==.',Ed='Eddrick:AwAFCA0ABAoAAA==.',Ei='Eilethen:AwAFCAkABAoAAA==.',Er='Eragon:AwADCAcABAoAAA==.',Ev='Evanorah:AwAECAQABAoAAA==.Evelis:AwADCAgABAoAAA==.',Fa='Facelessman:AwACCAIABAoAAA==.',Fe='Ferrovax:AwADCAQABAoAAA==.',Gr='Grimbrindral:AwACCAUABRQCDAACAQjRAwBKSasABRQADAACAQjRAwBKSasABRQAAA==.Grimfister:AwAHCAwABAoAAA==.',He='Hephaistian:AwAECAUABAoAAA==.',Hi='Hirnatou:AwACCAUABAoAAA==.',Ho='Horsebananas:AwACCAIABAoAAA==.',Hu='Hulud:AwADCAIABAoAAA==.Hundredsouls:AwAGCA4ABAoAAA==.',Ka='Kantong:AwAECAYABAoAAA==.',Ki='Kinrowan:AwAECAcABAoAAA==.',Ku='Kurick:AwADCAQABAoAAA==.',Lo='Loons:AwADCAIABAoAAA==.',Lu='Lukeduke:AwACCAUABRQCBwACAQgKAgA2fZ0ABRQABwACAQgKAgA2fZ0ABRQAAA==.',['L�']='Lôckrocks:AwAFCBAABAoAAA==.',Ma='Mandarin:AwAFCA4ABAoAAA==.',Me='Mercia:AwAECAEABAoAAA==.',Mi='Milker:AwACCAUABRQCDQACAQiTCABUHccABRQADQACAQiTCABUHccABRQAAA==.Misschris:AwADCAgABAoAAA==.',Ne='Nekro:AwAFCBAABAoAAA==.Nemmen:AwAICBcABAoCBgAIAQgAIQAnveIBBAoABgAIAQgAIQAnveIBBAoAAA==.Neongrasp:AwACCAUABRQCDgACAQjWBQA/WLEABRQADgACAQjWBQA/WLEABRQAAA==.',Ni='Nickatnight:AwAECAcABAoAAA==.',On='Onefiftyone:AwADCAYABAoAAA==.',Pa='Panhen:AwABCAEABAoAAA==.Paraparaboom:AwACCAUABRQDBQACAQi+CwAhXZsABRQABQACAQi+CwAhXZsABRQADwABAQh1CwASpzwABRQAAA==.Paraquat:AwAECAEABAoAAA==.',Ph='Phantastik:AwAECAEABAoAAA==.',Pl='Plunka:AwADCAUABAoAAA==.',Po='Potshot:AwAGCA0ABAoAAA==.',Pr='Priya:AwAICAMABAoAAA==.',Pu='Punchline:AwADCAgABAoAAA==.',Ra='Rakhak:AwACCAUABAoAAA==.',Re='Redwinetoast:AwADCAYABAoAAA==.Reshyk:AwADCAQABAoAAA==.',Ri='Rivermire:AwADCAQABAoAAA==.',Ru='Rurry:AwABCAMABRQAARAAAAACCAIABRQ=.',Ry='Ryuki:AwAHCBEABAoAAA==.',Sc='Scoot:AwADCAcABRQDEQADAQgpBgBIwbYABRQAEQACAQgpBgBC47YABRQAEgABAQikCwA4SVgABRQAAA==.Scourgespawn:AwACCAUABRQCEwACAQg/AgAdPY4ABRQAEwACAQg/AgAdPY4ABRQAAA==.',Se='Seev:AwABCAEABAoAAA==.Sephuz:AwAECAMABAoAAA==.Serbiscuit:AwADCAMABAoAAA==.',Sh='Shailora:AwADCAMABAoAAA==.Shalis:AwADCAcABAoAAA==.Sharvali:AwADCAcABAoAAA==.',Si='Simbagrovex:AwAICBAABAoAAA==.',Sl='Sluggo:AwACCAQABRQCFAAIAQgSLgBDTTQCBAoAFAAIAQgSLgBDTTQCBAoAAA==.',So='Solfist:AwADCAgABAoAAA==.',Sp='Spiralmist:AwAFCAEABAoAAA==.',Su='Sus:AwACCAQABRQCFQAIAQjqFgBBImYCBAoAFQAIAQjqFgBBImYCBAoAAA==.',Ta='Talana:AwADCAgABAoAAA==.',Te='Tegrizelle:AwADCAgABAoAAA==.',Th='Thanatoasted:AwABCAEABRQEFgAIAQhSBAA681gCBAoAFgAIAQhSBAA681gCBAoABgAHAQiaKgAom5oBBAoAFwABAQjkLQAfLykABAoAAA==.',To='Tombstone:AwAFCAIABAoAAA==.Topgap:AwACCAIABRQAAA==.',Ve='Verick:AwADCAYABAoAARAAAAADCAgABAo=.',Vo='Voidduchess:AwAHCAEABAoAAQcANn0CCAUABRQ=.',Wa='Warenio:AwAFCAgABAoAAA==.',Wu='Wubbyseven:AwAECAUABAoAAA==.',Ze='Zeusinator:AwAFCBAABAoAAA==.',Zu='Zulfionn:AwAFCBAABAoAAA==.',['Á']='Áyrá:AwADCAgABAoAAA==.',['Ø']='Øuroboros:AwADCAQABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end