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
 local lookup = {'Warlock-Affliction','Hunter-BeastMastery','Unknown-Unknown','Paladin-Holy','Paladin-Retribution','Paladin-Protection','Priest-Discipline','Shaman-Enhancement','Druid-Restoration','Mage-Frost','Evoker-Preservation','DemonHunter-Havoc','Priest-Shadow','Hunter-Survival','Monk-Mistweaver','Monk-Brewmaster','Warrior-Protection','Warrior-Arms',}; local provider = {region='US',realm='Dawnbringer',name='US',type='weekly',zone=42,date='2025-03-29',data={Ab='Abdalhazred:AwABCAMABRQCAQAHAQjSAQBXJZUCBAoAAQAHAQjSAQBXJZUCBAoAAA==.Abilus:AwACCAIABAoAAA==.',Ai='Aithanar:AwAGCAEABAoAAA==.Aitheron:AwABCAEABRQAAA==.',Aq='Aqurala:AwAECAkABAoAAA==.',Ar='Aravenn:AwAGCBQABAoCAgAGAQj9QAA7gJABBAoAAgAGAQj9QAA7gJABBAoAAA==.Arealis:AwAFCAEABAoAAQMAAAAGCAEABAo=.',At='Atlantæn:AwACCAEABAoAAA==.',Av='Avylastorica:AwACCAIABAoAAA==.',['A�']='Aísling:AwACCAMABAoAAA==.',Be='Bekabeka:AwABCAMABRQEBAAHAQi/FQAmBlYBBAoABAAGAQi/FQAp+1YBBAoABQAFAQiucgAy9D8BBAoABgABAQheQgAIexcABAoAAA==.Benerrarros:AwACCAMABRQCBwAHAQhRAwBgVAYDBAoABwAHAQhRAwBgVAYDBAoAAA==.Bera:AwAICAIABAoAAA==.Bergamot:AwACCAMABAoAAA==.',Bi='Billybobjr:AwABCAIABAoAAA==.',Br='Brynhild:AwAECAQABAoAAA==.',Ca='Cacellice:AwADCAYABAoAAA==.Callout:AwACCAIABAoAAA==.',Ch='Cheekclap:AwAECAcABAoAAA==.Cheery:AwACCAMABAoAAA==.Chidõri:AwABCAIABRQCCAAHAQgfCgBVZaUCBAoACAAHAQgfCgBVZaUCBAoAAA==.Chobie:AwACCAIABAoAAA==.',Cy='Cyralai:AwABCAEABRQCCQAGAQgWDQBTUS0CBAoACQAGAQgWDQBTUS0CBAoAAA==.',Da='Dankley:AwACCAEABAoAAA==.Daoko:AwABCAIABRQCCgAIAQgyCABMwLkCBAoACgAIAQgyCABMwLkCBAoAAA==.',Du='Duskstrider:AwACCAMABAoAAA==.',Em='Emmel:AwACCAQABAoAAA==.',Er='Eromir:AwADCAMABAoAAA==.',Fe='Ferrus:AwABCAEABRQAAA==.',Fo='Foundyou:AwAFCAwABAoAAA==.',Fu='Fuzzybeard:AwADCAIABAoAAA==.',Ga='Garlic:AwABCAEABAoAAA==.',Go='Goofy:AwAFCAkABAoAAA==.Gorlo:AwADCAMABAoAAA==.',Gr='Grundle:AwADCAMABAoAAA==.',Gu='Gunduin:AwABCAEABRQAAA==.',Ha='Halabel:AwEFCAUABAoAAA==.',He='Hearthzilla:AwAHCAMABAoAAA==.',Ho='Hots:AwABCAMABRQAAA==.',In='Injection:AwADCAUABAoAAA==.',Iv='Ivey:AwAFCA4ABAoAAA==.',Ja='Jarnevous:AwAFCAYABAoAAA==.Jaylenbrown:AwABCAEABAoAAA==.',Je='Jesanie:AwAFCAsABAoAAA==.',Jo='Jordanmainz:AwACCAMABAoAAA==.',Ka='Kakusu:AwAFCAIABAoAAA==.Kakuta:AwAECAgABAoAAQMAAAABCAEABRQ=.Kakutå:AwABCAEABRQAAA==.Kalium:AwADCAUABAoAAA==.',Kk='Kkrown:AwAECAQABAoAAA==.',Ko='Kobbaltcilar:AwAECAIABAoAAA==.Korbo:AwACCAMABAoAAA==.Korbulo:AwADCAkABAoAAA==.',Ku='Kungfuuy:AwAFCAsABAoAAA==.',La='Lav:AwEGCAgABAoAAA==.',Li='Lichlord:AwACCAEABAoAAA==.Lightboi:AwAECAUABAoAAA==.',Ma='Maetromundo:AwABCAEABAoAAA==.Maliboo:AwAGCAIABAoAAA==.Mapple:AwAHCAEABAoAAA==.Marblefox:AwAGCAIABAoAAA==.Maxamus:AwADCAYABAoAAA==.',Mo='Modifiedmix:AwAECAwABAoAAA==.Mooncows:AwAFCAEABAoAAA==.Morella:AwAHCBMABAoAAA==.Moòn:AwABCAIABAoAAA==.',Mu='Mustakrakish:AwABCAMABRQCCwAHAQgCBQBJAk0CBAoACwAHAQgCBQBJAk0CBAoAAA==.',My='Mystych:AwAECAkABAoAAA==.',Na='Nanatsusaya:AwAFCAwABAoAAA==.Naste:AwABCAEABRQAAA==.Nattyfrixz:AwAGCA0ABAoAAA==.',Ni='Nightbird:AwAGCAIABAoAAA==.',Ob='Obsedien:AwAGCAIABAoAAA==.',Ok='Oktobra:AwADCAUABAoAAA==.',Ol='Olivegarden:AwACCAMABAoAAA==.',On='Onos:AwADCAMABAoAAA==.',Os='Osenya:AwABCAIABRQCDAAIAQiIDQBUq80CBAoADAAIAQiIDQBUq80CBAoAAA==.',Pa='Palantyr:AwAHCBIABAoAAA==.Patrak:AwACCAEABAoAAA==.',Pi='Picklemorty:AwABCAEABRQAAA==.',Ra='Razuki:AwADCAIABAoAAA==.',Rh='Rhileyy:AwAECAYABAoAAA==.',Ri='Rika:AwACCAIABAoAAA==.',Ro='Roserogue:AwEHCBAABAoAAQ0ANTYDCAYABRQ=.Roseshambo:AwEGCAsABAoAAQ0ANTYDCAYABRQ=.',Sa='Saintsfear:AwACCAMABAoAAA==.Sareenastar:AwAGCAIABAoAAA==.',Sc='Scorpagus:AwAECAoABAoAAA==.',Se='Sekhmet:AwAGCAwABAoAAA==.',Sh='Shakey:AwADCAkABAoAAA==.Sheraa:AwACCAMABAoAAA==.Shingye:AwABCAIABAoAAA==.Shoom:AwACCAMABAoAAA==.',Si='Sinbåd:AwAECAYABAoAAA==.',So='Sorean:AwAICBcABAoDDgAIAQgNBQBH144BBAoAAgAIAQivLgA4r/QBBAoADgAFAQgNBQBGc44BBAoAAA==.Soxx:AwAECAYABAoAAA==.',Sp='Spritezero:AwAECAYABAoAAA==.',Su='Supitsron:AwAICAgABAoCDwAIAQgEYgABaDwABAoADwAIAQgEYgABaDwABAoAAA==.',Ta='Tarmalok:AwABCAMABRQCEAAHAQgDBwA6nckBBAoAEAAHAQgDBwA6nckBBAoAAA==.',Th='Thromar:AwABCAEABRQAAA==.',Tr='Treekeg:AwAGCA0ABAoAAA==.',Va='Valock:AwACCAIABAoAAA==.Vanderin:AwACCAIABAoAAA==.',Vy='Vyx:AwACCAMABAoAAA==.',Xa='Xaiosk:AwABCAEABRQAAA==.',Xe='Xeneus:AwAFCAQABAoAAQwAVKsBCAIABRQ=.',['X�']='Xíe:AwAICAUABAoDEQADAQiZFgA6gLwABAoAEQADAQiZFgA6PLwABAoAEgACAQjHOgAVWFUABAoAAA==.',Ye='Yes:AwABCAEABRQAAA==.',Yu='Yuzu:AwABCAEABRQAAQMAAAABCAEABRQ=.',Zu='Zuga:AwAGCAEABAoAAA==.',['Ð']='Ðark:AwABCAEABRQCAgAHAQixJQBL9y4CBAoAAgAHAQixJQBL9y4CBAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end