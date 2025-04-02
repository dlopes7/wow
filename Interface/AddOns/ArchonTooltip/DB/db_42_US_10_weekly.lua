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
 local lookup = {'Monk-Mistweaver','Evoker-Devastation','Unknown-Unknown','Warrior-Protection','Hunter-BeastMastery','Druid-Feral','DemonHunter-Vengeance','Priest-Discipline','DeathKnight-Unholy','Priest-Shadow','Priest-Holy','Paladin-Retribution','DemonHunter-Havoc','Mage-Frost','Shaman-Enhancement','DeathKnight-Frost','Paladin-Holy','Druid-Restoration','Druid-Balance','Shaman-Elemental','Shaman-Restoration','Paladin-Protection','Warlock-Destruction','Warlock-Demonology','Rogue-Assassination','DeathKnight-Blood','Warrior-Fury',}; local provider = {region='US',realm="Aman'Thul",name='US',type='weekly',zone=42,date='2025-03-29',data={Ab='Abigore:AwAFCAcABAoAAA==.Abronar:AwAGCAIABAoAAA==.',Ad='Adrenalin:AwAFCAsABAoAAA==.',Ae='Aellan:AwAFCAgABAoAAA==.',Aj='Ajairu:AwAHCBUABAoCAQAHAQizFABASw0CBAoAAQAHAQizFABASw0CBAoAAA==.',Al='Alwaays:AwADCAgABRQCAQADAQiEBgAvDOUABRQAAQADAQiEBgAvDOUABRQAAA==.Alwaystoo:AwAECAQABAoAAA==.',An='Anarithal:AwAGCBQABAoCAgAGAQi7EwA9BL0BBAoAAgAGAQi7EwA9BL0BBAoAAA==.Anarà:AwADCAYABAoAAA==.Anilynn:AwAECAcABAoAAQMAAAADCAQABRQ=.Anima:AwAECAUABAoAAA==.Anklebreakr:AwAFCAMABAoAAA==.Anubiset:AwACCAIABAoAAA==.',Ar='Aralak:AwAICAkABAoAAA==.Ardejah:AwAGCAMABAoAAA==.Artey:AwADCAIABAoAAA==.',As='Astrou:AwAGCBIABAoAAA==.',At='Atypical:AwAECAsABAoAAA==.',Ay='Aylissia:AwAFCAMABAoAAA==.',Az='Azappycrom:AwAHCA0ABAoAAA==.',Ba='Balefiree:AwAECAgABAoAAA==.Bananawoman:AwABCAEABAoAAA==.',Be='Beachballs:AwADCAoABAoAAA==.Beariel:AwABCAEABAoAAA==.Belest:AwACCAMABAoAAA==.',Bi='Biba:AwAICA8ABAoAAA==.Bigdawgrico:AwAHCBUABAoCBAAHAQhkAwBSvoMCBAoABAAHAQhkAwBSvoMCBAoAAA==.Bigkek:AwABCAEABAoAAA==.Bigstotems:AwACCAIABAoAAA==.Binarn:AwAECAkABAoAAA==.',Bl='Bloodlust:AwAGCA4ABAoAAA==.Bluebrood:AwADCAUABAoAAA==.',Bo='Boenarrow:AwAECAUABAoAAA==.Bofreddy:AwACCAIABAoAAA==.Bojack:AwAECAYABAoAAA==.Bonengaw:AwAGCAsABAoAAA==.Bowser:AwAGCAoABAoAAA==.',Br='Brakwa:AwAHCAQABAoAAA==.Broganz:AwABCAEABAoAAA==.Brreach:AwAFCA4ABAoAAA==.',Bt='Btee:AwAECAgABAoAAA==.',Bu='Bulkbilling:AwADCAUABAoAAA==.Bullus:AwAFCAkABAoAAA==.Buntz:AwAGCA0ABAoAAA==.Butchër:AwADCAUABRQCBQADAQgRCwAneNYABRQABQADAQgRCwAneNYABRQAAA==.',Ca='Cadet:AwACCAIABAoAAQMAAAAGCAcABAo=.Canineed:AwAGCAUABAoAAA==.Caströ:AwAECAkABAoAAA==.',Ce='Celad:AwAFCAsABAoAAA==.',Ch='Cheeka:AwAFCA4ABAoAAA==.',Cl='Cleavís:AwADCAoABAoAAA==.',Co='Completer:AwACCAIABAoAAA==.Copitsweeter:AwACCAQABAoAAA==.Corvyncos:AwADCAQABAoAAA==.',Cr='Cramberly:AwADCAQABAoAAA==.Cristeria:AwEBCAIABAoAAQMAAAADCAMABAo=.',Cu='Cucklemcgee:AwACCAIABAoAAA==.',Cy='Cyaneum:AwAECAoABAoAAA==.Cyraxx:AwAGCBMABAoAAA==.',Da='Dabita:AwAECAIABAoAAA==.Daddybaby:AwAFCAIABAoAAA==.Daewong:AwAFCAoABAoAAA==.Dake:AwAFCAYABAoAAA==.Damian:AwAGCAoABAoAAA==.Dasherd:AwAECAgABAoAAA==.',De='Deadgrin:AwAECAoABAoAAA==.Deadschoo:AwAFCAkABAoAAQYAJLADCAUABRQ=.Deejaye:AwAFCA4ABAoAAA==.Defyndk:AwABCAEABAoAAA==.Dellie:AwADCAEABAoAAA==.Demonkeeper:AwABCAEABAoAAA==.Denardiir:AwABCAEABAoAAQMAAAAGCBAABAo=.',Dh='Dhukkha:AwAHCBUABAoCBwAHAQgXBABcRcoCBAoABwAHAQgXBABcRcoCBAoAAA==.',Di='Diseased:AwAECAgABAoAAA==.Disk:AwAHCBUABAoCCAAHAQidHAAodGsBBAoACAAHAQidHAAodGsBBAoAAA==.Disperse:AwAHCBQABAoCCAAHAQj6EQA/AuUBBAoACAAHAQj6EQA/AuUBBAoAAA==.',Dm='Dmgfordays:AwAFCAMABAoAAA==.',Do='Dorallyna:AwABCAEABAoAAA==.Downpour:AwAGCA0ABAoAAA==.',Dr='Dragonhopes:AwAECAoABAoAAA==.Dragonscent:AwAFCAkABAoAAA==.Drated:AwADCAUABRQCCQADAQibBQAL6bYABRQACQADAQibBQAL6bYABRQAAA==.Drepung:AwAECAkABAoAAA==.',Du='Dugras:AwACCAEABAoAAA==.Duoindepink:AwAFCAUABAoAAA==.',Ea='Eaglekick:AwAECAIABAoAAA==.',Ed='Eddo:AwABCAEABAoAAA==.Edendil:AwAHCBoABAoDCgAHAQgyEwA+egICBAoACgAHAQgyEwA+egICBAoACwABAQiTYwAZdTAABAoAAA==.',El='Elleryl:AwADCAcABAoAAA==.Ellieria:AwAFCAgABAoAAA==.',Em='Emeraldjuice:AwAECAgABAoAAA==.',Eu='Eurel:AwADCAsABAoAAA==.',Ev='Eviltank:AwAHCBUABAoCDAAHAQiSJwBOXFMCBAoADAAHAQiSJwBOXFMCBAoAAA==.Evo:AwADCAYABAoAAA==.',Ez='Ezzbot:AwAGCAsABAoAAA==.',Fa='Fallenfaith:AwAGCAwABAoAAA==.Falluin:AwAHCBUABAoCDQAHAQgoMAAiiKIBBAoADQAHAQgoMAAiiKIBBAoAAA==.Fanchone:AwAECAQABAoAAA==.Fatandseexy:AwAICA0ABAoAAA==.',Fe='Felcrom:AwAFCAkABAoAAQMAAAAHCA0ABAo=.Felfliction:AwAGCAIABAoAAA==.Felinae:AwADCAYABAoAAA==.Felwynbrooke:AwABCAEABAoAAA==.Fenember:AwAFCAMABAoAAA==.',Fi='Firekhan:AwAGCA8ABAoAAA==.Fishxo:AwAECAUABAoAAQMAAAAHCAoABAo=.',Fl='Fluticasone:AwABCAEABAoAAA==.',Fm='Fma:AwAICAkABAoAAA==.',Fo='Foresight:AwADCAEABAoAAA==.',Fu='Fugrinthepus:AwABCAEABRQAAA==.Fuzzybaddrag:AwACCAIABAoAAQMAAAAGCA0ABAo=.Fuzzydks:AwAGCA0ABAoAAA==.',['F�']='Físh:AwAHCAoABAoAAA==.Fózzy:AwAGCBMABAoAAA==.',Ga='Garelle:AwAICBwABAoCDgAIAQgQCwBJwYwCBAoADgAIAQgQCwBJwYwCBAoAAA==.Gargamoyle:AwAECAEABAoAAA==.Gateweaver:AwAECAsABAoAAA==.',Gi='Gingey:AwAICAkABAoAAA==.',Go='Goliathxx:AwADCAUABAoAAA==.Gosly:AwAGCAMABAoAAA==.',Gr='Grandwar:AwAICAsABAoAAA==.Gravér:AwAGCA0ABAoAAA==.Greenforbarb:AwABCAEABRQAAQMAAAACCAQABRQ=.Griemm:AwAHCAYABAoAAA==.Grimfisty:AwADCAMABAoAAA==.',Gu='Guzpriest:AwABCAEABAoAAQMAAAAFCAgABAo=.Guzrogue:AwAFCAgABAoAAA==.',Ha='Haastkrieg:AwAFCA4ABAoAAA==.Hakzart:AwADCAgABRQCBQADAQjtCAA3ZvgABRQABQADAQjtCAA3ZvgABRQAAA==.Hamplanet:AwABCAEABAoAAA==.Harubright:AwABCAEABRQAAQEAR8MECAsABRQ=.Haruchi:AwAECAsABRQCAQAEAQhYAQBHw3oBBRQAAQAEAQhYAQBHw3oBBRQAAA==.Haruwhuh:AwAICBMABAoAAQEAR8MECAsABRQ=.',He='Healthcare:AwABCAEABAoAAA==.Hearte:AwAGCBQABAoCDwAGAQg5HgAsXn8BBAoADwAGAQg5HgAsXn8BBAoAAA==.Hermy:AwAHCBAABAoAAA==.',Ho='Holing:AwAFCAwABAoAAA==.Honeyduke:AwAFCAcABAoAAA==.Hornyhunt:AwABCAEABAoAAA==.',Hy='Hyzal:AwAICAUABAoAAA==.',['H�']='Héod:AwAFCAwABAoAAA==.',Id='Idìot:AwACCAQABAoAAA==.',Ii='Iira:AwAHCAwABAoAAA==.',Il='Illerine:AwAECAIABAoAAA==.',In='Indecisions:AwAICAgABAoAAA==.Inspirez:AwADCAMABAoAAA==.',It='Itsnotbatman:AwAFCAkABAoAAA==.',['I�']='Iìe:AwAHCBMABAoAAA==.',Ja='Jaland:AwAECAkABAoAAA==.Janeygirl:AwAECAgABAoAAA==.',Je='Jessehunt:AwAHCBYABAoCBQAHAQgUMgA7Hd8BBAoABQAHAQgUMgA7Hd8BBAoAAA==.Jezebel:AwADCAkABAoAAA==.',Jo='Joesef:AwAECAYABAoAAA==.Johnyf:AwABCAEABAoAAA==.Jonononomonk:AwABCAEABRQAAA==.Jonz:AwADCAYABAoAAA==.',Jy='Jynxed:AwABCAEABAoAAA==.',Ka='Kaizo:AwAGCBMABAoAAA==.Kalanix:AwADCAEABAoAAA==.Kallabreete:AwABCAEABAoAAA==.Kanatari:AwAGCBQABAoCCwAGAQg8DQBXa0kCBAoACwAGAQg8DQBXa0kCBAoAAA==.Karaleigh:AwAGCA8ABAoAAA==.Kattadin:AwAFCAkABAoAAA==.Kauraku:AwAFCAkABAoAAA==.',Ke='Kerlinda:AwAFCAYABAoAAA==.Keybricker:AwAICAgABAoAAQMAAAAICAgABAo=.',Kh='Khiana:AwAGCBIABAoAAA==.',Ki='Kicked:AwAHCAcABAoAAQoAUrgCCAQABRQ=.Kittymik:AwADCAkABAoAAA==.',Kn='Knarr:AwAFCAoABAoAAA==.',Ko='Korhil:AwAFCAgABAoAAA==.',Kr='Krumku:AwABCAEABAoAAA==.Krystàl:AwAFCAUABAoAAA==.',Ku='Kuddy:AwAECAQABAoAAA==.Kungsue:AwACCAIABAoAAA==.',Ky='Kyrokh:AwAECAYABAoAAA==.',Le='Lebronjr:AwAECAQABAoAAA==.Leniishii:AwABCAEABAoAAA==.',Li='Lightblade:AwAECAgABAoAAA==.Lindel:AwADCAIABAoAAA==.Lionkat:AwABCAIABAoAAA==.',Lo='Lolbubbles:AwAHCAsABAoAAA==.Lost:AwACCAUABRQCEAACAQgeAQBiu+YABRQAEAACAQgeAQBiu+YABRQAAA==.',Lu='Luye:AwAFCAwABAoAAA==.',['L�']='Léäf:AwAECAQABAoAAA==.Lõx:AwAFCBAABAoAAA==.',Ma='Macloven:AwABCAEABAoAAA==.Madoxx:AwAHCBMABAoAAA==.Magictacos:AwAGCA4ABAoAAQMAAAAGCA4ABAo=.Magnastar:AwADCAMABAoAAA==.Magnusg:AwABCAIABAoAAA==.Magone:AwAECAwABAoAAA==.Malice:AwABCAEABAoAAA==.Malvana:AwAFCA8ABAoAAA==.Malys:AwAGCBAABAoAAA==.Manacledk:AwAFCAgABAoAAA==.Maraach:AwAFCAEABAoAAA==.Marlos:AwAHCBUABAoCEQAHAQj2CgBChwgCBAoAEQAHAQj2CgBChwgCBAoAAA==.Marthaus:AwAECAcABAoAAA==.Mattrik:AwADCAkABAoAAA==.',Mc='Mcduff:AwADCAcABAoAAA==.',Me='Meatshièld:AwACCAIABAoAAA==.Medalion:AwADCAYABAoAAA==.Meserin:AwAFCAsABAoAAA==.',Mi='Midwa:AwADCAgABRQCDAADAQiABQBWPigBBRQADAADAQiABQBWPigBBRQAAA==.Mikasaro:AwACCAIABAoAAA==.Missnofun:AwAECAkABAoAAA==.Mistae:AwADCAQABRQAAA==.',Mo='Moonbeef:AwABCAEABRQDEgAIAQgXDQBAiy0CBAoAEgAIAQgXDQBAiy0CBAoAEwAGAQiCSgAVK8gABAoAAA==.Mowjow:AwAGCAgABAoAAA==.',My='Myrsham:AwAHCBUABAoDFAAHAQjeCQBUxZoCBAoAFAAHAQjeCQBUxZoCBAoAFQABAQhkegALLS4ABAoAAA==.Mythbrediir:AwAGCBAABAoAAA==.',['M�']='Mønk:AwAHCA8ABAoAAA==.',Na='Naralaeda:AwAECAUABAoAAQMAAAAFCAoABAo=.Nazaha:AwADCAUABRQCCwADAQi/AQBLzB8BBRQACwADAQi/AQBLzB8BBRQAAA==.',Ne='Nefarox:AwAFCAkABAoAAA==.Nekhrimah:AwAFCAYABAoAAA==.Nerfe:AwAGCBAABAoAAA==.Nexaarsh:AwAHCAcABAoAAA==.',Ni='Nightlydruid:AwADCAUABAoAAA==.Nirnroot:AwAGCA4ABAoAAA==.Nitelite:AwAICAcABAoAAA==.',No='Norf:AwAGCA8ABAoAAA==.Notbeezy:AwACCAIABAoAAA==.Notpettanko:AwAFCAYABAoAAA==.',Ny='Nykfury:AwAFCAEABAoAAA==.',Ol='Olunaija:AwACCAMABAoAAA==.',Om='Omm:AwACCAQABAoAAA==.',On='Onlyclaws:AwAHCBEABAoAAA==.',Ov='Overhealer:AwAHCAMABAoAAA==.',Pa='Pachi:AwABCAIABAoAAA==.Paladumb:AwADCAUABRQDDAADAQiREwATzYIABRQADAACAQiREwAb1YIABRQAFgABAQjRCwADvRQABRQAAA==.Palalaladin:AwAHCBUABAoCFgAHAQj4AwBblswCBAoAFgAHAQj4AwBblswCBAoAAA==.Panchovy:AwAGCA8ABAoAAA==.Pandoc:AwAHCAEABAoAAA==.Pawg:AwACCAQABRQCCgAIAQhNCABSuL0CBAoACgAIAQhNCABSuL0CBAoAAA==.',Pe='Pepimack:AwAGCA0ABAoAAA==.Pepps:AwAGCAMABAoAAA==.',Pi='Pingvellir:AwABCAEABAoAAQMAAAAECAkABAo=.Pipiwolf:AwAFCAMABAoAAA==.',Pl='Plaxie:AwAFCAkABAoAAQMAAAAGCA0ABAo=.Plaxina:AwAGCA0ABAoAAA==.Plazmapoke:AwAGCBMABAoAAA==.',Po='Pogo:AwACCAQABRQAAA==.Poofartsmell:AwACCAIABAoAAA==.Poppylotus:AwABCAEABAoAAA==.',Pr='Precioùs:AwACCAQABAoAAA==.Prototank:AwACCAIABAoAAA==.Protêk:AwADCAQABRQCDgAIAQiIAABi0IcDBAoADgAIAQiIAABi0IcDBAoAAA==.',Pu='Pungar:AwADCAQABAoAAA==.',Ra='Raeka:AwAECAUABAoAAA==.Raitez:AwAGCAMABAoAAA==.Rathomarr:AwAHCBUABAoCBQAHAQhdMAA7c+kBBAoABQAHAQhdMAA7c+kBBAoAAA==.Rawlôck:AwAHCBUABAoDFwAHAQjYJQA2GrwBBAoAFwAHAQjYJQA0jLwBBAoAGAABAQg+OQBL91AABAoAAA==.Rawromg:AwAFCAMABAoAAA==.Raxor:AwADCAMABAoAAA==.Razzpriest:AwAECAoABAoAAA==.',Re='Rendaxe:AwAHCBMABAoAAA==.Respi:AwAECAgABAoAAA==.Retalica:AwAHCBUABAoDDAAHAQiuWwAt8oQBBAoADAAGAQiuWwA03YQBBAoAFgABAQj0QwAEbA4ABAoAAA==.Retrishi:AwAECAUABAoAAA==.',Ri='Richnight:AwAFCAgABAoAAA==.Rickettsia:AwAFCA8ABAoAAA==.Rileda:AwAGCAYABAoAAA==.',Ro='Rollingrick:AwADCAMABAoAAA==.Rorro:AwAGCA4ABAoAAA==.',Rt='Rttn:AwABCAEABAoAAA==.',Ru='Ruripe:AwADCAUABAoAAA==.',Ry='Ryri:AwABCAIABAoAAA==.',Sa='Sabren:AwAGCBMABAoAAA==.Saccromycaes:AwADCAUABAoAAA==.Sahas:AwAGCA0ABAoAAA==.Salmoncado:AwAFCBUABAoCDAAFAQiGXABHIIEBBAoADAAFAQiGXABHIIEBBAoAAA==.Saridannan:AwADCAYABAoAAA==.Sativa:AwABCAEABAoAAA==.',Sc='Scars:AwAHCA4ABAoAAA==.Scotchfiend:AwAGCAsABAoAAQYAJLADCAUABRQ=.',Se='Seculor:AwAICAgABAoAAA==.Selten:AwAHCBUABAoCGQAHAQgIDQAxwtoBBAoAGQAHAQgIDQAxwtoBBAoAAA==.Serajade:AwAECAcABAoAAA==.Seraphinia:AwACCAIABAoAAA==.',Sh='Shadowcrag:AwADCAMABAoAAA==.Shamanrager:AwAFCAkABAoAAA==.Shammah:AwAFCAsABAoAAA==.Shellatrix:AwAHCBAABAoAAA==.Shellzy:AwAECAcABAoAAA==.Shepp:AwAFCAsABAoAAA==.',Si='Sinderela:AwAHCAcABAoAAA==.Sinisterwing:AwAFCAoABAoAAA==.Sinren:AwAFCAkABAoAAA==.',Sk='Skeptikk:AwAHCBMABAoAAA==.',Sl='Slateray:AwACCAMABAoAAA==.Slie:AwAFCAUABAoAAA==.Slyr:AwAFCA0ABAoAAA==.',So='Solarquakes:AwAICBEABAoAAA==.',Sp='Spatspell:AwAICAgABAoAAA==.Spudacus:AwAECAkABAoAAA==.',St='Stariel:AwAECAcABAoAAA==.Stormin:AwAECAoABAoAAA==.Streuth:AwAHCBUABAoCBAAHAQhZAwBRboUCBAoABAAHAQhZAwBRboUCBAoAAA==.Strummer:AwADCAUABRQCBQADAQhwDAAvZb0ABRQABQADAQhwDAAvZb0ABRQAAA==.',Su='Suaidrai:AwAECAQABAoAAA==.Subaruu:AwADCAgABAoAAA==.Subsiding:AwAECAYABAoAAA==.Supagroova:AwAICAgABAoAAA==.Supernothing:AwADCAMABAoAAA==.',Sw='Swirlza:AwAHCBIABAoAAA==.Swordfish:AwADCAoABAoAAA==.',Sy='Sylanthia:AwADCAUABAoAAA==.',['S�']='Sóg:AwAGCBQABAoCDQAGAQg1EgBgxJcCBAoADQAGAQg1EgBgxJcCBAoAAA==.',Ta='Tabknight:AwAGCBQABAoCGgAGAQh1FAA+oJ0BBAoAGgAGAQh1FAA+oJ0BBAoAAA==.Taelm:AwADCAEABAoAAA==.Targetone:AwAHCBIABAoAAA==.',Te='Tempo:AwAECAQABAoAAA==.Tenleigh:AwABCAEABAoAAA==.Terrorizor:AwADCAgABAoAAA==.',Th='Thargor:AwAGCBQABAoCGwAGAQg1DQBhBJkCBAoAGwAGAQg1DQBhBJkCBAoAAA==.Thefluffyman:AwAECAEABAoAAA==.Thendroz:AwADCAUABAoAAA==.Thiss:AwAFCA4ABAoAAA==.Thumperdumps:AwABCAEABAoAAA==.',Ti='Tiles:AwAECAUABAoAAA==.Tinytotem:AwAHCBEABAoAAA==.Titch:AwACCAIABAoAAA==.',To='Toehacker:AwADCAMABAoAAA==.',Tr='Treeko:AwAGCAYABAoAAA==.Trickytrix:AwAFCAQABAoAAA==.Trucmuche:AwAGCBAABAoAAA==.',Tw='Twofresh:AwACCAQABRQAAA==.',Ty='Tyrazar:AwADCAgABRQCFgADAQhEAQBXHy4BBRQAFgADAQhEAQBXHy4BBRQAAA==.Tyrazor:AwAECAQABAoAAA==.',['T�']='Tím:AwAFCA4ABAoAAA==.',Ul='Ultuulla:AwAGCAMABAoAAA==.',Un='Unholydk:AwACCAIABAoAAA==.',Uw='Uwusue:AwACCAMABRQCCwAIAQghDgBDVD0CBAoACwAIAQghDgBDVD0CBAoAAA==.',Va='Vandareye:AwAHCBAABAoAAA==.Varainne:AwAFCAkABAoAAA==.',Ve='Velgath:AwADCAQABRQAAA==.Venessense:AwAFCA4ABAoAAA==.Verr:AwAGCAMABAoAAA==.',Vi='Vioneva:AwAFCAIABAoAAA==.Virtuousity:AwADCAQABAoAAA==.Viscelock:AwAGCBQABAoCGwAGAQjJKQAp14IBBAoAGwAGAQjJKQAp14IBBAoAAA==.',Vx='Vxi:AwABCAEABRQCGQAIAQiXAgBdugcDBAoAGQAIAQiXAgBdugcDBAoAAA==.',Xa='Xaryn:AwAFCAkABAoAAA==.',Xi='Xiaocai:AwAICAQABAoAAQMAAAACCAIABRQ=.',Ya='Yamraiha:AwAICAgABAoAAA==.',Za='Zappygilmore:AwAHCBAABAoAAA==.',Ze='Zelder:AwAGCAcABAoAAA==.Zex:AwAFCAwABAoAAA==.Zeyan:AwAHCBUABAoCFAAHAQgdFQBAEe4BBAoAFAAHAQgdFQBAEe4BBAoAAA==.',Zi='Ziba:AwAHCBUABAoCBQAHAQjvMgA3VdoBBAoABQAHAQjvMgA3VdoBBAoAAA==.Zingerstacka:AwAFCAoABAoAAA==.',Zo='Zorel:AwAGCBEABAoAAA==.',Zz='Zz:AwABCAIABRQCDwAIAQgCBABZRBsDBAoADwAIAQgCBABZRBsDBAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end