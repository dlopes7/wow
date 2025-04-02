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
 local lookup = {'Paladin-Holy','Unknown-Unknown','DemonHunter-Havoc','Rogue-Assassination','Rogue-Subtlety','Druid-Restoration','DeathKnight-Blood','Mage-Fire','Mage-Frost','Hunter-BeastMastery','Monk-Mistweaver','Monk-Brewmaster',}; local provider = {region='US',realm='Cenarius',name='US',type='weekly',zone=42,date='2025-03-29',data={Ac='Achooah:AwAGCAkABAoAAA==.Acturus:AwADCAcABAoAAA==.',Ae='Aelisalla:AwADCAUABAoAAA==.',Ag='Agnescat:AwAFCAUABAoAAA==.',Al='Alexister:AwACCAIABAoAAA==.Algerzan:AwAFCAEABAoAAA==.',Am='Amelei:AwABCAIABRQCAQAIAQjoAwBO4rgCBAoAAQAIAQjoAwBO4rgCBAoAAA==.Amethystra:AwAECAQABAoAAQIAAAAFCAEABAo=.Amp:AwADCAQABAoAAA==.',An='Andazlin:AwABCAEABRQAAA==.',As='Ashlia:AwAFCAoABAoAAA==.',Ax='Axazon:AwABCAEABAoAAA==.',Az='Azzerria:AwACCAMABAoAAA==.',Ba='Babestire:AwACCAIABAoAAA==.Baki:AwAFCBMABAoAAA==.Bananadragon:AwAECAIABAoAAA==.',Be='Beefdaddy:AwAHCA0ABAoAAA==.Beerrun:AwAICAgABAoAAA==.',Bl='Blingin:AwAICAgABAoAAA==.',Bo='Bophedese:AwAECAUABAoAAA==.',Br='Brumsta:AwAFCAkABAoAAA==.',Ca='Caell:AwABCAEABAoAAA==.Calair:AwACCAIABRQCAwAIAQjUBABaxUADBAoAAwAIAQjUBABaxUADBAoAAA==.',Cb='Cballi:AwAECAcABAoAAA==.',Ce='Celandine:AwABCAIABAoAAA==.',Ch='Chadvra:AwAFCA0ABAoAAA==.',Cl='Clolarion:AwAFCAgABAoAAA==.',Co='Cough:AwAGCBIABAoAAA==.',Cr='Crowedots:AwAGCAQABAoAAA==.',Cu='Cullinz:AwAECAQABAoAAA==.Curiel:AwAFCA8ABAoAAA==.',Da='Dae:AwAFCA4ABAoAAA==.Darkhrt:AwAECAYABAoAAA==.Darkzevahc:AwAFCAUABAoAAA==.',De='Deadreign:AwAECAQABAoAAA==.Deathwavez:AwAECAQABAoAAA==.Dennis:AwAHCBUABAoDBAAHAQgTCQBU+DwCBAoABAAGAQgTCQBRSDwCBAoABQAGAQhcDQBO8B0CBAoAAA==.Depletes:AwAECAcABAoAAA==.',Do='Doomer:AwAFCAgABAoAAA==.Dorfludgren:AwAICAkABAoAAA==.Doruh:AwAFCAEABAoAAA==.',Dr='Dragmire:AwACCAIABAoAAA==.Dragnier:AwAICBAABAoAAA==.Drakenshiinx:AwAFCAgABAoAAA==.Drane:AwADCAMABAoAAA==.',Du='Dumbasmus:AwAFCAUABAoAAA==.',['D�']='Dêparted:AwAICAEABAoAAA==.',Ea='Eavie:AwACCAIABAoAAA==.',El='Elvishprezly:AwAECAUABAoAAA==.',Ex='Excëed:AwAECAQABAoAAA==.',Fa='Fallen:AwABCAEABAoAAQYARV8BCAIABRQ=.',Fe='Felius:AwAECAQABAoAAQYARV8BCAIABRQ=.Ferskur:AwAGCAQABAoAAA==.',Fr='Frostedflake:AwABCAEABAoAAA==.',Fy='Fyo:AwAHCBMABAoAAA==.',Gl='Glutton:AwABCAIABRQCBgAIAQglCABFX4YCBAoABgAIAQglCABFX4YCBAoAAA==.',Go='Goldenlotus:AwACCAIABAoAAA==.Golder:AwACCAIABAoAAA==.Gollywonx:AwABCAEABAoAAA==.Gorelash:AwABCAEABAoAAA==.',['G�']='Góat:AwAGCAUABAoAAA==.',Ha='Haavok:AwAFCAQABAoAAA==.Harf:AwADCAUABAoAAA==.',He='Heero:AwAHCAsABAoAAA==.',Hi='Himii:AwAFCAUABAoAAA==.',Ho='Holygodisme:AwAHCBEABAoAAA==.',Is='Isath:AwADCAUABAoAAA==.',Iw='Iwillpeeonu:AwAFCAoABAoAAA==.',Ja='Jac:AwADCAEABAoAAA==.',Ji='Jizza:AwAGCAYABAoAAA==.',Ju='Juriel:AwACCAIABAoAAA==.',Ka='Kathu:AwAECAUABAoAAA==.Kaylrizen:AwADCAcABAoAAA==.',Ke='Kezifel:AwAECAQABAoAAQcARLYDCAUABRQ=.Kezinik:AwADCAUABRQCBwADAQjUAwBEtvUABRQABwADAQjUAwBEtvUABRQAAA==.',Ko='Koraag:AwAFCAIABAoAAA==.',Kr='Kristyana:AwAFCAEABAoAAA==.Kruga:AwADCAUABAoAAA==.',Ky='Kyuu:AwADCAUABAoAAA==.',La='Lamennais:AwAECAQABAoAAA==.Latrinos:AwAICBAABAoAAA==.Lavendae:AwADCAUABAoAAA==.Laxus:AwACCAEABAoAAA==.',Le='Lenaina:AwACCAIABAoAAA==.Lesath:AwAFCAQABAoAAA==.',Lo='Lonelyheart:AwAFCAQABAoAAA==.Loridal:AwABCAEABAoAAA==.',Lu='Lucazz:AwAGCAYABAoAAA==.Lumpyteeth:AwAECAQABAoAAA==.Lunatick:AwAHCBIABAoAAA==.',Ma='Magedudee:AwABCAEABRQAAA==.Magisteve:AwABCAEABRQDCAAIAQgNHQA8IyMCBAoACAAIAQgNHQA36iMCBAoACQAFAQhOPQAop/QABAoAAQIAAAABCAEABRQ=.Maidmariann:AwACCAIABAoAAA==.Maizerial:AwAHCBQABAoCCgAHAQgwOwAvqK0BBAoACgAHAQgwOwAvqK0BBAoAAA==.Marcushorde:AwAFCAQABAoAAA==.Martypriest:AwAFCAQABAoAAA==.Masonixx:AwAFCAcABAoAAA==.',Me='Mellennah:AwAFCAsABAoAAA==.Menrvae:AwAECAUABAoAAA==.',Mo='Mogwrath:AwAFCAQABAoAAA==.Mongsok:AwAGCBEABAoAAA==.Monkdluffy:AwAECAEABAoAAA==.Monkmonkmonk:AwABCAEABAoAAA==.',My='Myshak:AwAECAUABAoAAA==.',Ni='Nickelbritt:AwADCAYABAoAAA==.',Og='Ogier:AwABCAEABRQAAA==.',Or='Orayleina:AwACCAIABAoAAA==.',Pa='Pawsed:AwAFCAoABAoAAA==.',Pe='Pengudk:AwAFCAIABAoAAA==.Perleana:AwAFCA4ABAoAAA==.Perra:AwAFCAQABAoAAA==.Peter:AwACCAIABAoAAQIAAAADCAMABAo=.',Ph='Philbertus:AwAICAIABAoAAA==.',Pi='Pikatin:AwABCAEABAoAAA==.',Po='Popestephen:AwACCAIABAoAAA==.',Pr='Priestacos:AwADCAQABAoAAA==.Protectormoo:AwAFCAEABAoAAA==.',Pu='Pushthescore:AwAFCAgABAoAAA==.',['P�']='Pàulywog:AwACCAMABAoAAA==.',Re='Reivida:AwAECAUABAoAAA==.Rendokai:AwAECAgABAoAAA==.Renlaut:AwADCAkABAoAAA==.Renshaibob:AwAHCAYABAoAAA==.',Ro='Rokari:AwAGCAsABAoAAA==.Roykent:AwACCAIABAoAAA==.',Ru='Russaki:AwAFCAEABAoAAA==.',Ry='Ryoku:AwACCAQABAoAAA==.',Sa='Saiti:AwAGCA8ABAoAAA==.Sarjun:AwADCAMABAoAAA==.',Sc='Scheany:AwACCAEABAoAAA==.Scuttlebug:AwAFCAQABAoAAA==.',Se='Seabake:AwAECAQABAoAAA==.Sermac:AwACCAIABAoAAA==.',Sh='Shaba:AwABCAEABAoAAA==.Shadowdamage:AwABCAEABAoAAA==.Shadowwulf:AwACCAIABAoAAA==.Shamdwich:AwACCAIABAoAAA==.Shamiko:AwAECAYABAoAAA==.Shelby:AwABCAEABRQAAA==.Shepard:AwACCAEABAoAAQIAAAAECAEABAo=.',Si='Sights:AwABCAEABAoAAA==.Sikkes:AwADCAYABAoAAA==.',Sl='Slippeddisc:AwACCAIABAoAAA==.',Sn='Snooze:AwADCAUABAoAAA==.Snovirz:AwAECAUABAoAAA==.Snowcone:AwAECAoABAoAAA==.',So='Sookie:AwAECAEABAoAAA==.',St='Stanlitwochi:AwAFCAQABAoAAA==.Starleaf:AwACCAMABAoAAA==.Stormkitty:AwAECAUABAoAAA==.Stormsteak:AwABCAEABRQAAA==.',Su='Sunadrae:AwABCAEABAoAAA==.Supershy:AwACCAIABAoAAA==.',Sy='Sylyndra:AwAFCAQABAoAAA==.',Ta='Tanedaria:AwAICAgABAoAAA==.Taulmäril:AwAECAUABAoAAA==.',Te='Tellatank:AwADCAUABAoAAQIAAAAGCBMABAo=.Tellen:AwAGCBMABAoAAA==.',Th='Thequae:AwADCAYABAoAAA==.Thiiccbowjob:AwAFCAEABAoAAA==.Thrèsh:AwAGCA4ABAoAAA==.Thymara:AwAFCAQABAoAAA==.',To='Tobais:AwAFCAwABAoAAA==.Totdown:AwAFCAgABAoAAA==.',Tu='Turokuruvar:AwAFCAsABAoAAA==.',Ty='Tynker:AwADCAUABAoAAA==.Tyronom:AwADCAEABAoAAA==.',['T�']='Túg:AwAFCAMABAoAAA==.',Ur='Urbanweaver:AwABCAIABRQCCwAIAQiADABEf3kCBAoACwAIAQiADABEf3kCBAoAAA==.',Ve='Vertaí:AwAGCAoABAoAAA==.',Vi='Vitavirent:AwADCAUABAoAAA==.',Wa='Warbringercb:AwAICAgABAoAAA==.Waruned:AwAGCA0ABAoAAA==.',Xh='Xhii:AwAHCBUABAoCDAAHAQgwAgBZwcUCBAoADAAHAQgwAgBZwcUCBAoAAA==.',Xi='Xiaodan:AwAECAUABAoAAQIAAAAFCAEABAo=.Xingxong:AwAFCAQABAoAAA==.Xistan:AwAFCAoABAoAAA==.',Yi='Yippy:AwAECAYABAoAAA==.',Yo='You:AwABCAEABAoAAA==.',Ze='Zelmancha:AwAICBkABAoCCgAIAQheJAA2pjcCBAoACgAIAQheJAA2pjcCBAoAAA==.Zenitul:AwAGCA8ABAoAAA==.',Zi='Zilmage:AwAGCBIABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end