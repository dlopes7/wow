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
 local lookup = {'DeathKnight-Frost','DeathKnight-Blood','Paladin-Protection','Warlock-Destruction','Warlock-Affliction','Paladin-Holy','Shaman-Enhancement','Rogue-Outlaw','Priest-Shadow','Monk-Windwalker','Hunter-Marksmanship','Hunter-BeastMastery','Druid-Restoration','Unknown-Unknown','DemonHunter-Havoc','Paladin-Retribution','Warrior-Fury','Priest-Holy','Priest-Discipline','Shaman-Elemental','Shaman-Restoration','DeathKnight-Unholy','Warlock-Demonology','Mage-Fire','Rogue-Assassination','Druid-Balance','Rogue-Subtlety','DemonHunter-Vengeance','Evoker-Devastation','Monk-Mistweaver','Druid-Feral','Mage-Arcane','Mage-Frost','Monk-Brewmaster','Evoker-Preservation','Warrior-Arms','Warrior-Protection',}; local provider = {region='US',realm='BurningBlade',name='US',type='weekly',zone=42,date='2025-03-28',data={Ac='Acerbic:AwAECAgABRQDAQAEAQgpAABaVYYBBRQAAQAEAQgpAABaVYYBBRQAAgABAQj5CQBXl18ABRQAAA==.Acertrick:AwAICAsABAoAAA==.',Ad='Adpally:AwABCAEABRQCAwAIAQgiAQBeP00DBAoAAwAIAQgiAQBeP00DBAoAAA==.',Ae='Aelwyd:AwACCAgABRQDBAACAQgWDAAvPYgABRQABAACAQgWDAAuUYgABRQABQABAQhMCwAm1E0ABRQAAA==.Aery:AwABCAEABRQCBgAIAQgNCwA29gACBAoABgAIAQgNCwA29gACBAoAAA==.',Ag='Aggron:AwAICBUABAoCBwAIAQi/DAA2jXACBAoABwAIAQi/DAA2jXACBAoAAA==.',Al='Alexassassin:AwADCAQABRQCCAAIAQjGAQBL+IgCBAoACAAIAQjGAQBL+IgCBAoAAA==.Allonsy:AwAECAQABAoAAA==.Aluas:AwABCAEABAoAAA==.Alzarak:AwAFCAsABAoAAA==.',Am='Amowshamow:AwAFCA8ABAoAAA==.',An='Anatall:AwAGCAgABAoAAA==.Anyachan:AwADCAMABAoAAA==.',Ar='Araeriispi:AwADCAkABRQCCQADAQg7AgBdyEIBBRQACQADAQg7AgBdyEIBBRQAAA==.Ari:AwABCAIABRQCCgAGAQjlDABc0VcCBAoACgAGAQjlDABc0VcCBAoAAA==.Arihog:AwAECAcABAoAAA==.Arkilyte:AwABCAIABRQAAQsAXAkDCAoABRQ=.Arkilytë:AwADCAoABRQDCwADAQjQAABcCTABBRQACwADAQjQAABcCTABBRQADAADAQj9BQBPex0BBRQAAA==.Arkílyte:AwAFCAUABAoAAQsAXAkDCAoABRQ=.Arothira:AwAFCAsABAoAAA==.Aryä:AwAGCBAABAoAAA==.',As='Ascend:AwEECAwABRQCBgAEAQiOAABRXWYBBRQABgAEAQiOAABRXWYBBRQAAA==.Ascendented:AwAHCAcABAoAAA==.Astrapaw:AwADCAQABAoAAA==.',Au='Auroch:AwAFCAMABAoAAA==.',Av='Avalen:AwAFCAYABAoAAA==.Avarcis:AwAGCA0ABAoAAA==.Avigdor:AwADCAIABAoAAA==.',Ba='Baalian:AwADCAcABAoAAA==.Badmigon:AwAECAQABAoAAA==.Bangbingboom:AwAECAkABAoAAA==.Barrey:AwABCAEABAoAAQ0AWqcDCAgABRQ=.Bartszp:AwAGCAYABAoAAA==.Basic:AwAGCBMABAoAAA==.',Be='Beefbroroni:AwAICAMABAoAAA==.',Bh='Bhadgar:AwABCAEABAoAAQ4AAAAGCAwABAo=.',Bi='Bigbossmonk:AwAHCAcABAoAAA==.Bigdd:AwADCAYABAoAAA==.Bigraga:AwAFCAoABAoAAA==.Bimbo:AwAFCAgABAoAAA==.Birdinii:AwACCAMABAoAAA==.Bithindel:AwACCAIABAoAAA==.',Bo='Boulderbash:AwAFCAkABAoAAA==.',Br='Brexxdh:AwAFCA4ABRQCDwAFAQhmAABGqe8BBRQADwAFAQhmAABGqe8BBRQAAA==.Bricktøp:AwACCAIABAoAAA==.',Bu='Bubbleblade:AwADCAUABAoAAA==.Bubblesbro:AwAECAsABRQCEAAEAQivAABMx5oBBRQAEAAEAQivAABMx5oBBRQAAA==.Buffalo:AwABCAEABRQCEQAIAQjWCwBKjqcCBAoAEQAIAQjWCwBKjqcCBAoAAA==.',Ca='Cakes:AwAECAYABAoAAA==.Callie:AwAECAwABRQDEgAEAQiYAABKfWMBBRQAEgAEAQiYAABKfWMBBRQAEwADAQgjBQAd7scABRQAAA==.Carerra:AwAICBAABAoAAA==.Caulkhunter:AwAFCA8ABAoAAA==.',Ce='Celine:AwAECAUABAoAAA==.',Ch='Chaosblade:AwAECAgABAoAAA==.Charlìe:AwAECAUABAoAAA==.Chickengawdz:AwABCAEABRQCCgAIAQjeDgBCojcCBAoACgAIAQjeDgBCojcCBAoAAA==.Chocobomb:AwAICBQABAoDFAAIAQheJQAp+S0BBAoAFAAGAQheJQAj+C0BBAoAFQAHAQguOwALZRoBBAoAAA==.Chunkis:AwAECAUABAoAAA==.',Ci='Cicatrizesp:AwAHCBUABAoCBwAHAQiMHgAVWnMBBAoABwAHAQiMHgAVWnMBBAoAAA==.Cive:AwAECAsABAoAAA==.',Cl='Clocho:AwAICAIABAoAAA==.',Co='Coldhurted:AwAICBwABAoDAQAIAQj8AwBHUYECBAoAAQAIAQj8AwBHUYECBAoAFgACAQjbUAAkSGcABAoAAA==.Corgirex:AwAGCA0ABAoAAA==.Cosmere:AwACCAMABAoAAA==.',Cr='Criminaal:AwADCAIABAoAAA==.Crimsondusk:AwABCAEABRQCCQAIAQh5CgBHGI0CBAoACQAIAQh5CgBHGI0CBAoAAA==.',Cy='Cyne:AwAECAQABAoAAA==.',Cz='Czigoo:AwAGCAsABAoAAA==.',Da='Dahnza:AwAGCBQABAoCEQAGAQgbMgAYjDkBBAoAEQAGAQgbMgAYjDkBBAoAAA==.Dalelador:AwABCAEABAoAAA==.Damagra:AwADCAMABAoAAA==.Dampfur:AwAFCAMABAoAAA==.Danendena:AwAFCAkABAoAAA==.Darkcorn:AwAGCBIABAoAAA==.Darlthedk:AwAGCBAABAoAAA==.Darminna:AwABCAEABRQEBQAIAQiSAQBSsqECBAoABQAIAQiSAQBPPKECBAoABAAEAQiSNABMnk8BBAoAFwABAQjlNwBIT0oABAoAAA==.Daziize:AwAGCBQABAoCAwAGAQjzBwBXmjgCBAoAAwAGAQjzBwBXmjgCBAoAAA==.',De='Deathlywind:AwABCAMABRQCAgAIAQiOCgBE5kMCBAoAAgAIAQiOCgBE5kMCBAoAAA==.Deci:AwABCAEABRQAAA==.Deln:AwADCAMABAoAAA==.Dessta:AwABCAEABAoAAQ4AAAABCAEABAo=.Destrorin:AwAGCBQABAoCFwAGAQgGCABM+uMBBAoAFwAGAQgGCABM+uMBBAoAAA==.Detree:AwAFCAEABAoAAA==.Detur:AwACCAIABAoAAA==.Devowizard:AwAFCA4ABRQCGAAFAQiFAABM8/oBBRQAGAAFAQiFAABM8/oBBRQAAA==.',Di='Dibib:AwADCAoABRQEBAADAQhKBQA9FOAABRQABAADAQhKBQAw8+AABRQABQACAQiDBQA0EZwABRQAFwABAQgcBwAi6UUABRQAAA==.Dingleling:AwAGCAYABAoAAQ4AAAAHCAoABAo=.Dirtybirdz:AwAGCAEABAoAAA==.Discobeast:AwAICBAABAoAAA==.',Do='Dorttok:AwAGCAsABAoAAA==.',Dr='Dractaka:AwAFCAsABAoAAA==.Dragondeezn:AwACCAEABAoAAA==.Drphil:AwAHCBkABAoEFgAHAQhfDwBQUl4CBAoAFgAHAQhfDwBNtF4CBAoAAgAEAQijGwBFKDgBBAoAAQADAQibGQAl9I8ABAoAAA==.Drucifer:AwAICBQABAoCBAAIAQhlLwAbNHABBAoABAAIAQhlLwAbNHABBAoAAA==.',Du='Dumptrucc:AwAECAcABAoAAA==.',Ek='Ekim:AwAECAQABAoAAA==.',El='Elspeth:AwAHCBMABAoAAA==.',Em='Emailed:AwEECAkABRQEBwAEAQjTBgA2V6UABRQABwACAQjTBgAqXaUABRQAFAABAQiRCAAgo0gABRQAFQABAQhtFAAm+DoABRQAAA==.',En='Endilyn:AwACCAEABAoAAA==.Envy:AwAFCA0ABAoAAA==.',Er='Ervine:AwABCAEABAoAAA==.',Ez='Ezath:AwACCAIABAoAAA==.',Fa='Fatcocoa:AwAFCAoABAoAAQEAXYcFCA4ABRQ=.',Fe='Feralwind:AwACCAIABAoAAA==.Festermight:AwADCAgABRQDFgADAQjbAQBQAjIBBRQAFgADAQjbAQBPKTIBBRQAAQACAQhZAQA6RL8ABRQAAA==.',Fr='Fredrock:AwAGCA8ABAoAAA==.Freestitches:AwADCAcABAoAAA==.Freshtea:AwAECAoABAoAAA==.',Ga='Gaiboi:AwADCAEABAoAAA==.Garbageboomx:AwAICAsABAoAAA==.',Ge='Georgeknight:AwACCAMABRQDFgAIAQgGGgA+Lu8BBAoAFgAIAQgGGgA+Lu8BBAoAAgABAQgERQAAagMABAoAAA==.Gewch:AwADCAEABAoAAA==.',Gr='Gradris:AwABCAEABRQCEAAIAQiRGgBM7pYCBAoAEAAIAQiRGgBM7pYCBAoAAA==.Greener:AwAGCBQABAoCDwAGAQhwGgBUVkECBAoADwAGAQhwGgBUVkECBAoAAA==.',Gu='Gunoil:AwACCAEABAoAAA==.',Ha='Halo:AwADCAMABAoAAA==.',He='Hextechvi:AwAFCAEABAoAAA==.',Hi='Himnick:AwAFCA4ABRQEFwAFAQiVAABZ6tUABRQABQADAQgPAQBGlhsBBRQAFwACAQiVAABba9UABRQABAACAQhmBgBU5ckABRQAAA==.',Ho='Holla:AwAICAgABAoAAA==.Hopz:AwAECAEABAoAAA==.Hornzie:AwADCAQABAoAAA==.Hotlinebling:AwADCAMABAoAAA==.',Hu='Hugzug:AwAECAQABAoAAA==.',Hy='Hyecansee:AwAFCAgABAoAAA==.',['H�']='Hèrrinà:AwAGCBEABAoAAA==.',Il='Illuunni:AwAGCBMABAoAAA==.',In='Innó:AwAFCAUABAoAARkAR5cECAoABRQ=.',It='Itzshowtime:AwADCAIABAoAAA==.',Jd='Jdemon:AwACCAIABAoAAA==.',Je='Jeddak:AwAGCBEABAoAAA==.',Jl='Jlimremix:AwABCAEABRQCGgAIAQj6AQBgQlwDBAoAGgAIAQj6AQBgQlwDBAoAAA==.',Ju='Justis:AwAICBAABAoAAA==.',Ka='Kaeorisera:AwECCAIABAoAAREAPM8ECAoABRQ=.Kaeoristrasz:AwEECAoABRQCEQAEAQhbAQA8z4MBBRQAEQAEAQhbAQA8z4MBBRQAAA==.Kanatash:AwAHCBQABAoDDAAHAQiNGQBRwoICBAoADAAHAQiNGQBRwoICBAoACwADAQhtLQA9U40ABAoAAA==.Karibdis:AwACCAIABAoAAA==.Karlachsimp:AwAICAgABAoAAA==.Karra:AwAHCA8ABAoAAA==.Kathqt:AwAICBAABAoAAA==.Kayssa:AwABCAIABRQAAA==.',Ke='Keegan:AwABCAEABRQCEQAIAQj7CQBOyMMCBAoAEQAIAQj7CQBOyMMCBAoAAA==.',Ki='Killstardo:AwAGCBQABAoCEQAGAQixKgAj424BBAoAEQAGAQixKgAj424BBAoAAA==.Kirkam:AwAECAgABAoAAQ0AWqcDCAgABRQ=.Kissdh:AwAGCBEABAoAAA==.',Ko='Komd:AwAECAcABAoAAA==.Koramar:AwACCAIABAoAARsANKgECAwABRQ=.',Kr='Kronsicus:AwAICAQABAoAAA==.',Ku='Kuuzko:AwACCAIABAoAAA==.',Li='Liopold:AwAGCAwABAoAAA==.Liquorbox:AwAFCAcABAoAAA==.Littledragon:AwADCAMABAoAAA==.Littlelion:AwAGCAwABAoAAA==.',Lo='Lohrian:AwAFCAoABAoAAA==.',Lr='Lronhoyabmbe:AwABCAEABAoAAA==.',Lu='Lucindragosa:AwABCAEABAoAAA==.Luckyscharmm:AwABCAEABRQAAA==.Luxx:AwABCAIABRQAAA==.',Lv='Lv:AwABCAEABRQCHAAIAQilAwBUBdMCBAoAHAAIAQilAwBUBdMCBAoAAA==.',Ma='Magecraftsp:AwAFCAgABAoAAR0AScAECAwABRQ=.Magistus:AwAFCA4ABRQCHgAFAQhpAABHjtIBBRQAHgAFAQhpAABHjtIBBRQAAA==.Malevenn:AwAGCAoABAoAAA==.Masachi:AwAFCAUABAoAAQ0ARXIECAwABRQ=.Masakins:AwAECAwABRQCDQAEAQi7AABFclwBBRQADQAEAQi7AABFclwBBRQAAA==.Masq:AwABCAEABAoAAA==.Matrebobe:AwAHCAIABAoAAA==.Maulnificent:AwACCAIABAoAAQMAOYEFCA4ABRQ=.Maulo:AwAFCA4ABRQCAwAFAQiXAAA5gXIBBRQAAwAFAQiXAAA5gXIBBRQAAA==.Maynaminty:AwAFCAYABAoAARoARVMFCA4ABRQ=.Maynaowl:AwAFCA4ABRQCGgAFAQheAABFU8EBBRQAGgAFAQheAABFU8EBBRQAAA==.Maynayogurt:AwAFCAUABAoAARoARVMFCA4ABRQ=.',Me='Meh:AwAFCAIABAoAAA==.Mentoes:AwAECAYABAoAAA==.',Mi='Midgert:AwAGCAYABAoAAA==.Mifoon:AwAGCAIABAoAAA==.Mirri:AwAECAQABAoAAA==.',Mo='Moktal:AwACCAIABAoAAA==.Moloki:AwADCAIABAoAAA==.Monkstuff:AwAFCAoABAoAAA==.Moomoomeadow:AwABCAEABAoAAA==.Moozar:AwAHCAYABAoAAA==.Morg:AwAFCAsABAoAAA==.',Ne='Negrumps:AwACCAUABAoAAA==.Nekidgrandma:AwACCAMABAoAAA==.Nezdh:AwAECAwABRQCDwAEAQgJAQBWIpgBBRQADwAEAQgJAQBWIpgBBRQAAA==.',Ni='Nicholascage:AwABCAEABRQDDAAIAQhPAQBiNH4DBAoADAAIAQhPAQBiNH4DBAoACwAFAQjAGwBN9jcBBAoAAA==.Nihilim:AwAGCBMABAoAAA==.',No='Notzeno:AwAICAgABAoAAA==.',Ny='Nyllalock:AwAGCBQABAoDBAAGAQjHFwBRPiMCBAoABAAGAQjHFwBRPiMCBAoABQABAQjlJgAc5kEABAoAAA==.Nyllalockb:AwAECAMABAoAAQQAUT4GCBQABAo=.',Ob='Oban:AwADCAMABAoAAQ4AAAAECAUABAo=.Obsidaddy:AwAGCBEABAoAAA==.',Ok='Okixs:AwAICAIABAoAAA==.',On='Onebadmonk:AwAICBAABAoAAA==.Onebadwarr:AwADCAEABAoAAQ4AAAAICBAABAo=.Onyxtempest:AwADCAMABAoAAA==.',Or='Oranmoki:AwABCAEABAoAAA==.',Oz='Ozpal:AwADCAQABAoAAA==.',Pa='Paladam:AwAGCAwABAoAAA==.Palroos:AwAFCAoABAoAAA==.',Pe='Pelinal:AwAECAsABRQCBgAEAQh5AABNy3EBBRQABgAEAQh5AABNy3EBBRQAAA==.Penelopi:AwADCAMABAoAAA==.Pensman:AwABCAEABAoAAA==.',Pi='Pigeonkick:AwADCAMABAoAAA==.Piratealex:AwAFCAYABAoAAQgAS/gDCAQABRQ=.',Pl='Platemate:AwAFCAcABAoAAA==.',Pr='Prepotenté:AwAECAoABAoAAA==.',Ps='Psychoq:AwAICA8ABAoAAA==.',Pt='Ptheve:AwAECAwABRQCEQAEAQiWAABchLUBBRQAEQAEAQiWAABchLUBBRQAAA==.',Pw='Pwiestman:AwABCAEABAoAAA==.',Py='Pyru:AwADCAYABAoAAA==.',Qu='Quantrank:AwAFCAoABAoAAA==.',Ra='Raei:AwAICBgABAoCFQAIAQhQJwAiW44BBAoAFQAIAQhQJwAiW44BBAoAAA==.Raewyn:AwAFCA0ABAoAAA==.Raladead:AwABCAEABAoAAA==.Ramas:AwAGCAsABAoAAA==.Ramchi:AwAECAYABAoAAA==.Ramhorn:AwACCAQABAoAAA==.Rawbee:AwAFCAgABAoAAA==.',Re='Reckon:AwAECAMABAoAAA==.Remain:AwACCAIABRQCDAAIAQhSDQBV0u8CBAoADAAIAQhSDQBV0u8CBAoAAA==.Remlar:AwAGCAEABAoAAA==.Renewspam:AwAFCAUABAoAAA==.',Ri='Rizzard:AwABCAEABRQAAA==.',Ro='Rocknshaman:AwAFCA0ABAoAAA==.Rokhunt:AwAECAsABRQCDAAEAQizAQBMq4EBBRQADAAEAQizAQBMq4EBBRQAAA==.Rougarou:AwADCAMABAoAAQ4AAAAECAQABAo=.Roundboi:AwAECAQABAoAAA==.',['R�']='Rîce:AwADCAIABAoAAQ4AAAAFCAgABAo=.Rîçë:AwAFCAgABAoAAA==.Röland:AwAHCBMABAoAAA==.',Sa='Satine:AwAFCAYABAoAAA==.',Sc='Screwheals:AwAHCAoABAoAAA==.',Se='Sellene:AwADCAgABRQCDQADAQg5AQBapzwBBRQADQADAQg5AQBapzwBBRQAAA==.Senorbang:AwAICAkABAoAAA==.Sep:AwABCAEABRQCFQAIAQh+BABWav4CBAoAFQAIAQh+BABWav4CBAoAAA==.',Sh='Shelandria:AwAECAwABRQCGwAEAQgkAQA0qGoBBRQAGwAEAQgkAQA0qGoBBRQAAA==.Shieldarc:AwEFCAUABAoAAQYAUV0ECAwABRQ=.Shiko:AwAGCBQABAoCEAAGAQg/HQBfbIQCBAoAEAAGAQg/HQBfbIQCBAoAAA==.Shmevly:AwAHCBIABAoAAA==.Shorion:AwACCAIABAoAAA==.Shreker:AwABCAEABRQCEgAIAQhVBABWiuICBAoAEgAIAQhVBABWiuICBAoAAA==.Shrig:AwAHCAwABAoAAA==.',Si='Sidebo:AwACCAIABAoAAA==.Sixing:AwABCAEABAoAAA==.',Sk='Skeeto:AwAGCBQABAoCHwAGAQjxCwAix14BBAoAHwAGAQjxCwAix14BBAoAAA==.Skettinoods:AwADCAYABAoAAA==.',Sl='Slimxx:AwAGCAsABAoAAA==.Slytherin:AwACCAEABAoAAA==.',Sn='Snaven:AwAFCAsABAoAAA==.',So='Soriko:AwAECAEABAoAAA==.Soul:AwABCAEABRQEGAAIAQi+EgBIXoMCBAoAGAAIAQi+EgBIXoMCBAoAIAABAQhcDQA4yTsABAoAIQABAQgTcwAP9icABAoAAA==.Soulstyce:AwACCAMABAoAAA==.',Sp='Spin:AwADCAQABAoAAA==.',St='Stedh:AwAFCAUABAoAAQMAVgQDCAoABRQ=.Stedk:AwABCAIABRQAAA==.Stepally:AwADCAoABRQCAwADAQhLAQBWBCYBBRQAAwADAQhLAQBWBCYBBRQAAA==.Strangehorse:AwAHCA4ABAoAAA==.Strongmace:AwAECAQABAoAAA==.',Su='Sugarzcoat:AwAECAcABAoAAA==.Sulphurous:AwADCAMABAoAAA==.',Sw='Sweetcheeba:AwAECAgABAoAAA==.Swippin:AwAFCAsABAoAAA==.Swsandy:AwAECAYABRQCCQAEAQj2AQA3E0sBBRQACQAEAQj2AQA3E0sBBRQAAA==.',Sy='Sylarr:AwABCAIABAoAAA==.Syler:AwAGCAkABAoAAA==.',Ta='Tasari:AwAECAwABRQDIgAEAQg4AABXyGoBBRQAIgAEAQg4AABXF2oBBRQACgABAQgSCQBRrFgABRQAAA==.',Th='Thiccbolts:AwAHCBQABAoDBAAHAQh6FwBFniUCBAoABAAHAQh6FwBBTyUCBAoAFwABAQj3NwAzEEoABAoAAA==.Thrallblade:AwACCAIABAoAAA==.Thunderstud:AwADCAMABAoAAA==.Thusios:AwAECAgABAoAAA==.',Ti='Tiggy:AwAECAcABAoAAA==.Tikí:AwAECAwABRQDIwAEAQhkAABaZTcBBRQAIwADAQhkAABgvjcBBRQAHQABAQjgCQAm4FIABRQAAA==.Tinesi:AwAICBIABAoAAA==.',To='Torthie:AwAECAwABRQCGAAEAQiiAQBU7pQBBRQAGAAEAQiiAQBU7pQBBRQAAA==.Torthìe:AwAFCAUABAoAARgAVO4ECAwABRQ=.Tothdk:AwAFCA4ABRQCAgAFAQg/AABMQdwBBRQAAgAFAQg/AABMQdwBBRQAAA==.Toxaaris:AwAGCAwABAoAAA==.',Tu='Tuffskins:AwABCAEABAoAAA==.Tuldien:AwAGCAgABAoAAA==.Turdball:AwADCAMABAoAAA==.',Tv='Tverdydh:AwACCAIABAoAAA==.',Tw='Twistkun:AwAECAoABAoAAA==.',Un='Unclerod:AwAFCAEABAoAAA==.Undine:AwAFCAUABAoAAA==.Unfixable:AwADCAQABRQAAA==.Unholystuff:AwAICAoABAoAAA==.Unplayable:AwACCAMABRQCEAAIAQhJHABPVIoCBAoAEAAIAQhJHABPVIoCBAoAAA==.',Va='Valtara:AwAECAQABAoAAA==.',Ve='Velociraptor:AwABCAEABAoAAA==.Vende:AwAGCBQABAoCHgAGAQgwDwBaI0sCBAoAHgAGAQgwDwBaI0sCBAoAAA==.',Vi='Viper:AwABCAEABRQCGQAIAQhFBABMxMQCBAoAGQAIAQhFBABMxMQCBAoAAA==.',Vl='Vlad:AwAICBQABAoDJAAIAQgbEgAoXscBBAoAJAAIAQgbEgAoXscBBAoAEQADAQiQVQAQ8nEABAoAAA==.',Vo='Vosslar:AwAGCBIABAoAAA==.',Wa='Waarrlockk:AwAECAwABRQEBAAEAQibAwBKEAgBBRQABAADAQibAwBHsQgBBRQAFwABAQh8AwA/uV0ABRQABQABAQjICQBQpVQABRQAAA==.Walrusrider:AwADCAMABAoAAA==.Wassy:AwABCAEABAoAAA==.',We='Wemgobyama:AwAGCA4ABAoAAA==.',Wi='Windwalker:AwAGCAIABAoAAA==.Wizartrees:AwACCAIABAoAAA==.Wizsera:AwAICBQABAoCHQAIAQjKCgBKgWECBAoAHQAIAQjKCgBKgWECBAoAAA==.',Wo='Womboree:AwAFCAwABAoAAA==.',Xa='Xabu:AwAECAIABAoAAA==.',Xe='Xeonhart:AwACCAQABRQDBAAIAQgMGABOuCECBAoABAAGAQgMGABR3iECBAoAFwACAQgaJABFR7QABAoAAA==.',Yk='Yki:AwADCAIABAoAAA==.',Yu='Yukarna:AwAHCA8ABAoAAA==.',Za='Zacha:AwAICAgABAoAAA==.Zannash:AwADCAYABAoAAA==.Zaraphym:AwAECAgABAoAAA==.',Ze='Zeats:AwABCAEABAoAARkAR5cECAoABRQ=.Zephyrine:AwAECAIABAoAAA==.',Zi='Zigy:AwAGCBQABAoCJQAGAQiyAwBdRmgCBAoAJQAGAQiyAwBdRmgCBAoAAA==.',Zu='Zukko:AwAFCAEABAoAAA==.',Zy='Zynny:AwACCAIABAoAAA==.Zynxy:AwAGCBAABAoAAA==.Zyrene:AwACCAIABAoAARUAIlsICBgABAo=.',['Ï']='Ïl:AwAECAoABRQCGQAEAQhDAABHl3YBBRQAGQAEAQhDAABHl3YBBRQAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end