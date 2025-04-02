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
 local lookup = {'Mage-Arcane','Warrior-Fury','Paladin-Holy','DeathKnight-Unholy','Shaman-Enhancement','Shaman-Restoration','DemonHunter-Havoc','DemonHunter-Vengeance','DeathKnight-Frost','Paladin-Retribution','Warrior-Arms','Evoker-Preservation','Evoker-Devastation','Unknown-Unknown',}; local provider = {region='US',realm='Vashj',name='US',type='weekly',zone=42,date='2025-03-28',data={Al='Alexichiban:AwAECAcABAoAAA==.',An='Angelona:AwABCAEABRQCAQAHAQiZAABfSeQCBAoAAQAHAQiZAABfSeQCBAoAAA==.',Aq='Aqui:AwAFCAYABAoAAA==.',Ba='Barquiel:AwADCAUABAoAAA==.Bayle:AwAHCBQABAoCAgAHAQiEJwAWHIcBBAoAAgAHAQiEJwAWHIcBBAoAAA==.',Be='Belirah:AwAECAUABAoAAA==.',Bl='Blitzkreig:AwABCAEABRQCAwAIAQgNFAAOqGUBBAoAAwAIAQgNFAAOqGUBBAoAAA==.',Bu='Bubbulubb:AwAHCBQABAoCBAAHAQjSEgBJEDcCBAoABAAHAQjSEgBJEDcCBAoAAA==.Bullthing:AwAECAIABAoAAA==.',Ca='Caldius:AwAFCAoABAoAAA==.Cassyn:AwABCAEABAoAAA==.',Ce='Cellileira:AwAFCAkABAoAAA==.',Ch='Chadmon:AwACCAIABAoAAA==.Chttrbox:AwADCAcABRQDBQADAQirBAAhZuMABRQABQADAQirBAAhZuMABRQABgACAQjKCgANh3cABRQAAA==.',Da='Daffeta:AwADCAIABAoAAA==.Dao:AwAICAgABAoAAA==.',De='Debbu:AwEDCAYABAoAAA==.Demonshine:AwAHCBQABAoDBwAHAQjJNAAhJncBBAoABwAGAQjJNAAl43cBBAoACAABAQhxRAAEthMABAoAAA==.Deãth:AwABCAEABAoAAA==.',Do='Doozler:AwAHCA8ABAoAAA==.',Du='Dumbledore:AwAGCA8ABAoAAA==.',['D�']='Dèadmeat:AwADCAMABAoAAA==.',En='Envision:AwACCAQABRQCCQAHAQh4AQBi+B8DBAoACQAHAQh4AQBi+B8DBAoAAA==.',Er='Eremetrii:AwAFCAsABAoAAA==.',Et='Ethiri:AwAGCAIABAoAAA==.',Fr='Frankielymon:AwADCAYABAoAAA==.',Gh='Ghorza:AwAHCAoABAoAAA==.',Go='Gosixers:AwAECAQABAoAAA==.',Gr='Gregor:AwABCAEABAoAAA==.',He='Hellonhooves:AwAICBAABAoAAA==.',Ho='Holyiron:AwAHCBQABAoCCgAHAQhFGQBW2J8CBAoACgAHAQhFGQBW2J8CBAoAAA==.',Hu='Hurak:AwAICAgABAoAAA==.',Hy='Hyacinthe:AwADCAUABAoAAA==.',Ka='Kayanica:AwABCAEABRQAAA==.',Ke='Keo:AwAFCBAABAoAAA==.',Ko='Korac:AwABCAEABAoAAA==.',Ku='Kumojo:AwAGCAoABAoAAA==.',Le='Lemen:AwAGCAkABAoAAA==.Letmego:AwAECAcABAoAAA==.',['L�']='Lègendairy:AwADCAMABAoAAA==.',Me='Meedlefinger:AwAECAsABAoAAA==.',Mi='Miscila:AwACCAIABAoAAA==.',Ny='Ny:AwAFCAoABAoAAA==.',Od='Odyssey:AwABCAEABRQDCwAHAQhQBgBT4ZwCBAoACwAHAQhQBgBT4ZwCBAoAAgACAQh2VAAxnnYABAoAAA==.',Pe='Pentasaurusr:AwABCAMABRQAAA==.',Ph='Phenom:AwAECAMABAoAAA==.',Po='Poke:AwAGCAgABAoAAA==.',Qu='Queteimporta:AwADCAYABAoAAA==.',Sc='Scarymonster:AwAHCBQABAoCCgAHAQiBIwBSuV8CBAoACgAHAQiBIwBSuV8CBAoAAA==.',Se='Seeturtle:AwAFCAkABAoAAA==.Serqet:AwABCAEABRQDDAAHAQgcCgAsFZ0BBAoADAAHAQgcCgAsFZ0BBAoADQAFAQgNGQBKM2IBBAoAAA==.',Sh='Shamueljaxon:AwAFCAkABAoAAA==.',Sk='Skyye:AwABCAEABAoAAA==.',St='Stearphen:AwAECAcABAoAAA==.',Ta='Tagdarasia:AwADCAMABAoAAA==.',Th='Thiccany:AwAFCAMABAoAAA==.',Ti='Tierax:AwAHCBAABAoAAA==.',Un='Uncertain:AwAGCAEABAoAAA==.',Ve='Vengeancez:AwAGCA4ABAoAAA==.',Vp='Vp:AwADCAMABAoAAA==.',Vy='Vynn:AwABCAEABAoAAQ4AAAAFCAoABAo=.',Wo='Wofgen:AwAGCAcABAoAAA==.',Yo='Yoladdie:AwAECAcABAoAAA==.',Ze='Zen:AwAICAUABAoAAA==.',['Z�']='Zúzokú:AwAECAcABAoAAA==.',['Ç']='Çhéèçh:AwACCAEABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end