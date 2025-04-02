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
 local lookup = {'Shaman-Enhancement','DeathKnight-Blood','Mage-Frost','Mage-Fire','Paladin-Holy','Paladin-Retribution','Priest-Shadow','Unknown-Unknown','Warrior-Fury','Priest-Holy','DemonHunter-Vengeance','DeathKnight-Unholy','DeathKnight-Frost','Rogue-Assassination','Warlock-Destruction',}; local provider = {region='US',realm='Undermine',name='US',type='weekly',zone=42,date='2025-03-28',data={Am='Amnoon:AwAFCAgABAoAAA==.Amri:AwAHCAMABAoAAA==.',Ar='Ardrhys:AwACCAIABAoAAA==.',Av='Avondwella:AwAFCAwABAoAAA==.',Ay='Ayatsukaz:AwABCAEABAoAAA==.',Ba='Badcumpany:AwABCAEABRQAAA==.Balm:AwAECAkABAoAAA==.',Be='Berzerker:AwAGCBAABAoAAA==.',Bi='Biblepimp:AwABCAEABAoAAA==.',Bo='Bonedready:AwAFCAgABAoAAA==.Boucouyoucou:AwAFCAQABAoAAA==.',Br='Brewcrew:AwAICA0ABAoAAA==.Brickhousee:AwABCAEABRQAAA==.Brud:AwADCAcABAoAAA==.',By='Byakugan:AwADCAUABRQCAQADAQiPBAAj9eoABRQAAQADAQiPBAAj9eoABRQAAA==.',Ca='Calvisilocks:AwAFCAgABAoAAA==.',Co='Considerable:AwAFCA0ABRQCAgAFAQgdAABQUBYCBRQAAgAFAQgdAABQUBYCBRQAAA==.',Cr='Crentist:AwADCAMABAoAAA==.',De='Deathod:AwACCAIABAoAAA==.',Dh='Dhe:AwABCAEABAoAAA==.',Di='Diabolist:AwAECAYABAoAAA==.Die:AwAECAQABAoAAA==.',El='Elistrae:AwADCAEABAoAAA==.',Er='Ergo:AwAICB8ABAoDAwAIAQicBwBJ0r4CBAoAAwAIAQicBwBIqr4CBAoABAAGAQjZNwA0GUEBBAoAAA==.',Fl='Floptropican:AwABCAEABRQAAA==.',Fo='Foxykrikka:AwADCAYABAoAAA==.',Fr='Fróstblight:AwAECAYABAoAAA==.',Gi='Girthen:AwAECAQABAoAAA==.',Go='Gokü:AwAICAcABAoAAA==.',Gu='Gutted:AwADCAcABRQCAgADAQhxAQBfAEoBBRQAAgADAQhxAQBfAEoBBRQAAA==.',Ha='Hanna:AwAECAcABAoAAA==.',Hu='Humblepal:AwAICCMABAoDBQAIAQhsEQAZxY4BBAoABQAIAQhsEQAZxY4BBAoABgACAQiTzwAm5mkABAoAAA==.Huntersk:AwAECAcABAoAAQcAVzACCAYABRQ=.',Ic='Ici:AwAFCAgABAoAAA==.',Is='Iskothar:AwABCAEABAoAAA==.',Ja='Jackzlock:AwAICAQABAoAAA==.Jarco:AwADCAMABAoAAQgAAAAHCAEABAo=.',Jo='Joshcalcjr:AwAECAcABAoAAA==.',Ka='Kakipriest:AwAICAkABAoAAA==.',Ki='Kiliko:AwAECAMABAoAAA==.',La='Landre:AwAGCBMABAoAAA==.',Le='Leonz:AwADCAcABRQCCQADAQh2BABJ0xsBBRQACQADAQh2BABJ0xsBBRQAAA==.Letharanos:AwEGCBEABAoAAA==.Lethasmash:AwEBCAEABAoAAQgAAAAGCBEABAo=.Lethavenge:AwEDCAMABAoAAQgAAAAGCBEABAo=.',Li='Liraffemyn:AwAECAoABAoAAA==.',Lk='Lkynyx:AwAECAsABAoAAA==.',Lo='Loond:AwAECAcABAoAAA==.',Ma='Makubex:AwACCAEABAoAAA==.Maldran:AwAFCAgABAoAAA==.Malkaios:AwAFCA4ABAoAAA==.Marien:AwAFCAcABAoAAA==.',Me='Megwyn:AwACCAMABAoAAA==.',Mi='Mistyblue:AwAICAgABAoAAA==.',Na='Nailz:AwAFCAwABAoAAA==.',Oa='Oaths:AwAFCAIABAoAAA==.Oathsfury:AwABCAEABAoAAA==.',Oh='Ohmylanta:AwAGCAQABAoAAA==.',Os='Oscarmike:AwAECAQABAoAAA==.',Pa='Panzerkan:AwAECAcABAoAAA==.',Pi='Pigish:AwABCAEABAoAAA==.',Pr='Priestsk:AwACCAYABRQCBwACAQhqBgBXMMEABRQABwACAQhqBgBXMMEABRQAAA==.',Ra='Rantsuu:AwAGCAoABAoAAQgAAAABCAEABRQ=.',Ro='Rookah:AwAECAcABAoAAQoAMecDCAcABRQ=.Rooter:AwAHCBEABAoAAA==.Roowynn:AwADCAcABRQCCgADAQj7AgAx5+0ABRQACgADAQj7AgAx5+0ABRQAAA==.',Se='Seongdh:AwADCAcABRQCCwADAQicAQA8+uYABRQACwADAQicAQA8+uYABRQAAA==.Seongpal:AwAECAQABAoAAA==.Seongwar:AwAECAQABAoAAA==.',Sh='Shamany:AwADCAQABAoAAA==.Shapen:AwADCAMABAoAAA==.Shejreev:AwACCAEABAoAAA==.Shimera:AwADCAYABAoAAA==.Shish:AwACCAMABAoAAQwANoAGCAoABAo=.Shockawar:AwADCAcABRQCCQADAQhbBQA2fwgBBRQACQADAQhbBQA2fwgBBRQAAA==.Shïsh:AwAGCAoABAoCDAAGAQjlKgA2gFwBBAoADAAGAQjlKgA2gFwBBAoAAA==.',Sk='Skullcrushr:AwAGCBMABAoCDQAGAQhFDgAeM0kBBAoADQAGAQhFDgAeM0kBBAoAAA==.',Sl='Slaughterhse:AwAECAEABAoAAA==.',So='Solthin:AwAECAgABAoAAA==.',St='Starrdazze:AwAFCAgABAoAAA==.Strelock:AwACCAQABAoAAA==.',Ta='Talkamar:AwAFCAMABAoAAA==.Taylorswift:AwAFCA4ABAoAAA==.',Th='Theevil:AwACCAMABAoAAA==.Thekourge:AwAFCAgABAoAAA==.Thukuna:AwAGCBIABAoAAA==.',To='Touritos:AwADCAEABAoAAA==.',Tu='Tuskal:AwADCAMABAoAAA==.',Ty='Tydes:AwAFCAwABAoAAA==.',Un='Unciroh:AwACCAIABAoAAQUAVI8BCAIABRQ=.Unprepared:AwAGCAoABAoAAA==.',Vo='Volk:AwADCAcABRQCDgADAQjnAABIbCEBBRQADgADAQjnAABIbCEBBRQAAA==.Volkadin:AwACCAIABAoAAQ4ASGwDCAcABRQ=.Volkaloid:AwAECBIABAoAAQ4ASGwDCAcABRQ=.',Vs='Vsesosorry:AwACCAQABRQAAA==.',Wr='Wrenlyn:AwAHCBAABAoAAA==.',Xy='Xymos:AwADCAcABRQCDwADAQgsAgBOXC8BBRQADwADAQgsAgBOXC8BBRQAAA==.',Yu='Yu:AwACCAIABAoAAA==.',Za='Zaes:AwABCAEABRQAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end