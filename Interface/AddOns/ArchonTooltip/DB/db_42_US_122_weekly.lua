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
 local lookup = {'Monk-Mistweaver','Shaman-Enhancement','Mage-Frost','Rogue-Subtlety','Mage-Fire','Unknown-Unknown','DemonHunter-Havoc','Druid-Feral','Druid-Balance','Priest-Discipline','Paladin-Holy','Priest-Shadow','Warlock-Demonology','Warlock-Affliction','Warlock-Destruction','Hunter-BeastMastery','DeathKnight-Unholy','Evoker-Devastation','Shaman-Restoration','Priest-Holy','DeathKnight-Blood','Warrior-Fury','Warrior-Arms','Paladin-Protection','Hunter-Marksmanship','Paladin-Retribution','Warrior-Protection','DeathKnight-Frost',}; local provider = {region='US',realm='Icecrown',name='US',type='weekly',zone=42,date='2025-03-28',data={Aa='Aayria:AwACCAIABAoAAA==.',Ac='Aceknight:AwAFCAEABAoAAA==.',Ad='Adrinor:AwACCAIABAoAAA==.Adzman:AwAICA8ABAoAAA==.',Ae='Aeryx:AwAHCAEABAoAAA==.',Ak='Akatash:AwAFCAcABAoAAA==.',Al='Alaric:AwAFCAMABAoAAA==.Alf:AwACCAIABAoAAA==.Alisterr:AwABCAEABAoAAA==.Alistèr:AwABCAEABAoAAA==.',Am='Amishbert:AwAFCA4ABAoAAA==.Amor:AwABCAIABRQCAQAGAQgCDgBb0l0CBAoAAQAGAQgCDgBb0l0CBAoAAA==.',An='Andelle:AwADCAYABAoAAA==.',Ar='Arcaneoak:AwAECAYABAoAAA==.Archaladin:AwAGCAYABAoAAA==.Arisaris:AwABCAEABRQCAgAIAQggFAAiC/cBBAoAAgAIAQggFAAiC/cBBAoAAA==.',As='Aseeltare:AwABCAEABRQAAA==.Ashaloria:AwADCAkABAoAAA==.',At='Atagfu:AwAECAQABAoAAA==.',Au='Austin:AwAGCAYABAoAAA==.',Av='Avaren:AwABCAEABRQCAwAHAQhjCgBU2o8CBAoAAwAHAQhjCgBU2o8CBAoAAA==.Avareno:AwAECAYABAoAAQMAVNoBCAEABRQ=.Avarens:AwAECAQABAoAAQMAVNoBCAEABRQ=.Aveno:AwABCAEABAoAAA==.',Aw='Awake:AwABCAEABRQAAA==.',Ba='Baboonsteve:AwAECAsABRQCBAAEAQhgAQAy8F0BBRQABAAEAQhgAQAy8F0BBRQAAA==.Baggins:AwAFCAgABAoAAA==.Baldenergy:AwAECAQABAoAAA==.Bandledin:AwABCAEABAoAAA==.',Be='Bellis:AwABCAEABAoAAA==.Bellonà:AwACCAIABAoAAA==.',Bi='Bigjustice:AwAHCA4ABAoAAA==.',Bj='Bjorne:AwAFCAcABAoAAA==.',Bl='Blammo:AwADCAUABAoAAA==.Blinkdh:AwAECAYABAoAAA==.Blinkmadge:AwAFCAsABRQCBQAFAQh5AABLef4BBRQABQAFAQh5AABLef4BBRQAAA==.Bloodsøng:AwACCAIABAoAAA==.',Bo='Bokchoy:AwAECAIABAoAAA==.Bombadil:AwAICAEABAoAAA==.',Bu='Bubbledin:AwAHCAsABAoAAA==.Burdell:AwAFCAoABAoAAA==.Burleb:AwAFCAkABAoAAA==.',Ca='Calorenn:AwAFCAYABAoAAA==.Calòren:AwADCAcABAoAAQYAAAAFCAYABAo=.Caramisu:AwACCAMABRQAAQEAKSAFCAoABRQ=.Carnelius:AwABCAEABAoAAQYAAAAGCAwABAo=.Catfood:AwABCAEABRQCBwAIAQg+AQBg6nsDBAoABwAIAQg+AQBg6nsDBAoAAA==.',Ce='Cerrundan:AwAHCAsABAoAAA==.',Ch='Chickenism:AwEFCA8ABRQDCAAFAQgfAABZNVEBBRQACQAEAQjXAABf75ABBRQACAADAQgfAABVH1EBBRQAAA==.Chideep:AwACCAMABAoAAA==.Chowtime:AwAFCAgABAoAAA==.',Cl='Clamps:AwACCAQABRQAAA==.Clandon:AwAECA0ABRQCCgAEAQjLAABN+4QBBRQACgAEAQjLAABN+4QBBRQAAA==.',Co='Coolers:AwACCAEABAoAAA==.',Cr='Cross:AwAHCBQABAoCCwAHAQihDAA8COIBBAoACwAHAQihDAA8COIBBAoAAA==.',Ct='Ctyxia:AwACCAIABAoAAA==.',Da='Daax:AwAECAYABAoAAA==.Dannypand:AwABCAEABAoAAA==.Darroon:AwAECA8ABRQCDAAEAQj1AABTbYoBBRQADAAEAQj1AABTbYoBBRQAAA==.Darroonx:AwAHCAwABAoAAQwAU20ECA8ABRQ=.Dawntodusk:AwABCAEABAoAAA==.Daximus:AwADCAUABAoAAQYAAAAECAYABAo=.Daymann:AwAFCAgABAoAAA==.Daztreides:AwAGCBIABAoAAA==.',De='Deadion:AwAGCAwABAoAAA==.Deadpaly:AwACCAIABAoAAQYAAAAGCAwABAo=.Derraa:AwAECAEABAoAAA==.',Dh='Dhunterrage:AwABCAEABAoAAQYAAAACCAIABAo=.',Di='Diamf:AwAFCAcABAoAAA==.Dinowen:AwAECAsABAoAAA==.Dirge:AwAGCA0ABAoAAA==.Dithia:AwAFCAcABAoAAA==.',Do='Doohoo:AwACCAIABAoAAA==.Dotbush:AwABCAIABRQEDQAGAQhvCABCudoBBAoADQAGAQhvCABCudoBBAoADgACAQgBIgAQcVgABAoADwABAQifggAtAiQABAoAAA==.',Dr='Dragoness:AwACCAIABAoAAA==.Dragonlyfans:AwABCAEABAoAAA==.Drippinboner:AwAFCAUABAoAAA==.',Du='Durota:AwAGCA0ABAoAAA==.',Dz='Dzzy:AwAECAwABRQCEAAEAQgXAQBVdJwBBRQAEAAEAQgXAQBVdJwBBRQAAA==.',['D�']='Déâth:AwACCAIABAoAAA==.',Ec='Ectos:AwACCAIABAoAAQYAAAAGCBEABAo=.Ectoz:AwAGCBEABAoAAA==.Ectyxx:AwAGCAwABAoAAA==.',El='Elsmasher:AwADCAMABAoAAA==.Elwynn:AwAECAIABAoAAA==.',En='Enkharna:AwACCAIABAoAAA==.',Es='Esoteric:AwAFCAYABAoAAA==.',Fa='Faet:AwAFCAsABAoAAA==.Faeyt:AwAECAUABAoAAA==.Falroy:AwAFCAoABAoAAA==.Farsighted:AwADCAMABAoAAA==.Faye:AwABCAEABAoAAA==.',Fe='Feedtheiron:AwAECAkABAoAAA==.Felmord:AwAFCAUABAoAAQYAAAAICAcABAo=.',Fi='Fierystrangr:AwAECAoABAoAAA==.Filigree:AwACCAIABAoAAA==.Finesthour:AwAFCBAABRQCEQAFAQgbAABFAOQBBRQAEQAFAQgbAABFAOQBBRQAAA==.',Fl='Flowérs:AwAECAMABAoAAA==.Fluxy:AwAFCAoABAoAAA==.',Fo='Fonzie:AwAICAYABAoAAA==.',Fr='Freshmagus:AwAGCBcABAoCBQAGAQjPJwBIl70BBAoABQAGAQjPJwBIl70BBAoAAA==.',Ga='Galkthyr:AwADCAEABAoAAQYAAAAHCA8ABAo=.Gampshwago:AwAFCAwABRQCEgAFAQhiAABO5+0BBRQAEgAFAQhiAABO5+0BBRQAAA==.Garronan:AwAFCA4ABRQCEAAFAQhCAABR5hECBRQAEAAFAQhCAABR5hECBRQAAA==.',Ge='Geveesa:AwAECAUABAoAAA==.',Gh='Ghor:AwACCAIABAoAAA==.',Gi='Gimixxpriest:AwABCAEABAoAAA==.',Gr='Grayfoxx:AwAECAIABAoAAA==.Greenny:AwADCAUABAoAAA==.Grimgrín:AwAECAEABAoAAA==.Grindder:AwABCAEABAoAAA==.Grindthor:AwAGCA8ABAoAAA==.Grunky:AwAICBcABAoCEwAIAQgGBQBaGPECBAoAEwAIAQgGBQBaGPECBAoAARQAUW8FCA8ABRQ=.',Gu='Gustofists:AwAICAgABAoAAA==.',Ha='Hamoron:AwAGCAUABAoAAA==.Hankdatank:AwABCAEABAoAAA==.',He='Healixes:AwAGCAkABAoAAA==.',Ho='Hooshmazu:AwABCAEABAoAAA==.',['H�']='Hâzél:AwAECAcABAoAAA==.Hëllräisër:AwABCAEABAoAAA==.Hôlystôrm:AwAECAQABAoAAA==.',Ik='Ikmaginesham:AwAECAEABAoAAA==.',Il='Illinivich:AwABCAIABRQCFQAIAQi8BABUruQCBAoAFQAIAQi8BABUruQCBAoAAA==.',Im='Immortal:AwAFCA4ABRQDFgAFAQhCAABOngUCBRQAFgAFAQhCAABOAgUCBRQAFwADAQgzAQA1LO8ABRQAAA==.',In='Inei:AwABCAEABAoAAA==.Invokor:AwAGCAwABAoAAA==.',Ja='Jackstone:AwADCAQABAoAAA==.Jadefox:AwAGCA4ABAoAAA==.Jaedemon:AwAFCAMABAoAAA==.',Je='Jerlion:AwABCAEABRQAAA==.',Ju='Jumpies:AwABCAEABAoAAA==.Jumplol:AwAFCA4ABAoAAA==.Jur:AwAECAUABAoAAA==.Juunbroh:AwAGCA0ABAoAAA==.',Ka='Kaarin:AwADCAQABAoAAQYAAAAFCAcABAo=.Kalid:AwAFCA8ABRQCFAAFAQgMAABRb+ABBRQAFAAFAQgMAABRb+ABBRQAAA==.Kallandras:AwEFCAwABAoAAA==.Kalpanda:AwAGCBEABAoAAA==.Kargan:AwABCAEABAoAAA==.',Ke='Kedrak:AwAFCA8ABAoAAA==.Kevret:AwADCAYABAoAAA==.',Kh='Khaelian:AwAHCBAABAoAAA==.',Ki='Kitmeup:AwAFCA0ABAoAAA==.',Ko='Kommit:AwAFCBAABRQCGAAFAQgOAABg2ysCBRQAGAAFAQgOAABg2ysCBRQAAA==.',Kr='Kriko:AwADCAUABAoAAA==.',Ky='Kylar:AwABCAEABAoAAQYAAAAECAcABAo=.Kymiro:AwAFCBAABRQCBwAFAQgzAABUlx0CBRQABwAFAQgzAABUlx0CBRQAAA==.Kynigós:AwAECAsABAoAAA==.Kynir:AwAFCAsABAoAAA==.',['K�']='Käthryn:AwADCAMABAoAAA==.',La='Lapretrise:AwAECAYABAoAAA==.',Le='Leobardo:AwAFCAsABAoAAA==.',Li='Lilwár:AwACCAMABAoAAQYAAAABCAEABRQ=.Littlemorsel:AwABCAIABAoAAA==.',Lo='Lonie:AwAFCAsABAoAAA==.',Ma='Mackzsh:AwABCAEABRQAAA==.Madlarkin:AwAFCAIABAoAAA==.Manech:AwADCAUABAoAAA==.Markoramius:AwAECAUABAoAAA==.Maxcrits:AwAECAUABAoAAA==.',Me='Meen:AwAECAUABAoAAA==.Meganpriest:AwAICBgABAoDDAAIAQiMBgBL69oCBAoADAAIAQiMBgBL69oCBAoAFAABAQg4XwAMijQABAoAAA==.Mekhasingh:AwACCAMABAoAAA==.Metap:AwABCAEABRQAAA==.',Mi='Miilyia:AwAHCBoABAoCGQAHAQhbBgBY7pMCBAoAGQAHAQhbBgBY7pMCBAoAAA==.Mikelabz:AwAHCAEABAoAAA==.Mirah:AwAICAEABAoAAA==.Misfired:AwAECAYABAoAAQYAAAAGCAkABAo=.',Mo='Mogriya:AwAHCAQABAoAAA==.Mokt:AwACCAIABAoAAA==.Mollywhop:AwAECAgABAoAAA==.Monkie:AwAECAQABAoAAA==.Montee:AwAGCBMABAoAAA==.Mowgli:AwAICAgABAoAAA==.',Mu='Mugu:AwADCAQABAoAAA==.Murph:AwAFCAsABAoAAA==.',My='Myeyeonu:AwAFCA0ABAoAAA==.Mysterydrac:AwAECAwABAoAAA==.',['M�']='Míra:AwAGCAwABAoAAA==.',Na='Nachtengel:AwAECAUABAoAAA==.Naeomi:AwADCAIABAoAAA==.Nagda:AwACCAEABAoAAA==.',Ne='Neaya:AwABCAEABAoAAQYAAAAGCBEABAo=.Necromantic:AwAECAgABAoAAA==.Necrotîc:AwAECAUABAoAAA==.Nesaru:AwAECAoABAoAAA==.',Ni='Nines:AwACCAIABAoAAA==.Ningehzidda:AwABCAEABAoAAA==.Nisaloth:AwAFCBEABAoAAA==.',No='Nontoxic:AwAGCBAABAoAAA==.',Nu='Nual:AwAFCAwABAoAAA==.Nudag:AwADCAUABAoAAA==.',Oa='Oathpact:AwAICCEABAoCGgAIAQjTAgBiY2wDBAoAGgAIAQjTAgBiY2wDBAoAAA==.',Ol='Older:AwAGCA0ABAoAAA==.Olk:AwAGCA4ABAoAAA==.',Oo='Oopssh:AwAECAUABAoAAA==.',Or='Oreganow:AwAFCA4ABRQEDQAFAQitAABVSM4ABRQADwAEAQjcAgAfaBkBBRQADQACAQitAABMP84ABRQADgACAQgeAwBaV8EABRQAAA==.',Os='Osterkush:AwAECAEABAoAAA==.',Ot='Otogison:AwAECAMABAoAAA==.Otterinvater:AwAGCAYABAoAAQYAAAADCAMABRQ=.',Pe='Perfectguy:AwAFCAsABAoAAA==.Petmybeast:AwAECAgABAoAAA==.Petuski:AwAFCAgABAoAAA==.Pewpewism:AwEBCAEABRQAAQgAWTUFCA8ABRQ=.',Ph='Phriaa:AwADCAYABAoAAA==.',Pi='Pingu:AwADCAYABRQCEwADAQiHAQBaBkEBBRQAEwADAQiHAQBaBkEBBRQAAA==.Pisman:AwADCAYABAoAAA==.',Pl='Planckshadow:AwAFCAUABAoAARIAVkADCAYABRQ=.',Po='Popicus:AwAECAYABAoAAA==.Pounce:AwAGCBwABAoCCAAGAQjCAwBhWZMCBAoACAAGAQjCAwBhWZMCBAoAAA==.',Pr='Praeceps:AwAECAgABAoAAA==.Prollydead:AwABCAEABAoAAA==.Prupru:AwAGCAcABAoAAA==.',Pu='Punchymchit:AwAGCAwABAoAAA==.',Ra='Radala:AwAECAcABRQCGwAEAQhIAABDvGEBBRQAGwAEAQhIAABDvGEBBRQAARUAUF0ECAkABRQ=.Radel:AwAECAkABRQCFQAEAQjlAABQXXIBBRQAFQAEAQjlAABQXXIBBRQAAA==.Radmonk:AwABCAIABAoAARUAUF0ECAkABRQ=.Raelan:AwAECAcABAoAAA==.Raesham:AwAECAUABAoAAA==.Ragemaster:AwACCAIABAoAAA==.',Re='Redsaint:AwAFCAEABAoAAA==.Retpally:AwAFCAoABAoAAA==.',Ro='Rocksand:AwAICAkABAoAAA==.Rogueetjs:AwAGCA4ABAoAAA==.',Ru='Runninguns:AwACCAMABRQCGQAIAQjFCQA+8UACBAoAGQAIAQjFCQA+8UACBAoAAA==.',Ry='Ryddlesr:AwADCAUABRQCBAADAQjQBAAo2ecABRQABAADAQjQBAAo2ecABRQAAA==.Ryeshot:AwAFCA8ABRQCDAAFAQg2AABYjBECBRQADAAFAQg2AABYjBECBRQAAA==.Ryner:AwACCAIABAoAAQYAAAAGCA8ABAo=.',Sa='Salsak:AwAECAYABAoAAA==.Sathidk:AwAGCA8ABAoAAA==.',Sc='Scarlah:AwADCAQABAoAAA==.',Sh='Shadorash:AwAECAsABAoAAA==.Shamonlee:AwABCAEABAoAAA==.Shiho:AwABCAEABRQAAA==.Shimmer:AwAGCBAABAoAAA==.Shneedin:AwADCAMABAoAAQYAAAAFCAUABAo=.Shocklock:AwAHCA4ABAoAAA==.',Si='Silladin:AwADCAgABRQCCwADAQgMAgA5pvYABRQACwADAQgMAgA5pvYABRQAAA==.Simpletura:AwACCAIABAoAAA==.Sipthyr:AwAFCAYABAoAAA==.',Sl='Slayabunny:AwABCAMABRQCFgAIAQjZBgBSgfcCBAoAFgAIAQjZBgBSgfcCBAoAAA==.Slepybaer:AwAFCA8ABAoAAA==.',Sm='Smoosh:AwABCAEABAoAAA==.',So='Solaranis:AwAGCAUABAoAAA==.Sororitas:AwADCAMABAoAAA==.Souupdh:AwADCAMABAoAAA==.',Ss='Ssdende:AwAGCA0ABAoAAA==.',St='Strepsis:AwABCAEABRQAAA==.',Su='Sugadaddy:AwABCAEABRQAAA==.Susamuru:AwAECAQABRQAAA==.',Ta='Talenath:AwAICAkABAoAAA==.Tatertot:AwAFCA0ABAoAAA==.Taynka:AwADCAUABAoAAA==.',Th='Thallya:AwABCAIABRQAAA==.Thelonnius:AwAICAsABAoAAA==.Therealsb:AwABCAEABRQAARYAUoEBCAMABRQ=.Thewhat:AwABCAEABAoAAA==.Thortanous:AwABCAEABAoAAA==.Thunderbunz:AwABCAIABRQCBwAIAQhJCgBP1u8CBAoABwAIAQhJCgBP1u8CBAoAAA==.',Ti='Tideradra:AwAFCBAABRQCAgAFAQhXAABH4OsBBRQAAgAFAQhXAABH4OsBBRQAAA==.Ting:AwABCAEABRQCHAAIAQiuAgBSfM8CBAoAHAAIAQiuAgBSfM8CBAoAAA==.Tinypally:AwAGCAoABAoAAA==.',To='Toixic:AwAFCA4ABRQCAQAFAQjLAAAwVKIBBRQAAQAFAQjLAAAwVKIBBRQAAA==.Tootihunt:AwAICBQABAoCEAAIAQhgCgBaKgoDBAoAEAAIAQhgCgBaKgoDBAoAAA==.',Tr='Travaxian:AwAGCBEABAoAAA==.',Ts='Tsukoyomi:AwAECAQABAoAAA==.',Tu='Tumtumm:AwAFCAwABAoAAA==.',Tw='Twelvebtw:AwAECAwABRQEDgAEAQgeAgA9aeoABRQADgADAQgeAgA0J+oABRQADwADAQj9BAAmgOcABRQADQABAQgzAwBE618ABRQAAA==.Twonadon:AwAGCA0ABAoAAA==.',Un='Unstopubble:AwABCAEABAoAAA==.',Up='Upsetfish:AwAGCA4ABAoAAA==.',Va='Valenia:AwADCAUABAoAAA==.Vaylen:AwABCAEABAoAAA==.',Ve='Velíanthe:AwAICBAABAoAAA==.Vexahlia:AwACCAMABAoAAA==.',Vi='Vikingdrood:AwAHCBkABAoDCAAHAQjfBQBP4ywCBAoACAAGAQjfBQBOzCwCBAoACQAHAQj1GABMexwCBAoAAA==.Vinnyfr:AwADCAYABAoAAA==.Viscous:AwABCAEABAoAAA==.',Vo='Voxdru:AwAGCBQABAoDCAAGAQhFBwBK1PABBAoACAAGAQhFBwBK1PABBAoACQAEAQgTRwA7ZswABAoAAA==.',['V�']='Vîta:AwAFCA0ABAoAAA==.',Wa='Wastedwar:AwAICAgABAoAAA==.',Wu='Wuling:AwADCAEABAoAAA==.',Xe='Xepherite:AwAHCA4ABAoAAA==.',Xi='Xiaojian:AwAGCA4ABAoAAA==.',Za='Zalea:AwAFCBAABRQCBQAFAQhIAABVQCACBRQABQAFAQhIAABVQCACBRQAAA==.Zalman:AwAGCAYABAoAAQUAVUAFCBAABRQ=.',Ze='Zeromak:AwABCAEABAoAAA==.',Zz='Zzanxy:AwAECAQABAoAAA==.',['Ä']='Äzræll:AwAFCAIABAoAAA==.',['Ð']='Ðuckii:AwAFCAcABAoAAA==.',['Ö']='Ödyn:AwAECAYABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end