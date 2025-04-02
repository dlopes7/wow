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
 local lookup = {'Priest-Shadow','Unknown-Unknown','Warrior-Fury','Warrior-Arms','Monk-Mistweaver','Mage-Frost','Paladin-Retribution','Evoker-Devastation','Evoker-Preservation','Evoker-Augmentation','Mage-Fire','Shaman-Restoration','Druid-Balance','DeathKnight-Unholy','Priest-Holy','Priest-Discipline','DeathKnight-Blood','Warlock-Demonology','Warrior-Protection','Monk-Windwalker','DemonHunter-Vengeance','DemonHunter-Havoc','Druid-Restoration','Paladin-Holy',}; local provider = {region='US',realm='Fizzcrank',name='US',type='weekly',zone=42,date='2025-03-29',data={Aa='Aaluna:AwAHCBQABAoCAQAHAQhnJgAQbR4BBAoAAQAHAQhnJgAQbR4BBAoAAA==.',Ak='Akittymeow:AwAFCAsABAoAAA==.',Al='Altmage:AwAGCBMABAoAAA==.',Am='Amelina:AwACCAIABAoAAA==.Aminni:AwADCAMABAoAAQIAAAAGCAsABAo=.',An='Anxíety:AwACCAIABAoAAQIAAAAFCAwABAo=.',Ap='Applephone:AwAGCA8ABAoAAA==.',Ar='Arcanas:AwAFCAQABAoAAA==.Archontas:AwADCAUABAoAAA==.Aritus:AwABCAEABRQCAwAIAQgIBABdjS0DBAoAAwAIAQgIBABdjS0DBAoAAA==.Artuarry:AwAICBMABAoAAA==.Arune:AwABCAEABAoAAA==.',Ba='Banthr:AwAFCAgABAoAAA==.',Be='Beggin:AwAICBYABAoDAwAIAQgsBwBRrPUCBAoAAwAIAQgsBwBRrPUCBAoABAADAQhnLwA8n6AABAoAAA==.',Bi='Billybandaid:AwAICBgABAoCBQAIAQhFGQAzSdwBBAoABQAIAQhFGQAzSdwBBAoAAA==.',Bl='Blazy:AwAFCAoABAoAAA==.Blutø:AwAFCAsABAoAAA==.',Bu='Butcherme:AwAFCAgABAoAAA==.Buttercups:AwAGCA4ABAoAAA==.',Ch='Chubbygirl:AwAECAMABAoAAA==.',Cl='Cleansing:AwADCAYABAoAAA==.Cleyi:AwAGCAsABAoAAA==.',Co='Coldpasta:AwAFCAUABAoAAA==.Coldroled:AwADCAcABRQCBgADAQhlAQAvmeIABRQABgADAQhlAQAvmeIABRQAAA==.Cosairi:AwABCAEABAoAAA==.Cougztroll:AwAGCAYABAoAAA==.',Da='Daranne:AwACCAYABRQCBwACAQhlEwAW8oMABRQABwACAQhlEwAW8oMABRQAAA==.',De='Deaduglie:AwAGCAYABAoAAA==.',Do='Dolphinz:AwABCAIABRQCBwAHAQj4IQBUQnICBAoABwAHAQj4IQBUQnICBAoAAA==.',Dr='Dragoose:AwAICBgABAoECAAIAQjFDwBJ4wQCBAoACAAHAQjFDwBGlgQCBAoACQAHAQiLDQAXMUMBBAoACgABAQj8BQAyxi8ABAoAAA==.Dread:AwADCAMABAoAAA==.Drykkr:AwAFCA0ABAoAAA==.',Dy='Dyondarra:AwACCAIABAoAAA==.',Ec='Ectobio:AwABCAEABAoAAA==.Ectotot:AwADCAkABAoAAA==.',Em='Emmymage:AwAICBgABAoDBgAIAQhdAwBYPiQDBAoABgAIAQhdAwBYPiQDBAoACwAEAQhqPQBJ2ysBBAoAAA==.',Ep='Ephelia:AwACCAYABRQCDAACAQhRBgBOqbsABRQADAACAQhRBgBOqbsABRQAAA==.',Ev='Everlight:AwAFCA0ABAoAAA==.',Fa='Fatterblunt:AwAICBkABAoCDQAIAQhEEwBICWICBAoADQAIAQhEEwBICWICBAoAAA==.',Fo='Fourdy:AwAICBEABAoAAA==.',Fr='Froost:AwACCAYABRQCDgACAQhrBwA0QJoABRQADgACAQhrBwA0QJoABRQAAA==.',Ga='Gapper:AwADCAMABAoAAQIAAAAGCAsABAo=.',Gi='Gigalith:AwAFCAoABAoAAA==.',Gl='Glestaar:AwAFCBAABAoAAA==.Glow:AwAECAoABAoAAA==.',Go='Gooper:AwAGCAsABAoAAA==.',Ha='Hairi:AwABCAIABRQDDwAIAQiqAQBesTYDBAoADwAIAQiqAQBesTYDBAoAEAABAQhVTwBCkkIABAoAAA==.Hattorihanzo:AwABCAIABAoAAA==.',In='Inktray:AwAFCAkABAoAAA==.',Ja='Jakub:AwAGCAEABAoAAA==.Jalee:AwAFCAoABAoAAA==.',Je='Jerthro:AwAICAIABAoAAA==.Jesit:AwAHCBUABAoCCAAHAQiXFgAm0pEBBAoACAAHAQiXFgAm0pEBBAoAAA==.',Ka='Kamarra:AwABCAEABAoAAA==.Kankles:AwAGCAwABAoAAA==.',Ke='Keeinath:AwADCAMABAoAAA==.Kernelpanic:AwAICBcABAoDDgAIAQgCCABT+98CBAoADgAIAQgCCABT+98CBAoAEQABAQifRQADQhQABAoAAA==.',Li='Lithann:AwEBCAEABAoAAA==.',Lo='Loadedtaco:AwADCAIABAoAAA==.Lowang:AwAFCAsABAoAAA==.',Lu='Lumie:AwACCAIABAoAAA==.Lunamae:AwAFCA0ABAoAAA==.Luvvyaa:AwAGCAsABAoAAA==.',Ma='Maxohlx:AwACCAMABRQCEgAIAQiiAgBQMKQCBAoAEgAIAQiiAgBQMKQCBAoAAA==.',Me='Meeko:AwEDCAEABAoAAQkASloDCAYABRQ=.Melynne:AwAGCAYABAoAAA==.',Mi='Minaki:AwADCAUABAoAAA==.',Mo='Moistori:AwAGCAwABAoAAA==.Mormdring:AwAFCAUABAoAAA==.',My='Myschism:AwAHCBUABAoCEwAHAQglBwA8aO0BBAoAEwAHAQglBwA8aO0BBAoAAA==.',Na='Nagaphen:AwAICAgABAoAAA==.Nareyne:AwABCAEABAoAAA==.',Nb='Nbg:AwAECAcABAoAAA==.',Ne='Nessará:AwACCAIABAoAAA==.',Ni='Ninjapro:AwAGCAYABAoAAA==.',Nu='Nuraga:AwADCAgABAoAAA==.',Oo='Oogway:AwAICBwABAoCFAAIAQiSBwBOIcgCBAoAFAAIAQiSBwBOIcgCBAoAAA==.',Op='Ophil:AwABCAEABAoAAA==.',Pa='Paldaka:AwAFCA0ABAoAAA==.Pandaemonia:AwACCAYABRQCFQACAQi+BgAI8lcABRQAFQACAQi+BgAI8lcABRQAAA==.Papafritas:AwAFCAoABAoAAA==.Pattilicious:AwAFCAoABAoAAA==.',Ph='Phlvsht:AwADCAcABAoAAA==.',Pi='Pierres:AwADCAIABAoAAA==.',Pl='Plantman:AwACCAIABAoAAA==.',Qu='Qualek:AwAHCA4ABAoAAA==.Quilue:AwADCAYABAoAAA==.',Ra='Raeleth:AwABCAEABAoAAA==.Ralton:AwACCAIABAoAAA==.Rannmagnison:AwADCAYABAoAAA==.Rathol:AwACCAIABAoAAA==.Razlin:AwADCAIABAoAAA==.',Ry='Rygaard:AwAECAYABAoAAA==.',Sa='Sapharina:AwAECAcABAoAAA==.',Se='Sealmyfate:AwABCAMABRQCFgAIAQimJwAjr98BBAoAFgAIAQimJwAjr98BBAoAAA==.Searfang:AwABCAEABAoAAA==.Seync:AwAFCAsABAoAAA==.',Sh='Shotzfired:AwABCAEABAoAAA==.',Sk='Skytec:AwAFCAwABAoAAA==.',Sn='Snowscayia:AwAHCBgABAoCFwAHAQjcCABS7XUCBAoAFwAHAQjcCABS7XUCBAoAAA==.',So='Solatium:AwAICAsABAoAAA==.',Sp='Spaceduck:AwAICAgABAoAAA==.',Sr='Srry:AwABCAQABRQCAwAIAQibCgBKwr8CBAoAAwAIAQibCgBKwr8CBAoAAA==.',St='Sternenfall:AwAFCAYABAoAAA==.Stewie:AwAGCAYABAoAAA==.Stord:AwAICAIABAoAAA==.',Sw='Swayzeetrain:AwACCAEABRQCGAAIAQiiCwA04/wBBAoAGAAIAQiiCwA04/wBBAoAAA==.',Ta='Tael:AwACCAMABAoAAA==.',Ti='Tinkaballah:AwAHCA0ABAoAAA==.',Tw='Twileaf:AwAECAEABAoAAA==.',Ty='Typhoidmary:AwAECAcABAoAAA==.',['T�']='Térror:AwAFCAwABAoAAA==.',Va='Varrik:AwAHCA0ABAoAAA==.',Ve='Veliri:AwABCAEABAoAAA==.',Vo='Volklin:AwADCAEABAoAAA==.',['V�']='Vàrrik:AwAECAQABAoAAQIAAAAHCA0ABAo=.',Wr='Wrack:AwAECAcABAoAAA==.',Xi='Xia:AwAGCAYABAoAAA==.',Xo='Xoilkick:AwABCAEABAoAAA==.Xoilstelth:AwACCAIABAoAAQIAAAAHCAEABAo=.',Yu='Yumeshade:AwAHCBYABAoDDwAHAQjZDwBEhCgCBAoADwAHAQjZDwBEhCgCBAoAAQABAQgqTgAYJiUABAoAAA==.',Za='Zamari:AwAECAcABAoAAA==.',Ze='Zealous:AwAICBAABAoAAA==.',Zh='Zhoul:AwAFCAoABAoAAA==.',Zo='Zoerina:AwAECAEABAoAAA==.Zoobilong:AwAFCAsABAoAAA==.',Zw='Zwaffle:AwABCAEABAoAAQcAVEIBCAIABRQ=.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end