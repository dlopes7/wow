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
 local lookup = {'Hunter-BeastMastery','Hunter-Survival','Mage-Fire','Warrior-Arms','Warrior-Fury','Unknown-Unknown','Warlock-Affliction','Warlock-Demonology','Paladin-Holy',}; local provider = {region='US',realm='ShatteredHalls',name='US',type='weekly',zone=42,date='2025-03-28',data={Aj='Ajion:AwAICBcABAoDAQAIAQilHwBSTk8CBAoAAQAIAQilHwBHPk8CBAoAAgAFAQhhBgBKBkIBBAoAAA==.',Az='Azram:AwABCAEABRQAAA==.',Ch='Chamberr:AwAICAwABAoAAA==.',Co='Codum:AwADCAMABAoAAA==.',Cr='Crowface:AwABCAIABRQCAwAIAQhNFABCLnQCBAoAAwAIAQhNFABCLnQCBAoAAA==.',Da='Dackosaur:AwAECAMABAoAAA==.Darkenedone:AwAICBIABAoAAA==.',Db='Dblackfalcon:AwAFCAEABAoAAA==.',De='Deathrune:AwAECAIABAoAAA==.Demono:AwAFCAgABAoAAA==.',Dr='Dracthyr:AwAFCAkABAoAAA==.Drogarrow:AwAHCAwABAoAAA==.',Fa='Falan:AwAICAEABAoAAA==.',Fr='Frostblast:AwABCAEABAoAAA==.',Ga='Gamblet:AwAECAMABAoAAA==.',Ge='Genjiskhan:AwAHCBYABAoDBAAHAQjYFQBW/48BBAoABAAEAQjYFQBXvo8BBAoABQAEAQg1KwBP2moBBAoAAA==.',Ha='Hamus:AwAECAQABAoAAA==.Harakki:AwAECAcABAoAAA==.',Il='Illidak:AwADCAQABAoAAQYAAAAECAMABAo=.',Ku='Kurraled:AwAFCAUABAoAAA==.',Lo='Lockwarior:AwAECAkABRQDBwAEAQiTAABGTUcBBRQABwAEAQiTAAA2HUcBBRQACAABAQhdAgBewWoABRQAAA==.',Lu='Luciena:AwABCAIABAoAAA==.Lullu:AwAFCAEABAoAAA==.',['LÃ']='LÃ ggs:AwACCAQABAoAAA==.',Mo='Monkjimothy:AwAECAgABAoAAA==.',My='Myxo:AwABCAEABAoAAA==.',Os='Oscar:AwADCAMABAoAAQYAAAAFCAkABAo=.',Pa='Pallydude:AwAGCAYABAoAAA==.Paul:AwAICBMABAoAAA==.',Ra='Racinette:AwABCAIABRQCCQAIAQiNAABgrVgDBAoACQAIAQiNAABgrVgDBAoAAA==.',Sl='Sleepies:AwAHCBEABAoAAA==.',Sn='Snolo:AwABCAEABAoAAA==.',Sp='Spiritwarior:AwAFCAUABAoAAQcARk0ECAkABRQ=.Splux:AwAHCAkABAoAAA==.',Th='Thunderfnk:AwAFCAcABAoAAA==.',Ti='Tinkerspell:AwAECAMABAoAAA==.Titri:AwAFCAsABAoAAA==.',Tr='Trickydice:AwABCAEABAoAAA==.',Tw='Twohundred:AwABCAMABRQAAA==.',Wr='Wreckthar:AwAHCBIABAoAAA==.',Wu='Wu:AwAFCAUABAoAAQYAAAABCAEABRQ=.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end