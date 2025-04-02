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
 local lookup = {'Unknown-Unknown','Rogue-Outlaw','Druid-Restoration','Warrior-Fury','Warrior-Arms','Monk-Brewmaster','Druid-Balance','Mage-Arcane','Warrior-Protection','Paladin-Retribution',}; local provider = {region='US',realm='Moonrunner',name='US',type='weekly',zone=42,date='2025-03-29',data={Ab='Abbr:AwAECAIABAoAAA==.',Ad='Adragon:AwACCAIABAoAAA==.',Ae='Aedryll:AwAFCAsABAoAAA==.Aein:AwABCAEABRQAAA==.',Ah='Ahj:AwACCAEABAoAAQEAAAAFCAEABAo=.',Ak='Akiyama:AwAECAYABAoAAQEAAAAICAgABAo=.Aktras:AwABCAIABRQAAA==.',Al='Alkaid:AwACCAQABRQCAgAIAQhgAQBRSMECBAoAAgAIAQhgAQBRSMECBAoAAA==.',An='Anarky:AwAICAgABAoAAA==.',Ar='Aranak:AwAGCAEABAoAAA==.Archdemon:AwAFCAsABAoAAA==.Arhc:AwABCAEABAoAAA==.',Au='Auani:AwAFCA8ABAoAAA==.',Ba='Babyrinsjr:AwADCAMABAoAAA==.',Be='Bellanisa:AwABCAEABAoAAA==.',Bo='Bo:AwAFCA8ABAoAAA==.Bobsledbob:AwADCAYABAoAAA==.',Br='Brightborne:AwABCAEABAoAAA==.Bru:AwAGCAgABAoAAA==.Brya:AwABCAEABAoAAA==.Bryxi:AwAGCA0ABAoAAA==.Brünhilde:AwAECAYABAoAAA==.',Bs='Bstbll:AwADCAgABRQCAwADAQiFAwAucuAABRQAAwADAQiFAwAucuAABRQAAA==.',Bu='Buella:AwAFCA4ABAoAAA==.Bugerflipper:AwADCAEABAoAAA==.Buttsnacks:AwAFCAIABAoAAA==.',Ca='Caltaa:AwAFCA8ABAoAAA==.Cambrie:AwACCAIABAoAAA==.Canthan:AwAFCAUABAoAAQEAAAAGCAEABAo=.Canverian:AwADCAMABAoAAA==.Cattimia:AwAECAYABAoAAA==.',Ch='Chickenwing:AwAECAYABAoAAA==.Chilin:AwAECAIABAoAAA==.Chillback:AwAECAgABAoAAA==.Christano:AwAFCAEABAoAAA==.Christhecold:AwAFCA4ABAoAAA==.',Cy='Cylvara:AwADCAMABAoAAA==.',Da='Daarina:AwADCAQABAoAAA==.Dalacia:AwAECAYABAoAAA==.Darkevo:AwAFCA8ABAoAAA==.Datnagadrake:AwABCAIABRQDBAAHAQgsEQBVfGgCBAoABAAGAQgsEQBdtWgCBAoABQAEAQhnJQAz4/AABAoAAA==.Dawinchy:AwAHCA8ABAoAAA==.',De='Deadlylocks:AwAFCAIABAoAAA==.Deadlypsycho:AwAFCA8ABAoAAA==.Dellistia:AwAICAgABAoAAA==.Desdamona:AwADCAQABAoAAA==.Devorick:AwAFCA8ABAoAAA==.',Di='Dijarl:AwAFCAoABAoAAA==.',Dj='Djingrogu:AwADCAUABAoAAA==.',Do='Doodlebob:AwAHCAEABAoAAA==.Doorki:AwAHCAEABAoAAA==.',Dr='Draickin:AwADCAoABAoAAA==.Drumroleplz:AwABCAEABRQAAA==.',Du='Duud:AwAFCAEABAoAAA==.',Ee='Eeviy:AwAECAQABAoAAA==.',En='Endolar:AwABCAEABAoAAA==.',Er='Erianthe:AwAFCA0ABAoAAA==.',Es='Esherä:AwADCAQABAoAAA==.',Ex='Exmar:AwAGCAsABAoAAA==.',Fa='Faalyen:AwAECAUABAoAAA==.',Fc='Fckmalfurion:AwAFCAkABAoAAA==.',Fi='Finatic:AwACCAMABRQAAA==.',Fl='Flanders:AwADCAIABAoAAA==.',Fr='Fryze:AwADCAcABAoAAA==.',Ga='Gabrik:AwAFCAoABAoAAA==.',Gh='Ghosimoon:AwADCAUABAoAAA==.',Gi='Gil:AwAFCA8ABAoAAA==.',Gl='Glizzygobler:AwAHCBIABAoAAA==.',Go='Goatspace:AwAECAYABAoAAA==.Gogohobo:AwAFCAQABAoAAA==.',Gr='Grosella:AwAECAsABAoAAA==.',Ha='Hardsus:AwAECAQABAoAAA==.',He='Hecate:AwADCAEABAoAAA==.',Hi='Hightide:AwABCAMABRQAAA==.',Ho='Holyfrejoles:AwAICAMABAoAAA==.',Hu='Hunkahunka:AwAECAQABAoAAA==.Huntrezz:AwAECAQABAoAAA==.Hurtsdounght:AwAFCAkABAoAAA==.',Id='Idkmyname:AwABCAEABAoAAA==.',Im='Imnotedgy:AwADCAQABAoAAA==.Impervious:AwACCAIABAoAAA==.',In='Incogneato:AwADCAMABAoAAA==.',Ir='Ironic:AwAFCA8ABAoAAA==.',Is='Iskandar:AwAECAkABAoAAA==.',It='Itwaswalters:AwACCAEABAoAAA==.',Ja='Jamal:AwAFCAEABAoAAA==.',Je='Jekkt:AwAFCA4ABAoAAA==.',Ka='Kalinnia:AwAECAEABAoAAA==.',Ke='Keilas:AwADCAMABAoAAA==.Keyes:AwADCAkABRQCBgADAQhqAABbpEIBBRQABgADAQhqAABbpEIBBRQAAA==.',Ki='Kirlia:AwADCAEABAoAAA==.',Ko='Koresh:AwADCAUABAoAAA==.Koriastrasza:AwADCAIABAoAAA==.',Kr='Krobelus:AwAFCA8ABAoAAA==.',['K�']='Kìllstheweak:AwAFCA8ABAoAAA==.',La='Layliah:AwACCAMABRQCBwAIAQjlBQBduxcDBAoABwAIAQjlBQBduxcDBAoAAA==.',Le='Lezebel:AwABCAEABAoAAA==.',Lo='Lormazlezrax:AwAFCAIABAoAAA==.',Lu='Luxace:AwABCAEABAoAAA==.',Me='Meatballer:AwAFCAoABAoAAA==.Medreaux:AwAGCAYABAoAAQEAAAAICAwABAo=.Mev:AwAICAgABAoAAA==.',Mi='Microfel:AwAGCAkABAoAAA==.Mitsuri:AwABCAEABAoAAA==.',Ml='Mlorenzo:AwACCAMABRQCCAAIAQgwAQBCH48CBAoACAAIAQgwAQBCH48CBAoAAA==.',Mo='Moks:AwAGCAcABAoAAQEAAAAICAgABAo=.Mothcra:AwABCAIABAoAAA==.',Mu='Murghtag:AwAFCAYABAoAAA==.',Na='Nanuki:AwAICAwABAoAAA==.',Nc='Nc:AwAGCAwABAoAAA==.',Ne='Nearn:AwAFCAIABAoAAA==.',Ni='Nightsmoke:AwAECAUABAoAAA==.',No='Nonattarius:AwADCAMABAoAAA==.Norezfou:AwAFCA8ABAoAAA==.',Nu='Nurobi:AwAHCBAABAoAAA==.',Od='Odanobunaga:AwADCAQABAoAAA==.Odyn:AwADCAQABAoAAA==.',Pa='Pancake:AwAFCAoABAoAAA==.Paradias:AwAGCAoABAoAAA==.',Pe='Peppersham:AwADCAMABAoAAA==.',Po='Poca:AwAFCAwABAoAAA==.',Pr='Primed:AwAFCA8ABAoAAA==.Professor:AwAECAYABAoAAA==.',Qu='Quadtwat:AwAGCAgABAoAAA==.',Ra='Rahmehn:AwAFCAIABAoAAA==.Rawfistermr:AwADCAQABAoAAA==.Raña:AwADCAMABAoAAA==.',Re='Remoria:AwACCAIABAoAAA==.Reuvir:AwAGCAEABAoAAA==.Revans:AwAICAgABAoAAA==.',Ri='Rizzoy:AwAFCAUABAoAAA==.',Ru='Ruckabis:AwAFCAIABAoAAA==.',Sa='Sakuria:AwAECAQABAoAAA==.Sarkana:AwAFCAIABAoAAA==.Saxonn:AwAECAYABAoAAA==.Saydis:AwADCAMABAoAAA==.',Se='Seleinai:AwAFCA0ABAoAAA==.',Sh='Shalami:AwACCAEABAoAAA==.Shamina:AwAICAgABAoAAA==.Sharkbones:AwADCAMABAoAAA==.Shifts:AwAHCAQABAoAAA==.Shiftyy:AwADCAEABAoAAA==.',Sp='Spikedriver:AwAFCA0ABAoAAA==.Spooge:AwACCAIABAoAAA==.',St='Stariane:AwAFCA0ABAoAAA==.Steelclap:AwABCAEABAoAAA==.Stepdad:AwAECAYABAoAAA==.',Ta='Talanea:AwAFCA8ABAoAAA==.',Te='Telain:AwAECAYABAoAAA==.',Th='Thakilla:AwAICA4ABAoAAA==.Thalaton:AwAGCAsABAoAAA==.Thatsdillon:AwAGCA4ABAoAAA==.Thoryndin:AwADCAMABAoAAA==.',Ti='Titan:AwADCAcABRQDBAADAQhwCAA1ObwABRQABAACAQhwCABMUrwABRQACQABAQieBQAHCDMABRQAAA==.',Tr='Trinjal:AwAFCAYABAoAAA==.Trolosarushx:AwABCAIABRQCCgAIAQg2KABBr1ACBAoACgAIAQg2KABBr1ACBAoAAA==.',Tu='Tuskadin:AwADCAIABAoAAA==.',Ug='Uglybeast:AwAGCBAABAoAAA==.',Ve='Verfanglich:AwAECAYABAoAAA==.',Vi='Vitalorange:AwACCAQABRQDBwAIAQgtCABZ/PQCBAoABwAIAQgtCABZ/PQCBAoAAwABAQgTWQALoS8ABAoAAA==.',Vo='Vozrezz:AwABCAEABAoAAA==.',['V�']='Vëda:AwAFCAIABAoAAA==.',Wr='Wras:AwADCAMABAoAAA==.',Xa='Xandrah:AwADCAMABAoAAA==.Xanxap:AwAGCA0ABAoAAA==.',Xe='Xenogears:AwACCAIABAoAAA==.',Xi='Xiansai:AwAFCAIABAoAAA==.',Za='Zakilan:AwABCAEABAoAAA==.',Zu='Zuzaka:AwACCAIABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end