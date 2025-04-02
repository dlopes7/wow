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
 local lookup = {'DemonHunter-Havoc','DemonHunter-Vengeance','Shaman-Restoration','Monk-Brewmaster','Warlock-Destruction',}; local provider = {region='US',realm='Arygos',name='US',type='weekly',zone=42,date='2025-03-29',data={Aa='Aaryssian:AwAGCBIABAoAAA==.',Al='Alazandria:AwAICBAABAoAAA==.Alyssalee:AwAICAgABAoAAA==.',An='Antashaman:AwADCAMABAoAAA==.',Be='Beerhelmet:AwECCAIABAoAAA==.',Br='Braleanna:AwAECAcABAoAAA==.',Ca='Callalilly:AwAICA8ABAoCAQAIAQjbcwACtVsABAoAAQAIAQjbcwACtVsABAoAAA==.',Ch='Cheesekurd:AwABCAEABAoAAA==.',Co='Coinlock:AwAFCBAABAoAAA==.Comboost:AwAFCAwABAoAAA==.',Da='Daywalkers:AwAFCAwABAoAAA==.',De='Deathforhire:AwAECAIABAoAAA==.',Di='Disastro:AwACCAEABAoAAA==.',Ea='Earnest:AwACCAMABRQCAgAIAQjBBABOhbECBAoAAgAIAQjBBABOhbECBAoAAA==.',El='Elmo:AwAECAcABAoAAA==.',Fe='Feralkitty:AwAICAgABAoAAQEAArUICA8ABAo=.',Fl='Flogg:AwAHCAwABAoAAA==.',Fo='Foregotten:AwAGCAgABAoAAA==.',Ga='Gathward:AwAFCAwABAoAAA==.Gazreiale:AwAFCAwABAoAAA==.',Gr='Greenblades:AwABCAEABAoAAA==.',Gw='Gwaine:AwAECAQABAoAAA==.',Ho='Holyhero:AwAGCBEABAoAAA==.',Ip='Ipoopied:AwAFCAYABAoAAA==.',Je='Jerry:AwAECAQABAoAAA==.',Ka='Kakui:AwACCAIABAoAAA==.',Ku='Kunaee:AwAFCAwABAoAAA==.Kuther:AwACCAIABAoAAA==.',La='Lawd:AwAFCAMABAoAAA==.Lawdheçomin:AwADCAYABAoAAA==.',Lo='Lockly:AwAICAgABAoAAA==.',Ma='Macabre:AwABCAEABAoAAA==.',Me='Messi:AwABCAEABRQCAwAIAQgWGAA0nAMCBAoAAwAIAQgWGAA0nAMCBAoAAA==.',Mi='Mikosan:AwAICBAABAoAAA==.Minniedonut:AwAFCAYABAoAAA==.',Mo='Mortgage:AwAICBAABAoAAA==.',Na='Nathansbb:AwAFCAMABAoAAA==.',No='Norrahh:AwAECAQABAoAAA==.',Pe='Penelopè:AwABCAIABRQCBAAIAQjyAwBCglACBAoABAAIAQjyAwBCglACBAoAAA==.',Re='Rewbix:AwAGCAsABAoAAA==.',Ri='Riaglais:AwAFCAwABAoAAA==.',Ro='Rockkso:AwAGCAYABAoAAA==.Rolder:AwACCAMABRQCBQAIAQhdCwBMI6kCBAoABQAIAQhdCwBMI6kCBAoAAA==.Rottentaint:AwAECAIABAoAAA==.',Sa='Sarabi:AwABCAEABAoAAA==.',Se='Selynne:AwADCAQABAoAAA==.',Si='Sindorei:AwADCAcABAoAAA==.',Sl='Sleeptalk:AwAHCAEABAoAAA==.',Th='Theorii:AwABCAEABAoAAA==.',Ti='Tifalockhàrt:AwAGCAgABAoAAA==.',To='Totetum:AwAECAYABAoAAA==.',Tr='Trillc:AwAICAwABAoAAA==.Tryniti:AwACCAIABAoAAA==.',Vo='Vovek:AwACCAIABAoAAA==.',Wi='Wigglez:AwAICAsABAoAAA==.',Za='Zaravia:AwAICAgABAoAAA==.',['É']='Éntity:AwAGCAsABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end