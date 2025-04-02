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
 local lookup = {'Warlock-Destruction','Warlock-Affliction','Warlock-Demonology','Paladin-Retribution','Hunter-BeastMastery','Warrior-Protection','Warrior-Arms','DemonHunter-Vengeance','Priest-Discipline','Priest-Holy','Unknown-Unknown','Druid-Balance','Druid-Restoration','Shaman-Restoration','Mage-Frost','DeathKnight-Blood','Priest-Shadow','Rogue-Assassination','Warrior-Fury',}; local provider = {region='US',realm='Frostwolf',name='US',type='weekly',zone=42,date='2025-03-29',data={Ab='Abadon:AwACCAEABAoAAA==.',Ac='Action:AwABCAMABRQEAQAHAQg2EABVXnICBAoAAQAHAQg2EABVXnICBAoAAgAEAQi9DgBGJR4BBAoAAwACAQhlKgA/IZ4ABAoAAA==.',Ae='Aeryn:AwABCAEABRQCBAAIAQijCgBbQR0DBAoABAAIAQijCgBbQR0DBAoAAA==.',Ah='Ahote:AwAHCAkABAoAAA==.',Al='Alarin:AwAFCAUABAoAAA==.Alseena:AwADCAEABAoAAA==.',Am='Amadeux:AwABCAEABRQCBQAHAQgDHgBUkGcCBAoABQAHAQgDHgBUkGcCBAoAAA==.Amicae:AwAECAIABAoAAA==.',An='Andenarras:AwABCAEABAoAAA==.Anform:AwAFCAwABAoAAA==.Anthais:AwAFCAsABAoAAA==.',Ar='Arby:AwAHCAwABAoAAA==.Arfas:AwAECAYABAoAAA==.Armoogeddon:AwADCAMABAoAAA==.Arx:AwABCAEABRQDBgAIAQgiAQBZTSUDBAoABgAIAQgiAQBZTSUDBAoABwAIAQhfCgA+F0wCBAoAAA==.',As='Ashleyk:AwAFCAkABAoAAA==.',At='Atrumdeus:AwAGCBIABAoAAA==.',Au='Autoshottnn:AwAGCAwABAoAAA==.',Aw='Awkykit:AwAECAIABAoAAA==.',Be='Beaksbigdk:AwAFCAwABAoAAA==.Belldia:AwAFCA8ABAoAAA==.Benini:AwACCAIABAoAAA==.',Bl='Blackribbon:AwAECAEABAoAAA==.',Bo='Boo:AwAICAgABAoAAQQAUvgDCAQABRQ=.',Br='Bronzetusk:AwAFCA0ABAoAAA==.Brothalynch:AwACCAIABAoAAA==.Brés:AwAICAgABAoAAA==.',Bu='Bubblêosêvên:AwAICA8ABAoAAA==.Buckey:AwAFCAgABAoAAA==.Busting:AwAFCAsABAoAAA==.',Ch='Chainy:AwAECAQABAoAAA==.Chrysamere:AwAHCBMABAoAAA==.',Co='Corinthian:AwAGCBMABAoAAA==.',Cu='Cumrad:AwAGCBAABAoAAA==.',Cw='Cwoodz:AwAFCAYABAoAAA==.',Da='Damacraze:AwAHCBQABAoCBQAHAQi2NQA3dMoBBAoABQAHAQi2NQA3dMoBBAoAAA==.Daoloth:AwAECAgABAoAAA==.Darcness:AwABCAEABAoAAA==.Dark:AwADCAgABRQCCAADAQiqAABYtTEBBRQACAADAQiqAABYtTEBBRQAAA==.Daxine:AwAECAEABAoAAA==.',De='Deaminase:AwAGCA4ABAoAAA==.Delphoxx:AwAECAUABAoAAA==.Demidru:AwAECAUABAoAAA==.Depleterpann:AwABCAEABAoAAA==.',Di='Dicol:AwAFCAIABAoAAA==.Divineshock:AwAECAgABAoAAA==.',Do='Dohati:AwAICBgABAoCCQAIAQhLRgADOGUABAoACQAIAQhLRgADOGUABAoAAA==.Dommiination:AwAECAEABAoAAA==.',Dr='Drakblak:AwAHCBQABAoCCgAHAQjPGgAzubYBBAoACgAHAQjPGgAzubYBBAoAAA==.Drathgar:AwAGCAYABAoAAA==.',Du='Duayne:AwAFCAkABAoAAA==.',Ee='Eezmeez:AwABCAEABAoAAA==.',Eg='Eggdrop:AwACCAIABAoAAA==.',En='Enaeria:AwADCAMABAoAAA==.',Es='Estellyse:AwACCAIABAoAAA==.',Ey='Eygueth:AwAECAMABAoAAQsAAAAHCAoABAo=.',Fa='Fairyhunter:AwAECAcABAoAAA==.Fañgrat:AwABCAEABAoAAA==.',Fl='Floppyterry:AwAFCAMABAoAAA==.',Fr='Friskìes:AwAHCAIABAoAAA==.Froznlight:AwAECAEABAoAAA==.',Fy='Fylerian:AwABCAEABRQDDAAIAQj7DABb2rECBAoADAAHAQj7DABbTLECBAoADQABAQgEVAAuCz4ABAoAAA==.',Ga='Ganjja:AwADCAUABAoAAA==.',Gi='Giny:AwAFCAMABAoAAA==.',Go='Gobbledeez:AwAGCAYABAoAAA==.Gotcowbell:AwADCAcABAoAAA==.',Gr='Graysing:AwACCAMABAoAAA==.Grizzy:AwADCAQABAoAAA==.',Gy='Gyndrinolara:AwAECAUABAoAAA==.',He='Hexou:AwAHCAoABAoAAA==.',Hi='Himanshu:AwAFCAoABAoAAA==.',Ho='Holypane:AwABCAEABRQAAA==.Horick:AwADCAMABAoAAA==.',Hu='Huu:AwAFCAkABAoAAA==.',Ia='Iamstronge:AwAFCAoABAoAAA==.',Im='Imbreedable:AwAFCA4ABAoAAA==.',It='Itai:AwAHCBEABAoAAA==.',Ja='Jackill:AwAFCAgABAoAAA==.Jazzle:AwAHCBQABAoCDgAHAQhlHwA8rMsBBAoADgAHAQhlHwA8rMsBBAoAAA==.',Jh='Jhoanjhett:AwAECAEABAoAAA==.',Ji='Jinkua:AwAICAgABAoAAA==.',Ka='Kaeya:AwADCAYABAoAAA==.Katedolores:AwAGCAQABAoAAA==.',Ke='Kevthefatire:AwADCAcABAoAAA==.',Ki='Killmonga:AwACCAEABAoAAA==.',Ko='Kore:AwABCAEABRQAAA==.Korfang:AwAFCAoABAoAAA==.',Ku='Kuzco:AwAECAUABAoAAA==.',La='Lani:AwACCAIABAoAAA==.Lapointe:AwAICAgABAoAAA==.Laurianna:AwAICBIABAoAAA==.',Le='Lelink:AwAECAgABAoAAA==.',Li='Lightlana:AwABCAEABAoAAA==.Littlestarz:AwAFCAsABAoAAA==.Lizzieag:AwEFCAwABAoAAA==.',Lo='Loakai:AwAECAcABAoAAA==.Lohueng:AwAECAgABAoAAA==.Lootah:AwADCAUABAoAAA==.Lowbatteries:AwABCAEABAoAAA==.',Ly='Lyxon:AwAECAUABAoAAA==.',Ma='Malgozrabeth:AwABCAMABRQCAgAIAQj6AwA4FyECBAoAAgAIAQj6AwA4FyECBAoAAA==.Malédiction:AwAHCBQABAoCDwAHAQjeIgAuoZwBBAoADwAHAQjeIgAuoZwBBAoAAA==.Maplewick:AwABCAEABAoAAA==.Mazera:AwADCAQABAoAAA==.',Me='Memorypearl:AwABCAEABRQAAA==.',Mi='Minisid:AwAGCA4ABAoAAA==.',Mo='Monktomas:AwAGCA0ABAoAAA==.Moobius:AwAECAQABAoAAA==.Moomeow:AwABCAEABRQAAA==.',['M�']='Mÿstërÿ:AwADCAcABAoAAA==.',Na='Natedoggydog:AwAICBAABAoAAA==.',Ne='Neuro:AwAECAEABAoAAA==.',Ni='Nichdru:AwADCAMABAoAAA==.Nilly:AwAGCAYABAoAAA==.Nitefall:AwADCAQABAoAAA==.',Oo='Oonaki:AwAHCBQABAoCEAAHAQiyHwAd+xoBBAoAEAAHAQiyHwAd+xoBBAoAAA==.',Pa='Palacall:AwAICAgABAoAAA==.',Pe='Peeposadjam:AwABCAEABAoAAA==.Petrogris:AwADCAUABAoAAA==.',Pu='Purr:AwADCAQABAoAAA==.',Re='Renkagisa:AwADCAkABAoAAA==.Retana:AwABCAIABAoAAA==.Retrisan:AwAHCA4ABAoAAA==.Revaine:AwADCAQABAoAAA==.',Rh='Rhinn:AwACCAMABAoAAA==.',Ri='Rileydude:AwADCAcABAoAAA==.',Ro='Rojen:AwACCAEABAoAAA==.',Ru='Ruaumoko:AwAFCAUABAoAAA==.',Sa='Sarayu:AwAGCA0ABAoAAA==.Sassyjay:AwAGCBUABAoECgAGAQjQEQBVvxACBAoACgAGAQjQEQBVnhACBAoACQADAQiMMgA9nckABAoAEQABAQjfUgADhxEABAoAAA==.',Sc='Scrubbdaddy:AwAHCA4ABAoAAA==.',Se='Seran:AwAFCA4ABAoAAA==.',Sh='Shadoharht:AwADCAMABAoAAA==.Shockcaller:AwAFCAkABAoAAA==.',Sm='Smeetpotato:AwADCAMABAoAAA==.',So='Solstica:AwABCAEABAoAAA==.',St='Stonekiwi:AwAHCBUABAoCEgAHAQh6BABaxMICBAoAEgAHAQh6BABaxMICBAoAAA==.Stonystark:AwAECAQABAoAAA==.',Su='Suitedhunt:AwADCAUABAoAAA==.',Sy='Syllenás:AwADCAMABAoAAA==.',Ta='Tahumm:AwAFCAkABAoAAA==.Taigahunt:AwAECAUABAoAAA==.Takoi:AwABCAEABAoAAA==.',Th='Thabq:AwADCAcABAoAAA==.Thraxacious:AwAECAcABAoAAA==.Thulsadoomm:AwABCAEABAoAAA==.',Ti='Tigölebittie:AwAHCAcABAoAAA==.',To='Tolkien:AwABCAEABAoAAA==.',Tr='Treesuschrst:AwABCAEABRQAAA==.Trumpybear:AwAFCAYABAoAAA==.',Tw='Twinstar:AwABCAEABAoAAA==.',Un='Uncletat:AwABCAEABRQAAA==.',Ur='Urmami:AwAECAIABAoAAA==.',Va='Vampyre:AwADCAYABAoAAQgAWLUDCAgABRQ=.Vandalf:AwAFCA4ABAoAAA==.',Ve='Vengeta:AwADCAgABAoAAA==.',Vi='Vitaminn:AwAECAQABAoAAA==.',Vl='Vlaen:AwAECAIABAoAAA==.',Vo='Voldane:AwAFCA4ABAoAAA==.',Vy='Vynaria:AwABCAEABAoAAA==.Vyndrana:AwAECAYABAoAAQsAAAAFCAEABAo=.',Wd='Wdfourty:AwAHCBMABAoAAA==.',We='Welios:AwAFCAcABAoAAA==.',Wh='Whisa:AwAICAwABAoAAA==.',Wi='Wilhedin:AwAHCBIABAoDEwAHAQhPFgBMBTECBAoAEwAGAQhPFgBRKDECBAoABwADAQgbKwAzy78ABAoAAA==.Wing:AwADCAQABRQCBAAIAQhoFgBS+L0CBAoABAAIAQhoFgBS+L0CBAoAAA==.',Wu='Wumbology:AwAICAkABAoAAA==.',Za='Zanzer:AwADCAMABAoAAA==.Zarga:AwADCAUABAoAAA==.',Ze='Zeshlock:AwAHCBMABAoAAA==.',['ß']='ßutcher:AwACCAMABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end