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
 local lookup = {'Monk-Windwalker','Paladin-Holy','Mage-Frost','Priest-Discipline','Paladin-Protection','Druid-Feral','DemonHunter-Havoc','Hunter-BeastMastery','Shaman-Enhancement','Druid-Balance','Druid-Restoration','Mage-Fire','Evoker-Devastation','Priest-Shadow','Priest-Holy','Warlock-Affliction','Warlock-Demonology','Warlock-Destruction','Warrior-Fury','Shaman-Restoration','Paladin-Retribution','Evoker-Preservation','Unknown-Unknown','Warrior-Arms','Hunter-Survival','Hunter-Marksmanship','Warrior-Protection','DeathKnight-Unholy','Shaman-Elemental','DeathKnight-Frost','Rogue-Assassination','Rogue-Subtlety','DemonHunter-Vengeance','Monk-Mistweaver',}; local provider = {region='US',realm='Firetree',name='US',type='weekly',zone=42,date='2025-03-29',data={Ad='Adondias:AwAFCAEABAoAAA==.',Ag='Agrevail:AwABCAEABAoAAA==.',Ai='Aidden:AwAHCBQABAoCAQAHAQj3CQBUMpgCBAoAAQAHAQj3CQBUMpgCBAoAAA==.',Al='Aldari:AwAGCA4ABAoAAA==.Aluc:AwAFCAEABAoAAA==.',As='Ascilica:AwADCAIABAoAAA==.Asperges:AwABCAEABRQAAA==.',Az='Azathoth:AwAECAQABAoAAA==.',['A�']='Aëlana:AwAFCAEABAoAAA==.',Ba='Babymj:AwAFCAsABAoAAA==.Baconn:AwAHCA0ABAoAAA==.',Be='Bearhugs:AwABCAEABRQAAA==.',Bi='Birky:AwAICAsABAoAAA==.',Br='Brightened:AwAECAQABAoAAA==.Broloren:AwACCAYABAoAAA==.Brøx:AwAGCA0ABAoAAA==.',Bu='Bubblehealzz:AwACCAUABRQCAgACAQinBQAjtIwABRQAAgACAQinBQAjtIwABRQAAA==.',['B�']='Bîrth:AwABCAEABRQCAwAIAQhsCABNM7YCBAoAAwAIAQhsCABNM7YCBAoAAA==.',Ca='Calic:AwAFCAEABAoAAA==.Caltrask:AwAHCA4ABAoAAA==.Capnmurlock:AwAHCBMABAoAAA==.Catharsis:AwADCAcABRQCBAADAQi5BAAqceAABRQABAADAQi5BAAqceAABRQAAA==.',Ce='Cern:AwADCAMABAoAAA==.',Ch='Chiflado:AwAHCAwABAoAAA==.Chinpokodin:AwAHCBUABAoCBQAHAQihDQA4T8ABBAoABQAHAQihDQA4T8ABBAoAAA==.Chonkykong:AwAFCAEABAoAAA==.',Ci='Cilya:AwAFCAcABAoAAA==.',Co='Conniving:AwAICAgABAoAAA==.',Cr='Critykity:AwAHCBQABAoCBgAHAQiKBwA3Au8BBAoABgAHAQiKBwA3Au8BBAoAAA==.Crypticdh:AwAICBQABAoCBwAIAQiyIgAzHAUCBAoABwAIAQiyIgAzHAUCBAoAAA==.',Cu='Curmudgeon:AwAICAMABAoAAA==.',Da='Dandorllan:AwAFCBEABAoAAA==.Dandyrandy:AwAHCBUABAoCAgAHAQi6CQBCCCMCBAoAAgAHAQi6CQBCCCMCBAoAAA==.Dariesa:AwADCAEABAoAAA==.Darkiron:AwABCAEABAoAAA==.Darthcrimson:AwAFCAkABAoAAA==.Dawnsreaper:AwAGCAwABAoAAA==.',De='Deepfist:AwAFCAEABAoAAA==.Demton:AwAFCAEABAoAAA==.Derrickbe:AwAHCBUABAoCCAAHAQitIQBKJUsCBAoACAAHAQitIQBKJUsCBAoAAA==.Dezodin:AwEBCAEABAoAAA==.',Dg='Dgkprodigy:AwAICBkABAoCCQAIAQjRFQAgBuYBBAoACQAIAQjRFQAgBuYBBAoAAA==.',Di='Diatonic:AwAGCAwABAoAAA==.Direkow:AwAHCBUABAoCBQAHAQjnAwBbYM8CBAoABQAHAQjnAwBbYM8CBAoAAA==.',Do='Dojaz:AwAHCBUABAoCBwAHAQgOJAA1HvoBBAoABwAHAQgOJAA1HvoBBAoAAA==.Doomhammer:AwAGCAYABAoAAA==.Doomyboomy:AwABCAEABRQDCgAIAQiWJgA5Gq0BBAoACgAHAQiWJgA4oq0BBAoACwAFAQjRKAAkrR0BBAoAAA==.',Dr='Draconica:AwAHCAwABAoAAA==.Draktha:AwABCAEABAoAAA==.Dreddful:AwAHCBUABAoCDAAHAQhQLQAnZp0BBAoADAAHAQhQLQAnZp0BBAoAAA==.Drum:AwAGCBIABAoAAA==.',Du='Duckymcduck:AwABCAEABRQAAA==.',Ei='Eione:AwAGCBMABAoAAA==.',El='Ellcrys:AwAFCAUABAoAAA==.Elvinshiznic:AwADCAQABAoAAA==.',Em='Emeraldbeast:AwAECAUABAoAAA==.Emoge:AwABCAMABRQCBwAIAQhNCABW0A8DBAoABwAIAQhNCABW0A8DBAoAAA==.',En='Endela:AwAECAEABAoAAA==.Energy:AwADCAMABAoAAA==.Enii:AwAGCBMABAoAAA==.',Es='Escanør:AwAECAUABAoAAA==.',Ev='Evokalic:AwACCAQABRQCDQAIAQhWAwBb1BADBAoADQAIAQhWAwBb1BADBAoAAA==.',Ex='Excellen:AwAHCA8ABAoAAA==.Exo:AwAHCBUABAoCCwAHAQj+BABbxNECBAoACwAHAQj+BABbxNECBAoAAA==.Extolled:AwAICBgABAoCCAAHAQh6DgBe+OoCBAoACAAHAQh6DgBe+OoCBAoAAA==.Exylan:AwAFCAkABAoAAA==.',Fe='Felsae:AwAHCBAABAoAAA==.',Fi='Fisten:AwACCAIABAoAAQ4AUcoBCAEABRQ=.Fistn:AwABCAEABRQEDgAIAQhsDABRynECBAoADgAHAQhsDABSlHECBAoABAAFAQhdLQAe4+cABAoADwABAQhEZgAOyikABAoAAA==.',Fl='Flexx:AwAFCAsABAoAAA==.',Fn='Fnaskmar:AwAHCA4ABAoAAA==.',Fo='Forbearance:AwAHCBUABAoCBQAHAQhIBwBKrVQCBAoABQAHAQhIBwBKrVQCBAoAAA==.',Fr='Franco:AwAGCBIABAoAAA==.Freshlock:AwACCAIABRQEEAAIAQisBQBdRN8BBAoAEAAFAQisBQBfqt8BBAoAEQAEAQhfDABaVpoBBAoAEgACAQg0TQBgetsABAoAAA==.Frostytoez:AwACCAIABRQDAwAIAQj7FABF/xcCBAoADAAIAQjZHAA3aCYCBAoAAwAIAQj7FABAIhcCBAoAAA==.',Fy='Fyreeze:AwAFCAoABAoAAA==.',Ga='Galadhriel:AwAFCAEABAoAAA==.Ganador:AwAHCBIABAoAAA==.Gazzerfroz:AwAECAQABAoAAA==.',Ge='Getcrit:AwAICBUABAoCEwAIAQiWEABEgW8CBAoAEwAIAQiWEABEgW8CBAoAAA==.',Gi='Gimbal:AwAFCAoABAoAAA==.',Gn='Gnomeofdeath:AwAHCAwABAoAAA==.',Go='Gordonramsme:AwAFCAEABAoAAA==.',Gr='Greentide:AwABCAEABRQCFAAIAQh9BwBUEMoCBAoAFAAIAQh9BwBUEMoCBAoAAA==.Greysham:AwACCAMABAoAAA==.',Gu='Gummybearz:AwAICAkABAoAAA==.',Ha='Hammerferge:AwAGCA8ABAoAAA==.',Ho='Holysquish:AwACCAQABRQDFQAIAQhGFwBSdrcCBAoAFQAIAQhGFwBSdrcCBAoABQABAQgdQwAGHhMABAoAAA==.',Hr='Hrakharuirn:AwADCAEABAoAAA==.',['H�']='Héykan:AwAICBgABAoDDQAIAQhEFAA0O7MBBAoADQAHAQhEFAAxY7MBBAoAFgACAQiOGAAb4W4ABAoAARcAAAABCAEABRQ=.',Ic='Iceleaf:AwAICAEABAoAAA==.',Ij='Ijudgepeople:AwAECAEABAoAAA==.',Il='Ileinaa:AwAFCAEABAoAAA==.Iliketrains:AwAFCAcABAoAAA==.Illuminatì:AwAGCAkABAoAAA==.',Im='Immobilizer:AwAICBAABAoAAA==.',In='Indishaman:AwACCAIABAoAAA==.',Ir='Irysse:AwAFCAUABAoAAA==.',It='Itstotessifu:AwAFCAYABAoAAA==.',Ja='Jammybeanbag:AwAFCA0ABAoAAA==.Jayfizzle:AwAFCAEABAoAAA==.',Jc='Jckie:AwACCAIABAoAAA==.',Ju='Jubei:AwAFCAUABAoAARgAXpwCCAIABRQ=.Jubeidh:AwAECAQABAoAARgAXpwCCAIABRQ=.Juw:AwAGCA8ABAoAAA==.',Ka='Kasky:AwACCAEABAoAAA==.',Ke='Keane:AwAGCAsABAoAAA==.',Ki='Kindassuddy:AwADCAIABAoAAA==.Kirklandbeef:AwACCAIABAoAAA==.Kivlov:AwADCAYABRQCGAADAQhHAQAo/fMABRQAGAADAQhHAQAo/fMABRQAAA==.',Kn='Kniavez:AwAFCAEABAoAAA==.',Kr='Krack:AwAFCAoABAoAAA==.Kratoo:AwAFCAIABAoAAA==.',Ku='Kuler:AwADCAIABAoAAA==.',['K�']='Kèèn:AwAGCA0ABAoAAA==.Kítkat:AwAFCAMABAoAAA==.Kòdiak:AwADCAIABAoAAA==.',Le='Leeroyjenko:AwAFCAoABAoAAA==.',Lo='Lockpow:AwADCAQABAoAAA==.Lollipops:AwAFCAkABAoAARcAAAAICAkABAo=.Lorienb:AwABCAIABRQAAA==.Lorthos:AwAICAgABAoAAA==.',Lu='Luckehlock:AwADCAcABRQCEAADAQhnAQBPjxABBRQAEAADAQhnAQBPjxABBRQAAA==.',Ma='Macgillivray:AwAFCAoABAoAAA==.Madk:AwAHCAcABAoAARMAPjEECAkABRQ=.Magus:AwADCAQABRQCDAAIAQgJAwBeW00DBAoADAAIAQgJAwBeW00DBAoAAA==.Maluck:AwAECAQABAoAAA==.',Me='Melylen:AwABCAEABAoAAA==.',Mi='Miicow:AwAECAsABAoAAA==.',Mu='Musculate:AwADCAQABRQEGQAIAQgIAQBXat4CBAoAGQAIAQgIAQBXat4CBAoACAAHAQiRNwBB5sABBAoAGgABAQjpOgBE7ksABAoAAA==.',Ni='Nicagug:AwAGCAkABAoAAA==.Nick:AwABCAEABRQAAQwAXlsDCAQABRQ=.Nintendoh:AwAHCBMABAoAAA==.',No='Nonna:AwABCAEABRQEGAAGAQivEwBVVbkBBAoAGAAFAQivEwBO9rkBBAoAEwAEAQg8OABAAhwBBAoAGwACAQgOGQBEs54ABAoAAA==.Noolore:AwACCAQABRQCHAAIAQhqDABOhZYCBAoAHAAIAQhqDABOhZYCBAoAAA==.Nordin:AwACCAQABAoAAA==.',Nu='Nurfroll:AwAGCA0ABAoAAA==.',Ny='Nysselyne:AwAFCAoABAoAAA==.',Od='Odimus:AwACCAIABRQDGQAIAQiGAwBGyegBBAoAGQAHAQiGAwBESegBBAoACAAEAQj+VgA2ojMBBAoAAA==.',On='Onana:AwABCAEABRQCHQAIAQjiDgBD8UUCBAoAHQAIAQjiDgBD8UUCBAoAAA==.',Or='Orlastus:AwAFCAIABAoAAA==.',Ot='Otheos:AwAFCAEABAoAAA==.',Pe='Pege:AwAECAQABAoAARcAAAAGCAoABAo=.Penniwing:AwAECAcABAoAAA==.Percival:AwAFCAoABAoAARgAKP0DCAYABRQ=.Perfectoso:AwAFCAEABAoAAA==.',Pi='Piffboy:AwAFCAEABAoAAA==.',Po='Pookiedookie:AwADCAMABAoAAA==.',Pr='Priestler:AwAECAQABAoAARcAAAAFCAkABAo=.',Ps='Psstboy:AwAECAkABAoAAA==.',Pu='Pullbarg:AwACCAMABAoAAA==.',Py='Pyru:AwABCAEABAoAAA==.',Re='Reggienoble:AwABCAEABRQCGQAIAQjcAABWh/cCBAoAGQAIAQjcAABWh/cCBAoAAA==.Reiner:AwADCAcABRQCHgADAQgMAQAr2fQABRQAHgADAQgMAQAr2fQABRQAAA==.Reynaria:AwABCAEABRQAAA==.',Ry='Rydia:AwADCAMABAoAAA==.',Sa='Sankyu:AwAFCAgABAoAAA==.',Sc='Scredwin:AwAFCAEABAoAARcAAAAGCBMABAo=.',Se='Senorboboxx:AwAFCAwABAoAAA==.',Sh='Shanksinatrá:AwADCAUABRQDHwADAQj2AgA1BbQABRQAHwACAQj2AgBGi7QABRQAIAABAQgCCgAR+00ABRQAAA==.Shaxxypoo:AwAHCA4ABAoAAA==.Shedari:AwAICBcABAoCFQAIAQgZLgA2IzQCBAoAFQAIAQgZLgA2IzQCBAoAAA==.Sholyver:AwAHCBMABAoAAA==.',Si='Silby:AwADCAIABAoAAA==.Simzerker:AwABCAMABRQCEwAIAQibAwBWLjYDBAoAEwAIAQibAwBWLjYDBAoAAA==.',Sl='Slamazing:AwABCAEABRQCIQAIAQg7BQBM66ACBAoAIQAIAQg7BQBM66ACBAoAAA==.Slamtastic:AwAFCBIABAoAAA==.',Sn='Snowba:AwABCAEABRQAAA==.',So='Softly:AwACCAYABRQCIgACAQjTCABIiq4ABRQAIgACAQjTCABIiq4ABRQAAA==.Solanis:AwAGCA4ABAoAAA==.Solman:AwAGCBEABAoAAA==.',St='Starkesha:AwABCAEABAoAAA==.Starkisses:AwAHCBMABAoAAA==.Stearic:AwACCAIABAoAAA==.Styrth:AwADCAgABRQCGwADAQhXAABfpVIBBRQAGwADAQhXAABfpVIBBRQAAA==.Stálizzy:AwAICAMABAoAAA==.',Su='Supdaddy:AwABCAEABRQAASIASIoCCAYABRQ=.',Ta='Taeshira:AwAFCAsABAoAAA==.Talkimas:AwAFCAEABAoAAA==.Talvisota:AwAGCA0ABAoAAA==.Tazer:AwABCAEABAoAAA==.',Te='Tekosd:AwAICAgABAoAAQcAVakCCAIABRQ=.Tekoslul:AwACCAIABRQCBwAIAQjRBwBVqRUDBAoABwAIAQjRBwBVqRUDBAoAAA==.Tekosqt:AwAGCAYABAoAAQcAVakCCAIABRQ=.Teldrussy:AwAGCAsABAoAAA==.',Th='Thalonar:AwAECAQABAoAAA==.Thalunar:AwADCAIABAoAAA==.Thander:AwAFCAkABAoAAA==.Thorck:AwAECAUABAoAAA==.',Ti='Tinklewinkle:AwAHCBIABAoAAA==.',To='Torver:AwACCAIABAoAAA==.Totemsquish:AwADCAEABAoAAA==.',Tu='Turbulence:AwAECAgABAoAAA==.',Un='Unholyknight:AwACCAMABAoAAA==.Unremorseful:AwAHCBUABAoCDgAHAQhGCABcSr0CBAoADgAHAQhGCABcSr0CBAoAAA==.Uns:AwACCAMABAoAAA==.',Ur='Uranus:AwAFCA4ABAoAAA==.',Ve='Venttres:AwAICA8ABAoAAA==.Vexice:AwADCAgABRQCEgADAQizAgBTqCgBBRQAEgADAQizAgBTqCgBBRQAAA==.',Vh='Vhanstol:AwAECAgABAoAAA==.',Vi='Views:AwAGCAcABAoAAA==.Viewsr:AwAFCAEABAoAAA==.',Vo='Voldy:AwADCAUABAoAAA==.',Vt='Vtsax:AwAFCAUABAoAAA==.Vtuber:AwAECAQABAoAAQcAVtABCAMABRQ=.',['V�']='Vøgue:AwAHCBUABAoCHwAHAQgnDwAoSawBBAoAHwAHAQgnDwAoSawBBAoAAA==.',Wa='Watchitpal:AwAECAQABAoAAA==.',We='Wealthy:AwAFCAEABAoAAA==.Wendyrhodes:AwABCAEABAoAAA==.',Wi='Wiiska:AwAFCAcABAoAAA==.',Wo='Wolfyhugs:AwABCAEABRQAAA==.',Xe='Xenodeath:AwAECAYABAoAAA==.',Xo='Xombi:AwACCAMABAoAAA==.',Xs='Xsjado:AwAHCBUABAoCHgAHAQitBwA6uPgBBAoAHgAHAQitBwA6uPgBBAoAAA==.',Yu='Yuhwoo:AwAHCA4ABAoAAA==.',Ze='Zemi:AwAHCBUABAoCCQAHAQg6GwAdPaABBAoACQAHAQg6GwAdPaABBAoAAA==.Zephiyre:AwABCAEABAoAARcAAAAFCAsABAo=.Zephrael:AwAFCAsABAoAAA==.',Zm='Zmz:AwADCAcABRQCDgADAQiYBABCngABBRQADgADAQiYBABCngABBRQAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end