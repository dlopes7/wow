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
 local lookup = {'Monk-Windwalker','Rogue-Assassination','Rogue-Outlaw','Rogue-Subtlety','Monk-Mistweaver','Shaman-Restoration','Evoker-Augmentation','Evoker-Devastation','Priest-Discipline','Priest-Shadow','Unknown-Unknown','Shaman-Enhancement','Warrior-Fury','Priest-Holy',}; local provider = {region='US',realm='Dalaran',name='US',type='subscribers',zone=42,date='2025-04-02',data={Ad='Adansso:AwEGCA8ABAoAAA==.',Ar='Arlee:AwEDCAYABAoAAA==.',Be='Belynila:AwEBCAIABRQAAA==.',Bl='Blesman:AwEFCA0ABAoAAA==.',Da='Dadbanger:AwEFCBEABRQCAQAFAQhKAABaKxICBRQFwQsAAAIAXcILAAAFAF/DCwAABABixAsAAAMAScULAAADAFoBAAUBCEoAAForEgIFFAXBCwAAAgBdwgsAAAUAX8MLAAAEAGLECwAAAwBJxQsAAAMAWgA=.',De='Dellastel:AwEDCAMABAoAAA==.',Gl='Glizzygary:AwEGCBQABAoCAQAGAQjhEwBQICMCBAoGwQsAAAUAWMILAAAFAFXDCwAAAwBGxAsAAAMAV8ULAAADAFDGCwAAAQBEAQAGAQjhEwBQICMCBAoGwQsAAAUAWMILAAAFAFXDCwAAAwBGxAsAAAMAV8ULAAADAFDGCwAAAQBEAA==.',Ha='Haf:AwEGCAEABAoAAA==.',Ka='Kaydencé:AwEGCBIABAoAAA==.',Ki='Kitsufae:AwEBCAIABAoAAQIAR48ICB8ABAo=.Kitsù:AwEICB8ABAoEAgAIAQgmCABHj3gCBAoIwQsAAAYAX8ILAAAFAGDDCwAABQBQxAsAAAUAWsULAAAEAGLGCwAABABFxwsAAAEADMgLAAABABwCAAcBCCYIAE28eAIECgfBCwAABABfwgsAAAMAYMMLAAACAFDECwAAAwBaxQsAAAEAYsYLAAADAEXHCwAAAQAMAwAGAQj/BgApJlYBBAoGwQsAAAEAQMILAAABAA3DCwAAAQA2xAsAAAEAKMULAAABAC7ICwAAAQAcBAAGAQgKHAAqOz8BBAoGwQsAAAEAPsILAAABABXDCwAAAgBBxAsAAAEANcULAAACAC/GCwAAAQABAA==.',Ko='Kodypog:AwEBCAEABRQAAA==.',Ku='Kungfused:AwEBCAIABRQCBQAHAQhYDQBRLYwCBAoHwQsAAAkAYsILAAAHAF/DCwAACABdxAsAAAUAYMULAAAEAELGCwAAAwBOxwsAAAIAJwUABwEIWA0AUS2MAgQKB8ELAAAJAGLCCwAABwBfwwsAAAgAXcQLAAAFAGDFCwAABABCxgsAAAMATscLAAACACcA.',Le='Leroguejames:AwEFCBUABAoDAgAFAQibFABK1XkBBAoFwQsAAAYAWMILAAAGAFXDCwAABABNxAsAAAMAUcULAAACACgCAAQBCJsUAFNpeQEECgTBCwAAAwBYwgsAAAIAVcMLAAABAE3ECwAAAQBRBAAFAQj8GgA9pk4BBAoFwQsAAAMARMILAAAEAE7DCwAAAwBAxAsAAAIAOMULAAACACgA.',Mo='Mookind:AwEECAkABAoAAA==.',Ph='Phoenixaura:AwEGCAkABAoAAQYANJcDCAgABRQ=.Phoenixshock:AwEDCAgABRQCBgADAQi3BgA0l/cABRQDwQsAAAMAKcILAAAEAFXDCwAAAQAeBgADAQi3BgA0l/cABRQDwQsAAAMAKcILAAAEAFXDCwAAAQAeAA==.',Ry='Rytiouevoker:AwECCAQABRQDBwAIAQi1AABAo0QCBAoIwQsAAAMAYsILAAAEAFTDCwAABABPxAsAAAMAUMULAAAEABvGCwAAAwAaxwsAAAMALsgLAAACAEkHAAgBCLUAAEAjRAIECgjBCwAAAwBiwgsAAAMAVMMLAAADAE/ECwAAAwBQxQsAAAMAG8YLAAACABbHCwAAAgAuyAsAAAEASQgABgEIrCEAG/kzAQQKBsILAAABADTDCwAAAQAPxQsAAAEADcYLAAABABrHCwAAAQAtyAsAAAEADgA=.',Sa='Saadxevok:AwEFCAYABAoAAQkAVOMFCBQABRQ=.Saadxm:AwEICBMABAoAAQkAVOMFCBQABRQ=.Saadxp:AwEFCBQABRQDCQAFAQiPAQBU43sBBRQFwQsAAAUAVsILAAAFAFPDCwAABABTxAsAAAMAR8ULAAADAGIJAAQBCI8BAFUlewEFFATBCwAABABWwgsAAAUAU8QLAAADAEfFCwAAAwBiCgACAQiKCABXNc8ABRQCwQsAAAEAWsMLAAAEAFMA.',['S�']='Sçår:AwEGCAIABAoAAA==.',Ta='Tayvok:AwEECAMABAoAAQsAAAABCAEABRQ=.',Tu='Tulkryne:AwECCAYABRQDDAAIAQgNCABPStYCBAoIwQsAAAUAXMILAAAEAGDDCwAABABZxAsAAAQAUMULAAAEAF7GCwAAAwAxxwsAAAMAWMgLAAADACoMAAgBCA0IAE9K1gIECgjBCwAABQBcwgsAAAQAYMMLAAAEAFnECwAABABQxQsAAAQAXsYLAAADADHHCwAAAwBYyAsAAAEAKgYAAQEIjXcAUsRfAAQKAcgLAAACAFIA.',Wa='Warriornebra:AwEHCBYABAoCDQAHAQiAEgBHlnYCBAoHwQsAAAUAV8ILAAAFAFrDCwAABABLxAsAAAMAV8ULAAACAFXGCwAAAgBBxwsAAAEACQ0ABwEIgBIAR5Z2AgQKB8ELAAAFAFfCCwAABQBawwsAAAQAS8QLAAADAFfFCwAAAgBVxgsAAAIAQccLAAABAAkA.',Ze='Zertzz:AwEGCA4ABAoCCAAGAQh3GQBHTpkBBAoGwQsAAAIAYsILAAACAFHDCwAAAwBQxAsAAAMASMULAAADAEDGCwAAAQAeCAAGAQh3GQBHTpkBBAoGwQsAAAIAYsILAAACAFHDCwAAAwBQxAsAAAMASMULAAADAEDGCwAAAQAeAQoAP/cDCAcABRQ=.',Zz='Zzert:AwEDCAcABRQCCgADAQj8BQA/9wQBBRQDwQsAAAMAUsILAAACACLDCwAAAgBLCgADAQj8BQA/9wQBBRQDwQsAAAMAUsILAAACACLDCwAAAgBLAA==.Zzertz:AwECCAUABRQDCgACAQi7CwA2b5IABRQCwQsAAAMAMMILAAACADwKAAIBCLsLADZvkgAFFALBCwAAAwAwwgsAAAEAPA4AAQEIixYAAO8qAAUUAcILAAABAAABCgA/9wMIBwAFFA==.Zzerz:AwECCAMABRQDCgAIAQh1AgBdZEkDBAoIwQsAAAUAYcILAAAEAGHDCwAABABhxAsAAAMAVsULAAAEAGHGCwAABABZxwsAAAUAXMgLAAACAFoKAAgBCHUCAF1kSQMECgjBCwAABABhwgsAAAMAYcMLAAAEAGHECwAAAwBWxQsAAAQAYcYLAAAEAFnHCwAABQBcyAsAAAIAWg4AAgEIZ2EALuxWAAQKAsELAAABAC/CCwAAAQAuAQoAP/cDCAcABRQ=.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end