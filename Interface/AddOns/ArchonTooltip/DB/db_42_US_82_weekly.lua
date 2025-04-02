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
 local lookup = {'Unknown-Unknown','Paladin-Retribution','Rogue-Assassination','Mage-Frost','Druid-Balance',}; local provider = {region='US',realm='Duskwood',name='US',type='weekly',zone=42,date='2025-03-29',data={Ae='Aedrias:AwAECAcABAoAAA==.Aegennai:AwADCAcABAoAAA==.Aegon:AwADCAIABAoAAA==.',Ag='Agilaz:AwADCAIABAoAAA==.',Al='Albinism:AwACCAMABAoAAA==.',Ar='Arccane:AwADCAMABAoAAA==.Aristaeus:AwACCAIABAoAAA==.Arsønx:AwAECAYABAoAAA==.',As='Ashlyr:AwAECAEABAoAAA==.',Ba='Baconpancake:AwAICAkABAoAAA==.',Be='Bearforceone:AwAECAQABAoAAQEAAAAGCBIABAo=.',Bl='Bloodsharp:AwACCAMABAoAAA==.Blusoleil:AwABCAEABAoAAA==.',Bo='Bonilla:AwABCAEABRQAAA==.',Br='Brownycake:AwACCAMABAoAAA==.',Ch='Chüngüs:AwACCAMABAoAAA==.',['C�']='Cårdinål:AwAFCAwABAoAAA==.Cônstantîne:AwABCAEABAoAAA==.',Da='Daeroth:AwAECAcABAoAAA==.',De='Deathdoodles:AwADCAUABAoAAA==.',Dr='Dragondude:AwAECAEABAoAAA==.Drunkenbrew:AwAECAcABAoAAA==.',Dy='Dyelin:AwAECAEABAoAAA==.',El='Elyron:AwAECAEABAoAAA==.',Fa='Fakename:AwAECAEABAoAAA==.Fangstorm:AwAECAEABAoAAA==.',Fe='Felbane:AwAGCA4ABAoAAA==.',Fi='Fistmé:AwAICBAABAoAAQIAROEICBcABAo=.',Fo='Fondera:AwABCAEABAoAAA==.',Gi='Gideòn:AwAICA8ABAoAAA==.',Gr='Gravitea:AwAECAYABAoAAA==.Greatchez:AwAECAgABAoAAA==.Grumpyoltrol:AwABCAEABAoAAA==.',Gu='Gudge:AwAFCAkABAoAAA==.Gummypenguin:AwAHCA0ABAoAAA==.Gumpers:AwADCAEABAoAAQEAAAAECAQABAo=.',Ha='Hadhox:AwADCAYABAoAAA==.Hanok:AwADCAMABAoAAQEAAAAECAEABAo=.Hathdox:AwABCAEABAoAAQEAAAADCAYABAo=.Hazelnoot:AwAGCAwABAoAAA==.',He='Hexcist:AwADCAEABAoAAA==.',Ho='Hollyanne:AwAECAEABAoAAA==.',In='Insaint:AwAFCAwABAoAAA==.',Ir='Irog:AwAECAEABAoAAA==.Ironfield:AwADCAgABAoAAA==.',Ja='Jaboi:AwAECAkABAoAAA==.',Je='Jetta:AwACCAMABAoAAA==.Jezzak:AwADCAUABAoAAA==.',Jp='Jpn:AwACCAIABAoAAQEAAAAFCAUABAo=.',Ka='Karev:AwAHCAcABAoAAA==.',Ke='Keho:AwACCAIABAoAAA==.',Ki='Kiascendance:AwADCAIABAoAAQEAAAAFCAoABAo=.Killerpluto:AwAHCBUABAoCAwAHAQggDQA2KtkBBAoAAwAHAQggDQA2KtkBBAoAAA==.Kindred:AwACCAMABAoAAA==.',Ko='Koriane:AwABCAEABAoAAA==.Korxon:AwADCAEABAoAAA==.',La='Lanaria:AwABCAEABAoAAA==.',Ma='Macarius:AwAECAUABAoAAA==.Malestrom:AwADCAUABAoAAA==.Maria:AwAECAYABAoAAA==.Matile:AwAGCAkABAoAAA==.',Me='Mercc:AwAGCAEABAoAAA==.',Mo='Mokuer:AwABCAEABAoAAQEAAAAFCA8ABAo=.Mooshaman:AwAGCBAABAoAAA==.',Mu='Mustevistust:AwACCAIABAoAAA==.',Na='Nariyeth:AwAFCAkABAoAAA==.',No='Noriisa:AwAECAYABAoAAA==.',Pa='Panduh:AwAHCBUABAoCBAAHAQhLCQBULKYCBAoABAAHAQhLCQBULKYCBAoAAA==.Pariousa:AwAHCBYABAoCAwAHAQjfAgBgNf0CBAoAAwAHAQjfAgBgNf0CBAoAAA==.',Pi='Picklelicker:AwACCAQABAoAAA==.Pinguo:AwAHCA4ABAoAAA==.Pinkfu:AwAFCAwABAoAAA==.',Pl='Plaguedheals:AwAECAQABAoAAA==.',Po='Potangwang:AwABCAEABAoAAA==.',Pr='Pray:AwACCAIABAoAAA==.Prim:AwABCAEABAoAAA==.',['P�']='Pöpe:AwAECAQABAoAAA==.',Ra='Raleria:AwADCAEABAoAAA==.',Re='Reemo:AwAECAIABAoAAA==.',Sa='Sanats:AwABCAEABAoAAA==.Sarazah:AwABCAMABRQAAA==.',Se='Seraphina:AwADCAcABAoAAA==.Serein:AwAECAEABAoAAA==.',Sh='Shadowdoobie:AwAFCAEABAoAAA==.Shinkickerr:AwAFCAoABAoAAA==.',Si='Sikihtsisoo:AwAECAYABAoAAA==.',Sk='Skarbrand:AwAECAEABAoAAA==.',So='Solarbubble:AwAICBcABAoCAgAIAQhOIABE4XsCBAoAAgAIAQhOIABE4XsCBAoAAA==.',St='Stonespinner:AwEICAgABAoAAA==.',Su='Sunforge:AwAECAUABAoAAA==.',Ta='Taldieth:AwABCAEABAoAAA==.Taurasst:AwAGCAkABAoAAA==.',Te='Teetau:AwAECAEABAoAAA==.',Th='Thaddeusz:AwAECAEABAoAAA==.Thickheaded:AwAECAQABAoAAA==.',To='Toxix:AwACCAMABAoAAA==.',Ty='Tychesham:AwADCAMABAoAAQUAR4cCCAIABRQ=.',Ur='Urdeadtoo:AwADCAMABAoAAA==.',Va='Val:AwAECAQABAoAAA==.Varnzdort:AwADCAMABAoAAA==.',Vi='Vinsteam:AwABCAEABAoAAA==.',Vl='Vlarett:AwAGCBEABAoAAA==.',Vo='Vollken:AwABCAEABAoAAA==.',Xe='Xerxeis:AwADCAMABAoAAA==.',Xz='Xz:AwADCAYABAoAAA==.',Za='Zaiyra:AwACCAMABAoAAA==.',Zu='Zugara:AwACCAIABAoAAQEAAAACCAMABAo=.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end