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
 local lookup = {'Druid-Restoration','DeathKnight-Unholy','Unknown-Unknown','Mage-Fire','Mage-Arcane','Warlock-Affliction','Warlock-Demonology','Warlock-Destruction','Paladin-Retribution','Hunter-BeastMastery','Paladin-Protection','Mage-Frost','Shaman-Elemental','Shaman-Enhancement','Warrior-Fury',}; local provider = {region='US',realm='Eonar',name='US',type='weekly',zone=42,date='2025-03-29',data={Ai='Aidra:AwAICAgABAoAAA==.Ailesía:AwACCAIABRQCAQAIAQhVDgBDnxoCBAoAAQAIAQhVDgBDnxoCBAoAAA==.',Al='Alatheena:AwAHCBYABAoCAgAHAQhHEQBM0VMCBAoAAgAHAQhHEQBM0VMCBAoAAA==.Albinoz:AwAHCBEABAoAAA==.',Az='Azaleh:AwAGCAwABAoAAA==.',Be='Beloshaya:AwADCAEABAoAAA==.',Bl='Blobsz:AwACCAMABAoAAA==.',Bo='Bonesentinel:AwAHCBIABAoAAA==.Borzoi:AwAFCAUABAoAAA==.',Ca='Catchvoker:AwAICAgABAoAAA==.Cattlesdaddy:AwADCAMABAoAAQMAAAAICA0ABAo=.Caycay:AwAFCAwABAoAAA==.',Co='Cococrispies:AwADCAUABAoAAA==.',Da='Daddychill:AwAHCBEABAoAAA==.Daseymay:AwABCAEABAoAAA==.Daten:AwAECAoABAoAAA==.',De='Decayed:AwADCAMABAoAAA==.',Dr='Draktând:AwABCAEABAoAAA==.',Du='Dune:AwAGCA4ABAoAAA==.',Ea='Eatmypaws:AwAHCA8ABAoAAA==.',El='Elliyra:AwEGCBIABAoAAA==.Ellspeth:AwAGCA8ABAoAAA==.',Er='Errane:AwACCAMABRQCAQAIAQisAABgk2MDBAoAAQAIAQisAABgk2MDBAoAAA==.',Gu='Gulnn:AwAGCBMABAoAAA==.Gutsu:AwACCAIABAoAAA==.',He='Healsforu:AwAHCAcABAoAAA==.',Ho='Holythile:AwAFCA0ABAoAAA==.',Il='Illidead:AwACCAIABRQDBAAIAQhGBwBYMg8DBAoABAAIAQhGBwBYMg8DBAoABQAFAQj1BABSZkcBBAoAAA==.',In='Injection:AwAHCBUABAoEBgAHAQi9AgBa7VsCBAoABgAHAQi9AgBUzVsCBAoABwAGAQjcBABYZUQCBAoACAABAQhrgQA4ki0ABAoAAA==.',Ir='Iridiris:AwACCAIABAoAAA==.',Ja='Jabbadahut:AwAHCBQABAoCCQAHAQhuIgBSc28CBAoACQAHAQhuIgBSc28CBAoAAA==.',Ju='Justine:AwACCAQABAoAAA==.',Kr='Kravex:AwAFCAkABAoAAA==.Krixxa:AwAGCAIABAoAAA==.',La='Larayvia:AwAHCBYABAoCCgAHAQguVAAU7T0BBAoACgAHAQguVAAU7T0BBAoAAA==.Lateralis:AwAFCAgABAoAAA==.Lazerpelican:AwAGCAQABAoAAA==.',Li='Lidoria:AwADCAMABAoAAQYAWu0HCBUABAo=.Limpypal:AwAICBcABAoDCwAIAQiDCQBAZxsCBAoACwAIAQiDCQBAZxsCBAoACQABAQgLBgESICkABAoAAA==.',Ma='Maero:AwABCAEABRQAAA==.Masubi:AwAGCAoABAoAAA==.Mattingly:AwADCAMABAoAAA==.',Mo='Monkey:AwAGCAYABAoAAA==.',Ne='Nefia:AwAGCBUABAoDBAAGAQjyJgBFY88BBAoABAAGAQjyJgBEPs8BBAoADAADAQiZRgBB/ckABAoAAA==.',Ni='Nimbus:AwADCAYABRQCDQADAQikAgBAdAABBRQADQADAQikAgBAdAABBRQAAA==.',No='Notthepope:AwACCAIABRQAAA==.',Ny='Nytesage:AwAHCBQABAoCBAAHAQghGABS6lQCBAoABAAHAQghGABS6lQCBAoAAA==.',On='Onyxx:AwADCAUABAoAAA==.',Pa='Painavolian:AwAHCBEABAoAAA==.Palifur:AwAFCAgABAoAAA==.',Po='Poggies:AwACCAUABRQCBAACAQhZDQBWiroABRQABAACAQhZDQBWiroABRQAAA==.Popebenedict:AwAFCAEABAoAAA==.Popestotem:AwABCAIABRQAAQMAAAACCAIABRQ=.',Ra='Rampágé:AwAGCAsABAoAAA==.Razji:AwAGCA4ABAoAAA==.',Re='Rekaas:AwAECAQABAoAAA==.Rekd:AwAGCAsABAoAAA==.',Sa='Sadeel:AwAHCBMABAoAAA==.',Se='Seaniangnome:AwADCAQABAoAAA==.',Sh='Shadøwbøø:AwAICAYABAoAAA==.Shaggylol:AwAGCAUABAoAAA==.Shaladin:AwAICAgABAoAAA==.Shockchalk:AwABCAEABRQCDgAHAQjdDABRWHICBAoADgAHAQjdDABRWHICBAoAAA==.',Sm='Smellybeefs:AwADCAYABAoAAA==.',St='Strahm:AwAICA0ABAoAAA==.',Su='Superjinn:AwABCAEABAoAAQYAWu0HCBUABAo=.Supertree:AwACCAIABAoAAA==.',Th='Thias:AwADCAcABAoAAA==.Thicchunter:AwAHCA4ABAoAAA==.',To='Topaze:AwAECAMABAoAAA==.',Tr='Tronko:AwABCAEABAoAAA==.',Tu='Tusk:AwAHCBYABAoCDwAHAQhnEABRTnECBAoADwAHAQhnEABRTnECBAoAAA==.',Un='Unholypope:AwADCAMABAoAAQMAAAACCAIABRQ=.',Va='Valeigh:AwACCAIABAoAAA==.Valengarde:AwAFCBAABAoAAA==.',Ve='Vetsky:AwAGCAgABAoAAQMAAAAICAoABAo=.',Vi='Vizharan:AwAGCAsABAoAAA==.',Vu='Vuhlky:AwAICAgABAoAAA==.',Vy='Vyndrolan:AwACCAIABAoAAA==.',Wa='Warlas:AwACCAIABAoAAA==.',Yo='Yochangsvegn:AwAHCAkABAoAAA==.',Yu='Yukihara:AwACCAMABAoAAA==.',Za='Zake:AwAFCAQABAoAAA==.',Zu='Zulfrik:AwAFCAsABAoAAA==.',['Ë']='Ëmma:AwAGCAQABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end