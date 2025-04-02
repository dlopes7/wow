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
 local lookup = {'Paladin-Holy','Shaman-Enhancement','Unknown-Unknown','Hunter-BeastMastery','Mage-Fire','DeathKnight-Blood','Paladin-Retribution','Evoker-Devastation','DeathKnight-Frost','Hunter-Survival','Rogue-Assassination','Rogue-Subtlety','Rogue-Outlaw','Warrior-Fury','Warrior-Protection','Warrior-Arms','Paladin-Protection','Shaman-Restoration','DemonHunter-Vengeance','Hunter-Marksmanship','Shaman-Elemental',}; local provider = {region='US',realm='Saurfang',name='US',type='weekly',zone=42,date='2025-03-28',data={Ac='Accursedbro:AwADCAEABAoAAA==.',Ae='Aedaris:AwAICBAABAoAAA==.',Ag='Agorax:AwACCAEABAoAAA==.',Ai='Aimei:AwAFCA4ABAoAAA==.Aionxz:AwAGCAwABAoAAA==.Aiphaton:AwAECAgABAoAAA==.',Ak='Akolar:AwAGCBgABAoCAQAGAQh6EgA1Sn0BBAoAAQAGAQh6EgA1Sn0BBAoAAA==.',Al='Aliorn:AwAFCAcABAoAAA==.Allenax:AwAFCAsABAoAAA==.Alponyoman:AwAHCBQABAoCAgAHAQiKDABO9XMCBAoAAgAHAQiKDABO9XMCBAoAAA==.',An='Antiuwu:AwAFCAgABAoAAA==.',Ar='Araelora:AwABCAEABAoAAA==.Ares:AwABCAEABRQAAA==.Arkwelth:AwADCAUABAoAAA==.Artimicia:AwADCAUABAoAAA==.',As='Ashanath:AwAHCAYABAoAAA==.Assamlaksa:AwABCAEABAoAAQMAAAAECA0ABAo=.',Av='Avie:AwAHCAkABAoAAA==.',Az='Azraezel:AwADCAIABAoAAA==.',Ba='Baelrog:AwAFCAcABAoAAA==.Ballshaft:AwAECAYABAoAAA==.Barthom:AwAFCAsABAoAAA==.Baràk:AwAHCBUABAoCBAAHAQgSKgA8AAMCBAoABAAHAQgSKgA8AAMCBAoAAA==.',Be='Bearsbicdk:AwAFCAsABAoAAA==.Beatrix:AwAGCAcABAoAAA==.Beerington:AwAGCA8ABAoAAA==.Bewmm:AwAGCAwABAoAAA==.',Bi='Bigoltrollop:AwADCAUABAoAAA==.Bizz:AwAFCAwABAoAAA==.',Bl='Blazebringer:AwADCAQABAoAAA==.Bllissterine:AwADCAMABAoAAQMAAAADCAUABAo=.Bllissticks:AwADCAUABAoAAA==.',Bo='Bogan:AwADCAQABAoAAA==.',Br='Bradsie:AwACCAQABAoAAA==.Brewtalîty:AwACCAIABAoAAA==.Brosamdi:AwAHCBAABAoAAA==.Brush:AwAECAUABAoAAA==.',Bu='Burnt:AwABCAEABAoAAA==.',Bw='Bwthybl:AwACCAIABAoAAA==.',Ca='Cannedfox:AwAGCAwABAoAAA==.',Ce='Celendra:AwAFCAkABAoAAA==.Celtic:AwAGCBAABAoAAQEAOjQBCAIABRQ=.',Ch='Challisa:AwADCAIABAoAAA==.Charnaby:AwAFCA0ABAoAAA==.Cherriio:AwAGCAoABAoAAA==.Chipcookie:AwADCAcABAoAAA==.',Cl='Clarc:AwAECAEABAoAAQMAAAAGCAoABAo=.',Co='Corte:AwAECAQABAoAAA==.',Cr='Crazedorc:AwAHCBMABAoAAA==.Croescold:AwAECA0ABAoAAA==.',Cu='Currylembu:AwAGCAYABAoAAA==.',Da='Damisia:AwAGCA8ABAoAAA==.Daylisha:AwAFCAIABAoAAA==.Dazzles:AwAFCAgABAoAAA==.Daïsy:AwADCAUABAoAAA==.',De='Deadvirgin:AwADCAMABAoAAA==.Deaux:AwAGCAYABAoAAA==.Deciphel:AwACCAMABAoAAA==.Dephara:AwADCAEABAoAAA==.Dessane:AwADCAcABAoAAA==.Deviantall:AwAFCAkABAoAAA==.',Dh='Dhp:AwAGCAwABAoAAA==.',Di='Diora:AwAGCBEABAoAAA==.Diéthyl:AwABCAEABAoAAA==.',Do='Don:AwABCAEABAoAAA==.Dora:AwADCAUABAoAAA==.',Dr='Dracule:AwADCAIABAoAAA==.Dracyoda:AwAGCA4ABAoAAA==.Dragöndeez:AwADCAEABAoAAA==.Draiia:AwAGCBIABAoAAA==.Draiky:AwAGCAwABAoAAA==.Drakana:AwAECAcABAoAAA==.Dropkick:AwABCAEABRQAAA==.Drunkrilius:AwACCAIABAoAAQUASXgICBYABAo=.Druïd:AwAGCAIABAoAAA==.',Dy='Dylem:AwAGCAUABAoAAA==.',El='Elundara:AwAGCBgABAoCBgAGAQj+FQA5WH0BBAoABgAGAQj+FQA5WH0BBAoAAA==.Elïra:AwADCAUABAoAAA==.',En='Entmoot:AwAFCAwABAoAAA==.',Es='Estardra:AwAGCAUABAoAAA==.',Ev='Eviely:AwADCAgABAoAAA==.Evilnattie:AwAGCAwABAoAAA==.',Fa='Fannychmela:AwACCAIABAoAAA==.Faright:AwABCAEABRQAAA==.',Fe='Feistyfist:AwADCAUABAoAAA==.Feleron:AwAHCBUABAoCBwAHAQhAPwA2jOABBAoABwAHAQhAPwA2jOABBAoAAA==.Fengliu:AwAECAYABAoAAA==.',Fi='Fiyerite:AwADCAcABRQCCAADAQioBAAyLukABRQACAADAQioBAAyLukABRQAAA==.',Fo='Forcain:AwAGCBAABAoAAA==.Forkinglock:AwABCAEABAoAAA==.',Fr='Freshdemon:AwAICAgABAoAAA==.Frolysra:AwAECAYABAoAAA==.',Fu='Furfist:AwAHCBMABAoAAA==.Fuzzyballs:AwAFCAQABAoAAA==.',['F�']='Fätboy:AwAECA4ABAoAAA==.Fúzzlë:AwADCAUABAoAAA==.',Ga='Gamumush:AwAGCBYABAoCBwAGAQj0IABdYm4CBAoABwAGAQj0IABdYm4CBAoAAA==.',Ge='Generico:AwAHCBgABAoCBwAHAQhyMABMXh4CBAoABwAHAQhyMABMXh4CBAoAAA==.',Gl='Glaiviture:AwABCAEABAoAAA==.',Go='Gotno:AwABCAEABRQAAQIAV8cCCAMABRQ=.Gotsalt:AwACCAQABAoAAA==.',Gr='Grievöüs:AwAGCBAABAoAAA==.Grindblast:AwADCAMABAoAAA==.Grindfrost:AwAECAQABAoAAA==.',['G�']='Gødslapp:AwADCAUABAoAAA==.',Ha='Haxxor:AwADCAEABAoAAA==.',He='Hellfist:AwAECAQABAoAAA==.',Ho='Hotdiscordgf:AwAGCAYABAoAAA==.',Hu='Huntsketchup:AwADCAQABAoAAA==.Huntssy:AwAGCBAABAoAAA==.',Hy='Hypersleep:AwADCAcABAoAAA==.',['H�']='Hàuntress:AwADCAEABAoAAA==.Hötnhòrdey:AwAFCBAABAoAAA==.',In='Iny:AwAFCA0ABAoAAA==.',Ir='Ironmage:AwACCAUABAoAAQMAAAAGCAYABAo=.',Ja='Jacksmash:AwABCAEABAoAAQMAAAAHCAkABAo=.Jaganoto:AwACCAIABAoAAA==.Jaiyn:AwADCAMABAoAAA==.Jakoo:AwACCAMABRQCAgAIAQiMBABXxwsDBAoAAgAIAQiMBABXxwsDBAoAAA==.Jalarin:AwACCAIABAoAAQMAAAADCAUABAo=.Jamitydh:AwEECAgABAoAAA==.Jasireth:AwACCAMABRQCCQAIAQgtAwBOV7MCBAoACQAIAQgtAwBOV7MCBAoAAA==.Jasonbjörn:AwABCAEABAoAAQgAKUkICBYABAo=.Jazoo:AwAFCAsABAoAAA==.',Je='Jedwarus:AwABCAEABAoAAA==.Jelia:AwAECAYABAoAAA==.Jelvocado:AwAGCBIABAoAAA==.Jenak:AwAFCAgABAoAAA==.',Jo='Jonkbear:AwAECA0ABAoAAA==.',Ju='Juliet:AwABCAEABAoAAA==.',Ka='Kaeliela:AwAECAYABAoAAA==.Kalculon:AwAFCAQABAoAAA==.Karroah:AwAECAcABAoAAA==.Katiyana:AwADCAQABAoAAA==.Katodeedodo:AwABCAEABAoAAA==.',Ke='Keksiq:AwAFCAsABAoAAA==.',Kh='Khursheed:AwAFCAkABAoAAA==.',Ki='Kiadiasundon:AwADCAEABAoAAA==.Kikoman:AwAGCA0ABAoAAA==.Killjòy:AwAECAgABAoAAA==.Kinesra:AwAGCAwABAoAAA==.Kittypounder:AwABCAIABRQAAA==.',Kn='Kngleonidas:AwADCAEABAoAAA==.',Kr='Kratoze:AwAFCAsABAoAAA==.Krý:AwAFCA0ABAoAAA==.',Ku='Kushie:AwAFCAIABAoAAA==.',['K�']='Kál:AwAFCAIABAoAAA==.',La='Lancaran:AwADCAEABAoAAA==.',Le='Leonorran:AwAFCA8ABAoAAA==.',Li='Lissuin:AwAFCAwABAoAAA==.Litefury:AwAHCBYABAoCBwAHAQhBJgBMT1ACBAoABwAHAQhBJgBMT1ACBAoAAA==.',Lo='Loganja:AwADCAEABAoAAA==.Lokmar:AwAHCA8ABAoAAA==.Lollobionda:AwADCAMABAoAAA==.Loono:AwAFCAMABAoAAA==.Lorculé:AwAGCAwABAoAAA==.',Lu='Lucintaluna:AwAECAQABAoAAA==.Lulingqï:AwADCAEABAoAAA==.Luminei:AwAGCAYABAoAAA==.Lutz:AwADCAUABAoAAA==.',Ly='Lythorn:AwAECAQABAoAAA==.Lythrak:AwACCAIABAoAAA==.',Ma='Mackyla:AwADCAMABAoAAQMAAAAGCAwABAo=.Magbun:AwAFCAwABAoAAA==.Mages:AwABCAMABAoAAA==.Magicvall:AwAICAcABAoAAA==.Mailou:AwAHCBAABAoAAA==.Mamasboi:AwADCAUABAoAAA==.Mantova:AwAFCAoABAoAAA==.Mattank:AwAHCA0ABAoAAA==.Matthxw:AwAECAUABAoAAA==.',Mi='Miikoo:AwAFCAEABAoAAA==.Mikotö:AwAGCBAABAoAAA==.Milkymaid:AwAFCAMABAoAAA==.',Mo='Monkguru:AwAECAQABAoAAA==.Mouldydoodle:AwABCAEABAoAAA==.',Mu='Mudduck:AwAFCAEABAoAAA==.',My='Mymistyboo:AwACCAQABAoAAA==.',['M�']='Mòònshine:AwADCAUABAoAAA==.',Na='Nailahpriest:AwACCAIABAoAAA==.',Ne='Nettý:AwADCAMABAoAAA==.',Ni='Nialdo:AwAFCAwABAoAAA==.Nightshift:AwACCAIABAoAAA==.Nisefayth:AwABCAEABAoAAA==.',No='Noiz:AwACCAEABAoAAA==.Noremac:AwADCAIABAoAAA==.Northmand:AwAGCBgABAoDBAAGAQg9MwA+tskBBAoABAAGAQg9MwA+tskBBAoACgACAQifDgAouWQABAoAAA==.',Nu='Nunueggplant:AwAECAEABAoAAA==.',['N�']='Nøkken:AwACCAIABAoAAA==.Nÿm:AwABCAEABAoAAA==.',Ob='Obake:AwADCAUABAoAAA==.Obsoleet:AwAGCA8ABAoAAA==.',Od='Oddmonk:AwACCAIABAoAAA==.',Ol='Olddrekky:AwAFCBAABAoAAA==.',On='Onikage:AwAGCBkABAoECwAGAQh5BgBgcX8CBAoACwAGAQh5BgBgcX8CBAoADAACAQg4KQAnoGgABAoADQABAQi4CwBJpVIABAoAAA==.',Op='Opfotmjr:AwACCAEABAoAAA==.Opreich:AwAFCAoABAoAAA==.',Or='Orisi:AwAGCA8ABAoAAA==.Orthalz:AwAGCAwABAoAAA==.',Ox='Oxilock:AwADCAIABAoAAQMAAAAGCA4ABAo=.Oxipriest:AwAGCA4ABAoAAA==.',Pa='Pallyative:AwABCAIABAoAAA==.Pandjob:AwADCAQABAoAAA==.Para:AwABCAIABRQAAA==.Pavlovaa:AwACCAIABAoAAA==.',Pe='Peepeedemon:AwAFCAkABAoAAA==.',Pi='Pilsam:AwADCAUABAoAAA==.',Pl='Plutoowarlok:AwAECAUABAoAAA==.',Pr='Prayschool:AwADCAUABAoAAA==.Predatoy:AwAFCA4ABAoAAA==.Primàl:AwACCAEABAoAAA==.Priscus:AwAGCAgABAoAAA==.',Ra='Ragnäêr:AwABCAEABAoAAA==.Ragonar:AwADCAUABAoAAA==.Ranfin:AwAFCAsABAoAAA==.Rawrpaw:AwAFCAsABAoAAA==.Razukar:AwACCAIABAoAAA==.Razzles:AwACCAIABAoAAA==.',Re='Redpal:AwADCAMABAoAAA==.Reeshar:AwACCAIABAoAAA==.Rexomonk:AwADCAMABAoAAA==.',Ri='Rina:AwAECAcABAoAAA==.Rissla:AwADCAcABAoAAA==.',Ro='Rogiia:AwAECAYABAoAAQMAAAAGCBIABAo=.',Ru='Rumblybear:AwAFCA4ABAoAAA==.Ruthia:AwAGCBAABAoAAA==.',['R�']='Ràndomhero:AwAFCBYABAoEDgAFAQgROgAcYwMBBAoADgAFAQgROgAXjAMBBAoADwAEAQigGgAXR4AABAoAEAABAQjfRQAGahAABAoAAA==.',Sa='Salomone:AwAGCBgABAoDEQAGAQi9GQAsswcBBAoABwAFAQi+dwAzSCEBBAoAEQAGAQi9GQAfywcBBAoAAA==.Samonki:AwABCAIABRQAAA==.',Sc='Schnome:AwAFCAcABAoAAA==.Scratchies:AwAECAQABAoAAQMAAAAGCBMABAo=.Scrêwêdûp:AwADCAMABAoAAA==.Scyler:AwAECAsABAoAAA==.',Sg='Sgtnovna:AwABCAEABAoAAA==.Sgtsquat:AwABCAIABRQAAA==.',Sh='Shadyy:AwAHCBcABAoCBAAHAQh5DABfU/cCBAoABAAHAQh5DABfU/cCBAoAAA==.Shaetore:AwAGCBAABAoAAA==.Shankzp:AwAICAgABAoAAA==.Shankzr:AwAICB4ABAoCDAAIAQi0BgBKl64CBAoADAAIAQi0BgBKl64CBAoAAA==.Sharmtor:AwAGCBgABAoCEgAGAQhfFQBSxBQCBAoAEgAGAQhfFQBSxBQCBAoAAA==.Shha:AwAHCBYABAoCEwAHAQjvDAA9hdkBBAoAEwAHAQjvDAA9hdkBBAoAAA==.Shhapally:AwAGCBMABAoAARMAPYUHCBYABAo=.Shiné:AwAFCAYABAoAAA==.',Si='Silverbird:AwADCAEABAoAAA==.Simpvoker:AwAFCA0ABAoAAA==.Sixxpal:AwABCAEABAoAAQMAAAAGCA8ABAo=.',Sk='Skest:AwABCAEABRQAAA==.Skragrott:AwAHCAYABAoAAA==.Skybomb:AwAGCBgABAoCFAAGAQiYEgBFlLABBAoAFAAGAQiYEgBFlLABBAoAAA==.',Sl='Slavryx:AwAICAgABAoAAA==.Sliq:AwADCAYABAoAAA==.',Sm='Smegiest:AwAICAsABAoAAA==.',Sn='Snarfèy:AwAGCBAABAoAAA==.Sneakypuss:AwADCAEABAoAAQMAAAAGCAYABAo=.Sneapk:AwABCAEABRQAAA==.',So='Soggyerv:AwABCAIABRQDFQAIAQhBDwBEGTMCBAoAFQAHAQhBDwBFozMCBAoAEgAGAQgNQAASzwEBBAoAAA==.',Sp='Speeddevil:AwAECAMABAoAAA==.',Ss='Sshaady:AwAGCBMABAoAAQQAX1MHCBcABAo=.',St='Stalactite:AwAFCAIABAoAAA==.',Su='Sudowoodo:AwAFCAMABAoAAA==.Suff:AwAGCAkABAoAAA==.Superevan:AwADCAUABRQCBAADAQjgCgAokMgABRQABAADAQjgCgAokMgABRQAAA==.Superhanz:AwAECAcABAoAAA==.',Sw='Swalala:AwAHCAYABAoAAA==.',['S�']='Sãmael:AwAHCBUABAoCEwAHAQhyDQBALs8BBAoAEwAHAQhyDQBALs8BBAoAAA==.',Ta='Tanwamagi:AwAHCBAABAoAAA==.',Te='Tena:AwADCAUABAoAAA==.Tenarri:AwAECAUABAoAAA==.Teranzil:AwAGCA8ABAoAAA==.',Th='Thegord:AwACCAIABAoAAA==.Thuxis:AwAGCBYABAoCBwAGAQj2UQA1CZgBBAoABwAGAQj2UQA1CZgBBAoAAA==.',Ti='Tiptup:AwADCAIABAoAAA==.',Tr='Trenchfoot:AwAECAYABAoAAA==.Trippen:AwAHCAYABAoAAA==.Trycondus:AwAECAoABAoAAA==.',Tu='Tulatros:AwAGCA8ABAoAAA==.',Ur='Ursocs:AwAFCAIABAoAAA==.',Va='Vall:AwAHCBYABAoCEwAHAQh0CABO0DwCBAoAEwAHAQh0CABO0DwCBAoAAA==.',Ve='Veenus:AwAFCAwABAoAAA==.Veinyfists:AwAECAIABAoAAA==.Verakki:AwABCAIABRQAAA==.',Vi='Vindicator:AwACCAYABAoAAA==.',Wa='Warrvx:AwADCAMABAoAAA==.Warside:AwADCAMABAoAAQMAAAABCAEABRQ=.Waterslushy:AwABCAIABAoAAQMAAAAGCAwABAo=.',We='Well:AwAICAoABAoAAA==.',Wo='Wongghole:AwAICAYABAoAAA==.',Wr='Wrongkey:AwAECAgABAoAAA==.',Ws='Wsz:AwABCAEABAoAAA==.',Xa='Xannar:AwAGCA0ABAoAAA==.Xarmina:AwABCAEABRQAAA==.',Ye='Yeah:AwAHCA0ABAoAAA==.',Yk='Yk:AwADCAcABAoAAA==.',Yo='Youkette:AwAGCAwABAoAAA==.',Yu='Yuja:AwAECA4ABAoAAA==.',Za='Zaljan:AwADCAgABRQCEgADAQgyAwBFyQIBBRQAEgADAQgyAwBFyQIBBRQAAA==.Zayato:AwAGCBgABAoDBAAGAQhhKABN/RACBAoABAAGAQhhKABN/RACBAoACgACAQhlDgBH6GgABAoAAA==.',Zo='Zohno:AwACCAIABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end