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
 local lookup = {'Warlock-Demonology','Unknown-Unknown','DeathKnight-Unholy','Paladin-Holy','Warlock-Destruction','Warrior-Fury','Warrior-Protection','DemonHunter-Vengeance','Druid-Guardian','Warrior-Arms','Druid-Feral','Priest-Shadow','Hunter-BeastMastery','Mage-Frost','Shaman-Elemental','Paladin-Retribution',}; local provider = {region='US',realm='Scilla',name='US',type='weekly',zone=42,date='2025-03-29',data={Ai='Aiwass:AwAHCBAABAoAAA==.',Al='Alexander:AwADCAYABAoAAA==.',Am='Amathricus:AwADCAcABAoAAA==.',Ap='Applé:AwACCAIABAoAAQEAWfwBCAEABRQ=.',At='Atillart:AwACCAIABAoAAA==.',Be='Beelzebul:AwAFCAgABAoAAQIAAAABCAIABRQ=.',Bu='Bubbawubbaz:AwACCAIABRQCAwAHAQgeFQBMDywCBAoAAwAHAQgeFQBMDywCBAoAAA==.',Ca='Canadianguy:AwACCAIABAoAAA==.',Ch='Changarang:AwACCAIABRQCBAAHAQimAgBhJ+UCBAoABAAHAQimAgBhJ+UCBAoAAA==.Cheyeon:AwAGCA0ABAoAAA==.',Ci='Cia:AwAHCBQABAoCBQAHAQjcKAAxb6YBBAoABQAHAQjcKAAxb6YBBAoAAA==.',Cl='Claybigsby:AwACCAIABRQDBQAHAQjfFwBTmSkCBAoABQAHAQjfFwBGhikCBAoAAQAEAQhRFQBGSzABBAoAAA==.Clif:AwAHCBkABAoDBgAHAQi4IwAtGbQBBAoABgAGAQi4IwAzz7QBBAoABwABAQjoKgAE1RIABAoAAA==.',Da='Damien:AwAECAIABAoAAA==.',Di='Dirmag:AwADCAMABAoAAA==.',Dj='Djwarlock:AwAFCBAABAoAAA==.',Do='Doccuban:AwAFCAkABAoAAA==.',Dr='Drachese:AwAECAQABAoAAA==.Druchese:AwAFCAUABAoAAA==.',Em='Emsley:AwAHCBMABAoAAA==.',Ey='Eyrn:AwADCAMABAoAAA==.',Fa='Fatality:AwACCAIABRQCCAAHAQhBDABBl/EBBAoACAAHAQhBDABBl/EBBAoAAA==.',Fo='Focalors:AwACCAIABAoAAQIAAAABCAIABRQ=.Foobear:AwACCAIABRQCCQAHAQhXAQBazrwCBAoACQAHAQhXAQBazrwCBAoAAA==.',Go='Gochese:AwABCAEABAoAAA==.',Gr='Gramid:AwAFCAUABAoAAA==.Gramrage:AwADCAYABRQDCgADAQg7AgBDRcYABRQACgACAQg7AgBW08YABRQABgACAQiACgAyJqgABRQAAA==.',Gt='Gtoffmyd:AwACCAQABAoAAA==.',Ha='Haagoon:AwAECAUABAoAAA==.Hatch:AwAECAQABAoAAA==.Hazeydeez:AwAECAQABAoAAA==.',He='Herbydoober:AwABCAEABAoAAA==.',If='Ifrita:AwAECAkABAoAAA==.',Im='Imbasoul:AwABCAIABRQDBQAIAQimFwBKKCsCBAoABQAGAQimFwBRqSsCBAoAAQADAQiWIwA9PcQABAoAAA==.',Ja='Jaycat:AwACCAMABAoAAA==.',Jo='Jormi:AwAECAgABAoAAA==.',['J�']='Jésus:AwADCAMABAoAAQQAYScCCAIABRQ=.',Ka='Kabaayi:AwADCAQABAoAAA==.',Ke='Keybricker:AwADCAMABAoAAQIAAAAFCAMABAo=.',Ki='Kizim:AwAICAUABAoAAA==.',Kl='Kllaus:AwACCAQABAoAAA==.',Ko='Kowalski:AwACCAUABRQCCwACAQinAQA72rEABRQACwACAQinAQA72rEABRQAAA==.',Li='Lickme:AwACCAUABRQCDAACAQg7BwBRFrEABRQADAACAQg7BwBRFrEABRQAAA==.',Ma='Magicdro:AwABCAEABRQAAA==.',Me='Mero:AwADCAIABAoAAA==.',Mo='Mok:AwACCAIABRQAAA==.',My='Myeongsoo:AwAGCBIABAoAAA==.Mytz:AwAGCAwABAoAAA==.',Ni='Nini:AwACCAQABAoAAA==.',Pe='Pettraner:AwAFCAkABAoAAA==.',Pl='Plaguedoctor:AwACCAMABAoAAA==.',Po='Portinglol:AwACCAIABAoAAA==.Powershift:AwADCAMABAoAAA==.',Ra='Ratadin:AwAECAYABAoAAA==.Rataplague:AwACCAIABAoAAQIAAAAECAYABAo=.',Re='Remmîngton:AwAECAkABAoAAA==.',Ru='Runslikedeer:AwACCAMABAoAAA==.Runé:AwAFCAkABAoAAA==.',Sa='Sanika:AwACCAIABRQCDQAHAQgZJgBKOiwCBAoADQAHAQgZJgBKOiwCBAoAAA==.',Se='Sean:AwACCAIABRQCDgAHAQgkCABawbsCBAoADgAHAQgkCABawbsCBAoAAA==.',Sh='Sheppy:AwAICAgABAoAAQ0ASjoCCAIABRQ=.Shimakaze:AwAGCBAABAoAAA==.Shizaam:AwACCAIABRQCDwAHAQjzCQBZpZgCBAoADwAHAQjzCQBZpZgCBAoAAA==.Shmorc:AwEECAQABAoAAA==.Shy:AwAECAQABAoAAA==.',Si='Sinfxl:AwAECAUABAoAAQIAAAAFCAkABAo=.',Sk='Skullmages:AwAHCBkABAoCEAAHAQjdHgBVXYQCBAoAEAAHAQjdHgBVXYQCBAoAAA==.',Sl='Slinkeril:AwADCAQABAoAAA==.Sloppydro:AwACCAIABAoAAA==.',St='Stabberz:AwAHCBMABAoAAA==.',Te='Telissa:AwAECAIABAoAAA==.Temprance:AwADCAMABAoAAA==.',Th='Theano:AwAHCA8ABAoAAA==.',To='Tohru:AwABCAIABRQAAA==.',Va='Variam:AwADCAgABAoAAA==.',Vu='Vuo:AwAECAgABAoAAA==.',Wr='Wrather:AwAECAcABAoAAA==.',Xf='Xfreshh:AwAFCAkABAoAAA==.',Ya='Yamaruid:AwAECAEABAoAAA==.',Ze='Zerosh:AwAECAgABAoAAA==.',Zu='Zugszy:AwAHCBIABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end