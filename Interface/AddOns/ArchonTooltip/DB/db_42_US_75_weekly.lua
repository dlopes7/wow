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
 local lookup = {'DemonHunter-Havoc','DeathKnight-Blood','Priest-Holy','Monk-Windwalker','Monk-Mistweaver','Unknown-Unknown','DeathKnight-Unholy','Druid-Restoration','Paladin-Retribution','Rogue-Assassination','Rogue-Subtlety','Evoker-Devastation','Evoker-Preservation','Priest-Shadow',}; local provider = {region='US',realm="Drak'thul",name='US',type='weekly',zone=42,date='2025-03-29',data={An='Andil:AwAECAYABAoAAA==.',Ar='Arienna:AwADCAQABAoAAA==.Arinnia:AwAFCAUABAoAAA==.',As='Astralwar:AwADCAUABAoAAA==.',Aw='Awesome:AwABCAEABAoAAQEALEcICBYABAo=.',Be='Beefypaladin:AwADCAYABAoAAA==.Belysiuh:AwADCAQABAoAAA==.',Bl='Blindwalker:AwAHCBUABAoCAgAHAQjjDQBCJQcCBAoAAgAHAQjjDQBCJQcCBAoAAA==.Blissfuleigh:AwABCAEABAoAAA==.',Br='Braistlin:AwABCAIABAoAAA==.Brielan:AwADCAEABAoAAA==.',Ca='Castigate:AwACCAIABRQAAA==.',Ch='Cheesepally:AwAFCBAABAoAAA==.',Co='Coconut:AwAGCBUABAoCAwAGAQj2HgA9q5UBBAoAAwAGAQj2HgA9q5UBBAoAAA==.',Da='Daddywarbuks:AwAECAgABAoAAA==.Dagin:AwADCAUABAoAAA==.',Do='Dominhoes:AwACCAIABAoAAA==.',Dr='Drunkmonk:AwAHCBUABAoDBAAHAQihDgBLxUYCBAoABAAHAQihDgBLxUYCBAoABQAGAQhjGQBDJ9sBBAoAAA==.',Ej='Ejreborn:AwADCAMABAoAAA==.',Es='Estarossa:AwADCAQABAoAAA==.',Fi='Firewood:AwABCAEABAoAAQYAAAACCAIABAo=.',Fr='Fryja:AwAGCAIABAoAAA==.',Gr='Grandmeta:AwAGCAsABAoAAA==.Grungos:AwABCAIABAoAAA==.',Gu='Gulpttub:AwABCAEABAoAAA==.Gungoa:AwAGCAoABAoAAA==.Gunthar:AwADCAMABAoAAA==.',Ha='Halaxel:AwADCAUABAoAAA==.Hanta:AwAGCAsABAoAAA==.',He='Healmedaddy:AwADCAcABAoAAA==.Heldarram:AwADCAcABAoAAA==.',Ho='Hotsforthots:AwADCAoABAoAAA==.',Hr='Hrizul:AwAFCAYABAoAAA==.',Jo='Jodyhiroller:AwAHCBUABAoCAQAHAQjuIgA82wMCBAoAAQAHAQjuIgA82wMCBAoAAA==.',Ka='Katamine:AwAFCA4ABAoAAA==.',Ke='Keyador:AwACCAIABAoAAA==.',Ki='Killnall:AwACCAMABAoAAA==.',Kl='Kladon:AwAGCA0ABAoAAA==.',Ko='Koreaper:AwABCAEABAoAAA==.',Kr='Krystarin:AwAECAgABAoAAA==.',Ky='Kynlada:AwABCAEABAoAAA==.',Li='Likhalo:AwACCAIABAoAAA==.',Ma='Malakaii:AwAFCAUABAoAAA==.Mazrim:AwACCAMABAoAAA==.',Me='Meliria:AwAFCAMABAoAAA==.',Mi='Mistykit:AwAECAQABAoAAA==.',Mo='Moops:AwACCAMABRQAAA==.Mordacity:AwEDCAQABAoAAA==.',Na='Nazgül:AwABCAEABRQAAA==.',Ni='Nikos:AwAECAgABAoAAA==.',No='Nordikdragon:AwAHCAUABAoAAA==.Nory:AwAICBYABAoCAQAIAQgHHwAsRyICBAoAAQAIAQgHHwAsRyICBAoAAA==.',On='Oni:AwAHCBUABAoDBwAHAQgbCgBZjrsCBAoABwAHAQgbCgBZjrsCBAoAAgABAQifQgAUIiMABAoAAA==.',Pa='Panthro:AwADCAQABAoAAA==.',Pi='Pinkylove:AwAHCBUABAoCCAAHAQiUGAA2rqQBBAoACAAHAQiUGAA2rqQBBAoAAA==.',Pl='Pluto:AwADCAIABAoAAA==.',Pr='Promathia:AwAICBUABAoCCQAHAQjOGwBTGpgCBAoACQAHAQjOGwBTGpgCBAoAAA==.Proxi:AwAECAYABAoAAA==.',Re='Redrouges:AwAFCA0ABAoAAA==.',Sa='Saltytart:AwABCAEABRQAAA==.',Sh='Shadowbann:AwADCAMABAoAAA==.Shanks:AwAICBcABAoDCgAIAQi8BgA9u30CBAoACgAIAQi8BgA9u30CBAoACwACAQj1KgAP3lwABAoAAA==.',Sl='Slothawar:AwAFCAcABAoAAA==.',So='Solei:AwAGCA0ABAoAAA==.Southernways:AwABCAEABAoAAA==.',Sp='Spider:AwAFCA8ABAoAAA==.',Sq='Squigglybutt:AwADCAYABAoAAA==.',Ta='Tallonya:AwAECAQABAoAAA==.Talsomething:AwAGCAgABAoAAA==.',Th='Thedru:AwADCAYABAoAAA==.',Tr='Treva:AwAICBYABAoDDAAIAQgwCwBLPF8CBAoADAAHAQgwCwBK3F8CBAoADQAGAQiTCQA9BbYBBAoAAA==.',Va='Valfy:AwAFCAIABAoAAA==.',Ve='Vescovo:AwADCAEABAoAAA==.',Vo='Vodyanoi:AwAICBcABAoDDgAIAQijAwBW2yEDBAoADgAIAQijAwBW2yEDBAoAAwABAQgPYQA7vjcABAoAAA==.',Wi='Wingback:AwACCAEABAoAAA==.Wispaway:AwAGCA4ABAoAAA==.',Xh='Xhenshini:AwAHCBUABAoCDAAHAQiiEwAzl74BBAoADAAHAQiiEwAzl74BBAoAAA==.',['ß']='ßob:AwACCAIABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end