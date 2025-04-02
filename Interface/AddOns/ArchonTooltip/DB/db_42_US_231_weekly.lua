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
 local lookup = {'DemonHunter-Vengeance','Warrior-Arms','Unknown-Unknown','Warlock-Affliction','Warlock-Destruction','Warrior-Fury','Priest-Shadow','Hunter-BeastMastery','Shaman-Restoration','Shaman-Elemental','Paladin-Holy',}; local provider = {region='US',realm='Ursin',name='US',type='weekly',zone=42,date='2025-03-28',data={An='Angrignon:AwABCAEABAoAAA==.Anonymoose:AwABCAEABAoAAA==.',Ay='Aynu:AwABCAEABAoAAA==.',Ba='Banthos:AwAGCAgABAoAAA==.',Be='Bearbearbear:AwAECAgABAoAAA==.Bearocalypse:AwADCAMABAoAAA==.',Bo='Bonaventure:AwADCAMABAoAAA==.',Co='Cobbles:AwABCAEABRQAAA==.',De='Deathmantis:AwAHCBQABAoCAQAHAQjQFgAl+0YBBAoAAQAHAQjQFgAl+0YBBAoAAA==.',Dr='Drwd:AwADCAMABAoAAA==.',El='Elizalynn:AwADCAMABAoAAA==.',Ev='Ev√©lyn:AwAHCBMABAoAAA==.',Fe='Fengshui:AwAGCAsABAoAAA==.Ferritin:AwACCAMABAoAAQIAUCQCCAIABRQ=.',Fi='Fishguts:AwADCAMABAoAAA==.',Gl='Glokii:AwACCAIABAoAAA==.',He='Hellzscream:AwADCAQABAoAAA==.',Ho='Hockeydruid:AwACCAMABAoAAQMAAAAECAoABAo=.Hockeyhunter:AwAECAoABAoAAA==.',['J√']='J√©zus:AwADCAEABAoAAA==.',Ke='Keralan:AwACCAIABRQCAQAIAQiZAQBbWjEDBAoAAQAIAQiZAQBbWjEDBAoAAA==.',Li='Liithocite:AwACCAIABRQCAgAIAQi+AgBQJAYDBAoAAgAIAQi+AgBQJAYDBAoAAA==.',Ly='Lyam:AwABCAEABAoAAA==.Lysah:AwACCAIABRQDBAAIAQjyAQBYI4UCBAoABAAHAQjyAQBRioUCBAoABQAGAQgKJQBKe7gBBAoAAA==.',Ma='Maestro:AwAFCBAABAoAAA==.Mafjets:AwABCAEABAoAAA==.Mattylite:AwADCAYABAoAAA==.',Me='Meo:AwAFCAwABAoAAA==.',Mo='Mommywommy:AwABCAEABAoAAA==.',['M√']='M√•fjetz:AwACCAMABAoAAA==.',Ni='Niffty:AwACCAEABAoAAA==.',Ok='Ok:AwAHCA8ABAoAAA==.',Pa='Paladiva:AwACCAMABAoAAA==.',Ra='Raggnarr:AwACCAIABRQCBgAHAQjnDgBTcX4CBAoABgAHAQjnDgBTcX4CBAoAAA==.',Ri='Rizzhashira:AwACCAIABAoAAQMAAAAGCAsABAo=.',Ry='Rythevia:AwAHCAUABAoAAA==.',Sa='Sanctified:AwAECAcABAoAAA==.',Se='Seraph:AwACCAMABAoAAA==.',Sh='Shadowjetz:AwAICBoABAoCBwAIAQiFCwBA8nkCBAoABwAIAQiFCwBA8nkCBAoAAA==.',St='Sthompson:AwABCAEABAoAAA==.',Te='Teinaras:AwACCAIABRQCCAAIAQjOEQBP/sUCBAoACAAIAQjOEQBP/sUCBAoAAA==.',Ti='Tiffa:AwAGCBoABAoDCQAGAQi7DQBdWmYCBAoACQAGAQi7DQBdWmYCBAoACgAEAQgfHwBUQ2sBBAoAAA==.',To='Togdumburz:AwAGCAEABAoAAA==.',Tr='Treezy:AwAGCA0ABAoAAA==.',Ud='Udderlymad:AwAFCA8ABAoAAA==.',Wi='Windslotfury:AwACCAMABAoAAQEAW1oCCAIABRQ=.',Zi='Zifi:AwACCAUABRQCCwACAQhTAwBY9boABRQACwACAQhTAwBY9boABRQAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end