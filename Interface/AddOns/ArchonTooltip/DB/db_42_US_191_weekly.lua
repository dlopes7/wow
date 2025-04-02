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
 local lookup = {'Mage-Arcane','Priest-Holy','Warrior-Protection','Monk-Windwalker','Paladin-Retribution','Paladin-Holy','Paladin-Protection','Mage-Fire','Shaman-Enhancement','Shaman-Restoration','Hunter-BeastMastery','Unknown-Unknown','Rogue-Subtlety','Rogue-Assassination','DeathKnight-Unholy',}; local provider = {region='US',realm='Shandris',name='US',type='weekly',zone=42,date='2025-03-28',data={Ac='Acebets:AwAHCBUABAoCAQAHAQjRAABdn8MCBAoAAQAHAQjRAABdn8MCBAoAAA==.Ackay:AwABCAEABAoAAA==.',Ad='Adorie:AwABCAIABAoAAA==.',Al='Alfo:AwAHCBMABAoAAA==.',Am='Amberness:AwAHCBUABAoCAgAHAQhGCABW3JACBAoAAgAHAQhGCABW3JACBAoAAA==.',Ar='Arthedain:AwAHCBUABAoCAwAHAQiIAgBYRa8CBAoAAwAHAQiIAgBYRa8CBAoAAA==.Arthedaine:AwACCAIABAoAAQMAWEUHCBUABAo=.',Au='Augmentmyass:AwACCAIABAoAAA==.',Ba='Bangbang:AwAGCAoABAoAAA==.',Be='Bendini:AwAGCAsABAoAAA==.',Bo='Bobe:AwACCAIABAoAAA==.Bobedruid:AwACCAMABAoAAA==.',Br='Brëwsleë:AwAHCBUABAoCBAAHAQjfCwBKNWoCBAoABAAHAQjfCwBKNWoCBAoAAA==.',Bu='Bulldoony:AwAECAkABAoAAA==.',Ce='Ceindra:AwADCAUABAoAAA==.Celiñ:AwAHCBUABAoEBQAHAQjEIgBOZmMCBAoABQAHAQjEIgBOZmMCBAoABgACAQhELQAar1AABAoABwABAQgpQgAEfg0ABAoAAA==.',Ch='Chered:AwADCAUABRQCCAADAQjbBQBZ2isBBRQACAADAQjbBQBZ2isBBRQAAA==.Chewingcud:AwAECAkABAoAAA==.',['C�']='Cól:AwAGCAsABAoAAA==.',Da='Daesong:AwEGCAoABAoAAA==.',De='Demi:AwAGCA8ABAoAAA==.',Do='Dozy:AwABCAEABRQAAA==.',Dr='Druidheelzz:AwADCAMABAoAAA==.',Du='Durlan:AwACCAIABAoAAA==.',Ei='Eithnê:AwABCAEABAoAAA==.',Ev='Evianda:AwADCAQABAoAAA==.',Fa='Facepalm:AwAECAgABAoAAA==.Fatherzen:AwABCAEABAoAAA==.',Fr='Freedum:AwACCAIABRQCAwAIAQjyAgBM5pQCBAoAAwAIAQjyAgBM5pQCBAoAAA==.',Ga='Gabriella:AwABCAEABAoAAA==.Gaviriard:AwAICAgABAoAAA==.',Ge='Gellywoo:AwADCAgABAoAAA==.',Go='Goonz:AwAHCBUABAoDCQAHAQiEGwBJY5QBBAoACQAFAQiEGwBGx5QBBAoACgAHAQiiMgAZZUkBBAoAAA==.',Gr='Greymoon:AwABCAEABAoAAA==.',He='Hello:AwADCAIABAoAAA==.',Hu='Hurrikun:AwAHCAEABAoAAA==.',Ja='Jawn:AwACCAQABAoAAA==.',Ka='Kalahandra:AwAHCBMABAoAAA==.Kalseraph:AwABCAEABAoAAA==.',La='Lasa:AwADCAQABAoAAA==.',Lo='Lotuss:AwAECAcABAoAAA==.',Ma='Maiama:AwAHCBUABAoCCwAHAQjaMgA54MwBBAoACwAHAQjaMgA54MwBBAoAAA==.Massack:AwAECAkABAoAAA==.',Mc='Mcstudly:AwABCAEABAoAAQwAAAAECAkABAo=.',Me='Medimoosle:AwAHCA8ABAoAAA==.',Mi='Midgetmàniàc:AwADCAQABAoAAA==.',Mo='Moobear:AwAECAkABAoAAA==.Mortishiin:AwABCAEABAoAAA==.',Na='Naanaa:AwAGCAwABAoAAA==.',Ne='Netherrogue:AwABCAEABRQDDQAIAQhICQBZE3ECBAoADQAIAQhICQBCvHECBAoADgAFAQgSDABX8OgBBAoAAA==.Nevidimyy:AwEBCAEABAoAAQwAAAAGCAoABAo=.',Pe='Performance:AwADCAUABAoAAA==.',Po='Poolnoodle:AwAECAkABAoAAA==.',Pr='Prevalence:AwABCAEABAoAAA==.',Qu='Quadrix:AwAECAkABAoAAA==.',Re='Remorse:AwABCAEABRQCDwAIAQiLBABa7RoDBAoADwAIAQiLBABa7RoDBAoAAA==.',['R�']='Rën:AwACCAIABAoAAA==.',Sa='Sarylin:AwABCAEABAoAAA==.',Sg='Sgtdad:AwACCAIABAoAAA==.',Sh='Shortstackz:AwAICAgABAoAAA==.Shàdowqt:AwAECAIABAoAAA==.',Sm='Smoke:AwAGCAwABAoAAA==.',Sw='Swishslash:AwAICAgABAoAAA==.',Te='Teli:AwAHCBUABAoCBQAHAQiiPQA5bOYBBAoABQAHAQiiPQA5bOYBBAoAAA==.Telperien:AwAECAoABAoAAA==.Temeilea:AwAECAMABAoAAA==.',Th='Thors:AwABCAEABRQAAA==.',Ti='Timmy:AwAHCAMABAoAAA==.',To='Torgoth:AwABCAEABAoAAA==.Totemsmoke:AwAFCAUABAoAAA==.Toxofbissues:AwABCAEABAoAAA==.',Tw='Twilightsoul:AwAICAgABAoAAA==.',Un='Underlok:AwACCAMABAoAAA==.',Va='Valiantaine:AwACCAIABRQCBQAIAQiiEgBWCNECBAoABQAIAQiiEgBWCNECBAoAAA==.',Ve='Vendel:AwAGCAsABAoAAA==.',Vi='Vistine:AwAECAcABAoAAA==.',Vu='Vulpiandis:AwACCAIABAoAAQUAOWwHCBUABAo=.',Wi='Wikken:AwABCAEABAoAAA==.Winkster:AwAECAUABAoAAA==.',Xy='Xyfarion:AwABCAEABAoAAA==.',Yo='Yohasakura:AwABCAEABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end