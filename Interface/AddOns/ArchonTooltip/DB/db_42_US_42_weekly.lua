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
 local lookup = {'Monk-Windwalker','Shaman-Elemental','Shaman-Restoration','DeathKnight-Unholy','DeathKnight-Frost','Unknown-Unknown','Warlock-Destruction','Hunter-Marksmanship','Warlock-Demonology','Priest-Discipline','Mage-Fire','Mage-Frost','Paladin-Retribution','DemonHunter-Havoc','Hunter-BeastMastery','Warrior-Arms','Monk-Mistweaver','Evoker-Devastation','Evoker-Augmentation','Warlock-Affliction','Rogue-Subtlety','Shaman-Enhancement','Priest-Holy','Paladin-Protection',}; local provider = {region='US',realm='Bonechewer',name='US',type='weekly',zone=42,date='2025-03-29',data={Ac='Acelliste:AwABCAEABAoAAA==.Acerocks:AwAECAEABAoAAA==.',Af='Afrit:AwAFCA4ABAoAAA==.',Ah='Ahzathoth:AwAICA4ABAoAAA==.',Ak='Akholymomma:AwAFCAEABAoAAA==.',Al='Altffour:AwACCAEABAoAAA==.',An='Anamay:AwADCAUABAoAAA==.Ancalagoon:AwAICBEABAoAAA==.Antixx:AwAFCAIABAoAAA==.',Ao='Aoris:AwABCAEABAoAAA==.',As='Astarouge:AwAGCAYABAoAAA==.Astraesia:AwAFCAUABAoAAA==.',At='Atchafalaya:AwADCAIABAoAAA==.Atomicblaze:AwADCAMABAoAAA==.',Ba='Babymiko:AwAGCAsABAoAAA==.Baey:AwAFCAQABAoAAA==.Basketball:AwADCAUABRQCAQADAQi4AgBHeBsBBRQAAQADAQi4AgBHeBsBBRQAAA==.',Be='Bergidum:AwACCAIABAoAAA==.Bestbuybully:AwACCAQABRQDAgAIAQi+BgBS99UCBAoAAgAIAQi+BgBS99UCBAoAAwABAQgtdAAszEEABAoAAA==.',Bi='Bigdamgegurl:AwADCAYABAoAAA==.Biglett:AwABCAEABRQAAA==.',Bl='Blakeblossom:AwAFCAYABAoAAA==.Blazenhaze:AwAFCAsABAoAAA==.Bloodly:AwAHCCEABAoDBAAHAQhPKQAlE30BBAoABAAHAQhPKQAlE30BBAoABQACAQjJJgAEASQABAoAAA==.Blorgon:AwAICBcABAoCBAAIAQjyFgA0pRoCBAoABAAIAQjyFgA0pRoCBAoAAA==.',Bo='Bohngjitsu:AwADCAcABAoAAA==.Borelane:AwAFCAkABAoAAA==.Bovinepally:AwAECAoABAoAAA==.',Br='Broblade:AwAICAgABAoAAA==.Brumeo:AwAECAUABAoAAA==.',Bu='Bulwa:AwAFCAkABAoAAA==.',Ca='Captantrips:AwACCAIABAoAAA==.Cavonesee:AwAGCAEABAoAAA==.',Ci='Cidemon:AwAFCAUABAoAAA==.',Cl='Clubbette:AwAGCA0ABAoAAA==.',Co='Colombiano:AwAHCAQABAoAAA==.Copper:AwADCAUABAoAAA==.Cosdapanda:AwADCAYABAoAAA==.',Cr='Crusherlol:AwAECAYABAoAAA==.Crytique:AwACCAMABAoAAA==.',Da='Dabrightside:AwADCAYABAoAAA==.Darthdilf:AwAICAgABAoAAA==.Datbubblelol:AwAECAgABAoAAA==.Daxy:AwAECAUABAoAAA==.Dazbek:AwAHCBEABAoAAA==.',De='Deadboltz:AwAICAsABAoAAA==.Degeneffe:AwADCAYABAoAAA==.Demonlester:AwAICAgABAoAAA==.Demoreknight:AwAGCBEABAoAAA==.Devilboy:AwAGCAYABAoAAA==.',Di='Dinonuggié:AwADCAQABAoAAA==.Dizzynectar:AwAFCAoABAoAAA==.',Do='Domore:AwAFCAIABAoAAA==.Dook:AwAFCAEABAoAAA==.Doongsu:AwAGCBIABAoAAA==.',Dr='Dragbrown:AwAHCBAABAoAAA==.Droptopp:AwAECAcABAoAAA==.',Du='Durrga:AwABCAEABAoAAQYAAAAICAwABAo=.',['D�']='Dãftmõnk:AwAGCA0ABAoAAA==.',El='Elisaveta:AwADCAUABAoAAA==.Ella:AwAFCA4ABAoAAA==.',Er='Errien:AwACCAIABAoAAA==.',Ex='Exiled:AwAGCA4ABAoAAA==.',Fa='Falkhor:AwACCAQABAoAAA==.Fatlootz:AwAFCBAABAoAAA==.Fattyonce:AwADCAMABAoAAA==.',Fe='Fearchickens:AwAICBYABAoCBwAIAQhkEABCw3ACBAoABwAIAQhkEABCw3ACBAoAAA==.Fejao:AwABCAEABAoAAA==.Fengmin:AwABCAEABAoAAQYAAAAFCAkABAo=.',Fi='Fiorina:AwAGCA0ABAoAAA==.',Fl='Flexkin:AwAGCAYABAoAAA==.Flipfløp:AwADCAUABAoAAQMATncICBYABAo=.',Fo='Fornor:AwABCAIABAoAAA==.Foxfù:AwACCAQABAoAAA==.Foxkníght:AwAICBgABAoCBAAIAQgYEgA+u0wCBAoABAAIAQgYEgA+u0wCBAoAAA==.',Fr='Freyjaluna:AwADCAUABAoAAQgAP+0HCBUABAo=.Frita:AwAICAgABAoAAA==.',Ge='Gearbrylls:AwAICAgABAoAAA==.',Gh='Ghettox:AwACCAIABAoAAA==.Ghrell:AwEGCA0ABAoAAA==.',Gi='Gimllet:AwAECAYABAoAAA==.',Gn='Gnormage:AwAECAEABAoAAA==.',Go='Gonuhreeuh:AwADCAMABAoAAA==.',Gr='Greypa:AwACCAMABAoAAA==.',Gu='Gurthyb:AwAGCA8ABAoAAA==.',Ha='Halfordium:AwADCAEABAoAAA==.Hardlylokdup:AwABCAEABRQDBwAIAQihDgBBmIQCBAoABwAIAQihDgBBmIQCBAoACQABAQhEOQA3Ek8ABAoAAA==.Hardlyready:AwAECAEABAoAAA==.Hausey:AwABCAEABAoAAA==.Hawkmees:AwAGCA0ABAoAAA==.',He='Heckia:AwACCAYABAoAAA==.Heelza:AwAFCAEABAoAAA==.Hellxan:AwAFCAwABAoAAA==.Helphen:AwADCAQABAoAAA==.Henchsucks:AwADCAQABAoAAA==.Herakies:AwAECAUABAoAAA==.',Ho='Hoji:AwACCAMABAoAAA==.',Hu='Hurkola:AwAGCAQABAoAAA==.Husqvarna:AwAECAIABAoAAQcAUuUICBgABAo=.',Id='Idkdude:AwAGCAYABAoAAA==.',Il='Illaio:AwAGCAsABAoAAA==.',Im='Imanie:AwACCAIABAoAAA==.',It='Itamï:AwAGCAYABAoAAA==.',Ja='Jaagren:AwABCAEABAoAAA==.Jayrel:AwAICBgABAoCCgAIAQiODQA8iSQCBAoACgAIAQiODQA8iSQCBAoAAA==.',Jc='Jcby:AwAICBgABAoCCwAIAQjkEgBNAooCBAoACwAIAQjkEgBNAooCBAoAAA==.',Jo='Joey:AwABCAEABRQAAA==.',Ju='Juankkii:AwAECAYABAoAAA==.',['J�']='Jáckfrost:AwAGCBYABAoCDAAGAQiLFwBSR/8BBAoADAAGAQiLFwBSR/8BBAoAAA==.',Ka='Kalatai:AwAGCA8ABAoAAA==.Kalindora:AwAFCAwABAoAAA==.',Ke='Keoma:AwAICAgABAoAAA==.Keystorm:AwAGCBAABAoAAA==.',Ki='Kiala:AwABCAEABAoAAA==.Kilari:AwACCAEABAoAAA==.Killabckstb:AwAECAIABAoAAA==.',Ku='Kungfoodpnda:AwAECAUABAoAAA==.',La='Lacedfent:AwAGCA4ABAoAAA==.Laviish:AwAICAoABAoAAA==.',Le='Leafpics:AwACCAIABAoAAA==.Lediddler:AwAECAoABAoAAA==.Ledru:AwAFCAIABAoAAA==.',Li='Lilballohate:AwABCAEABAoAAA==.',Ma='Madlevi:AwADCAEABAoAAA==.Mageyøulook:AwADCAYABAoAAA==.Magicchris:AwADCAIABAoAAA==.Maliun:AwABCAEABRQAAA==.Mallaki:AwABCAEABRQCDQAHAQiXHQBU8YwCBAoADQAHAQiXHQBU8YwCBAoAAA==.Malusdemon:AwAICBUABAoCDgAIAQg/LgAVsrABBAoADgAIAQg/LgAVsrABBAoAAA==.Mamasota:AwADCAQABAoAAA==.Markiepoo:AwAICBgABAoCBwAHAQiYDgBS5YUCBAoABwAHAQiYDgBS5YUCBAoAAA==.Markypie:AwAICAgABAoAAQcAUuUICBgABAo=.Markytonk:AwAICAgABAoAAQcAUuUICBgABAo=.',Me='Meleria:AwAGCA0ABAoAAA==.',Mi='Michaaelvick:AwABCAEABAoAAA==.',Mo='Moomoodles:AwADCAYABAoAAA==.',My='Myling:AwAICAgABAoAAA==.Mystake:AwAGCBAABAoAAA==.Mysticbudoo:AwAGCA0ABAoAAA==.',Ne='Neztus:AwADCAYABAoAAA==.',Ni='Niziel:AwAGCBEABAoAAA==.',No='Nowalker:AwAFCAwABAoAAA==.',Ny='Nymphali:AwACCAIABAoAAQ8AR9kBCAIABRQ=.',['N�']='Nìcholas:AwADCAYABAoAAA==.',Om='Omenbane:AwADCAUABAoAAA==.',Or='Organics:AwAECAUABAoAAA==.Ornarl:AwAFCAQABAoAAA==.',Pa='Parketor:AwAECAQABAoAAA==.',Pe='Peam:AwAHCAQABAoAAA==.',Ph='Phrostee:AwABCAEABAoAAA==.',Pi='Pillowhands:AwADCAYABAoAAA==.',Pr='Pravus:AwAFCBIABAoAAA==.Premmish:AwAICAgABAoAAA==.Prutsloche:AwAECAYABAoAAA==.',Pu='Puffandslice:AwACCAIABAoAAA==.Punchkick:AwAGCAMABAoAAA==.',['P�']='Páth:AwAECAYABAoAAA==.Pøtato:AwABCAEABRQCEAAIAQh/BQBJCrsCBAoAEAAIAQh/BQBJCrsCBAoAAA==.',Qu='Quinfluence:AwAGCAYABAoAAA==.Quintillion:AwAICBYABAoCEQAIAQg3DABIln0CBAoAEQAIAQg3DABIln0CBAoAAA==.',Ra='Raau:AwAHCBgABAoDEgAHAQhkEgA1I9MBBAoAEgAHAQhkEgA1DNMBBAoAEwACAQhHBQAhxkgABAoAAA==.Ragexchaos:AwACCAIABAoAAA==.Rainndance:AwADCAQABAoAAA==.',Re='Reaperxchaos:AwAECAYABAoAAA==.Redghosst:AwABCAIABRQECQAIAQjIGQBFWwsBBAoABwAEAQiFOABNrUEBBAoACQAEAQjIGQA8/wsBBAoAFAADAQjdEwA+wtoABAoAAA==.Reydrae:AwAHCAkABAoAAA==.',Rh='Rhyllii:AwAFCAgABAoAAA==.',Ri='Rinsed:AwACCAIABAoAAA==.',Ro='Roadburner:AwAICBAABAoAAA==.Romenhoff:AwAHCA8ABAoAAA==.Ronin:AwACCAIABAoAAA==.',['R�']='Råz:AwABCAEABRQAAA==.Råzz:AwAFCA0ABAoAAQYAAAABCAEABRQ=.Rêquiem:AwAFCAMABAoAAA==.',Sa='Sandro:AwAGCA0ABAoAAA==.',Sc='Scaramanga:AwAECAQABAoAAA==.',Se='Sedaea:AwAFCAoABAoAAA==.',Sh='Shadymcgee:AwABCAEABAoAAA==.Shammyrock:AwADCAMABAoAAA==.Sharayse:AwACCAIABAoAAA==.Sharktank:AwAFCAMABAoAAA==.Shuriken:AwAHCBEABAoAAA==.',Si='Siopau:AwAFCAgABAoAAA==.',Sm='Smallko:AwAHCA4ABAoAAA==.Smòke:AwABCAEABAoAAA==.Smõké:AwADCAgABAoAAA==.',Sn='Sneevle:AwABCAEABRQCFQAHAQhFBgBYO7sCBAoAFQAHAQhFBgBYO7sCBAoAAA==.Snowfláme:AwAFCAoABAoAAA==.',So='Solfyr:AwAFCAMABAoAAA==.Solodh:AwAGCAYABAoAAA==.Sootsucks:AwAECAkABAoAAA==.Sootzy:AwAECAQABAoAARQAWXYBCAMABRQ=.Souljamm:AwACCAIABAoAAA==.',Sp='Spankky:AwACCAQABAoAAA==.Spicynoodles:AwAFCAkABAoAAA==.',Sq='Squachy:AwACCAQABAoAAQoAPIkICBgABAo=.',Ss='Ssghoul:AwAGCBAABAoAAA==.',St='Starwnd:AwACCAUABRQCFgACAQhYBwAmNKEABRQAFgACAQhYBwAmNKEABRQAAA==.Steadchi:AwAGCBEABAoAAA==.Stealthgump:AwAGCA0ABAoAAA==.Stupid:AwAICAwABAoAAA==.',Su='Suzuha:AwAECAQABAoAAQYAAAAFCAkABAo=.',Sy='Sydneysweeny:AwAGCA8ABAoAAQYAAAABCAEABRQ=.Synnergyy:AwADCAYABAoAAA==.',['S�']='Séii:AwAGCAMABAoAAA==.',Ta='Tanzee:AwAICBgABAoCFwAIAQinDgA+WTcCBAoAFwAIAQinDgA+WTcCBAoAAA==.',Te='Teriona:AwAECAQABAoAAA==.Testsubjeck:AwAGCAwABAoAAA==.',Th='Thannos:AwADCAIABAoAAA==.Tharick:AwAFCAcABAoAAA==.Thricee:AwACCAIABAoAAA==.',Ti='Tiamato:AwAICBAABAoAAA==.Tideup:AwADCAMABAoAAA==.',Tr='Tripel:AwACCAEABAoAAA==.',Tu='Tunare:AwACCAQABAoAAA==.',Tw='Twiittcchhy:AwAFCAoABAoAAA==.Twylla:AwAECAcABAoAAA==.',Ty='Tyler:AwAECAUABAoAAA==.Tynak:AwAFCAgABAoAAA==.Tyrelis:AwADCAQABAoAAA==.',Ul='Ultramind:AwACCAEABAoAAA==.',Um='Umbrâ:AwACCAIABAoAAA==.',Ut='Utharlon:AwABCAEABRQCAQAIAQi1BQBVVvICBAoAAQAIAQi1BQBVVvICBAoAAA==.',Va='Vaelis:AwADCAYABAoAAA==.Vanellope:AwABCAEABAoAAA==.',Ve='Velystelithe:AwAICA8ABAoAAA==.Veyna:AwACCAMABAoAAQYAAAAFCAYABAo=.',Vi='Viceless:AwAECAMABAoAAA==.',Wa='Wardogsix:AwAICAYABAoAAA==.',Wi='Windfuryop:AwAFCAcABAoAAA==.Windrunnér:AwACCAIABAoAAA==.',Wu='Wulflock:AwAFCAIABAoAAA==.',Xa='Xanthym:AwABCAEABRQDGAAIAQhnBQBJL5MCBAoAGAAIAQhnBQBJL5MCBAoADQADAQggwgArHIwABAoAAA==.',Za='Zarideyn:AwAGCBQABAoCDwAGAQivOQA/NrUBBAoADwAGAQivOQA/NrUBBAoAAA==.',Zo='Zookee:AwADCAMABAoAAA==.',Zy='Zypheni:AwAHCAkABAoAAA==.',['Î']='Îcyhot:AwABCAEABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end