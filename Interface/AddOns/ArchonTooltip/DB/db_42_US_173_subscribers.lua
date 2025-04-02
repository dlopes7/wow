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
 local lookup = {'Hunter-BeastMastery','Monk-Brewmaster','Unknown-Unknown','Mage-Fire','Warlock-Destruction','Warlock-Demonology','Warlock-Affliction','Priest-Shadow','Priest-Holy','Paladin-Retribution','Paladin-Holy','Priest-Discipline','Druid-Balance','DemonHunter-Havoc','Druid-Feral','Druid-Restoration','Warrior-Arms','Warrior-Fury','Warrior-Protection','Rogue-Outlaw','Monk-Mistweaver','Monk-Windwalker','Hunter-Survival','Hunter-Marksmanship',}; local provider = {region='US',realm='Proudmoore',name='US',type='subscribers',zone=42,date='2025-04-02',data={Al='Alaskannatif:AwEBCAMABRQCAQAIAQjTAwBc9mADBAoIwQsAAAUAXsILAAAFAGDDCwAABQBgxAsAAAQAYsULAAAFAGDGCwAABABhxwsAAAQAU8gLAAACAE8BAAgBCNMDAFz2YAMECgjBCwAABQBewgsAAAUAYMMLAAAFAGDECwAABABixQsAAAUAYMYLAAAEAGHHCwAABABTyAsAAAIATwA=.Allethel:AwEECAIABAoAAA==.Allthatjazz:AwEDCAwABRQCAgADAQgwAQBMOAkBBRQDwQsAAAUAS8ILAAAEAEDDCwAAAwBYAgADAQgwAQBMOAkBBRQDwQsAAAUAS8ILAAAEAEDDCwAAAwBYAA==.Altercations:AwEGCAYABAoAAQMAAAAICAgABAo=.',Ap='Apsmage:AwEECAcABRQCBAAEAQjwAwA/tm0BBRQEwQsAAAIAR8ILAAACAGHDCwAAAgAvxAsAAAEAJgQABAEI8AMAP7ZtAQUUBMELAAACAEfCCwAAAgBhwwsAAAIAL8QLAAABACYA.',Be='Benivolent:AwEFCAsABAoAAQMAAAAGCAYABAo=.',Bu='Bussybolt:AwECCAEABRQEBQAIAQgnKgBRsrsBBAoIwQsAAAQAYMILAAAEAFTDCwAABABgxAsAAAQAY8ULAAAEAFrGCwAAAwBbxwsAAAIATsgLAAABABEFAAUBCCcqAFdduwEECgXBCwAAAQBWwgsAAAQAVMMLAAAEAGDGCwAAAwBbxwsAAAIATgYAAwEIDRkAX1o9AQQKA8ELAAADAGDECwAABABjxQsAAAMAWgcAAgEItSEAJJh6AAQKAsULAAABADjICwAAAQARAA==.',Ca='Caamm:AwEDCAQABRQCCAAIAQhkAABh+4oDBAoIwQsAAAMAY8ILAAAEAGHDCwAABABjxAsAAAMAY8ULAAADAGPGCwAAAwBfxwsAAAMAY8gLAAADAF0IAAgBCGQAAGH7igMECgjBCwAAAwBjwgsAAAQAYcMLAAAEAGPECwAAAwBjxQsAAAMAY8YLAAADAF/HCwAAAwBjyAsAAAMAXQA=.Carynna:AwEHCA0ABAoAAQkAUuAECAoABRQ=.',Ch='Chaklet:AwEICAgABAoAAA==.',Co='Coralirodeth:AwEDCAoABRQCCAADAQiCBwAudegABRQDwQsAAAYAO8ILAAACACbDCwAAAgApCAADAQiCBwAudegABRQDwQsAAAYAO8ILAAACACbDCwAAAgApAA==.',Cu='Curre:AwEICBQABAoDCgAIAQh+WABGEr0BBAoIwQsAAAIAW8ILAAACAFbDCwAAAgBSxAsAAAIAG8ULAAADAFHGCwAAAwA+xwsAAAQAIMgLAAACAF8KAAcBCH5YAEJtvQEECgfBCwAAAgBbwgsAAAIAVsMLAAACAFLECwAAAgAbxQsAAAMAUcYLAAADAD7HCwAABAAgCwABAQiwNQAs3UMABAoByAsAAAIALAEIAFObCAgsAAQK.Curroblin:AwEICCwABAoDCAAIAQh+BwBTm+ICBAoIwQsAAAQAY8ILAAAIAF3DCwAACABaxAsAAAYAVMULAAAJAGPGCwAABABexwsAAAMAScgLAAACACEIAAcBCH4HAFrE4gIECgfBCwAAAwBjwgsAAAYAXcMLAAAIAFrECwAABQBUxQsAAAcAY8YLAAADAF7HCwAAAQBJDAAHAQjqCwBLpWECBAoHwQsAAAEAX8ILAAACAF/ECwAAAQBCxQsAAAIAFcYLAAABAE/HCwAAAgBPyAsAAAIAWwA=.',De='Decobolt:AwEDCAYABAoAAA==.Deprecated:AwEFCAoABAoAAQcAQZgECA4ABRQ=.',Du='Duçk:AwEBCAEABAoAAQMAAAAFCAoABAo=.',Ec='Ecksblaster:AwEDCAUABRQCBAADAQjIDQAr8PsABRQDwQsAAAIAW8ILAAABABTDCwAAAgATBAADAQjIDQAr8PsABRQDwQsAAAIAW8ILAAABABTDCwAAAgATAQ0AVcgFCBMABRQ=.Ecksreaper:AwEBCAEABRQAAQ0AVcgFCBMABRQ=.Ecksripper:AwEFCBMABRQCDQAFAQg9AABVyA4CBRQFwQsAAAUAYMILAAAEAGPDCwAABABJxAsAAAQAV8ULAAACAEcNAAUBCD0AAFXIDgIFFAXBCwAABQBgwgsAAAQAY8MLAAAEAEnECwAABABXxQsAAAIARwA=.Eckszapper:AwEFCAUABAoAAQ0AVcgFCBMABRQ=.',Eg='Eggzntoast:AwEECAkABRQCDgAEAQhQAQBbWqUBBRQEwQsAAAMAYcILAAACAGHDCwAAAwBWxAsAAAEAVA4ABAEIUAEAW1qlAQUUBMELAAADAGHCCwAAAgBhwwsAAAMAVsQLAAABAFQA.',El='Elisí:AwEBCAEABAoAAQgAUbIHCBsABAo=.',Fr='Fridayoclock:AwEBCAEABRQCDQAIAQjIDgBJ6LkCBAoIwQsAAAUAR8ILAAAFAEnDCwAABQBNxAsAAAgAR8ULAAAFAFDGCwAACABRxwsAAAMASsgLAAADADwNAAgBCMgOAEnouQIECgjBCwAABQBHwgsAAAUAScMLAAAFAE3ECwAACABHxQsAAAUAUMYLAAAIAFHHCwAAAwBKyAsAAAMAPAA=.',Gh='Gharcyndr:AwEICAgABAoAAA==.',Gl='Glowleaf:AwECCAMABRQDDwAIAQhCDABDxJUBBAoIwQsAAAQAY8ILAAAEABbDCwAABABbxAsAAAQAU8ULAAAEAFvGCwAAAwAOxwsAAAIAMsgLAAACAFcPAAYBCEIMAENLlQEECgbBCwAABABjwgsAAAIAFsMLAAACAFvECwAAAgBTxQsAAAIAW8YLAAABAA4QAAcBCB4hACw+gAEECgfCCwAAAgA/wwsAAAIAJ8QLAAACABHFCwAAAgAwxgsAAAIAL8cLAAACACrICwAAAgAyAA==.',Gu='Gunnther:AwEICAgABAoAAQMAAAAICAgABAo=.',Ic='Icewîng:AwEDCAwABRQDEQADAQiWAgBLrNAABRQDwQsAAAUAX8ILAAAEAEvDCwAAAwA4EgADAQhFCAA+xQsBBRQDwQsAAAIAQcILAAABAELDCwAAAwA4EQACAQiWAgBVGtAABRQCwQsAAAMAX8ILAAADAEsA.',Jo='Jombola:AwEGCAwABAoAAQwAUhwDCAwABRQ=.',Ka='Kalavazar:AwEHCA0ABAoAAQEAU4UECAwABRQ=.Kalazar:AwEECAwABRQCAQAEAQiMAQBThaYBBRQEwQsAAAQAY8ILAAAEAGPDCwAAAwBhxAsAAAEAJQEABAEIjAEAU4WmAQUUBMELAAAEAGPCCwAABABjwwsAAAMAYcQLAAABACUA.Karurael:AwEICCMABAoCAQAIAQhVIwA6O2YCBAoIwQsAAAYAW8ILAAAGAFTDCwAABgBBxAsAAAUAN8ULAAAFAB/GCwAAAwA2xwsAAAIAIsgLAAACAC8BAAgBCFUjADo7ZgIECgjBCwAABgBbwgsAAAYAVMMLAAAGAEHECwAABQA3xQsAAAUAH8YLAAADADbHCwAAAgAiyAsAAAIALwA=.Kaykó:AwEHCBsABAoECAAHAQhdDABRspECBAoHwQsAAAUAVMILAAAFAFfDCwAABQBWxAsAAAQAPsULAAADAGDGCwAAAwBTxwsAAAIARggABwEIXQwAUbKRAgQKB8ELAAACAFTCCwAAAgBXwwsAAAIAVsQLAAACAD7FCwAAAgBgxgsAAAEAU8cLAAABAEYMAAYBCOwhADNjZQEECgbBCwAAAwBBwgsAAAMAQsMLAAADAEDECwAAAgA9xgsAAAIAIMcLAAABABEJAAEBCO9iAEqGUAAECgHFCwAAAQBKAA==.',Ke='Kelsiedh:AwEDCAMABAoAAREAWvIBCAEABRQ=.Kelsiesham:AwEFCAgABAoAAREAWvIBCAEABRQ=.Kelsietism:AwEBCAEABRQEEQAIAQh7BQBa8tMCBAoIwQsAAAYAY8ILAAAJAF/DCwAABgBfxAsAAAcAY8ULAAAEAFzGCwAABQBRxwsAAAMAVcgLAAACAE8RAAcBCHsFAFvX0wIECgfBCwAABABjwgsAAAUAX8MLAAAEAF/ECwAABQBjxQsAAAMAXMYLAAACAEvHCwAAAgBVEgAIAQhQDgBVEKYCBAoIwQsAAAEAXsILAAADAF/DCwAAAgBbxAsAAAIAU8ULAAABAFvGCwAAAwBRxwsAAAEAQMgLAAACAE8TAAIBCHgdAETUngAECgLBCwAAAQBIwgsAAAEAQQA=.',['K�']='Káyko:AwEECAQABAoAAQgAUbIHCBsABAo=.',La='Larissaqt:AwEGCAgABAoAAA==.',Li='Liquidsalt:AwEHCA8ABAoAAQcAURQDCAwABRQ=.Liquorcat:AwEBCAEABRQAAQcAURQDCAwABRQ=.',Lu='Lunamäe:AwEGCAkABAoAAA==.',Ly='Lynkalla:AwEGCAMABAoAAA==.',Me='Meddah:AwEGCAwABAoAAA==.',Mo='Monkhon:AwEGCA8ABAoAAA==.',My='Mythraku:AwEDCAcABRQCCQADAQhhAwA8kwYBBRQDwQsAAAUAU8ILAAABAE7DCwAAAQAUCQADAQhhAwA8kwYBBRQDwQsAAAUAU8ILAAABAE7DCwAAAQAUAA==.',['N�']='Nørrin:AwEECAkABRQCFAAEAQgqAABAB2gBBRQEwQsAAAYAYMILAAABAFHDCwAAAQAfxAsAAAEALxQABAEIKgAAQAdoAQUUBMELAAAGAGDCCwAAAQBRwwsAAAEAH8QLAAABAC8A.',Om='Omgtotem:AwEECAgABAoAAA==.Omnivicent:AwEGCAYABAoAAA==.',Oz='Ozzyshaman:AwEFCAEABAoAAA==.',Pe='Peetee:AwEDCAUABAoAAQMAAAAICAUABAo=.',Po='Poazfk:AwEICAUABAoAAA==.Pocketadin:AwECCAIABRQAAA==.Powergoblin:AwEECAwABRQCFQAEAQhxAQBaYZABBRQEwQsAAAUAXMILAAADAF7DCwAAAwBVxAsAAAEAWRUABAEIcQEAWmGQAQUUBMELAAAFAFzCCwAAAwBewwsAAAMAVcQLAAABAFkA.',Re='Rejuju:AwEHCAcABAoAAQMAAAAICAgABAo=.',Sh='Shamhon:AwECCAIABAoAAQMAAAAGCA8ABAo=.Shelannigans:AwEECAoABRQCCQAEAQi7AABS4G0BBRQEwQsAAAIAUsILAAAEAFnDCwAAAwBUxAsAAAEASwkABAEIuwAAUuBtAQUUBMELAAACAFLCCwAABABZwwsAAAMAVMQLAAABAEsA.Shizukaze:AwEHCBkABAoEFgAHAQguEQBDTkgCBAoHwQsAAAUAXMILAAAFAEXDCwAABQBExAsAAAQAUsULAAADAFHGCwAAAgAoxwsAAAEAIxYABwEILhEAQ05IAgQKB8ELAAADAFzCCwAAAwBFwwsAAAQARMQLAAADAFLFCwAAAgBRxgsAAAIAKMcLAAABACMCAAUBCIwPADofBgEECgXBCwAAAQA2wgsAAAEAQsMLAAABAC3ECwAAAQA0xQsAAAEARhUAAgEIfVUAQeWWAAQKAsELAAABADbCCwAAAQBNAA==.',St='Stéphie:AwEFCAgABAoAAQgAUbIHCBsABAo=.',Sy='Sylyphe:AwEDCAMABAoAAA==.',Ti='Tierán:AwEHCBsABAoEAQAHAQimGwBac5sCBAoHwQsAAAUAYsILAAAFAGLDCwAABQBhxAsAAAQAYsULAAAEAFjGCwAAAgBCxwsAAAIAVgEABwEIphsAWiObAgQKB8ELAAACAGLCCwAAAgBiwwsAAAEAXsQLAAABAGLFCwAAAQBYxgsAAAIAQscLAAABAFYXAAYBCNADAFQuEAIECgbBCwAAAgBhwgsAAAIAYMMLAAADAFbECwAAAgBhxQsAAAIAUscLAAABACwYAAUBCA4bAEgShwEECgXBCwAAAQBgwgsAAAEAUsMLAAABAGHECwAAAQBRxQsAAAEAAwA=.',To='Tocopherol:AwEDCAMABRQDAgAIAQgbBABKGmYCBAoIwQsAAAMAUMILAAACAE/DCwAAAwA+xAsAAAMAP8ULAAAEAFnGCwAAAwBPxwsAAAMARcgLAAACAEQCAAgBCBsEAEoaZgIECgjBCwAAAwBQwgsAAAIAT8MLAAADAD7ECwAAAwA/xQsAAAMAWcYLAAACAE/HCwAAAwBFyAsAAAIARBYAAgEIN08AH6RTAAQKAsULAAABAD3GCwAAAQACAA==.',Tr='Tremens:AwEDCAwABRQDBwADAQirAQBRFCcBBRQDwQsAAAUAY8ILAAAEAF3DCwAAAwAyBwADAQirAQBOJycBBRQDwQsAAAIAWsILAAAEAF3DCwAAAwAyBgABAQjGAwBjpnEABRQBwQsAAAMAYwA=.',['T�']='Tóva:AwEECAkABAoAAA==.',Za='Zayvointh:AwECCAQABAoAAQgALnUDCAoABRQ=.',['Ð']='Ðùçk:AwEFCAoABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end