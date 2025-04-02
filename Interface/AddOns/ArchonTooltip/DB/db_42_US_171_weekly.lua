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
 local lookup = {'Unknown-Unknown','Rogue-Subtlety','Warrior-Protection','Mage-Frost','Mage-Fire','Paladin-Retribution','Monk-Mistweaver',}; local provider = {region='US',realm='Onyxia',name='US',type='weekly',zone=42,date='2025-03-29',data={Ab='Abrams:AwACCAIABAoAAQEAAAADCAQABAo=.',Ad='Adobi:AwAFCA0ABAoAAA==.',Ae='Aerez:AwABCAEABAoAAA==.',Al='Aleath:AwAGCBQABAoCAgAGAQhECgBdHl8CBAoAAgAGAQhECgBdHl8CBAoAAA==.Alternate:AwAHCAQABAoAAA==.',Bi='Bigjerome:AwAFCAYABAoAAA==.',Bl='Blackmagic:AwABCAEABAoAAA==.',Br='Brbbowflexin:AwAHCAcABAoAAQEAAAACCAIABRQ=.',Bu='Bulbasaurus:AwAGCAsABAoAAA==.Bus:AwABCAEABRQAAA==.',Ca='Cariz:AwAFCAoABAoAAA==.',Ch='Chios:AwACCAIABRQAAA==.',Co='Conormcgravy:AwAGCAkABAoAAA==.',Cr='Crow:AwAICA0ABAoAAQEAAAADCAMABRQ=.',Da='Davedances:AwACCAIABAoAAA==.',De='Deadcell:AwADCAMABAoAAA==.Deathhorn:AwACCAQABAoAAA==.',El='Elemistrasza:AwADCAQABAoAAA==.Ellipsoro:AwAGCBEABAoAAA==.Eluriana:AwAHCBEABAoAAA==.',Ex='Exagriff:AwAECAYABAoAAA==.Excision:AwAICAgABAoAAA==.',Fi='Fizaw:AwAFCAoABAoAAA==.',Fr='Frang:AwABCAEABAoAAA==.',Ga='Gaurr:AwAECAQABAoAAA==.',Go='Gothmogsbane:AwADCAQABAoAAA==.',Gr='Greyspirit:AwAHCAQABAoAAA==.Grubforged:AwAFCAwABAoAAA==.',He='Hello:AwAICAkABAoAAA==.',Ho='Honkmydemon:AwACCAIABAoAAA==.',Hp='Hpal:AwACCAMABRQAAA==.',Hu='Huonnoth:AwADCAYABAoAAA==.',Kh='Khe:AwAECAsABAoAAA==.',Ki='Kittyshadow:AwAECAcABAoAAQMANukDCAYABRQ=.',Ku='Kushtotem:AwADCAMABAoAAA==.',Le='Lettussy:AwAHCBIABAoAAA==.',Lo='Louietremoss:AwADCAYABAoAAA==.',Lu='Lupp:AwAICB8ABAoDBAAIAQjlAQBfr1QDBAoABAAIAQjlAQBfr1QDBAoABQAIAQg2JAA0gOQBBAoAAA==.',Me='Messaline:AwACCAEABAoAAQEAAAAECAIABAo=.',Mo='Moment:AwAECAkABAoAAA==.Moorality:AwABCAEABAoAAQEAAAACCAIABRQ=.Mozzafar:AwACCAQABAoAAA==.',No='Nora:AwAECAoABRQCBgAEAQhaAABeYrsBBRQABgAEAQhaAABeYrsBBRQAAA==.',Ph='Phoecc:AwAECAEABAoAAA==.',Po='Poropp:AwAFCAsABAoAAA==.Posiblyurdad:AwAFCAwABAoAAA==.',Ro='Rolana:AwAECAYABAoAAA==.',Sa='Salinity:AwAFCAgABAoAAA==.Santini:AwAHCBEABAoAAA==.Satinet:AwAECAIABAoAAA==.Sayamese:AwAHCAQABAoAAA==.',Sh='Shadôwhunt:AwADCAMABAoAAA==.',Si='Sicarii:AwAFCAQABAoAAA==.',Sk='Skyarc:AwAICAgABAoAAQEAAAAICAgABAo=.Skyrak:AwAICAgABAoAAA==.',Sn='Snickles:AwAECAQABAoAAA==.',Sp='Spring:AwABCAEABAoAAQEAAAADCAgABAo=.',Su='Supdude:AwAFCA0ABAoAAA==.',Sw='Swerve:AwAICAgABAoAAA==.',Tr='Trashshaman:AwACCAIABAoAAA==.',Vr='Vrodi:AwAGCBAABAoAAA==.',Vy='Vynii:AwAHCA8ABAoAAA==.',Wq='Wqt:AwACCAQABAoAAA==.',Wu='Wuh:AwADCAMABAoAAA==.',Xa='Xaida:AwAFCAoABRQCBwAFAQizAAApIK4BBRQABwAFAQizAAApIK4BBRQAAA==.',Za='Zangyaku:AwAFCAsABAoAAA==.',Ze='Zenis:AwAECAcABAoAAA==.Zerocool:AwAFCAsABAoAAA==.Zetsuï:AwAGCA4ABAoAAA==.Zevarra:AwABCAEABAoAAA==.',Zy='Zyggy:AwAECAUABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end