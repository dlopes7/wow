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
 local lookup = {'Mage-Frost','Unknown-Unknown','DeathKnight-Blood','Shaman-Enhancement','Druid-Guardian',}; local provider = {region='US',realm='Korialstrasz',name='US',type='weekly',zone=42,date='2025-03-29',data={Ac='Accursed:AwAGCAMABAoAAA==.',At='Atlantis:AwACCAMABAoAAA==.',Au='Auraxia:AwAECAoABAoAAA==.',Az='Azzrell:AwADCAoABAoAAA==.',Ba='Bananâs:AwAGCAgABAoAAA==.',Be='Belan:AwAFCAsABAoAAA==.Belladin:AwAHCBIABAoAAA==.',Bi='Bishmage:AwAICBUABAoCAQAIAQg4DABH+nwCBAoAAQAIAQg4DABH+nwCBAoAAA==.Bishwarrior:AwAECAQABAoAAQEAR/oICBUABAo=.',Bl='Blamezuko:AwAGCAwABAoAAA==.Bloodfrost:AwAICA4ABAoAAA==.',Bo='Bobiejo:AwAGCA8ABAoAAA==.',Ca='Cachinnare:AwACCAIABAoAAQIAAAAHCBEABAo=.Calabretta:AwAFCAsABAoAAA==.',Ch='Chargelot:AwADCAUABAoAAQIAAAAFCAsABAo=.',Co='Cobey:AwADCAUABAoAAA==.Corpze:AwAGCAQABAoAAA==.Cosmicjay:AwADCAUABAoAAA==.',Da='Dantruis:AwABCAEABRQAAA==.',De='Demonwolfss:AwABCAEABRQAAQMASRMFCAoABRQ=.',Di='Diabla:AwADCAMABAoAAA==.',Em='Emberrose:AwADCAMABAoAAA==.',Fe='Fernet:AwACCAMABAoAAA==.',Fl='Flarewalker:AwAICAIABAoAAA==.Flarewolf:AwAICBAABAoAAA==.Flopper:AwAECAQABAoAAA==.',Fr='Frostfires:AwAICBMABAoAAA==.Fryerchris:AwEDCAUABAoAAA==.',Fy='Fynn:AwABCAIABRQCBAAIAQh1EAAvuzcCBAoABAAIAQh1EAAvuzcCBAoAAA==.',Go='Goldenlock:AwACCAIABAoAAA==.Golfmo:AwAFCA8ABAoAAA==.',Ha='Hailin:AwAFCA0ABAoAAA==.Hassilhery:AwADCAEABAoAAA==.',Ka='Kamerth:AwAECAoABAoAAA==.Karluron:AwADCAEABAoAAA==.Kasumi:AwAHCBIABAoAAA==.Katmoreahh:AwAGCAoABAoAAQUAYjMICBcABAo=.Katowo:AwAICBcABAoCBQAIAQgmAABiM4cDBAoABQAIAQgmAABiM4cDBAoAAA==.Kazure:AwAGCAsABAoAAA==.',Ke='Kevinbakin:AwAFCAoABAoAAA==.',Ko='Konekokat:AwEBCAIABAoAAA==.',La='Laaksy:AwABCAEABRQAAA==.Lafondah:AwAGCAUABAoAAA==.',Li='Lilbabycat:AwABCAEABAoAAA==.',Lu='Luwwin:AwABCAEABAoAAA==.',Ma='Magiclaire:AwAFCAUABAoAAA==.',Me='Meetflaps:AwABCAEABAoAAA==.',Ms='Msspelled:AwABCAIABAoAAA==.',Mx='Mximus:AwADCAEABAoAAA==.',Na='Nabstar:AwAECAYABAoAAA==.Nasroth:AwAGCBAABAoAAA==.',Or='Orangedrives:AwABCAEABRQAAA==.Oreeli:AwAFCAoABAoAAA==.',Pl='Plainjane:AwAICA0ABAoAAA==.Pläze:AwACCAQABAoAAA==.',Ra='Ramitos:AwACCAMABAoAAA==.',['R�']='Rôflstômp:AwAECAcABAoAAA==.',Sg='Sgtpepperz:AwADCAcABAoAAA==.',Sh='Shanea:AwAGCAwABAoAAA==.Shoinked:AwACCAQABAoAAA==.',Si='Sinned:AwAICAYABAoAAA==.',St='Stabbytrout:AwAHCAsABAoAAA==.',['S�']='Sàlanis:AwACCAIABAoAAA==.Sälanis:AwABCAEABAoAAQIAAAACCAIABAo=.',Ti='Tirnos:AwABCAEABAoAAA==.',Tr='Traydle:AwAFCAsABAoAAA==.',Ty='Tylenil:AwAICBMABAoAAA==.',Vl='Vladvladvlad:AwAHCAcABAoAAA==.',Wa='Watermelon:AwADCAUABAoAAA==.',Wh='Whalaski:AwAFCAUABAoAAA==.',Wi='Wings:AwAGCAQABAoAAA==.',Ze='Zellztoo:AwAECAoABAoAAA==.',Zi='Zillâ:AwACCAIABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end