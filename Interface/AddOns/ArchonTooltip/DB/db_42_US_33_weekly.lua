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
 local lookup = {'Shaman-Elemental','Warrior-Fury','Warrior-Arms','DeathKnight-Unholy','DeathKnight-Frost','Hunter-BeastMastery','Monk-Windwalker','DeathKnight-Blood','Monk-Mistweaver','Priest-Holy','Priest-Discipline','Druid-Guardian','Unknown-Unknown','Hunter-Survival','Paladin-Protection','Paladin-Retribution','Rogue-Subtlety','Druid-Restoration','DemonHunter-Havoc','Priest-Shadow','Evoker-Devastation','Warlock-Destruction','Evoker-Preservation','Shaman-Restoration','Druid-Balance','Mage-Frost','Mage-Fire','Paladin-Holy',}; local provider = {region='US',realm='Blackrock',name='US',type='weekly',zone=42,date='2025-03-28',data={Ad='Adebisi:AwACCAUABAoAAA==.',Ai='Aizenx:AwAECAEABAoAAA==.',Al='Alahn:AwADCAUABAoAAQEAX24BCAIABRQ=.Alandovos:AwACCAIABAoAAA==.Alienfreakdt:AwAICBUABAoDAgAIAQhvBQBX3BADBAoAAgAIAQhvBQBX3BADBAoAAwADAQg6LQA1lKMABAoAAA==.Alluria:AwABCAEABRQDBAAGAQh+KwAnrVcBBAoABAAGAQh+KwAlwFcBBAoABQAFAQjyEgAb7PEABAoAAA==.Alysun:AwABCAEABAoAAA==.',Am='Amzel:AwABCAEABRQCBgAIAQgRDgBTougCBAoABgAIAQgRDgBTougCBAoAAA==.',An='Animaloss:AwAECAIABAoAAA==.Anirn:AwAGCAgABAoAAA==.Anthilina:AwAECAcABAoAAA==.',Ar='Aradora:AwACCAEABAoAAA==.Arkyos:AwABCAIABRQCBwAIAQjGAQBf2lUDBAoABwAIAQjGAQBf2lUDBAoAAA==.Artemyss:AwADCAUABAoAAA==.Arthanos:AwAICBYABAoCCAAIAQjTCABF/WsCBAoACAAIAQjTCABF/WsCBAoAAA==.Aryã:AwADCAEABAoAAA==.',As='Assassinman:AwADCAYABAoAAA==.Asterean:AwAHCAQABAoAAA==.Astàroth:AwACCAIABAoAAA==.',Av='Avachii:AwABCAIABRQCCQAIAQj0BABUkfoCBAoACQAIAQj0BABUkfoCBAoAAA==.Avdol:AwAGCAoABAoAAA==.',Ba='Baelcoz:AwABCAEABAoAAA==.Bankhyst:AwAECAQABAoAAA==.Barkskin:AwAHCAQABAoAAA==.',Be='Beastialmath:AwADCAYABAoAAA==.Bellarke:AwAFCAkABAoAAA==.Belldelphine:AwABCAIABRQAAA==.',Bi='Bignatureguy:AwADCAMABAoAAA==.Billybombem:AwAICAgABAoAAA==.',Bl='Blazeuwu:AwABCAIABRQDCgAIAQjBAwBVe/ACBAoACgAIAQjBAwBVe/ACBAoACwAGAQilFAA/LLkBBAoAAA==.Bleak:AwAHCAQABAoAAA==.Blessings:AwAFCAkABAoAAA==.Blödhgárm:AwABCAIABRQCDAAIAQiGAgA+MUACBAoADAAIAQiGAgA+MUACBAoAAA==.',Bo='Boboko:AwAHCAsABAoAAA==.Bodyshots:AwAHCBIABAoAAA==.Boonswaggle:AwACCAIABAoAAA==.Boscho:AwAFCAgABAoAAQ0AAAAICA4ABAo=.Boschoa:AwAICA4ABAoAAA==.Bowguy:AwAICAgABAoAAA==.',Bu='Bubblesforu:AwAECAMABAoAAA==.',['B�']='Bóunce:AwAICAwABAoAAA==.',Ca='Cantaloupe:AwACCAIABAoAAA==.Caytr:AwAGCAMABAoAAA==.',Ce='Centershock:AwACCAIABAoAAA==.',Cf='Cfred:AwAFCAIABAoAAA==.',Ch='Chaoselite:AwABCAIABRQAAA==.Chin:AwABCAEABRQAAA==.Chone:AwACCAIABAoAAA==.Chuibacca:AwABCAEABRQDBgAHAQjsFwBWoZACBAoABgAHAQjsFwBWoZACBAoADgADAQjTDAAlAooABAoAAA==.',Cl='Clanx:AwAECAcABAoAAA==.Clickclack:AwADCAMABAoAAA==.',Co='Cobrakilla:AwAFCAkABAoAAA==.Cosmicgate:AwAFCAYABAoAAA==.Cowlawladin:AwACCAIABRQDDwAIAQjRCgA1nPIBBAoADwAIAQjRCgAzUPIBBAoAEAAGAQj0XAAtnnIBBAoAAA==.',Cr='Critcritz:AwAECAgABAoAAA==.Crusha:AwAGCAMABAoAAA==.',Ct='Ctf:AwAGCAgABAoAAA==.',['C�']='Cönquest:AwAFCAEABAoAAA==.',Da='Daeltha:AwAFCAkABAoAAA==.Dagimp:AwACCAEABAoAAA==.Daisytaylor:AwAGCAYABAoAAA==.Darkhært:AwADCAEABAoAAA==.Darthmuffin:AwAFCAkABAoAAA==.Dasprime:AwACCAIABAoAAA==.Dawoonz:AwACCAIABAoAAQ0AAAAFCAQABAo=.',De='Deathbringer:AwAICAUABAoAAA==.Deathdealer:AwABCAEABAoAAA==.Deathãngel:AwACCAIABRQCCAAIAQg3CABKQXoCBAoACAAIAQg3CABKQXoCBAoAAA==.Degraded:AwAICBAABAoAAA==.Demonstealth:AwADCAYABAoAAA==.Dethstra:AwAECAgABAoAAA==.',Di='Dillydílly:AwAHCAwABAoAAA==.',Do='Doryani:AwAFCAUABAoAAA==.',Dr='Dramatic:AwACCAIABRQAAA==.Dratnosfan:AwAICBYABAoCEQAIAQg4AgBX9ygDBAoAEQAIAQg4AgBX9ygDBAoAAA==.Drazka:AwAGCA4ABAoAAA==.Dreamlike:AwABCAIABRQCEgAIAQh6BQBR+b4CBAoAEgAIAQh6BQBR+b4CBAoAAA==.Dreamology:AwACCAMABAoAAA==.Driztt:AwAHCBEABAoAAA==.',Du='Dunkndonuts:AwAICAoABAoAAA==.',['D�']='Dèrp:AwABCAEABAoAAA==.',El='Eldsinsalis:AwAGCAgABAoAAA==.Electrolytes:AwADCAMABAoAAA==.',Ev='Evialleanna:AwAICAgABAoCEwAIAQilRQANbhUBBAoAEwAIAQilRQANbhUBBAoAAA==.Eviania:AwADCAUABAoAAA==.Evillinx:AwADCAUABAoAAA==.Evilmaru:AwADCAUABAoAAA==.',Fa='Faesroln:AwAECAEABAoAAA==.Fawandel:AwADCAIABAoAAA==.Fayfargrove:AwACCAEABAoAAA==.',Fi='Fidel:AwAGCA4ABAoAAA==.Firestream:AwAGCBIABAoAAA==.',Fl='Flexisonfiya:AwACCAEABAoAAA==.Flux:AwADCAYABAoAAA==.Flâimee:AwAFCAYABAoAAA==.',Fo='Foeresh:AwAFCAIABAoAAA==.',Fu='Furgoblin:AwAECAMABAoAAA==.',Ga='Gawler:AwACCAEABAoAAA==.',Gr='Greyarrow:AwADCAYABAoAAA==.Gringi:AwAFCA0ABAoAAA==.Grizzard:AwADCAUABAoAAA==.Gromzo:AwACCAMABAoAAA==.Gruckek:AwADCAUABAoAAA==.',Gw='Gwendlyne:AwADCAMABAoAAA==.',['G�']='Gäcrux:AwACCAEABAoAAA==.',He='Healsmon:AwAGCA8ABAoAAA==.Heliophobic:AwADCAEABAoAAA==.Hellosharon:AwABCAEABAoAAA==.',Ho='Hokkigai:AwAECAMABAoAAA==.Holistic:AwADCAUABAoAAA==.Hotlineblink:AwAICAgABAoAAA==.',Hu='Huntaa:AwAGCAsABAoAAA==.Huraji:AwABCAIABRQEFAAIAQjyCABT2KkCBAoAFAAHAQjyCABZvKkCBAoACgADAQj7QgAu6akABAoACwACAQiSSgAPJEsABAoAAA==.',Hy='Hysterya:AwADCAUABAoAAA==.',If='Ifarmthings:AwAGCAUABAoAAA==.',Im='Imptaco:AwAECAQABAoAAA==.Imryl:AwADCAYABAoAAA==.',In='Insatiacow:AwAHCBIABAoAAA==.Inzo:AwAFCAgABAoAAA==.',Io='Io:AwACCAQABAoAAQ0AAAAGCAgABAo=.',Ir='Ironpaws:AwAECAEABAoAAA==.',Ja='Jakuza:AwADCAMABAoAAA==.',Je='Jeffyshadows:AwAICBYABAoCFAAIAQjGCwBAmnUCBAoAFAAIAQjGCwBAmnUCBAoAAA==.Jerìk:AwAHCAoABAoAAA==.',Ji='Jigsaw:AwAFCA8ABAoAAA==.',Jo='Joeywheeler:AwAICBUABAoCFQAIAQiBCgBEA2cCBAoAFQAIAQiBCgBEA2cCBAoAAA==.',Ju='Justabutcher:AwAECAEABAoAAA==.',Ka='Kafur:AwADCAEABAoAAA==.Kamasplode:AwAHCA0ABAoAAA==.Kanner:AwADCAUABAoAAA==.',Ke='Kelendor:AwABCAIABRQCBgAIAQiwGwA9knACBAoABgAIAQiwGwA9knACBAoAAA==.',Kh='Khlampzight:AwAICBYABAoCCAAIAQj6DAA6wA0CBAoACAAIAQj6DAA6wA0CBAoAAA==.',Ki='Kiel:AwAGCAsABAoAAA==.Kilnona:AwABCAEABRQAAA==.',Kr='Krushka:AwAGCAcABAoAAA==.',Ku='Kuobruh:AwAFCAMABAoAAA==.',Kw='Kwangpow:AwAHCAQABAoAAA==.',La='Lazyrage:AwABCAEABAoAAQ0AAAADCAUABAo=.',Li='Lichfreak:AwACCAMABAoAAQ0AAAAECAQABAo=.',Ll='Lladi:AwABCAEABRQCFgAIAQihFAA5xj8CBAoAFgAIAQihFAA5xj8CBAoAAA==.',Lo='Loaded:AwAGCAEABAoAAA==.Lovepink:AwAICBIABAoAAA==.',Ma='Magharat:AwACCAIABAoAAQEAX24BCAIABRQ=.Magneeter:AwAICAgABAoAAA==.Malacanthet:AwAHCAQABAoAAA==.Maston:AwACCAIABAoAAA==.',Mc='Mccafe:AwAICAoABAoAAA==.',Me='Meekers:AwEBCAIABRQAARcASloDCAYABRQ=.Meladelm:AwAICBAABAoAAA==.Melindris:AwAGCAIABAoAAA==.',Mi='Michaelvarr:AwAICAgABAoAAA==.Minar:AwAFCAMABAoAAA==.Misarua:AwABCAEABRQAAA==.Miscreant:AwAICBAABAoAAA==.',Mo='Moegraine:AwACCAIABAoAAQ8ASv0ECAcABRQ=.Moist:AwABCAIABAoAAQkAVD8DCAYABRQ=.Moneyshaught:AwAFCAgABAoAAQ0AAAAICA4ABAo=.Monipouch:AwAGCAEABAoAAA==.Monklebowski:AwAHCAQABAoAAA==.Monkypouch:AwAECAQABAoAAA==.Moonshout:AwAFCAUABAoAAA==.Mortícia:AwADCAMABRQCDwAIAQhmBwA+KEYCBAoADwAIAQhmBwA+KEYCBAoAAA==.',Mu='Mugosbomba:AwAGCAIABAoAAA==.Murphet:AwAFCAEABAoAAA==.',Na='Nance:AwAECAgABAoAAA==.Nanidafuq:AwADCAEABAoAAA==.Nathenatra:AwABCAIABRQAAA==.Nazandeseth:AwAFCAUABAoAAQ0AAAABCAIABRQ=.',Ne='Neeko:AwAHCAwABAoAAA==.Nessä:AwADCAYABAoAAA==.',No='Nofsha:AwAECAEABAoAAQ0AAAAECAMABAo=.Nofshey:AwAECAMABAoAAA==.Nomas:AwADCAUABAoAAA==.',Oc='Ocean:AwAHCAQABAoAAA==.',Oh='Ohwellz:AwAGCBEABAoAAA==.',Ok='Okidoki:AwADCAIABAoAAA==.Okone:AwABCAIABRQDAQAIAQjpCQBQhY4CBAoAAQAHAQjpCQBTGI4CBAoAGAAHAQjYHAA9g9YBBAoAAA==.',On='Onýx:AwAICBYABAoCEAAIAQhqIwBDsV8CBAoAEAAIAQhqIwBDsV8CBAoAAA==.',Pa='Pakuru:AwAICBYABAoCGQAIAQhlEQBHn28CBAoAGQAIAQhlEQBHn28CBAoAAA==.Palxa:AwABCAIABRQCEAAIAQgdHABH4YsCBAoAEAAIAQgdHABH4YsCBAoAAA==.Papatotems:AwADCAUABAoAAA==.',Pe='Peachgobbler:AwAFCAwABAoAAA==.Pestifero:AwAECAsABAoAAA==.',Ph='Phatform:AwADCAIABAoAAA==.',Pi='Piccolö:AwAHCAEABAoAAA==.Pickwaton:AwAFCAEABAoAAA==.',Pl='Plumbus:AwABCAEABAoAAA==.',Po='Pomoz:AwAECAQABAoAAA==.Powahmove:AwADCAMABAoAAA==.Powerpeon:AwAHCAQABAoAAA==.',Pr='Praize:AwABCAEABRQCFgAIAQjiCABLAsYCBAoAFgAIAQjiCABLAsYCBAoAAA==.Prescious:AwABCAEABRQCEAAIAQjpDABYkgIDBAoAEAAIAQjpDABYkgIDBAoAAA==.',Pu='Puccii:AwAHCBAABAoAAA==.Pulp:AwAHCAgABAoAAA==.Pulpyuk:AwAECAQABAoAAA==.',Qi='Qirl:AwAFCAoABAoAAA==.',Qq='Qqoq:AwAFCAwABAoAAA==.',Ra='Ratarga:AwABCAIABRQCAQAHAQjEBgBfbs0CBAoAAQAHAQjEBgBfbs0CBAoAAA==.Ravolir:AwAECAYABAoAAA==.Rawrxdd:AwABCAEABAoAAQUASnUDCAYABRQ=.',Re='Reapersac:AwAGCBAABAoAAA==.Repentenced:AwAGCBIABAoAAA==.',Rh='Rhaenyratar:AwAFCAIABAoAAA==.',Ri='Rickyross:AwAECAQABAoAAA==.Rinaera:AwABCAEABAoAAA==.',Ro='Robinschwan:AwAGCAQABAoAAA==.Rollindirty:AwACCAIABAoAAA==.Rootgoose:AwAHCBUABAoDGQAHAQhbFwBFHi0CBAoAGQAHAQhbFwBFHi0CBAoAEgAEAQhfKwBAov4ABAoAAA==.Rorindar:AwABCAIABAoAAA==.Rotal:AwAGCAEABAoAAA==.Roxytocin:AwAECAYABAoAAA==.',Rs='Rski:AwAHCAsABAoAAA==.',['R�']='Róbin:AwACCAEABAoAAA==.',Sa='Saareebas:AwAFCAkABAoAAA==.Sachivsabal:AwACCAIABAoAAA==.Salubrious:AwABCAEABRQCEAAIAQglGABNiKcCBAoAEAAIAQglGABNiKcCBAoAAA==.',Sc='Sclubsvn:AwAHCAQABAoAAA==.',Se='Seanthedragn:AwAFCAYABAoAAA==.Seanthepally:AwABCAMABRQCEAAHAQhvMQBC2xkCBAoAEAAHAQhvMQBC2xkCBAoAAA==.Sear:AwABCAEABAoAAQ0AAAAGCAgABAo=.Secretaznman:AwAHCAQABAoAAA==.Serialheal:AwAFCAEABAoAAA==.',Sh='Shadaone:AwAICAEABAoAAA==.Shamatic:AwAECAEABAoAAA==.Shardbow:AwAGCAsABAoAAA==.Shinsoker:AwAFCAoABAoAAQ0AAAAGCBIABAo=.Shockazulu:AwAFCAQABAoAAA==.',Si='Sista:AwAGCA0ABAoAAA==.',Sk='Skonkel:AwABCAEABRQAAA==.',Sm='Smokinvibez:AwAFCAUABAoAAA==.Smðkêy:AwACCAIABAoAAA==.',Sn='Snowfury:AwABCAIABRQCBgAIAQgYAgBgxm8DBAoABgAIAQgYAgBgxm8DBAoAAA==.',Sp='Splendipulos:AwAFCAcABAoAAA==.',St='Stormshout:AwAECA0ABAoAAQ0AAAAFCAUABAo=.Stromshield:AwABCAEABRQCEAAHAQjDJQBMsFMCBAoAEAAHAQjDJQBMsFMCBAoAAA==.',Su='Subzy:AwADCAQABRQDGgAIAQiLDQBOJ2QCBAoAGgAIAQiLDQBNc2QCBAoAGwAIAQiaKQAi1a4BBAoAAA==.Sunnyz:AwADCAcABAoAAA==.Supaflash:AwACCAUABRQCHAACAQjOAgBbH9QABRQAHAACAQjOAgBbH9QABRQAAA==.Surfnturf:AwAFCAkABAoAAA==.Suri:AwACCAIABAoAAQ0AAAAGCBEABAo=.Surprisê:AwABCAEABRQAAA==.',Sy='Syross:AwADCAMABAoAAA==.',Ta='Taeko:AwADCAMABAoAAQ0AAAAHCAwABAo=.Takomi:AwAFCAMABAoAAA==.Tamalpais:AwABCAEABAoAAA==.',Te='Tenderlight:AwADCAUABAoAAA==.Tewasha:AwACCAIABAoAAA==.',Th='Thinias:AwAECAQABAoAAA==.Thobos:AwABCAIABRQCEAAIAQjuEQBPFNYCBAoAEAAIAQjuEQBPFNYCBAoAAA==.Thul:AwABCAIABRQCGwAIAQgQEABPAKECBAoAGwAIAQgQEABPAKECBAoAAA==.',To='Tolilo:AwADCAQABAoAAA==.Touches:AwAFCA0ABAoAAA==.',Tr='Tramana:AwAGCAkABAoAAA==.Trauk:AwAFCAIABAoAAA==.Truzxz:AwAGCBIABAoAAA==.',Un='Unohana:AwAECAMABAoAAQ0AAAAGCAEABAo=.',Ut='Utauric:AwAHCBUABAoCEAAHAQhTNwA7nAACBAoAEAAHAQhTNwA7nAACBAoAAA==.',Va='Vacula:AwAFCAwABAoAAA==.Vanath:AwACCAIABAoAAA==.',Ve='Veight:AwAECAsABAoAAA==.Venyia:AwAGCAcABAoAAA==.Vestra:AwAGCAwABAoAAA==.',Vy='Vyndk:AwACCAMABAoAAQ0AAAABCAEABRQ=.',Wd='Wdp:AwAFCAwABAoAAQ0AAAAGCAgABAo=.',We='Werr:AwAGCAkABAoAAA==.',Wi='Windfrey:AwABCAEABRQAAA==.',Xa='Xalazoth:AwAECAQABAoAAA==.Xavierdh:AwADCAMABAoAAA==.',Ya='Yahboibangz:AwACCAIABAoAAA==.Yamikaneki:AwAICAgABAoAAA==.Yasratcha:AwAGCAUABAoAAA==.',Yn='Ynnel:AwABCAEABAoAAA==.',Za='Zardon:AwADCAMABAoAARUAWtAICB0ABAo=.Zaubernina:AwAECAQABAoAAA==.',Zi='Zivis:AwACCAEABAoAAA==.',Zo='Zontarr:AwACCAEABAoAAA==.',['È']='Èmily:AwACCAEABAoAAA==.',['ß']='ßrightglaive:AwADCAMABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end