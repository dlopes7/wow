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
 local lookup = {'Warrior-Fury','Hunter-BeastMastery','Unknown-Unknown','Shaman-Restoration','Paladin-Retribution','Rogue-Assassination','DemonHunter-Havoc','Shaman-Enhancement','Mage-Fire','Priest-Discipline','Priest-Holy','Priest-Shadow','Warrior-Protection','Druid-Feral','Warlock-Destruction','Warlock-Demonology','Monk-Mistweaver','Mage-Arcane','DeathKnight-Unholy','Druid-Balance',}; local provider = {region='US',realm='Caelestrasz',name='US',type='weekly',zone=42,date='2025-03-29',data={Ab='Abbyss:AwACCAMABAoAAA==.Abramelinn:AwABCAEABRQAAA==.',Ac='Acaìla:AwAECAcABAoAAA==.',Ae='Aerîz:AwACCAIABAoAAA==.Aesku:AwACCAIABAoAAA==.',Al='Aldogz:AwAICBAABAoAAA==.Allor:AwADCAMABAoAAA==.Alyxpants:AwAGCBAABAoAAA==.',Am='Amenu:AwADCAQABAoAAA==.Amenusham:AwACCAIABAoAAA==.Amishall:AwAGCAwABAoAAA==.',An='Anguskhan:AwADCAEABAoAAA==.Anoroc:AwAFCAwABAoAAA==.',Ar='Arity:AwAFCAUABAoAAA==.Arndul:AwAICAYABAoAAA==.',As='Ashtism:AwAGCAoABAoAAA==.Asta:AwADCAUABRQCAQADAQgBBgAvvAQBBRQAAQADAQgBBgAvvAQBBRQAAA==.',At='Athenna:AwABCAEABAoAAA==.Atüned:AwAECA0ABAoAAA==.',Au='Auryon:AwADCAcABRQCAgADAQgeBgBaDiYBBRQAAgADAQgeBgBaDiYBBRQAAA==.',Av='Avendar:AwAFCAQABAoAAA==.',Ay='Ayyva:AwADCAQABAoAAQMAAAAFCA0ABAo=.',Az='Azii:AwABCAEABRQAAA==.Azolii:AwADCAEABAoAAA==.Azuba:AwAICBgABAoCBAAIAQjiCQBW+6MCBAoABAAIAQjiCQBW+6MCBAoAAA==.',Ba='Babricksean:AwADCAMABAoAAA==.Baconpancake:AwABCAEABAoAAA==.Badgêr:AwAGCBIABAoAAA==.Balerion:AwADCAIABAoAAA==.Barethor:AwAECAQABAoAAA==.Battleaxe:AwAECAcABAoAAA==.',Be='Belarii:AwAFCAQABAoAAA==.Bellestina:AwAFCAQABAoAAA==.Belsam:AwACCAMABAoAAA==.Bendecida:AwACCAIABAoAAQMAAAABCAEABRQ=.',Bi='Biggutman:AwAFCAUABAoAAA==.Bigpurp:AwAICAgABAoAAA==.',Bl='Bladetwo:AwABCAEABRQCAgAHAQjDEwBaQboCBAoAAgAHAQjDEwBaQboCBAoAAA==.',Bo='Boneblocka:AwAECAUABAoAAA==.Bonerjamz:AwAICAoABAoAAA==.',Br='Brokin:AwAECAcABAoAAA==.',Bu='Bubblëøseven:AwAGCBAABAoAAA==.Budgie:AwAGCA4ABAoAAA==.Budgy:AwAECAgABAoAAA==.Bundie:AwAECAMABAoAAA==.Bunneh:AwAECAUABAoAAA==.',['B�']='Bëllädonna:AwACCAIABAoAAA==.',Ca='Caalz:AwABCAEABAoAAQUAYWsCCAYABRQ=.Candrena:AwADCAQABAoAAA==.',Ch='Chaotilock:AwADCAEABAoAAA==.Chubbypope:AwADCAMABAoAAQYAWlUBCAIABRQ=.',Cl='Cleevi:AwAECAIABAoAAA==.Cloudmonk:AwAFCAIABAoAAA==.',Cy='Cyndradre:AwACCAIABAoAAA==.',['C�']='Cônundrum:AwADCAUABAoAAA==.',Da='Daftmonk:AwADCAIABAoAAA==.Dalanarr:AwAECAkABAoAAA==.Damnrisky:AwAFCAUABAoAAA==.Dapridy:AwABCAEABRQAAA==.Daprity:AwAHCAcABAoAAQMAAAABCAEABRQ=.Davè:AwAGCAEABAoAAA==.',De='Deathgold:AwABCAEABAoAAA==.Debris:AwAECAcABAoAAA==.Deflekt:AwAGCA0ABAoAAA==.Delilillea:AwAFCAkABAoAAA==.Dengar:AwABCAEABRQCAgAIAQhCIgA8LUcCBAoAAgAIAQhCIgA8LUcCBAoAAA==.Destriànt:AwAECAoABAoAAA==.',Dr='Dragonhead:AwAECAsABRQCBwAEAQjZAABbl6cBBRQABwAEAQjZAABbl6cBBRQAAA==.Drucaila:AwACCAIABAoAAA==.Drøp:AwAGCA0ABAoAAA==.',Du='Dudesrock:AwAICBYABAoCCAAIAQiZBQBST/cCBAoACAAIAQiZBQBST/cCBAoAAA==.',Ee='Eevaa:AwAICAgABAoAAA==.Eevà:AwACCAIABAoAAA==.',Ef='Efink:AwAECAQABAoAAA==.',Ei='Eirikafemk:AwABCAEABRQAAA==.',El='Elfhelm:AwAECAgABAoAAA==.Elured:AwAECAsABAoAAA==.',Em='Emildra:AwABCAEABRQAAA==.',Er='Erekhoec:AwADCAQABAoAAA==.Erth:AwADCAQABAoAAA==.Eryuna:AwAECAEABAoAAA==.',Ex='Exiledemon:AwAECAEABAoAAA==.Expedio:AwAFCAMABAoAAA==.',Ez='Ezza:AwAGCAwABAoAAA==.',Fa='Fanface:AwAGCAYABAoAAA==.Fangerino:AwABCAIABRQCCQAIAQjSAwBbEkEDBAoACQAIAQjSAwBbEkEDBAoAAA==.',Fi='Fingersword:AwAFCAkABAoAAA==.',Fl='Flaviousqt:AwACCAEABAoAAA==.Flekzakzak:AwAFCAsABAoAAA==.Flekzugzug:AwADCAQABAoAAA==.Fluffpriest:AwABCAEABRQDCgAIAQhhGQAlGIwBBAoACgAIAQhhGQAh5owBBAoACwADAQhmTAAmfIgABAoAAA==.',Ga='Galah:AwAECAkABAoAAA==.Gankahn:AwAHCBAABAoAAA==.',Gh='Ghostsaber:AwAECAoABAoAAA==.',Gi='Giggitygig:AwAECAgABAoAAA==.',Gl='Glennthehen:AwAECAcABAoAAA==.',Go='Goodenia:AwACCAQABAoAAA==.Gorhowl:AwAFCA4ABAoAAA==.',Gr='Grantuss:AwAGCAkABAoAAA==.Gravox:AwAECAkABAoAAA==.',['G�']='Gérált:AwAHCBEABAoAAA==.Gürgän:AwAECAIABAoAAA==.',Ha='Hadestotem:AwAFCAkABAoAAA==.Harex:AwABCAEABAoAAQMAAAAGCAwABAo=.',Ho='Hoho:AwAECAYABAoAAA==.Hollowvoice:AwAGCAoABAoAAA==.Holyviixen:AwABCAEABRQAAA==.',Hu='Huntér:AwAICBgABAoCAgAIAQibGwBRmHkCBAoAAgAIAQibGwBRmHkCBAoAAA==.',Ic='Icepyro:AwADCAQABAoAAA==.',In='Inarius:AwAECAoABAoAAA==.',Ir='Irma:AwAECAMABAoAAA==.',Is='Istal:AwAICAgABAoAAA==.',It='Itanknuspank:AwAGCAwABAoAAA==.',Ja='Jackiexx:AwADCAQABAoAAA==.Jaelen:AwAFCAQABAoAAA==.Jarian:AwABCAEABAoAAA==.',Jh='Jhrel:AwEBCAEABAoAAA==.',Jj='Jjsøn:AwADCAEABAoAAA==.',Ju='Juun:AwADCAQABAoAAA==.',Ka='Kariko:AwADCAMABAoAAA==.Karno:AwAECAUABAoAAA==.Katora:AwAFCAoABAoAAA==.',Kh='Kharii:AwADCAcABRQCDAADAQieBABECAABBRQADAADAQieBABECAABBRQAAA==.',Ko='Kogger:AwADCAIABAoAAA==.',Kr='Krinksroozu:AwACCAIABAoAAA==.Krugg:AwACCAQABAoAAA==.',Ku='Kungpao:AwABCAEABAoAAA==.Kusei:AwADCAQABAoAAA==.',Le='Legs:AwADCAQABRQCDQAIAQg0AQBZPB0DBAoADQAIAQg0AQBZPB0DBAoAAA==.',Li='Linarisa:AwAECAMABAoAAA==.Liquidate:AwAGCAYABAoAAA==.',Lo='Loa:AwADCAcABAoAAA==.Lon:AwADCAMABAoAAA==.Longicorn:AwAFCAMABAoAAA==.Lookatmoi:AwAGCBMABAoAAA==.Loryn:AwAFCBAABAoAAA==.',Lu='Lumbajack:AwAECAcABAoAAA==.',Ly='Lytemup:AwAECAUABAoAAA==.',['L�']='Lùo:AwABCAEABRQAAA==.',Ma='Maigoinu:AwAFCAQABAoAAA==.Majinbuu:AwAECAcABAoAAA==.Malfestio:AwAGCAwABAoAAA==.Mandelorian:AwACCAQABAoAAA==.',Me='Mellowbee:AwADCAQABAoAAA==.Mercior:AwABCAEABAoAAA==.',Mi='Mihawrd:AwABCAEABAoAAA==.Milksalve:AwAGCAUABAoAAA==.Mistakoji:AwABCAEABRQAAA==.',Mo='Moiny:AwAECAYABAoAAA==.Monsterhuntr:AwACCAIABAoAAA==.Mortedela:AwAECAYABAoAAQMAAAAGCAYABAo=.',Mu='Muted:AwACCAQABAoAAA==.Muz:AwABCAIABRQAAA==.Muzc:AwAICAwABAoAAA==.',My='Mythbriyon:AwAICBYABAoCDgAIAQg0AQBXzSsDBAoADgAIAQg0AQBXzSsDBAoAAA==.',Na='Naalaxii:AwAECAUABAoAAA==.Natrstorm:AwADCAYABAoAAA==.Natured:AwAFCAgABAoAAA==.Naturised:AwAECAgABAoAAA==.Nawe:AwADCAIABAoAAA==.',Ne='Nemmystrata:AwADCAQABAoAAA==.Neprion:AwAECAkABAoAAA==.Neroscape:AwAICAgABAoAAA==.Neviiremyx:AwAFCAcABAoAAA==.',Ni='Nickali:AwAECAMABAoAAA==.Nikweak:AwAFCAwABAoAAA==.',No='Noverra:AwAECAcABAoAAA==.',Oi='Oiboiboi:AwAFCAQABAoAAA==.',Ok='Okazi:AwAECAcABAoAAQMAAAAGCAwABAo=.',Ol='Oldblood:AwADCAUABAoAAA==.',Op='Oph:AwAFCAUABAoAAA==.',Ov='Overu:AwAGCAgABAoAAA==.',Oz='Ozzietree:AwABCAEABRQAAA==.',Pa='Paladeéz:AwABCAEABAoAAA==.Pallyaceman:AwAECAQABAoAAA==.Pandayu:AwADCAIABAoAAA==.Parallaxia:AwAICBYABAoDDwAIAQgwGgBIqxYCBAoADwAHAQgwGgBHuRYCBAoAEAAEAQjLFABCATUBBAoAAA==.',Pe='Perollold:AwAGCA4ABAoAAA==.Petaryzn:AwAHCAcABAoAAA==.',Ph='Phil:AwADCAIABAoAAA==.',Pi='Picklé:AwAGCA4ABAoAAA==.Pinkrock:AwADCAkABAoAAA==.',Po='Podabear:AwABCAEABRQAAA==.Portgaz:AwAFCAwABAoAAA==.',Pu='Putere:AwAECAcABAoAAA==.',['P�']='Pâkerious:AwABCAEABRQAAA==.',Ra='Raekongzilla:AwABCAEABAoAAA==.Raene:AwAFCAcABAoAAA==.Raiigun:AwAGCBAABAoAAA==.Rawrbewbz:AwABCAEABRQCCQAHAQgdCwBffd8CBAoACQAHAQgdCwBffd8CBAoAAA==.Rawrnoobz:AwAECAQABAoAAQkAX30BCAEABRQ=.Raziiel:AwADCAcABAoAAA==.',Re='Redorkulated:AwAGCAsABAoAAA==.Redrock:AwABCAEABAoAAQMAAAADCAkABAo=.Rennala:AwAFCA0ABAoAAA==.Rentherak:AwADCAYABAoAAA==.',Ri='Ridê:AwAECAkABAoAAA==.',Ro='Rodqtpi:AwAHCAMABAoAAREAQYgDCAgABRQ=.Ronrot:AwADCAQABAoAAA==.Roots:AwABCAEABRQCEQAHAQhJFABG7xECBAoAEQAHAQhJFABG7xECBAoAAA==.',['R�']='Rävèn:AwABCAEABAoAAA==.Réason:AwADCAIABAoAAA==.Rípandtear:AwAICAMABAoAAA==.',Sa='Saintnarc:AwACCAEABAoAAA==.Salami:AwAECAcABAoAAA==.Sanguiniüs:AwAECAQABAoAAA==.Sarash:AwAGCAYABAoAAA==.Sarya:AwAFCA0ABAoAAA==.',Sc='Schwiftty:AwAICBEABAoAAA==.Scrubturkey:AwAECAkABAoAAA==.',Se='Seraphym:AwACCAUABAoAAA==.Sevx:AwAGCA0ABAoAAA==.',Sh='Shanksuu:AwAECAcABAoAAA==.Shikarii:AwABCAEABRQAAA==.Shimmyz:AwAECAgABAoAAA==.',Si='Sinamor:AwADCAQABAoAAA==.',Sl='Slashfire:AwADCAYABAoAAA==.',Sn='Sneeds:AwAHCA8ABAoAAA==.',So='Soali:AwAECAQABAoAAA==.Soaringsky:AwABCAIABRQCEgAIAQhYAQBIIHcCBAoAEgAIAQhYAQBIIHcCBAoAAA==.Sophia:AwAECAQABAoAAA==.Sormo:AwABCAEABAoAAA==.',Sp='Specialork:AwAICAgABAoAAA==.Spookies:AwADCAEABAoAAA==.',Sq='Squishybelly:AwAGCA4ABAoAAA==.',St='Steinman:AwAFCAQABAoAAA==.Stormblessed:AwADCAcABAoAAA==.Stumpyzap:AwAGCA8ABAoAAA==.',Su='Surashock:AwAFCAIABAoAAA==.',Sy='Synfal:AwAFCAsABAoAAA==.Syrez:AwADCAMABAoAAA==.Sythence:AwAICB4ABAoCEwAIAQjNCgBP97ACBAoAEwAIAQjNCgBP97ACBAoAAA==.',['S�']='Sårixz:AwAECAUABAoAAA==.Sìrsharmìng:AwAECAUABAoAAA==.',Ta='Taelahar:AwADCAYABAoAAA==.Tangodemon:AwACCAMABAoAAA==.Tangodruid:AwACCAIABAoAAA==.Tangohunter:AwAECAUABAoAAA==.',Te='Teddelz:AwADCAQABAoAAA==.Tempeststorm:AwACCAIABAoAAA==.',Th='Thatdamdruid:AwADCAcABAoAAA==.',To='Tototoro:AwADCAUABAoAAA==.Tovuk:AwAFCAsABAoAAA==.',Tr='Treadmill:AwACCAIABAoAAA==.Triksie:AwABCAEABAoAAQMAAAAECAkABAo=.Trollolol:AwAECAgABAoAAA==.',Ty='Tyranoc:AwAECAUABAoAAA==.Tytherious:AwADCAYABAoAAA==.',Va='Valkyriê:AwABCAIABAoAAA==.Vanillakiss:AwADCAYABAoAAA==.',Ve='Velindris:AwABCAEABRQCFAAHAQhIGwBEYw8CBAoAFAAHAQhIGwBEYw8CBAoAAA==.Vellarya:AwAECAgABAoAAA==.Velphian:AwAGCAMABAoAAA==.',Vy='Vyxenn:AwABCAEABRQCDAAHAQgyEQBCDCECBAoADAAHAQgyEQBCDCECBAoAAA==.',We='Westlock:AwADCAIABAoAAA==.',Wi='Wiiman:AwAFCAUABAoAAA==.',Wo='Wobblock:AwAFCA8ABAoAAA==.',Xe='Xerolife:AwAGCAIABAoAAA==.',Xf='Xforce:AwAICBgABAoDCwAIAQjyEAA4jBoCBAoACwAIAQjyEAA4jBoCBAoADAACAQikPAAZ53gABAoAAA==.',['X�']='Xïao:AwABCAEABAoAAQMAAAAECAsABAo=.',Za='Zaarock:AwAICAYABAoAAA==.Zandro:AwAGCA4ABAoAAA==.Zanduill:AwABCAEABRQAAA==.Zaraçk:AwAGCA4ABAoAAA==.',Ze='Zealform:AwAECAgABAoAAA==.Zeflashtrash:AwAFCAQABAoAAA==.',Zi='Zindroz:AwADCAQABAoAAA==.',Zo='Zojah:AwAFCAYABAoAAA==.',Zu='Zugtoe:AwAICAgABAoAAA==.',Zy='Zykaei:AwABCAEABRQCEQAHAQhmBwBeLdICBAoAEQAHAQhmBwBeLdICBAoAAA==.Zyl:AwACCAMABAoAAA==.',Zz='Zzeldris:AwAFCBAABAoAAA==.',['Z�']='Zârack:AwACCAIABAoAAQMAAAAGCA4ABAo=.Zãráck:AwAECAYABAoAAQMAAAAGCA4ABAo=.',['Ç']='Çomplexity:AwACCAMABAoAAA==.',['Í']='Ígnís:AwAGCA0ABAoAAA==.',['Ð']='Ðeez:AwACCAIABAoAAA==.',['Ñ']='Ñx:AwABCAEABAoAAQMAAAACCAIABAo=.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end