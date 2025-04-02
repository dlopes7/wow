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
 local lookup = {'Monk-Windwalker','DemonHunter-Vengeance','Priest-Shadow','Evoker-Devastation','DeathKnight-Unholy','DeathKnight-Frost','DeathKnight-Blood','Hunter-Marksmanship','Hunter-BeastMastery','Paladin-Retribution','Unknown-Unknown','Warlock-Destruction','Mage-Fire','Shaman-Enhancement','DemonHunter-Havoc','Druid-Balance','Rogue-Assassination','Rogue-Subtlety','Rogue-Outlaw','Monk-Mistweaver','Warlock-Affliction','Warlock-Demonology','Mage-Frost','Priest-Discipline','Paladin-Holy','Paladin-Protection','Warrior-Fury','Shaman-Restoration','Druid-Restoration','Shaman-Elemental','Warrior-Arms',}; local provider = {region='US',realm='Stormreaver',name='US',type='weekly',zone=42,date='2025-03-28',data={Aa='Aaragondelta:AwAGCAYABAoAAA==.Aaragonium:AwAICAwABAoAAQEAPtkFCAoABRQ=.Aaragonius:AwACCAIABAoAAA==.Aaragonneo:AwAFCAoABRQCAQAFAQhjAAA+2dkBBRQAAQAFAQhjAAA+2dkBBRQAAA==.Aaragontheta:AwABCAEABAoAAQEAPtkFCAoABRQ=.',Ac='Ackreseth:AwAFCAoABAoAAA==.',Ad='Adrelia:AwAGCAYABAoAAA==.Advillidan:AwAECA0ABAoAAA==.',Ai='Aiee:AwAFCAUABAoAAA==.',Am='Ameliapónd:AwAFCAUABAoAAA==.',Ap='Apodal:AwAGCAoABAoAAQIAN20FCAoABRQ=.Applesnapple:AwADCAEABAoAAA==.',Ar='Arktus:AwADCAIABAoAAA==.Armadagedon:AwACCAIABAoAAA==.Arrithion:AwAGCAwABAoAAA==.Arthaz:AwACCAIABRQCAwAIAQiiDQA6LVMCBAoAAwAIAQiiDQA6LVMCBAoAAQQAI4QFCAcABRQ=.Arutorius:AwADCAoABAoAAA==.',At='Atexnogaraa:AwAECAQABAoAAQEAPtkFCAoABRQ=.',Ax='Axtin:AwACCAIABAoAAA==.',Ba='Babayagadk:AwAICBYABAoEBQAIAQjeIAAtQbABBAoABQAIAQjeIAAhd7ABBAoABgAHAQjlDQAc0U8BBAoABwADAQiNLAAknpgABAoAAA==.Baeldun:AwACCAIABAoAAA==.Bashm:AwAGCBMABAoAAA==.',Be='Beens:AwADCAYABRQDCAADAQhKAgBDgbUABRQACAACAQhKAgBSBLUABRQACQACAQgQDgAqQqEABRQAAA==.Belowzerolol:AwAFCAoABRQCCgAFAQgNAABf6i8CBRQACgAFAQgNAABf6i8CBRQAAA==.',Bi='Bigchimpin:AwAICAwABAoAAA==.Biggie:AwAFCAcABAoAAA==.',Bl='Bleeke:AwADCAEABAoAAA==.',Br='Breadbowl:AwACCAIABAoAAQsAAAAGCBMABAo=.Brocc:AwAHCAoABAoAAQoAX+oFCAoABRQ=.',Bu='Bubbleôseven:AwAGCAUABAoAAA==.Bullzzeye:AwAICBEABAoAAA==.',['B�']='Bêav:AwAICAgABAoAAQoAVi8BCAEABRQ=.Bëar:AwABCAEABRQAAA==.',Ca='Cabe:AwAGCAYABAoAAA==.Canwin:AwAGCAoABAoAAQwAQtMFCAoABRQ=.Carnagemage:AwAGCAYABAoAAA==.',Ch='Chasel:AwACCAIABRQCDQAIAQgiJAAnQdsBBAoADQAIAQgiJAAnQdsBBAoAAA==.Chewtoy:AwADCAMABAoAAA==.Chonk:AwABCAEABRQAAQsAAAABCAIABRQ=.Choobert:AwAFCAgABAoAAA==.',Co='Cogsley:AwAHCA8ABAoAAA==.Cornnut:AwAGCAoABAoAAA==.Corns:AwAFCAcABRQCDgAFAQiQAAAucaABBRQADgAFAQiQAAAucaABBRQAAA==.',Cr='Craptastic:AwAHCBUABAoCCQAHAQjiMgAxkswBBAoACQAHAQjiMgAxkswBBAoAAA==.Creac:AwABCAIABRQAAA==.Crispfingers:AwADCAMABAoAAA==.',Da='Damonic:AwACCAEABAoAAA==.Damoshh:AwAGCAsABAoAAA==.Dayman:AwAGCBMABAoAAA==.Daythyme:AwAECAcABAoAAA==.Dazzledan:AwADCAMABAoAAA==.',De='Deeztotemz:AwADCAMABAoAAA==.Deidre:AwAECAkABAoAAA==.Delchapo:AwAFCAwABAoAAA==.Demonicpeon:AwAECAgABAoAAA==.Deyedael:AwABCAIABAoAAA==.Deylicious:AwAGCA8ABAoAAQkAODAFCAoABRQ=.',Df='Dfib:AwADCAcABAoAAA==.',Dh='Dh:AwAECAYABRQCDwAEAQj4AQApq2wBBRQADwAEAQj4AQApq2wBBRQAAA==.',Di='Dijoe:AwADCAMABAoAAA==.',Dr='Dragondyz:AwAFCAcABRQCBAAFAQgGAQAjhIUBBRQABAAFAQgGAQAjhIUBBRQAAA==.Dragonpls:AwAECAQABAoAAA==.Dreteraktwo:AwAGCAIABAoAAA==.Drive:AwAICAwABAoAAA==.',El='Elemeffayoh:AwAECAQABAoAAA==.Eli:AwAICAgABAoAAA==.Elo:AwAICBEABAoAAA==.Eluneimati:AwAICA4ABAoAAA==.',En='Enfuego:AwAGCBMABAoAAA==.',Es='Escapades:AwAGCAYABAoAAA==.',Ev='Evalan:AwACCAIABAoAAA==.Evalen:AwACCAIABAoAAA==.',Fa='Faunuis:AwAFCAgABRQCEAAFAQhBAABEOukBBRQAEAAFAQhBAABEOukBBRQAAA==.',Fe='Fearthebeef:AwAGCAYABAoAAA==.Ferdubs:AwAECAIABAoAAA==.',Fi='Firnthuleien:AwADCAMABAoAAA==.',Fl='Fllin:AwABCAEABRQAAA==.',Fo='Foster:AwADCAMABAoAAA==.',Fu='Funklock:AwAHCBEABAoAAA==.',Ga='Gandàlin:AwADCAMABAoAAA==.',Gg='Ggator:AwABCAEABRQAAA==.',Gl='Glorý:AwAICAoABAoAAA==.',Go='Gonzgo:AwAFCAYABAoAAA==.Goopgrippin:AwAECAMABRQAAA==.',Gr='Gryff:AwAGCAsABAoAAA==.',Gu='Guap:AwAFCAoABRQCDQAFAQhrAABRvgcCBRQADQAFAQhrAABRvgcCBRQAAA==.Guldanshand:AwAECAUABAoAAA==.',['G�']='Gífted:AwAGCAUABAoAAA==.',Ha='Habana:AwABCAIABAoAAA==.',He='Hesafox:AwAFCAMABAoAAA==.Hexxie:AwABCAMABAoAAA==.',Hi='Hidendeathh:AwAGCBIABAoAAA==.',Ho='Hogslammer:AwABCAEABAoAAA==.',Hu='Hugétotem:AwAICAkABAoAAA==.',Ik='Ikedah:AwAICAgABAoAAA==.',Im='Imnosickmall:AwAGCAIABAoAAA==.',Io='Iolmop:AwAFCAcABAoAAA==.',Iy='Iyasu:AwABCAEABAoAAA==.',Je='Jellythug:AwACCAIABAoAAA==.Jerksnlocks:AwAHCAcABAoAAA==.Jexro:AwAECAcABRQCDwAEAQimAQBJ6XoBBRQADwAEAQimAQBJ6XoBBRQAAA==.',Ju='Juin:AwABCAEABAoAAA==.',Ka='Kancaked:AwAICAgABAoAAA==.Kartonnedoos:AwAECAcABAoAAA==.',Kb='Kblastis:AwAGCAUABAoAAA==.',Kh='Khronus:AwAHCAUABAoAAA==.',Ki='Killamark:AwAECAcABAoAAA==.',Ko='Koalageddon:AwAGCAYABAoAAA==.Koalateatime:AwACCAIABRQAAA==.Koalayonce:AwAECAQABAoAAA==.Koalitytime:AwAICBYABAoEEQAIAQj0DgBYpKQBBAoAEgAFAQhzEgBWfrMBBAoAEQAFAQj0DgBLr6QBBAoAEwADAQjnBgBYWv0ABAoAAA==.Kolgar:AwACCAIABAoAAA==.',Lo='Lockfocks:AwACCAIABAoAAA==.Loktark:AwAFCAoABRQCEwAFAQgCAABOi/4BBRQAEwAFAQgCAABOi/4BBRQAAA==.Lolladin:AwAGCAsABAoAAA==.Longrichard:AwAGCBQABAoCCgAGAQgoTQA9vaoBBAoACgAGAQgoTQA9vaoBBAoAAA==.Lootchi:AwAFCAoABRQCFAAFAQg4AABWSQkCBRQAFAAFAQg4AABWSQkCBRQAAA==.Lootinrouge:AwAGCBAABAoAARQAVkkFCAoABRQ=.',Ma='Madrons:AwAHCA0ABAoAAA==.Magedood:AwAFCAwABAoAAA==.Mambomarty:AwAFCAoABRQEDAAFAQgoAgBC0y8BBRQADAADAQgoAgBP7S8BBRQAFQABAQjfBwBdcWUABRQAFgABAQj+BwAA5z0ABRQAAA==.Manather:AwAECAcABRQDFwAEAQhAAABT1VABBRQAFwADAQhAAABkAFABBRQADQACAQhQDABAl7oABRQAAA==.',Mc='Mcbonk:AwAHCAYABAoAAA==.',Mi='Migeul:AwADCAEABAoAAA==.Minitank:AwAFCAUABAoAAA==.Mintwiskers:AwAECAkABAoAAA==.Mivix:AwAGCAoABAoAARgATlEFCAoABRQ=.',Mo='Mom:AwAGCAUABAoAAA==.',Mu='Mugged:AwADCAUABAoAAA==.Mushmouth:AwABCAIABRQCFwAHAQgkBwBaD8gCBAoAFwAHAQgkBwBaD8gCBAoAAA==.',Na='Naixdk:AwACCAIABRQAAA==.Naixs:AwAICAsABAoAAA==.Naixzz:AwAICBMABAoAAA==.Nalkrul:AwABCAEABAoAAA==.Naril:AwAGCAYABAoAAA==.Naturesneat:AwAECAEABAoAAA==.Nazgurl:AwABCAEABRQDEQAHAQg6BwBPIWsCBAoAEQAHAQg6BwBPIWsCBAoAEgABAQgsLwAnUDEABAoAAA==.',Ni='Nimmit:AwAFCA4ABAoAAA==.',No='Novath:AwAFCAoABRQDGQAFAQhiAQBPrB0BBRQAGQADAQhiAQBKbh0BBRQAGgACAQiOAwBDka0ABRQAAA==.',Ny='Nyssarissa:AwAFCBAABAoAAA==.',Oa='Oakenstream:AwAGCAUABAoAAA==.',Oe='Oennogaraa:AwABCAEABAoAAQEAPtkFCAoABRQ=.',Oh='Ohlookademon:AwAICAgABAoAAA==.',Pa='Palmface:AwAGCAYABAoAAA==.Pandanus:AwAFCAwABAoAAA==.Papalog:AwAGCAoABAoAAQgAWBQDCAYABRQ=.',Pe='Pedrocerrano:AwADCAIABAoAAA==.Pelthedh:AwAICAgABAoAAA==.Pevoker:AwAICAwABAoAAA==.',Pi='Pinecones:AwAICBIABAoAARsAXNUCCAQABRQ=.',Pl='Please:AwAFCAoABRQCHAAFAQhWAQALEksBBRQAHAAFAQhWAQALEksBBRQAAA==.Pleasetwo:AwACCAIABRQCHAAIAQjKAABfvGADBAoAHAAIAQjKAABfvGADBAoAARwACxIFCAoABRQ=.',Pr='Prezbyter:AwACCAIABAoAAA==.',Pu='Pugio:AwAGCAMABAoAAA==.',Ra='Ramulkin:AwABCAEABRQAAA==.Ranko:AwABCAIABRQAAA==.Rayden:AwACCAIABAoAAA==.',Re='Reavêr:AwADCAIABAoAAA==.Rebi:AwACCAIABAoAAA==.',Ri='Riddck:AwADCAEABAoAAA==.Rillata:AwABCAEABAoAAQsAAAAFCAwABAo=.',Ro='Rolltidex:AwAGCAoABAoAAA==.Roojin:AwAGCAUABAoAAA==.Roshana:AwAECAUABAoAAA==.',['R�']='Ràndle:AwAECAEABAoAAA==.',Sa='Same:AwACCAIABRQCHQAIAQg4AABiJ4IDBAoAHQAIAQg4AABiJ4IDBAoAARkAT6wFCAoABRQ=.',Sc='Scottwarren:AwAFCAoABAoAAA==.Scúbasteve:AwAECAYABAoAAA==.',Se='Sepheruss:AwACCAMABRQCCgAIAQgXEABXCOUCBAoACgAIAQgXEABXCOUCBAoAAA==.',Sh='Shirshakens:AwADCAMABAoAAA==.Shocklesnar:AwABCAIABRQCHgAIAQhHBABYtwEDBAoAHgAIAQhHBABYtwEDBAoAAA==.Shunbunn:AwACCAIABAoAAA==.',Si='Silverwen:AwABCAIABRQDCQAHAQj5EQBhDsQCBAoACQAHAQj5EQBd7cQCBAoACAAFAQgaDABgjxQCBAoAAA==.Sinestroo:AwACCAIABAoAAA==.Sinistratus:AwAFCAUABAoAAA==.Sinowbeat:AwACCAUABRQCDwAIAQglBQBZyTkDBAoADwAIAQglBQBZyTkDBAoAAQoAX+oFCAoABRQ=.Sipers:AwAGCAwABAoAAA==.',Sk='Skipcawk:AwAFCAoABRQCCQAFAQjJAAA4MLYBBRQACQAFAQjJAAA4MLYBBRQAAA==.',Sl='Slither:AwAFCAMABAoAAA==.',Sn='Snoopfrogg:AwABCAIABRQEDAAHAQgOMABB7mwBBAoADAAGAQgOMAAxz2wBBAoAFQADAQgiEgA5eegABAoAFgACAQi9JQBO5KoABAoAAA==.',So='Souladin:AwAGCAoABAoAAA==.',Ss='Ssjgoku:AwAECAQABAoAAA==.',St='Stormchief:AwABCAEABAoAAA==.',Su='Sunjosh:AwAECAkABAoAAA==.',Sy='Synched:AwAGCA4ABAoAAA==.',Ta='Taerinn:AwAGCAYABAoAAA==.',Te='Teddywaumpus:AwAGCAUABAoAAA==.',Th='Thabidness:AwADCAQABAoAAA==.Thanquiol:AwAFCAoABRQCAgAFAQgQAAA3bb4BBRQAAgAFAQgQAAA3bb4BBRQAAA==.Thebaraj:AwAFCAsABAoAAA==.Thesituàtion:AwAICAwABAoAAA==.Thêssius:AwAHCA8ABAoAAA==.',Ti='Tictactoast:AwAHCA4ABAoAAA==.Tike:AwACCAIABAoAAQsAAAAGCBMABAo=.Tinkr:AwABCAIABRQAAA==.Titianhex:AwAFCAcABAoAAA==.',To='Totemtimmy:AwACCAIABRQAAA==.',Tw='Twerktooth:AwAECAcABAoAAA==.Twistedhavoc:AwAECAEABAoAAA==.Twotime:AwADCAIABAoAAA==.',Ud='Udderlymoist:AwAGCAUABAoAAA==.',Um='Umalinn:AwAGCAYABAoAAA==.',Un='Undeadmotus:AwAGCA0ABAoAAA==.Unholyrep:AwABCAEABAoAAA==.',Va='Vacca:AwAGCAYABAoAAA==.Varsity:AwACCAQABRQDGwAIAQi9AgBc1UgDBAoAGwAIAQi9AgBc1UgDBAoAHwAFAQiRHAA1fz0BBAoAAA==.',Ve='Veldora:AwAECAUABAoAAA==.',We='Wetpickle:AwADCAYABAoAAA==.',Wi='Wickle:AwAFCAYABAoAAA==.',Wo='Woodbury:AwAECAUABAoAAA==.',Xi='Xivei:AwAFCAoABRQCGAAFAQg1AABOUeIBBRQAGAAFAQg1AABOUeIBBRQAAA==.',Ya='Yabookia:AwABCAEABAoAAA==.',Za='Zachx:AwAICAgABAoAAA==.Zarmakai:AwACCAIABRQDBQAIAQj7BABWGhADBAoABQAIAQj7BABUjhADBAoABgAIAQifBQA56jcCBAoAAA==.',Zo='Zomagawd:AwACCAMABAoAAA==.',Zu='Zufoot:AwACCAIABAoAARwACxIFCAoABRQ=.',['È']='Èula:AwAFCAYABAoAAA==.',['Ò']='Òdinn:AwAFCAIABAoAAA==.',['ß']='ßeav:AwABCAEABRQCCgAHAQjJJwBWL0gCBAoACgAHAQjJJwBWL0gCBAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end