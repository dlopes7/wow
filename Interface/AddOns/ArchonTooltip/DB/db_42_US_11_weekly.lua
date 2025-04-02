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
 local lookup = {'Shaman-Elemental','Unknown-Unknown','Paladin-Retribution','Shaman-Enhancement','Warrior-Fury','Warrior-Protection',}; local provider = {region='US',realm='Andorhal',name='US',type='weekly',zone=42,date='2025-03-29',data={Ai='Aiedel:AwAECAMABAoAAA==.',An='Angahax:AwAECAMABAoAAA==.',Ar='Ariosx:AwAFCAQABAoAAA==.Arrowchef:AwAGCAIABAoAAA==.',Ba='Balob:AwABCAEABRQCAQAHAQhMCQBT36UCBAoAAQAHAQhMCQBT36UCBAoAAA==.',Bl='Blaksmoke:AwADCAIABAoAAA==.',Br='Brueface:AwAECAQABAoAAA==.',Bu='Bubbly:AwACCAQABAoAAA==.',Ce='Cernun:AwAHCBMABAoAAA==.',De='Dezric:AwAFCAgABAoAAA==.',El='Elnaris:AwACCAQABAoAAA==.',Eo='Eon:AwAECAYABAoAAA==.',Er='Eriu:AwACCAMABAoAAQIAAAAFCAQABAo=.',Fi='Fire:AwADCAMABAoAAA==.Fistsoffluff:AwADCAMABAoAAA==.',Gi='Giltordon:AwAHCBEABAoAAA==.Gitzi:AwAHCBMABAoAAA==.',Gl='Glaciea:AwAFCAkABAoAAA==.',Gr='Greasytotems:AwAECAUABAoAAA==.',Jo='Jolty:AwACCAQABAoAAA==.',Jr='Jrbacncheze:AwAECAcABAoAAA==.',Ka='Kainicus:AwACCAIABAoAAA==.Kainshala:AwAHCBEABAoAAA==.Kaosu:AwAFCAcABAoAAA==.Karina:AwAGCBQABAoCAwAGAQgofAAaryUBBAoAAwAGAQgofAAaryUBBAoAAA==.',Ke='Keoni:AwAECAYABAoAAA==.',Ki='Kiljin:AwAFCAkABAoAAA==.',Ko='Kokobubbles:AwACCAIABAoAAA==.',Li='Littlemenace:AwAFCAUABAoAAA==.',Lu='Luigimangion:AwABCAEABAoAAA==.Luminusrayne:AwAHCBMABAoAAA==.',Me='Meheret:AwAHCA4ABAoAAA==.',Mu='Munt:AwAHCBUABAoCBAAHAQiHCwBVcYkCBAoABAAHAQiHCwBVcYkCBAoAAA==.',My='Mystx:AwACCAIABAoAAQIAAAAFCAQABAo=.Mythx:AwAICBgABAoDBQAIAQitCABRmt0CBAoABQAIAQitCABRmt0CBAoABgACAQiOIAAsYFkABAoAAA==.',Na='Nae:AwAICBAABAoAAA==.Nami:AwAGCAQABAoAAA==.',No='Nordblade:AwAECAYABAoAAA==.',Ol='Olsilion:AwACCAIABAoAAA==.',Om='Omegalulz:AwAHCBMABAoAAA==.',Po='Pokochu:AwAHCBMABAoAAA==.',Pr='Prey:AwAFCAMABAoAAA==.',Pu='Puddingface:AwAHCBIABAoAAA==.',Ra='Rauhk:AwADCAMABAoAAA==.',Re='Rez:AwAFCAUABAoAAA==.',Rh='Rhysan:AwAHCBMABAoAAA==.',Ru='Rude:AwAGCAYABAoAAA==.',Ry='Ryugen:AwAHCBMABAoAAA==.',Se='Sebnoth:AwADCAoABAoAAA==.',Sh='Sham:AwAECAgABAoAAA==.',Si='Sillyderek:AwAECAIABAoAAA==.',Sp='Spaceboss:AwACCAIABAoAAA==.',Su='Sunwa:AwACCAMABAoAAQIAAAAFCAQABAo=.',['SÃ']='SÃ¯mba:AwAICAsABAoAAA==.',Vy='Vyndreal:AwABCAEABAoAAA==.',Wa='Walls:AwAECAQABAoAAA==.',Wi='Wingedlizard:AwAFCAUABAoAAA==.',Zh='Zhal:AwAGCAQABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end