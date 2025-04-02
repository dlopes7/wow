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
 local lookup = {'DeathKnight-Blood','Hunter-BeastMastery','Hunter-Survival','Monk-Mistweaver','Mage-Frost','Paladin-Retribution','Rogue-Subtlety','Shaman-Restoration','Evoker-Devastation','Evoker-Preservation','Rogue-Assassination','DemonHunter-Havoc','Shaman-Elemental','Unknown-Unknown','Druid-Guardian',}; local provider = {region='US',realm='Hydraxis',name='US',type='weekly',zone=42,date='2025-03-29',data={Am='Amathushhg:AwAFCAwABAoAAA==.',Ar='Arnold:AwABCAIABAoAAA==.',Ba='Baelhal:AwABCAIABRQCAQAIAQhBGwAaUUgBBAoAAQAIAQhBGwAaUUgBBAoAAA==.',Bi='Birthday:AwAECAQABAoAAA==.',Bo='Bonekrusher:AwAFCAgABAoAAA==.Boomkimi:AwAGCAsABAoAAA==.Boosiferr:AwACCAMABAoAAA==.',Br='Broimos:AwAECAEABAoAAA==.Bryce:AwAICBMABAoAAA==.',['B�']='Bóunty:AwABCAEABRQDAgAHAQhFGQBYAI0CBAoAAgAHAQhFGQBYAI0CBAoAAwADAQj0DAAxfJMABAoAAA==.',Ca='Caista:AwABCAEABAoAAA==.Caltrific:AwAGCA8ABAoAAA==.Caltrn:AwACCAIABAoAAA==.Campskizzle:AwABCAEABRQAAA==.Catatonia:AwABCAEABRQAAA==.',Ch='Chisa:AwAFCA0ABAoAAA==.',Cl='Clenton:AwAGCBMABAoAAA==.',Da='Darkbrew:AwACCAMABAoAAA==.Darkshard:AwADCAQABAoAAA==.',De='Depression:AwAICAgABAoAAA==.',Di='Diddlecog:AwAICAQABAoAAA==.',Do='Donaldpump:AwAICAgABAoAAA==.Downritemonk:AwEBCAIABRQCBAAIAQh7CQBJSqwCBAoABAAIAQh7CQBJSqwCBAoAAA==.',El='Elgatõ:AwABCAEABAoAAA==.Elizardeth:AwADCAUABAoAAA==.',Er='Erany:AwADCAUABAoAAA==.',Es='Escaper:AwADCAIABAoAAA==.',Fa='Fallenembers:AwABCAIABRQCBQAIAQi5BABYEgMDBAoABQAIAQi5BABYEgMDBAoAAA==.',Fr='Frenchtoast:AwAICAgABAoAAA==.',Ga='Garius:AwABCAEABAoAAA==.',Gu='Gustwin:AwAECAgABAoAAA==.',He='Hellfar:AwADCAQABAoAAA==.',Ho='Holypopnlock:AwAECAcABAoAAA==.Holyrain:AwAECAIABAoAAA==.Hondojoe:AwAGCAoABAoAAA==.Hopewell:AwACCAIABAoAAA==.',Jh='Jhae:AwAFCAMABAoAAA==.',Jo='Jourdan:AwABCAEABRQCBgAIAQjxLwA4niwCBAoABgAIAQjxLwA4niwCBAoAAA==.',Ka='Kajax:AwAGCBUABAoCBwAGAQi1EABHWtoBBAoABwAGAQi1EABHWtoBBAoAAA==.Katze:AwAICAEABAoAAA==.',Ki='Kimiasa:AwADCAEABAoAAA==.',Kr='Kraken:AwACCAUABAoAAA==.',Ky='Kyramgalaar:AwAFCAYABAoAAA==.',Li='Lianolaura:AwADCAQABAoAAA==.',Ma='Maavarra:AwADCAYABAoAAA==.Maimgame:AwAHCAEABAoAAA==.',Mi='Misericorde:AwAHCBMABAoAAA==.',My='Mydarling:AwAGCA8ABAoAAA==.Mymoon:AwABCAEABAoAAA==.',Na='Nark:AwADCAUABAoAAA==.',Ni='Nikodemus:AwAHCBMABAoAAA==.Ninetoads:AwABCAIABRQCCAAIAQgzBgBU5N8CBAoACAAIAQgzBgBU5N8CBAoAAA==.',No='Nohzul:AwAFCAkABAoAAA==.',Or='Orym:AwADCAMABAoAAA==.',Pa='Pallythetank:AwACCAQABAoAAA==.',Pu='Pulsebas:AwAFCAkABAoAAA==.',Ra='Rancidity:AwAHCAcABAoAAA==.Ratdamon:AwABCAEABAoAAA==.',Ri='Riordan:AwAECA0ABAoAAA==.',Ro='Rockriver:AwAFCAEABAoAAA==.Rothema:AwACCAMABAoAAA==.',Ru='Rungdungus:AwADCAcABAoAAA==.',Ry='Rynzia:AwABCAIABRQDCQAIAQj5DwBETwACBAoACQAHAQj5DwBBQQACBAoACgACAQiQGgAQW1QABAoAAA==.',Sa='Sambo:AwADCAQABAoAAA==.',Sc='Scerra:AwAGCAEABAoAAA==.Schaeffer:AwAGCBAABAoAAA==.',Se='Seviran:AwAICBEABAoAAA==.',Sh='Shwabeary:AwADCAUABAoAAA==.',Sm='Smallmonk:AwAGCA0ABAoAAA==.',Sn='Sneakysoul:AwABCAIABRQCCwAIAQi2BABM/rsCBAoACwAIAQi2BABM/rsCBAoAAA==.',Sp='Spartaaxd:AwAFCAEABAoAAA==.',Sw='Swiftleaf:AwACCAIABAoAAA==.',Ta='Tagalorc:AwACCAIABAoAAA==.Talto:AwADCAYABAoAAA==.',Th='Thelegendáry:AwAECAkABAoAAA==.Themigrant:AwAECAIABAoAAA==.',Va='Vandenar:AwABCAEABAoAAA==.Vanesh:AwABCAEABRQCDAAHAQh8DgBYxsACBAoADAAHAQh8DgBYxsACBAoAAA==.',Ve='Vellii:AwAFCA8ABAoAAA==.Veloth:AwAECAYABAoAAA==.',Vi='Viviera:AwADCAIABAoAAA==.',Wi='Wildheart:AwACCAMABAoAAA==.',Za='Zaledron:AwABCAEABAoAAA==.',Zj='Zjaffacakes:AwAHCBUABAoCDQAHAQh0DwBJdTwCBAoADQAHAQh0DwBJdTwCBAoAAQ4AAAAICAQABAo=.',Zu='Zultan:AwAECAUABAoAAA==.Zurrik:AwABCAIABRQCDwAIAQiDAgBColACBAoADwAIAQiDAgBColACBAoAAA==.',['Ä']='Ärtísãñwû:AwABCAEABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end