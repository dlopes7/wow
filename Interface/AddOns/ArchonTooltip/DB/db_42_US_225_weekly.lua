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
 local lookup = {'DeathKnight-Unholy','Shaman-Elemental','DemonHunter-Havoc','Mage-Fire','Mage-Frost','Unknown-Unknown','DeathKnight-Blood','Shaman-Restoration','Warrior-Fury','Hunter-Survival','Monk-Mistweaver','Monk-Windwalker','Monk-Brewmaster','Druid-Balance','Warrior-Arms','Evoker-Devastation','Druid-Feral','Paladin-Protection','Paladin-Holy','Paladin-Retribution','Druid-Guardian','Druid-Restoration','Priest-Shadow','Priest-Discipline','Priest-Holy',}; local provider = {region='US',realm='Trollbane',name='US',type='weekly',zone=42,date='2025-03-28',data={Ai='Aidren:AwAHCBIABAoAAA==.',Al='Alicedelight:AwAFCAwABAoAAA==.',Am='Amabeast:AwAICAgABAoAAA==.Amisia:AwADCAEABAoAAA==.',An='Ansem:AwADCAUABAoAAA==.',Ar='Arkn:AwAFCAcABAoAAA==.',As='Ashtoreth:AwAECAYABAoAAA==.Assukun:AwAFCAwABAoAAA==.',Au='Aurezia:AwAFCAoABAoAAA==.',Ax='Axelz:AwABCAEABAoAAQEAOfEBCAIABRQ=.',Az='Azmodel:AwABCAEABAoAAA==.Azzariell:AwAGCBMABAoAAA==.',Ba='Baddmojo:AwAHCBUABAoCAgAHAQg0FAA7j+wBBAoAAgAHAQg0FAA7j+wBBAoAAA==.Badmac:AwAGCBQABAoCAwAGAQjaJgA/l9wBBAoAAwAGAQjaJgA/l9wBBAoAAA==.Banishedfate:AwAECAcABAoAAA==.',Be='Bebo:AwADCAQABRQDBAAIAQjJEABKCpkCBAoABAAIAQjJEABKCpkCBAoABQAFAQjoNAAzphUBBAoAAA==.Berry:AwADCAQABAoAAQYAAAAECAYABAo=.',Bi='Biaxident:AwADCAMABAoAAA==.Bigpoj:AwADCAsABAoAAA==.',Bo='Boneard:AwAFCA0ABAoAAA==.Boxeybrown:AwAFCAQABAoAAA==.',Br='Bravianda:AwAFCAwABAoAAA==.Breccia:AwADCAMABAoAAA==.Brujjo:AwAECAMABAoAAA==.',Bu='Bucci:AwAFCAwABAoAAA==.Buffwarrior:AwAGCA4ABAoAAA==.Buzzster:AwABCAMABRQCBwAIAQhfBABV/vECBAoABwAIAQhfBABV/vECBAoAAA==.',Ca='Cammikins:AwABCAIABRQCCAAHAQjHBwBcMb4CBAoACAAHAQjHBwBcMb4CBAoAAA==.Cannole:AwAFCAUABAoAAA==.Carti:AwAFCAUABAoAAA==.',Ch='Chongo:AwABCAEABAoAAQkAVdEBCAIABRQ=.Chubzy:AwADCAEABAoAAA==.',Ci='Cinnarhon:AwADCAEABAoAAA==.',Co='Conflict:AwAHCBEABAoAAA==.Cosmo:AwABCAEABRQAAA==.Cowtailgrunt:AwAECAQABAoAAA==.',Cr='Cruelsun:AwAGCAEABAoAAA==.',Cu='Curumo:AwAFCAoABAoAAA==.',Da='Daftmonk:AwABCAIABAoAAA==.Dalrak:AwAGCBQABAoCCgAGAQglAgBZREoCBAoACgAGAQglAgBZREoCBAoAAA==.Damagedchi:AwAICAoABAoAAA==.Dandelion:AwABCAEABRQAAA==.Darkenling:AwAICAEABAoAAA==.Datis:AwABCAEABAoAAA==.Datvoodoomon:AwABCAIABRQAAA==.',Di='Digydigyhole:AwABCAEABAoAAA==.',Do='Doby:AwACCAQABAoAAA==.Doggestyle:AwAGCA0ABAoAAA==.Dorastrain:AwAHCAIABAoAAA==.Dorime:AwAHCBQABAoECwAHAQjkIQAsa4gBBAoACwAHAQjkIQAsa4gBBAoADAAEAQhyLAAz2vIABAoADQACAQiEEwA1WYAABAoAAA==.',Dr='Dragonwyck:AwAFCAEABAoAAA==.Dromai:AwABCAEABAoAAA==.',Du='Durenree:AwACCAEABAoAAA==.',El='Elan:AwACCAIABAoAAA==.Eleman:AwAGCBUABAoCAgAGAQjTFwBCs74BBAoAAgAGAQjTFwBCs74BBAoAAA==.Elijahx:AwAECAcABAoAAA==.Elijay:AwAECAQABAoAAA==.Elva:AwAECAsABAoAAA==.',Em='Emaiko:AwADCAQABAoAAA==.Emisha:AwADCAEABAoAAA==.Emmshunter:AwAICAQABAoAAA==.',En='Envyd:AwAFCAYABAoAAA==.',Ep='Epona:AwAFCAQABAoAAA==.',Eu='Eurodice:AwADCAEABAoAAA==.',Fa='Fakeblind:AwAECAcABAoAAA==.Fauxlux:AwADCAMABAoAAA==.Faùst:AwAGCAkABAoAAA==.',Fe='Feliandron:AwAFCAgABAoAAA==.',Fi='Fiann:AwAECAoABAoAAA==.',Fl='Flintstones:AwAHCBUABAoCDgAHAQhCJAA8FbIBBAoADgAHAQhCJAA8FbIBBAoAAA==.Flyinglizard:AwAGCAIABAoAAA==.',Fu='Fujee:AwAFCAcABAoAAA==.Funkyt:AwAECAMABAoAAA==.',Ga='Galdarkaz:AwADCAEABAoAAA==.Gangkit:AwAGCAoABAoAAA==.',Ge='Gennil:AwABCAEABRQCBQAHAQifBgBbmNECBAoABQAHAQifBgBbmNECBAoAAA==.',Go='Goblintopher:AwABCAEABAoAAA==.Gochujang:AwAECAUABAoAAA==.Gormash:AwABCAIABRQCDAAIAQgECABJUrcCBAoADAAIAQgECABJUrcCBAoAAA==.Gothickk:AwAICAsABAoAAA==.',Gr='Grumpyroots:AwAGCAIABAoAAA==.',Gu='Guymontag:AwAFCAQABAoAAA==.',Ha='Halal:AwAFCAoABAoAAA==.',He='Heaf:AwACCAIABRQCDwAIAQgrAQBexkoDBAoADwAIAQgrAQBexkoDBAoAAA==.Hellrever:AwAFCAQABAoAAA==.',Hi='Hikons:AwAGCAgABAoAAA==.Hippyjibbers:AwACCAIABAoAAQYAAAAGCAsABAo=.',Ho='Holylol:AwADCAQABAoAAA==.',Ht='Htzx:AwADCAUABAoAAA==.',Is='Isongard:AwAICAgABAoAAA==.',Ja='Jarco:AwAFCAYABAoAAQYAAAAHCAEABAo=.',Ji='Jimmiespray:AwAFCAUABAoAAQkATOEECAsABRQ=.',['J�']='Jäzmine:AwADCAEABAoAAA==.Jèssicà:AwAGCA0ABAoAAA==.',Ka='Kabutosan:AwADCAQABAoAAQYAAAAFCAkABAo=.Kamots:AwADCAYABAoAAA==.Kareokee:AwAGCBQABAoCCQAGAQjLJQAtLZUBBAoACQAGAQjLJQAtLZUBBAoAAA==.Kargoroth:AwAGCAgABAoAAA==.Kazdormu:AwABCAEABRQCEAAHAQigFAAq1qMBBAoAEAAHAQigFAAq1qMBBAoAAA==.',Ke='Kenku:AwAICBEABAoAAA==.',Kn='Knokkelmann:AwAHCA8ABAoAAA==.Knottybits:AwADCAQABAoAAA==.',Ko='Konsumer:AwAECAwABAoAAA==.',Kr='Kronie:AwABCAEABAoAAA==.Krrk:AwACCAMABAoAAA==.Krønie:AwAFCAkABAoAAA==.',Li='Lickmychaos:AwABCAEABAoAAA==.Lickmyspellz:AwAFCAoABAoAAA==.Lights:AwACCAIABAoAAA==.Lizrdjibbers:AwAGCAsABAoAAA==.Lizurg:AwACCAMABAoAAA==.',Ll='Llillianna:AwADCAYABAoAAA==.',Lu='Lucarien:AwADCAQABAoAAA==.Lusacan:AwAGCA0ABAoAAA==.',Ly='Lyaden:AwAECAYABAoAAA==.Lyrin:AwADCAUABAoAAA==.',Ma='Maelos:AwAECAsABAoAAA==.Magnathul:AwAHCAcABAoAAA==.Makeah:AwABCAEABRQAAA==.Marrior:AwADCAQABAoAAA==.',Mi='Midrok:AwAFCAQABAoAAA==.Misswesty:AwABCAEABAoAAA==.',Mj='Mjölnir:AwAICBAABAoAAA==.',Mo='Mobythicc:AwADCAUABRQDDgADAQh0BwAphdcABRQADgADAQh0BwAphdcABRQAEQABAQgsBABSL0cABRQAAA==.Moderatemufn:AwAHCCcABAoCBwAHAQi1EgA0xqwBBAoABwAHAQi1EgA0xqwBBAoAAA==.Moink:AwAICAgABAoAAA==.Moonboomfred:AwABCAEABAoAAA==.Moothulhu:AwAECAoABAoAAA==.',Mu='Mudsniffer:AwADCAQABAoAAA==.Munkamanbezy:AwAICBEABAoAAA==.Mutilate:AwAHCA4ABAoAAA==.',['M�']='Máplesyrúp:AwAGCA0ABAoAAA==.Méðwmïx:AwAHCA0ABAoAAA==.Mìlkman:AwAHCAgABAoAAA==.',Na='Narae:AwADCAYABAoAAA==.',Ne='Necronomikan:AwAECAQABAoAAA==.Neosporan:AwAFCAkABAoAAA==.Nerotic:AwAFCAoABAoAAA==.',Ni='Nimidh:AwAGCAEABAoAAA==.',No='Noahnkwtf:AwACCAQABRQAAA==.Notafdh:AwAICAUABAoAAA==.',Nu='Nuang:AwADCAMABAoAAA==.',Ob='Obnoxiousego:AwABCAIABRQCEgAHAQjlDAA3FMQBBAoAEgAHAQjlDAA3FMQBBAoAAA==.',Od='Oddknee:AwAGCAcABAoAAQkAVdEBCAIABRQ=.Odney:AwABCAIABRQDCQAHAQh0EQBV0V4CBAoACQAGAQh0EQBdEF4CBAoADwAGAQizDwBPQOoBBAoAAA==.',Of='Ofookjibbers:AwABCAEABAoAAQYAAAAGCAsABAo=.',Ol='Olivebetray:AwAFCAgABAoAAA==.',On='Onysable:AwABCAEABAoAARMAUWACCAIABRQ=.',Op='Opalrai:AwAFCAQABAoAAA==.',Or='Oridox:AwAFCAsABAoAAA==.Orumine:AwABCAEABRQCFAAGAQjHNQBQMQcCBAoAFAAGAQjHNQBQMQcCBAoAAA==.',Pa='Pahpi:AwAFCAUABAoAAA==.Paratussum:AwAFCA0ABAoAAA==.',Pe='Peppino:AwAGCAoABAoAAA==.',Po='Pocket:AwACCAEABAoAAA==.',Ps='Psychoshorts:AwAFCAcABAoAAA==.',Pw='Pwnpaladin:AwAGCA8ABAoAAA==.',Py='Pyramys:AwAICBMABAoAAA==.',Ra='Raidhero:AwABCAEABRQCAgAIAQj9DgBAMDcCBAoAAgAIAQj9DgBAMDcCBAoAAA==.Rasso:AwAHCAMABAoAAA==.',Re='Reflection:AwAGCAEABAoAAA==.Reppa:AwAECAQABAoAAA==.Retiniris:AwAFCAwABAoAAA==.',Rh='Rhonstaris:AwACCAEABAoAAA==.Rhox:AwABCAEABAoAAA==.',Ri='Rickshades:AwAICBcABAoEEQAIAQjpBABB9FoCBAoAEQAIAQjpBABB9FoCBAoAFQAEAQidDAAphM8ABAoAFgABAQgWWgAJPCYABAoAAA==.',Ro='Rockem:AwABCAIABRQAAA==.',Ru='Rubb:AwADCAQABAoAAA==.',Sa='Salanaar:AwABCAIABRQAAA==.Sancteum:AwABCAIABRQDFwAHAQiUBgBcxdkCBAoAFwAHAQiUBgBcxdkCBAoAGAABAQjHTAA04kIABAoAAA==.Saucegardner:AwAECAkABAoAAA==.Savra:AwABCAEABAoAAA==.Sayy:AwAFCBQABAoCBQAFAQgmIgBKN5UBBAoABQAFAQgmIgBKN5UBBAoAAA==.',Sc='Schro:AwAGCBEABAoAAA==.Schrow:AwAECAYABAoAAQYAAAAGCBEABAo=.Scorpionius:AwAHCBEABAoAAA==.',Se='Seifert:AwADCAMABAoAAA==.Sekvir:AwAICAIABAoAAA==.Serapheik:AwAECAsABAoAAA==.Seraz:AwAGCAsABAoAAQYAAAAGCBAABAo=.',Sh='Shoebox:AwAGCAoABAoAAA==.',Sk='Skaraa:AwAGCAMABAoAAA==.',Sl='Sllatt:AwACCAEABAoAAA==.',Sn='Snackysteak:AwAGCAwABAoAAA==.',So='Somarlar:AwAHCAMABAoAAA==.Somtingwong:AwADCAQABAoAAA==.Sopho:AwAECAYABAoAAA==.',Sp='Spaggers:AwADCAQABAoAAA==.Speity:AwADCAYABAoAAA==.Spikedice:AwABCAEABAoAAA==.',St='Striphe:AwAGCA0ABAoAAA==.Stryper:AwAGCAYABAoAAA==.Størmm:AwAFCAcABAoAAA==.',Su='Sunday:AwAICCIABAoCGQAIAQg9AQBePkQDBAoAGQAIAQg9AQBePkQDBAoAAA==.Surâ:AwAHCBQABAoCCAAHAQgfBgBgCtwCBAoACAAHAQgfBgBgCtwCBAoAAA==.',Sy='Sylvanàsdoxy:AwABCAEABAoAAA==.Symbol:AwAECAYABAoAAA==.',Ta='Talaura:AwAECAEABAoAAA==.',Th='Thack:AwAFCAYABAoAAA==.Thoryn:AwAGCAwABAoAAA==.',Tk='Tkenga:AwACCAMABAoAAA==.',To='Tokzi:AwAGCAEABAoAAA==.Tonicdeath:AwAICAgABAoAAA==.Touchanun:AwADCAcABAoAAA==.',Tr='Trashcan:AwADCAMABAoAAA==.Trashie:AwAFCAwABAoAAA==.Truthsayer:AwAFCAsABAoAAA==.',Ts='Tsuruchi:AwAICBAABAoAAA==.',Ty='Tyce:AwADCAUABAoAAA==.Tylannis:AwABCAIABRQCEwAHAQgvCABK9z0CBAoAEwAHAQgvCABK9z0CBAoAAA==.',Ug='Ugacoop:AwABCAEABRQAAA==.',Un='Unholyforce:AwADCAIABAoAAA==.',Va='Vansong:AwADCAYABAoAAA==.',Ve='Vehe:AwAGCAwABAoAAA==.Veledaa:AwAICBYABAoCGQAIAQgPBwBKzKcCBAoAGQAIAQgPBwBKzKcCBAoAAA==.Vendethiel:AwABCAEABAoAAA==.',Vi='Vickos:AwAICAgABAoAAA==.Violletta:AwAFCAkABAoAAA==.',Vo='Voidme:AwAFCAcABAoAAA==.Volvagia:AwABCAEABRQAAA==.',['V�']='Vèlkhànà:AwAGCA4ABAoAAA==.',Wa='Watashi:AwADCAMABAoAAA==.',Wo='Wolke:AwAECAgABAoAAA==.',Ya='Yasuki:AwAICAgABAoAAA==.',Ye='Yellcat:AwAHCAMABAoAAA==.',Yo='Yocha:AwAFCAkABAoAAA==.',Yv='Yvonnêl:AwAFCAoABAoAAA==.',Za='Zabidu:AwABCAIABRQDDAAHAQhdCgBQpYgCBAoADAAHAQhdCgBQpYgCBAoACwACAQj/UgAr3G0ABAoAAA==.Zanderblack:AwAGCBAABAoAAA==.Zaria:AwAGCA0ABAoAAA==.Zauriel:AwADCAIABAoAAA==.',Ze='Zelenã:AwADCAYABAoAAA==.Zephon:AwABCAIABRQCAwAHAQi1FQBNxWsCBAoAAwAHAQi1FQBNxWsCBAoAAA==.Zeromunk:AwAFCAMABAoAAA==.',['Â']='Âxel:AwABCAIABRQCAQAIAQhZFQA58RwCBAoAAQAIAQhZFQA58RwCBAoAAA==.',['Ð']='Ðarknes:AwAECAsABAoAAA==.Ðirtypunch:AwABCAEABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end