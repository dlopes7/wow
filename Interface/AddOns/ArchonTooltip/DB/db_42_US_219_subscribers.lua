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
 local lookup = {'Rogue-Assassination','Paladin-Protection','Paladin-Retribution','Unknown-Unknown','Priest-Discipline','Warrior-Protection','Priest-Holy','Druid-Balance','Evoker-Preservation','DeathKnight-Frost','DeathKnight-Unholy','Druid-Restoration','DemonHunter-Vengeance','DemonHunter-Havoc','Shaman-Elemental','Rogue-Outlaw','Warrior-Fury','Warrior-Arms','Monk-Windwalker','Shaman-Restoration','Shaman-Enhancement','Mage-Fire','Mage-Frost','Monk-Mistweaver','Hunter-BeastMastery','Warlock-Affliction','Warlock-Destruction','Priest-Shadow','Warlock-Demonology','Hunter-Marksmanship',}; local provider = {region='US',realm='Thrall',name='US',type='subscribers',zone=42,date='2025-04-02',data={Ap='Apexvancleef:AwECCAYABRQCAQACAQgJBQBMTK0ABRQCwQsAAAMAU8ILAAADAEQBAAIBCAkFAExMrQAFFALBCwAAAwBTwgsAAAMARAA=.Apollyonus:AwEBCAEABRQDAgAIAQhADAA63AcCBAoIwQsAAAUAVcILAAAFAFjDCwAAAwBHxAsAAAMAK8ULAAACAC7GCwAAAgA5xwsAAAEAF8gLAAABADQCAAgBCEAMADrcBwIECgjBCwAABABVwgsAAAQAWMMLAAADAEfECwAAAwArxQsAAAIALsYLAAACADnHCwAAAQAXyAsAAAEANAMAAgEI9OMAS5d9AAQKAsELAAABAFLCCwAAAQBEAA==.',Bb='Bblblake:AwEDCAQABRQAAA==.',Be='Belgarath:AwECCAMABAoAAQQAAAAICAgABAo=.',Bl='Bluekek:AwEECAoABRQCBQAEAQgTAQBbCZMBBRQEwQsAAAQAXcILAAADAFrDCwAAAQBfxAsAAAIAVAUABAEIEwEAWwmTAQUUBMELAAAEAF3CCwAAAwBawwsAAAEAX8QLAAACAFQA.Blueloop:AwEGCAYABAoAAQUAWwkECAoABRQ=.',Bo='Bobbyz:AwEHCBkABAoCBgAHAQh1BABQHX8CBAoHwQsAAAUAYsILAAAFAF/DCwAABABNxAsAAAMAQcULAAADAFTGCwAAAwBQxwsAAAIAOgYABwEIdQQAUB1/AgQKB8ELAAAFAGLCCwAABQBfwwsAAAQATcQLAAADAEHFCwAAAwBUxgsAAAMAUMcLAAACADoA.',Br='Bruhdean:AwEGCA8ABAoAAQQAAAAGCBMABAo=.',Bv='Bva:AwEDCAcABRQCBwADAQj6AABiQ1oBBRQDwQsAAAQAY8ILAAACAGPDCwAAAQBgBwADAQj6AABiQ1oBBRQDwQsAAAQAY8ILAAACAGPDCwAAAQBgAA==.',Ce='Cenarii:AwECCAYABRQCCAACAQiBDQBNSLUABRQCwQsAAAQATcILAAACAE0IAAIBCIENAE1ItQAFFALBCwAABABNwgsAAAIATQA=.Cenmage:AwEBCAEABAoAAQgATUgCCAYABRQ=.Censhaman:AwEBCAEABAoAAQgATUgCCAYABRQ=.',Ch='Chakasbabaka:AwEHCBUABAoDAwAHAQg1PgBAFBcCBAoHwQsAAAQATsILAAAEAE/DCwAABABYxAsAAAMAKMULAAACAEnGCwAAAgAsxwsAAAIALAMABwEINT4AQBQXAgQKB8ELAAAEAE7CCwAABABPwwsAAAIAWMQLAAADACjFCwAAAgBJxgsAAAIALMcLAAABACwCAAIBCFc8ABOBRgAECgLDCwAAAgAFxwsAAAEAIQA=.',Co='Coffecat:AwEHCAEABAoAAA==.',Da='Datnotamoose:AwEBCAEABRQCCQAHAQgUAgBcLecCBAoHwQsAAAUAYMILAAAFAF7DCwAABABjxAsAAAQAYcULAAADAGDGCwAAAwBQxwsAAAIATwkABwEIFAIAXC3nAgQKB8ELAAAFAGDCCwAABQBewwsAAAQAY8QLAAAEAGHFCwAAAwBgxgsAAAMAUMcLAAACAE8A.',De='Deathcen:AwEECAgABRQDCgAEAQgSAABg8ckBBRQEwQsAAAMAY8ILAAACAGHDCwAAAgBdxAsAAAEAYAoABAEIEgAAYPHJAQUUBMELAAACAGPCCwAAAgBhwwsAAAIAXcQLAAABAGALAAEBCOoQAGEATQAFFAHBCwAAAQBhAA==.Defiants:AwEGCBAABAoAAQQAAAAICAgABAo=.',Do='Doc:AwEICAcABAoAAQwAQgwDCAcABRQ=.',Dr='Drastenn:AwEBCAEABAoAAQcAQjAECAwABRQ=.Drastin:AwEECAwABRQCBwAEAQgTAQBCMFUBBRQEwQsAAAUATMILAAADAFnDCwAAAwALxAsAAAEAVwcABAEIEwEAQjBVAQUUBMELAAAFAEzCCwAAAwBZwwsAAAMAC8QLAAABAFcA.Drastnin:AwECCAIABAoAAQcAQjAECAwABRQ=.Drastx:AwEICBIABAoAAQcAQjAECAwABRQ=.',Ed='Edgyann:AwEDCAUABRQDDQADAQi1AgA6zNoABRQDwQsAAAIAOcILAAACADzDCwAAAQA6DQADAQi1AgA6zNoABRQDwQsAAAEAOcILAAACADzDCwAAAQA6DgABAQgTHQAZbkQABRQBwQsAAAEAGQA=.',El='Electricrat:AwEDCAoABRQCDwADAQg0AQBiQFgBBRQDwQsAAAQAY8ILAAADAGLDCwAAAwBgDwADAQg0AQBiQFgBBRQDwQsAAAQAY8ILAAADAGLDCwAAAwBgAA==.',Fe='Felsrogue:AwEBCAEABRQCEAAIAQjpAwAy7QoCBAoIwQsAAAQAYMILAAAEAFbDCwAABABPxAsAAAMAGcULAAADAC3GCwAAAgAZxwsAAAEAE8gLAAACABwQAAgBCOkDADLtCgIECgjBCwAABABgwgsAAAQAVsMLAAAEAE/ECwAAAwAZxQsAAAMALcYLAAACABnHCwAAAQATyAsAAAIAHAEEAAAAAQgBAAUU.Felthedruid:AwEBCAEABRQAAA==.',Ga='Galginoth:AwEFCA8ABRQDEQAFAQgwAABPgBkCBRQFwQsAAAUAY8ILAAAEAGHDCwAAAgBYxAsAAAMARsULAAABACgRAAUBCDAAAE+AGQIFFAXBCwAAAwBjwgsAAAMAYcMLAAACAFjECwAAAwBGxQsAAAEAKBIAAgEI+gUAPRqcAAUUAsELAAACAFbCCwAAAQAjAA==.',Gn='Gnashes:AwEDCAgABRQCAwADAQjDCQBS0SUBBRQDwQsAAAQAXsILAAACAE/DCwAAAgBJAwADAQjDCQBS0SUBBRQDwQsAAAQAXsILAAACAE/DCwAAAgBJAA==.Gnashpal:AwEFCBAABAoAAQMAUtEDCAgABRQ=.',Gr='Greenwolves:AwEBCAEABRQCEwAIAQifBABXfh8DBAoIwQsAAAUAXcILAAAFAFrDCwAABQBZxAsAAAQAW8ULAAAEAGDGCwAABABaxwsAAAMAUMgLAAABAEITAAgBCJ8EAFd+HwMECgjBCwAABQBdwgsAAAUAWsMLAAAFAFnECwAABABbxQsAAAQAYMYLAAAEAFrHCwAAAwBQyAsAAAEAQgA=.',Ho='Holyhotter:AwEFCAgABAoAAQUAWnQDCAkABRQ=.Holystain:AwEDCAkABRQCBQADAQiOAwBadDkBBRQDwQsAAAQAW8ILAAADAFnDCwAAAgBaBQADAQiOAwBadDkBBRQDwQsAAAQAW8ILAAADAFnDCwAAAgBaAA==.',Im='Implicitly:AwEDCAQABRQDFAAIAQjsAABhq2EDBAoIwQsAAAMAY8ILAAAEAGLDCwAAAwBhxAsAAAMAY8ULAAAFAGPGCwAABABjxwsAAAMAXsgLAAACAF0UAAgBCOwAAGGrYQMECgjBCwAAAgBjwgsAAAMAYsMLAAACAGHECwAAAwBjxQsAAAUAY8YLAAAEAGPHCwAAAwBeyAsAAAIAXRUAAwEI1TMARq/cAAQKA8ELAAABAFbCCwAAAQBIwwsAAAEANAA=.Imprudence:AwECCAMABAoAARQAYasDCAQABRQ=.Impure:AwEECAQABAoAARQAYasDCAQABRQ=.',Is='Iskraa:AwECCAIABAoAAA==.',Ja='Ja:AwEICAcABAoAAQwAQgwDCAcABRQ=.',Ka='Ka:AwEDCAcABRQDDAADAQhBBwBCDKgABRQDwQsAAAQAUMILAAACACHDCwAAAQBTDAACAQhBBwA5MqgABRQCwQsAAAQAUMILAAACACEIAAEBCEEaAAoNSAAFFAHDCwAAAQAKAA==.Kaigwynn:AwEBCAIABRQDFgAIAQjyHQBBnUMCBAoIwQsAAAQAUcILAAAEAEjDCwAABABNxAsAAAQAVMULAAADAFHGCwAABAAzxwsAAAMAIcgLAAACACkWAAgBCPIdAD2kQwIECgjBCwAAAwBRwgsAAAMASMMLAAADAE3ECwAAAwBExQsAAAMAUcYLAAACACTHCwAAAwAhyAsAAAIAKRcABQEIqToAPe0tAQQKBcELAAABADXCCwAAAQBHwwsAAAEAL8QLAAABAFTGCwAAAgAzAA==.',Ki='Kichenorpain:AwEFCAwABAoAARgANKUDCAYABRQ=.Kichenorpalm:AwEDCAYABRQCGAADAQhTCAA0pfQABRQDwQsAAAIAPcILAAACADbDCwAAAgApGAADAQhTCAA0pfQABRQDwQsAAAIAPcILAAACADbDCwAAAgApAA==.',Kr='Kryonyx:AwEBCAIABRQAAA==.',La='Lahri:AwEBCAIABRQCGQAIAQiAAQBhq4EDBAoIwQsAAAYAYcILAAAGAGPDCwAABQBixAsAAAUAYsULAAAFAGLGCwAAAwBcxwsAAAIAYMgLAAACAGMZAAgBCIABAGGrgQMECgjBCwAABgBhwgsAAAYAY8MLAAAFAGLECwAABQBixQsAAAUAYsYLAAADAFzHCwAAAgBgyAsAAAIAYwA=.Lazlishu:AwEHCA8ABAoAAA==.',Ly='Lyfa:AwECCAMABRQCEQACAQh6EQAI/YEABRQCwgsAAAIAEcMLAAABAAARAAIBCHoRAAj9gQAFFALCCwAAAgARwwsAAAEAAAEEAAAAAwgEAAUU.',['L�']='Líanhua:AwEGCBAABAoAAA==.',Ma='Mapleserp:AwEECAYABAoAAQQAAAAFCAgABAo=.',Me='Meatier:AwEFCAoABAoAAA==.',Mi='Missbubbles:AwEFCAQABAoAAA==.',Mu='Muffinfaery:AwEDCAgABRQCBQADAQjSBQA23/8ABRQDwQsAAAQAYMILAAADADLDCwAAAQARBQADAQjSBQA23/8ABRQDwQsAAAQAYMILAAADADLDCwAAAQARAA==.',Na='Nakahunt:AwEDCAcABRQCGQADAQi1CQBJ8xsBBRQDwQsAAAMAX8ILAAACAEvDCwAAAgAzGQADAQi1CQBJ8xsBBRQDwQsAAAMAX8ILAAACAEvDCwAAAgAzAA==.Nakkydaddy:AwEECAkABAoAAQQAAAABCAEABRQ=.Narcoleptik:AwEDCAQABAoAARkAXrcICBsABAo=.Naturemagic:AwEECAQABAoAAQcAFL8ECAoABRQ=.',No='Noslurs:AwEDCAcABRQCCAADAQjoCABGmAkBBRQDwQsAAAMARMILAAACADjDCwAAAgBWCAADAQjoCABGmAkBBRQDwQsAAAMARMILAAACADjDCwAAAgBWAA==.',Ol='Olddean:AwEGCBMABAoAAA==.',Pa='Palacen:AwEFCAUABAoAAQoAYPEECAgABRQ=.',Ph='Phaizdk:AwECCAMABRQCCgACAQjAAgAleZYABRQCwQsAAAIAN8ILAAABABMKAAIBCMACACV5lgAFFALBCwAAAgA3wgsAAAEAEwA=.Phaizx:AwEHCA4ABAoAAQoAJXkCCAMABRQ=.',Pr='Prayermagic:AwEECAoABRQDBwAEAQgLAwAUvxEBBRQEwQsAAAUAIMILAAADABnDCwAAAQAWxAsAAAEAAgcABAEICwMAFL8RAQUUBMELAAAEACDCCwAAAgAZwwsAAAEAFsQLAAABAAIFAAIBCA4RAA3XRwAFFALBCwAAAQAbwgsAAAEAAAA=.',Ri='Richards:AwEDCAcABRQDGgADAQg5AgBYLBMBBRQDwQsAAAMAX8ILAAACAE7DCwAAAgBaGwADAQjzBABMqhQBBRQDwQsAAAIAT8ILAAABADvDCwAAAQBaGgADAQg5AgBVjxMBBRQDwQsAAAEAX8ILAAABAE7DCwAAAQBSAA==.',['R�']='Ràgé:AwEICBcABAoCDgAIAQipAgBe/WcDBAoIwQsAAAMAXMILAAAEAGLDCwAAAwBixAsAAAMAYcULAAADAFzGCwAAAwBfxwsAAAMAX8gLAAABAFkOAAgBCKkCAF79ZwMECgjBCwAAAwBcwgsAAAQAYsMLAAADAGLECwAAAwBhxQsAAAMAXMYLAAADAF/HCwAAAwBfyAsAAAEAWQA=.Räiju:AwEBCAEABRQCFQAHAQj4EwBA+CQCBAoHwQsAAAQAYsILAAAEAEPDCwAABAA+xAsAAAIAMMULAAACAEnGCwAAAgAnxwsAAAIAQBUABwEI+BMAQPgkAgQKB8ELAAAEAGLCCwAABABDwwsAAAQAPsQLAAACADDFCwAAAgBJxgsAAAIAJ8cLAAACAEAA.',Se='Serlynth:AwEICCAABAoCHAAIAQiSEAA4uE4CBAoIwQsAAAUAUMILAAAFAFDDCwAABQA0xAsAAAUAM8ULAAAEAD/GCwAAAwA1xwsAAAMAGsgLAAACAC0cAAgBCJIQADi4TgIECgjBCwAABQBQwgsAAAUAUMMLAAAFADTECwAABQAzxQsAAAQAP8YLAAADADXHCwAAAwAayAsAAAIALQA=.',Sh='Shamblers:AwEFCAUABAoAARgATWYBCAEABRQ=.',Sk='Skellyann:AwEFCAYABAoAAQ0AOswDCAUABRQ=.',St='Stisprime:AwEICBsABAoCGQAHAQgdDgBetwEDBAoHwQsAAAUAY8ILAAAFAGPDCwAABQBjxAsAAAQAU8ULAAADAGLGCwAAAwBaxwsAAAIAXRkABwEIHQ4AXrcBAwQKB8ELAAAFAGPCCwAABQBjwwsAAAUAY8QLAAAEAFPFCwAAAwBixgsAAAMAWscLAAACAF0A.Stisso:AwEECAQABAoAARkAXrcICBsABAo=.Strazamagic:AwEDCAMABAoAAQcAFL8ECAoABRQ=.',['S�']='Sätansdemon:AwEECAYABAoAAQQAAAAFCAUABAo=.',Te='Tedsawyer:AwEICAgABAoAAA==.',Ti='Tianpo:AwEICAgABAoAAA==.',To='Tonitrus:AwEGCAcABAoAAQQAAAAICAgABAo=.Toxík:AwEHCA0ABAoAAA==.',Un='Unole:AwEDCAEABAoAAA==.',Va='Vanhealn:AwEICAsABAoAAA==.Vaskie:AwEICAgABAoAAA==.',Vi='Vivaldii:AwEFCAQABAoAAQcAQjAECAwABRQ=.Viveusp:AwEGCBcABAoCAwAGAQjoMABb7UoCBAoGwQsAAAUAYcILAAAFAGLDCwAABQBhxAsAAAUAY8ULAAACAFXGCwAAAQBIAwAGAQjoMABb7UoCBAoGwQsAAAUAYcILAAAFAGLDCwAABQBhxAsAAAUAY8ULAAACAFXGCwAAAQBIAA==.',Vr='Vris:AwEFCAwABAoAAA==.',Vy='Vyedma:AwEBCAIABRQEGgAIAQicEAA4uiMBBAoIwQsAAAQAUcILAAAEAFXDCwAAAgBCxAsAAAMAFcULAAADAErGCwAAAwAkxwsAAAIAPsgLAAABABkbAAYBCMg2ACygbgEECgbBCwAAAQA8wgsAAAQAVcQLAAABABXFCwAAAQAkxgsAAAIAGMcLAAABACYaAAQBCJwQAD12IwEECgTBCwAAAwBRwwsAAAIAQsYLAAABACTHCwAAAQA+HQADAQgaLAAk/bwABAoDxAsAAAIACsULAAACAErICwAAAQAZAA==.',Xe='Xeehunna:AwECCAMABRQDGQAIAQjvBQBd50oDBAoIwQsAAAUAY8ILAAAFAGPDCwAAAwBWxAsAAAQASsULAAAFAGPGCwAAAwBixwsAAAIAYMgLAAACAGEZAAgBCO8FAF3nSgMECgjBCwAAAwBjwgsAAAMAY8MLAAACAFbECwAAAwBKxQsAAAQAY8YLAAADAGLHCwAAAgBgyAsAAAIAYR4ABQEIaycASBIKAQQKBcELAAACAE/CCwAAAgBTwwsAAAEATsQLAAABAB7FCwAAAQBXAA==.',Xl='Xlb:AwEGCAYABAoAAA==.',Za='Zalanox:AwEECAoABRQCGAAEAQgPBQAkQTQBBRQEwQsAAAQAOMILAAADABvDCwAAAgAcxAsAAAEAIRgABAEIDwUAJEE0AQUUBMELAAAEADjCCwAAAwAbwwsAAAIAHMQLAAABACEA.',Zh='Zhenni:AwEGCAkABAoAAA==.',Zu='Zugsecute:AwEDCAgABRQCEQADAQi1BwA/JBQBBRQDwQsAAAQATsILAAACAC/DCwAAAgA/EQADAQi1BwA/JBQBBRQDwQsAAAQATsILAAACAC/DCwAAAgA/AA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end