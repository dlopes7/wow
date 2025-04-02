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
 local lookup = {'Priest-Discipline','Druid-Restoration','Druid-Feral','Unknown-Unknown',}; local provider = {region='US',realm='SilverHand',name='US',type='weekly',zone=42,date='2025-03-28',data={Ae='Aerdan:AwACCAIABAoAAA==.',Af='Afridium:AwADCAUABAoAAA==.',Ar='Archibolt:AwAICAgABAoAAA==.',Ay='Ayzmyth:AwADCAQABAoAAA==.',Ba='Babbs:AwAGCAkABAoAAA==.',Bi='Birdman:AwAGCAgABAoAAA==.',Bl='Blatendrg:AwAECAUABAoAAA==.',Ca='Cairdragh:AwADCAMABAoAAA==.',Ch='Chiot:AwADCAYABAoAAA==.',Cl='Cleat:AwADCAIABAoAAA==.',Co='Cottonpandy:AwACCAIABAoAAA==.Cowcow:AwACCAIABAoAAA==.',Cr='Crizzo:AwAECAcABAoAAA==.',Da='Dalfuran:AwAGCA0ABAoAAA==.Darkwingorc:AwABCAEABRQAAA==.',De='Deliverance:AwAHCBkABAoCAQAHAQh8GAAslYsBBAoAAQAHAQh8GAAslYsBBAoAAA==.',Dn='Dnegelpal:AwAGCA4ABAoAAA==.',Dr='Drunkndonuts:AwADCAQABAoAAA==.',Du='Durward:AwACCAMABAoAAA==.',Ea='Easyname:AwABCAEABRQAAA==.',El='Elemental:AwACCAIABAoAAQIANskCCAYABRQ=.',Ep='Epica:AwAFCAIABAoAAA==.',Er='Eragonhawk:AwACCAQABAoAAA==.Erovianoria:AwAECAYABAoAAA==.',Es='Essun:AwAGCBAABAoAAA==.',Fa='Fauxpas:AwAFCAoABAoAAA==.',Fu='Furina:AwAGCBAABAoAAA==.',Ga='Gabrael:AwAHCAwABAoAAA==.',Ge='Geloe:AwACCAQABAoAAA==.',Gh='Ghostcat:AwAHCA0ABAoAAA==.',Go='Gongsway:AwABCAEABRQAAA==.',Gr='Greatergood:AwAGCAIABAoAAA==.',Ha='Hazelnuts:AwACCAIABAoAAA==.',['HÃ']='HÃ­rra:AwAFCA8ABAoAAA==.',If='Ifryz:AwAFCAsABAoAAA==.',Ja='Jadynara:AwAHCAUABAoAAA==.',Ji='Jimmydin:AwAHCAwABAoAAA==.',Ju='Junhoong:AwAFCA0ABAoAAA==.',Ka='Katesluage:AwADCAMABAoAAA==.',Ke='Kernasas:AwAECAEABAoAAA==.Kezan:AwAECAQABAoAAA==.',La='Lastword:AwADCAUABAoAAA==.Laur:AwAHCAwABAoAAA==.',Lu='Lus:AwAGCAIABAoAAA==.',Me='Meztlitotol:AwAFCA0ABAoAAA==.',Mo='Modannix:AwAGCAsABAoAAA==.Moisticklez:AwAICAgABAoAAA==.',Ne='Nechahira:AwACCAYABRQDAgACAQj9BQA2yZUABRQAAgACAQj9BQA2yZUABRQAAwABAQiyAwAU80wABRQAAA==.Nensho:AwAGCAwABAoAAA==.',Ov='Overheal:AwAICAgABAoAAA==.',Ph='Phaze:AwAGCA4ABAoAAA==.Phia:AwAHCBIABAoAAA==.',Pu='Puncheon:AwAFCAwABAoAAQIANskCCAYABRQ=.',Ra='Rascdit:AwADCAQABAoAAA==.',Rh='Rhemiel:AwACCAIABAoAAA==.',Ri='Ribbo:AwADCAQABAoAAA==.',Sh='Shaim:AwAHCAwABAoAAA==.Shirito:AwAGCA4ABAoAAA==.Shirogitsu:AwAECAYABAoAAA==.',Si='Sigma:AwABCAEABAoAAA==.Sindannie:AwACCAEABAoAAA==.',Sk='Skornne:AwADCAgABAoAAA==.',Sl='Slipnstick:AwAGCAsABAoAAA==.',So='Solemn:AwADCAYABAoAAA==.Soulbled:AwAFCAUABAoAAA==.',['SÃ']='SÃ³ta:AwAECAkABAoAAQQAAAABCAEABRQ=.',Th='Therm:AwACCAIABAoAAA==.',Va='Vareyn:AwAECAEABAoAAA==.',Vo='Vonon:AwABCAEABRQAAA==.',Wh='Wholesale:AwAGCA4ABAoAAA==.',Ya='Yagiashi:AwABCAIABAoAAA==.',Zi='Zillver:AwAGCA0ABAoAAA==.',['ZÃ']='ZÃ¨lda:AwAFCAoABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end