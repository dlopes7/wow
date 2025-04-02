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
 local lookup = {'Shaman-Elemental','Shaman-Enhancement','Warrior-Fury','Paladin-Retribution','Evoker-Devastation','Evoker-Preservation',}; local provider = {region='US',realm='Ravencrest',name='US',type='weekly',zone=42,date='2025-03-29',data={Ad='Adis:AwAECAoABAoAAA==.',Ag='Agba:AwAFCAwABAoAAA==.',Al='Alanus:AwAFCA0ABAoAAA==.',An='Annafe:AwADCAMABAoAAA==.',Ar='Armsmaster:AwACCAIABAoAAA==.',Av='Avtershock:AwABCAIABRQDAQAIAQiNDgBCWEoCBAoAAQAIAQiNDgA8VkoCBAoAAgAGAQhgGAA/HcQBBAoAAA==.',Ba='Baey:AwAFCAcABAoAAA==.',Ch='Chibbs:AwAECAQABAoAAA==.',Di='Dionan:AwAFCA0ABAoAAA==.',Do='Doks:AwAECAUABAoAAA==.',Dr='Drag√µn:AwABCAEABAoAAA==.',Ds='Dstwo:AwAECAYABAoAAA==.',Ea='Ealara:AwADCAcABAoAAA==.',Ep='Epoulosi:AwAECAMABAoAAA==.',Er='Erwyn:AwAFCAIABAoAAA==.',Ev='Everayn:AwABCAEABAoAAA==.',Fa='Fallen:AwADCAQABAoAAA==.',Ge='Gemeater:AwADCAEABAoAAA==.',Gl='Gloomstalkin:AwAFCAgABAoAAA==.',Gr='Grumpuz:AwAECAIABAoAAA==.Gryffs:AwADCAYABAoAAA==.',Gu='Gutts:AwAFCA0ABAoAAA==.',Ha='Happens:AwAFCAkABAoAAA==.Haromm:AwABCAEABRQCAwAIAQh6EwA4Dk0CBAoAAwAIAQh6EwA4Dk0CBAoAAA==.',Ho='Hohentein:AwABCAEABAoAAA==.',Ji='Jive:AwAECAoABAoAAA==.',Ju='Jukk:AwACCAMABAoAAA==.',Ke='Kerztek:AwAECAEABAoAAA==.',Kh='Khaster:AwACCAQABRQCBAAIAQg0BABgp14DBAoABAAIAQg0BABgp14DBAoAAA==.',Kr='Krimzin:AwAHCA4ABAoAAQEAQlgBCAIABRQ=.',La='Lanskies:AwAFCAoABAoAAA==.',Li='Librarte:AwADCAMABAoAAA==.',Lo='Lox:AwACCAQABAoAAA==.',['L√']='L√≠tterbox:AwAFCAMABAoAAA==.',Ma='Mahariel:AwAICAgABAoAAA==.',Mu='Mushhead:AwAFCAkABAoAAA==.',My='Mythantherox:AwAGCA0ABAoAAA==.',No='Noircoeur:AwABCAIABAoAAA==.',Ny='Nyxstonia:AwAFCAUABAoAAA==.',Pe='Persephoneia:AwAFCA0ABAoAAA==.',Ph='Phteven:AwADCAcABAoAAA==.',Ra='Rakkari:AwABCAEABAoAAA==.Ravenlunatic:AwAICAUABAoAAA==.',Ri='Riloro:AwAFCA0ABAoAAA==.',Ro='Rochana:AwACCAMABAoAAA==.Rodgerwabbet:AwADCAgABAoAAA==.',Sh='Sharked:AwACCAMABAoAAA==.Shekels:AwABCAEABAoAAA==.',Si='Silvein:AwAFCAQABAoAAA==.',Sp='Spyro:AwAICBYABAoDBQAHAQh9GgAaS1oBBAoABQAHAQh9GgAaS1oBBAoABgAGAQhkEAAQqf8ABAoAAA==.',St='Staloren:AwAICAgABAoAAA==.',['S√']='S√Øx:AwAECAMABAoAAA==.',Ta='Tarlyn:AwABCAIABRQCBAAIAQjbMQA7IiMCBAoABAAIAQjbMQA7IiMCBAoAAA==.',Ti='Timthelock:AwABCAEABAoAAA==.Timthemonk:AwAFCAsABAoAAA==.',To='Toxicbanana:AwADCAMABAoAAA==.',Va='Valhalia:AwAFCAwABAoAAA==.',Vi='Vidoq:AwABCAEABAoAAA==.',Vy='Vyprania:AwAGCAkABAoAAA==.',We='Weth:AwACCAQABAoAAA==.',Wi='Wildefaux:AwADCAQABRQAAA==.',Ye='Yevgeny:AwADCAIABAoAAA==.',Ze='Zelavathuin:AwAFCAoABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end