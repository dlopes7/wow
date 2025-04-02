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
 local lookup = {'Paladin-Protection','Shaman-Enhancement','Warrior-Arms','Warrior-Fury','Rogue-Assassination','Warlock-Destruction','Mage-Fire','Priest-Shadow','Priest-Holy','Unknown-Unknown','DeathKnight-Blood','Monk-Brewmaster','Monk-Windwalker',}; local provider = {region='US',realm='TwistingNether',name='US',type='weekly',zone=42,date='2025-03-28',data={Ab='Abeon:AwAHCBUABAoCAQAHAQjjEAAv0X8BBAoAAQAHAQjjEAAv0X8BBAoAAA==.',Ah='Ahnano:AwAHCBUABAoCAgAHAQgVFQA23egBBAoAAgAHAQgVFQA23egBBAoAAA==.',Aj='Ajwana:AwAGCAoABAoAAA==.',An='Anvilkrash:AwABCAEABAoAAA==.',Ba='Bachadin:AwAGCAEABAoAAA==.',Ca='Calamidade:AwAFCA0ABAoAAA==.',Cl='Clother:AwAECAsABAoAAA==.',De='Detonare:AwABCAEABAoAAA==.',Dj='Djaztech:AwACCAIABRQDAwAIAQjUBwBOSHoCBAoAAwAHAQjUBwBLnXoCBAoABAAHAQjxEQBTvFgCBAoAAA==.',Ea='Earthmommy:AwACCAIABAoAAA==.',En='Enalea:AwADCAMABAoAAA==.',Er='Erisanie:AwAICBcABAoCBQAIAQjKDAAkHtsBBAoABQAIAQjKDAAkHtsBBAoAAA==.',Fe='Feso:AwACCAIABAoAAA==.',Fi='Finnarius:AwACCAMABAoAAA==.Fizzlewar:AwAFCA4ABAoAAA==.',Fo='Foros:AwABCAIABAoAAA==.',Fr='Fryiertuck:AwADCAkABAoAAA==.',Ga='Gaunshots:AwADCAkABAoAAA==.',Ge='Gendorosan:AwADCAgABAoAAA==.',Gi='Gigabyte:AwADCAkABAoAAA==.',Gn='Gnork:AwADCAkABAoAAA==.',Gr='Grayfoxx:AwADCAkABAoAAA==.',Ha='Havokishi:AwAECAMABAoAAA==.',He='Hellstomper:AwABCAEABAoAAA==.',Ja='Jarny:AwACCAIABAoAAA==.',['J�']='Jârprî:AwAGCAkABAoAAA==.',Ka='Kahira:AwEDCAgABAoAAA==.Kambra:AwADCAIABAoAAA==.',Kh='Khyl:AwAECAgABAoAAA==.',Ks='Ksauce:AwADCAgABAoAAA==.',Li='Linta:AwACCAIABAoAAA==.',Lo='Loki:AwAFCBAABAoAAA==.',Ma='Malifecent:AwAGCBQABAoCBgAGAQgZMQAzHWQBBAoABgAGAQgZMQAzHWQBBAoAAA==.Malka:AwADCAkABAoAAA==.',Na='Nagendra:AwAGCA4ABAoAAA==.',No='Nordathair:AwABCAIABAoAAA==.Nori:AwADCAkABRQCBwADAQjIBQBVRCwBBRQABwADAQjIBQBVRCwBBRQAAA==.Notorious:AwACCAIABAoAAA==.',Nu='Numbies:AwAECAQABAoAAA==.',Pe='Pendragonzz:AwADCAgABAoAAA==.',Pr='Priestalisha:AwAECAoABAoAAA==.',Ra='Ragetatertot:AwACCAIABAoAAA==.',Re='Redrobins:AwACCAIABAoAAA==.Reheal:AwAFCA4ABAoAAA==.',Rh='Rhhee:AwADCAkABAoAAA==.',Ri='Ritualistic:AwABCAEABAoAAA==.Rixxy:AwABCAEABRQAAA==.',Sa='Saisaith:AwAHCBYABAoDCAAHAQhaGQAssKEBBAoACAAHAQhaGQAssKEBBAoACQABAQiCZgALlCIABAoAAA==.Sandy:AwABCAEABRQAAA==.Sauronn:AwAHCA4ABAoAAA==.',Se='Serpeng:AwADCAUABAoAAA==.',Sh='Shanta:AwAECAkABAoAAA==.Shkar:AwAICBcABAoCBAAIAQjxFAAyJTkCBAoABAAIAQjxFAAyJTkCBAoAAA==.Shryke:AwABCAEABAoAAA==.',Sl='Slaagg:AwAICAgABAoAAQoAAAAICBAABAo=.',St='Striptotem:AwAFCAoABAoAAA==.',Sw='Swaborock:AwAICBAABAoAAA==.',Ta='Talôn:AwAICAgABAoAAA==.',Va='Valtas:AwEGCBQABAoCCwAGAQi5DABUGRICBAoACwAGAQi5DABUGRICBAoAAA==.',Wa='Wayya:AwADCAkABAoAAA==.',Wr='Wratheon:AwAHCBYABAoDDAAHAQgGBQBH0hICBAoADAAHAQgGBQBH0hICBAoADQABAQiwTQAkYS0ABAoAAA==.',Xa='Xablau:AwACCAIABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end