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
 local lookup = {'Evoker-Preservation','Unknown-Unknown','Monk-Mistweaver','DeathKnight-Unholy','Priest-Discipline','Priest-Shadow','Priest-Holy','Paladin-Retribution','Paladin-Protection','Monk-Windwalker','Druid-Feral','Evoker-Devastation','DemonHunter-Havoc','Warlock-Destruction','Warlock-Demonology','DeathKnight-Blood','DemonHunter-Vengeance','Druid-Restoration','Druid-Balance','Hunter-Survival',}; local provider = {region='US',realm='Madoran',name='US',type='weekly',zone=42,date='2025-03-29',data={Al='Alandien:AwABCAEABRQAAA==.Albyfaraday:AwAECAQABAoAAQEARz4DCAMABRQ=.',Ar='Ardaddy:AwADCAkABAoAAA==.Arragorn:AwAGCBMABAoAAA==.Arthurworgen:AwAFCAUABAoAAA==.',Ba='Bamboozled:AwADCAEABAoAAA==.Barngoddess:AwADCAUABAoAAA==.',Be='Beyla:AwADCAkABAoAAA==.',Bu='Butterkip:AwAICAsABAoAAA==.',Ca='Carnifexx:AwABCAEABRQAAA==.',Ch='Chopahoe:AwAGCA8ABAoAAA==.',Cl='Clamius:AwAFCAYABAoAAA==.',Co='Conduit:AwAGCAwABAoAAA==.',Cr='Critterzz:AwAFCA0ABAoAAA==.',Da='Dawnstàr:AwAFCAsABAoAAA==.',De='Deepfist:AwAGCA0ABAoAAA==.Degenerate:AwABCAEABAoAAQIAAAABCAEABRQ=.Demonhunter:AwAECAYABAoAAA==.',Di='Dingusbrain:AwAHCA4ABAoAAA==.',Dr='Dragonhaze:AwAGCA4ABAoAAA==.',Ed='Eddie:AwABCAMABRQCAwAHAQjFIgAqNosBBAoAAwAHAQjFIgAqNosBBAoAAA==.',El='Eldes:AwABCAIABRQCBAAHAQg8GgA7M/oBBAoABAAHAQg8GgA7M/oBBAoAAA==.Elyviel:AwABCAEABRQAAA==.',En='Entrópy:AwAICAgABAoAAA==.',Fe='Featherslap:AwACCAIABAoAAA==.',Ga='Garfalo:AwADCAMABAoAAA==.',Gh='Ghöstbeef:AwABCAMABRQCBAAHAQjFIgAxfbMBBAoABAAHAQjFIgAxfbMBBAoAAA==.',Gr='Gralmerte:AwAFCA0ABAoAAA==.',He='Healslord:AwABCAIABRQEBQAHAQhOCwBOPksCBAoABQAHAQhOCwBOPksCBAoABgACAQjIOQA+H4kABAoABwABAQjxYgAnMTEABAoAAA==.',Ho='Hotasspally:AwADCAMABAoAAQIAAAABCAIABRQ=.',Ic='Icynips:AwABCAIABRQAAA==.',It='Itches:AwABCAEABRQAAA==.',Ja='Jarbito:AwADCAQABAoAAA==.',Ji='Jintonic:AwAGCAoABAoAAA==.',Jp='Jpdh:AwAECAoABAoAAA==.',Ju='Junksvil:AwADCAMABAoAAA==.',Ka='Kaithemia:AwADCAUABAoAAA==.',Ke='Kenth:AwADCAMABAoAAA==.',Ki='Kinini:AwADCAMABAoAAA==.',Ko='Kolna:AwABCAEABRQAAA==.Korinth:AwEBCAMABRQDCAAHAQgtIQBT+HYCBAoACAAHAQgtIQBT+HYCBAoACQACAQidMwAh11IABAoAAA==.',Ky='Kyril:AwAHCBUABAoCCAAHAQh7KgBOB0YCBAoACAAHAQh7KgBOB0YCBAoAAA==.',Le='Legault:AwAFCAQABAoAAA==.Lethtel:AwADCAEABAoAAA==.',Li='Livie:AwACCAMABAoAAA==.',Ma='Maezer:AwAECAQABAoAAA==.',Me='Meascii:AwACCAIABAoAAA==.Merc:AwAHCBUABAoCCgAHAQihFAA5YusBBAoACgAHAQihFAA5YusBBAoAAA==.',Mi='Mirespike:AwABCAMABRQCCwAHAQh5BABQnXYCBAoACwAHAQh5BABQnXYCBAoAAA==.',Mo='Moonyfangs:AwABCAEABRQAAQEARz4DCAMABRQ=.Moonywings:AwADCAMABRQDAQAIAQi8AgBHPrMCBAoAAQAIAQi8AgBHPrMCBAoADAABAQhLNwAyZjAABAoAAA==.',Na='Naughtyfusëd:AwAECAIABAoAAA==.',Ne='Neutrophil:AwACCAMABAoAAA==.',Ni='Nikkaya:AwABCAEABAoAAA==.',No='Noobacleese:AwAGCA8ABAoAAA==.Nordin:AwABCAEABAoAAQIAAAAFCAUABAo=.',['N�']='Nÿmera:AwAECAcABAoAAA==.',Os='Ostorm:AwACCAMABAoAAA==.',Pb='Pbmage:AwABCAEABAoAAA==.',Pe='Percocetpete:AwAICBoABAoEBwAIAQi6BwBRZqACBAoABwAIAQi6BwBRZqACBAoABgABAQiIQABVKmAABAoABQABAQhlTABIfE0ABAoAAQ0AJaYDCAcABRQ=.',Ph='Phaet:AwABCAMABRQDDgAHAQhVDgBVC4gCBAoADgAHAQhVDgBUpIgCBAoADwABAQj5NABceWQABAoAAA==.',Pu='Pumptron:AwAGCA8ABAoAAA==.',Ra='Rampant:AwACCAIABAoAAA==.Randalore:AwAHCBQABAoCDQAHAQjrLQAt+LIBBAoADQAHAQjrLQAt+LIBBAoAAQsAUeEICBwABAo=.Ratherton:AwADCAUABAoAAA==.',Re='Redasurk:AwABCAEABAoAAA==.Resoluteone:AwAGCAEABAoAAA==.Revytwohand:AwABCAMABRQCCgAHAQixDgBNcUUCBAoACgAHAQixDgBNcUUCBAoAAA==.',Ro='Rohdey:AwABCAEABRQCEAAGAQj8HAAuqjUBBAoAEAAGAQj8HAAuqjUBBAoAAA==.',Sa='Sabeladys:AwAGCA8ABAoAAA==.Sardogobo:AwAFCAEABAoAAA==.',Se='Sekio:AwAGCBAABAoAAA==.Sepultra:AwAGCAYABAoAAA==.',Sh='Shotzy:AwABCAEABRQAAA==.Shàdow:AwABCAEABRQAAA==.',Sm='Smellyy:AwABCAIABAoAAA==.',So='Soifure:AwADCAMABAoAAQIAAAAFCAYABAo=.',Te='Tenssid:AwADCAMABAoAAA==.',Ts='Tsen:AwAFCAoABAoAAA==.',Tw='Tworu:AwACCAIABAoAAA==.',Ty='Typicaldrood:AwACCAIABAoAAA==.',Ul='Ulysius:AwAGCAIABAoAAA==.',Va='Vash:AwABCAMABRQCEQAHAQgQBgBUI4UCBAoAEQAHAQgQBgBUI4UCBAoAAA==.',Ve='Velaric:AwABCAEABAoAAQIAAAAGCA8ABAo=.Veldu:AwAFCAsABRQDEgAFAQgsAQAqUUIBBRQAEgAEAQgsAQAuukIBBRQAEwABAQjbEgAXNUoABRQAAA==.Vespyr:AwACCAEABAoAAA==.Vexiara:AwADCAMABAoAAQIAAAABCAEABRQ=.',Wi='Wigbiford:AwAFCAoABAoAAA==.Willee:AwAFCAcABAoAAA==.',Wy='Wyrmheal:AwABCAEABRQAAA==.',Yu='Yunart:AwAFCAwABAoAAA==.',Za='Zalará:AwAICAkABAoAAA==.',Ze='Zeaket:AwACCAIABRQCFAAIAQiJAABarC8DBAoAFAAIAQiJAABarC8DBAoAAA==.Zeçhs:AwAFCAYABAoAAA==.',Zo='Zorcan:AwACCAMABAoAAA==.',Zy='Zyr:AwABCAMABRQAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end