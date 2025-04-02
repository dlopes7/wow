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
 local lookup = {'Warrior-Fury','DeathKnight-Blood','Shaman-Restoration','Monk-Windwalker','Monk-Brewmaster','Unknown-Unknown','Priest-Holy','DemonHunter-Havoc','Paladin-Protection','Hunter-BeastMastery','Druid-Restoration','Druid-Balance','Mage-Fire','Druid-Feral','Warlock-Affliction','Warlock-Destruction','Warrior-Protection','Hunter-Marksmanship','DeathKnight-Unholy',}; local provider = {region='US',realm="Mok'Nathal",name='US',type='weekly',zone=42,date='2025-03-29',data={Aa='Aaralia:AwAGCAoABAoAAA==.',Aj='Ajester:AwABCAEABRQCAQAIAQjZBwBVZuoCBAoAAQAIAQjZBwBVZuoCBAoAAA==.',Ak='Akadeus:AwADCAMABAoAAA==.',As='Ashikahammer:AwADCAMABAoAAA==.',Bi='Bigshrimpin:AwAGCAYABAoAAA==.',Bu='Bullwalk:AwACCAMABAoAAA==.Bunghole:AwACCAMABAoAAA==.',Ca='Cap:AwAGCBEABAoAAA==.Carden:AwADCAYABAoAAA==.',Ch='Charlas:AwAGCA0ABAoAAA==.',Co='Corvenis:AwAECAIABAoAAA==.',Ct='Cthullu:AwABCAIABRQAAA==.',De='Deathpooden:AwADCAcABRQCAgADAQghAwBMLwgBBRQAAgADAQghAwBMLwgBBRQAAA==.',Di='Dima:AwAFCBAABAoAAA==.Dithy:AwADCAMABAoAAA==.',Dk='Dkrmk:AwAICAgABAoAAA==.',El='Elaments:AwAECAQABAoAAA==.',Ep='Epicdude:AwAFCAcABAoAAA==.',Fe='Fearzlol:AwAECAYABAoAAA==.',Fr='Freedessert:AwABCAEABRQAAA==.',Gr='Greggdshami:AwAHCBUABAoCAwAHAQgUGQBASfsBBAoAAwAHAQgUGQBASfsBBAoAAA==.Grow:AwAHCBEABAoAAA==.',Ha='Hardwired:AwACCAIABAoAAA==.',Ho='Holykal:AwAECAUABAoAAA==.Hope:AwAICBcABAoDBAAIAQhwDQBMMFgCBAoABAAHAQhwDQBIMVgCBAoABQACAQh3EwA+jIsABAoAAQYAAAABCAEABRQ=.Horse:AwADCAcABRQCBwADAQgHBAAnENEABRQABwADAQgHBAAnENEABRQAAA==.',Hr='Hrafna:AwADCAMABAoAAA==.',Ic='Icu:AwADCAQABAoAAA==.',Jo='Jorxx:AwACCAQABAoAAA==.',Ju='Jun:AwADCAcABRQCCAADAQihBABPPDIBBRQACAADAQihBABPPDIBBRQAAA==.',Ka='Kaenn:AwAHCBUABAoCCQAHAQjiDAA9V9ABBAoACQAHAQjiDAA9V9ABBAoAAA==.',Ke='Keldra:AwAICCAABAoCCgAIAQgjAQBihoMDBAoACgAIAQgjAQBihoMDBAoAAA==.',Kh='Khephris:AwAECAEABAoAAA==.',Ku='Kuragann:AwAFCAgABAoAAA==.',La='Lapipi:AwAECAYABAoAAA==.',Li='Lionroar:AwACCAQABRQDCwAIAQizAwBW6vUCBAoACwAIAQizAwBW6vUCBAoADAAEAQjPUwAWtpkABAoAAA==.Lionscales:AwADCAQABAoAAA==.',Ll='Llaothtaed:AwAICAgABAoAAA==.',Lo='Lonee:AwACCAEABAoAAA==.',Ma='Matteas:AwAFCAIABAoAAA==.Maxr:AwAGCAoABAoAAA==.',Me='Mendelssohn:AwAICCEABAoCDQAIAQhRGQA//UgCBAoADQAIAQhRGQA//UgCBAoAAA==.',Mo='Mograins:AwAECAMABAoAAA==.',My='Mymdos:AwAGCBIABAoAAA==.',['M�']='Môiraine:AwADCAMABAoAAA==.',Or='Orgdynamite:AwADCAcABRQCDgADAQi0AAA2Bg8BBRQADgADAQi0AAA2Bg8BBRQAAA==.',Pa='Panzer:AwAFCAgABAoAAA==.',Pe='Pejbolt:AwADCAcABRQDDwADAQjFBQAiN50ABRQADwACAQjFBQAvf50ABRQAEAACAQhzDQAenYEABRQAAQgATzwDCAcABRQ=.',Pl='Plum:AwAGCAgABAoAAA==.',Pr='Praying:AwADCAIABAoAAA==.',Pu='Puccini:AwAGCA4ABAoAAQ0AP/0ICCEABAo=.',Re='Requrve:AwAFCBAABAoAAA==.',Sa='Savarkar:AwABCAEABRQCEQAHAQiSBwA5/98BBAoAEQAHAQiSBwA5/98BBAoAAA==.',Sh='Shamwowolio:AwABCAIABAoAAA==.',Sk='Skÿe:AwAHCBUABAoCEgAHAQh+DwBGBOkBBAoAEgAHAQh+DwBGBOkBBAoAAA==.',Sl='Slappinbubs:AwAICAgABAoAAA==.',Sm='Smoovy:AwAICBkABAoDEwAIAQgLEgBBeEwCBAoAEwAIAQgLEgBBeEwCBAoAAgABAQgaRAAOXh0ABAoAAA==.',Sp='Spifftreebug:AwADCAcABAoAAA==.',St='Stonkz:AwAICBAABAoAAA==.',Sz='Szarcion:AwAGCBEABAoAAA==.',['S�']='Söphie:AwAICAgABAoAAA==.',Ta='Tainema:AwAGCAwABAoAAA==.Taurriel:AwAFCBAABAoAAA==.Tazzm:AwAFCA0ABAoAAA==.',Te='Teranok:AwAHCBUABAoDBAAHAQjPDwBImzMCBAoABAAHAQjPDwBImzMCBAoABQABAQhrGwAFZRUABAoAAA==.',Th='Thoir:AwADCAcABRQCAwADAQiGAwBBkAgBBRQAAwADAQiGAwBBkAgBBRQAAQcAJxADCAcABRQ=.Thundrkeg:AwABCAEABRQAAA==.',Tr='Tricktìckler:AwADCAMABAoAAA==.',Ul='Ulymage:AwEDCAcABRQCDQADAQiJCQA55/sABRQADQADAQiJCQA55/sABRQAAA==.',Va='Vashi:AwAECAcABAoAAA==.',We='Weehunt:AwAECAUABAoAAA==.',Wi='Wicka:AwACCAUABAoAAA==.Wildriver:AwAECA0ABAoAAA==.',Xa='Xaehyun:AwACCAMABRQCBAAIAQhvBgBQL+ECBAoABAAIAQhvBgBQL+ECBAoAAA==.Xanni:AwADCAcABRQCAwADAQjGBQAWPcUABRQAAwADAQjGBQAWPcUABRQAAA==.Xarbyn:AwADCAEABAoAAA==.',Ya='Yakbo:AwAICBAABAoAAA==.',Za='Zanne:AwABCAEABRQDEgAHAQjPCQBVS0sCBAoAEgAHAQjPCQBVS0sCBAoACgABAQgLpgAusEoABAoAAA==.',Zl='Zlot:AwADCAcABRQCCgADAQg/BwBHDBQBBRQACgADAQg/BwBHDBQBBRQAAA==.',['Ò']='Òneshot:AwABCAEABRQAAA==.',['Ø']='Øneshot:AwABCAEABAoAAQYAAAABCAEABRQ=.Øñêshot:AwABCAEABRQAAQYAAAABCAEABRQ=.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end