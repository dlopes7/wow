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
 local lookup = {'Monk-Windwalker','Unknown-Unknown','Warrior-Arms','Warrior-Fury','DeathKnight-Blood','Mage-Fire','Warlock-Demonology','Warlock-Destruction','Shaman-Enhancement','Mage-Frost','Evoker-Augmentation','Evoker-Devastation','Priest-Discipline','Priest-Holy','DeathKnight-Unholy','Priest-Shadow','Warlock-Affliction','Hunter-BeastMastery','Druid-Balance','Druid-Feral','Paladin-Protection','Rogue-Subtlety',}; local provider = {region='US',realm='Malorne',name='US',type='weekly',zone=42,date='2025-03-29',data={Al='Alterboy:AwAFCA8ABAoAAA==.',An='Anelowyn:AwAGCA8ABAoAAA==.Anthor:AwAICAgABAoAAA==.Anyways:AwAFCA4ABAoAAA==.',Ap='Apocal:AwAFCAkABAoAAA==.',Ar='Arcanicus:AwADCAUABAoAAA==.',Au='Aurrios:AwAFCBAABAoAAA==.',Ba='Baozhi:AwABCAEABAoAAA==.Baraden:AwAGCA0ABAoAAA==.Basutai:AwAHCAIABAoAAA==.',Be='Beefy:AwAGCBEABAoAAA==.',Bh='Bhxdeeznutz:AwADCAIABAoAAA==.',Bi='Birgetta:AwAGCA4ABAoAAA==.Birus:AwADCAcABRQCAQADAQiiAwAz4f4ABRQAAQADAQiiAwAz4f4ABRQAAA==.',Bl='Blee:AwAECAcABAoAAA==.',Bo='Boomnblink:AwAGCBEABAoAAA==.Boomshot:AwADCAQABAoAAQIAAAAHCAwABAo=.Boppa:AwACCAIABAoAAA==.Bownir:AwAGCBEABAoAAA==.',Bu='Bubonic:AwACCAQABAoAAA==.',Ch='Chalis:AwABCAEABRQAAA==.Challen:AwABCAEABRQDAwAIAQjmDgBCtAACBAoABAAHAQizGgA2GgcCBAoAAwAHAQjmDgBC5gACBAoAAA==.Charlondo:AwAGCAsABAoAAA==.Cheezypoofs:AwAFCAcABAoAAA==.',Cl='Clamsquirter:AwAGCBEABAoAAA==.',Cr='Crysis:AwAHCBIABAoAAA==.',De='Deathman:AwABCAEABRQCBQAIAQgECgBDllgCBAoABQAIAQgECgBDllgCBAoAAA==.Desmordin:AwABCAEABAoAAA==.Deäthrose:AwAGCBEABAoAAA==.',Dh='Dhomsak:AwAICAcABAoAAQYAVtECCAMABRQ=.',Do='Doominatrix:AwAECAoABAoAAA==.',Dr='Dragonhams:AwAGCBEABAoAAA==.Drip:AwAECAkABAoAAA==.Drytoast:AwADCAIABAoAAA==.',Du='Dumbledore:AwAHCAwABAoAAA==.',Ev='Evillux:AwABCAEABRQDBwAIAQj2BwBI3fEBBAoABwAGAQj2BwBDq/EBBAoACAAGAQiQKABEVacBBAoAAA==.',Fa='Fauxtotem:AwABCAEABRQCCQAIAQiKCABKub8CBAoACQAIAQiKCABKub8CBAoAAA==.',Fl='Fletch:AwABCAEABRQAAA==.',['F�']='Fënn:AwAGCA8ABAoAAA==.',Ga='Galaxsea:AwAGCAYABAoAAA==.',Gf='Gfour:AwAHCAIABAoAAA==.',Ho='Homsorc:AwACCAMABRQDBgAIAQj7BwBW0QQDBAoABgAIAQj7BwBW0QQDBAoACgAEAQi4SwAjUbMABAoAAA==.Hope:AwAFCAEABAoAAA==.',Ka='Kammo:AwAHCBIABAoAAA==.Katla:AwADCAMABAoAAA==.',Ko='Konico:AwAECAcABAoAAA==.',La='Lazdrake:AwABCAEABRQDCwAIAQjUAAA6iwsCBAoACwAIAQjUAAA6YQsCBAoADAAFAQhXIwAZ3u8ABAoAAA==.',Lu='Lukadonthyrr:AwACCAIABRQDDQAIAQjBCgBCWlUCBAoADQAIAQjBCgBBRlUCBAoADgACAQgGTwAmyn0ABAoAAA==.',Ma='Malasiea:AwABCAEABRQCDwAIAQjtDgBGF3ECBAoADwAIAQjtDgBGF3ECBAoAAA==.Maleficênt:AwABCAEABRQCEAAIAQjcDgA8XEcCBAoAEAAIAQjcDgA8XEcCBAoAAA==.',Mo='Moji:AwADCAYABAoAAA==.Moncow:AwAGCBEABAoAAA==.Monstermayi:AwAGCBEABAoAAA==.',Mu='Muggyvagoo:AwACCAIABAoAAQIAAAAFCAoABAo=.',My='Mytastical:AwAHCBAABAoAAA==.',Na='Najwah:AwAGCAYABAoAAA==.Namalis:AwABCAEABRQEBwAHAQj/EQBHY1EBBAoABwAEAQj/EQBQoVEBBAoAEQAEAQihDwA/tREBBAoACAAEAQhRTAAywd4ABAoAAA==.',No='Nonae:AwABCAEABRQCEgAIAQgsFgBPFKcCBAoAEgAIAQgsFgBPFKcCBAoAAA==.Norsydrieth:AwACCAMABAoAAA==.Nosliw:AwAICAgABAoAAA==.',Nu='Nubruzine:AwAGCA4ABAoAAA==.',Om='Omegá:AwAFCA8ABAoAAA==.',Os='Ostarielyn:AwADCAMABAoAAA==.',Pa='Para:AwAHCBUABAoCAQAHAQi7HAAkv44BBAoAAQAHAQi7HAAkv44BBAoAAQIAAAABCAEABRQ=.Pawfu:AwAGCA0ABAoAAA==.',Pi='Piyyah:AwAGCAEABAoAAA==.',Pr='Pristia:AwAHCA4ABAoAAA==.',Ps='Psychic:AwAFCAsABAoAAA==.',Pu='Puma:AwADCAgABRQDEwADAQi7AgBhVk8BBRQAEwADAQi7AgBhVk8BBRQAFAABAQhTAwBXylIABRQAAA==.',Ra='Raddh:AwAGCBAABAoAAA==.Ratha:AwABCAEABRQCFQAIAQjWEwAghVsBBAoAFQAIAQjWEwAghVsBBAoAAA==.',Ri='Rick:AwAGCBUABAoCFgAGAQguFwAju2kBBAoAFgAGAQguFwAju2kBBAoAAA==.',Rx='Rxdh:AwACCAEABAoAAA==.',Sa='Saaros:AwACCAMABAoAAA==.',Sc='Scottamus:AwAICAMABAoAAA==.',Sh='Shikyokami:AwACCAIABAoAAA==.Shockem:AwAFCAwABAoAAA==.',Sk='Skoochie:AwACCAIABAoAAA==.',Sp='Sprigg:AwACCAIABAoAAA==.',St='Stonedpriest:AwAFCAwABAoAAA==.',Sy='Syllubear:AwAGCBEABAoAAA==.',Te='Teias:AwABCAEABRQCDgAIAQgzBwBPwqsCBAoADgAIAQgzBwBPwqsCBAoAAA==.',Ti='Tigerscale:AwADCAYABRQCDAADAQiTBAAtvuwABRQADAADAQiTBAAtvuwABRQAAA==.',Tr='Trala:AwAFCAUABAoAAA==.Trunkmonkey:AwAFCAkABAoAAA==.',Ts='Tsaagan:AwAGCBEABAoAAA==.',Tw='Twilightmoon:AwAGCBcABAoCEAAGAQhkGQA9vasBBAoAEAAGAQhkGQA9vasBBAoAAA==.',Ty='Tychusad:AwACCAQABAoAAA==.',Un='Unholyhannah:AwAICBAABAoAAA==.',Va='Vagew:AwAFCAoABAoAAA==.',Wi='Wiccaflame:AwAGCA4ABAoAAA==.',Xe='Xencure:AwAGCBAABAoAAA==.Xerk:AwAFCAwABAoAAQUAQ5YBCAEABRQ=.',Ya='Yareli:AwAFCAwABAoAAA==.',Ze='Zekröm:AwAFCAkABAoAARAAPFwBCAEABRQ=.Zenodwarf:AwABCAEABRQAAA==.',Zi='Zinbar:AwAFCAgABAoAAA==.',Zu='Zune:AwAGCAYABAoAAA==.Zutin:AwAICAgABAoAAA==.',['Ç']='Çløud:AwAFCAUABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end