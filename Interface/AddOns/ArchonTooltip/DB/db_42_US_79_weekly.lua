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
 local lookup = {'Warrior-Fury','Unknown-Unknown','Rogue-Assassination','Druid-Balance','Druid-Feral','Shaman-Restoration','Mage-Fire',}; local provider = {region='US',realm='Drenden',name='US',type='weekly',zone=42,date='2025-03-29',data={Ac='Actaia:AwAICAgABAoAAA==.',Ad='Adora:AwAFCA0ABAoAAA==.',An='Anitabj:AwAECAcABAoAAA==.',Av='Avdakedavra:AwADCAMABAoAAA==.',Ba='Babooski:AwABCAEABAoAAA==.Bangers:AwABCAEABRQCAQAHAQg2GAA+CR4CBAoAAQAHAQg2GAA+CR4CBAoAAA==.',Bl='Blooming:AwAECAoABAoAAA==.',Br='Brewslunt:AwACCAMABRQAAA==.',Ca='Carl:AwABCAIABRQAAA==.',Ce='Cedwalex:AwAECAQABAoAAA==.Celithia:AwAFCAEABAoAAA==.',Ch='Chada:AwACCAEABAoAAQIAAAADCAMABAo=.Charîzard:AwAGCAMABAoAAA==.Chipp:AwABCAQABRQAAA==.',Co='Coggler:AwACCAIABAoAAA==.',Cu='Curmudge:AwAFCAsABAoAAA==.',Cy='Cyaani:AwAFCAEABAoAAA==.',Da='Dakunaito:AwAECAgABAoAAA==.',Di='Dippindotz:AwAFCAwABAoAAA==.',Dr='Drhkillinger:AwECCAEABAoAAQIAAAACCAIABAo=.',Du='Duroom:AwACCAQABAoAAA==.',Fe='Feardotrun:AwACCAIABAoAAA==.',Fu='Fuggz:AwAECAIABAoAAA==.',Fy='Fyrakkobama:AwAHCAMABAoAAA==.',Ga='Gaiasliege:AwACCAIABAoAAA==.',Ha='Hammerhead:AwACCAEABAoAAA==.',Ja='Jaskor:AwABCAEABAoAAQMAJ+gICBUABAo=.',Je='Jeef:AwAGCAQABAoAAQIAAAAHCAMABAo=.',Jo='Jof:AwAGCAwABAoAAA==.',Ka='Katrishy:AwAGCAwABAoAAA==.',Ke='Keedrid:AwAFCAUABAoAAA==.',Kt='Kthanxx:AwAHCAcABAoAAA==.',Le='Legacy:AwAECAcABAoAAA==.Leighwaltz:AwAFCAEABAoAAA==.',Lu='Lukers:AwAFCAYABAoAAA==.Luthian:AwAGCA0ABAoAAA==.',Ly='Lyse:AwABCAEABAoAAA==.',Ma='Macarthur:AwAICAUABAoAAA==.Manslain:AwECCAIABAoAAA==.Mathpapa:AwAGCAcABAoAAQIAAAAHCAMABAo=.',Mi='Mindhorn:AwAGCAsABAoAAA==.',Py='Pyroth:AwAECAQABAoAAA==.',Ra='Rakshasa:AwABCAEABRQAAA==.Rashmi:AwABCAEABRQDBAAGAQh+EQBcYXYCBAoABAAGAQh+EQBcYXYCBAoABQACAQhVGwAREVEABAoAAA==.Razed:AwABCAEABAoAAA==.',Ro='Rolan:AwAFCAwABAoAAA==.Roogi:AwAECAEABAoAAA==.Roweene:AwACCAIABAoAAA==.',Se='Selryth:AwAECAEABAoAAA==.',Sh='Shots:AwEDCAUABAoAAA==.',Sn='Snortedgfuel:AwAECAQABAoAAA==.',St='Steelbolt:AwACCAMABRQCBgAHAQiFCQBZ0qgCBAoABgAHAQiFCQBZ0qgCBAoAAA==.',Su='Super:AwAFCAgABAoAAA==.',Te='Tesla:AwAICAgABAoAAA==.',Th='Theefjeef:AwADCAIABAoAAQIAAAAHCAMABAo=.',Ti='Tigerstarr:AwADCAMABAoAAA==.',Va='Vagglord:AwABCAEABRQAAA==.',Ve='Vedra:AwABCAEABAoAAA==.',['V�']='Vásh:AwADCAMABAoAAA==.',Wa='Wardkbriggle:AwABCAIABRQAAA==.Wardon:AwAFCAgABAoAAA==.',Wo='Wolfdude:AwACCAEABAoAAA==.',Xa='Xanddoria:AwAFCA0ABAoAAA==.',['Ö']='Öz:AwABCAEABRQCBwAIAQiyDQBNr8ICBAoABwAIAQiyDQBNr8ICBAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end