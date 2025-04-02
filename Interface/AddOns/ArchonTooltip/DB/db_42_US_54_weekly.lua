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
 local lookup = {'Unknown-Unknown','DemonHunter-Vengeance','Rogue-Outlaw','DemonHunter-Havoc','Priest-Holy','Monk-Mistweaver',}; local provider = {region='US',realm='Coilfang',name='US',type='weekly',zone=42,date='2025-03-29',data={Az='Azuni:AwACCAIABAoAAA==.',Bo='Boochili:AwAHCBIABAoAAA==.',Bu='Bubblës:AwACCAIABAoAAA==.',Ch='Charlie:AwACCAIABAoAAA==.Chicken:AwAECAYABAoAAQEAAAAHCBMABAo=.',['C�']='Cätîáñdrïà:AwAHCBMABAoAAA==.',Da='Danne:AwAFCAwABAoAAA==.Darktemplar:AwABCAEABAoAAA==.',Di='Dicey:AwAHCBQABAoCAgAHAQjgDQA9NNMBBAoAAgAHAQjgDQA9NNMBBAoAAA==.',Dr='Dragoonnick:AwACCAIABAoAAA==.Drzillae:AwADCAgABAoAAQMAI4YECAcABRQ=.',Eu='Euphal:AwAFCA0ABAoAAA==.',Ey='Eyekicku:AwAGCBIABAoAAA==.',Fl='Flexicus:AwAGCAwABAoAAA==.',Go='Gohzer:AwAHCA8ABAoAAA==.',Ha='Hanora:AwABCAEABAoAAA==.Happii:AwAICBgABAoCBAAIAQgzJAAqpfkBBAoABAAIAQgzJAAqpfkBBAoAAA==.',He='Hellspawn:AwAHCBMABAoAAA==.',Hi='Hiddenblade:AwAGCAwABAoAAA==.',Ho='Hollow:AwAECAMABAoAAA==.Holygrim:AwAECAoABRQCBQAEAQhPAABUAIoBBRQABQAEAQhPAABUAIoBBRQAAA==.Howii:AwAHCBIABAoAAA==.',Is='Isabelaa:AwAGCBIABAoAAA==.',It='Itslit:AwADCAgABAoAAA==.',Jo='Johnnysins:AwAHCAQABAoAAA==.',Ka='Kakashi:AwABCAEABRQAAA==.',Kr='Krønos:AwAFCAUABAoAAA==.',Li='Litbitonme:AwABCAEABAoAAA==.',Lo='Lostmoo:AwADCAYABAoAAA==.',Ly='Lyricluna:AwAECAIABAoAAA==.',Ma='Mancëra:AwAHCBAABAoAAA==.',Me='Metchka:AwAICA8ABAoAAA==.',Mi='Midmadgenera:AwAECAoABAoAAA==.Mio:AwAHCBUABAoCBgAHAQjsDgBI8VcCBAoABgAHAQjsDgBI8VcCBAoAAA==.',Mo='Moto:AwAGCBEABAoAAA==.',Pe='Pendragon:AwADCAcABAoAAA==.Periodic:AwAHCBEABAoAAA==.',Pl='Platen:AwAGCBIABAoAAA==.',Ro='Rokyman:AwACCAEABAoAAA==.',Ry='Rynne:AwAECAcABAoAAA==.',Se='Sentinäl:AwADCAcABAoAAA==.',Sh='Shedidit:AwAECAQABAoAAA==.',Si='Silvertiger:AwAHCBMABAoAAA==.',Sz='Szeth:AwABCAEABAoAAA==.',Te='Text:AwAECAUABAoAAQEAAAAGCAwABAo=.',Vi='Viishh:AwAHCBMABAoAAA==.',Wa='Waban:AwAFCAoABAoAAA==.',Wo='Wolf:AwAHCBMABAoAAA==.',Xi='Xion:AwAFCAcABAoAAA==.',Yl='Ylit:AwAFCAYABAoAAA==.',Yo='Youdidwhat:AwABCAEABAoAAA==.',Zo='Zooberstank:AwAFCAcABAoAAQQAKqUICBgABAo=.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end