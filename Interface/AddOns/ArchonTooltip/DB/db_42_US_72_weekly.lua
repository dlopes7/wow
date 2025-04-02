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
 local lookup = {'Unknown-Unknown','Druid-Balance','Hunter-BeastMastery','Warlock-Destruction','Warlock-Demonology','Warlock-Affliction','Shaman-Restoration',}; local provider = {region='US',realm='Dragonblight',name='US',type='weekly',zone=42,date='2025-03-29',data={Ba='Babalunious:AwADCAUABAoAAA==.',Bl='Bleshuu:AwABCAEABAoAAA==.',Bo='Boombaaby:AwACCAQABAoAAA==.',Br='Britishchick:AwABCAEABAoAAA==.',Ca='Calada:AwABCAEABAoAAA==.Calaharth:AwACCAQABAoAAA==.',Ch='Chaindeez:AwAGCAIABAoAAA==.',Cl='Claranar:AwAECAQABAoAAA==.',Da='Daccpreest:AwABCAEABAoAAA==.Dazarek:AwADCAYABAoAAA==.',Dr='Dragonsin:AwAICA4ABAoAAA==.',Ep='Epistle:AwABCAEABAoAAA==.',Fa='Faffard:AwABCAEABAoAAQEAAAABCAEABAo=.Fame:AwACCAUABRQCAgACAQj3DQAUoHcABRQAAgACAQj3DQAUoHcABRQAAA==.',Fe='Feyndra:AwABCAEABAoAAA==.',Fr='Frick:AwABCAEABAoAAA==.',Fu='Fumanchöö:AwAGCA8ABAoAAA==.',Fy='Fystie:AwABCAEABAoAAA==.',Ga='Garin:AwACCAQABAoAAA==.',Ho='Hotspur:AwACCAEABAoAAA==.',Ia='Iamkainoaa:AwAFCAgABAoAAA==.',Je='Jellexy:AwABCAEABAoAAA==.Jellibean:AwADCAUABAoAAA==.',Ka='Kadeen:AwABCAEABAoAAA==.Kailis:AwAECAYABAoAAA==.Kayzon:AwADCAgABRQCAwADAQhMCABLlgIBBRQAAwADAQhMCABLlgIBBRQAAA==.',Ki='Kilbaeden:AwABCAIABRQEBAAIAQjtNQA/0VEBBAoABAAFAQjtNQA4zlEBBAoABQADAQgeHwA7nOAABAoABgACAQgoGgBOsJwABAoAAA==.',Ko='Korben:AwAFCA0ABAoAAA==.',Ku='Kublakhan:AwADCAQABAoAAA==.',La='Lakhi:AwAGCA0ABAoAAA==.',Le='Lemooski:AwADCAUABAoAAA==.Letholdus:AwADCAYABAoAAA==.',Li='Lightberry:AwACCAIABAoAAA==.Lightningg:AwAECAkABAoAAA==.',Lu='Lucifera:AwAECAYABAoAAQcAQc4HCBcABAo=.',Ma='Mandi:AwACCAMABAoAAA==.',Mi='Mirkdrak:AwAECAwABAoAAA==.Misjudged:AwAICAYABAoAAA==.Mizzen:AwACCAQABAoAAA==.',Mo='Mohdaddy:AwADCAUABAoAAA==.',Ne='Negate:AwAGCAMABAoAAA==.',No='Nosine:AwAECAEABAoAAA==.Novax:AwABCAEABAoAAA==.',['N�']='Nëptune:AwAHCBcABAoCBwAHAQjyGgBBzuwBBAoABwAHAQjyGgBBzuwBBAoAAA==.',Oe='Oekabe:AwABCAEABAoAAA==.',Or='Oroko:AwACCAMABAoAAA==.Oruko:AwACCAIABAoAAA==.',Ot='Otwin:AwADCAUABAoAAA==.',Pa='Palleigh:AwADCAYABAoAAA==.',Pi='Pikklerikk:AwABCAEABAoAAA==.',Qi='Qindere:AwAECAUABAoAAA==.',Re='Reeses:AwABCAEABAoAAQEAAAAFCAYABAo=.',Ro='Rockgobbler:AwAICAgABAoAAA==.Rocthoeb:AwAICAsABAoAAA==.',Ry='Ry:AwAGCAkABAoAAA==.',Sk='Skuishe:AwAICAgABAoAAA==.',St='Stuckinwell:AwADCAYABRQDBgADAQhEAwBQdsMABRQABgACAQhEAwBQscMABRQABAACAQg4CABRLLIABRQAAA==.',Te='Temna:AwADCAUABAoAAA==.',To='Totemistic:AwABCAEABAoAAA==.Tourniknight:AwABCAEABAoAAA==.',Ut='Uttrspriest:AwAECAEABAoAAA==.',Va='Valkknaifu:AwADCAUABAoAAA==.Van:AwABCAEABAoAAA==.',Ve='Vessna:AwABCAEABAoAAA==.',Vi='Vivîán:AwABCAEABAoAAA==.',Wa='Walk:AwAICAgABAoAAQIAFKACCAUABRQ=.',Wi='Winterfall:AwADCAMABAoAAA==.',Wo='Woodford:AwAFCAYABAoAAA==.',Xl='Xlo:AwACCAIABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end