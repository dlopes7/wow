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
 local lookup = {'Evoker-Preservation','Priest-Holy','Priest-Shadow','Priest-Discipline','DemonHunter-Havoc','DemonHunter-Vengeance','Unknown-Unknown','Warlock-Destruction','Warlock-Demonology','Paladin-Retribution','DeathKnight-Frost','DeathKnight-Unholy','Hunter-Marksmanship','Hunter-BeastMastery','Warrior-Fury','Warrior-Arms','Warrior-Protection','Shaman-Restoration','Monk-Windwalker','Monk-Mistweaver',}; local provider = {region='US',realm="Kael'thas",name='US',type='weekly',zone=42,date='2025-03-29',data={Ad='Adowyrm:AwACCAQABRQCAQAIAQifAABa8EIDBAoAAQAIAQifAABa8EIDBAoAAA==.',Ai='Airalani:AwAHCBIABAoAAA==.',Ak='Akairo:AwAICBwABAoEAgAIAQi6DABCl1ACBAoAAgAIAQi6DABCSlACBAoAAwADAQivLQBHx+AABAoABAABAQj/VQAJni0ABAoAAA==.',Al='Alairyss:AwAFCAgABAoAAA==.Alybobwena:AwAGCBQABAoDBQAGAQj2PAAkF1ABBAoABQAGAQj2PAAislABBAoABgAFAQhVIgAhmuEABAoAAA==.',Ar='Arcaina:AwABCAEABAoAAA==.Artèmís:AwACCAEABAoAAQcAAAAECAcABAo=.',Au='Auraela:AwADCAYABAoAAA==.',Az='Azell:AwAECAkABAoAAA==.',Ba='Bajablaster:AwAECAgABAoAAA==.Bandoliers:AwADCAsABAoAAA==.',Bc='Bchung:AwADCAUABAoAAA==.',Bo='Boofstu:AwABCAMABRQDCAAHAQhwEwBKCFMCBAoACAAHAQhwEwBKCFMCBAoACQACAQhlNgARgl0ABAoAAA==.',Br='Brainiac:AwACCAIABAoAAA==.Brielle:AwAFCAUABAoAAA==.Bromide:AwAGCA0ABAoAAA==.',Bu='Buffalowings:AwAFCAoABAoAAA==.Bullymaguire:AwACCAMABAoAAQcAAAAHCAoABAo=.',Ca='Cake:AwADCAMABAoAAA==.Caliopia:AwAECAYABAoAAA==.',Ch='Chungki:AwAICAkABAoAAQcAAAAICAsABAo=.',Co='Cobellex:AwABCAEABAoAAA==.',Da='Dadson:AwAICBAABAoAAA==.Dashyll:AwACCAIABAoAAA==.Dazzlight:AwAICBwABAoCCgAIAQgRJgBBiVsCBAoACgAIAQgRJgBBiVsCBAoAAA==.',De='Deathreâper:AwAICBAABAoAAA==.Deathswitch:AwAICBAABAoAAA==.Demacus:AwAICA8ABAoAAA==.Demeter:AwAECAkABAoAAA==.',Do='Dookiee:AwAFCAwABAoAAA==.Douglasquaíd:AwAICAgABAoAAA==.',Dr='Drat:AwAECAQABAoAAA==.Drimbarn:AwAICAgABAoAAA==.',Du='Dude:AwABCAEABAoAAQcAAAAFCAQABAo=.',Eb='Ebojager:AwADCAsABAoAAA==.',Ei='Eibon:AwABCAIABRQDCwAIAQgLAwBZpcICBAoACwAIAQgLAwBWPsICBAoADAAGAQjnIwA6O6gBBAoAAA==.',Es='Eskath:AwACCAMABAoAAA==.',Ev='Evapankowski:AwAECAcABAoAAA==.',Fe='Felipito:AwACCAIABAoAAA==.Ferrara:AwACCAIABRQDDQAHAQijBABdecoCBAoADQAHAQijBABdecoCBAoADgAEAQigaQA/7fMABAoAAA==.',Fi='Fijesekebien:AwAECAsABAoAAA==.',Fl='Flandri:AwABCAIABRQCAgAIAQjlAABe/lgDBAoAAgAIAQjlAABe/lgDBAoAAA==.',Ga='Gabaghoul:AwAHCBIABAoAAA==.Galnarn:AwABCAEABRQAAA==.',Go='Goop:AwAHCAoABAoAAA==.',Gr='Graylock:AwABCAEABAoAAA==.Griimm:AwABCAEABAoAAA==.',Ha='Hackitz:AwAICAgABAoAAA==.Hail:AwAECAQABAoAAA==.Hammdruid:AwACCAIABAoAAA==.Hammwar:AwAECAQABAoAAA==.Harambesdik:AwAICBkABAoCDQAIAQhfAgBY6BYDBAoADQAIAQhfAgBY6BYDBAoAAA==.',Id='Idotsalots:AwAECAQABAoAAA==.',Im='Imtheteapot:AwAGCBQABAoDDwAGAQhXMQAbUkwBBAoADwAGAQhXMQAbUkwBBAoAEAACAQhTRQAEPSgABAoAAA==.',Is='Issidora:AwACCAIABAoAAA==.',Ja='Jakeakuma:AwABCAEABRQCCQAHAQiRBwA/6foBBAoACQAHAQiRBwA/6foBBAoAAA==.Jarco:AwAHCAEABAoAAA==.',Ju='Julio:AwAECAcABAoAAA==.',Ka='Kaashaa:AwAHCAIABAoAAA==.',Ki='Kiiras:AwAECAcABAoAAA==.Kimoora:AwABCAEABAoAAA==.',Kl='Klefthoof:AwAICAoABAoAAQcAAAAICA8ABAo=.',Ku='Kungfoo:AwADCAcABAoAAA==.',La='Ladrellena:AwAICAgABAoAAA==.',Le='Legaloas:AwAFCAIABAoAAA==.Leondero:AwAGCBMABAoAAA==.Leyla:AwADCAMABAoAAA==.',Li='Lildrinky:AwADCAMABAoAAA==.',Lo='Loanna:AwAHCAYABAoAAA==.',['L�']='Lèdrollan:AwAICBIABAoAAA==.Lîly:AwACCAQABAoAAA==.',Ma='Maut:AwAICAgABAoAAA==.Maz:AwAFCAcABAoAAA==.',Mo='Mogrungar:AwAECAIABAoAAA==.Monkpie:AwADCAMABAoAAREAWpoCCAQABRQ=.Moofaace:AwABCAEABAoAAA==.',My='Mypalshifty:AwAECAQABAoAAA==.',Na='Naasirr:AwACCAMABAoAAA==.Natureswish:AwAHCBIABAoAAA==.',Ne='Nekrautik:AwAHCA4ABAoAAA==.',Ni='Nightcrest:AwADCAMABAoAAQcAAAAGCA0ABAo=.Nighthydra:AwAGCA0ABAoAAA==.',Nu='Nuhpie:AwACCAQABRQEEQAIAQi5AQBamu8CBAoAEQAIAQi5AQBYQu8CBAoAEAAFAQiVFQBCb6ABBAoADwACAQjoSwBNPKwABAoAAA==.',Ny='Nymphetamine:AwADCAMABAoAAA==.',Ol='Olimdar:AwACCAIABRQCEgAIAQi2AABhdWQDBAoAEgAIAQi2AABhdWQDBAoAAA==.',Or='Oricelle:AwAECAYABAoAAA==.',Pa='Palagrim:AwABCAEABAoAAA==.Pandulce:AwAECAYABAoAAA==.',Pe='Peachie:AwADCAcABAoAAA==.',Po='Pokypineaple:AwAHCAIABAoAAA==.Pompouspear:AwADCAYABAoAAA==.',['P�']='Pèrsephone:AwABCAEABAoAAA==.',Ra='Raisha:AwAECAQABAoAAA==.Raitan:AwADCAMABAoAAA==.',Ru='Ruckus:AwABCAEABAoAAA==.',Sa='Sandkat:AwAICAsABAoAAA==.Saray:AwAECAIABAoAAA==.',Sh='Shanny:AwADCAIABAoAAA==.',Si='Singars:AwADCAcABAoAAA==.Sinto:AwAFCAQABAoAAA==.',Sk='Skaterboi:AwABCAEABAoAAA==.',Sm='Smores:AwAECAYABAoAAA==.',So='Souno:AwAICBAABAoAAA==.',Sp='Spacedmysts:AwACCAIABAoAAA==.Sprodage:AwAECAgABAoAAA==.Spåwny:AwACCAEABAoAAA==.',St='Stylö:AwAECAMABAoAAA==.',Sw='Swtmystic:AwAGCBAABAoAAA==.',Sy='Synth:AwAICAcABAoAAA==.',Te='Tekvet:AwAICBAABAoCCgAIAQhGzAAIgHwABAoACgAIAQhGzAAIgHwABAoAAA==.Temptress:AwAICAkABAoAAA==.',To='Tonee:AwAECAUABAoAAA==.Toscus:AwABCAEABRQAAA==.Totemjunkie:AwAICAgABAoAAA==.',Un='Unclepeepers:AwACCAUABRQDEwACAQg1BQBMobkABRQAEwACAQg1BQBMobkABRQAFAABAQigFQAViDwABRQAAA==.',Ur='Urtag:AwABCAEABAoAAQMAU3ACCAMABRQ=.',Vi='Vilevixon:AwAFCAYABAoAAA==.',Wa='Wakabombo:AwAGCAEABAoAAA==.',We='Weyekîn:AwAECAYABAoAAA==.',Ye='Yeah:AwAECAYABAoAAA==.',Zi='Zionspartan:AwAFCAoABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end