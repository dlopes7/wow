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
 local lookup = {'Evoker-Devastation','Shaman-Elemental','Priest-Holy','Priest-Discipline','Priest-Shadow','DemonHunter-Havoc','Paladin-Retribution','DemonHunter-Vengeance','Unknown-Unknown',}; local provider = {region='US',realm='Uldaman',name='US',type='weekly',zone=42,date='2025-03-28',data={Ab='Abnis:AwAFCAUABAoAAA==.',Ac='Acnologiå:AwAFCAUABAoAAA==.',Ad='Ademar:AwAECAEABAoAAA==.',Az='Azulå:AwACCAIABAoAAA==.',Ba='Baelian:AwADCAMABAoAAA==.Balidrion:AwADCAEABAoAAA==.',Bl='Blkabyss:AwAICB8ABAoCAQAIAQj+BgBOiLYCBAoAAQAIAQj+BgBOiLYCBAoAAA==.',Bo='Boozi:AwACCAYABAoAAA==.',Br='Brohame:AwAFCAsABAoAAA==.',Ca='Calucedonas:AwADCAgABAoAAA==.Calyse:AwAFCAsABAoAAA==.Casima:AwACCAIABAoAAA==.',Ci='Cicila:AwAICAwABAoAAA==.',Cr='Crank:AwAHCAoABAoAAA==.',Di='Dina:AwACCAMABAoAAA==.',Dr='Dragin:AwADCAcABAoAAA==.',Ei='Eifel:AwADCAYABAoAAA==.',Fa='Fallynangel:AwADCAEABAoAAA==.Falroc:AwADCAMABRQCAgAIAQjHAgBd8isDBAoAAgAIAQjHAgBd8isDBAoAAA==.Falrok:AwAGCAYABAoAAA==.',Fe='Feraljitney:AwAECAgABAoAAA==.',Fi='Filho:AwADCAgABAoAAA==.',Fo='Foxalari:AwAGCAEABAoAAA==.',Fr='Fragglerock:AwAFCAkABAoAAA==.',['F�']='Fàlrock:AwAHCAcABAoAAQIAXfIDCAMABRQ=.',Gr='Gretchy:AwADCAEABAoAAA==.',Ho='Hovercraft:AwAFCAYABAoAAA==.',Hu='Huldir:AwAECAcABAoAAA==.',In='Indigobleue:AwAECAEABAoAAA==.',Ja='Japplen:AwABCAIABAoAAA==.',Je='Jepetto:AwAICBIABAoAAA==.',Ka='Kalzdemar:AwAFCA4ABAoAAA==.',La='Lañdo:AwABCAEABAoAAA==.',Lu='Lucentarlck:AwAICAgABAoAAA==.',Ma='Magici:AwADCAEABAoAAA==.Mashin:AwACCAEABAoAAA==.',Mo='Moonsaw:AwACCAMABAoAAA==.Morgarlan:AwABCAMABRQDAwAIAQjxDwBDPR4CBAoAAwAHAQjxDwBFMx4CBAoABAAFAQgFIQAytjgBBAoAAA==.',Mu='Mummsy:AwAFCAEABAoAAA==.',Ne='Neph:AwABCAEABAoAAA==.',Ni='Nishikki:AwADCAUABRQCBQADAQjxBQAg5dUABRQABQADAQjxBQAg5dUABRQAAA==.',Ny='Nyte:AwACCAIABAoAAA==.',Pa='Palmanance:AwADCAQABAoAAA==.',Pr='Prestolight:AwADCAUABAoAAA==.',Pu='Pulpdk:AwAECAQABAoAAA==.Pulptea:AwADCAQABRQCBgAIAQjDBgBYqiADBAoABgAIAQjDBgBYqiADBAoAAA==.',Ra='Ratraxx:AwAECAkABAoAAA==.',Re='Redrogue:AwADCAEABAoAAA==.',Ri='Riftan:AwAGCA0ABAoAAA==.',Sa='Sauce:AwABCAEABAoAAA==.',Se='Seloki:AwAHCAoABAoAAA==.',Sl='Slaytanic:AwAGCBoABAoCBwAGAQh6WgAvLnkBBAoABwAGAQh6WgAvLnkBBAoAAA==.',So='Solora:AwADCAUABAoAAA==.',Sp='Spacekadet:AwADCAYABRQCCAADAQhfAABgPE0BBRQACAADAQhfAABgPE0BBRQAAA==.',['S�']='Sûpêrglûê:AwACCAIABAoAAA==.',Te='Teralia:AwACCAMABAoAAQkAAAADCAEABAo=.',Th='Thorge:AwACCAQABAoAAA==.',Ti='Tian:AwAFCA4ABAoAAA==.',Vo='Voluus:AwADCAUABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end