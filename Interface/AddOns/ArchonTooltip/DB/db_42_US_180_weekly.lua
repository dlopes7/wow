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
 local lookup = {'Paladin-Retribution','Shaman-Enhancement','Hunter-Marksmanship','DemonHunter-Havoc','Hunter-BeastMastery','Priest-Holy','Monk-Brewmaster','Mage-Fire','Warrior-Arms','Unknown-Unknown','Shaman-Restoration','Evoker-Devastation','Warrior-Fury','Rogue-Subtlety','Druid-Guardian',}; local provider = {region='US',realm='Rivendare',name='US',type='weekly',zone=42,date='2025-03-29',data={Ad='Adoryl:AwADCAMABAoAAA==.',Ah='Ahtrayu:AwAECAgABAoAAA==.',Ar='Arlyx:AwADCAwABAoAAA==.Arnwaz:AwABCAEABAoAAA==.',Ba='Baf:AwABCAEABRQCAQAHAQgeFQBcrsYCBAoAAQAHAQgeFQBcrsYCBAoAAA==.',Bb='Bboc:AwAGCA4ABAoAAA==.',Be='Beenjuicin:AwAFCAUABAoAAQIAXrcBCAEABRQ=.Berfomat:AwAHCBMABAoAAA==.Betatyler:AwAGCAgABAoAAA==.',Bi='Bigkodorider:AwAECAQABAoAAA==.Bingchilling:AwABCAEABRQCAwAIAQjyBABXWsICBAoAAwAIAQjyBABXWsICBAoAAA==.',Bl='Bloomyvfd:AwACCAQABAoAAA==.Blueicee:AwACCAMABAoAAA==.',Bo='Bocc:AwAHCAwABAoAAA==.Boostedlock:AwAGCAsABAoAAA==.',['BÃ']='BÃ®a:AwACCAIABAoAAA==.',Ce='Ceedh:AwADCAcABRQCBAADAQhSBQBVjiQBBRQABAADAQhSBQBVjiQBBRQAAA==.Celphtitled:AwAICAgABAoAAA==.',Cj='Cjjackpot:AwAFCAcABAoAAA==.',Cl='Clydman:AwADCAYABAoAAA==.',Co='Contagion:AwADCAMABAoAAA==.Cornccobb:AwAGCA0ABAoAAA==.',Da='Damnskippy:AwAECAcABAoAAA==.Darkire:AwABCAEABRQCBQAHAQj0NQA2lMkBBAoABQAHAQj0NQA2lMkBBAoAAA==.',De='Demonfist:AwAICBAABAoAAA==.',Di='Diddley:AwAFCAUABAoAAA==.',Dr='Dragnar:AwAHCBQABAoCBQAHAQjqQwAivIIBBAoABQAHAQjqQwAivIIBBAoAAA==.',El='Elyndrai:AwADCAUABAoAAQYAUBcHCBUABAo=.',Fa='Fay:AwABCAEABRQCBwAHAQg7AwBVHnkCBAoABwAHAQg7AwBVHnkCBAoAAA==.',Fi='Fishnchimps:AwAFCAEABAoAAA==.',Ge='Gettrolldson:AwAGCAsABAoAAQgAMMsICBQABAo=.',Gr='Greetness:AwACCAIABAoAAA==.',Ja='Jahy:AwAGCAIABAoAAA==.Jarlan:AwAFCAwABAoCCQAFAQhNEABZn+sBBAoACQAFAQhNEABZn+sBBAoAAA==.',Ka='Kaidarian:AwADCAUABAoAAA==.Kavax:AwACCAEABAoAAQoAAAADCAEABAo=.',Ki='Kimbelena:AwADCAIABAoAAA==.',Kl='Kleb:AwAGCAUABAoAAA==.',Le='Leone:AwAGCAoABAoAAA==.',Li='Liola:AwADCAEABAoAAA==.',Lu='Lute:AwAHCBMABAoAAA==.',['LÃ']='LÃ¡rien:AwADCAEABAoAAA==.',Ma='Manon:AwABCAEABRQAAA==.',Me='Mendingo:AwAGCAgABAoAAA==.',Mo='Mooage:AwAHCBEABAoAAA==.',Pa='Papasiete:AwAFCAcABAoAAA==.',Ri='Rivis:AwAFCAkABAoAAA==.',Se='Seraphym:AwADCAQABAoAAA==.Sevro:AwADCAEABAoAAA==.',Sh='Shalla:AwABCAEABRQCCwAIAQghEQA/7kYCBAoACwAIAQghEQA/7kYCBAoAAA==.Sheck:AwACCAIABAoAAA==.Shinryujin:AwABCAEABAoAAQwAV/YDCAgABRQ=.Shuralya:AwAHCBMABAoAAA==.',St='Stilts:AwAGCAoABAoAAA==.Stocky:AwABCAEABAoAAA==.',Te='Teia:AwAFCAUABAoAAA==.Tenyi:AwAGCAoABAoAAA==.Terrin:AwADCBIABAoAAA==.',Th='Theodore:AwABCAEABAoAAA==.',Tr='Triage:AwAGCAwABAoAAA==.',Un='Unclecharlie:AwABCAEABRQDDQAHAQggCgBa08YCBAoADQAHAQggCgBa08YCBAoACQACAQiuMgA8XokABAoAAA==.Unholylukers:AwAECAQABAoAAA==.',Ve='Vellani:AwAFCAEABAoAAA==.',Wo='Wocoxl:AwADCAYABRQCDgADAQjyAwBBiwQBBRQADgADAQjyAwBBiwQBBRQAAA==.',Zh='Zharsha:AwAHCAQABAoAAA==.',Zu='Zulshin:AwABCAEABRQCDwAIAQhvAgBEh1QCBAoADwAIAQhvAgBEh1QCBAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end