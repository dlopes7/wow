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
 local lookup = {'Shaman-Enhancement','Mage-Fire','Unknown-Unknown','Warlock-Affliction','Warlock-Demonology','Warlock-Destruction','Warrior-Fury','Priest-Shadow','Rogue-Assassination','Rogue-Outlaw','DemonHunter-Havoc','Evoker-Devastation','Paladin-Protection','Priest-Discipline','Priest-Holy','Monk-Mistweaver','Mage-Arcane','Mage-Frost','Druid-Balance','Shaman-Restoration','Paladin-Retribution','Shaman-Elemental',}; local provider = {region='US',realm='Thunderlord',name='US',type='weekly',zone=42,date='2025-03-28',data={Aa='Aaliyah:AwADCAUABAoAAA==.',Ab='Abertrent:AwADCAIABAoAAA==.',Ac='Acidwavve:AwABCAMABRQAAA==.',Ae='Aethilius:AwAICAgABAoAAA==.',Al='Alexwithfur:AwAHCAsABAoAAA==.Alplarn:AwACCAIABAoAAA==.',Am='Ammathacin:AwAICBAABAoAAA==.',An='Annihilape:AwAGCA4ABAoAAA==.',Aq='Aquadrelia:AwADCAMABAoAAA==.',At='Atomonia:AwADCAMABAoAAA==.',Au='Automagic:AwABCAEABAoAAA==.',Ay='Aymine:AwADCAQABAoAAA==.',Az='Azgeliath:AwADCAQABAoAAA==.',Ba='Badwolff:AwADCAEABAoAAA==.Bali:AwAFCAcABAoAAA==.Baycon:AwACCAIABAoAAA==.',Be='Belanor:AwADCAIABAoAAA==.Berry:AwAHCA4ABAoAAA==.',Bi='Bighog:AwAECAIABAoAAA==.Biglego:AwADCAYABRQCAQADAQizAwA4JgQBBRQAAQADAQizAwA4JgQBBRQAAA==.Bigloaf:AwACCAQABAoAAQIALg4CCAQABRQ=.Bignipsmcgee:AwAECAUABAoAAA==.Billibones:AwAFCAsABAoAAA==.Bismilahimps:AwACCAIABAoAAQMAAAADCAQABRQ=.',Bl='Blastme:AwAFCAIABAoAAA==.Blastmee:AwAECAIABAoAAA==.',Bo='Bosgothots:AwABCAEABRQAAA==.Bosgotsdots:AwAHCBQABAoEBAAGAQjqAwBZwBsCBAoABAAGAQjqAwBNbBsCBAoABQAFAQjkCwBZvJUBBAoABgACAQhfZwAux28ABAoAAQMAAAABCAEABRQ=.',Br='Bracky:AwECCAIABAoAAA==.Brewmaxxing:AwADCAQABAoAAQMAAAADCAQABRQ=.Brynné:AwAHCAgABAoAAA==.',Bu='Buggy:AwAGCAkABAoAAA==.Burdy:AwACCAIABAoAAQcAPdEHCBcABAo=.Busyb:AwAICAIABAoAAA==.',Ca='Caféaulait:AwAECAQABAoAAA==.Camrose:AwAECAQABAoAAA==.Canon:AwADCAEABAoAAA==.',Ce='Celasong:AwACCAIABAoAAA==.Certotems:AwABCAIABRQCAQAHAQitEABBYywCBAoAAQAHAQitEABBYywCBAoAAA==.',Ch='Chubbsmcgee:AwAECAcABAoAAA==.',Cm='Cmtwittlepaw:AwAFCAUABAoAAA==.',Co='Cosmicpally:AwACCAIABAoAAA==.',['C�']='Céllphone:AwACCAIABAoAAA==.',Da='Daddi:AwAECAYABAoAAA==.Daemessiah:AwABCAEABAoAAA==.Damitara:AwAFCAsABAoAAA==.Davemage:AwADCAUABAoAAA==.Dazander:AwADCAMABAoAAA==.',De='Deathmite:AwAFCAwABAoAAA==.',Di='Dillpo:AwAECAQABAoAAA==.Dis:AwABCAQABRQEBgAIAQh2HgBU0O0BBAoABgAGAQh2HgBLUu0BBAoABAADAQgNEABWVgQBBAoABQACAQhHJABRY7IABAoAAA==.Disyx:AwABCAEABAoAAA==.',Do='Doridosa:AwAECAYABAoAAA==.',Dr='Dradamir:AwACCAEABAoAAA==.Dread:AwABCAIABAoAAA==.Droknor:AwABCAEABAoAAA==.',Du='Dumblezong:AwADCAMABAoAAA==.',['D�']='Díabolical:AwABCAIABRQCCAAHAQj4DABOgl8CBAoACAAHAQj4DABOgl8CBAoAAA==.',El='Elazar:AwAFCAsABAoAAA==.Elidori:AwADCAUABRQDCQADAQjCAwAmr58ABRQACQACAQjCAwA2Jp8ABRQACgACAQhUAQAIv4MABRQAAA==.',Em='Emilialock:AwACCAIABAoAAA==.',En='Enyeto:AwAGCBEABAoAAA==.',Ep='Epsillyon:AwADCAUABAoAAA==.',Er='Eriara:AwACCAIABAoAAA==.',Et='Eternum:AwADCAYABAoAAA==.',Ez='Ezoghoul:AwACCAIABAoAAA==.',Fe='Ferwinor:AwAICA4ABAoAAA==.',Fo='Foxikins:AwAFCAUABAoAAA==.',Fr='Frshadow:AwABCAEABAoAAA==.Frêezorburn:AwAICAgABAoAAA==.',Ga='Gakiska:AwAFCA8ABAoAAA==.Gaía:AwABCAEABAoAAA==.',Ge='Gelfin:AwACCAEABAoAAA==.Gelin:AwAFCAsABAoAAA==.Genjí:AwAICAgABAoAAA==.Genkael:AwADCAYABAoAAA==.',Gi='Gigglefart:AwAICA4ABAoAAA==.Girthbrookss:AwACCAMABAoAAQMAAAAECAUABAo=.',Go='Goldielocs:AwADCAMABAoAAA==.Gorblo:AwAECAYABAoAAA==.Gorgamm:AwADCAMABAoAAQMAAAADCAkABAo=.Gorgiscorch:AwADCAkABAoAAA==.',Gr='Grigdor:AwEICAMABAoAAA==.',Gu='Guypriest:AwAECAcABAoAAQMAAAAFCAcABAo=.',['G�']='Gðd:AwAICAYABAoAAA==.',Ha='Hannibul:AwAFCA0ABAoAAA==.',He='Helldriver:AwAECAEABAoAAA==.Heshbananas:AwABCAEABRQCBwAIAQiPDwA533UCBAoABwAIAQiPDwA533UCBAoAAA==.',Hr='Hryn:AwAECAIABAoAAA==.',Hu='Huntcakes:AwAECAEABAoAAA==.',Hy='Hypev:AwABCAEABAoAAQMAAAAICAYABAo=.Hypm:AwAGCBIABAoAAQMAAAAICAYABAo=.Hyps:AwAICAYABAoAAA==.',Ib='Ibowla:AwACCAQABAoAAA==.',Im='Impwrangler:AwACCAMABAoAAA==.',In='Instantdeath:AwABCAIABRQCCwAIAQhfDwBOP7ECBAoACwAIAQhfDwBOP7ECBAoAAA==.Invìctús:AwAGCBEABAoAAA==.',It='Itskodak:AwAFCAIABAoAAA==.',Iz='Izume:AwAGCAsABAoAAA==.',Ja='Jad:AwAECAYABAoAAA==.Jawo:AwADCAQABAoAAA==.',Je='Jehni:AwAECAEABAoAAA==.',Jo='Joni:AwAICBAABAoAAA==.',Jx='Jx:AwAECAQABAoAAA==.',['J�']='Jürg:AwADCAEABAoAAA==.',Ka='Kahlduin:AwAECAUABAoAAA==.Kallib:AwAGCBEABAoAAA==.Kasumidari:AwABCAEABAoAAA==.',Ke='Kerishai:AwACCAQABAoAAA==.Keyallanis:AwABCAEABAoAAA==.',Ki='Kimori:AwAFCAYABAoAAQMAAAAGCAIABAo=.',Kl='Klockwork:AwAICAcABAoAAA==.',Ko='Korgigammi:AwAGCAIABAoAAA==.',Kr='Kreltotem:AwAFCAcABAoAAA==.Krelvoker:AwAECAsABAoAAQMAAAAFCAcABAo=.',Ku='Kungfuit:AwAICAgABAoAAA==.',La='Lancel:AwACCAIABAoAAQMAAAAGCBEABAo=.',Le='Lethedemon:AwAECAIABAoAAA==.',Li='Lichthrall:AwADCAMABAoAAA==.Lilet:AwAGCBEABAoAAA==.Lisri:AwAFCAQABAoAAA==.Littlestorm:AwAHCBMABAoAAA==.',Lo='Lorindy:AwAECAgABAoAAQgAToIBCAIABRQ=.',Ma='Madara:AwAHCAMABAoAAA==.Manchufu:AwAHCA8ABAoAAA==.',Me='Meszyra:AwADCAUABRQCDAADAQh+BAA7RO4ABRQADAADAQh+BAA7RO4ABRQAAA==.',Mi='Mistafista:AwACCAMABAoAAA==.',Mo='Moggrin:AwABCAIABRQAAA==.Monthlyfury:AwAECAQABAoAAQ0AR6kBCAIABRQ=.Moushou:AwAGCA4ABAoAAA==.',Mu='Muffinstumps:AwADCAIABAoAAA==.',Ne='Nedraice:AwABCAEABRQAAA==.Nevore:AwABCAEABRQDDgAHAQj2EwA2P8EBBAoADgAHAQj2EwA1mMEBBAoADwAHAQghJQAcplkBBAoAAA==.',Ni='Nikostratos:AwADCAUABAoAAA==.Ninoska:AwABCAEABAoAAA==.Nitewing:AwADCAYABRQCDQADAQhrAwAmzrIABRQADQADAQhrAwAmzrIABRQAAA==.',['N�']='Nýxara:AwAECAUABAoAAA==.',Of='Ofchildren:AwACCAIABAoAAQMAAAAFCAwABAo=.',Op='Opi:AwABCAIABRQCDAAHAQgzBQBfgd4CBAoADAAHAQgzBQBfgd4CBAoAAA==.Opizerka:AwABCAEABAoAAQwAX4EBCAIABRQ=.',Pa='Paladingo:AwADCAUABAoAARAAQ/MHCBQABAo=.',Pe='Peedmypants:AwAFCA0ABAoAAA==.Pellence:AwABCAEABAoAAA==.Pelleus:AwAFCAUABAoAAA==.',Ph='Phephraan:AwAECAkABAoAAA==.Phoenixrisin:AwADCAcABAoAAA==.Phwaz:AwADCAUABAoAAA==.',Pi='Piffster:AwAECAQABRQAAA==.Piffy:AwAICBAABAoAAA==.Pizzadough:AwACCAQABRQEAgAIAQj2IQAuDu0BBAoAAgAIAQj2IQAuDu0BBAoAEQACAQgzCwAvKF8ABAoAEgACAQhXYAAehlwABAoAAA==.',Re='Redestro:AwABCAEABAoAAQMAAAAFCAwABAo=.Rednuth:AwADCAMABAoAAA==.Reydar:AwADCAEABAoAAA==.',Ri='Riotshield:AwACCAIABAoAAA==.',Ro='Rotorsdr:AwAECAYABAoAAA==.Rouñders:AwADCAYABRQCEwADAQhZBgAz5PUABRQAEwADAQhZBgAz5PUABRQAAA==.',Rp='Rphaung:AwAECAEABAoAAA==.',Sa='Saltdiscney:AwABCAEABAoAARQAPJ0CCAMABRQ=.Samlock:AwAGCB0ABAoCBgAGAQjgMgA4YlkBBAoABgAGAQjgMgA4YlkBBAoAAA==.Sammette:AwADCAQABAoAAA==.Savella:AwADCAUABAoAAA==.',Sc='Schamwoww:AwACCAIABAoAAA==.',Se='Seacutie:AwAFCAUABAoAAA==.Seleniera:AwABCAEABAoAAA==.Selleck:AwAHCBYABAoCFQAHAQhoMQBBmBkCBAoAFQAHAQhoMQBBmBkCBAoAAA==.',Sh='Shamsandwich:AwACCAIABAoAAA==.Shintracer:AwAICAsABAoAAA==.Shortcircult:AwACCAIABAoAAA==.Shweba:AwACCAIABAoAAA==.',Si='Sielthus:AwAFCAwABAoAAA==.Silverpower:AwACCAIABAoAAA==.Situna:AwADCAUABAoAAA==.',Sk='Skyedoko:AwACCAIABAoAAA==.',Sl='Sleezyaf:AwAFCAMABAoAAA==.Slowcase:AwADCAgABAoAAA==.Slowroll:AwAFCA0ABAoAAA==.Slxm:AwABCAEABAoAAA==.',Sp='Sprenkz:AwAICAUABAoAAA==.',St='Sternum:AwACCAIABAoAAA==.',Su='Summwun:AwAHCAoABAoAAA==.Superace:AwABCAMABRQCFgAIAQj/BABQcvECBAoAFgAIAQj/BABQcvECBAoAAA==.',Ta='Taids:AwACCAIABAoAAA==.Taqa:AwAGCAIABAoAAA==.',Te='Teddymouse:AwADCAQABAoAAA==.',Th='Thecowkiing:AwADCAMABAoAAA==.Thraggums:AwABCAEABAoAAA==.Thrashipapi:AwAECAYABAoAAA==.Thulu:AwAFCAUABAoAAA==.',To='Tomshelby:AwAICAgABAoAAA==.Toneri:AwACCAIABAoAAQMAAAAFCAcABAo=.Tossdirt:AwAFCAUABAoAAQYAVNABCAQABRQ=.',Tr='Trakshot:AwAHCBEABAoAAQMAAAACCAQABRQ=.Trapzilla:AwAICAgABAoAAA==.Truefaith:AwAFCAkABAoAAA==.',Ts='Tservo:AwABCAEABRQAAA==.',Tu='Tuggy:AwAHCBcABAoCBwAHAQhTGAA90RUCBAoABwAHAQhTGAA90RUCBAoAAA==.',Ty='Tynsoldier:AwAECAEABAoAAA==.Typhal:AwAGCBIABAoAAA==.',Uh='Uhtan:AwADCAgABAoAAA==.',Un='Unholysaurus:AwABCAIABRQCDQAHAQiQCABHqScCBAoADQAHAQiQCABHqScCBAoAAA==.Unnaturall:AwAHCAoABAoAAA==.',Va='Valorruk:AwADCAYABAoAAA==.',Ve='Verxa:AwACCAIABAoAAA==.',Vi='Virali:AwAFCA8ABAoAAA==.Vispper:AwAECAgABAoAAA==.',Vo='Vociva:AwAFCA8ABAoAAA==.',Wh='Whilay:AwACCAIABAoAAQMAAAAGCBEABAo=.',Wo='Wolfpriest:AwABCAEABRQAAA==.',Yo='Yokuz:AwAICBcABAoDCAAIAQiiDgBJikICBAoACAAHAQiiDgBGI0ICBAoADgABAQj/TQAkaT4ABAoAAA==.',Yu='Yungbrad:AwAGCAsABAoAAA==.',Za='Zarindela:AwADCAQABRQAAA==.',Ze='Zeenaheals:AwADCAYABAoAAA==.',Zo='Zozgrax:AwADCAMABAoAAA==.',Zy='Zymmy:AwACCAMABAoAAA==.',['Ì']='Ìllìdäñ:AwADCAUABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end