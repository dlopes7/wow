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
 local lookup = {'Monk-Windwalker','Monk-Mistweaver','Warrior-Protection','Unknown-Unknown','Paladin-Retribution',}; local provider = {region='US',realm='Dentarg',name='US',type='weekly',zone=42,date='2025-03-29',data={Aa='Aaragath:AwEECAEABAoAAA==.',Ae='Aenlori:AwADCAQABRQDAQAIAQhREgBGqw0CBAoAAQAHAQhREgBFGQ0CBAoAAgAIAQgXJwATzWoBBAoAAA==.',Ai='Aikar:AwADCAcABAoAAA==.',Be='Beldrof:AwACCAQABAoAAA==.',Bl='Bleed:AwAGCA0ABAoAAA==.',Br='Braiglock:AwAECAgABAoAAA==.',Bu='Buu:AwADCAEABAoAAA==.',Ca='Caarmageddon:AwAHCBEABAoAAA==.',De='Deathphish:AwAGCAEABAoAAA==.Denardirn:AwAHCAYABAoAAA==.Deshler:AwABCAEABAoAAA==.',Di='Ditlutz:AwAECAwABAoAAA==.',Do='Dom:AwACCAQABRQCAwAIAQhhBABCV1ICBAoAAwAIAQhhBABCV1ICBAoAAA==.',Dr='Drius:AwAICAIABAoAAA==.',El='Ellrond:AwAECAQABAoAAA==.',En='Entropy:AwAECAwABAoAAA==.',Ev='Evasong:AwAFCAEABAoAAA==.',Fa='Faenza:AwEDCAgABAoAAA==.',Fe='Fenrir:AwAFCAEABAoAAA==.',Gi='Gigglebatt:AwAECAEABAoAAA==.',Ha='Hassadah:AwADCAMABAoAAA==.',He='Hej:AwAFCAEABAoAAA==.',Ho='Holîcow:AwAICBAABAoAAA==.Hoofingit:AwABCAEABAoAAA==.',Hu='Hugepenance:AwAICBAABAoAAA==.',Im='Imortalfury:AwAHCBEABAoAAA==.',It='Ithys:AwACCAIABAoAAA==.',Je='Jeffrey:AwABCAIABAoAAA==.',Ju='Juan:AwAECAwABAoAAA==.Jumpeor:AwAFCAcABAoAAQQAAAAICAUABAo=.',Ke='Keloretta:AwAECAwABAoAAA==.Kethria:AwAFCAUABAoAAA==.',Ki='Kiira:AwAGCAoABAoAAA==.Kilthgar:AwAECAwABAoAAA==.',Le='Lennin:AwAGCAwABAoAAA==.',Lo='Lokiel:AwAGCA4ABAoAAA==.',Ly='Lydius:AwAGCAEABAoAAA==.',Ma='Magrøk:AwAECAUABAoAAA==.',Mu='Muffs:AwACCAIABAoAAA==.',Ne='Nequin:AwAECAYABAoAAQQAAAAGCAEABAo=.Nequins:AwAGCAEABAoAAA==.',Ni='Niobe:AwACCAIABAoAAA==.Nirvaná:AwADCAMABAoAAA==.',Pi='Picantechode:AwAICAoABAoAAA==.Pierre:AwAGCA0ABAoAAQQAAAAICAgABAo=.',Po='Pounds:AwACCAUABAoAAA==.',Py='Pyrazus:AwAECAsABAoAAA==.Pyrochew:AwADCAUABAoAAA==.',Re='Remulüs:AwAGCA4ABAoAAA==.',Rh='Rhimeholt:AwAECAwABAoAAA==.',Sc='Scalebeard:AwAGCA4ABAoAAA==.',Se='Sesamo:AwACCAQABRQCBQAIAQhtCgBaeR8DBAoABQAIAQhtCgBaeR8DBAoAAA==.',Si='Sixoneseven:AwAECAEABAoAAA==.',So='Solatic:AwADCAMABAoAAA==.',St='Stormina:AwADCAUABAoAAA==.Stormwoolf:AwACCAEABAoAAA==.',Ta='Takoda:AwAGCAoABAoAAA==.Tashamia:AwABCAEABAoAAA==.',Ti='Tidereign:AwACCAIABAoAAA==.',Tr='Tranquilityy:AwAFCAoABAoAAA==.Trinanah:AwAHCBAABAoAAA==.',Un='Unoimaqtpie:AwAFCAwABAoAAA==.',Va='Valor:AwAECAYABAoAAA==.',Ve='Velkuvrana:AwACCAIABAoAAA==.',We='Wef:AwACCAUABAoAAA==.',Wh='Whaitiri:AwAECAEABAoAAA==.',Wi='Wings:AwAFCAkABAoAAA==.',Wo='Wolfhound:AwABCAIABAoAAA==.',Za='Zaldesh:AwABCAIABAoAAA==.',Zu='Zulanta:AwAICA4ABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end