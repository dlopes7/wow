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
 local lookup = {'Warrior-Arms','Warlock-Affliction','Warlock-Destruction','Warlock-Demonology','Warrior-Fury','Unknown-Unknown','Rogue-Assassination','Hunter-Survival',}; local provider = {region='US',realm='Darrowmere',name='US',type='weekly',zone=42,date='2025-03-29',data={Ah='Ahnari:AwAECAkABAoAAA==.',Ai='Ailinaa:AwAHCBgABAoCAQAHAQjpBwBUU38CBAoAAQAHAQjpBwBUU38CBAoAAA==.',Al='Alinety:AwAECAgABAoAAA==.Alistin:AwAECAQABAoAAA==.',Ar='Armswar:AwAHCAwABAoAAA==.',As='Asriel:AwAFCAIABAoAAA==.',Be='Beeftruck:AwAFCAkABAoAAA==.',Bi='Biminem:AwACCAQABAoAAA==.',Ce='Cedrina:AwABCAEABAoAAA==.',Co='Cocstrong:AwAICAgABAoAAA==.',Da='Dawnbringer:AwAECAcABAoAAA==.',De='Deathbyslak:AwABCAEABAoAAA==.Deatho:AwACCAMABAoAAA==.Deimos:AwACCAQABAoAAA==.',['D�']='Dësìre:AwAGCAoABAoAAA==.',Fa='Fatherowo:AwAFCA0ABAoAAA==.',Fi='Fineapple:AwADCAQABAoAAA==.',Ga='Gankone:AwADCAMABAoAAA==.',Gr='Graffin:AwACCAIABAoAAA==.',Ha='Harshdh:AwAFCA4ABAoAAA==.',He='Heimer:AwABCAEABAoAAA==.',Hz='Hzivvee:AwAFCAUABAoAAA==.',Ja='Jabmöney:AwAGCAIABAoAAA==.',Ji='Jirac:AwAECAoABAoAAA==.',Ka='Kabuki:AwABCAEABAoAAA==.Kaytes:AwABCAEABAoAAA==.',Kh='Khrysus:AwADCAEABAoAAA==.',Kr='Kravitz:AwAECAMABAoAAA==.',Mi='Mickfurry:AwABCAIABRQEAgAIAQhvAQBNpLgCBAoAAgAIAQhvAQBNpLgCBAoAAwAFAQjNPQAy5yQBBAoABAABAQhbOQA+8E8ABAoAAA==.',Mo='Momoki:AwADCAEABAoAAA==.',Mu='Murthunt:AwAECAIABAoAAA==.',My='Mylarna:AwABCAIABAoAAA==.',No='Nocticula:AwADCAMABAoAAA==.',Ny='Nyet:AwACCAIABRQDAQAIAQiiBwBEQ4UCBAoAAQAIAQiiBwBEQ4UCBAoABQAFAQiXOgAiXg0BBAoAAA==.',['N�']='Nòir:AwABCAEABAoAAA==.',Og='Ogredline:AwACCAIABAoAAA==.',Or='Orioz:AwAECAoABAoAAA==.',Rh='Rhaellia:AwADCAEABAoAAA==.',Ro='Roflburger:AwABCAEABAoAAA==.Rotisserie:AwABCAEABAoAAQYAAAADCAQABAo=.',Sa='Saltlander:AwADCAEABAoAAA==.',Sc='Scaliesowo:AwACCAMABAoAAQYAAAAFCA0ABAo=.',Sk='Skdragon:AwABCAEABAoAAA==.Skyo:AwACCAIABRQCBwAHAQiBAwBc1eUCBAoABwAHAQiBAwBc1eUCBAoAAA==.',Sp='Sprinkler:AwAECAQABAoAAQgAY8ACCAUABRQ=.',Sy='Sykoman:AwAECAQABAoAAQcAXNUCCAIABRQ=.',Ta='Taintedknigt:AwAECAUABAoAAA==.',Th='Thornbeast:AwACCAMABAoAAQYAAAAFCA0ABAo=.Thízz:AwAGCAEABAoAAA==.',To='Toetoeto:AwAECAIABAoAAA==.',Wa='Wallbears:AwACCAMABRQAAA==.',Wi='Windwalker:AwAHCAEABAoAAA==.',['Å']='Åpocalypse:AwADCAEABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end