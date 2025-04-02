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
 local lookup = {'DeathKnight-Blood','Shaman-Elemental','Warrior-Protection','Unknown-Unknown','Warrior-Fury','Monk-Windwalker','Evoker-Devastation','Evoker-Preservation','Shaman-Restoration','Priest-Holy',}; local provider = {region='US',realm='Lethon',name='US',type='weekly',zone=42,date='2025-03-29',data={Al='Allä:AwADCAYABAoAAA==.Aloha:AwAICAgABAoAAA==.',Am='Amatsukaze:AwAHCBEABAoAAA==.',Ar='Aruster:AwADCAoABAoAAA==.',As='Asecretbear:AwAGCA8ABAoAAA==.Ashvana:AwAGCBQABAoCAQAGAQhtFABBcp0BBAoAAQAGAQhtFABBcp0BBAoAAA==.',Aw='Awsika:AwADCAcABRQCAgADAQhcAgBGEgoBBRQAAgADAQhcAgBGEgoBBRQAAA==.',Be='Beefmcangus:AwAGCBQABAoCAwAGAQi+BQBRGRsCBAoAAwAGAQi+BQBRGRsCBAoAAA==.',Bi='Billybob:AwAFCAsABAoAAA==.',Bl='Bluemangood:AwAICAQABAoAAA==.',Ce='Cenarîus:AwACCAIABAoAAQQAAAADCAoABAo=.',Ch='Chaed:AwABCAEABAoAAA==.',Co='Combativecow:AwAGCA8ABAoAAA==.',Cy='Cynestrya:AwAFCAwABAoAAA==.',De='Dercso:AwABCAEABAoAAA==.',Di='Dialog:AwABCAEABRQAAA==.',Do='Dog:AwADCAYABRQCBQADAQi3BgA0c+oABRQABQADAQi3BgA0c+oABRQAAA==.',En='Enhancejunk:AwACCAEABAoAAA==.',Ex='Exzavier:AwABCAEABAoAAA==.',Fa='Fangstaghelm:AwAECAQABAoAAA==.',Fu='Fujitroll:AwADCAMABAoAAA==.',Gl='Gladerbug:AwAFCAkABAoAAA==.',Gr='Griffithe:AwAECAUABAoAAA==.',Hi='Hippopotamus:AwAECAUABAoAAA==.',Is='Ishmonk:AwADCAcABRQCBgADAQhBAwBEMAsBBRQABgADAQhBAwBEMAsBBRQAAA==.Ishretadin:AwAFCAUABAoAAQYARDADCAcABRQ=.',Ju='Justinb:AwACCAQABAoAAA==.',Ka='Karma:AwAFCAwABAoAAA==.',Le='Legoweaver:AwADCAEABAoAAA==.',Lo='Lorelie:AwACCAIABAoAAA==.',Ma='Malex:AwADCAcABRQDBwADAQgxAgBctDkBBRQABwADAQgxAgBctDkBBRQACAADAQhPAQAyq+AABRQAAA==.',Mo='Moistmetal:AwAFCAwABAoAAA==.',Pa='Pacin:AwADCAMABAoAAA==.',Pu='Pum:AwAGCBQABAoCCQAGAQjgCwBhqIcCBAoACQAGAQjgCwBhqIcCBAoAAA==.Pummonk:AwABCAEABAoAAA==.',Ra='Raghnoll:AwACCAIABAoAAA==.',Ro='Roronoazoro:AwABCAEABAoAAA==.',Ru='Rustonn:AwAFCAwABAoAAA==.',Sa='Sariar:AwABCAEABAoAAQQAAAADCAoABAo=.',Sh='Shamfrive:AwADCAMABAoAAA==.',To='Topaten:AwABCAEABAoAAA==.Toploc:AwAFCAcABAoAAA==.',['T�']='Töp:AwACCAMABAoAAA==.',Va='Vaipara:AwABCAEABAoAAA==.',Wa='Wagglez:AwADCAcABRQCAgADAQi1AQBUFyUBBRQAAgADAQi1AQBUFyUBBRQAAA==.',Za='Zatholix:AwAFCAcABAoAAA==.',Ze='Zega:AwAFCAsABAoAAA==.',Zo='Zodiac:AwAGCBQABAoCCgAGAQhnKAAtL00BBAoACgAGAQhnKAAtL00BBAoAAA==.Zoro:AwAECAgABAoAAQQAAAABCAEABRQ=.',['É']='Éippo:AwAFCAwABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end