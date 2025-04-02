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
 local lookup = {'Unknown-Unknown','Paladin-Protection','Rogue-Subtlety','Monk-Windwalker','Monk-Mistweaver','Paladin-Retribution','Evoker-Devastation','Evoker-Preservation','Hunter-BeastMastery','Warlock-Demonology','Warlock-Destruction','DeathKnight-Blood','Druid-Balance','Druid-Restoration','Warlock-Affliction','Shaman-Elemental','Shaman-Restoration','Warrior-Arms','Rogue-Assassination','Mage-Fire','Mage-Frost','Priest-Holy',}; local provider = {region='US',realm="Ner'zhul",name='US',type='weekly',zone=42,date='2025-03-29',data={Ab='Abrigo:AwAGCAcABAoAAA==.',Ad='Adastea:AwAGCAsABAoAAA==.',Al='Alaanz:AwADCAMABAoAAA==.Alpharatz:AwAFCAgABAoAAA==.Alr:AwABCAEABAoAAA==.',Am='Amunwrath:AwAFCAoABAoAAA==.',An='Anelace:AwAICAgABAoAAA==.Anyana:AwADCAMABAoAAA==.',Ao='Aozeraa:AwAGCAoABAoAAA==.Aozerra:AwABCAEABAoAAQEAAAAGCAoABAo=.',Ar='Arkoric:AwAICAsABAoAAA==.',As='Ashtongue:AwAICAoABAoAAA==.Asurafresh:AwAGCAoABAoAAA==.',Ay='Ayvero:AwAFCAcABAoAAA==.',Ba='Bamuth:AwAHCBYABAoCAgAHAQiTCABF2zICBAoAAgAHAQiTCABF2zICBAoAAA==.',Be='Belowaverage:AwADCAEABAoAAA==.',Bi='Billidari:AwACCAIABAoAAQMALyEHCBUABAo=.',Bl='Blightclub:AwABCAEABAoAAQQAMwcBCAEABRQ=.',Bo='Boksul:AwAGCAoABAoAAA==.Bolobao:AwAFCA0ABAoAAA==.',Br='Brisktwo:AwADCAEABAoAAA==.',By='Byakuya:AwAGCAEABAoAAA==.',Ca='Caly:AwECCAQABRQCBQAIAQi1BQBTg/ECBAoABQAIAQi1BQBTg/ECBAoAAA==.Carcass:AwAFCAEABAoAAA==.',Ch='Chach:AwACCAEABAoAAA==.Chawkpriest:AwAHCAIABAoAAA==.',Ci='Cindrø:AwADCAMABAoAAA==.',Co='Colauris:AwAGCA8ABAoAAA==.',Cr='Crabs:AwAGCBAABAoAAA==.Crayson:AwAFCAsABAoAAA==.',Cu='Cult:AwAGCAsABAoAAA==.',Da='Dangohealing:AwAGCAcABAoAAA==.',Dc='Dctrdoom:AwACCAIABAoAAA==.',De='Deatherselfs:AwAGCA8ABAoAAA==.Delläk:AwADCAUABAoAAA==.Derekvinyard:AwAFCAoABAoAAA==.Design:AwABCAEABAoAAQEAAAACCAIABAo=.Deuxma:AwABCAEABAoAAQYAU3oHCBcABAo=.',Di='Diodoesdmg:AwAGCA8ABAoAAA==.',Dm='Dmgprovider:AwABCAEABAoAAA==.',Do='Domochevsky:AwADCAQABRQCBAAIAQgqCQBIRKgCBAoABAAIAQgqCQBIRKgCBAoAAA==.Dorgan:AwADCAEABAoAAA==.',Dr='Drakelm:AwAICBgABAoDBwAIAQgaDQBLEjgCBAoABwAHAQgaDQBMDTgCBAoACAADAQhNFQAimp4ABAoAAA==.Drorian:AwADCAMABAoAAA==.Drrdead:AwAECAQABAoAAA==.Drtoetem:AwADCAMABAoAAA==.',Du='Duckpond:AwAGCA4ABAoAAA==.Dudesoother:AwACCAIABAoAAA==.Dumbdragon:AwAGCAQABAoAAA==.',Ea='Earthen:AwADCAMABAoAAA==.',Eh='Ehkoe:AwAFCA4ABAoAAA==.',Ei='Eillonwy:AwAFCA4ABAoAAA==.',El='Elitextony:AwABCAEABAoAAA==.',Em='Ember:AwADCAUABRQCCQADAQjECQAv4eoABRQACQADAQjECQAv4eoABRQAAA==.Emberz:AwAECAQABAoAAA==.',En='Enyaspace:AwAECAQABAoAAA==.',Fa='Faeris:AwAFCA8ABAoAAA==.Faineth:AwAECAcABAoAAA==.',Fe='Feacialiale:AwADCAMABAoAAA==.Felbladekid:AwAFCA0ABAoAAA==.',Fl='Flashyz:AwACCAIABAoAAQEAAAAGCA4ABAo=.',Fo='Folstagg:AwADCAMABAoAAA==.Fonzzie:AwACCAEABAoAAA==.',Fr='Friarpuck:AwABCAEABRQAAA==.',Ga='Galiphe:AwAGCAsABAoAAA==.Gamsungorani:AwAGCAgABAoAAA==.Ganiedruren:AwAECAQABAoAAA==.',Ge='Geopetal:AwAGCBEABAoAAA==.',Gi='Gid:AwADCAEABAoAAA==.Gingy:AwAGCAcABAoAAA==.',Gl='Glocked:AwAGCAYABAoAAA==.',Go='Goobr:AwACCAIABAoAAA==.Goodjobbuddy:AwAFCA0ABAoAAA==.',Gr='Grievous:AwAICAMABAoAAA==.',Gu='Guappo:AwAECAUABAoAAA==.Guideau:AwACCAEABAoAAA==.',Ha='Hafwyn:AwAGCA8ABAoAAA==.',He='Heliux:AwAHCBEABAoAAA==.',Hl='Hljóð:AwABCAEABAoAAA==.',Ho='Holysmiter:AwADCAMABAoAAA==.',Ir='Iriemon:AwAFCA0ABAoAAA==.',Ja='Jasperb:AwAECAUABAoAAA==.',Je='Jerzzarn:AwAHCA0ABAoAAA==.',Ji='Jinzx:AwADCAIABAoAAA==.',Jo='Jojo:AwAGCA8ABAoAAA==.',Ju='Juhabachh:AwADCAMABAoAAA==.',['J�']='Járnviðr:AwACCAIABAoAAA==.Jâm:AwACCAEABAoAAA==.',Ka='Kajione:AwAHCBcABAoCBgAHAQjIOABTegYCBAoABgAHAQjIOABTegYCBAoAAA==.Kalynnah:AwAGCA8ABAoAAA==.Kanatoo:AwADCAYABAoAAA==.Kanekisenpai:AwABCAEABRQDCgAHAQiiEQBEuFQBBAoACwAGAQi3MAAvznIBBAoACgAEAQiiEQBIuFQBBAoAAA==.Kanjam:AwAFCA8ABAoAAA==.',Kb='Kblast:AwAHCA4ABAoAAA==.',Ke='Kelai:AwADCAUABRQCDAADAQhBAgBWECoBBRQADAADAQhBAgBWECoBBRQAAA==.',Ki='Killapal:AwABCAEABAoAAA==.Kinre:AwAECAcABAoAAA==.',Ko='Konfucius:AwAGCAsABAoAAA==.',Kr='Krowin:AwACCAMABAoAAA==.Kruma:AwAFCAoABAoAAA==.',Ku='Kuzé:AwAECAsABAoAAA==.',Kx='Kxz:AwACCAEABAoAAQEAAAAHCA4ABAo=.',Ky='Kyuubi:AwAGCBQABAoDDQAGAQgyJABDXMEBBAoADQAGAQgyJABDXMEBBAoADgADAQikQAAf9o8ABAoAAA==.',La='Lase:AwADCAEABAoAAA==.',Le='Legendhunter:AwAFCAsABAoAAA==.Letmo:AwACCAEABAoAAA==.',Li='Lightisdead:AwAGCAwABAoAAA==.Lindariel:AwAFCAcABAoAAA==.Lindir:AwAGCA8ABAoAAA==.Lingxhao:AwAFCAoABAoAAA==.Liparooni:AwAGCAoABAoAAA==.Liyt:AwACCAEABAoAAQEAAAACCAIABAo=.',Lo='Lockedupfoo:AwADCAUABRQDCwADAQj1CAA2c6oABRQACwACAQj1CABOXaoABRQADwABAQhnDgAGoDwABRQAAA==.Lorchah:AwAECAQABAoAAA==.Lorgan:AwAECAQABAoAAA==.',Lu='Lucaris:AwAFCAEABAoAAQEAAAAHCA0ABAo=.Lunah:AwAFCAsABAoAAA==.Lussty:AwADCAMABAoAAA==.',['L�']='Låb:AwAGCA8ABAoAAA==.Lègo:AwAGCAUABAoAAA==.',Ma='Machico:AwAFCA8ABAoAAA==.Magina:AwAGCAoABAoAAA==.Magosika:AwAECAcABAoAAA==.Maledizione:AwAECAgABAoAAA==.Maxbadly:AwAFCA8ABAoAAA==.',Me='Meatbeat:AwAFCAsABAoAAA==.Megahorn:AwAGCA0ABAoAAA==.Metalwarrior:AwAFCA0ABAoAAA==.',Mi='Mikki:AwADCAcABAoAAA==.Mild:AwACCAIABAoAAA==.Minishadow:AwAECAUABAoAAA==.Mistycuts:AwADCAUABAoAAA==.',Mo='Moltensalt:AwADCAQABAoAAA==.Motwprovider:AwAFCAQABAoAAA==.',Mu='Murman:AwADCAMABAoAAA==.',Na='Naoz:AwADCAgABAoAAA==.Nater:AwAGCAcABAoAAA==.',Ne='Nekkrosys:AwAGCAoABAoAAA==.Nekrron:AwAGCA8ABAoAAA==.',No='Noods:AwABCAEABRQCBAAIAQhKEQAzBx0CBAoABAAIAQhKEQAzBx0CBAoAAA==.Noshka:AwAGCAsABAoAAA==.Notarget:AwABCAEABAoAAQEAAAAHCA4ABAo=.',Oc='Octobër:AwAFCAUABAoAAA==.',Ok='Okishama:AwABCAEABRQDEAAIAQhiCABPqrQCBAoAEAAIAQhiCABPqrQCBAoAEQABAQjjcwAsDUIABAoAAA==.',Ot='Otsutsuki:AwAGCAEABAoAAA==.',Pa='Palamaine:AwADCAUABRQCAgADAQi8AgA4/tgABRQAAgADAQi8AgA4/tgABRQAAA==.',Pe='Pesty:AwAGCBAABAoAAA==.',Ph='Phate:AwABCAEABAoAAQEAAAACCAEABAo=.',Pl='Plikka:AwAGCAkABAoAAA==.',Po='Poggy:AwAGCAsABAoAAA==.Potsie:AwADCAMABAoAAA==.',Pr='Praesolus:AwADCAQABAoAAA==.Probstoned:AwABCAEABAoAAQEAAAAGCAIABAo=.Promocode:AwADCAUABRQCBwADAQjRBAAuPOYABRQABwADAQjRBAAuPOYABRQAAA==.',Qf='Qf:AwAICAIABAoAAQEAAAABCAEABRQ=.',Qu='Quatermain:AwAFCAkABAoAAA==.',Ra='Raazaa:AwAFCAcABAoAAA==.Rabbifrost:AwAFCAUABAoAAA==.Raeknor:AwAGCAgABAoAAA==.Rathvyr:AwABCAEABRQCEgAIAQhYAQBcJUQDBAoAEgAIAQhYAQBcJUQDBAoAAA==.Ravis:AwACCAIABAoAAQEAAAAECAQABAo=.',Re='Rebeakah:AwAFCA8ABAoAAA==.Recksel:AwAECAoABAoAAA==.Redbash:AwABCAIABRQAAA==.Reggs:AwAFCAEABAoAAA==.Rektify:AwAFCAcABAoAAA==.Reminara:AwAFCA8ABAoAAA==.Renko:AwAHCBAABAoAAA==.Revmeup:AwAGCBMABAoAAA==.',Ri='Riggs:AwAECAcABAoAAA==.Rilakuma:AwAECAYABAoAAA==.',Ro='Rokonin:AwAICAQABAoAAA==.Rozewyn:AwAFCAsABAoAAA==.',Ru='Russianlove:AwACCAMABAoAAA==.',Ry='Ryawhitefang:AwAGCA8ABAoAAA==.Ryujin:AwAICAkABAoAAA==.',['R�']='Rønín:AwABCAEABAoAAQEAAAAGCAcABAo=.',Sa='Saathea:AwADCAMABAoAAA==.Sangria:AwACCAIABAoAAA==.Saphirin:AwABCAEABRQCDAAIAQhDBQBTrdoCBAoADAAIAQhDBQBTrdoCBAoAAA==.',Sc='Schutzengel:AwAECAsABAoAAA==.Scorchgoblen:AwAICAgABAoAAA==.Scorchlife:AwAICAgABAoAAA==.Scribbl:AwABCAIABRQDCgAIAQivAwBTaHACBAoACgAHAQivAwBU3HACBAoACwAHAQjrFgBM4DICBAoAAA==.',Sh='Shadowscream:AwAHCAsABAoAAA==.Shamuraijack:AwAFCAkABAoAAA==.Shazbawt:AwABCAEABRQAAA==.Shiffty:AwAECAUABAoAAA==.Shäde:AwADCAUABRQCAwADAQh/BAAwr/UABRQAAwADAQh/BAAwr/UABRQAAA==.',Si='Siastra:AwADCAMABAoAAA==.',Sk='Skiethx:AwADCAUABRQDEwADAQgHAgBOzNQABRQAAwADAQjLAwBE5AcBBRQAEwACAQgHAgBf0NQABRQAAA==.Skra:AwABCAIABRQAAA==.Skullderz:AwAGCAYABAoAAA==.',Sl='Slowqt:AwAECAQABAoAAA==.',Sm='Smitherz:AwADCAMABAoAAA==.',Sp='Spacedusty:AwAGCA8ABAoAAA==.Spazgremlin:AwAICAgABAoAAA==.Splinters:AwACCAIABAoAAA==.Spnkynvrsoft:AwABCAIABRQAAA==.',St='Stabachacha:AwADCAUABRQCEwADAQgEAQBFMSUBBRQAEwADAQgEAQBFMSUBBRQAAA==.Stannistinyt:AwAGCAoABAoAAA==.Stdsrbop:AwAFCAUABAoAAA==.Stealthanie:AwADCAQABAoAAA==.Steamrage:AwACCAIABAoAAA==.Sth:AwACCAMABAoAAA==.Stinkie:AwABCAMABRQECgAIAQgOBABKX2ECBAoACgAHAQgOBABND2ECBAoACwABAQhZdQBIqUoABAoADwABAQjYKAAVCD4ABAoAAA==.Stonebeard:AwACCAMABAoAAQEAAAADCAMABAo=.Stonedpriest:AwAGCAIABAoAAA==.Stormcore:AwAECAQABAoAAA==.Stumpyrogue:AwACCAIABAoAAA==.Stârlight:AwAECAYABAoAAA==.',Su='Super:AwADCAQABRQDFAAIAQjrEQBLVJUCBAoAFAAIAQjrEQBK5JUCBAoAFQAFAQicMwBEFikBBAoAAA==.Surgate:AwAFCAsABAoAAA==.Suuhwas:AwADCAQABAoAAA==.',Sw='Swampybutt:AwACCAQABAoAAA==.',Sy='Sylverarrow:AwAGCA8ABAoAAA==.Symph:AwAFCAUABAoAAA==.',Ta='Tarnfair:AwADCAIABAoAAA==.',Te='Telvor:AwAECAIABAoAAA==.Terrukk:AwAECAQABAoAAA==.Teufelsnudel:AwAFCAYABAoAAA==.',Th='Therran:AwACCAIABAoAAQEAAAAGCAkABAo=.Theuss:AwAFCAUABAoAAA==.Thirdlegg:AwAHCAEABAoAAA==.',Ti='Tigerclaw:AwABCAEABAoAAA==.Tingaling:AwAFCA4ABAoAAA==.',To='Toothlss:AwADCAQABAoAAA==.Totums:AwAECAUABAoAAA==.',Tr='Trein:AwAFCA4ABAoAAA==.Tribalz:AwAGCAsABAoAAA==.Trunddle:AwACCAIABAoAAA==.',Tu='Turbeauxheal:AwAICAsABAoAAA==.',Va='Valenia:AwACCAQABAoAAA==.Valmont:AwAGCAwABAoAAA==.',Ve='Vekz:AwAGCAsABAoAAA==.Vellarïa:AwAGCCAABAoCFgAGAQgiHgA4cJsBBAoAFgAGAQgiHgA4cJsBBAoAAA==.Vervlock:AwADCAUABRQCCwADAQhbBAA82f4ABRQACwADAQhbBAA82f4ABRQAAA==.Vervwar:AwACCAQABAoAAQsAPNkDCAUABRQ=.',Vo='Voltedrage:AwAGCA0ABAoAAA==.Voucher:AwAGCAgABAoAAQcALjwDCAUABRQ=.',Vy='Vysérå:AwAGCA8ABAoAAA==.',['V�']='Vénkman:AwAGCA4ABAoAAA==.',Wa='Warluma:AwACCAIABAoAAA==.',Wi='Wil:AwAGCAYABAoAAA==.Wildbilly:AwAHCBUABAoDAwAHAQizEAAvIdsBBAoAAwAHAQizEAAvB9sBBAoAEwACAQjEKgAghUYABAoAAA==.Wizzlewozzle:AwAECAcABAoAAA==.',Wo='Worldwaker:AwAHCBUABAoCBAAHAQg7CgBS3pMCBAoABAAHAQg7CgBS3pMCBAoAAA==.',Wy='Wylblly:AwAHCBIABAoAAA==.',Xc='Xcarnage:AwACCAIABAoAAA==.',Xg='Xgambit:AwAFCA0ABAoAAA==.',Yu='Yuckmouth:AwAGCBQABAoCFQAGAQixHgBCz78BBAoAFQAGAQixHgBCz78BBAoAAA==.',Za='Zadaen:AwAECAkABAoAAA==.Zankey:AwAGCBAABAoAAA==.Zaquel:AwAECAcABAoAAA==.',Ze='Zenpally:AwAFCAcABAoAAA==.',Zo='Zolur:AwAECAQABRQCBwAEAQhdAgA3IzABBRQABwAEAQhdAgA3IzABBRQAAA==.',['Ç']='Çhef:AwAICAoABAoAAA==.',['Ð']='Ðjinzen:AwAFCAMABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end