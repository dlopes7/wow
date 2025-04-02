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
 local lookup = {'Warrior-Fury','Unknown-Unknown','Hunter-BeastMastery',}; local provider = {region='US',realm='Auchindoun',name='US',type='weekly',zone=42,date='2025-03-29',data={Ao='Aoki:AwADCAcABAoAAA==.',Ar='Arkanoas:AwAGCAkABAoAAA==.',Bl='Bloodrider:AwADCAsABAoAAA==.',Ca='Cathleen:AwACCAEABAoAAA==.',Ch='Chubtart:AwAGCBMABAoAAA==.',Ci='Ciborg:AwACCAQABAoAAA==.',De='Deathborne:AwAECAUABAoAAA==.',Du='Durötan:AwAGCA4ABAoAAQEAWQAHCBsABAo=.Dutchess:AwADCAUABAoAAA==.',Ei='Eilonwy:AwEECAwABAoAAA==.',El='Elowen:AwAGCA4ABAoAAA==.',Er='Eríngo:AwAGCBIABAoAAA==.',Fl='Floise:AwAGCA0ABAoAAA==.',He='Hennessÿ:AwACCAMABAoAAA==.',Iz='Izeroeasily:AwADCAMABAoAAA==.Izzi:AwAGCBEABAoAAA==.',Je='Jester:AwACCAQABAoAAA==.',Kl='Klipnor:AwAECAMABAoAAA==.',Kr='Krumkabob:AwADCAMABAoAAA==.',Ky='Kyndra:AwACCAIABAoAAQIAAAAGCAwABAo=.Kynyctemavra:AwAGCAwABAoAAA==.',Le='Lemonaids:AwACCAMABAoAAA==.',Mi='Mightymost:AwAFCBIABAoAAA==.',Mo='Molfey:AwADCAQABAoAAA==.Morehastepls:AwADCAMABAoAAQEAWQAHCBsABAo=.',Mu='Mudds:AwADCAMABAoAAA==.',Ni='Nicodomus:AwACCAIABAoAAA==.Nightrush:AwAGCBEABAoAAA==.',Ra='Raco:AwABCAEABAoAAA==.Rathon:AwABCAEABAoAAA==.',Ry='Ryuk:AwABCAEABAoAAA==.',Sh='Shinji:AwADCAMABAoAAA==.',So='Socklock:AwAGCBIABAoAAA==.Solidgold:AwAHCBsABAoCAQAHAQiGCgBZAMACBAoAAQAHAQiGCgBZAMACBAoAAA==.',Ti='Timetwodie:AwACCAQABAoAAA==.',Tr='Trevenant:AwAFCAUABAoAAA==.',Up='Upphoria:AwADCAYABAoAAA==.',Vi='Viccan:AwABCAEABAoAAA==.',Wo='Wont:AwABCAEABAoAAA==.',Xr='Xra:AwADCAIABAoAAA==.',Ya='Yangtao:AwAFCAkABAoAAA==.',Zp='Zpqc:AwADCAQABAoAAA==.',['Å']='Åü:AwAGCBAABAoAAQEAWQAHCBsABAo=.',['Ð']='Ðark:AwADCAMABAoAAQMAS/cBCAEABRQ=.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end