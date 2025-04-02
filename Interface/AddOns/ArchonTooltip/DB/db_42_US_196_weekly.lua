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
 local lookup = {'Priest-Holy','Priest-Discipline','Shaman-Restoration','Paladin-Retribution','Unknown-Unknown','DeathKnight-Unholy','Warrior-Fury','DemonHunter-Havoc','Paladin-Holy','Druid-Restoration','Hunter-BeastMastery','Warlock-Destruction','Warlock-Affliction',}; local provider = {region='US',realm='Silvermoon',name='US',type='weekly',zone=42,date='2025-03-28',data={Ab='Absolutnova:AwAECAoABAoAAA==.',Ad='Adelma:AwAFCAcABAoAAA==.Adelyne:AwAGCBkABAoCAQAGAQgSFgBDOtkBBAoAAQAGAQgSFgBDOtkBBAoAAA==.',Ae='Aelioran:AwAFCAkABAoAAA==.Aeroice:AwABCAIABRQCAgAIAQgfAwBVbQoDBAoAAgAIAQgfAwBVbQoDBAoAAA==.',Ai='Aideb:AwABCAEABRQCAgAHAQgqIQAWRzYBBAoAAgAHAQgqIQAWRzYBBAoAAQMAEboDCAYABRQ=.',Aj='Ajax:AwABCAIABRQCBAAIAQhYHQBNDYMCBAoABAAIAQhYHQBNDYMCBAoAAA==.',Al='Alidormi:AwAFCBEABAoAAA==.Alphasoldier:AwAHCBUABAoCBAAHAQioEABf0+ECBAoABAAHAQioEABf0+ECBAoAAA==.Altia:AwAHCBIABAoAAA==.Aluraye:AwAICBAABAoAAA==.',Am='Amhela:AwAFCAkABAoAAA==.',An='Anaraellea:AwADCAEABAoAAA==.Anasaria:AwAECAQABAoAAA==.Anowon:AwADCAEABAoAAA==.',Ar='Arenar:AwAHCBEABAoAAA==.Arkelium:AwAECAIABAoAAA==.Aronau:AwACCAMABAoAAA==.',As='Astarriassa:AwADCAMABAoAAA==.',Au='Aureluna:AwABCAEABAoAAA==.',Az='Azaezel:AwAHCBIABAoAAA==.',Ba='Babychewie:AwADCAgABAoAAA==.Balla:AwAECAIABAoAAA==.Bangbusdrver:AwAFCAEABAoAAA==.',Be='Beardeman:AwADCAEABAoAAA==.Beaross:AwAFCAoABAoAAQUAAAAHCAoABAo=.Beefshock:AwADCAEABAoAAA==.Berarrek:AwADCAgABAoAAA==.Berniemadoff:AwAHCBMABAoAAA==.',Bl='Blakkadin:AwAICBAABAoAAQUAAAABCAEABRQ=.Bluex:AwAHCBEABAoAAA==.',Bo='Booyaah:AwACCAIABRQCAwAIAQjoAQBfTTsDBAoAAwAIAQjoAQBfTTsDBAoAAA==.',Br='Braviel:AwADCAEABAoAAA==.Breakinrocks:AwADCAMABAoAAQUAAAAHCBIABAo=.Brigadester:AwAGCA0ABAoAAA==.',Bu='Budwiser:AwACCAIABAoAAA==.',Ca='Cadaverific:AwACCAEABAoAAA==.Cassawings:AwABCAEABAoAAQUAAAADCAcABAo=.',Ch='Cheerio:AwABCAIABRQAAA==.Chàotic:AwAHCA8ABAoAAA==.Cháncellor:AwACCAIABAoAAA==.',Cl='Clockwork:AwAHCA4ABAoAAA==.',Co='Coreion:AwACCAUABAoAAA==.Corraline:AwACCAQABAoAAA==.Cowabungha:AwABCAEABAoAAA==.',Cr='Creamyjeans:AwAECAQABAoAAA==.',Cy='Cyndea:AwACCAIABAoAAA==.Cyphris:AwAECAQABAoAAA==.',['C�']='Cérnunnos:AwADCAEABAoAAA==.',Da='Daftknight:AwAHCBAABAoAAA==.Dances:AwADCAYABAoAAA==.Dangereus:AwACCAMABAoAAA==.Dannis:AwAFCAUABAoAAA==.Darkbáine:AwADCAMABAoAAA==.Darkisdragon:AwAFCAoABAoAAA==.Darmorg:AwAFCAsABAoAAA==.',De='Deathy:AwAECAcABAoAAQUAAAAGCAYABAo=.Decymel:AwABCAEABRQAAA==.Deegoddaem:AwADCAUABAoAAA==.Delmore:AwAECAUABAoAAQUAAAAFCAQABAo=.Delmoré:AwAFCAQABAoAAA==.Dexe:AwACCAEABAoAAA==.Dezz:AwABCAEABAoAAA==.',Do='Dodgeram:AwADCAEABAoAAA==.Dohr:AwAECAEABAoAAQUAAAAHCBIABAo=.',Dr='Dragonsmight:AwAHCBAABAoAAA==.',Du='Duewryn:AwADCAIABAoAAA==.',El='Elgoblini:AwACCAIABAoAAA==.',Em='Emberdk:AwADCAcABRQCBgADAQg0AgBIoiUBBRQABgADAQg0AgBIoiUBBRQAAA==.',Ep='Ephyla:AwADCAcABAoAAA==.',Es='Essenne:AwABCAEABAoAAQUAAAADCAcABAo=.',Ey='Eyonates:AwAFCAgABAoAAA==.',Fa='Falora:AwADCAcABAoAAA==.',Fe='Fenrirqueens:AwABCAEABAoAAA==.',Fl='Fluphy:AwACCAIABAoAAA==.',Fu='Funneris:AwACCAIABRQAAA==.',Fy='Fyz:AwAECAMABAoAAA==.',Ga='Gadios:AwABCAIABRQAAA==.',Go='Gobfather:AwAHCA8ABAoAAA==.Goharl:AwAGCAYABAoAAA==.Goobr:AwAFCAYABAoAAA==.',Gr='Grenne:AwADCAQABAoAAA==.Grinderrg:AwAGCA8ABAoAAA==.',Gu='Gugg:AwAECAEABAoAAA==.Gum:AwADCAUABAoAAA==.',Gw='Gweb:AwAFCAgABAoAAA==.',Ha='Halidril:AwABCAEABAoAAA==.',He='Hegs:AwAHCBMABAoAAA==.Heizos:AwADCAEABAoAAA==.Helaku:AwABCAEABRQAAA==.Herradura:AwAHCBEABAoAAA==.Hevharuk:AwAFCAkABAoAAA==.Hewk:AwADCAEABAoAAA==.',Hi='Hideaway:AwAFCAcABAoAAA==.',Ho='Holymoo:AwADCAEABAoAAA==.',Hu='Hudsonpally:AwAICAcABAoAAA==.',Id='Idarknessl:AwABCAIABRQAAA==.',Il='Iluvantar:AwADCAMABAoAAA==.',In='Intet:AwADCAUABAoAAA==.Intricate:AwAICA8ABAoAAA==.',Ip='Ipa:AwAICAgABAoAAA==.',Ir='Ireliae:AwAECAQABAoAAA==.',Is='Isindril:AwAHCBEABAoAAA==.Isnacky:AwABCAEABAoAAA==.',Ix='Ixidor:AwAHCAYABAoAAA==.',Iy='Iynch:AwAHCBEABAoAAA==.',Ja='Jadianrogue:AwABCAEABRQAAA==.',Je='Jenntly:AwAECAQABAoAAA==.',Ji='Jigi:AwABCAIABAoAAA==.Jirasia:AwAHCBMABAoAAA==.',Jo='Joduku:AwADCAYABAoAAA==.Joedamonk:AwADCAUABAoAAA==.Jordo:AwAICBAABAoAAA==.Joystick:AwAICAgABAoAAA==.',Ka='Kaelluth:AwACCAQABAoAAA==.Kageriyu:AwABCAIABRQCBwAIAQhDCgBRmr4CBAoABwAIAQhDCgBRmr4CBAoAAA==.Karanitoo:AwAICBEABAoAAA==.Kaybin:AwADCAEABAoAAQUAAAAECAYABAo=.Kayla:AwAFCAYABAoAAA==.Kazadux:AwABCAEABAoAAA==.',Ke='Keatøn:AwADCAQABAoAAA==.Keefjerky:AwABCAEABAoAAQUAAAAECAgABAo=.Kelethius:AwAHCBEABAoAAA==.Kesthus:AwAHCBQABAoCCAAHAQh+GgBC3kECBAoACAAHAQh+GgBC3kECBAoAAA==.',Ki='Killercrane:AwABCAEABAoAAA==.',Kl='Klozrevenge:AwADCAMABAoAAA==.',Le='Leesylock:AwAFCAcABAoAAA==.',Li='Lightwolves:AwAICBcABAoDBAAIAQhhAQBhuYIDBAoABAAIAQhhAQBhuYIDBAoACQACAQhQKwAJtWAABAoAAA==.Linaelia:AwACCAEABAoAAA==.',Lo='Lockli:AwACCAIABAoAAA==.Lockrhen:AwAFCAIABAoAAA==.Lovelydeäth:AwAHCBEABAoAAA==.',Lu='Luceid:AwAHCBEABAoAAA==.',['L�']='Léf:AwAFCAkABAoAAA==.',Ma='Madilyn:AwADCAUABAoAAA==.Magestika:AwAGCAkABAoAAA==.Maiderftw:AwABCAEABAoAAA==.Mamamaya:AwAFCAYABAoAAA==.Marbae:AwAICA8ABAoAAA==.Mavralara:AwADCAEABAoAAA==.Maxious:AwAHCAwABAoAAA==.Mazdameowta:AwAHCBEABAoAAA==.',Mc='Mclight:AwADCAMABAoAAA==.Mclyte:AwABCAIABRQAAA==.',Me='Meinfrau:AwAHCBAABAoAAA==.Methia:AwADCAEABAoAAQUAAAAGCAMABAo=.',Mi='Mikuna:AwAFCAgABAoAAA==.Miranai:AwAGCAMABAoAAA==.',Mo='Mojowest:AwAFCAkABAoAAA==.Monskaar:AwAICA8ABAoAAA==.Moong:AwAFCAMABAoAAA==.Moonlitgrove:AwABCAEABAoAAA==.Morphyne:AwAGCAIABAoAAA==.',Mu='Mustybones:AwAECAgABAoAAA==.Mustärd:AwAHCBEABAoAAA==.',My='Myree:AwAGCAYABAoAAA==.Myrir:AwADCAcABAoAAA==.',['M�']='Månevrede:AwAICAgABAoAAA==.',Na='Naks:AwAICBAABAoAAA==.Nashwa:AwAICAgABAoAAA==.Nastiee:AwABCAEABRQCCgAIAQgVFQAvVL0BBAoACgAIAQgVFQAvVL0BBAoAAA==.',Nh='Nhelv:AwAFCAgABAoAAA==.',Ni='Niame:AwACCAIABAoAAA==.Ninjakitten:AwAFCAYABAoAAA==.',Oa='Oashian:AwAFCAkABAoAAA==.',Od='Odonts:AwAICAgABAoAAA==.',On='Onoodles:AwACCAIABAoAAA==.',Or='Orrindan:AwAFCBAABAoAAA==.',Ox='Oxblade:AwAICAMABAoAAA==.',Pa='Paladinæres:AwAGCAwABAoAAA==.Pallieguy:AwAFCAYABAoAAA==.Pantteri:AwABCAEABAoAAA==.',Pe='Penetrate:AwABCAEABAoAAA==.Persëphöne:AwAGCA0ABAoAAA==.Pezzixx:AwABCAEABAoAAA==.',Ph='Phett:AwAFCAoABAoAAA==.',Pi='Pikkin:AwADCAEABAoAAA==.',Po='Ponzie:AwAFCAYABAoAAA==.Postmortim:AwADCAEABAoAAA==.Potaters:AwADCAEABAoAAA==.',Pr='Prokk:AwABCAEABAoAAA==.Proxy:AwAFCAMABAoAAA==.',Pu='Pu:AwADCAEABAoAAA==.',['P�']='Póe:AwAECAcABAoAAA==.',Qc='Qchlan:AwABCAIABAoAAQUAAAAFCAwABAo=.',Qi='Qiteag:AwADCAMABAoAAQUAAAAFCAwABAo=.',Ra='Radulov:AwAFCAYABAoAAA==.Raithlyn:AwADCAEABAoAAA==.Rambles:AwADCAMABAoAAA==.Rambling:AwAFCAMABAoAAA==.Rastashara:AwAFCAkABAoAAA==.Rawrm:AwAFCAYABAoAAA==.Raynàre:AwAGCAYABAoAAA==.',Re='Rellana:AwAFCAQABAoAAA==.Remidee:AwABCAEABAoAAA==.',Sa='Sarkøth:AwADCAMABAoAAA==.Saushie:AwABCAEABAoAAA==.Savagedoodle:AwAGCAsABAoAAA==.',Se='Seidhra:AwAFCAMABAoAAA==.Seyton:AwADCAMABAoAAA==.',Sg='Sgtdoom:AwADCAEABAoAAA==.',Si='Sifusplitter:AwAFCAMABAoAAA==.Sixinchdeep:AwABCAIABRQAAA==.',Sk='Skullduckery:AwAHCBAABAoAAA==.',Sm='Smokechedda:AwAFCAkABAoAAA==.Smoothlizzy:AwAHCBEABAoAAA==.',So='Sodem:AwAFCAkABAoAAA==.Song:AwACCAIABAoAAA==.',Sp='Spellbraker:AwAHCBEABAoAAA==.',St='Starburstz:AwADCAUABAoAAA==.Starknight:AwADCAcABRQCBAADAQgwBwAxqfQABRQABAADAQgwBwAxqfQABRQAAA==.Stiorra:AwACCAIABAoAAA==.',Su='Suppadh:AwAGCAYABAoAAA==.',Sw='Swagnasty:AwAFCAkABAoAAA==.',Ta='Taeyn:AwABCAEABAoAAQUAAAADCAcABAo=.Takalion:AwACCAMABAoAAA==.',Te='Tediousjag:AwADCAMABAoAAA==.Temorone:AwABCAEABAoAAA==.Teninchdeep:AwACCAIABAoAAA==.Teross:AwAHCAoABAoAAA==.Terrorblades:AwADCAYABAoAAQUAAAAHCBEABAo=.',Th='Theßrush:AwAECAQABAoAAA==.Thornlox:AwAFCAYABAoAAA==.',Ti='Tieuni:AwACCAYABAoAAA==.Tiktikmage:AwADCAoABAoAAA==.',Tr='Treeforce:AwABCAEABAoAAA==.Tríxie:AwABCAEABAoAAA==.',Ul='Ulthane:AwABCAEABAoAAA==.',Va='Valantria:AwAHCBQABAoCBgAHAQj6BABi8REDBAoABgAHAQj6BABi8REDBAoAAA==.Valie:AwADCAQABAoAAA==.Vanishingson:AwAFCAkABAoAAA==.',Ve='Verelidaine:AwAICCEABAoCCwAIAQiBGwBDenECBAoACwAIAQiBGwBDenECBAoAAA==.Vestshotz:AwACCAUABRQCCwACAQhaFQAiFXUABRQACwACAQhaFQAiFXUABRQAAA==.',Vi='Vintage:AwAECAcABAoAAA==.',Vu='Vulterrier:AwABCAIABAoAAA==.',Wa='Warthandis:AwAHCA4ABAoAAA==.',Wh='Whenththappn:AwAICAgABAoAAA==.',Wy='Wyrmskull:AwADCAIABAoAAA==.Wysashi:AwADCAEABAoAAA==.',Xa='Xanju:AwAHCBEABAoAAA==.',Xi='Xinkz:AwAFCAYABAoAAA==.',Yo='Yolosphinx:AwAHCA8ABAoAAA==.',Za='Zarcyna:AwADCAcABRQDDAADAQjbBwA5nbEABRQADAACAQjbBwA93bEABRQADQACAQjdBAA6TqMABRQAAA==.Zathoron:AwAHCBEABAoAAA==.',Zi='Zillian:AwABCAIABRQCCAAIAQj7DgBGcbUCBAoACAAIAQj7DgBGcbUCBAoAAA==.',Zu='Zumwalathas:AwADCAgABAoAAA==.',['À']='Ànt:AwADCAcABAoAAA==.',['Ë']='Ëvan:AwAFCAYABAoAAA==.',['Ð']='Ðarrow:AwACCAEABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end