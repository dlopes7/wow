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
 local lookup = {'Warrior-Fury','Warrior-Arms','Shaman-Enhancement',}; local provider = {region='US',realm='Lightninghoof',name='US',type='weekly',zone=42,date='2025-03-29',data={Ae='Aenstalash:AwAGCA8ABAoAAA==.',Am='Amanna:AwAHCA8ABAoAAA==.',An='Anesthia:AwADCAIABAoAAA==.Antwon:AwADCAMABAoAAA==.',Ar='Arthraz:AwAECAgABAoAAA==.',Be='Bethina:AwABCAEABRQAAA==.',Bl='Bloodlustplz:AwAGCAMABAoAAA==.',Br='Brewwnor:AwADCAMABAoAAA==.',['BÃ']='BÃ©rt:AwAICA8ABAoAAA==.',Ca='Carnage:AwADCAMABAoAAA==.',Cr='Creamyshart:AwAGCBIABAoAAA==.',['CÃ']='CÃ£rloy:AwABCAEABRQDAQAHAQioIwAxKbUBBAoAAQAHAQioIwAptbUBBAoAAgAFAQh7HQAvskABBAoAAA==.',Da='Darthknull:AwACCAIABAoAAA==.',De='Deatthdecay:AwAICBAABAoAAA==.',Di='Disshammy:AwABCAIABRQCAwAIAQjlCABMxboCBAoAAwAIAQjlCABMxboCBAoAAA==.',Do='Donkform:AwAGCAYABAoAAA==.Donniyii:AwABCAEABAoAAA==.',Dy='Dysenteryy:AwAICAgABAoAAA==.',Em='Empoleon:AwAHCBMABAoAAA==.',Fe='Fe:AwAGCAYABAoAAA==.',Fr='Frofrohunter:AwAGCAwABAoAAA==.Frofrolock:AwACCAMABAoAAA==.',Gh='Ghost:AwAGCA8ABAoAAA==.',Gl='Glissa:AwAGCBAABAoAAA==.',Ha='Hadory:AwADCAUABAoAAA==.',Ho='Holycannoli:AwADCAEABAoAAA==.Horiffic:AwADCAUABAoAAA==.',Hu='Huberdale:AwADCAkABAoAAA==.',In='Inflation:AwAICBMABAoAAA==.',Ka='Kalena:AwAFCAgABAoAAA==.',Ky='Kylara:AwABCAEABAoAAA==.',Lu='Lucifur:AwADCAYABAoAAA==.',Ma='Magnass:AwAICBAABAoAAA==.Mawks:AwAGCAsABAoAAA==.',Mc='Mcstukes:AwACCAIABAoAAA==.',Mo='Moothreil:AwAECAkABAoAAA==.',Ny='Nymara:AwADCAYABAoAAA==.',Sa='Sammidormu:AwADCAUABAoAAA==.Savvy:AwAICAYABAoAAA==.',Se='Sedelis:AwADCAQABAoAAA==.',So='Sobar:AwADCAMABAoAAA==.',Sw='Swenior:AwABCAEABAoAAA==.',Ti='Tickletackle:AwAGCAMABAoAAA==.',Ub='Ubiquitous:AwADCAYABAoAAA==.',Ve='Vemal:AwAGCAMABAoAAA==.',Wh='Whoppin:AwADCAQABAoAAA==.',Xa='Xalzi:AwADCAUABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end