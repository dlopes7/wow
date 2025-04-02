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
 local lookup = {'Paladin-Holy','Evoker-Preservation','DemonHunter-Vengeance','DemonHunter-Havoc','Unknown-Unknown','Priest-Shadow','Priest-Discipline','Paladin-Retribution','Mage-Arcane','Mage-Fire','Warlock-Demonology','Warlock-Affliction','Warlock-Destruction','Monk-Windwalker','Monk-Brewmaster','Warrior-Protection','Priest-Holy','Shaman-Restoration','Shaman-Elemental',}; local provider = {region='US',realm='BleedingHollow',name='US',type='subscribers',zone=42,date='2025-04-02',data={Ad='Addex:AwEDCAgABRQCAQADAQh/AgBStxABBRQDwQsAAAMAWcILAAADAE3ECwAAAgBQAQADAQh/AgBStxABBRQDwQsAAAMAWcILAAADAE3ECwAAAgBQAQIANMMECAQABRQ=.',Am='Ambient:AwEECAQABRQCAgAIAQgGBwA0wxkCBAoIwQsAAAQASsILAAAEAEfDCwAABAAoxAsAAAQARcULAAAEADTGCwAAAwBExwsAAAIAIsgLAAABAAoCAAgBCAYHADTDGQIECgjBCwAABABKwgsAAAQAR8MLAAAEACjECwAABABFxQsAAAQANMYLAAADAETHCwAAAgAiyAsAAAEACgA=.',At='Atrika:AwEDCAUABRQDAwADAQhaAQBSshwBBRQDwQsAAAIAUsILAAACAErDCwAAAQBaAwADAQhaAQBQ2xwBBRQDwQsAAAEATcILAAABAErDCwAAAQBaBAACAQiKDgBMkrIABRQCwQsAAAEAUsILAAABAEYA.',Bi='Bilbro:AwECCAEABAoAAQUAAAAGCAIABAo=.',Bu='Burnyburner:AwECCAIABAoAAQYAKQ8DCAoABRQ=.',Ca='Cark:AwEBCAEABAoAAA==.',Cy='Cywen:AwEDCAoABRQCBgADAQi2BwApD+MABRQDwQsAAAIANcILAAAEAB7DCwAABAAnBgADAQi2BwApD+MABRQDwQsAAAIANcILAAAEAB7DCwAABAAnAA==.',De='DelacoÃ»r:AwEFCAoABAoAAQcAQaQDCAYABRQ=.Dentmerl:AwEDCAYABRQCCAADAQgjBABjjGEBBRQDwQsAAAIAYsILAAACAGPDCwAAAgBjCAADAQgjBABjjGEBBRQDwQsAAAIAYsILAAACAGPDCwAAAgBjAA==.',Di='Divinenine:AwECCAMABRQCBwAIAQjWGQAkJrIBBAoIwQsAAAMAEsILAAADADjDCwAABAAwxAsAAAMAEcULAAAEAEXGCwAAAgAjxwsAAAIAE8gLAAABABYHAAgBCNYZACQmsgEECgjBCwAAAwASwgsAAAMAOMMLAAAEADDECwAAAwARxQsAAAQARcYLAAACACPHCwAAAgATyAsAAAEAFgA=.',Dw='Dwarfwarloc:AwEECAIABAoAAA==.',['DÃ']='DÃ«lacour:AwEDCAYABRQCBwADAQi+BgBBpOcABRQDwQsAAAIAUMILAAABAErDCwAAAwAqBwADAQi+BgBBpOcABRQDwQsAAAIAUMILAAABAErDCwAAAwAqAA==.',El='Elewizrdgang:AwEICAwABAoAAQkAXQICCAMABRQ=.',Ha='Hakgek:AwEICAcABAoAAQMAW/ACCAIABRQ=.Halosdh:AwEBCAEABRQAAQkAXQICCAMABRQ=.Halosmage:AwECCAMABRQDCQAIAQhJAABdAkYDBAoIwQsAAAUAWsILAAAFAF/DCwAABQBhxAsAAAUAYMULAAAFAF/GCwAABABWxwsAAAMAWsgLAAACAFwJAAgBCEkAAF0CRgMECgjBCwAABABawgsAAAQAX8MLAAAEAGHECwAAAwBgxQsAAAQAX8YLAAACAFbHCwAAAwBayAsAAAIAXAoABgEIKTEAQgivAQQKBsELAAABAD/CCwAAAQAPwwsAAAEAU8QLAAACAEfFCwAAAQBPxgsAAAIAUgA=.',In='Initiative:AwEGCAIABAoAAA==.',['KÃ']='KÃ¯ddo:AwEICBAABAoAAA==.',Ma='Magegage:AwEGCAcABAoAAA==.Magolli:AwEBCAEABRQCCAAIAQgGFQBRgOMCBAoIwQsAAAUAVcILAAAFAF3DCwAABQBWxAsAAAQAXMULAAAEAFLGCwAAAwBTxwsAAAIAR8gLAAABADcIAAgBCAYVAFGA4wIECgjBCwAABQBVwgsAAAUAXcMLAAAFAFbECwAABABcxQsAAAQAUsYLAAADAFPHCwAAAgBHyAsAAAEANwA=.',Mi='Minidubss:AwEHCAwABAoAAQsAQ5ADCAsABRQ=.Minigun:AwEICBAABAoAAA==.Minipala:AwEICBQABAoCCAAIAQh/JABEFYYCBAoIwQsAAAMAV8ILAAADAE3DCwAAAwBMxAsAAAMAQ8ULAAACAE/GCwAAAgA7xwsAAAIAJMgLAAACADwIAAgBCH8kAEQVhgIECgjBCwAAAwBXwgsAAAMATcMLAAADAEzECwAAAwBDxQsAAAIAT8YLAAACADvHCwAAAgAkyAsAAAIAPAELAEOQAwgLAAUU.Miniss:AwEDCAsABRQECwADAQjWAQBDkLsABRQDwQsAAAYAUMILAAADAFDDCwAAAgAqDAADAQgTBAAwyN0ABRQDwQsAAAEANsILAAADAFDDCwAAAQALCwACAQjWAQA9SLsABRQCwQsAAAMAUMMLAAABACoNAAEBCIgdACs0OQAFFAHBCwAAAgArAA==.Misakasama:AwEFCAUABAoAAQMARDUDCAgABRQ=.',Mo='Moosclemommy:AwEICBsABAoCDgAIAQiKDABEpI4CBAoIwQsAAAUATsILAAAFAFrDCwAABgBRxAsAAAMAVsULAAAEAErGCwAAAgAzxwsAAAEAK8gLAAABACkOAAgBCIoMAESkjgIECgjBCwAABQBOwgsAAAUAWsMLAAAGAFHECwAAAwBWxQsAAAQASsYLAAACADPHCwAAAQAryAsAAAEAKQEGACkPAwgKAAUU.',Mu='MurrÃ°n:AwEHCAsABAoAAQUAAAAICBAABAo=.',Ni='Niinetails:AwEHCAEABAoAAQcAJCYCCAMABRQ=.Nindina:AwEICA0ABAoAAQ8ATC4DCAgABRQ=.Nindorina:AwEDCAgABRQCDwADAQg1AQBMLgcBBRQDwQsAAAUAWcILAAACADrDCwAAAQBRDwADAQg1AQBMLgcBBRQDwQsAAAUAWcILAAACADrDCwAAAQBRAA==.',No='Novelus:AwECCAIABRQCEAAIAQjrAQBWVP8CBAoIwQsAAAUAYMILAAAFAF7DCwAABABfxAsAAAQAYMULAAAEAFPGCwAAAgBWxwsAAAIAOcgLAAAEAFAQAAgBCOsBAFZU/wIECgjBCwAABQBgwgsAAAUAXsMLAAAEAF/ECwAABABgxQsAAAQAU8YLAAACAFbHCwAAAgA5yAsAAAQAUAA=.Novicar:AwEFCAIABAoAARAAVlQCCAIABRQ=.',['PÃ']='PÃ¨te:AwEFCBAABRQDBwAFAQi0AQBPJHcBBRQFwQsAAAQAWsILAAADAFbDCwAABABWxAsAAAMATcULAAACADYHAAQBCLQBAE01dwEFFATBCwAABABawgsAAAMAVsQLAAADAE3FCwAAAgA2EQABAQiJDQBW32IABRQBwwsAAAQAVgA=.',Ra='Ramsama:AwEDCAgABRQCAwADAQj5AQBENfwABRQDwQsAAAMAVsILAAADAEPDCwAAAgAyAwADAQj5AQBENfwABRQDwQsAAAMAVsILAAADAEPDCwAAAgAyAA==.',Re='Recursively:AwEECA4ABRQEDAAEAQgcAgBBmBYBBRQEwQsAAAQAWcILAAAEAFfDCwAABAAxxAsAAAIAIwwAAwEIHAIAS7kWAQUUA8ELAAADAFnCCwAABABXwwsAAAMAMQ0AAgEIHBAAHgiEAAUUAsELAAABACrDCwAAAQARCwABAQhCBwAjNFUABRQBxAsAAAIAIwA=.',Sh='Shamanpete:AwEBCAEABRQCEgAIAQiDFwBAAS4CBAoIwQsAAAMAUsILAAADAEvDCwAAAwBPxAsAAAMAO8ULAAADAFvGCwAABABGxwsAAAQAEcgLAAACACMSAAgBCIMXAEABLgIECgjBCwAAAwBSwgsAAAMAS8MLAAADAE/ECwAAAwA7xQsAAAMAW8YLAAAEAEbHCwAABAARyAsAAAIAIwEHAE8kBQgQAAUU.Sharrq:AwEBCAEABRQCCgAHAQifFgBOfoICBAoHwQsAAAUAWMILAAAFAFbDCwAABQBJxAsAAAQARMULAAAEAFjGCwAAAwBQxwsAAAIAQAoABwEInxYATn6CAgQKB8ELAAAFAFjCCwAABQBWwwsAAAUAScQLAAAEAETFCwAABABYxgsAAAMAUMcLAAACAEAA.',Th='Thanala:AwEDCAkABRQCAQADAQiWAgBKygwBBRQDwQsAAAQAWsILAAADAFrDCwAAAgAqAQADAQiWAgBKygwBBRQDwQsAAAQAWsILAAADAFrDCwAAAgAqAA==.Thejigglr:AwEDCAgABRQCEwADAQh7AwBEsQsBBRQDwQsAAAQAUsILAAACAEHDCwAAAgA6EwADAQh7AwBEsQsBBRQDwQsAAAQAUsILAAACAEHDCwAAAgA6AA==.',Tt='Ttattoo:AwEFCAwABAoAAA==.',Ye='Yevo:AwEECAwABRQCEQAEAQiDAABSUoQBBRQEwQsAAAQAY8ILAAAEAFDDCwAAAwBHxAsAAAEATREABAEIgwAAUlKEAQUUBMELAAAEAGPCCwAABABQwwsAAAMAR8QLAAABAE0A.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end