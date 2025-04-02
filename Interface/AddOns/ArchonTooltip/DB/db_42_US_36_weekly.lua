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
 local lookup = {'Warrior-Fury','DemonHunter-Vengeance','Warlock-Demonology','Warlock-Destruction','DemonHunter-Havoc','Paladin-Retribution','Evoker-Devastation','Druid-Balance','Druid-Restoration','Priest-Shadow','Warlock-Affliction','Hunter-BeastMastery','Unknown-Unknown','Hunter-Survival','Shaman-Restoration',}; local provider = {region='US',realm="Blade'sEdge",name='US',type='weekly',zone=42,date='2025-03-29',data={Ae='Aeternia:AwAGCBEABAoAAA==.',Ah='Ahzamir:AwABCAEABRQCAQAHAQgzEABS3XQCBAoAAQAHAQgzEABS3XQCBAoAAA==.',Al='Aleinara:AwAECAYABAoAAA==.Alwayscloudy:AwACCAIABAoAAA==.',Aq='Aqular:AwAECAQABAoAAA==.',As='Asynic:AwADCAUABAoAAA==.',Av='Avadakedevra:AwAICAgABAoAAA==.',Be='Beniochan:AwACCAMABAoAAA==.',Bo='Bohel:AwAGCAgABAoAAA==.',Br='Brylenn:AwABCAMABAoAAA==.',Bu='Bulb:AwAECAsABAoAAA==.',Ca='Cane:AwACCAIABAoAAA==.Catastros:AwAGCAMABAoAAA==.Cayllia:AwACCAIABAoAAA==.',Ch='Chivies:AwACCAIABAoAAA==.',Co='Cogne:AwAECAEABAoAAA==.',De='Deathverses:AwADCAQABAoAAA==.Demhunts:AwACCAQABRQCAgAIAQjfBgBGnG8CBAoAAgAIAQjfBgBGnG8CBAoAAA==.',Di='Dikslapp:AwAGCAwABAoAAA==.',Do='Donoph:AwAGCAwABAoAAA==.Doomar:AwAHCBUABAoDAwAHAQiPAgBZc6gCBAoAAwAHAQiPAgBZc6gCBAoABAACAQgfcAA0l1oABAoAAA==.',Dr='Drakedonut:AwABCAIABRQAAA==.',Dy='Dynabol:AwAHCBUABAoCBQAHAQg6CwBY3OgCBAoABQAHAQg6CwBY3OgCBAoAAA==.',Eb='Eborsisk:AwAFCAcABAoAAA==.',Fl='Fleck:AwAGCAwABAoAAA==.Flloyd:AwAGCAwABAoAAA==.',['F�']='Föxxÿ:AwABCAEABAoAAA==.',Gn='Gnight:AwAICAgABAoAAA==.',Gr='Greeny:AwACCAEABAoAAA==.Grimmhammer:AwABCAEABAoAAA==.Grissa:AwABCAEABAoAAA==.',Ha='Hammergold:AwABCAEABAoAAA==.Harmful:AwAHCAUABAoAAA==.',Hi='Hiblast:AwAGCAwABAoAAA==.',Ho='Holierhooves:AwABCAEABRQCBgAHAQjwLQBJ7zUCBAoABgAHAQjwLQBJ7zUCBAoAAA==.Holyknightt:AwAECAQABAoAAA==.Holyminutes:AwACCAMABAoAAA==.',Iv='Ivoric:AwAICAkABAoAAA==.',Ja='Jabronygos:AwAHCBUABAoCBwAHAQjcCQBR8X0CBAoABwAHAQjcCQBR8X0CBAoAAA==.',Jo='Johneggbert:AwAFCAkABAoAAA==.',Ka='Katiyana:AwADCAEABAoAAA==.',Kn='Knightxl:AwAHCAcABAoAAA==.',Ku='Kurquaan:AwABCAEABAoAAA==.',Le='Leondis:AwAGCA4ABAoAAA==.Leveaux:AwAICAwABAoAAA==.Lexifu:AwABCAEABRQCCAAHAQhlGgBG9hgCBAoACAAHAQhlGgBG9hgCBAoAAA==.',Li='Litharia:AwACCAIABAoAAA==.',Lo='Lockmonster:AwAFCAIABAoAAA==.Lorp:AwADCAQABAoAAA==.',Lu='Lucifel:AwAHCAUABAoAAA==.',Ma='Madkingzack:AwAFCAkABAoAAA==.Malliki:AwACCAQABAoAAA==.Mathan:AwADCAYABAoAAA==.',Mo='Morgrim:AwADCAIABAoAAA==.',Mu='Mudderman:AwACCAMABAoAAA==.',Ni='Nibutadragon:AwAHCAoABAoAAA==.',No='Noicce:AwAHCBUABAoDCQAHAQiPEQBCkPEBBAoACQAHAQiPEQBCkPEBBAoACAACAQhGawATKjwABAoAAA==.',Oa='Oakmoss:AwAGCBEABAoAAA==.',Od='Odwin:AwAGCA8ABAoAAA==.',Om='Ombravuota:AwABCAEABRQCCgAHAQiNDwBHRzoCBAoACgAHAQiNDwBHRzoCBAoAAA==.',Pe='Peanutz:AwAICBAABAoAAA==.Perezhealton:AwACCAQABAoAAA==.',Pi='Pikzi:AwABCAEABRQCCgAHAQhQBgBfi+UCBAoACgAHAQhQBgBfi+UCBAoAAA==.',Pr='Pronto:AwADCAUABAoAAA==.',Ra='Raktot:AwACCAIABAoAAA==.Ramsey:AwAHCAcABAoAAA==.',Re='Reeks:AwAICAgABAoAAA==.Reikon:AwAICBAABAoAAA==.Reyz:AwACCAIABAoAAA==.',Rh='Rhagnarr:AwACCAQABAoAAA==.',Sa='Safi:AwABCAEABRQECwAHAQi7DgBcXh4BBAoABAAEAQjUKwBau5EBBAoAAwADAQjZFQBgoSsBBAoACwADAQi7DgBX4B4BBAoAAA==.Sardril:AwABCAEABAoAAA==.',Se='Senzu:AwAHCBQABAoCBgAHAQgrZwAfwmABBAoABgAHAQgrZwAfwmABBAoAAA==.',Sk='Skyslice:AwAGCAkABAoAAA==.',So='Solliwixx:AwAHCAwABAoAAA==.',St='Staple:AwAECAYABAoAAA==.Steelfist:AwAGCAEABAoAAA==.',Su='Subzone:AwADCAIABAoAAA==.',Sy='Sylvaniss:AwAHCBUABAoCDAAHAQj0KgA+/AwCBAoADAAHAQj0KgA+/AwCBAoAAA==.',Ta='Tankinit:AwACCAMABAoAAA==.Tara:AwAFCAoABAoAAA==.',Ti='Ti:AwAGCAsABAoAAA==.',To='Toes:AwABCAEABAoAAQ0AAAAGCAsABAo=.',Ud='Udawutabunga:AwAFCAEABAoAAA==.',Un='Unglaus:AwAICAQABAoAAA==.',Va='Valdon:AwAHCA8ABAoAAA==.Vali:AwACCAQABAoAAA==.Valzlok:AwABCAEABAoAAA==.',Ve='Velinieron:AwAHCBQABAoDDAAHAQixDQBgCPECBAoADAAHAQixDQBgCPECBAoADgAEAQjMBwBVYB0BBAoAAA==.',Vy='Vylon:AwAECAgABAoAAA==.',['V�']='Vêga:AwACCAMABRQAAA==.',Wh='Whispertree:AwABCAEABAoAAA==.',Wi='Wixjones:AwAICBUABAoDCQAIAQhlCQBBMGsCBAoACQAIAQhlCQBBMGsCBAoACAADAQiyWgAgS3sABAoAAA==.',Wu='Wuxian:AwACCAIABRQCDwAIAQiwCwBNiokCBAoADwAIAQiwCwBNiokCBAoAAA==.',Wy='Wyyn:AwAFCA4ABAoAAA==.',Xa='Xanboi:AwAGCAoABAoAAA==.Xataataa:AwAECAQABAoAAA==.',Xi='Xiuying:AwAGCA0ABAoAAA==.',Ze='Zeebu:AwADCAQABAoAAA==.Zellreaper:AwADCAcABAoAAA==.',Zm='Zmajarac:AwAGCAkABAoAAA==.',Zo='Zoko:AwAECAoABAoAAA==.',['Ð']='Ðemaea:AwADCAYABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end