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
 local lookup = {'Unknown-Unknown','Hunter-BeastMastery','Rogue-Outlaw','Priest-Holy','DeathKnight-Blood',}; local provider = {region='US',realm='SteamwheedleCartel',name='US',type='weekly',zone=42,date='2025-03-28',data={Br='Brownbelt:AwADCAgABAoAAA==.',Bu='Buteihunter:AwAFCAkABAoAAA==.',Ca='Cadranak:AwAECAEABAoAAA==.Carlnomicron:AwAFCA4ABAoAAA==.',Da='Dallma:AwAICAMABAoAAA==.Dalm:AwAGCAgABAoAAQEAAAAICAMABAo=.Dayaris:AwABCAEABAoAAA==.',De='Deaflynn:AwAHCAEABAoAAA==.',Di='Diamante:AwAHCAoABAoAAA==.',Dr='Dremu:AwADCAIABAoAAA==.',El='Elamaun:AwADCAgABAoAAA==.',Fa='Faelyna:AwADCAYABAoAAA==.',Fo='Forged:AwAGCBAABAoAAA==.',Go='Goodhead:AwADCAcABAoAAA==.',Ho='Holyverdict:AwAGCBIABAoAAA==.',Ji='Jingshei:AwACCAIABAoAAA==.',Ka='Katnipp:AwAFCAkABAoAAA==.Kaylazune:AwADCAUABAoAAA==.',La='Larquin:AwACCAIABAoAAA==.',Li='Liminara:AwEFCAoABAoAAQIAL+wECAkABRQ=.',Ma='Manthrax:AwAFCAEABAoAAA==.',Mi='Missmolt:AwAFCBQABAoCAwAFAQiOBABH8YgBBAoAAwAFAQiOBABH8YgBBAoAAA==.',Mu='Mustachemolt:AwACCAQABAoAAA==.',['M�']='Mürsaat:AwACCAUABAoAAA==.',Nu='Nurgle:AwACCAIABAoAAA==.',Ol='Olizia:AwAFCAsABAoAAA==.',Op='Opex:AwACCAEABAoAAA==.',Pl='Pluglord:AwAECAgABAoAAA==.',Ra='Rakle:AwAFCAEABAoAAA==.Rameses:AwACCAIABAoAAA==.Ravinar:AwADCAgABAoAAA==.',Re='Redux:AwAFCAEABAoAAA==.',Rh='Rhÿshanley:AwACCAMABAoAAA==.',Ro='Roxicet:AwADCAUABAoAAA==.',Ru='Ruthina:AwABCAEABAoAAA==.',Sa='Santofrancis:AwAFCAkABAoAAA==.',Se='Selfplay:AwAICAcABAoAAA==.Seraie:AwABCAEABRQCBAAHAQj4BABd19UCBAoABAAHAQj4BABd19UCBAoAAA==.',Sh='Shayden:AwACCAIABAoAAA==.',Si='Sigridaudgun:AwACCAUABRQCBQACAQieBgBDXZwABRQABQACAQieBgBDXZwABRQAAA==.',St='Startia:AwACCAMABAoAAA==.',Sy='Sybri:AwAGCAsABAoAAA==.',Ti='Tiluvar:AwAGCAEABAoAAA==.',Tm='Tmog:AwAGCBEABAoAAA==.',Ve='Velysa:AwADCAgABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end