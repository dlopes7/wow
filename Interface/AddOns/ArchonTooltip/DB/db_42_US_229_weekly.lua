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
 local lookup = {'Hunter-BeastMastery','Hunter-Survival','Paladin-Retribution','Druid-Restoration','Druid-Balance','Unknown-Unknown','Priest-Shadow','Priest-Holy','Evoker-Preservation','Shaman-Enhancement','Shaman-Restoration','Druid-Feral','Mage-Fire','Mage-Frost','Warrior-Fury','Warrior-Arms','DeathKnight-Frost',}; local provider = {region='US',realm='Uldum',name='US',type='weekly',zone=42,date='2025-03-28',data={Aa='Aaralyn:AwACCAIABAoAAA==.',Ad='Adorean:AwAGCAwABAoAAA==.',Ak='Akaril:AwAECAEABAoAAA==.',Al='Alphabeast:AwAFCAEABAoAAA==.',Ar='Aramos:AwAECAgABAoAAA==.',As='Ashtrap:AwACCAQABRQDAQAIAQjuBgBe9jADBAoAAQAIAQjuBgBe9jADBAoAAgAFAQjIBgBHODIBBAoAAA==.',Az='Aznarak:AwADCAEABAoAAA==.Azuzu:AwABCAEABAoAAA==.',Ba='Balzorath:AwACCAEABAoAAA==.',Be='Beastmode:AwABCAIABAoAAA==.',Bl='Bloodpelt:AwABCAEABAoAAA==.Bloodwolf:AwACCAIABAoAAA==.',Bo='Bookofzeref:AwAECAQABAoAAA==.',Br='Brimscythe:AwAECAcABAoAAA==.',Bu='Bubblepriest:AwACCAUABAoAAA==.Buressra:AwAGCAkABAoAAA==.Buttexplode:AwABCAEABAoAAA==.',Ca='Carclias:AwAFCAwABAoAAA==.',Ce='Cedo:AwABCAEABAoAAA==.',Ch='Chaoscookies:AwAICAQABAoAAA==.Charc:AwADCAYABAoAAA==.Chartkov:AwACCAMABAoAAA==.',Cu='Cursedchild:AwADCAMABAoAAA==.',Da='Daciana:AwADCAUABAoAAA==.Darkeznite:AwADCAUABAoAAA==.',De='Defiasrogue:AwADCAUABAoAAA==.Delinda:AwACCAMABAoAAA==.Desmosedici:AwAHCBEABAoAAA==.',Dh='Dhargal:AwACCAIABAoAAA==.',Di='Dingdag:AwACCAIABAoAAA==.Divitiacus:AwABCAEABAoAAA==.Dixee:AwACCAIABAoAAA==.',Do='Dontmeswitme:AwADCAUABAoAAA==.',Dr='Dramar:AwABCAEABAoAAA==.Droki:AwAICBIABAoAAA==.',Es='Estralla:AwADCAUABAoAAA==.',Ev='Evocatis:AwACCAMABRQCAwAIAQhnCwBXNBADBAoAAwAIAQhnCwBXNBADBAoAAA==.',Fa='Faion:AwAGCBAABAoAAA==.',Fi='Firebirdxz:AwAFCAoABAoAAQQASgwCCAMABRQ=.Firebirdz:AwACCAMABRQDBAAIAQgeCQBKDGkCBAoABAAIAQgeCQBKDGkCBAoABQAFAQiJJgBNTZ8BBAoAAA==.Fizzledust:AwAICAgABAoAAA==.',Fr='Frostfever:AwADCAQABAoAAQMAVAEBCAIABRQ=.',Fu='Fuzzybut:AwACCAIABAoAAA==.',Ga='Gark:AwACCAMABAoAAA==.',Go='Gondra:AwAFCAcABAoAAA==.',Ha='Hagarn:AwAHCAoABAoAAA==.Hairybasil:AwABCAEABAoAAA==.',He='Hexmachine:AwAICAIABAoAAA==.',Ho='Hole:AwADCAYABAoAAA==.Holyflem:AwABCAEABAoAAA==.Holyray:AwAHCAMABAoAAA==.',Hu='Huggs:AwAFCAgABAoAAA==.',Ia='Iamahriman:AwAFCAsABAoAAA==.',In='Incognonetoo:AwAICAgABAoAAA==.',Ja='Jasindra:AwAECAQABAoAAA==.Jaxeau:AwACCAIABAoAAA==.',Ji='Jihun:AwAICBAABAoAAA==.',Ka='Kaala:AwAGCAEABAoAAA==.Kain:AwAICAwABAoAAA==.Kalron:AwAGCA0ABAoAAA==.Katio:AwABCAEABRQAAA==.',Ki='Kitchenstink:AwAGCA0ABAoAAA==.',Ko='Komosky:AwEICAgABAoAAA==.',Kr='Krapgame:AwAICAgABAoAAA==.Krelen:AwADCAQABAoAAA==.',Ku='Kurnea:AwADCAUABAoAAA==.',Ld='Ldritch:AwABCAEABRQAAA==.',Li='Lianara:AwACCAIABAoAAQYAAAACCAMABAo=.Lightmin:AwAGCA0ABAoAAA==.',Lo='Lore:AwAHCBMABAoAAA==.',Ly='Lyannastark:AwABCAIABRQDBwAIAQgKHQAy5nEBBAoABwAFAQgKHQBCwXEBBAoACAAFAQgqKAAyh0MBBAoAAA==.',Ma='Makaze:AwACCAEABAoAAA==.Malachor:AwABCAEABAoAAQYAAAAFCAkABAo=.Malfurìon:AwAICBIABAoAAA==.Manaug:AwACCAUABRQCCQACAQgJAgBJjqQABRQACQACAQgJAgBJjqQABRQAAA==.',Mc='Mccholock:AwACCAIABAoAAA==.Mcmach:AwADCAUABAoAAA==.',Me='Menoah:AwADCAUABAoAAA==.Metaabuse:AwACCAIABAoAAA==.',Mi='Miniaka:AwAGCAkABAoAAA==.',Mo='Monichan:AwACCAIABAoAAA==.Monkeyd:AwABCAIABRQDCgAIAQgSCgBUpaECBAoACgAHAQgSCgBXjKECBAoACwABAQi6bwA0AkQABAoAAA==.',Mu='Murazor:AwABCAEABAoAAA==.',Na='Natzukamu:AwABCAIABRQDBQAIAQhkDgBNh5YCBAoABQAHAQhkDgBWb5YCBAoABAACAQhaPwA2x4oABAoAAA==.',No='Norr:AwACCAUABAoAAA==.Notdeadyet:AwACCAIABAoAAA==.',Nu='Nuthar:AwAFCAoABAoAAA==.',Ny='Nyseria:AwAECAQABAoAAA==.',Oa='Oakarm:AwAICAgABAoAAA==.',Ob='Objammin:AwAECAQABAoAAA==.',On='Onetoughson:AwAFCAkABAoAAA==.Ontherun:AwADCAEABAoAAA==.',Os='Oscarguydude:AwAFCAUABAoAAA==.',Pe='Pele:AwACCAMABAoAAA==.',Pu='Puffypanda:AwABCAEABAoAAA==.',Ra='Raeris:AwAHCAcABAoAAA==.Ratio:AwACCAIABAoAAA==.',Ri='Ripdvanwinkl:AwADCAEABAoAAA==.',Ro='Ronyn:AwAGCAUABAoAAA==.',Ru='Ruden:AwAFCAkABAoAAA==.Ruxl:AwAECAgABAoAAA==.',Sa='Saintorum:AwAECAMABAoAAA==.Salin:AwABCAEABAoAAA==.Sammiya:AwACCAIABAoAAA==.Sarah:AwABCAEABAoAAQYAAAAFCAwABAo=.Sarthy:AwABCAIABRQCAwAIAQhhFQBUAbwCBAoAAwAIAQhhFQBUAbwCBAoAAA==.',Sc='Scoobydo:AwACCAMABAoAAQYAAAADCAkABAo=.Scrubs:AwAICBYABAoCAQAIAQi0IAA3OEcCBAoAAQAIAQi0IAA3OEcCBAoAAA==.',Sh='Shadius:AwADCAEABAoAAQwAQ/4BCAEABRQ=.Shiel:AwACCAIABAoAAA==.',Sl='Sleples:AwADCAkABAoAAA==.Sleyalias:AwACCAIABAoAAA==.',St='Stormlight:AwADCAUABAoAAA==.Strength:AwAFCA8ABAoAAA==.',Sy='Syland:AwACCAIABAoAAA==.',Ta='Taalix:AwADCAQABRQDDQAIAQgVCQBUYvECBAoADQAIAQgVCQBUYvECBAoADgABAQiiZABW2kwABAoAAA==.Taintsploof:AwAECAQABAoAAA==.',Te='Temnyy:AwAHCBEABAoAAA==.Tenma:AwAGCA0ABAoAAA==.Teyrah:AwAFCAQABAoAAA==.',Ti='Tinkerella:AwADCAUABAoAAA==.',To='Topsteak:AwABCAEABAoAAA==.Totem:AwAGCBMABAoAAA==.',Tr='Trupeti:AwADCAEABAoAAA==.',Tw='Twodogz:AwACCAQABRQDDwAIAQjvBwBbP+MCBAoADwAIAQjvBwBaBOMCBAoAEAAEAQjnFgBcooEBBAoAAA==.',Ul='Ulanmage:AwADCAUABAoAAA==.',Va='Valguero:AwADCAUABAoAAA==.Vamire:AwAICAgABAoAAA==.Vandath:AwAICAgABAoAAA==.',Ve='Vemju:AwACCAIABAoAAA==.',Vo='Voided:AwAHCBUABAoCEQAHAQinAwBUCpMCBAoAEQAHAQinAwBUCpMCBAoAAA==.Vorkath:AwAGCBMABAoAAA==.',Vt='Vtae:AwADCAUABAoAAA==.',We='Werehamster:AwADCAYABAoAAA==.',Wi='Widdershins:AwAFCAcABAoAAA==.',Xa='Xaelin:AwACCAIABAoAAA==.',Ya='Yamoro:AwADCAQABAoAAA==.',Yo='Yoshymi:AwAECAcABAoAAA==.',Za='Zarra:AwACCAMABAoAAA==.',Zo='Zocorro:AwACCAMABAoAAA==.Zodiack:AwAICAgABAoAAA==.',['ß']='ßloodbag:AwAICAgABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end