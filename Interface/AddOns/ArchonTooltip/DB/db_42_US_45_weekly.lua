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
 local lookup = {'Hunter-BeastMastery','Warlock-Demonology','Warlock-Destruction','Warlock-Affliction','Priest-Shadow','Priest-Holy','Rogue-Outlaw','Mage-Fire',}; local provider = {region='US',realm='Bronzebeard',name='US',type='weekly',zone=42,date='2025-03-29',data={Ai='Aiir:AwABCAEABAoAAA==.',Ar='Arkitek:AwABCAEABRQCAQAIAQiPEgBSQMUCBAoAAQAIAQiPEgBSQMUCBAoAAA==.',As='Astrothunder:AwAHCBUABAoEAgAHAQjRDQBOmYYBBAoAAgAFAQjRDQBG3oYBBAoAAwADAQizSwBKUuIABAoABAABAQgTIgBV+l8ABAoAAA==.',Au='Auroth:AwADCAEABAoAAA==.',Aw='Awlhh:AwABCAIABAoAAA==.',Bl='Blackout:AwAGCAkABAoAAA==.',Bo='Bosshoglock:AwAGCAQABAoAAA==.',Ch='Cheetodorito:AwABCAEABAoAAA==.',Co='Corez:AwABCAMABRQDBQAIAQjoEwA5o/cBBAoABQAHAQjoEwA5GPcBBAoABgADAQiqSAALCpoABAoAAA==.',Di='Disektor:AwABCAEABAoAAA==.',Du='Ducked:AwADCAIABAoAAA==.',Ed='Edrelang:AwADCAMABAoAAA==.',El='Elianadia:AwADCAIABAoAAA==.',Ex='Exsalar:AwAECAYABAoAAA==.',Ga='Galandre:AwADCAMABAoAAA==.Gamble:AwABCAEABAoAAA==.',Gh='Ghast:AwADCAMABAoAAA==.',Gr='Grandpawolf:AwADCAEABAoAAA==.',['G�']='Gùldan:AwAECAQABAoAAA==.',Ha='Handerbug:AwAGCBMABAoAAA==.Hazmati:AwAHCBEABAoAAA==.',Ho='Hogglethorp:AwAGCAcABAoAAA==.',Hu='Huntion:AwAICAoABAoAAA==.',Il='Illadron:AwABCAEABAoAAA==.',In='Invoctation:AwACCAEABAoAAA==.',Je='Jek:AwAICAoABAoAAQcAYCoBCAEABRQ=.Jenaaidy:AwAFCAMABAoAAA==.',Ke='Ketura:AwABCAEABAoAAA==.',La='Lauxy:AwAGCAUABAoAAA==.Lawfulbeard:AwABCAEABAoAAA==.',Le='Leyva:AwAECAcABAoAAA==.',Li='Lilyoon:AwAGCAYABAoAAA==.',Lo='Loroessan:AwADCAMABAoAAA==.',Ma='Maled:AwABCAEABAoAAA==.',Mo='Monspeet:AwACCAMABAoAAA==.Morn:AwAGCAcABAoAAA==.',Na='Nadià:AwADCAIABAoAAA==.',Pa='Patchs:AwADCAMABAoAAA==.',Po='Potatolor:AwAECAMABAoAAA==.',Pr='Prettycolorz:AwAGCAUABAoAAA==.',Ra='Rainn:AwADCAMABAoAAA==.',Rh='Rhapsody:AwADCAUABAoAAA==.',Ri='Ricknar:AwADCAMABAoAAA==.',Ru='Ruw:AwADCAYABAoAAA==.',Sa='Sapphirepal:AwADCAIABAoAAA==.',Sh='Shawesome:AwACCAIABAoAAA==.',Sw='Swaggart:AwABCAEABRQAAA==.',Th='Thniper:AwAHCA8ABAoAAA==.Thunderbuddy:AwABCAEABAoAAA==.',Ti='Tiamaria:AwAGCBAABAoAAA==.',To='Todar:AwAICBAABAoAAA==.',Vy='Vyraal:AwADCAMABAoAAA==.',Wa='Warlorok:AwAGCAkABAoAAA==.',We='Wedge:AwADCAEABAoAAA==.Wend:AwAGCA8ABAoAAA==.',Wy='Wychlord:AwABCAEABAoAAA==.',Ya='Yamagesly:AwABCAEABRQCCAAGAQhZJQBE8twBBAoACAAGAQhZJQBE8twBBAoAAA==.',Yn='Yn:AwAFCAIABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end