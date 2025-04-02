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
 local lookup = {'Hunter-BeastMastery','Paladin-Retribution','Monk-Mistweaver','Unknown-Unknown','Priest-Holy','Monk-Windwalker','Priest-Discipline','Priest-Shadow','Warlock-Destruction','Hunter-Marksmanship','Hunter-Survival','Shaman-Restoration','DeathKnight-Unholy','Druid-Restoration','Rogue-Subtlety','Rogue-Outlaw','Druid-Feral',}; local provider = {region='US',realm='MoonGuard',name='US',type='subscribers',zone=42,date='2025-04-02',data={As='Asheyri:AwEDCAgABRQCAQADAQi4BgBd8D4BBRQDwQsAAAMAXsILAAADAF7DCwAAAgBbAQADAQi4BgBd8D4BBRQDwQsAAAMAXsILAAADAF7DCwAAAgBbAA==.',Bu='Bunnypuppy:AwEDCAYABRQCAgADAQhUDwApFdUABRQDwQsAAAMAMcILAAACAAbDCwAAAQBDAgADAQhUDwApFdUABRQDwQsAAAMAMcILAAACAAbDCwAAAQBDAA==.',Co='Cobolmoon:AwEBCAEABRQAAA==.',Cu='Cuddlebear:AwEFCBMABAoAAA==.',['C�']='Cÿlest:AwEDCAUABRQCAwADAQgdCwAJFL0ABRQDwQsAAAIADMILAAACAAjDCwAAAQAFAwADAQgdCwAJFL0ABRQDwQsAAAIADMILAAACAAjDCwAAAQAFAA==.',Do='Dold:AwEHCAoABAoAAQQAAAABCAEABRQ=.',Ee='Eepykìtty:AwEBCAEABRQAAQUATqgDCAQABRQ=.',Ga='Galilari:AwECCAIABRQCBgAIAQi3BwBO5eECBAoIwQsAAAQAW8ILAAAEAFzDCwAABABZxAsAAAMAW8ULAAADAFvGCwAAAwBHxwsAAAIAQ8gLAAADACMGAAgBCLcHAE7l4QIECgjBCwAABABbwgsAAAQAXMMLAAAEAFnECwAAAwBbxQsAAAMAW8YLAAADAEfHCwAAAgBDyAsAAAMAIwA=.',Ha='Hasapas:AwEDCAQABRQEBQAIAQhtCQBOqKACBAoIwQsAAAYAUsILAAAGAGPDCwAABgBRxAsAAAUAWMULAAAFAGHGCwAABABQxwsAAAMAKsgLAAACADkFAAgBCG0JAEwaoAIECgjBCwAABABSwgsAAAMAY8MLAAADAFHECwAAAgBUxQsAAAIAYcYLAAACAFDHCwAAAQAayAsAAAIAOQcABwEIGRQAQdbxAQQKB8ELAAACAFDCCwAAAgBLwwsAAAMAQ8QLAAACAFjFCwAAAwBUxgsAAAIAFscLAAABACoIAAMBCOIrAEwqHQEECgPCCwAAAQBgxAsAAAEAY8cLAAABACAA.',Ho='Holykìtty:AwEDCAUABAoAAQUATqgDCAQABRQ=.',Jo='Joeccult:AwEDCAYABRQCCQADAQgWCAAuwt4ABRQDwQsAAAMAP8ILAAACAB/DCwAAAQAsCQADAQgWCAAuwt4ABRQDwQsAAAMAP8ILAAACAB/DCwAAAQAsAA==.Joerrior:AwEBCAEABAoAAQkALsIDCAYABRQ=.',Ka='Kadoshaphat:AwEBCAEABAoAAQQAAAADCAQABAo=.',Ki='Kirkh:AwEBCAMABRQEAQAIAQg7FgBcXMICBAoIwQsAAAcAYsILAAAGAF/DCwAABQBexAsAAAUAYsULAAAHAFfGCwAABABRxwsAAAEAUsgLAAADAGMBAAcBCDsWAFv0wgIECgfBCwAAAwBbwgsAAAIAX8MLAAABAFvECwAABABixQsAAAIAV8YLAAABAE/ICwAAAgBjCgAHAQjlDQBELCsCBAoHwQsAAAQAYsILAAAEAF7DCwAABABexAsAAAEAB8ULAAAFAFbGCwAAAwBRyAsAAAEADgsAAQEIchEAUv9kAAQKAccLAAABAFIBCABHbgIIBAAFFA==.Kirkpriest:AwECCAQABRQDCAAIAQiSDQBHbnwCBAoIwQsAAAYAUMILAAAHAFnDCwAABgBQxAsAAAMAQMULAAADAFLGCwAABABMxwsAAAQANsgLAAAEACoIAAgBCJINAEdufAIECgjBCwAABgBQwgsAAAcAWcMLAAAGAFDECwAAAwBAxQsAAAMAUsYLAAAEAEzHCwAABAA2yAsAAAMAKgcAAQEINGQACZAlAAQKAcgLAAABAAkA.Kirkvoker:AwEGCAsABAoAAQgAR24CCAQABRQ=.',Kn='Knackeredh:AwEFCAgABAoAAA==.',La='Larissaqt:AwECCAMABAoAAA==.',Le='Lexiilock:AwEDCAQABAoAAQQAAAABCAEABRQ=.',Lo='Lostpuppy:AwEGCAEABAoAAQIAKRUDCAYABRQ=.',Ma='Mathathh:AwEICAgABAoAAA==.',Ni='Nilina:AwEGCAEABAoAAA==.',Ny='Nyfaria:AwEECAQABAoAAQwALs8HCBsABAo=.',Of='Offthatzoot:AwECCAIABRQCDQAIAQgUDQBRiLgCBAoIwQsAAAUAW8ILAAAFAFvDCwAABQBVxAsAAAUATcULAAAEAGDGCwAABABQxwsAAAIANMgLAAACAE4NAAgBCBQNAFGIuAIECgjBCwAABQBbwgsAAAUAW8MLAAAFAFXECwAABQBNxQsAAAQAYMYLAAAEAFDHCwAAAgA0yAsAAAIATgA=.',Qr='Qrowbot:AwEBCAEABRQAAA==.Qrowdruid:AwEHCBoABAoCDgAHAQjUCQBR/IYCBAoHwQsAAAQAUcILAAAGAGDDCwAABQBhxAsAAAQAWsULAAADAFPGCwAAAgA/xwsAAAIAPA4ABwEI1AkAUfyGAgQKB8ELAAAEAFHCCwAABgBgwwsAAAUAYcQLAAAEAFrFCwAAAwBTxgsAAAIAP8cLAAACADwBBAAAAAEIAQAFFA==.Qrowfather:AwEDCAMABAoAAQQAAAABCAEABRQ=.Qrowhunter:AwEBCAEABAoAAQQAAAABCAEABRQ=.',Re='Reingeist:AwEDCAYABRQCDQADAQiKBQA7ggMBBRQDwQsAAAMATsILAAACACPDCwAAAQA/DQADAQiKBQA7ggMBBRQDwQsAAAMATsILAAACACPDCwAAAQA/AA==.',Se='Serynytee:AwEFCA0ABAoAAA==.',Sn='Snugglepawsx:AwEECA0ABRQDDwAEAQg0AQBOi4QBBRQEwQsAAAUAX8ILAAAEAEzDCwAAAwBNxAsAAAEAQA8ABAEINAEATouEAQUUBMELAAAEAF/CCwAABABMwwsAAAMATcQLAAABAEAQAAEBCKQDACEsMwAFFAHBCwAAAQAhAA==.',Us='Usurah:AwECCAQABRQCAgAIAQigDABYYR8DBAoIwQsAAAUAY8ILAAAFAGHDCwAABgBixAsAAAQAVMULAAAEAF/GCwAABABYxwsAAAQAOcgLAAADAFQCAAgBCKAMAFhhHwMECgjBCwAABQBjwgsAAAUAYcMLAAAGAGLECwAABABUxQsAAAQAX8YLAAAEAFjHCwAABAA5yAsAAAMAVAA=.',Vi='Vindk:AwEICAIABAoAAREAQ+wECAUABRQ=.Vindruid:AwEECAUABRQCEQAIAQj4BABD7IYCBAoIwQsAAAMAJsILAAADAFXDCwAAAwBAxAsAAAMAPsULAAADAFjGCwAAAwBAxwsAAAMAXMgLAAACAC8RAAgBCPgEAEPshgIECgjBCwAAAwAmwgsAAAMAVcMLAAADAEDECwAAAwA+xQsAAAMAWMYLAAADAEDHCwAAAwBcyAsAAAIALwA=.Vinsham:AwEICAwABAoAAREAQ+wECAUABRQ=.',Zo='Zootiiez:AwECCAUABAoAAQUATqgDCAQABRQ=.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end