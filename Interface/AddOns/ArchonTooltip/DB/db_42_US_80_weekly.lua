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
 local lookup = {'Mage-Fire','Mage-Arcane','Monk-Mistweaver','Paladin-Retribution','Warrior-Fury',}; local provider = {region='US',realm='Dunemaul',name='US',type='weekly',zone=42,date='2025-03-29',data={Al='Allice:AwAECAQABAoAAA==.',Ar='Arianthela:AwAECAkABAoAAA==.',Av='Avenge:AwADCAUABAoAAA==.',Ba='Bandobras:AwADCAMABAoAAA==.',Bl='Bloom:AwADCAMABRQAAA==.',Br='Broken:AwABCAEABAoAAA==.',Cr='Cryface:AwACCAIABAoAAA==.',De='Deadmochi:AwACCAIABAoAAA==.Deathdylan:AwAGCAMABAoAAA==.Demonikal:AwACCAIABAoAAA==.',Do='Doryu:AwAGCA4ABAoAAA==.',El='Eldin:AwADCAMABAoAAA==.',En='Enchantress:AwAFCAEABAoAAA==.Enro:AwAGCAMABAoAAA==.',Et='Etc:AwAFCAoABAoAAA==.',Fo='Foodex:AwAGCAQABAoAAA==.Fourleaf:AwAGCAMABAoAAA==.',Fr='Freemason:AwACCAIABAoAAA==.Frogplushy:AwACCAIABRQDAQAIAQgKBgBb/SADBAoAAQAIAQgKBgBb/SADBAoAAgABAQizDgA2izMABAoAAA==.',Gr='Grimthecruel:AwACCAIABAoAAA==.',Jo='Job:AwAHCAMABAoAAA==.',Ju='Junkyard:AwACCAIABAoAAA==.',Ka='Kaimin:AwADCAEABAoAAA==.Karthas:AwADCAcABAoAAA==.',Ku='Kutkal:AwAFCAMABAoAAA==.',Ky='Kyofu:AwAFCAIABAoAAA==.',La='Laria:AwABCAIABRQAAA==.',Li='Lightbright:AwAGCAMABAoAAA==.Lilbeefcake:AwABCAEABAoAAA==.',Lu='Lumpyoatmeal:AwAGCAkABAoAAA==.Lushetti:AwAICAYABAoAAA==.',Mo='Modelavenged:AwAECAMABAoAAA==.Modeletc:AwABCAEABAoAAA==.Moonsïnd:AwAGCAMABAoAAA==.',Na='Nalthexon:AwAGCA8ABAoAAA==.',Ne='Neko:AwAICBQABAoCAwAIAQh9GwAvYMcBBAoAAwAIAQh9GwAvYMcBBAoAAA==.',Ni='Nitwp:AwAGCAMABAoAAA==.',Om='Omnisllash:AwAGCAgABAoAAA==.',Pe='Pebblicious:AwADCAUABAoAAA==.',Ph='Pharisaic:AwABCAEABRQAAA==.',Pi='Pillin:AwABCAEABAoAAA==.',Pr='Provi:AwACCAIABAoAAA==.',Re='Rezkin:AwABCAEABRQDAgAIAQhFAQBGCIICBAoAAgAIAQhFAQBGCIICBAoAAQABAQiCbwAPzDgABAoAAA==.',Rh='Rhoadii:AwABCAIABRQCBAAIAQgBEwBTyNYCBAoABAAIAQgBEwBTyNYCBAoAAA==.Rhordric:AwEGCAMABAoAAA==.',Ro='Rokkitok:AwAGCAwABAoAAA==.',Sa='Sanghelli:AwACCAQABRQCBQAIAQhCAQBesmwDBAoABQAIAQhCAQBesmwDBAoAAA==.',Sh='Shadii:AwAECAUABAoAAA==.Shadowrose:AwADCAMABAoAAA==.',Si='Silchas:AwADCAEABAoAAA==.Siley:AwAGCAwABAoAAA==.',Sn='Sneakytrix:AwADCAMABAoAAA==.',St='Stinkypanda:AwABCAIABRQCAwAHAQgRFQA/6gkCBAoAAwAHAQgRFQA/6gkCBAoAAA==.',Tr='Triplenine:AwAECAgABAoAAQIAVT4CCAQABRQ=.',Tw='Twanshin:AwAECAEABAoAAA==.',Va='Valgorath:AwADCAIABAoAAA==.',Ve='Venetrazat:AwAFCAoABAoAAA==.',Wa='Warder:AwACCAMABAoAAA==.',Za='Zackman:AwAGCAMABAoAAA==.',Zo='Zolttor:AwAGCA8ABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end