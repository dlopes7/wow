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
 local lookup = {'Hunter-BeastMastery','Paladin-Retribution','Unknown-Unknown','Evoker-Devastation','Mage-Fire','Priest-Discipline','Priest-Holy','Monk-Brewmaster','Warrior-Fury','Warlock-Demonology','Monk-Windwalker',}; local provider = {region='US',realm='Anvilmar',name='US',type='weekly',zone=42,date='2025-03-29',data={Al='Alindia:AwABCAEABAoAAA==.Alirrayiia:AwADCAMABAoAAA==.',Ap='Apolloerosp:AwAECAQABAoAAA==.',As='Ashundrar:AwAECAkABAoAAA==.',Az='Azure:AwAFCA0ABAoAAA==.',Ba='Badpad:AwAFCAkABAoAAA==.Bahler:AwAICAgABAoAAA==.Barefall:AwABCAMABRQCAQAIAQj3EwBUtbgCBAoAAQAIAQj3EwBUtbgCBAoAAA==.Barewhale:AwACCAIABAoAAQEAVLUBCAMABRQ=.Bashira:AwAFCAUABAoAAA==.',Bo='Bogertus:AwAGCA0ABAoAAA==.',Br='Brasha:AwAFCAkABAoAAA==.',Ca='Calthroc:AwABCAEABAoAAA==.',Cl='Closetmonkey:AwABCAEABAoAAA==.',Da='Darknìght:AwACCAIABAoAAA==.',De='Deeznutticus:AwACCAQABRQAAA==.Derdan:AwADCAYABAoAAA==.Destriant:AwADCAEABAoAAA==.',Dr='Dragonbane:AwABCAEABAoAAQIARNQBCAIABRQ=.',Ec='Echoes:AwACCAIABAoAAQMAAAAFCAMABAo=.',Ed='Eddy:AwACCAMABAoAAA==.',Eu='Euorphium:AwABCAEABRQCBAAIAQgGCwBCZmICBAoABAAIAQgGCwBCZmICBAoAAA==.',Fe='Fellicity:AwAICAgABAoAAA==.',Ff='Fflip:AwAECAcABAoAAA==.',Fo='Forphium:AwABCAIABAoAAQQAQmYBCAEABRQ=.',Fr='Frederica:AwADCAEABAoAAA==.',Ga='Gagamer:AwADCAMABAoAAA==.Ganhammer:AwAECAYABAoAAA==.',Gi='Gingie:AwABCAEABAoAAA==.Gird:AwAFCAgABAoAAA==.',Gn='Gnomestra:AwAFCAUABAoAAA==.',Go='Gordek:AwAFCAcABAoAAA==.',Gr='Grantaron:AwADCAcABAoAAA==.Grntitan:AwADCAQABAoAAA==.',Gw='Gwoohoori:AwAGCBEABAoAAA==.',Ho='Honeygurl:AwAFCAcABAoAAA==.',Hu='Huflungpoop:AwAFCA4ABAoAAA==.',Im='Imcruel:AwACCAIABRQCBQAIAQgoBwBdyhADBAoABQAIAQgoBwBdyhADBAoAAA==.',Ja='Jabes:AwAECAMABAoAAA==.',Jo='Joregis:AwADCAgABAoAAA==.Jorphium:AwAECAQABAoAAQQAQmYBCAEABRQ=.',Jt='Jt:AwAECAQABAoAAA==.',Ju='Juqi:AwADCAgABRQCBQADAQjPBgBQcCYBBRQABQADAQjPBgBQcCYBBRQAAA==.',Ke='Keiran:AwADCAEABAoAAA==.',Kh='Khalnerys:AwAFCAUABAoAAA==.Khoudow:AwABCAEABRQDBgAIAQiCFAA39sQBBAoABgAIAQiCFAAqyMQBBAoABwAFAQj7LgA7aCIBBAoAAA==.',Ki='Kimmi:AwACCAEABAoAAA==.Kity:AwAHCAUABAoAAA==.',Ku='Kuraishin:AwABCAIABRQAAA==.',Ky='Kylindra:AwAFCAgABAoAAA==.',Le='Lero:AwAHCBUABAoCCAAHAQjwAgBWjZACBAoACAAHAQjwAgBWjZACBAoAAA==.Lexo:AwABCAEABRQAAA==.',Li='Liuni:AwAFCBAABAoAAA==.',Lu='Lumanaus:AwABCAEABAoAAA==.Lunaclair:AwADCAYABAoAAQMAAAABCAIABRQ=.',Ma='Mancath:AwAFCAgABAoAAA==.',Me='Mechawarrior:AwAHCBIABAoAAA==.Melanar:AwABCAEABAoAAA==.',Mo='Moistweaver:AwACCAQABAoAAA==.Momdad:AwAFCA4ABAoAAA==.',Ms='Msboombostic:AwAICBAABAoAAA==.',Na='Naeko:AwAFCAEABAoAAQMAAAABCAIABRQ=.Namine:AwAFCAoABAoAAA==.',Ny='Nymlindra:AwAFCAoABAoAAA==.',Or='Ornadun:AwAECAMABAoAAQEAVLUBCAMABRQ=.Orphen:AwABCAEABAoAAA==.',Oz='Ozakra:AwADCAQABAoAAA==.',Pj='Pj:AwAECAYABAoAAA==.',Ra='Ravenbrook:AwAHCBcABAoCCQAHAQgOBwBelfcCBAoACQAHAQgOBwBelfcCBAoAAA==.',Re='Reciprocity:AwADCAcABAoAAA==.',Ro='Romani:AwAECAMABAoAAA==.',Ru='Rupertgiless:AwADCAUABRQCCgADAQh5AAAn8OoABRQACgADAQh5AAAn8OoABRQAAA==.',Sc='Scaliefox:AwADCAgABAoAAA==.',Si='Simonx:AwAFCAgABAoAAA==.',Sk='Skyedrin:AwAFCAgABAoAAA==.',Sn='Snipy:AwACCAIABAoAAA==.',St='Strombjorn:AwAFCAUABAoAAA==.',['S�']='Sølaria:AwAECAQABAoAAA==.',Th='Thotñprayers:AwAGCA8ABAoAAA==.',Tu='Turtl:AwAHCBcABAoCCwAHAQhLBABhUxEDBAoACwAHAQhLBABhUxEDBAoAAA==.',Ty='Tyryn:AwACCAIABAoAAQMAAAAFCAgABAo=.',Un='Undeadbuddy:AwAICBAABAoAAA==.',Va='Valantor:AwABCAIABRQCAgAIAQgyKgBE1EcCBAoAAgAIAQgyKgBE1EcCBAoAAA==.Valgaskav:AwAFCBAABAoAAA==.',Vo='Voladin:AwAICAgABAoAAA==.',Vy='Vyeahhgruh:AwAFCA4ABAoAAA==.',Wa='Washu:AwABCAIABRQAAA==.',Wh='Whorphium:AwACCAIABAoAAQQAQmYBCAEABRQ=.',Wi='Wisdomheart:AwAECAQABAoAAA==.',Wo='Wonderbread:AwAHCBcABAoCAgAHAQjeMwBEBxoCBAoAAgAHAQjeMwBEBxoCBAoAAA==.',['W�']='Wârwôlf:AwAGCA8ABAoAAA==.',Xa='Xaladriel:AwADCAEABAoAAA==.',Xe='Xenan:AwADCAgABAoAAA==.',Ye='Yeastmode:AwAECAcABAoAAA==.',Ze='Zeebra:AwAFCAgABAoAAA==.',Zi='Zillionbucks:AwAECA4ABAoAAQIANm0DCAcABRQ=.Zillionbúcks:AwADCAcABRQCAgADAQhFCAA2bfAABRQAAgADAQhFCAA2bfAABRQAAA==.',Zu='Zulmara:AwAHCAkABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end