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
 local lookup = {'Priest-Shadow','Priest-Holy','DemonHunter-Vengeance','Warrior-Arms','Warrior-Fury','Unknown-Unknown','Mage-Fire','Warlock-Affliction','Warlock-Destruction','Paladin-Retribution','Hunter-BeastMastery','Monk-Mistweaver','Evoker-Augmentation','Evoker-Devastation','DemonHunter-Havoc',}; local provider = {region='US',realm='Agamaggan',name='US',type='weekly',zone=42,date='2025-03-29',data={Ae='Aegida:AwADCAMABRQDAQAIAQj6AQBcO0wDBAoAAQAIAQj6AQBcO0wDBAoAAgABAQjaWQBR9E8ABAoAAA==.Aerodria:AwAHCBMABAoAAA==.',Ak='Akeno:AwABCAIABRQCAwAIAQjLBABM+rACBAoAAwAIAQjLBABM+rACBAoAAA==.',As='Ashton:AwACCAQABRQCBAAIAQhtCgA3lEsCBAoABAAIAQhtCgA3lEsCBAoAAA==.',Az='Azzy:AwABCAIABRQCBQAIAQiZDQBNXZQCBAoABQAIAQiZDQBNXZQCBAoAAA==.',Bo='Bothenheim:AwABCAEABRQAAA==.',Br='Brewsimmons:AwAECAgABAoAAQYAAAAICBAABAo=.',Bu='Burnta:AwAICAgABAoAAA==.',Ca='Capie:AwAICAEABAoAAA==.',Ce='Centri:AwADCAMABRQCBwAIAQjlBwBYLwUDBAoABwAIAQjlBwBYLwUDBAoAAA==.',Ch='Chicknorris:AwAHCA8ABAoAAA==.',Cl='Clahowd:AwAFCAkABAoAAA==.Cleverlev:AwABCAIABAoAAA==.',Cr='Cruellev:AwABCAEABAoAAA==.',Cu='Cuttyflam:AwADCAIABAoAAA==.',De='Delbael:AwADCAEABAoAAA==.Demonicrav:AwABCAEABRQDCAAIAQhNBABBShMCBAoACAAHAQhNBABBBBMCBAoACQAIAQjLIwA0zMwBBAoAAA==.',Dp='Dpsrogue:AwABCAEABAoAAQYAAAAECAYABAo=.',Du='Ducksauce:AwACCAEABAoAAA==.Durtok:AwACCAQABAoAAA==.',Ev='Evvie:AwACCAIABAoAAQcAWC8DCAMABRQ=.',Ex='Excentric:AwABCAEABAoAAQcAWC8DCAMABRQ=.',Fa='Fabulous:AwABCAEABAoAAA==.Faedra:AwACCAEABAoAAQMATPoBCAIABRQ=.Fatesdue:AwACCAUABRQCCgACAQgOCwBJiLsABRQACgACAQgOCwBJiLsABRQAAA==.',Fe='Fearious:AwAHCBIABAoAAA==.',Fl='Flandy:AwACCAMABAoAAA==.',Gi='Giterdonee:AwADCAMABRQCBQAIAQgZCQBOodYCBAoABQAIAQgZCQBOodYCBAoAAA==.',Go='Goblinbeans:AwAICBAABAoAAA==.',Gr='Grizznade:AwAECAIABAoAAA==.',Ha='Hadoken:AwADCAIABAoAAA==.',Hu='Hurtlockër:AwAICAkABAoAAA==.',Hy='Hyara:AwABCAIABRQCCwAIAQgEHgA8p2cCBAoACwAIAQgEHgA8p2cCBAoAAA==.',['H�']='Häkoda:AwAHCAsABAoAAA==.',Im='Imnaked:AwAICAoABAoAAA==.',Ja='Jackston:AwAECAQABAoAAA==.',Je='Jeffster:AwABCAEABAoAAA==.',Ka='Kanree:AwACCAcABRQCDAACAQjHDAARYIIABRQADAACAQjHDAARYIIABRQAAA==.',Ko='Kolonb:AwAGCA0ABAoAAA==.Korxin:AwADCAMABRQCCwAIAQgHFwBHNqACBAoACwAIAQgHFwBHNqACBAoAAA==.',Le='Ledgendary:AwAICAcABAoAAA==.',Li='Lillethia:AwACCAEABAoAAA==.',Lo='Longbów:AwAECAYABAoAAA==.',Ma='Man:AwACCAMABAoAAA==.Manabanana:AwAFCAUABAoAAA==.',Me='Melt:AwACCAcABRQCCQACAQg6DAAqVI0ABRQACQACAQg6DAAqVI0ABRQAAA==.Menda:AwABCAEABAoAAA==.Meowmix:AwAECAgABAoAAA==.',Mi='Mike:AwAECAcABAoAAA==.Missðirect:AwACCAIABAoAAA==.',Mo='Mobiouse:AwAGCAMABAoAAA==.',Mu='Murotarn:AwAECAIABAoAAA==.',Ne='Neryssa:AwACCAcABRQCCQACAQjKCQA8hKEABRQACQACAQjKCQA8hKEABRQAAA==.',Ni='Nibrastraz:AwACCAMABRQDDQAIAQhTAABYU68CBAoADQAHAQhTAABemK8CBAoADgAHAQjwGgAgAlQBBAoAAA==.',No='Noana:AwADCAEABAoAAA==.Nocter:AwACCAIABRQAAA==.',Om='Omgega:AwAECAEABAoAAA==.',On='Onimeek:AwAHCA8ABAoAAA==.',Pa='Paper:AwACCAMABRQCDgAIAQgCBgBO39ACBAoADgAIAQgCBgBO39ACBAoAAA==.',Pe='Peacefullev:AwABCAEABRQCDAAIAQjVDgBDrVgCBAoADAAIAQjVDgBDrVgCBAoAAA==.Penance:AwADCAQABAoAAA==.',Pi='Pictureplane:AwADCAMABAoAAA==.',Pr='Priestituta:AwABCAEABAoAAA==.',Ri='Riellus:AwAGCBQABAoCDwAGAQgGRQAT3CQBBAoADwAGAQgGRQAT3CQBBAoAAA==.',Ro='Rokom:AwABCAIABRQCBQAHAQjPFwA7viICBAoABQAHAQjPFwA7viICBAoAAA==.',Sh='Shamanpwnz:AwAECAkABAoAAA==.Shortpally:AwAGCAoABAoAAA==.',Sl='Slingshotz:AwAHCAwABAoAAA==.',So='Sodoritos:AwAECAIABAoAAA==.',St='Stabwei:AwAECAwABAoAAA==.',Su='Superevoker:AwAHCBMABAoAAA==.Sureshotz:AwAICBAABAoAAA==.',Ta='Taehausx:AwAGCA0ABAoAAQcAOQUCCAQABRQ=.Taraka:AwAFCAwABAoAAA==.',Th='Thauriel:AwABCAEABRQAAA==.Thesheit:AwACCAIABAoAAQYAAAAHCA8ABAo=.',To='Toesnatcher:AwAGCAwABAoAAA==.',Ug='Uggogobbo:AwAFCAQABAoAAA==.',Va='Valethia:AwAGCAsABAoAAA==.',Za='Zarrona:AwADCAEABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end