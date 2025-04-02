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
 local lookup = {'Unknown-Unknown','DeathKnight-Frost','Mage-Fire','Mage-Frost','DemonHunter-Havoc',}; local provider = {region='US',realm='Runetotem',name='US',type='weekly',zone=42,date='2025-03-29',data={Al='Alwan:AwAHCA4ABAoAAA==.Aly:AwADCAYABAoAAA==.',Ar='Arithana:AwAFCBAABAoAAA==.',Ay='Aybrams:AwADCAMABAoAAA==.',Bl='Blameton:AwAICAgABAoAAA==.',Bu='Buford:AwADCAYABAoAAA==.',Ca='Calese:AwADCAIABAoAAA==.',Ci='Cindyx:AwACCAEABAoAAQEAAAADCAYABAo=.',Co='Colossians:AwADCAUABAoAAA==.',Cr='Crazyloon:AwAFCAkABAoAAA==.',Cy='Cynthea:AwAICAgABAoAAA==.',Di='Dindaratwo:AwAFCBAABAoAAA==.',Du='Dumbledaddy:AwABCAEABRQAAA==.',Es='Estark:AwAECAUABAoAAA==.',Ev='Evissier:AwAGCAwABAoAAA==.',Fa='Fae:AwAICAgABAoAAA==.',Fi='Finir:AwABCAEABAoAAA==.',Fr='Frostfirer:AwAICAgABAoAAA==.',Go='Gooblicious:AwAFCAYABAoAAA==.',Gr='Grievace:AwACCAMABRQCAgAIAQgHAgBW5QADBAoAAgAIAQgHAgBW5QADBAoAAA==.',Ho='Honourablee:AwAGCBIABAoAAA==.',Hy='Hymnals:AwAGCA0ABAoAAA==.',['H�']='Héyl:AwABCAEABAoAAA==.',Ja='Jayber:AwABCAEABRQAAA==.',Kt='Ktom:AwAGCBIABAoAAA==.',['K�']='Kårnåge:AwAECAQABAoAAA==.',Le='Lennykoggins:AwAFCBMABAoAAA==.Lepriest:AwABCAEABAoAAA==.',Li='Lightnup:AwAECAIABAoAAQMAS2oBCAEABRQ=.',Lo='Lostatotem:AwAFCAgABAoAAA==.',Ma='Magêyalook:AwABCAEABRQDAwAHAQiTGABLak8CBAoAAwAHAQiTGABLak8CBAoABAABAQj4bwAJSDUABAoAAA==.Manzz:AwADCAUABAoAAA==.',Mu='Murakumo:AwAFCAUABAoAAA==.',Na='Nareík:AwAFCBAABAoAAA==.',Or='Orkrist:AwACCAIABAoAAA==.',Po='Powertool:AwAECAkABAoAAA==.',['P�']='Pårts:AwACCAUABAoAAA==.',Ro='Rottingtree:AwABCAEABAoAAA==.',Se='Seaka:AwAECAoABAoAAA==.',Sh='Shpadoinkle:AwAICAIABAoAAA==.Shrech:AwAGCBAABAoAAA==.',Sl='Slyicer:AwAFCAUABAoAAA==.',So='Soxs:AwAFCA4ABAoAAA==.',['S�']='Sérénity:AwAECAkABAoAAA==.',Ta='Tartanus:AwAHCBQABAoCBQAHAQhQPgASr0kBBAoABQAHAQhQPgASr0kBBAoAAA==.Tayzetv:AwABCAEABRQAAA==.',To='Tombstone:AwAGCBIABAoAAA==.Topoide:AwAFCAEABAoAAA==.',Xt='Xtronius:AwAFCAwABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end