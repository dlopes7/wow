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
 local lookup = {'Mage-Fire','Paladin-Holy','Paladin-Retribution','Paladin-Protection','Mage-Frost','Warrior-Fury','Warlock-Demonology','Warlock-Destruction','Warlock-Affliction','Unknown-Unknown','Evoker-Devastation','Evoker-Preservation','Shaman-Elemental','Shaman-Restoration','Priest-Shadow','Priest-Discipline','Druid-Feral','Druid-Restoration','DemonHunter-Havoc','Hunter-BeastMastery','Monk-Windwalker','Shaman-Enhancement','DemonHunter-Vengeance','DeathKnight-Blood','DeathKnight-Unholy','Druid-Balance',}; local provider = {region='US',realm='Skullcrusher',name='US',type='weekly',zone=42,date='2025-03-28',data={Aa='Aaylia:AwAECAQABAoAAA==.',Ab='Abzmage:AwAHCBYABAoCAQAHAQgMDgBaCrgCBAoAAQAHAQgMDgBaCrgCBAoAAA==.',Al='Alexandrap:AwABCAEABAoAAA==.Allmighto:AwADCAYABRQEAgADAQi+BQASOIYABRQAAgACAQi+BQAa6YYABRQAAwABAQgMIQAJAjsABRQABAABAQhPCwAEQhUABRQAAA==.',An='Androstraz:AwAECAQABAoAAA==.',Ar='Arune:AwAFCAYABAoAAA==.Aryeos:AwAGCA8ABAoAAA==.',Au='Auntflö:AwAECAQABAoAAA==.Aurorä:AwAFCAkABAoAAA==.',Av='Averyward:AwAECAQABAoAAA==.',Ba='Bannett:AwACCAUABRQDBQACAQhOAQBhB98ABRQABQACAQhOAQBhB98ABRQAAQABAQiVGgAvTkQABRQAAA==.Bastét:AwACCAUABAoAAA==.Baxterhunt:AwADCAMABAoAAA==.',Bi='Billmurray:AwAFCAwABAoAAA==.',Bl='Bleached:AwAGCA8ABAoAAA==.',Bo='Boomshimtang:AwADCAMABAoAAA==.Boreddruid:AwAECAgABAoAAA==.',Br='Brazcane:AwAECAkABAoAAA==.Breemonic:AwAHCBMABAoAAA==.Brygonjinn:AwAGCBAABAoAAA==.',Ca='Caraxes:AwABCAIABRQAAA==.',Ch='Cheesus:AwAHCBAABAoAAA==.Chilloutkwaz:AwABCAEABAoAAA==.',Ci='Cinnamen:AwAGCAoABAoAAA==.',Co='Coaa:AwAGCA8ABAoAAA==.Cowlor:AwAGCA0ABAoAAA==.',Cr='Cregga:AwAECAQABAoAAA==.Crõwfather:AwAGCAQABAoAAA==.',Cu='Curr:AwAECAQABAoAAA==.',Cz='Czpz:AwADCAMABAoAAA==.',['C�']='Círca:AwACCAIABAoAAA==.',Da='Darkbu:AwAECAgABAoAAA==.Dastard:AwAHCBEABAoAAA==.',Dc='Dcmp:AwACCAUABRQCBgACAQjyCQAxP6cABRQABgACAQjyCQAxP6cABRQAAA==.',De='Deftonia:AwADCAcABAoAAA==.Delalalia:AwACCAIABAoAAA==.Dementïa:AwAICA8ABAoAAA==.Designxx:AwAHCBEABAoAAA==.Destrotim:AwAHCBYABAoEBwAHAQjWBgBC5AECBAoABwAGAQjWBgBIrwECBAoACAAFAQj5OQAzpi8BBAoACQABAQhaKgAHAzMABAoAAA==.Devotional:AwAECAQABAoAAA==.Dez:AwAHCBMABAoAAA==.',Di='Dirgens:AwACCAUABRQCCAACAQhlCwAtf44ABRQACAACAQhlCwAtf44ABRQAAA==.Divinesack:AwAGCAEABAoAAA==.',Do='Dommiemommie:AwAECAQABAoAAQoAAAAICA0ABAo=.Doozee:AwAGCAgABAoAAA==.',Dr='Draktal:AwACCAQABAoAAA==.Dresdén:AwAFCAYABAoAAA==.Drilltime:AwAECAMABAoAAA==.',Dw='Dwarfshmussy:AwAGCAsABAoAAA==.',El='Elizzabeth:AwAFCAoABAoAAA==.Ellisis:AwAFCA0ABAoAAA==.Elvarg:AwAICBUABAoDCwAIAQjJEQA07dMBBAoACwAIAQjJEQA07dMBBAoADAAFAQhqEAAfJPUABAoAAA==.',Er='Ertironin:AwAECAUABAoAAA==.',Ex='Exxitus:AwAECAYABAoAAA==.',Fa='Falsoqt:AwAECAUABAoAAA==.Fat:AwAHCAsABAoAAA==.',Fi='Fidelitaslex:AwAECAMABAoAAA==.',Fj='Fjörgyn:AwADCAUABRQCDQADAQh4AQBXeCsBBRQADQADAQh4AQBXeCsBBRQAAA==.',Fl='Flit:AwACCAMABAoAAA==.',Fo='Fotosynthsis:AwAECAgABAoAAA==.',Ge='Germee:AwAFCAoABAoAAA==.',Gh='Ghosted:AwACCAIABAoAAA==.',Gi='Giggledust:AwAFCAYABAoAAA==.',Gl='Glorified:AwABCAEABRQAAA==.',Go='Goopyscoopy:AwAFCBEABAoAAA==.Goub:AwAHCBsABAoCDgAHAQh5DABQdXgCBAoADgAHAQh5DABQdXgCBAoAAA==.Goubam:AwADCAMABAoAAQ4AUHUHCBsABAo=.',Gr='Grapeinator:AwADCAMABAoAAA==.Grimrock:AwABCAEABAoAAA==.Grizzelbrand:AwAFCA4ABAoAAA==.',Gw='Gwyne:AwAFCA4ABAoAAA==.',Ha='Hashed:AwAGCAoABAoAAA==.Hayspriest:AwACCAUABRQDDwACAQhOBwBH8qYABRQADwACAQhOBwBH8qYABRQAEAABAQj/DwAT0TYABRQAAA==.',He='Healzndps:AwABCAEABRQAAA==.Hemmorhoid:AwAFCAMABAoAAA==.',Ho='Holdeez:AwACCAMABRQCAwAIAQg+GABKsKYCBAoAAwAIAQg+GABKsKYCBAoAAA==.Hoodler:AwACCAMABRQDEQAIAQhHAwBSI68CBAoAEQAHAQhHAwBVWq8CBAoAEgAIAQgOBgBTvK4CBAoAAA==.Hoodlery:AwAECAQABAoAAREAUiMCCAMABRQ=.Hotsock:AwADCAMABAoAAA==.',Hy='Hycise:AwAECAQABAoAARMAV4QCCAUABRQ=.',Ib='Iblastpants:AwADCAQABAoAAA==.',Ig='Iggyy:AwADCAQABAoAAA==.Ignite:AwADCAMABAoAAA==.',Ij='Ijjii:AwADCAMABAoAAA==.',Ik='Ikkirak:AwAECAQABAoAAA==.',In='Intime:AwADCAMABAoAAA==.',Ir='Irila:AwACCAUABAoAAA==.Irshawix:AwACCAUABRQCFAACAQgLDwA++5oABRQAFAACAQgLDwA++5oABRQAAA==.',['I�']='Içarùs:AwACCAIABAoAAQ8ASgUBCAEABRQ=.',Jo='Jomgpallie:AwADCAUABAoAAA==.',Ju='Juktal:AwAFCAkABAoAAA==.Justthetipp:AwACCAQABRQCFQAIAQgFCABKS7YCBAoAFQAIAQgFCABKS7YCBAoAAA==.',Ka='Karesh:AwADCAUABRQCDQADAQjAAQBQjR0BBRQADQADAQjAAQBQjR0BBRQAAA==.Karlsparx:AwAECAwABAoAAA==.',Ki='Kilzhot:AwAICAYABAoAAA==.',Kl='Klacksmonk:AwADCAUABRQCFQADAQiTAgBJ9BwBBRQAFQADAQiTAgBJ9BwBBRQAAA==.',Ko='Kouwfu:AwAECAgABAoAAA==.',Ku='Kuothe:AwAECAoABAoAAA==.',Ky='Kyrael:AwAFCAkABAoAAA==.',La='Lazsi:AwAECAgABAoAAA==.',Lc='Lcc:AwAICBAABAoAAA==.',Le='Lesham:AwAHCBcABAoDFgAHAQjkDABMC20CBAoAFgAHAQjkDABMC20CBAoADQAEAQjyMQA0oM0ABAoAAA==.Lesnichii:AwAGCAsABAoAAA==.',Li='Lightbrngr:AwAHCBMABAoAAA==.Lihuai:AwAGCAsABAoAAA==.Lildipster:AwAGCBIABAoAAA==.Lissandine:AwAHCBYABAoCFwAHAQheFAAsMGMBBAoAFwAHAQheFAAsMGMBBAoAAA==.',Lu='Lucas:AwAICAgABAoAAA==.Luggy:AwAFCAsABAoAAA==.',Ly='Lylith:AwACCAQABAoAAA==.',Ma='Magnusa:AwAECAoABAoAAA==.Manapaws:AwAECAYABAoAAA==.Manion:AwAGCAcABAoAAA==.Mannarchy:AwADCAMABAoAAA==.Mantrà:AwAFCAwABAoAAA==.Manwë:AwADCAUABAoAAA==.Masochista:AwADCAUABRQCGAADAQjLAgBNHQwBBRQAGAADAQjLAgBNHQwBBRQAAA==.Mastric:AwEGCA8ABAoAAA==.Matriss:AwAGCAkABAoAAA==.',Me='Meetch:AwACCAUABRQCGQAIAQgvDgBH6W4CBAoAGQAIAQgvDgBH6W4CBAoAAA==.Megdar:AwADCAEABAoAAA==.',Mo='Moirä:AwAICAgABAoAAQoAAAABCAEABRQ=.Mojobtw:AwAHCA4ABAoAAA==.Morrigan:AwADCAgABAoAAA==.Mortelinnos:AwAGCA8ABAoAAA==.',My='Mysticguru:AwAFCBMABAoAAA==.',Ne='Nevets:AwAFCAkABAoAAA==.Newmainhere:AwAECAYABAoAAA==.',Ni='Nickkshield:AwAFCAUABAoAAA==.Nimit:AwAFCAsABAoAAA==.',No='Notsenka:AwAECAQABAoAAA==.',Ob='Oberron:AwABCAEABAoAAA==.',Of='Offthechain:AwAGCA8ABAoAAA==.',Oj='Ojacks:AwADCAQABAoAAA==.',On='Oneheal:AwACCAIABRQAAREAUiMCCAMABRQ=.Onwedo:AwAECAcABAoAAA==.',Pa='Paddlin:AwAECAQABAoAAA==.Paladingus:AwAFCA0ABAoAAA==.',Pe='Peenar:AwAGCAoABAoAAA==.',Pk='Pk:AwAGCAYABAoAAA==.',Pu='Purin:AwAGCA8ABAoAAA==.',['P�']='Pìkachu:AwABCAIABRQAAA==.',Ra='Rasmus:AwAGCA8ABAoAAA==.Ravency:AwAHCBQABAoCCAAHAQjnDwBRUG8CBAoACAAHAQjnDwBRUG8CBAoAAA==.Raynar:AwACCAIABAoAAA==.Rayquaza:AwAGCA8ABAoAAA==.',Ri='Ribone:AwAFCA0ABAoAAA==.',Ro='Roamin:AwAFCAYABAoAAA==.Roasted:AwAECAwABAoAAA==.',Ry='Ryosham:AwABCAIABRQCDgAIAQiAGAAvNvkBBAoADgAIAQiAGAAvNvkBBAoAAA==.',['R�']='Rêv:AwABCAEABAoAAA==.',Sa='Sagikos:AwAHCBUABAoDEgAHAQjNFwA5k6EBBAoAEgAHAQjNFwA5k6EBBAoAGgADAQgwUgAh5JIABAoAAA==.Saucecity:AwADCAEABAoAAA==.',Sh='Shamanog:AwAHCBUABAoCFgAHAQiIFAAztPEBBAoAFgAHAQiIFAAztPEBBAoAAA==.Shamyshaman:AwAHCA8ABAoAAA==.Shir:AwAECAcABAoAAA==.',Sn='Snookkz:AwADCAYABAoAAA==.Snookz:AwABCAEABRQAAA==.',So='Soziin:AwADCAEABAoAAA==.',Sw='Swizzler:AwAECAQABAoAAA==.',Te='Tecknique:AwACCAQABAoAAA==.Telluride:AwAECAQABAoAAA==.',Th='Thbabadook:AwAECAgABAoAAA==.Thekwaz:AwADCAYABRQDCAADAQgACgA44ZkABRQACAACAQgACgA7+ZkABRQACQABAQiACgAysVEABRQAAA==.Thepromise:AwAECAcABAoAAA==.',To='Toxicedge:AwAICAQABAoAAA==.Toxicvoid:AwAECAQABAoAAQoAAAAICAQABAo=.',Tr='Trakeus:AwACCAUABRQCEwACAQiyCABXhMIABRQAEwACAQiyCABXhMIABRQAAA==.',Ty='Tyrahlia:AwAFCAYABAoAAA==.',Ul='Ulhall:AwAECAUABAoAAA==.',Us='Usøpp:AwADCAMABAoAAA==.',Va='Varibash:AwAGCA8ABAoAAA==.',Ve='Vetsky:AwAICAcABAoAAA==.',Wa='Wardpelican:AwAECAcABAoAAA==.Watermelon:AwAGCAgABAoAAA==.',We='Wednesday:AwABCAEABAoAAA==.Wendy:AwAFCAsABAoAAA==.',Wh='Whitepikmin:AwAGCAoABAoAAA==.',Wi='Wilmer:AwAHCBAABAoAAA==.Wissa:AwACCAIABAoAAA==.',Wr='Wravc:AwAFCA0ABAoAAA==.',Xa='Xaspen:AwADCAUABAoAAA==.',Xk='Xkow:AwAECAkABAoAAA==.',Xm='Xmysticxz:AwAFCAUABAoAAA==.',Xx='Xxannii:AwAFCAYABAoAAA==.',Ya='Yanyo:AwABCAEABAoAAA==.Yargzdk:AwACCAUABRQCGAACAQicCQAU92UABRQAGAACAQicCQAU92UABRQAAA==.',Ye='Yeahyo:AwABCAEABRQAAA==.Yeyol:AwABCAEABAoAAA==.',Yu='Yunikon:AwAGCAEABAoAAQoAAAAGCBIABAo=.',Ze='Zell:AwAECAYABAoAAA==.Zensix:AwAECAQABAoAAA==.Zeranyx:AwAFCAcABAoAAA==.',Zu='Zuggzug:AwAHCAEABAoAAA==.',['Ì']='Ìrìsh:AwABCAIABAoAAA==.',['Ö']='Ören:AwAFCAYABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end