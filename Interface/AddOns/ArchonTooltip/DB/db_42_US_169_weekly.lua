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
 local lookup = {'Mage-Fire','Paladin-Holy','Mage-Frost','Unknown-Unknown','Warrior-Fury','Warrior-Arms','Paladin-Protection','Warlock-Destruction','Rogue-Subtlety','DemonHunter-Havoc','Monk-Windwalker','Druid-Restoration','Priest-Discipline','Warlock-Demonology','Warlock-Affliction','Priest-Holy','Priest-Shadow','Monk-Mistweaver','Hunter-BeastMastery','Warrior-Protection','Shaman-Elemental','Shaman-Enhancement','Hunter-Marksmanship','Paladin-Retribution',}; local provider = {region='US',realm='Nordrassil',name='US',type='weekly',zone=42,date='2025-03-29',data={Ab='Abruno:AwACCAYABRQCAQACAQjfEQAuu5IABRQAAQACAQjfEQAuu5IABRQAAA==.',Al='Alandrìas:AwABCAIABRQAAA==.Altera:AwAECAYABAoAAA==.',Am='Amuri:AwAFCAwABAoAAA==.',An='Andere:AwAHCBIABAoAAA==.Androonatorz:AwACCAYABRQCAgACAQiPBQAipY4ABRQAAgACAQiPBQAipY4ABRQAAA==.Ankylotroll:AwADCAEABAoAAA==.Anímality:AwADCAEABAoAAA==.',Ar='Arcangila:AwAGCA8ABAoAAA==.',Ba='Baconegg:AwACCAMABAoAAA==.Balefire:AwAECAQABAoAAA==.',Be='Berentyr:AwAECAEABAoAAA==.',Bf='Bf:AwADCAEABAoAAA==.',Bl='Blargy:AwAGCAUABAoAAA==.Blaspheme:AwACCAIABRQAAA==.Blink:AwAFCBQABAoDAQAFAQhMQwAl/AgBBAoAAQAFAQhMQwAlrAgBBAoAAwAEAQjHTgAaIKUABAoAAQQAAAAGCAYABAo=.',Bo='Bouzol:AwAFCAkABAoAAA==.',Ca='Caliburne:AwAFCAEABAoAAA==.Capz:AwAFCA0ABRQDBQAFAQhaAABD9uwBBRQABQAFAQhaAABAFuwBBRQABgACAQh6AQBbjt0ABRQAAA==.',Ch='Chichujongar:AwABCAEABRQAAQcAH74CCAYABRQ=.',Ci='Cindertaro:AwADCAEABAoAAA==.Cindrella:AwAGCAoABAoAAA==.',Cl='Clayre:AwABCAMABRQCCAAGAQiqHgBLHvMBBAoACAAGAQiqHgBLHvMBBAoAAA==.',Co='Coolcrush:AwACCAIABAoAAQQAAAAFCAkABAo=.',Cr='Critzwar:AwACCAQABRQAAA==.',De='Deadlyiris:AwAGCAsABAoAAA==.Deitrus:AwABCAEABAoAAA==.Demonbulio:AwACCAIABAoAAA==.Demonisthicc:AwAHCAkABAoAAA==.',Di='Dithehealer:AwAFCAoABAoAAA==.',Dw='Dwayne:AwAECAYABAoAAA==.',El='Eliicia:AwACCAYABRQCCQACAQhEBwAqJp0ABRQACQACAQhEBwAqJp0ABRQAAA==.',Em='Emmetcullen:AwACCAQABRQAAA==.',En='Endorush:AwACCAYABRQCCgACAQgWCQBXdscABRQACgACAQgWCQBXdscABRQAAA==.',Er='Eragonb:AwAECAYABAoAAA==.Ereitherla:AwAECAQABAoAAA==.',Ex='Exigrr:AwACCAQABAoAAA==.',Fl='Fleredil:AwAGCA0ABAoAAA==.',Fu='Futaccine:AwAGCAYABAoAAA==.',['F�']='Föxtrot:AwACCAUABRQCCwACAQhFCAAn+XsABRQACwACAQhFCAAn+XsABRQAAA==.',Ga='Garen:AwAECAQABAoAAA==.',Gy='Gydeon:AwAHCAcABAoAAA==.',Ha='Haldane:AwAGCAsABAoAAQQAAAAGCAsABAo=.Havochunter:AwABCAEABAoAAA==.',He='Heatwavez:AwABCAEABAoAAA==.Heraois:AwAGCAoABAoAAA==.',Ho='Horndoggie:AwAFCAIABAoAAA==.',In='Innervatez:AwADCAkABRQCDAADAQgtAQBcSEIBBRQADAADAQgtAQBcSEIBBRQAAA==.',Ja='Jakie:AwAFCA0ABAoAAA==.Jarten:AwAFCAoABAoAAA==.',Je='Jerrenn:AwADCAUABAoAAA==.Jesseatamer:AwAFCAwABAoAAA==.',Js='Jstrawr:AwAGCBAABAoAAA==.',Ka='Kaera:AwAFCAIABAoAAA==.Kaleidoscope:AwABCAEABAoAAA==.Kartian:AwAECAcABAoAAA==.Karyisa:AwAFCAIABAoAAA==.Kazanaya:AwACCAIABAoAAA==.',Ki='Killalltoday:AwAECAcABAoAAA==.',Kn='Knixx:AwABCAIABRQCDQAIAQjICQA822cCBAoADQAIAQjICQA822cCBAoAAA==.',Ko='Koshka:AwADCAEABAoAAQQAAAAECAQABAo=.Kotastrophic:AwAGCAQABAoAAA==.',Kr='Krispykreme:AwADCAMABAoAAA==.',Ku='Kufoo:AwAECAcABAoAAA==.',Ky='Kytar:AwAICAgABAoAAA==.',['K�']='Kålevrå:AwAECAcABAoAAA==.',La='Larea:AwADCAIABAoAAA==.Laridee:AwAICAMABAoAAA==.Layez:AwADCAcABAoAAA==.',Le='Leo:AwABCAEABAoAAA==.Lethal:AwADCAMABAoAAA==.',Li='Linkstar:AwAFCAMABAoAAA==.',Lo='Lohal:AwAGCAkABAoAAA==.',Lu='Lunatiri:AwAICBAABAoAAA==.',Mc='Mcshen:AwAECAQABAoAAA==.',Me='Melikefire:AwAFCAkABAoAAA==.Merek:AwAECAcABAoAAA==.',Mi='Mikeysmom:AwAICAgABAoAAA==.',Mo='Mouthshowerz:AwADCAEABAoAAA==.',['M�']='Mélusine:AwAHCA8ABAoAAA==.',Na='Naksami:AwAECAQABAoAAA==.',Ne='Necrotoxin:AwAGCBIABAoAAA==.Neek:AwABCAIABRQAAA==.',Ni='Nightsdeath:AwACCAIABAoAAA==.Nightsever:AwAHCBAABAoAAA==.Nilleria:AwACCAQABRQEDgAIAQjRBQBJUScCBAoADgAHAQjRBQBN9icCBAoADwACAQgDGgA8SZ0ABAoACAABAQhigQAjAC0ABAoAAA==.Nirath:AwADCAcABAoAAA==.',No='Nopriest:AwABCAMABRQDEAAGAQhlHwA8FJEBBAoAEAAGAQhlHwA8FJEBBAoAEQAGAQg5HgAvH28BBAoAAA==.Notprepared:AwAFCAQABAoAAA==.',Nu='Nulltank:AwAFCAIABAoAAA==.',On='Onaroll:AwACCAYABRQCEgACAQh6CgAuGpwABRQAEgACAQh6CgAuGpwABRQAAA==.',Oo='Oohshiny:AwAFCAYABAoAAA==.',Pa='Pacamonk:AwABCAMABRQCCwAGAQhLGgA7hKkBBAoACwAGAQhLGgA7hKkBBAoAAA==.Pawnduh:AwADCAEABAoAAQQAAAAECAQABAo=.Pawpatine:AwAECAQABAoAAA==.Pawthetic:AwABCAEABRQAARIALhoCCAYABRQ=.',Pe='Penguinmagi:AwAFCBEABAoAAA==.Pertis:AwABCAMABRQAAA==.Petruccius:AwABCAEABRQAAA==.Pew:AwABCAEABRQCEwAHAQjoJABFJTMCBAoAEwAHAQjoJABFJTMCBAoAAA==.',Pr='Prumper:AwABCAIABRQCAwAIAQjpDABClnQCBAoAAwAIAQjpDABClnQCBAoAAA==.',Re='Remorse:AwACCAYABRQCFAACAQicAgAhhHwABRQAFAACAQicAgAhhHwABRQAAA==.Revid:AwAECAYABAoAAQQAAAAGCAoABAo=.',Ri='Riggo:AwAFCAIABAoAAA==.',Ro='Rockandshock:AwADCAQABRQCFQAIAQjCAABgo2wDBAoAFQAIAQjCAABgo2wDBAoAAA==.Ronfar:AwACCAQABRQCFgAIAQgKCABQB8gCBAoAFgAIAQgKCABQB8gCBAoAAA==.',Ru='Rueger:AwAGCAkABAoAAA==.Ruttisðir:AwAECAcABAoAAA==.',Ry='Ryhorn:AwAFCA4ABAoAAA==.',Sa='Sabnacke:AwABCAMABRQAAA==.Sanazenet:AwACCAIABAoAAA==.',Se='Segarth:AwADCAQABAoAAA==.Selen:AwAFCAkABAoAAA==.',Sh='Shìft:AwABCAMABRQAAA==.',Si='Sid:AwAFCAkABAoAAQsAOPMDCAkABRQ=.Sinfulghost:AwAFCA0ABAoAAA==.',Sl='Sloop:AwAGCAQABAoAAA==.Slow:AwAGCBkABAoCAQAGAQgaGABZh1QCBAoAAQAGAQgaGABZh1QCBAoAAA==.',Sm='Smokearope:AwADCAMABAoAAA==.',So='Sonícberger:AwAECAIABAoAAA==.',Su='Supercat:AwAECAMABAoAAA==.Surf:AwACCAQABAoAAA==.',Sw='Swankypally:AwACCAYABRQCBwACAQh2BQAfvnMABRQABwACAQh2BQAfvnMABRQAAA==.Swizzydk:AwAGCAMABAoAAA==.Swordscream:AwAICAEABAoAAA==.',Sy='Symphania:AwAECAYABAoAAA==.Syndicate:AwACCAMABAoAAA==.',Ta='Taieb:AwAECAgABAoAAA==.Tallyhochick:AwABCAMABRQAAA==.Tangerine:AwAHCBAABAoAAA==.Taylerswift:AwAECAQABAoAAA==.',Te='Tepid:AwABCAEABRQAAA==.',Th='Theexile:AwEHCBIABAoAAA==.',Ti='Ticklantical:AwAFCAkABAoAAA==.Tinyknowheal:AwAFCAIABAoAAA==.',To='Toko:AwADCAYABRQCEwADAQhFCAA6NAIBBRQAEwADAQhFCAA6NAIBBRQAAA==.Tomblord:AwAECAcABAoAAA==.',Tr='Truthful:AwABCAEABAoAAQQAAAADCAcABAo=.',Tw='Twin:AwAFCA8ABAoAAA==.',['T�']='Tës:AwAFCAsABAoAAA==.Tõkó:AwAFCAUABAoAARMAOjQDCAYABRQ=.',Um='Umbrae:AwABCAMABRQAAA==.',Uz='Uzala:AwABCAEABAoAAA==.',Va='Vaerpriest:AwABCAEABRQCEQAIAQiXEAA6BysCBAoAEQAIAQiXEAA6BysCBAoAAA==.Vanmidou:AwABCAEABAoAAA==.',Ve='Vendiyre:AwAECAQABAoAAA==.',Vo='Vorath:AwADCAEABAoAAA==.',We='Westerin:AwAFCAwABAoAAA==.',Wi='Wimateeka:AwAFCAIABAoAAA==.Windigo:AwADCAMABAoAAA==.Winginit:AwAHCAQABAoAARIALhoCCAYABRQ=.',Xe='Xenôn:AwAICBIABAoAAA==.',Yo='Yogí:AwACCAQABRQAAA==.Yonard:AwAECAkABAoAAA==.Yozomoto:AwACCAQABRQDEwAHAQhfFABVQ7UCBAoAEwAHAQhfFABVQ7UCBAoAFwAGAQiJHgA0XCYBBAoAAA==.',Ze='Zetsdean:AwAECAoABAoAAA==.',Zo='Zorbins:AwABCAMABRQAAA==.',['Ü']='Üther:AwAHCBQABAoDGAAHAQi/GwBWTpgCBAoAGAAHAQi/GwBWTpgCBAoABwACAQjlLAA9gnUABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end