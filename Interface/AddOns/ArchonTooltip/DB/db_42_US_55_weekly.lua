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
 local lookup = {'Priest-Shadow','Priest-Holy','Warrior-Fury','Warrior-Arms','Hunter-BeastMastery','Unknown-Unknown','Monk-Windwalker','Paladin-Retribution','DeathKnight-Blood','DeathKnight-Unholy','Mage-Fire','Evoker-Devastation','Evoker-Preservation','Druid-Guardian','Druid-Restoration','Mage-Frost','Warlock-Affliction','Warlock-Destruction','Warlock-Demonology','Druid-Balance','DemonHunter-Havoc','Mage-Arcane','Shaman-Restoration',}; local provider = {region='US',realm='Crushridge',name='US',type='weekly',zone=42,date='2025-03-29',data={Ag='Agrippa:AwAGCA0ABAoAAA==.',Ai='Aidric:AwAECAcABAoAAA==.Airwavez:AwAHCAcABAoAAA==.',Al='Aldormu:AwAECAkABAoAAA==.Allura:AwADCAMABAoAAA==.Altra:AwAGCBMABAoAAA==.',An='Angelique:AwAFCAwABAoAAA==.',As='Ashenback:AwABCAIABRQAAA==.Ashguard:AwABCAEABAoAAA==.Asomyrh:AwADCAMABAoAAA==.',Av='Avralis:AwAGCBQABAoDAQAGAQifGAA+QrUBBAoAAQAGAQifGAA+QrUBBAoAAgABAQivYgAvmDIABAoAAA==.',Az='Azshaura:AwAICAgABAoAAA==.',Be='Beaü:AwAFCAkABAoAAA==.',Bi='Biggiew:AwADCAUABRQDAwADAQgGCgA/j6wABRQAAwACAQgGCgAuhawABRQABAABAQi+BQBhonMABRQAAA==.',Bo='Bontao:AwACCAQABRQCBQAIAQjHEgBL+sMCBAoABQAIAQjHEgBL+sMCBAoAAA==.Booper:AwADCAIABAoAAA==.',Br='Bresepls:AwABCAEABRQAAA==.Breseshh:AwAGCBEABAoAAQYAAAABCAEABRQ=.Bricklee:AwACCAMABRQCBwAIAQguCgBG3ZQCBAoABwAIAQguCgBG3ZQCBAoAAA==.',Ca='Cadilak:AwAGCBMABAoAAA==.Cadsune:AwADCAYABAoAAA==.Cassius:AwACCAMABRQCCAAIAQhCEQBWQeQCBAoACAAIAQhCEQBWQeQCBAoAAA==.Catgoesmeow:AwADCAMABAoAAA==.Cazren:AwAICAQABAoDCQADAQjxNgAQwl0ABAoACQADAQjxNgAQwl0ABAoACgABAQhWagAD6Q8ABAoAAA==.',Ch='Chowderhead:AwABCAEABAoAAA==.',Ci='Ciefer:AwABCAMABAoAAA==.Cileb:AwADCAQABAoAAA==.',Cn='Cnbtorture:AwABCAEABAoAAA==.',Co='Copperit:AwAHCA8ABAoAAA==.Cornburglar:AwAECAgABAoAAA==.Coumadin:AwAECAgABAoAAA==.',Cr='Crunchwrap:AwAECAkABAoAAA==.Crúsader:AwAGCA8ABAoAAA==.',Da='Daddiedh:AwAFCAUABAoAAA==.Dakkon:AwABCAEABAoAAA==.Dathunran:AwAECA8ABAoAAA==.',De='Dearth:AwEICA0ABAoAAA==.Demona:AwAGCA4ABAoAAA==.',Di='Dirtylöbster:AwAGCBQABAoCCwAGAQj5JABJM94BBAoACwAGAQj5JABJM94BBAoAAA==.',Dl='Dltdjr:AwAECAEABAoAAA==.',Do='Dontlosmeplz:AwAECAQABAoAAQYAAAABCAEABRQ=.',Dr='Dropkicked:AwADCAcABAoAAA==.',Du='Duwork:AwAECAEABAoAAA==.',['D�']='Dæmona:AwAFCAsABAoAAA==.',Ea='Earthrender:AwAECAEABAoAAA==.',En='Enhshaman:AwABCAEABRQAAA==.',Fa='Fauna:AwACCAIABAoAAA==.',Fl='Flysky:AwACCAQABRQDDAAIAQihBgBULMQCBAoADAAHAQihBgBUL8QCBAoADQAIAQgaAwBHXJ0CBAoAAA==.',Fr='Frostuss:AwAFCAsABAoAAA==.',Fu='Fubear:AwADCAEABAoAAA==.',['F�']='Fèrn:AwAECAEABAoAAA==.',Ga='Garynud:AwAGCAsABAoAAA==.',Ge='Gearth:AwAGCBMABAoAAA==.Geel:AwAGCAsABAoAAA==.Gehennas:AwAECAsABAoAAA==.',Gr='Griffpo:AwAECAcABAoAAA==.Grävyy:AwAGCBQABAoCBwAGAQhuEQBMexoCBAoABwAGAQhuEQBMexoCBAoAAA==.',Ho='Honour:AwAGCAwABAoAAA==.',Id='Idiotbreath:AwAGCBQABAoCDAAGAQiyFQA6bZ4BBAoADAAGAQiyFQA6bZ4BBAoAAA==.',Ie='Ievoke:AwACCAMABAoAAA==.',Ir='Iriinala:AwAECAQABAoAAA==.',It='Itsthereaper:AwAGCBQABAoCDgAGAQh8AgBZ/lECBAoADgAGAQh8AgBZ/lECBAoAAA==.',Ja='Jasz:AwADCAMABAoAAA==.',Jo='Joulie:AwACCAIABAoAAA==.',Ju='Jujulockey:AwAICAgABAoAAA==.',Ka='Kaezarian:AwABCAEABAoAAA==.Kairei:AwADCAYABAoAAA==.Kawnmongold:AwADCAMABAoAAA==.',Ki='Kiris:AwAHCA0ABAoAAA==.',Ko='Koonia:AwADCAQABAoAAA==.',Kr='Krangis:AwAGCAYABAoAAA==.',Li='Lizzydh:AwAGCBMABAoAAA==.',Ma='Mageslayer:AwAECAoABAoAAA==.Malanara:AwADCAcABAoAAA==.Manamanaa:AwAHCBEABAoAAA==.Matty:AwAECAcABAoAAA==.Mavrik:AwAGCA8ABAoAAA==.',Mc='Mckay:AwAICAgABAoAAA==.',Me='Meatmagic:AwAFCAIABAoAAA==.Meudayr:AwEDCAQABAoAAA==.',Mi='Mimmir:AwAGCA8ABAoAAA==.Mirari:AwAGCBEABAoAAA==.Mittenss:AwAECAIABAoAAA==.',Mo='Mosspaws:AwAGCBQABAoCDwAGAQhpBwBhWZUCBAoADwAGAQhpBwBhWZUCBAoAAA==.Motoko:AwAGCBMABAoAAA==.',Ni='Nistic:AwACCAIABAoAAA==.',No='Nocturnos:AwAFCAIABAoAAA==.Noggin:AwAGCBAABAoAAA==.',Nu='Numonixx:AwABCAIABRQCDAAHAQgiDwA/vw8CBAoADAAHAQgiDwA/vw8CBAoAAA==.',Ny='Nymage:AwAFCAQABAoAAQYAAAAHCBEABAo=.',Oh='Oharewedead:AwAECAQABAoAAA==.Ohnodemons:AwADCAMABAoAAA==.',Ok='Okaerisan:AwABCAIABAoAAA==.',On='Oneshotcuhh:AwAICAIABAoAAA==.',Op='Ophil:AwABCAEABRQCEAAGAQg7EABYlkoCBAoAEAAGAQg7EABYlkoCBAoAAA==.',Or='Orack:AwADCAUABAoAAA==.',Pa='Panhasdemons:AwACCAIABRQEEQAIAQjzBgBQLbUBBAoAEQAFAQjzBgBQ5bUBBAoAEgAGAQiRKAA8Y6cBBAoAEwAEAQjaEQBJwFIBBAoAAA==.',Po='Poah:AwAGCAsABAoAAA==.',Ra='Ragnarl:AwAGCBAABAoAAA==.',Re='Reaperjoe:AwACCAQABAoAAA==.Rektributio:AwADCAQABRQCCAAIAQjgAgBgM24DBAoACAAIAQjgAgBgM24DBAoAAA==.Revalation:AwABCAEABAoAAA==.',Ro='Rodfarva:AwAGCAYABAoAAA==.Roxxar:AwABCAEABAoAAA==.',Sa='Saifrah:AwADCAYABAoAAA==.Salinä:AwEFCAwABAoAAA==.Saragos:AwACCAIABAoAAQsAWBcCCAQABRQ=.',Se='Selune:AwAICBEABAoCDwAIAQiXKwANGQkBBAoADwAIAQiXKwANGQkBBAoAAA==.Semir:AwABCAEABAoAAA==.',Sh='Sharick:AwADCAUABAoAAA==.Shawlee:AwAECAEABAoAAA==.Shettrah:AwABCAEABRQCFAAIAQjPDQBHuacCBAoAFAAIAQjPDQBHuacCBAoAAA==.',So='Somi:AwADCAYABAoAAA==.',Ta='Talethen:AwAECAgABAoAAA==.',Te='Terry:AwADCAYABRQCBQADAQhtBQBUJjABBRQABQADAQhtBQBUJjABBRQAAA==.',Th='Theverdict:AwAGCAwABAoAAA==.Threzk:AwAGCAkABAoAAA==.',Ti='Ticklemypal:AwADCAMABAoAAA==.Ticklemywar:AwAGCBEABAoAAA==.Tigerrwoods:AwAGCAkABAoAAA==.',To='Tohk:AwACCAMABRQCFQAIAQjcAABhNYQDBAoAFQAIAQjcAABhNYQDBAoAAA==.Tolle:AwADCAMABAoAAA==.',Tr='Trousers:AwACCAIABAoAAA==.',Tu='Tuchi:AwACCAQABRQEFgAIAQiQAABWDfQCBAoAFgAIAQiQAABVlPQCBAoAEAAFAQjIHwBVrLUBBAoACwABAQgzbgBXEzwABAoAAA==.',Va='Vanicton:AwABCAEABRQCFwAGAQiXFgBROxACBAoAFwAGAQiXFgBROxACBAoAAA==.Varanis:AwACCAMABRQAAA==.',Ve='Velianas:AwABCAEABAoAAA==.Verra:AwAECAkABAoAAA==.',Wa='Wampa:AwAECAoABAoAAA==.Wangstah:AwAICBQABAoCBQAIAQgwKgA0WhACBAoABQAIAQgwKgA0WhACBAoAAA==.Wargloves:AwAICAsABAoAAA==.',We='Weiss:AwACCAQABRQECwAIAQhpBgBYFxoDBAoACwAIAQhpBgBYFxoDBAoAFgABAQjDCwBTiV4ABAoAEAABAQh/awBNxz8ABAoAAA==.',Xy='Xylv:AwABCAEABAoAAA==.',Ya='Yagrum:AwAECAgABAoAAA==.',Ze='Zenya:AwAECAQABAoAAA==.',Zi='Zippit:AwADCAMABAoAAA==.',Zu='Zuga:AwAFCA0ABAoAAA==.',['Ô']='Ôbelix:AwAHCA8ABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end