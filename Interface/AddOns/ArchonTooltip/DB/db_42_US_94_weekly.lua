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
 local lookup = {'Unknown-Unknown','DemonHunter-Vengeance','Monk-Mistweaver','Paladin-Retribution','Paladin-Holy','Druid-Restoration',}; local provider = {region='US',realm='Feathermoon',name='US',type='weekly',zone=42,date='2025-03-29',data={Ab='Abduo:AwADCAgABAoAAA==.',Ad='Adamis:AwABCAEABAoAAA==.',Ae='Aellori:AwABCAEABAoAAA==.',Af='Afkinlife:AwABCAEABAoAAA==.',Al='Alandras:AwADCAYABAoAAA==.Allrianne:AwADCAQABAoAAA==.',Am='Ambilena:AwACCAEABAoAAA==.',Ap='Apollimy:AwAICAgABAoAAA==.Applebow:AwADCAYABAoAAA==.',Ar='Arenothor:AwACCAMABAoAAQEAAAADCAYABAo=.Arknova:AwACCAIABAoAAA==.',Au='Aurielia:AwAFCAoABAoAAA==.',Ba='Babygirll:AwAFCAQABAoAAA==.Battlecattle:AwADCAIABAoAAA==.',Bl='Blindfaeth:AwACCAEABAoAAA==.',Bo='Boomhauer:AwADCAYABAoAAA==.',Br='Braelia:AwACCAMABAoAAA==.Brannigan:AwADCAMABAoAAA==.',Ca='Calaul:AwABCAEABAoAAA==.Carbonn:AwAFCAQABAoAAA==.Carnivore:AwADCAQABAoAAA==.Cataryn:AwADCAMABAoAAA==.Catt:AwAECAoABAoAAA==.',Cy='Cyrr:AwAFCAYABAoAAA==.',Da='Damia:AwADCAYABAoAAA==.Darsithis:AwADCAYABAoAAA==.',De='Demzy:AwABCAEABRQCAgAIAQiaBABRGbcCBAoAAgAIAQiaBABRGbcCBAoAAA==.Dercuur:AwAECAcABAoAAA==.',Fa='Faragorn:AwADCAYABAoAAA==.',Fe='Felforyou:AwAECAQABAoAAA==.Felscythe:AwACCAQABAoAAA==.',Ga='Gaia:AwABCAEABAoAAA==.',Ge='Gelhiss:AwADCAYABAoAAA==.',Gr='Grazok:AwAECAYABAoAAA==.Grubetsella:AwAECAgABAoAAA==.Grue:AwABCAEABRQAAA==.Gruwoo:AwACCAMABAoAAQEAAAABCAEABRQ=.',Ho='Hownowbrncw:AwAECAcABAoAAA==.',Ii='Iique:AwAFCAwABAoAAA==.',Je='Jenisys:AwAICBIABAoAAA==.Jetfires:AwADCAQABAoAAA==.',Ji='Jinger:AwADCAQABAoAAA==.',Ka='Kaetta:AwAFCAgABAoAAA==.Kaliantha:AwABCAEABAoAAA==.',Ki='Killserenity:AwACCAEABAoAAA==.Kivrin:AwABCAEABAoAAA==.',Kn='Knoble:AwABCAEABAoAAA==.',Kr='Kritish:AwABCAIABRQCAwAIAQhGEgA5wCkCBAoAAwAIAQhGEgA5wCkCBAoAAA==.',Ky='Kymma:AwADCAYABAoAAA==.',Li='Lightbeard:AwACCAQABAoAAA==.',Ly='Lyshai:AwAHCBQABAoDBAAHAQi1NwBERAoCBAoABAAHAQi1NwBERAoCBAoABQAEAQhUGgBDVRsBBAoAAA==.',Ma='Magamon:AwAECAYABAoAAA==.',Me='Mediocre:AwADCAQABAoAAA==.Memy:AwACCAEABAoAAA==.',Mi='Mixler:AwAECAIABAoAAA==.',Mo='Moonflowers:AwABCAMABRQCBgAIAQhvBABWM+ECBAoABgAIAQhvBABWM+ECBAoAAA==.Moosecrit:AwACCAQABAoAAA==.',Ne='Nezuko:AwAECAUABAoAAA==.',No='Nocmlocksoff:AwACCAEABAoAAA==.',Os='Oscarmikey:AwAFCBIABAoAAA==.',Pe='Pesch:AwAICAIABAoAAA==.',Ph='Phranknbeans:AwAFCA4ABAoAAA==.',Pi='Pixiey:AwABCAEABAoAAA==.',Re='Reven:AwAFCAQABAoAAA==.',Rh='Rhage:AwADCAUABAoAAA==.',Ro='Rowani:AwADCAYABAoAAA==.',Sa='Sanitas:AwADCAEABAoAAA==.',Sh='Shammy:AwABCAEABAoAAA==.Ships:AwAFCBAABAoAAA==.',Sk='Skibbie:AwABCAEABRQAAA==.',St='Steviejay:AwACCAQABAoAAA==.Stygy:AwABCAEABAoAAA==.',['SÃ']='SÃ­nn:AwADCAMABAoAAA==.',Ta='Tachie:AwAECAkABAoAAA==.',Th='Thaesan:AwAECAQABAoAAA==.Theistica:AwADCAYABAoAAA==.',Ut='Utheli:AwAHCA8ABAoAAA==.',Va='Valwyn:AwACCAIABAoAAA==.',Vi='Viralanomaly:AwADCAQABAoAAA==.',Vn='Vnasty:AwABCAIABRQCBAAIAQjbHQBIxYoCBAoABAAIAQjbHQBIxYoCBAoAAA==.',['VÃ']='VÃ¬:AwACCAcABAoAAA==.',Wh='Whelp:AwADCAgABAoAAA==.',Za='Zanagor:AwADCAYABAoAAA==.Zayaadh:AwAGCAYABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end