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
 local lookup = {'Shaman-Restoration','DeathKnight-Blood','DeathKnight-Unholy','DeathKnight-Frost','Druid-Feral','Warrior-Arms','Warrior-Fury','Shaman-Enhancement',}; local provider = {region='US',realm='Gnomeregan',name='US',type='weekly',zone=42,date='2025-03-29',data={Af='Afoshadow:AwADCAIABAoAAA==.',Ba='Baylore:AwACCAIABAoAAA==.',Bi='Bigpoppapump:AwAFCAIABAoAAA==.',Bl='Blushtime:AwAFCAEABAoAAA==.Bluwhale:AwABCAMABRQCAQAIAQjGDgBHzmACBAoAAQAIAQjGDgBHzmACBAoAAA==.',Bo='Bodanky:AwAFCAIABAoAAA==.',Br='Bruno:AwAFCAsABAoAAA==.',Bu='Bunnynoodle:AwABCAEABAoAAA==.Burland:AwABCAIABAoAAA==.',['B�']='Bärbïe:AwACCAMABAoAAA==.',Ca='Callistos:AwAECAYABAoAAA==.Caradyn:AwACCAQABAoAAA==.',Ci='Cithrel:AwAGCA4ABAoAAA==.',Cl='Cloudninelol:AwAFCAUABAoAAA==.',Co='Considerable:AwABCAEABRQAAQIAUFAFCA0ABRQ=.Coruscare:AwAICAgABAoAAA==.',Da='Damnatio:AwADCAIABAoAAA==.Dastro:AwAHCAwABAoAAA==.',Dm='Dmaan:AwAHCBAABAoAAA==.',Dr='Drahalah:AwAECAoABRQDAwAEAQhQAABY8aEBBRQAAwAEAQhQAABY8aEBBRQABAADAQgSAQA0VvIABRQAAA==.',En='Envoki:AwAICBUABAoCBQAIAQiwAwBHJqACBAoABQAIAQiwAwBHJqACBAoAAA==.',Ga='Garaylo:AwADCAUABAoAAA==.',Ge='Georkinit:AwAFCAsABAoAAA==.',Gh='Ghosst:AwAECAgABAoAAA==.',Gn='Gnonepiece:AwABCAEABAoAAA==.',Gr='Grenee:AwAECAIABAoAAA==.',Gu='Guru:AwAECAcABAoAAA==.',Ho='Hognhots:AwAECAcABAoAAA==.',Hs='Hsimingjung:AwAGCA0ABAoAAA==.',Hu='Humanic:AwAFCAUABAoAAA==.',Ih='Ihithard:AwADCAEABAoAAA==.',Ja='Jalet:AwACCAIABAoAAA==.Jaydee:AwAECAQABAoAAA==.',Ji='Jilly:AwAGCAUABAoAAA==.',Ju='Jugsy:AwAHCAIABAoAAA==.',Ka='Kaligo:AwAECAYABAoAAA==.',Ke='Kebsy:AwAECAYABAoAAA==.Kevonjuravis:AwAECBEABAoAAA==.',La='Lavaburst:AwAICAgABAoAAA==.',['L�']='Lïlith:AwAICAgABAoAAA==.',Ma='Markx:AwAHCBQABAoDBgAHAQinEwBDsroBBAoABgAGAQinEwBD/boBBAoABwABAQggYwBB7T8ABAoAAA==.',Mo='Moomoomilker:AwADCAIABAoAAA==.Morneris:AwAGCA0ABAoAAA==.',Mu='Mud:AwACCAEABAoAAA==.Muggypew:AwAICAgABAoAAA==.',Ne='Nena:AwACCAIABAoAAA==.Neria:AwACCAQABAoAAA==.',Ni='Nity:AwAECAIABAoAAA==.',Pa='Painspongie:AwABCAEABAoAAA==.Paksennarion:AwACCAEABAoAAA==.Patriza:AwADCAIABAoAAA==.Pavo:AwAECAYABAoAAA==.',Pe='Penikeli:AwAICAIABAoAAA==.Peysanity:AwAHCBMABAoAAA==.',Qu='Quiver:AwACCAIABAoAAA==.',Ri='Rivenxi:AwACCAQABAoAAQYATDMBCAIABRQ=.',Ro='Ronfurgundy:AwADCAMABAoAAA==.Rorick:AwAECAQABAoAAA==.',Ru='Ruenan:AwAGCAkABAoAAA==.',Ry='Ryain:AwADCAYABAoAAA==.',Se='Senadarra:AwADCAMABAoAAA==.',Sh='Shendralar:AwABCAEABRQAAA==.',St='Stamina:AwABCAEABRQCBQAHAQjeAQBhxwMDBAoABQAHAQjeAQBhxwMDBAoAAA==.Stormbléssed:AwACCAEABAoAAA==.',Te='Tentsticles:AwADCAEABAoAAA==.',To='Toad:AwABCAEABAoAAA==.',Un='Unoboxo:AwAICBYABAoCCAAIAQglAwBctC0DBAoACAAIAQglAwBctC0DBAoAAA==.',Va='Valorash:AwAFCAsABAoAAA==.Variola:AwAECAMABAoAAA==.',Wo='Wootburger:AwABCAEABAoAAA==.',['W�']='Wøeify:AwAHCBIABAoAAA==.',Xe='Xerus:AwAFCAsABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end