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
 local lookup = {'Unknown-Unknown','Monk-Windwalker','Hunter-BeastMastery','Hunter-Marksmanship',}; local provider = {region='US',realm='TheScryers',name='US',type='weekly',zone=42,date='2025-03-28',data={Al='Alainea:AwAECAgABAoAAA==.',Am='Amershaman:AwADCAQABAoAAA==.',As='Asylum:AwAFCAoABAoAAA==.',Au='Aura:AwAFCAkABAoAAA==.',Ba='Balerion:AwADCAUABAoAAA==.',Be='Beatnik:AwADCAQABAoAAA==.',Bl='Blitzen:AwAGCBEABAoAAA==.',['BÃ']='BÃ¼rd:AwAGCAoABAoAAA==.',Ca='Caylor:AwACCAIABAoAAA==.',Ch='Choleena:AwADCAUABAoAAA==.',Co='Combat:AwABCAIABAoAAQEAAAACCAIABAo=.Combatk:AwACCAIABAoAAA==.',Da='Dangerwithin:AwAECAkABRQCAgAEAQi5AABUf5QBBRQAAgAEAQi5AABUf5QBBRQAAA==.',De='Deebz:AwADCAUABAoAAA==.',Du='Dunkin:AwACCAIABAoAAQEAAAAGCBEABAo=.',Fu='Furbees:AwACCAMABAoAAA==.',Gi='Gigz:AwAGCAUABAoAAA==.',Gr='Grandeeney:AwAECAgABAoAAA==.',He='Hemmuc:AwABCAEABAoAAQEAAAAGCBEABAo=.',Jo='Jordon:AwAECAYABAoAAA==.Joyride:AwADCAUABAoAAA==.',Ju='Juiceboxx:AwAFCAUABAoAAA==.Jujuvoodoo:AwADCAUABAoAAA==.',Ke='Kelldoar:AwAICAsABAoAAA==.',Ki='Kilmister:AwAECAUABAoAAA==.',Ku='Kungfoodoo:AwAICAcABAoAAA==.',Ky='Kyl:AwADCAQABAoAAA==.',Lu='Lucyford:AwADCAMABAoAAA==.',Ly='Lysolwipe:AwADCAcABAoAAA==.',['LÃ']='LÃ¤dypÃ«tra:AwADCAMABAoAAA==.',Mi='Miniruuter:AwACCAIABAoAAA==.Miniz:AwADCAMABAoAAA==.Misirlou:AwACCAIABAoAAQEAAAAGCBEABAo=.',Ni='Nihz:AwABCAEABAoAAA==.',Ny='Nyxes:AwADCAgABAoAAA==.',Pe='Peacan:AwADCAYABAoAAA==.Perseffonee:AwADCAYABAoAAA==.',Po='Popes:AwAICBUABAoDAwAIAQg0MgAitNABBAoAAwAIAQg0MgAitNABBAoABAADAQizNQAODVkABAoAAA==.',Re='Revolt:AwADCAUABAoAAA==.',Ro='Roflimgay:AwAICBAABAoAAA==.',Ru='Ruuter:AwAECAIABAoAAA==.',Sh='Shaydon:AwADCAMABAoAAA==.',Sl='Slopoke:AwAECAYABAoAAA==.',Sp='Spiinks:AwABCAEABAoAAA==.',Te='Teldryn:AwAECAYABAoAAA==.',Tr='Trilldt:AwAICAEABAoAAA==.Trilliam:AwAICAYABAoAAA==.',We='Welis:AwACCAQABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end