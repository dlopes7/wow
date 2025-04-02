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
 local lookup = {'Shaman-Elemental','DeathKnight-Unholy','DeathKnight-Blood','Priest-Shadow','Monk-Mistweaver','Druid-Restoration','Unknown-Unknown','Warlock-Destruction','Warlock-Demonology','Warlock-Affliction','Druid-Balance','Evoker-Preservation','Evoker-Devastation','Mage-Frost','DemonHunter-Vengeance','DemonHunter-Havoc','Mage-Fire','Hunter-Survival','Rogue-Assassination','Rogue-Subtlety','Shaman-Restoration','Priest-Discipline','Priest-Holy','Paladin-Protection',}; local provider = {region='US',realm="Mug'thol",name='US',type='weekly',zone=42,date='2025-03-28',data={Ae='Aesthetic:AwAGCBAABAoAAA==.',Al='Alerion:AwAGCAEABAoAAA==.',Ap='Applejuice:AwAFCAwABAoAAA==.',Az='Azmun:AwAGCAEABAoAAA==.',Ba='Badtothebowz:AwACCAMABAoAAA==.Barragadin:AwAHCAgABAoAAA==.',Bl='Blackbelt:AwACCAIABAoAAA==.Blackdragon:AwABCAEABRQAAA==.',Bo='Boomtang:AwACCAIABAoAAA==.Boomwhistle:AwADCAYABRQCAQADAQhQAwAqUdkABRQAAQADAQhQAwAqUdkABRQAAA==.Bootyhunting:AwAFCAkABAoAAQEAUf8CCAMABRQ=.',Br='Bravoker:AwAGCAwABAoAAA==.',Bu='Bubblekush:AwAHCAMABAoAAA==.Bulkam:AwAHCBAABAoAAA==.Bunnylicious:AwABCAEABAoAAA==.Burblegobble:AwAGCAsABAoAAA==.',Ca='Callahan:AwAFCAoABAoAAA==.Cameltotemx:AwACCAMABRQCAQAIAQiEBwBR/7wCBAoAAQAIAQiEBwBR/7wCBAoAAA==.',Ch='Cheeziit:AwAHCAoABAoAAA==.Chifa:AwAFCAkABAoAAA==.Chisteaks:AwABCAEABAoAAA==.Chomrogg:AwAHCBUABAoDAgAHAQiGCgBYKakCBAoAAgAHAQiGCgBYKakCBAoAAwAFAQiCEABYk80BBAoAAA==.Chzdh:AwACCAIABAoAAQQASYAECAoABRQ=.Chzpriest:AwAECAoABRQCBAAEAQh6AQBJgGUBBRQABAAEAQh6AQBJgGUBBRQAAA==.',Co='Coddler:AwAHCBUABAoCBQAHAQgyBwBdX88CBAoABQAHAQgyBwBdX88CBAoAAA==.Concubine:AwACCAMABAoAAA==.Coolshade:AwAFCAsABAoAAA==.',Cr='Crabsurd:AwAECAcABAoAAA==.Crock:AwAECAYABAoAAQEAYqcECAMABRQ=.Crockito:AwAECAMABRQCAQAIAQhZAABip4EDBAoAAQAIAQhZAABip4EDBAoAAA==.',Cy='Cymist:AwACCAMABRQCBgAIAQi3AwBXMPACBAoABgAIAQi3AwBXMPACBAoAAA==.Cynk:AwAFCAUABAoAAA==.Cyrusdavirus:AwADCAYABAoAAA==.',Da='Dak:AwAECAcABAoAAA==.',De='Deathmawl:AwAFCAIABAoAAA==.Deqz:AwAGCAUABAoAAA==.',Di='Dingleson:AwAGCAQABAoAAA==.Dinosaur:AwAECAQABAoAAQcAAAAFCAkABAo=.Dirtnapp:AwAHCBAABAoAAA==.Disaaya:AwAHCBIABAoAAA==.',Dj='Djangó:AwAGCAYABAoAAA==.',Do='Doodlebug:AwABCAEABRQAAA==.',Dr='Draculock:AwADCAUABAoAAA==.Dracuujin:AwAFCAoABAoAAA==.Dreadloccs:AwACCAMABRQECAAIAQhlDwBJvnUCBAoACAAIAQhlDwBCpXUCBAoACQACAQgvJQBP160ABAoACgACAQiUHQAuvnUABAoAAA==.Dreagnor:AwACCAMABAoAAA==.Dreamgiver:AwACCAMABRQCCwAIAQhABQBbdhwDBAoACwAIAQhABQBbdhwDBAoAAA==.Dreanil:AwAGCAsABAoAAA==.',Dy='Dyingbreath:AwAHCBUABAoDDAAHAQhKAwBSrY8CBAoADAAHAQhKAwBSrY8CBAoADQABAQh7NAA7/jkABAoAAA==.',['D�']='Dârn:AwAFCAwABAoAAA==.',El='Elissra:AwAHCBAABAoAAA==.',En='Enarys:AwAGCA0ABAoAAA==.Enigmma:AwACCAIABAoAAA==.',Eo='Eostre:AwAFCAkABAoAAA==.',Fe='Fearoshîma:AwAICAgABAoAAA==.Feelschiman:AwAGCAgABAoAAA==.Felwags:AwAECAQABAoAAA==.Fendrag:AwAECAcABAoAAA==.',Fi='Firedaddy:AwADCAMABAoAAA==.',Fl='Fluffykat:AwADCAEABAoAAA==.',Ga='Gamepunisher:AwABCAIABRQCDgAHAQiCEgBK6CkCBAoADgAHAQiCEgBK6CkCBAoAAA==.Garg:AwAFCAwABAoAAA==.Gazblin:AwADCAEABAoAAA==.',Gi='Ginshan:AwABCAEABRQDDwAHAQjlBQBTRIICBAoADwAHAQjlBQBTRIICBAoAEAADAQiNWgAvmrAABAoAAA==.',Go='Gomez:AwAECAQABAoAAA==.',Gr='Gromlo:AwAFCAwABAoAAA==.',Gu='Gummi:AwAHCBAABAoAAA==.Gunny:AwAFCAwABAoAAA==.',['G�']='Gämbit:AwAFCA0ABAoAAA==.',Ha='Hapapoo:AwADCAEABAoAAA==.',He='Heferti:AwAECAIABAoAAA==.',Hi='Hiddenbeaver:AwAICAgABAoAAA==.',Hu='Huntemall:AwAGCAkABAoAAA==.',Hy='Hypaxia:AwAFCAkABAoAAA==.',Ic='Iceshards:AwAFCA0ABAoAAA==.',Id='Idtrapthat:AwACCAIABAoAAA==.',Il='Illidank:AwACCAIABRQCEAAIAQgsFwA8A10CBAoAEAAIAQgsFwA8A10CBAoAAA==.Illirothas:AwAFCAoABAoAAQcAAAAGCA4ABAo=.',In='Indecision:AwAFCAgABAoAAA==.',It='Itsnotogre:AwACCAcABAoAAA==.',Jo='Joemauma:AwAGCBAABAoAAA==.',Jp='Jpam:AwAECAUABAoAAA==.',Ju='Judgesmonk:AwAICAgABAoAAA==.Jumbosize:AwACCAUABRQCBgACAQhwBABPtLcABRQABgACAQhwBABPtLcABRQAAA==.Jungoligin:AwABCAMABRQCDgAIAQgEBwBSocoCBAoADgAIAQgEBwBSocoCBAoAAA==.Jupîter:AwAECAMABAoAAA==.',Ka='Kaiyley:AwAECAYABAoAAA==.Kalastrian:AwAFCA0ABAoAAA==.Karate:AwADCAYABAoAAA==.Kasyllaa:AwACCAIABAoAAA==.',Ke='Kelinna:AwABCAEABAoAAA==.Kennidan:AwADCAUABAoAAA==.',Kg='Kghhee:AwACCAIABAoAAA==.',Ki='Kieru:AwABCAEABAoAAREATsQHCBQABAo=.Kiritoo:AwAICBEABAoAAA==.Kirsch:AwAFCAoABAoAAA==.',Ko='Kodabonk:AwAFCAgABAoAAA==.Kokoa:AwACCAIABAoAAA==.',La='Lamlam:AwAFCA4ABAoAAA==.Landar:AwADCAUABAoAAQcAAAAGCAwABAo=.Latharis:AwAHCAsABAoAAA==.Lathsong:AwACCAIABAoAAA==.',Le='Ledz:AwAGCAUABAoAAA==.',Li='Liaeda:AwAGCA8ABAoAAA==.Lianshi:AwAFCAkABAoAAA==.',Lo='Lolo:AwAECAgABRQCDwAEAQhJAQAsJf0ABRQADwAEAQhJAQAsJf0ABRQAAA==.Loosie:AwAHCBUABAoCEAAHAQj9GwBE2TQCBAoAEAAHAQj9GwBE2TQCBAoAAA==.Lowpann:AwACCAIABAoAAA==.',Lu='Lukethenuke:AwACCAIABAoAAA==.Lumiltiand:AwABCAEABRQAAA==.Lumitard:AwABCAEABAoAAA==.',Ma='Malgrendin:AwAECAcABAoAAA==.Marvala:AwAGCAsABAoAAA==.Maxilock:AwAGCAEABAoAAA==.',Mc='Mcbearpig:AwAFCAkABAoAAA==.',Me='Medrunk:AwADCAMABAoAAA==.',Mi='Mid:AwAHCBAABAoAAA==.Midgemaisel:AwADCAUABAoAAA==.Mirado:AwAFCAwABAoAAA==.Missfire:AwADCAYABAoAAQYAVzACCAMABRQ=.',Mm='Mmushi:AwAGCBIABAoAAA==.',Mo='Mortarien:AwAICAQABAoAAA==.Mortïx:AwAHCBIABAoAAA==.',My='Myrtle:AwAGCBAABAoAAA==.',Na='Naai:AwAICAkABAoAAA==.Natureviz:AwAFCAsABAoAAA==.',Ne='Nevoir:AwACCAEABAoAAA==.Nexeoh:AwADCAMABAoAAA==.',Ni='Niralth:AwADCAEABAoAAA==.Niwatori:AwADCAEABAoAAA==.',No='Noah:AwACCAQABRQCEgAIAQjMAABhhPYCBAoAEgAIAQjMAABhhPYCBAoAAA==.Nolarz:AwAECAkABRQDEwAEAQi8AQBQaNcABRQAEwACAQi8AQBggtcABRQAFAACAQirBQBATrkABRQAAA==.Norbon:AwADCAEABAoAAA==.Nosho:AwAFCAwABAoAAA==.',Np='Nphect:AwACCAMABRQAAA==.',Nu='Nukthom:AwADCAUABAoAAA==.',Ny='Nyneaves:AwAECAcABAoAAA==.',Oh='Ohmenwah:AwADCAMABAoAAA==.',Oj='Ojpyroblast:AwACCAQABRQCEQACAQjIDABKS7IABRQAEQACAQjIDABKS7IABRQAAA==.',On='Onisprite:AwAECAIABAoAAA==.',Or='Ordhah:AwADCAQABAoAAQcAAAAFCAsABAo=.',Ov='Overruler:AwAICAgABAoAAA==.',Ox='Oxyhottin:AwAGCAYABAoAAA==.',Pa='Padding:AwABCAEABAoAAA==.Pakhan:AwAECAYABAoAAA==.Palkane:AwEHCAsABAoAAA==.Pallo:AwADCAEABAoAAA==.Pami:AwAHCBIABAoAAA==.Paona:AwAFCA8ABAoAAA==.Papafloppa:AwABCAEABRQAAA==.',Pe='Peraroll:AwABCAEABRQAAA==.Petitcrisse:AwACCAIABAoAAA==.Pezdspencer:AwADCAUABAoAAA==.',Ph='Phenphen:AwABCAIABRQDEwAIAQg7BQBY/aMCBAoAEwAHAQg7BQBXiKMCBAoAFAAGAQgPDwBWD/MBBAoAAA==.Phuryphen:AwACCAQABAoAARMAWP0BCAIABRQ=.Physicyan:AwAGCBAABAoAAA==.',Pi='Piakchu:AwAGCAcABAoAAA==.',Pr='Prïest:AwAFCAsABAoAAA==.',Pu='Pumaa:AwAGCAwABAoAAA==.',Re='Rejehkt:AwAHCAwABAoAAA==.Remorsous:AwAFCAoABAoAAA==.Rentahunter:AwAECAYABAoAAA==.Revoke:AwADCAcABRQDDQADAQhMAwBJgwoBBRQADQADAQhMAwBJgwoBBRQADAABAQimBAA3Bz4ABRQAAA==.',Ro='Rockeater:AwAFCAwABAoAAA==.Roguewolf:AwAFCA4ABAoAAA==.',Ru='Rungle:AwAHCBUABAoCFQAHAQiREwBDtyYCBAoAFQAHAQiREwBDtyYCBAoAAA==.Rush:AwAFCA4ABAoAAA==.',Ry='Rysxn:AwAHCBAABAoAAA==.Ryuujins:AwACCAMABRQDFgAIAQiiBABRdNwCBAoAFgAIAQiiBABRdNwCBAoAFwABAQhuXwAwKzMABAoAAA==.',Se='Seladorei:AwAGCBQABAoCEwAGAQjPBgBf0XUCBAoAEwAGAQjPBgBf0XUCBAoAAA==.',Sh='Shadowblazer:AwAHCBAABAoAAA==.Sherekhan:AwAFCAQABAoAAA==.Shiftinmojo:AwAECAcABAoAAA==.Shoutucker:AwACCAIABAoAAA==.Shrike:AwACCAIABAoAAA==.Shwippy:AwADCAMABAoAAA==.',Si='Silvias:AwADCAUABAoAAA==.',Sl='Sleepingiant:AwADCAUABAoAAA==.Sleepingmad:AwAHCAsABAoAAA==.Slurpslurp:AwAGCAYABAoAAA==.',So='Sonoh:AwAGCAwABAoAAA==.',St='Stormspellx:AwADCAYABAoAAA==.Stormspellz:AwAFCAwABAoAAA==.',Su='Supay:AwADCAUABAoAAA==.',Sw='Swiffer:AwACCAIABAoAAA==.',Sy='Syzzle:AwAECAsABAoAAA==.',Ta='Takkiya:AwAGCA8ABAoAAA==.Taldath:AwAECAQABAoAAA==.Talos:AwAFCAwABAoAAA==.Tanktax:AwAECAoABRQCGAAEAQj7AABDOD0BBRQAGAAEAQj7AABDOD0BBRQAAA==.Tarkinal:AwAECAgABAoAAA==.',Te='Teekqi:AwABCAEABAoAAA==.Telina:AwAICAgABAoAAA==.Temetnosce:AwAGCBAABAoAAA==.Termakill:AwAHCBMABAoAAA==.',Th='Thearos:AwAICBAABAoAAQcAAAAICBEABAo=.Theserbian:AwAHCA4ABAoAAA==.',Ti='Tindwyl:AwABCAEABAoAAA==.',Tm='Tm:AwABCAIABAoAAA==.',To='Toeran:AwAGCBAABAoAAA==.Toes:AwABCAEABRQCCAAIAQh3DwBCznQCBAoACAAIAQh3DwBCznQCBAoAAA==.',Tu='Turboswag:AwAFCAgABAoAAA==.',Ty='Tyria:AwAFCAoABAoAAA==.',Va='Vacker:AwAECAgABAoAAA==.Vashstampede:AwAGCAwABAoAAA==.',Ve='Velrik:AwAECAIABAoAAA==.Vergil:AwABCAEABAoAAA==.',Vo='Volksworgens:AwADCAMABAoAAA==.',We='Wellmet:AwAGCAwABAoAAA==.Werse:AwAFCAUABAoAAA==.Wetloginyou:AwAFCA0ABAoAAA==.',Wr='Wrecluses:AwAECAQABAoAAQEAUwwCCAUABRQ=.',Yo='Yoyol:AwAFCAYABAoAAA==.',Za='Zalthorax:AwAGCA4ABAoAAA==.Zatilion:AwAHCA4ABAoAAA==.',Ze='Zenbane:AwAICAgABAoAAA==.',Zi='Ziggashot:AwAGCBAABAoAAA==.',Zo='Zofran:AwADCAMABAoAAA==.',Zz='Zzipling:AwAFCAwABAoAAA==.',['Â']='Âtlas:AwAHCBQABAoCBQAHAQhGIgAsBYUBBAoABQAHAQhGIgAsBYUBBAoAAA==.',['Ó']='Óxy:AwADCAUABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end