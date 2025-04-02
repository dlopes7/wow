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
 local lookup = {'Unknown-Unknown','DeathKnight-Frost','DeathKnight-Blood','DemonHunter-Havoc','DemonHunter-Vengeance','Paladin-Retribution',}; local provider = {region='US',realm='Ravenholdt',name='US',type='weekly',zone=42,date='2025-03-29',data={Ae='Aerik:AwABCAEABAoAAA==.',Ah='Ahote:AwAECAcABAoAAA==.',Ai='Airrows:AwAHCAsABAoAAA==.',Al='Alèxis:AwACCAIABAoAAA==.',Am='Ammardenicor:AwAICAgABAoAAA==.',Ar='Argonäut:AwAFCA0ABAoAAA==.',Ba='Bamfwarrior:AwAFCAkABAoAAA==.',Bk='Bk:AwAGCA0ABAoAAA==.',Br='Brickbeard:AwABCAEABAoAAA==.',Ch='Chexk:AwAHCAsABAoAAA==.',Cy='Cynthic:AwAHCAoABAoAAA==.',Da='Dabatmonmon:AwACCAIABAoAAA==.Daddio:AwAFCAYABAoAAA==.',Do='Domey:AwAICAUABAoAAA==.',Dr='Drakatoa:AwAGCAgABAoAAA==.',Dv='Dvoker:AwAFCAkABAoAAA==.',Er='Eraline:AwAGCA4ABAoAAA==.Erion:AwAGCAIABAoAAA==.',Ev='Eviternal:AwACCAIABAoAAA==.',Fe='Felscythe:AwADCAUABAoAAQEAAAAFCAMABAo=.',Fu='Fuknar:AwADCAQABAoAAA==.',Gn='Gnot:AwADCAYABAoAAA==.',Hu='Huike:AwAFCBAABAoAAA==.',Im='Impact:AwACCAIABAoAAQEAAAAFCBAABAo=.',Iw='Iwantmore:AwAFCAwABAoAAA==.',Jo='Joebison:AwADCAMABAoAAA==.',Ka='Kangaxx:AwEFCAoABAoAAA==.',Ki='Kitshuan:AwACCAEABAoAAA==.',Kn='Knicknack:AwACCAIABAoAAA==.',Ks='Ksonova:AwAICBcABAoCAgAIAQjoAwBJwIsCBAoAAgAIAQjoAwBJwIsCBAoAAA==.',La='Latamoonra:AwADCAUABAoAAA==.',Li='Lighthouse:AwADCAUABRQCAwADAQiiAgBXnhoBBRQAAwADAQiiAgBXnhoBBRQAAA==.',Lo='Lokiblaze:AwADCAYABAoAAA==.',Ma='Mareon:AwADCAMABAoAAA==.Marrast:AwABCAEABAoAAA==.',Me='Metroboomin:AwACCAIABAoAAA==.',Mi='Mitsuki:AwACCAIABAoAAA==.',Mo='Moonpaws:AwACCAIABAoAAA==.',Ni='Nirrad:AwAICBcABAoDBAAIAQhQFwA/rGMCBAoABAAIAQhQFwA/rGMCBAoABQACAQgCPwAHjTEABAoAAA==.Niustavus:AwAHCAUABAoAAA==.',No='Noxen:AwABCAEABAoAAA==.',Re='Retzil:AwAFCAMABAoAAA==.',Sa='Saiden:AwAFCAYABAoAAA==.',Sc='Scarrin:AwAGCBAABAoAAA==.',Sh='Shaelen:AwADCAYABAoAAA==.',Si='Siyegar:AwAHCBEABAoAAA==.',Sp='Sploçk:AwAECAgABAoAAA==.',Tr='Trajann:AwABCAEABRQCBgAIAQiDFQBRfsMCBAoABgAIAQiDFQBRfsMCBAoAAA==.Trashypotato:AwABCAEABAoAAA==.Traximonk:AwADCAUABAoAAA==.',Ty='Tymine:AwAGCA0ABAoAAA==.',Va='Varaz:AwACCAIABAoAAA==.',Vi='Viridian:AwACCAEABAoAAA==.',Ye='Yenzemo:AwAGCBAABAoAAA==.',Ze='Zeldoris:AwAFCBAABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end