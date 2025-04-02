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
 local lookup = {'Mage-Frost','Unknown-Unknown','Warrior-Arms','Paladin-Retribution','DemonHunter-Havoc','Warrior-Fury','Evoker-Preservation','Druid-Restoration','Paladin-Holy','Warlock-Destruction','Warlock-Demonology','Shaman-Enhancement','Shaman-Elemental','Shaman-Restoration','Hunter-BeastMastery','Evoker-Devastation','DeathKnight-Blood','Priest-Shadow','Rogue-Subtlety','Rogue-Assassination','Priest-Holy','Mage-Fire','Mage-Arcane','DeathKnight-Unholy','DeathKnight-Frost','Hunter-Survival','Monk-Windwalker','Druid-Guardian',}; local provider = {region='US',realm='Kilrogg',name='US',type='weekly',zone=42,date='2025-03-29',data={Ab='Abartheris:AwAICAkABAoAAA==.',Al='Alassomorph:AwADCAQABAoAAA==.Albus:AwAHCBgABAoCAQAHAQj1CABaf6wCBAoAAQAHAQj1CABaf6wCBAoAAA==.Allayna:AwAGCA0ABAoAAA==.Alline:AwAGCA0ABAoAAA==.Aloha:AwAGCA8ABAoAAA==.Alssrasanre:AwACCAIABAoAAA==.',Am='Amishdk:AwAHCA8ABAoAAQIAAAACCAIABRQ=.',An='Andja:AwAICBwABAoCAwAIAQhkAABht38DBAoAAwAIAQhkAABht38DBAoAAA==.Anexa:AwADCAQABAoAAA==.Angela:AwABCAEABAoAAA==.Annastriana:AwABCAMABAoAAA==.',Ar='Arayne:AwAGCBQABAoCBAAGAQiKOABTvwcCBAoABAAGAQiKOABTvwcCBAoAAA==.',As='Ashyslashee:AwAFCA0ABAoAAA==.',Ba='Baalea:AwACCAIABAoAAA==.',Be='Benebeorn:AwAICBUABAoCBQAIAQgYEQBNIKMCBAoABQAIAQgYEQBNIKMCBAoAAA==.Berrie:AwADCAMABAoAAA==.',Bj='Bjorninnside:AwAGCBcABAoCBgAGAQh4KgAlIX0BBAoABgAGAQh4KgAlIX0BBAoAAA==.',Bl='Blüéçhew:AwACCAIABAoAAA==.',Bo='Bobbysmerica:AwABCAEABRQAAA==.Bollux:AwADCAYABAoAAA==.Bop:AwAECAUABAoAAQIAAAAFCAoABAo=.',Br='Braxte:AwAGCA0ABAoAAA==.',Bu='Buggies:AwABCAEABRQCAQAIAQh8AQBhQGEDBAoAAQAIAQh8AQBhQGEDBAoAAA==.Buggs:AwADCAcABAoAAQEAYUABCAEABRQ=.Buldozz:AwAFCAsABAoAAA==.Burnination:AwACCAMABAoAAA==.',Ca='Cameocreme:AwAECAQABAoAAA==.',Ce='Ceenit:AwAFCA8ABAoAAA==.Celawyn:AwACCAIABAoAAA==.',Ch='Cheddarbob:AwACCAIABRQAAA==.',Cl='Cloudsmoker:AwACCAIABAoAAA==.',Co='Coldstone:AwABCAEABAoAAA==.Cooldurance:AwAFCAkABAoAAA==.Cormir:AwADCAMABAoAAA==.',Da='Danklins:AwAGCA0ABAoAAA==.Darthvada:AwADCAQABAoAAA==.Daywalker:AwAECAQABAoAAA==.',De='Deathzgrace:AwAHCA4ABAoAAA==.Demonaria:AwAGCA0ABAoAAA==.Deroz:AwAECAYABAoAAQIAAAAGCAEABAo=.Devilhandler:AwAHCAwABAoAAA==.',Dh='Dhoro:AwAFCAEABAoAAA==.',Di='Disk:AwADCAMABAoAAA==.Divalulu:AwADCAQABAoAAQcAOc0DCAcABRQ=.',Do='Dotcom:AwADCAQABAoAAA==.',Dr='Dracheo:AwABCAEABRQCAQAIAQjRBABZfQEDBAoAAQAIAQjRBABZfQEDBAoAAA==.Dranix:AwADCAMABAoAAA==.Droiden:AwADCAQABAoAAA==.Dromps:AwADCAQABAoAAA==.',Du='Dumichauch:AwABCAEABRQCCAAIAQg1CQBFVG8CBAoACAAIAQg1CQBFVG8CBAoAAA==.',Ee='Eedrah:AwABCAIABAoAAA==.',Ek='Ekhor:AwACCAIABAoAAA==.',Em='Emofriz:AwADCAcABAoAAA==.',Er='Er:AwABCAEABAoAAA==.',Ew='Ewik:AwAFCAwABAoAAA==.',Fa='Faent:AwADCAcABAoAAA==.Falinora:AwABCAEABRQDCQAIAQg6BQBHgpACBAoACQAIAQg6BQBHgpACBAoABAAHAQiXYwAbk2sBBAoAAA==.',Fe='Feylemental:AwAHCBIABAoAAA==.',Fi='Fitzchivalry:AwABCAEABAoAAA==.',Fl='Flomlock:AwAGCA0ABAoAAA==.',Fo='Forcewild:AwACCAIABAoAAA==.Foxdh:AwACCAIABAoAAA==.',Fr='Francesca:AwAFCAoABAoAAA==.Friz:AwAICBYABAoDCgAIAQgdHAA/+AcCBAoACgAHAQgdHABEeAcCBAoACwADAQjFJwAtLawABAoAAA==.Frostitut:AwAGCAsABAoAAA==.Frostynipzz:AwABCAEABAoAAA==.',Fu='Fussell:AwABCAEABAoAAA==.Fuzzychunks:AwABCAIABAoAAA==.',Ga='Garruto:AwAGCA0ABAoAAA==.Gazug:AwAICBcABAoCDAAIAQi9EAAxWzICBAoADAAIAQi9EAAxWzICBAoAAA==.',Go='Goonthar:AwADCAUABRQCBgADAQhNBgAtb/wABRQABgADAQhNBgAtb/wABRQAAA==.Gottafly:AwAECAcABAoAAA==.',Gr='Greatballs:AwAFCAoABAoAAA==.Grindpika:AwAGCAwABAoAAA==.Grompo:AwABCAEABRQDDQAIAQjlDgBOhEUCBAoADQAHAQjlDgBPVEUCBAoADgACAQhuXABGK5QABAoAAA==.',Gu='Guccicarryon:AwACCAIABAoAAA==.',Gw='Gwegg:AwADCAYABAoAAA==.',Gy='Gynx:AwAHCBUABAoCBAAHAQiJKwBMrUACBAoABAAHAQiJKwBMrUACBAoAAA==.',Ha='Hairyteeth:AwABCAEABAoAAA==.Harulen:AwAFCAoABAoAAA==.',Hi='Hikang:AwAICAgABAoAAA==.',Ho='Holycreambar:AwAGCA0ABAoAAA==.',Hu='Huslangr:AwADCAMABAoAAA==.',Hy='Hygelak:AwABCAMABAoAAA==.',Ia='Iamgess:AwADCAcABAoAAA==.',Ib='Ibpowerline:AwABCAIABAoAAA==.',Im='Imbarryobama:AwAECAMABAoAAA==.',Ja='Jard:AwACCAMABAoAAA==.',Je='Jeraby:AwAGCAsABAoAAA==.',Jo='Jofdor:AwACCAIABAoAAA==.',Ju='Judgenawt:AwAFCAkABAoAAA==.',Ka='Kaiten:AwAECAMABAoAAA==.Karzen:AwAGCAwABAoAAA==.Kawalsky:AwAGCAwABAoAAA==.',Kh='Khorruc:AwAICAgABAoAAA==.',Ki='Killigula:AwACCAEABAoAAA==.',Ko='Korash:AwAGCAEABAoAAA==.',Ku='Kungfudou:AwADCAEABAoAAA==.',La='Lamora:AwABCAEABRQAAA==.Larissah:AwADCAUABAoAAA==.',Le='Leara:AwADCAMABAoAAQ8ARZ0BCAEABRQ=.Legomyagro:AwAGCA0ABAoAAA==.',Li='Lishal:AwABCAEABAoAAA==.Lizzia:AwAFCAwABAoAAA==.',Ma='Macanese:AwADCAcABAoAAA==.Macee:AwACCAIABAoAAA==.Mad:AwABCAEABAoAAA==.Maery:AwABCAEABAoAAA==.Manachi:AwADCAYABAoAAA==.Margad:AwAECAQABAoAAA==.Matchamist:AwADCAcABAoAAA==.Mayhemfox:AwADCAcABRQDBwADAQjeAgA5zYYABRQABwACAQjeAgA3CYYABRQAEAACAQhlCgAI4FAABRQAAA==.',Mc='Mcjudgin:AwAGCA4ABAoAAA==.',Me='Melinda:AwACCAIABAoAAA==.',Mi='Mimiker:AwABCAEABRQCEAAIAQidDQA6lC0CBAoAEAAIAQidDQA6lC0CBAoAAA==.Mimilock:AwADCAcABAoAARAAOpQBCAEABRQ=.Mirabella:AwADCAYABAoAAA==.Mizahella:AwABCAEABAoAAA==.',Mo='Mokei:AwADCAMABAoAAA==.Monkeybonez:AwAECAkABAoAAA==.Moonsilver:AwADCAcABAoAAA==.Mornak:AwAICAcABAoAAA==.Mourn:AwABCAEABRQCEQAIAQi/CABHHHQCBAoAEQAIAQi/CABHHHQCBAoAAA==.',Mu='Muertomarrow:AwABCAMABAoAAA==.',Na='Narcoleptik:AwABCAEABAoAAA==.Nasrith:AwAGCA0ABAoAAA==.Nastro:AwABCAEABAoAAA==.Nawtishot:AwAGCBEABAoAAA==.',No='Noimia:AwAFCAkABAoAAA==.',Od='Oden:AwAGCAIABAoAAA==.',Ok='Oksanabaiul:AwABCAEABRQCDAAIAQgsCwBIWZECBAoADAAIAQgsCwBIWZECBAoAAA==.',Pa='Padray:AwAICBgABAoCEgAIAQikEAA4mSoCBAoAEgAIAQikEAA4mSoCBAoAAA==.Panhia:AwACCAIABAoAAA==.',Pe='Peaseblossom:AwAGCAsABAoAAA==.Pelasius:AwABCAEABAoAAA==.Pepperbottom:AwAGCAEABAoAAA==.',Ph='Phantasos:AwADCAUABAoAAA==.',Ra='Raeagald:AwADCAQABAoAAREARxwBCAEABRQ=.Random:AwAFCAIABAoAAA==.Raveniss:AwAECAsABAoAAA==.',Re='Reconetta:AwAHCBUABAoDEwAHAQiwCwBCZD4CBAoAEwAHAQiwCwBCZD4CBAoAFAABAQg5KwAgHkMABAoAAA==.',Rh='Rhymulus:AwABCAEABAoAAA==.',Ri='Rissaria:AwABCAEABRQCFQAIAQiYAQBeuTkDBAoAFQAIAQiYAQBeuTkDBAoAAA==.',Ro='Roll:AwAFCAoABAoAAA==.Rotation:AwACCAIABAoAAA==.',Ru='Rudewenn:AwADCAcABAoAAA==.',Sa='Saburz:AwAECA4ABAoAAA==.Sarutobii:AwADCAMABAoAAA==.Sañtoro:AwACCAUABAoAAA==.',Se='Serens:AwACCAIABAoAAA==.',Sh='Shalako:AwACCAIABAoAAA==.Shaniallon:AwAGCAYABAoAAA==.Shiroh:AwAICAoABAoAAA==.',Si='Silentbruce:AwAICBQABAoDFgAIAQgVJAArzOUBBAoAFgAIAQgVJAArDOUBBAoAFwADAQjGCQAnOJAABAoAAA==.Silentchill:AwAGCAEABAoAAA==.Sinomen:AwAICB4ABAoCDAAIAQi4BABVTgkDBAoADAAIAQi4BABVTgkDBAoAAA==.',Sk='Skyblue:AwAECAkABAoAAA==.',St='Stampa:AwADCAcABAoAAA==.Stygian:AwABCAEABRQCBQAIAQhFGwA+M0ECBAoABQAIAQhFGwA+M0ECBAoAAA==.',Su='Sudimmoc:AwABCAEABRQDGAAIAQglCwBLDaoCBAoAGAAIAQglCwBLDaoCBAoAGQADAQi0GQAbsZcABAoAAA==.',Ta='Tabby:AwABCAEABAoAAA==.Tanyaharding:AwADCAUABAoAAA==.Tarîs:AwAECAoABAoAAA==.Tawneestone:AwAGCA4ABAoAAA==.',Th='Theldara:AwABCAEABRQCDwAIAQi2GABFnZECBAoADwAIAQi2GABFnZECBAoAAA==.Thoreen:AwABCAEABAoAAA==.Thrish:AwABCAEABRQDDwAIAQgWFgBKvqgCBAoADwAIAQgWFgBKvqgCBAoAGgACAQg1EAAP7VYABAoAAA==.Thundercry:AwAICAgABAoAAA==.Thunderfist:AwABCAEABRQCGwAIAQgECABQTr4CBAoAGwAIAQgECABQTr4CBAoAAA==.',Ti='Timothy:AwAICBIABAoAAA==.',To='Tomacco:AwABCAIABAoAAA==.',Tr='Trialdo:AwACCAEABAoAAA==.',Ty='Tyriais:AwACCAIABAoAAA==.',Va='Vayne:AwAICBcABAoDAwAIAQj0CABC/GkCBAoAAwAIAQj0CABC/GkCBAoABgACAQj1XAAfl1kABAoAAA==.',Vi='Vinge:AwEDCAcABAoAAA==.Violetrain:AwAECAcABAoAAA==.',Vy='Vyzualize:AwACCAQABRQCCQAIAQgCAgBaGQADBAoACQAIAQgCAgBaGQADBAoAAA==.',Wa='Wargram:AwABCAIABAoAAA==.Wauwen:AwAGCAEABAoAAA==.',We='Wednesdáy:AwAECAsABAoAAA==.Weeps:AwABCAEABRQCHAAIAQgMAQBSV+QCBAoAHAAIAQgMAQBSV+QCBAoAAA==.Wept:AwADCAMABAoAAA==.',Wi='Wiccked:AwAECAgABAoAAA==.Windrange:AwADCAMABAoAAA==.Wintérhoof:AwADCAMABAoAAA==.',Wo='Woodscale:AwABCAEABAoAAA==.',Xi='Xisle:AwACCAMABAoAAA==.',Ye='Yergat:AwABCAEABRQCDwAIAQhVBgBcTTsDBAoADwAIAQhVBgBcTTsDBAoAAA==.',Yu='Yupa:AwAECAMABAoAAA==.',Za='Zainea:AwABCAIABRQDFQAHAQjsDABJwU4CBAoAFQAHAQjsDABJwU4CBAoAEgABAQhwTwAIGSIABAoAAA==.',Ze='Zeeningg:AwACCAIABAoAAA==.Zelrex:AwABCAEABRQDEwAIAQgJCwBKdE4CBAoAEwAIAQgJCwA9oE4CBAoAFAAGAQiCDABFmOUBBAoAAA==.',Zi='Ziga:AwAGCA0ABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end