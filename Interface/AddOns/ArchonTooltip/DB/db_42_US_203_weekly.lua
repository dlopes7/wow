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
 local lookup = {'Paladin-Retribution','Unknown-Unknown','DemonHunter-Havoc','Shaman-Restoration','Druid-Balance',}; local provider = {region='US',realm='Staghelm',name='US',type='weekly',zone=42,date='2025-03-28',data={Ab='Absens:AwAECAsABAoAAA==.',An='Anyaesthesia:AwAECAIABAoAAA==.',Ar='Artto:AwACCAEABAoAAA==.',Au='Auragel:AwAGCA8ABAoAAA==.',Av='Avyrax:AwAECAIABAoAAA==.',Ba='Baylohn:AwADCAYABAoAAA==.',Be='Beast:AwACCAMABRQCAQAIAQjoAgBh92sDBAoAAQAIAQjoAgBh92sDBAoAAA==.',Bl='Bladed:AwAECAIABAoAAA==.Bloodveil:AwADCAMABAoAAQIAAAAECAUABAo=.',Bo='Bovinedivine:AwABCAEABAoAAQIAAAAECA0ABAo=.',Br='Brommelle:AwADCAEABAoAAA==.',Ch='Chaz:AwADCAMABAoAAA==.Chazlockx:AwAICAQABAoAAA==.',Da='Darkstär:AwADCAMABAoAAA==.',De='Deacon:AwAECAsABAoAAA==.Denji:AwACCAEABAoAAA==.Deydraeroeda:AwADCAUABRQCAwADAQgTCAActs8ABRQAAwADAQgTCAActs8ABRQAAA==.',Do='Dotsfodays:AwAECAIABAoAAA==.',Du='Dubes:AwADCAMABAoAAA==.Dustre:AwAFCAsABAoAAA==.',Ei='Eightbitwhit:AwAICAYABAoAAA==.',El='Eldari:AwAECAgABAoAAA==.Elem:AwABCAEABRQCBAAIAQjCIQAkkrMBBAoABAAIAQjCIQAkkrMBBAoAAA==.',Er='Erwindia:AwADCAMABAoAAA==.',Ey='Eye:AwADCAMABAoAAA==.',Ez='Ezi:AwAECAIABAoAAA==.',Fi='Fionnan:AwADCAMABAoAAA==.',Fr='Fracture:AwAGCAIABAoAAA==.Frosch:AwAECAUABAoAAQIAAAAECAUABAo=.',Ga='Gabimuru:AwAGCAkABAoAAA==.',Go='Goof:AwAGCA4ABAoAAA==.',Gr='Griz:AwADCAUABAoAAA==.Grizzly:AwADCAMABAoAAQIAAAADCAUABAo=.',Ha='Haddor:AwACCAIABAoAAA==.Hatrid:AwAECA0ABAoAAA==.Haunter:AwADCAYABAoAAA==.',Hi='Hilitemonk:AwAECAIABAoAAA==.',Ho='Holymommy:AwAECAUABAoAAA==.',Hv='Hvac:AwADCAMABAoAAA==.',Ja='Jackie:AwADCAQABAoAAA==.',Ji='Jinn:AwAHCBMABAoAAA==.',Ka='Kallikan:AwAECAIABAoAAA==.',Ke='Kesha:AwAECA0ABAoAAA==.',Ki='Kikariko:AwADCAUABAoAAA==.Kilaaz:AwAECAYABAoAAA==.',Le='Lealoo:AwACCAIABAoAAQIAAAADCAEABAo=.',Lo='Lovelydread:AwABCAEABAoAAA==.',Ly='Lyandre:AwABCAEABRQAAA==.Lyntu:AwAFCAgABAoAAA==.',Ma='Malkariss:AwAECAoABAoAAA==.Mathwhiz:AwACCAIABAoAAA==.Matãdor:AwABCAEABAoAAA==.',Me='Meowkitty:AwAECAIABAoAAA==.',Mo='Moghroth:AwAECA0ABAoAAA==.',Ne='Necrocia:AwAECAIABAoAAA==.',No='Norlav:AwAGCAEABAoAAA==.',Oh='Ohsyriss:AwADCAMABAoAAA==.',On='Onlyducky:AwAECAMABAoAAA==.',Os='Osteovine:AwAECAQABAoAAA==.',Po='Pojoevokest:AwAECAIABAoAAA==.',Ra='Raakotah:AwAHCBQABAoCBQAHAQjIDgBX4JACBAoABQAHAQjIDgBX4JACBAoAAA==.Raelo:AwAECAoABAoAAA==.',Re='Resco:AwAECAEABAoAAA==.',Ro='Roastmasterx:AwAICAEABAoAAA==.Rosepiercer:AwADCAYABAoAAA==.',Ry='Ryull:AwAECAIABAoAAA==.',Sa='Samandean:AwADCAEABAoAAA==.Sapphyra:AwACCAIABAoAAA==.',Sc='Schmuppet:AwAECAIABAoAAA==.',Se='Sellena:AwABCAEABAoAAQIAAAADCAEABAo=.',Sh='Shammatic:AwACCAIABAoAAA==.Shaofhit:AwADCAMABAoAAA==.Shocolatte:AwAECAIABAoAAA==.',Si='Siccinok:AwADCAIABAoAAA==.Sindorian:AwACCAMABAoAAA==.',Sm='Smugpt:AwAFCAYABAoAAA==.',So='Soko:AwADCAYABAoAAA==.Solastra:AwAECAsABAoAAA==.',St='Staryxia:AwAECAoABAoAAA==.',Su='Sulwen:AwAGCA0ABAoAAA==.',Ta='Tanklndunkil:AwADCAMABAoAAA==.',Va='Valenora:AwACCAIABAoAAA==.',Wa='Wallofshame:AwACCAEABAoAAA==.Wartooth:AwAECAIABAoAAA==.',Xy='Xyleiah:AwADCAMABAoAAA==.',['X�']='Xároth:AwAECA0ABAoAAA==.',Ya='Yanci:AwAECAwABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end