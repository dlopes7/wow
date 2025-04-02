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
 local lookup = {'Mage-Fire','Mage-Frost','Unknown-Unknown','DemonHunter-Havoc','Monk-Windwalker','Shaman-Restoration','DeathKnight-Unholy','Druid-Balance','Shaman-Enhancement','Mage-Arcane','Warlock-Demonology','Warlock-Destruction','Warlock-Affliction',}; local provider = {region='US',realm='Archimonde',name='US',type='weekly',zone=42,date='2025-03-29',data={Ag='Agamand:AwABCAEABAoAAA==.',Al='Alodi:AwACCAQABRQDAQAIAQgfHQA5BSMCBAoAAQAIAQgfHQA45yMCBAoAAgAFAQgKPQAolfUABAoAAA==.',An='Anomander:AwAECAcABAoAAA==.',Ar='Arcantum:AwADCAUABAoAAA==.',Bl='Blinklock:AwAFCAoABAoAAA==.',Bo='Bonetrain:AwACCAMABAoAAQMAAAADCAcABAo=.',Br='Brightblayde:AwADCAQABAoAAA==.',Ca='Catfud:AwAECAcABAoAAA==.',Ch='Chayse:AwABCAIABRQAAA==.Chérry:AwABCAEABRQCBAAIAQipFQBB/XMCBAoABAAIAQipFQBB/XMCBAoAAA==.',Co='Cowschwitz:AwACCAMABAoAAA==.',Cy='Cynestra:AwADCAUABAoAAA==.',Da='Daftmonk:AwABCAIABRQCBQAIAQiUAgBd9EADBAoABQAIAQiUAgBd9EADBAoAAA==.Darmonevil:AwAGCAYABAoAAA==.',De='Dethblow:AwADCAkABAoAAA==.',Di='Diwa:AwAHCBQABAoCBgAHAQivKAAv3o4BBAoABgAHAQivKAAv3o4BBAoAAA==.',Dr='Draviin:AwAGCA8ABAoAAA==.',Du='Duralast:AwACCAUABAoAAA==.',['D�']='Dâemeon:AwAHCBoABAoCBwAHAQjfLwATbEwBBAoABwAHAQjfLwATbEwBBAoAAA==.',Ep='Epitaph:AwAFCA8ABAoAAA==.',Fe='Fearosia:AwABCAEABAoAAA==.Fenrisfangs:AwAECAEABAoAAA==.',Fu='Furibeav:AwAFCAwABAoAAA==.',Ga='Gallindral:AwAFCAIABAoAAA==.',Ha='Hades:AwACCAMABAoAAA==.',Kr='Krasis:AwAICA8ABAoAAA==.Krispinwah:AwAGCBEABAoAAA==.',La='Lanc:AwAFCAoABAoAAA==.Lazertoe:AwABCAEABAoAAQMAAAAFCAkABAo=.',Le='Lealta:AwABCAEABRQAAA==.',Lo='Lover:AwAECAYABAoAAQgARs4GCBYABAo=.',Ly='Lysius:AwADCAMABAoAAA==.',Ma='Magicj:AwAGCAYABAoAAQkAXHcFCA8ABRQ=.Marv:AwABCAEABAoAAA==.Mauê:AwADCAQABAoAAA==.',My='Mylodon:AwAGCAwABAoAAA==.',Ni='Niad:AwAHCBQABAoDAgAHAQiyBwBbBcQCBAoAAgAHAQiyBwBbBcQCBAoACgADAQguCgAnK4YABAoAAA==.Nickalos:AwAHCBEABAoAAA==.',No='Notorckrag:AwACCAIABAoAAA==.',Nu='Nut:AwAHCBIABAoAAA==.',Ny='Nythos:AwACCAIABAoAAA==.',Or='Originalgank:AwABCAEABAoAAA==.',Qu='Quickchicken:AwAECAQABAoAAA==.',Ra='Rastris:AwAICBAABAoAAA==.',Sa='Salorian:AwAECAIABAoAAA==.',Sc='Scotthunts:AwADCAMABAoAAA==.Scottmonk:AwABCAEABAoAAA==.',Se='Seaborne:AwAECAkABAoAAA==.',Sh='Shamerica:AwACCAQABRQCCQAIAQjVAwBV4CADBAoACQAIAQjVAwBV4CADBAoAAA==.Shottysnipes:AwADCAUABAoAAA==.',Sk='Skylz:AwAHCBMABAoAAA==.',So='Solinjir:AwAGCAEABAoAAA==.',Sp='Spekaleks:AwACCAIABAoAAA==.',St='Starbuxx:AwAFCAMABAoAAA==.',Tc='Tchillz:AwAHCBIABAoAAA==.',Th='Theinsider:AwAGCBAABAoAAA==.',Ti='Tigerbait:AwABCAEABAoAAA==.',Tr='Tranza:AwAECAUABAoAAA==.',Uk='Ukehunt:AwAGCA4ABAoAAA==.',Wr='Wraithsdaddy:AwADCAQABAoAAA==.',Wt='Wtfmate:AwAFCAwABAoAAA==.',Xa='Xaioli:AwAHCBUABAoECwAHAQjTBwBYl/QBBAoACwAFAQjTBwBemPQBBAoADAAEAQghNwBRl0kBBAoADQABAQiQJABEOk4ABAoAAA==.Xaladin:AwACCAIABAoAAA==.',Xu='Xunasha:AwABCAEABAoAAA==.',Ze='Zendrex:AwABCAEABAoAAA==.',Zi='Zipett:AwAFCAkABAoAAA==.',Zo='Zornt:AwACCAIABAoAAA==.Zoroa:AwACCAEABAoAAQMAAAACCAIABAo=.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end