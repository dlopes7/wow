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
 local lookup = {'Mage-Fire','Unknown-Unknown','DeathKnight-Blood','Priest-Holy','Shaman-Restoration','Hunter-Marksmanship','Hunter-BeastMastery','Warlock-Destruction','Warlock-Affliction','Priest-Discipline','Rogue-Subtlety','Rogue-Assassination','Monk-Windwalker','Shaman-Elemental','Warlock-Demonology','DemonHunter-Havoc','Monk-Mistweaver','Warrior-Arms','Warrior-Fury','DeathKnight-Unholy','Shaman-Enhancement','Paladin-Retribution',}; local provider = {region='US',realm='Frostmourne',name='US',type='subscribers',zone=42,date='2025-04-02',data={Af='Afflictweave:AwEGCAEABAoAAA==.',Ar='Ardrek:AwEFCAIABAoAAA==.Artharrse:AwECCAMABAoAAA==.',Ce='Censorship:AwECCAIABAoAAA==.',Ch='Chickenfingr:AwEGCAYABAoAAA==.',Cr='Craftym:AwEFCA0ABRQCAQAFAQgOAQBOHukBBRQFwQsAAAQAV8ILAAADAF7DCwAAAwBLxAsAAAIAS8ULAAABADkBAAUBCA4BAE4e6QEFFAXBCwAABABXwgsAAAMAXsMLAAADAEvECwAAAgBLxQsAAAEAOQA=.Craftywafty:AwEGCAYABAoAAQEATh4FCA0ABRQ=.',Da='Daketh:AwEFCAwABAoAAA==.',Dr='Dravail:AwEICAgABAoAAQEAIGgCCAYABRQ=.',Dw='Dwakakiwi:AwEICAUABAoAAQIAAAAECAQABRQ=.',Et='Etrodk:AwEECAoABRQCAwAEAQh5AABidMwBBRQEwQsAAAQAYsILAAADAGHDCwAAAgBjxAsAAAEAYwMABAEIeQAAYnTMAQUUBMELAAAEAGLCCwAAAwBhwwsAAAIAY8QLAAABAGMA.',Ha='Hadji:AwECCAYABRQCBAACAQh4BwA8f6oABRQCwQsAAAMAVMILAAADACQEAAIBCHgHADx/qgAFFALBCwAAAwBUwgsAAAMAJAA=.Happyxo:AwEDCAUABRQCBQADAQiQBQBI/xMBBRQDwQsAAAIAScILAAACAF7DCwAAAQAyBQADAQiQBQBI/xMBBRQDwQsAAAIAScILAAACAF7DCwAAAQAyAA==.',He='Helfeign:AwECCAIABRQDBgAIAQhcCgBOXWgCBAoIwQsAAAUAWsILAAAFAF7DCwAABQBWxAsAAAUAW8ULAAAFAFLGCwAABABVxwsAAAMAHsgLAAADAEEGAAgBCFwKAEfRaAIECgjBCwAAAgBawgsAAAIAW8MLAAACAEfECwAAAwBaxQsAAAIARMYLAAACAFXHCwAAAgAeyAsAAAIALgcACAEI8iMAS9xiAgQKCMELAAADAFXCCwAAAwBewwsAAAMAVsQLAAACAFvFCwAAAwBSxgsAAAIASMcLAAABABzICwAAAQBBAA==.',Hu='Hubdula:AwECCAMABRQDCAAIAQigEgBMMG8CBAoIwQsAAAQAX8ILAAAEAEfDCwAABABVxAsAAAQAT8ULAAADAFbGCwAAAwApxwsAAAIAS8gLAAACAEkIAAgBCKASAEwwbwIECgjBCwAABABfwgsAAAQAR8MLAAAEAFXECwAAAwBPxQsAAAMAVsYLAAADACnHCwAAAgBLyAsAAAIASQkAAQEI/jMABoQiAAQKAcQLAAABAAYA.',Ja='Jazí:AwEHCAYABAoAAA==.',Jc='Jce:AwEDCAwABRQCCgADAQi1AgBhU1ABBRQDwQsAAAUAY8ILAAADAGHDCwAABABfCgADAQi1AgBhU1ABBRQDwQsAAAUAY8ILAAADAGHDCwAABABfAA==.',Jo='Jontic:AwEHCBsABAoDCwAHAQjmCgBUQGcCBAoHwQsAAAUAX8ILAAAFAFjDCwAABQBKxAsAAAQAXcULAAADAEfGCwAAAwBXxwsAAAIATgsABwEI5goAVEBnAgQKB8ELAAAFAF/CCwAABQBYwwsAAAUASsQLAAAEAF3FCwAAAwBHxgsAAAIAV8cLAAABAE4MAAIBCJUlADpmlwAECgLGCwAAAQA5xwsAAAEAOwA=.',Ka='Kaelvoker:AwEICAgABAoAAQEAIGgCCAYABRQ=.',Ki='Kimiealya:AwECCAYABRQCAQACAQhnHQAgaFcABRQCwQsAAAQAQMILAAACAAABAAIBCGcdACBoVwAFFALBCwAABABAwgsAAAIAAAA=.',Ku='Kushd:AwEICAQABAoAAQ0AJFIDCAUABRQ=.Kushh:AwECCAIABRQCCwAIAQjBBgBRRL4CBAoIwQsAAAQAYcILAAAEAGPDCwAABABMxAsAAAQATcULAAADAF7GCwAAAgBCxwsAAAIAT8gLAAACADoLAAgBCMEGAFFEvgIECgjBCwAABABhwgsAAAQAY8MLAAAEAEzECwAABABNxQsAAAMAXsYLAAACAELHCwAAAgBPyAsAAAIAOgENACRSAwgFAAUU.',['K�']='Kìnetyk:AwEECAwABRQCDgAEAQh1AQA93E0BBRQEwQsAAAQAXcILAAADAE7DCwAAAwAgxAsAAAIAKw4ABAEIdQEAPdxNAQUUBMELAAAEAF3CCwAAAwBOwwsAAAMAIMQLAAACACsA.',Lo='Loquewl:AwEECAsABRQDCAAEAQjuAwA5GiYBBRQEwQsAAAMAR8ILAAADAFzDCwAAAwAkxAsAAAIAHAgABAEI7gMAMJomAQUUBMELAAACADrCCwAAAQBGwwsAAAMAJMQLAAACABwPAAIBCOQBAFHOuQAFFALBCwAAAQBHwgsAAAIAXAA=.',Ly='Lyke:AwEDCAkABRQDCQADAQiRAwA2Re4ABRQDwQsAAAQAQ8ILAAADAD/DCwAAAgAfCQADAQiRAwA2Re4ABRQDwQsAAAMAQ8ILAAADAD/DCwAAAgAfCAABAQhhGwAtzz8ABRQBwQsAAAEALQA=.Lyked:AwEICAsABAoAAQkANkUDCAkABRQ=.Lykew:AwEGCAgABAoAAQkANkUDCAkABRQ=.',Ma='Madorimage:AwEECA0ABRQCAQAEAQi0BAA60F8BBRQEwQsAAAQAXsILAAAFAFTDCwAAAwAsxAsAAAEACwEABAEItAQAOtBfAQUUBMELAAAEAF7CCwAABQBUwwsAAAMALMQLAAABAAsA.Madorion:AwECCAIABAoAAQEAOtAECA0ABRQ=.Marmaduke:AwEICBUABAoCBQAIAQixAwBVNyADBAoIwQsAAAMAY8ILAAAEAGPDCwAAAwBjxAsAAAQAYcULAAADAGPGCwAAAgBhxwsAAAEAE8gLAAABAEcFAAgBCLEDAFU3IAMECgjBCwAAAwBjwgsAAAQAY8MLAAADAGPECwAABABhxQsAAAMAY8YLAAACAGHHCwAAAQATyAsAAAEARwA=.Maybedh:AwEFCAkABRQCEAAFAQgWAQA3HbkBBRQFwQsAAAIAUcILAAADAELDCwAAAQAKxAsAAAIALsULAAABAEUQAAUBCBYBADcduQEFFAXBCwAAAgBRwgsAAAMAQsMLAAABAArECwAAAgAuxQsAAAEARQA=.Maybedk:AwEGCAYABAoAARAANx0FCAkABRQ=.Maybedr:AwEGCAYABAoAARAANx0FCAkABRQ=.Maybemk:AwEECAIABAoAARAANx0FCAkABRQ=.Maybepl:AwEGCAsABAoAARAANx0FCAkABRQ=.Mayberg:AwECCAMABRQAARAANx0FCAkABRQ=.',Mo='Modern:AwECCAUABRQCEQACAQiMDwAemZEABRQCwQsAAAMAIMILAAACABwRAAIBCIwPAB6ZkQAFFALBCwAAAwAgwgsAAAIAHAA=.',Mu='Mudboil:AwECCAIABRQAARIAXmoFCBAABRQ=.Mudpal:AwEICBIABAoAARIAXmoFCBAABRQ=.Mudpriest:AwEECAEABAoAARIAXmoFCBAABRQ=.Mudwuffstar:AwEFCBAABRQDEgAFAQhFAABeaoMBBRQFwQsAAAQAYMILAAAFAGTDCwAABABUxAsAAAEAW8ULAAACAGQSAAUBCEUAAF5qgwEFFAXBCwAABABgwgsAAAQAZMMLAAACAFTECwAAAQBbxQsAAAIAZBMAAgEIPgoAVp/SAAUUAsILAAABAGHDCwAAAgBLAA==.',Na='Natokni:AwEGCAYABAoAAQoAYVMDCAwABRQ=.',Pa='Parobola:AwEDCAgABRQCBQADAQhpCQBKvcEABRQDwQsAAAUAYcILAAACADzDCwAAAQBCBQADAQhpCQBKvcEABRQDwQsAAAUAYcILAAACADzDCwAAAQBCAA==.',Ra='Ramm:AwEECAwABRQECAAEAQh5AwBZAjEBBRQEwQsAAAQAY8ILAAAEAGPDCwAAAgA/xAsAAAIAXQgAAwEIeQMAVW8xAQUUA8ELAAADAGPDCwAAAQA/xAsAAAEAXQkAAwEIXQoAR8hwAAUUA8ELAAABAF/CCwAABABjwwsAAAEAEw8AAQAIAAAAAlUAAAUUAcQLAAABAAIA.Rammwizard:AwEBCAEABAoAAQgAWQIECAwABRQ=.Razzldazzlee:AwEDCAQABRQCFAAIAQhwDQBOF7MCBAoIwQsAAAQAUcILAAAEAGHDCwAABABNxAsAAAQAN8ULAAAEAGHGCwAABABOxwsAAAMAPsgLAAACAEsUAAgBCHANAE4XswIECgjBCwAABABRwgsAAAQAYcMLAAAEAE3ECwAABAA3xQsAAAQAYcYLAAAEAE7HCwAAAwA+yAsAAAIASwA=.',Ri='Rivaownsyou:AwECCAUABRQCBAACAQiJCgA474gABRQCwQsAAAMARsILAAACACsEAAIBCIkKADjviAAFFALBCwAAAwBGwgsAAAIAKwA=.',Sc='Schlaami:AwEDCAMABAoAAQEAJqQDCAYABRQ=.Schlaammi:AwEDCAYABRQCAQADAQgCEAAmpOAABRQDwQsAAAQAUsILAAABAAnDCwAAAQAXAQADAQgCEAAmpOAABRQDwQsAAAQAUsILAAABAAnDCwAAAQAXAA==.',Se='Seriousnes:AwEECAwABRQCFQAEAQiyAQA/A2cBBRQEwQsAAAUARcILAAAEAE7DCwAAAgAlxAsAAAEAQxUABAEIsgEAPwNnAQUUBMELAAAFAEXCCwAABABOwwsAAAIAJcQLAAABAEMA.',Sh='Shamignords:AwEBCAEABAoAAQgATDACCAMABRQ=.',Ti='Tieprier:AwEHCAwABAoAAA==.',To='Toppfang:AwEDCAUABRQCDgADAQjMBQAYPbsABRQDwQsAAAMAMcILAAABAAXDCwAAAQASDgADAQjMBQAYPbsABRQDwQsAAAMAMcILAAABAAXDCwAAAQASAA==.',Tr='Trippybits:AwEECAkABAoAAQIAAAAGCAcABAo=.Trippynips:AwEGCAcABAoAAA==.',Un='Unholyfans:AwEHCBQABAoCFAAGAQhQDwBhcZsCBAoGwQsAAAQAYcILAAAEAF3DCwAABABfxAsAAAMAY8ULAAADAGPGCwAAAgBjFAAGAQhQDwBhcZsCBAoGwQsAAAQAYcILAAAEAF3DCwAABABfxAsAAAMAY8ULAAADAGPGCwAAAgBjAA==.',Ve='Velessia:AwEGCAwABAoAAA==.',Vi='Vionstal:AwEDCBAABRQCBwADAQgpCgBCZxUBBRQDwQsAAAYAV8ILAAAHAF7DCwAAAwAQBwADAQgpCgBCZxUBBRQDwQsAAAYAV8ILAAAHAF7DCwAAAwAQAA==.',Wa='Wakakyrri:AwEECAQABRQAAA==.',Yi='Yinmaester:AwEHCAIABAoAAA==.',Za='Zaneykings:AwECCAUABRQCFgACAQgCEwBM2q4ABRQCwQsAAAMAUcILAAACAEcWAAIBCAITAEzargAFFALBCwAAAwBRwgsAAAIARwA=.',Zo='Zordaz:AwECCAIABRQCBgAIAQjfCgBC518CBAoIwQsAAAIAQsILAAADAFHDCwAAAwBQxAsAAAMATcULAAADAEDGCwAAAwBQxwsAAAMAVMgLAAABAAAGAAgBCN8KAELnXwIECgjBCwAAAgBCwgsAAAMAUcMLAAADAFDECwAAAwBNxQsAAAMAQMYLAAADAFDHCwAAAwBUyAsAAAEAAAEVAGCdCAgUAAUU.Zorithmar:AwECCAIABRQAARUAYJ0ICBQABRQ=.Zorthar:AwEICBQABRQCFQAIAQgDAABgnUEDBRQIwQsAAAQAWcILAAAEAGPDCwAABABTxAsAAAMAZMULAAACAGTGCwAAAQBkxwsAAAEAZMgLAAABAGQVAAgBCAMAAGCdQQMFFAjBCwAABABZwgsAAAQAY8MLAAAEAFPECwAAAwBkxQsAAAIAZMYLAAABAGTHCwAAAQBkyAsAAAEAZAA=.Zortheaux:AwECCAIABRQAARUAYJ0ICBQABRQ=.Zorthi:AwECCAIABRQAARUAYJ0ICBQABRQ=.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end