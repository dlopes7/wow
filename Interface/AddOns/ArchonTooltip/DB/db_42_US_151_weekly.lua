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
 local lookup = {'Paladin-Retribution','Unknown-Unknown','Priest-Holy','Evoker-Preservation','Warlock-Destruction','Warlock-Affliction','Paladin-Protection','Rogue-Outlaw','Shaman-Restoration','DemonHunter-Havoc','DemonHunter-Vengeance','Priest-Shadow','Priest-Discipline','Hunter-Survival','Monk-Mistweaver','DeathKnight-Frost','DeathKnight-Unholy','DeathKnight-Blood','Monk-Windwalker','Mage-Frost','Shaman-Elemental','Warrior-Fury','Hunter-BeastMastery','Mage-Fire','Mage-Arcane','Warlock-Demonology','Evoker-Devastation','Rogue-Subtlety','Rogue-Assassination','Druid-Restoration',}; local provider = {region='US',realm='Malfurion',name='US',type='weekly',zone=42,date='2025-03-29',data={Ac='Acmis:AwAFCAQABAoAAA==.',Ad='Adventurer:AwAFCAkABAoAAA==.',Ae='Aeelan:AwACCAQABRQCAQAIAQjuDgBZRvgCBAoAAQAIAQjuDgBZRvgCBAoAAA==.Aefg:AwACCAMABAoAAA==.Aertimix:AwABCAEABAoAAA==.Aethalie:AwAFCAUABAoAAA==.',Ai='Airrose:AwAGCBIABAoAAA==.',Ak='Akimetsu:AwADCAMABAoAAA==.',Al='Alayea:AwAFCAQABAoAAA==.Alfina:AwACCAIABRQAAA==.Allise:AwADCAIABAoAAA==.',Am='Amethrist:AwAFCAUABAoAAA==.',Ap='Apawagos:AwAGCBMABAoAAA==.Aphexx:AwAGCBEABAoAAA==.',Ar='Arke:AwAGCAYABAoAAQIAAAAGCA4ABAo=.Arkzilla:AwAGCA4ABAoAAA==.Arwyen:AwAECAYABAoAAA==.Aryusirius:AwACCAIABAoAAA==.',Au='Autania:AwADCAMABAoAAQMASeUGCBUABAo=.Autolock:AwAFCAoABAoAAA==.',Av='Ave:AwAHCA4ABAoAAA==.',Az='Azenthielle:AwAECAQABAoAAQIAAAAFCAUABAo=.',Ba='Badderdragon:AwABCAEABRQCBAAGAQgGCwA2TooBBAoABAAGAQgGCwA2TooBBAoAAA==.Badmuffin:AwAFCAYABAoAAA==.Balloonknott:AwABCAEABRQDBQAHAQi+IgBHwtQBBAoABQAGAQi+IgBK5dQBBAoABgAEAQiiDgA8sx8BBAoAAA==.Bananà:AwAGCBAABAoAAA==.Bashnflash:AwAECAkABAoAAQIAAAAGCAwABAo=.Baxtief:AwADCAIABAoAAA==.',Be='Belzbubz:AwABCAEABAoAAA==.Berkstein:AwAFCAQABAoAAA==.',Bi='Biggimac:AwAGCA8ABAoAAA==.Bigin:AwACCAIABAoAAA==.Biomass:AwACCAMABAoAAA==.',Bl='Bloodalpha:AwAICAgABAoAAA==.Bloodemperor:AwADCAQABAoAAA==.',Bo='Borucwar:AwAFCA4ABAoAAA==.',Bu='Buddhi:AwAGCBMABAoAAA==.Bustersun:AwAFCAMABAoAAA==.',Ca='Calkestis:AwADCAQABAoAAA==.Candre:AwAHCBoABAoCBwAHAQifBgBQPGoCBAoABwAHAQifBgBQPGoCBAoAAA==.Capii:AwAECAQABAoAAA==.',Ch='Chalfin:AwAECAEABAoAAA==.Chay:AwADCAMABAoAAA==.Chillen:AwAFCA8ABAoAAA==.Chrîstîne:AwADCAMABAoAAA==.Chyna:AwAECBMABAoAAA==.',Ci='Cibø:AwADCAIABAoAAA==.',Cl='Clarsh:AwABCAIABRQCCAAHAQgmAgBRSmoCBAoACAAHAQgmAgBRSmoCBAoAAA==.Clayzerk:AwAHCAQABAoAAA==.Cleric:AwAECAcABAoAAA==.',Cr='Crazymofoe:AwAECAoABAoAAA==.',Cy='Cybre:AwADCAMABAoAAA==.',['C�']='Cästiel:AwAFCAoABAoAAA==.',Da='Dally:AwADCAQABRQCCQAIAQhOAwBcGhwDBAoACQAIAQhOAwBcGhwDBAoAAA==.Darcane:AwAHCA8ABAoAAA==.Darkvayne:AwAICAsABAoAAA==.Dayanita:AwACCAEABAoAAA==.',De='Deceiver:AwAECAsABAoAAA==.Deeblite:AwAICAgABAoAAA==.Demonnova:AwACCAQABRQDCgAIAQgrIQAz/hACBAoACgAIAQgrIQApPxACBAoACwADAQguIQBQWewABAoAAA==.Devrish:AwADCAMABAoAAA==.Dexterxo:AwAECAgABAoAAA==.',Di='Diaranawar:AwABCAEABAoAAA==.',Dr='Dragn:AwADCAgABAoAAA==.Dragnas:AwAGCA4ABAoAAA==.Dreadnaunt:AwAECAEABAoAAA==.Drugral:AwAGCBMABAoAAA==.Dryad:AwADCAwABAoAAA==.',Ea='Eadric:AwAHCBoABAoCAQAHAQggSgAx1cMBBAoAAQAHAQggSgAx1cMBBAoAAA==.',El='Elanthemage:AwAFCAQABAoAAA==.Eleison:AwAECAoABRQEAwAEAQgzAQBbGzsBBRQAAwADAQgzAQBYJDsBBRQADAABAQhBCwBGeFwABRQADQABAQi3DQBFWUMABRQAAA==.Ellmist:AwAFCAsABAoAAA==.Ellumen:AwAGCAwABAoAAA==.',Ep='Epyon:AwAICAgABAoAAA==.',Er='Erinyes:AwAHCBoABAoCDgAHAQgiBwAQpTMBBAoADgAHAQgiBwAQpTMBBAoAAA==.',Fa='Fatfish:AwADCAMABAoAAA==.Fatty:AwAHCBoABAoCDwAHAQgoLAAeD0cBBAoADwAHAQgoLAAeD0cBBAoAAA==.',Fe='Feyrozen:AwAFCAQABAoAAA==.',Fi='Firedup:AwAICAgABAoAAA==.',Fl='Fluffythecup:AwAFCAQABAoAAA==.',Fo='Formidonis:AwAGCAwABAoAAA==.Foxfirestrot:AwABCAEABAoAAA==.',Ga='Ganymede:AwABCAEABRQAAA==.Garygabagool:AwABCAIABRQAAA==.Gawdspet:AwAHCBIABAoAAA==.',Gl='Gloomycyan:AwAFCAwABAoAAA==.Glyn:AwAFCAQABAoAAA==.',Go='Goonboom:AwAECAQABAoAAA==.',Gr='Grekka:AwAECAYABAoAAA==.Grïm:AwAGCBMABAoAAA==.',Gu='Guldont:AwABCAEABAoAAA==.',Ha='Hammyhamster:AwAICAgABAoAAA==.Hankers:AwABCAEABAoAAA==.Haptics:AwAHCBIABAoAAA==.',He='Heresthebeef:AwAGCBEABAoAAA==.',Ho='Holydiscerag:AwABCAEABAoAAQIAAAACCAIABAo=.Holyslanger:AwADCAIABAoAAA==.Homogenic:AwAGCBAABAoAAA==.Horo:AwABCAIABRQEEAAHAQjZBQBb2TgCBAoAEAAGAQjZBQBcuDgCBAoAEQAHAQiCFQBFTSgCBAoAEgADAQgZMAAwn4kABAoAAA==.Hoss:AwAGCAwABAoAAA==.',Ht='Htownshawdo:AwAECAQABAoAAA==.',Hw='Hwangjinyi:AwAHCBoABAoDDwAHAQgEHwAwqqoBBAoADwAHAQgEHwAwqqoBBAoAEwABAQhMUwAIESEABAoAAA==.',Io='Ioraa:AwAFCAQABAoAAA==.',Ir='Irishhammer:AwAFCAQABAoAAA==.Ironfist:AwACCAIABAoAAA==.',Ji='Jileti:AwACCAcABRQCDwACAQj5CABOaasABRQADwACAQj5CABOaasABRQAAA==.',Jo='Johnporter:AwAHCAQABAoAAA==.Jozeph:AwAGCAIABAoAAA==.',Jp='Jpg:AwAHCAUABAoAAA==.',Ju='Justania:AwAGCBUABAoCAwAGAQirFQBJ5ecBBAoAAwAGAQirFQBJ5ecBBAoAAA==.',Ka='Kaeloth:AwAGCAEABAoAAA==.Kagayoshi:AwAFCAQABAoAAA==.Kalebpal:AwAGCBMABAoAAA==.Kalm:AwAGCAwABAoAAA==.Kayaanu:AwAHCBQABAoCFAAHAQjABQBf0OwCBAoAFAAHAQjABQBf0OwCBAoAAA==.',Ke='Kerethor:AwAHCBAABAoAAA==.',Kh='Khadrodox:AwAECAQABAoAAA==.Khalanøz:AwAECAYABAoAAA==.Kharn:AwAGCA0ABAoAAA==.Khazryl:AwAECAcABAoAAA==.',Ki='Kioni:AwAFCAcABAoAAA==.',Kl='Kletus:AwABCAEABRQAAA==.',Ko='Kongming:AwAHCBMABAoAAA==.Korvash:AwAECAIABAoAAA==.',Kr='Kromgol:AwABCAMABRQCFQAIAQgLBwBTadACBAoAFQAIAQgLBwBTadACBAoAAA==.',Ky='Kyela:AwAFCAQABAoAAA==.',['K�']='Kørupted:AwAFCAQABAoAAA==.',La='Laurala:AwADCAQABAoAAA==.Laurandrel:AwACCAQABAoAAA==.Laved:AwAGCAEABAoAAA==.',Le='Legarde:AwAGCBIABAoAAA==.',Li='Lilflip:AwAECAQABAoAAA==.Lilya:AwAFCAgABAoAAA==.Lithiris:AwAECAUABAoAAQMASeUGCBUABAo=.Lithorius:AwAFCA0ABAoAAA==.',Lo='Lorick:AwAGCA4ABAoAAA==.',Lu='Lucidonis:AwAFCAoABAoAAA==.',Ly='Lystia:AwADCAYABAoAAA==.',Ma='Mandarinduck:AwACCAMABRQCFgAIAQjIAwBcuTMDBAoAFgAIAQjIAwBcuTMDBAoAAA==.Marakanis:AwADCAQABAoAAA==.Mattick:AwABCAIABRQCFwAHAQhnHABUv3MCBAoAFwAHAQhnHABUv3MCBAoAAA==.',Mc='Mcfknkfc:AwAFCAYABAoAAA==.',Me='Meeyo:AwAGCA0ABAoAAA==.Mekaoppai:AwAECAoABAoAAA==.Mercadez:AwABCAEABRQAAA==.',Mi='Micti:AwAFCAoABAoAAA==.Miniion:AwAGCBEABAoAAA==.Minirhon:AwADCAEABAoAAA==.',Mo='Monkspider:AwACCAIABAoAAA==.Monsterflexx:AwAHCBoABAoDFwAHAQgmHgBQDGYCBAoAFwAHAQgmHgBQDGYCBAoADgABAQjJEwAgQygABAoAAA==.',My='Mysticpork:AwABCAEABRQEFAAIAQhAGAA35vkBBAoAFAAIAQhAGAA35vkBBAoAGAABAQjldwAMmSIABAoAGQABAQgjEQAGlQsABAoAAA==.',['M�']='Mìcycle:AwACCAIABAoAAA==.',Na='Naanir:AwAFCAUABAoAAA==.Naparture:AwAGCBEABAoAAA==.Narkin:AwAGCBAABAoAAA==.',Ne='Nelzidin:AwAHCAMABAoAAA==.Newstoneform:AwAFCAMABAoAAA==.',Ni='Nicecoat:AwADCAQABAoAAA==.Nicodemouz:AwAGCAIABAoAAA==.Ninetailss:AwAICAgABAoAAA==.',No='Norav:AwACCAIABAoAAA==.Nordini:AwACCAIABAoAAA==.Nordrydm:AwABCAEABRQAAA==.',['N�']='Níghtmäre:AwAGCAEABAoAAA==.',Ok='Okiedokiemon:AwAFCA0ABAoAAA==.',Ol='Olmeattotem:AwAGCAgABAoAAA==.',Op='Ophemia:AwAGCBAABAoAAA==.',Or='Orllin:AwABCAMABAoAAA==.',Oy='Oyron:AwADCAMABAoAAA==.',Pa='Papathiccins:AwAGCA4ABAoAAA==.Paradru:AwAECAQABAoAAA==.',Pe='Pekkie:AwADCAQABAoAAA==.Pestis:AwAHCAwABAoAAA==.',Ph='Phil:AwACCAMABAoAAA==.',Pi='Pi:AwAECAoABAoAAA==.Pidi:AwAHCBoABAoCAQAHAQiaQAA+fecBBAoAAQAHAQiaQAA+fecBBAoAAA==.Pioree:AwAGCAoABAoAAA==.',Pr='Premier:AwAECAQABAoAAA==.Pretitis:AwAECAEABAoAAA==.Pronouns:AwAGCAwABAoAAA==.',Py='Pymuuna:AwAGCBIABAoAAA==.Pyrophobiac:AwACCAMABRQDGgAIAQhHAABeuVoDBAoAGgAIAQhHAABeuVoDBAoABQAGAQh7KQBE1KIBBAoAAA==.',Ra='Raleina:AwAICBAABAoAAA==.Rangar:AwAICAgABAoAAA==.Raydemic:AwAHCAEABAoAAA==.',Re='Renmazuo:AwAGCAwABAoAAA==.',Ri='Rindor:AwADCAMABAoAAA==.',Rq='Rq:AwAGCBQABAoEBQAGAQiaOwAiQjABBAoABQAGAQiaOwAiQjABBAoABgACAQiOIQAgAWIABAoAGgABAQi9RgACfBgABAoAAA==.',Ru='Rucy:AwAHCBAABAoAAA==.',Ry='Rynx:AwAECAQABAoAAA==.',Sa='Saeyasan:AwAFCAQABAoAAA==.Sakurai:AwAFCAQABAoAAA==.Sangard:AwACCAMABAoAAA==.',Sc='Scalaspi:AwADCAQABAoAAA==.',Se='Sedard:AwAICAgABAoAAA==.Selindia:AwAFCAcABAoAAA==.Sewersliding:AwAECAQABAoAAA==.',Sh='Shallon:AwADCAMABAoAAA==.Sharkiesha:AwAECAUABAoAAA==.Sheepncreep:AwAGCAwABAoAAA==.Shen:AwAGCAwABAoAAA==.Shibito:AwAGCBQABAoCDAAGAQjlHQAvfXMBBAoADAAGAQjlHQAvfXMBBAoAAA==.Shilihu:AwADCAMABAoAAA==.Shorzy:AwAFCA0ABAoAAA==.Shåmwöw:AwAECAYABAoAAA==.',Si='Sienar:AwAFCA0ABAoAAA==.Simplejack:AwAFCA8ABAoAAA==.',Sk='Skeptá:AwAHCAwABAoAAA==.Skuwu:AwAGCAoABAoAAA==.',Sl='Sleepfrostvv:AwAHCBgABAoDBAAHAQjoBgA+LQcCBAoABAAHAQjoBgA+LQcCBAoAGwACAQggLQA+O4gABAoAAA==.',So='Somno:AwAHCBoABAoCCwAHAQipFAAujGsBBAoACwAHAQipFAAujGsBBAoAAA==.Soulsabi:AwAICBMABAoAAA==.',Sp='Spizzleblzz:AwAFCAQABAoAAA==.Spookyninja:AwACCAQABRQCHAAIAQjRBQBJ0ccCBAoAHAAIAQjRBQBJ0ccCBAoAAA==.Spookywacky:AwAECAsABAoAAA==.',St='Stardrift:AwABCAEABAoAAA==.Stauker:AwABCAEABAoAAA==.Stere:AwABCAEABRQAAA==.Sternshammy:AwAHCAIABAoAAA==.',Su='Supershenron:AwAGCA0ABAoAAA==.Surprise:AwABCAEABRQAAA==.',Sy='Syrelliia:AwABCAEABRQCHQAGAQhwEQAy9nsBBAoAHQAGAQhwEQAy9nsBBAoAAA==.',['S�']='Sævage:AwAFCAwABAoAAA==.Sørta:AwAFCAQABAoAAA==.',Te='Terrorforge:AwADCAQABAoAAA==.',Th='Thedockwho:AwADCAcABAoAAA==.Thefïst:AwAFCAEABAoAAA==.Theliarcy:AwAHCAoABAoAAA==.Thiccake:AwABCAEABAoAAA==.Thirdeye:AwACCAMABRQCHgAIAQjKDgA3UxUCBAoAHgAIAQjKDgA3UxUCBAoAAA==.Tholk:AwABCAIABAoAAA==.Thoxic:AwAHCBoABAoCGwAHAQjhFQApu5sBBAoAGwAHAQjhFQApu5sBBAoAAA==.',Ti='Tide:AwADCAQABAoAAA==.Timidity:AwAHCBQABAoDHQAHAQh+DwBIjaQBBAoAHAAGAQh7EwA8iaYBBAoAHQAFAQh+DwBNW6QBBAoAAA==.',To='Toolip:AwAECAEABAoAAA==.',Tr='Trashfish:AwAICAgABAoAAA==.Traumaspally:AwAICAYABAoAAA==.Triggah:AwABCAEABAoAAA==.Trolina:AwADCAEABAoAAA==.Tronus:AwADCAgABAoAAA==.Troodonus:AwAFCAsABAoAAA==.Trè:AwADCAMABAoAAA==.',Um='Umbralmoon:AwADCAcABAoAAA==.',Un='Uniscorn:AwAICAEABAoAAA==.',Va='Vaneste:AwADCAUABRQDGgADAQheAQAqva4ABRQAGgACAQheAQAyYa4ABRQABgABAQgkDAAbdkwABRQAAA==.Vartrino:AwAHCBoABAoCCQAHAQh8IQAxo7wBBAoACQAHAQh8IQAxo7wBBAoAAA==.',Ve='Veldras:AwACCAIABAoAAA==.Veralynn:AwADCAUABAoAAA==.Vermwing:AwAECAsABAoAAA==.',Vi='Vikin:AwAGCAwABAoAAA==.Viraya:AwADCAYABAoAAA==.',Vo='Vordris:AwAFCAsABAoAAA==.Vortan:AwABCAEABAoAAA==.',Wa='Warfury:AwAECAYABAoAAA==.',Wo='Wockyslush:AwABCAEABAoAAA==.Wolfrin:AwACCAIABAoAAA==.Wowsix:AwADCAMABAoAAA==.',Wu='Wubers:AwAHCBMABAoAAA==.Wubwub:AwADCAIABAoAAQIAAAAHCBMABAo=.',Yo='Yohda:AwABCAEABRQCDwAHAQjMFQA/FQACBAoADwAHAQjMFQA/FQACBAoAAA==.',Za='Zaboza:AwAECAQABAoAAA==.Zappÿ:AwACCAMABAoAAA==.',Ze='Zerttrak:AwAGCBIABAoAAA==.',Zo='Zoyi:AwAHCBEABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end