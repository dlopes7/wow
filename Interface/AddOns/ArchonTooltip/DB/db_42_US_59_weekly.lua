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
 local lookup = {'Shaman-Enhancement','Warrior-Fury','Shaman-Restoration','Shaman-Elemental','Unknown-Unknown','Druid-Balance',}; local provider = {region='US',realm='DarkIron',name='US',type='weekly',zone=42,date='2025-03-29',data={Ae='Aeriea:AwADCAUABAoAAA==.',Ah='Ahmadeus:AwAECAYABAoAAA==.',Ai='Aibertabeef:AwAGCAYABAoAAA==.Aidsboii:AwAGCAYABAoAAA==.',Al='Albertehbeef:AwAGCBUABAoCAQAGAQh3FQBGvOsBBAoAAQAGAQh3FQBGvOsBBAoAAA==.Albetabeef:AwAGCBYABAoCAgAGAQgbFQBcGz4CBAoAAgAGAQgbFQBcGz4CBAoAAA==.Alith:AwADCAYABAoAAA==.Allhopeisded:AwABCAEABAoAAA==.',Am='Amage:AwAICAgABAoAAA==.Amanita:AwAGCAsABAoAAA==.Amelaista:AwAFCAUABAoAAA==.',An='Angusbeef:AwAFCAsABAoAAA==.',Ao='Aoibh:AwADCAgABAoAAA==.',Ar='Ardon:AwAHCBUABAoEAQAHAQjKEABFGDECBAoAAQAHAQjKEABFGDECBAoAAwAGAQiWPQAm3RgBBAoABAADAQhQPwAnhIgABAoAAA==.',As='Asamifang:AwAFCBEABAoAAA==.',Ba='Bangerz:AwAFCAUABAoAAA==.',Be='Beanieweenie:AwAICAgABAoAAA==.Beowullfe:AwACCAIABAoAAA==.',Bj='Bjorum:AwADCAMABAoAAQUAAAAECAMABAo=.',Br='Brewzleeroy:AwAICAgABAoAAA==.',Bu='Bulian:AwAHCAMABAoAAA==.',Ca='Carlyle:AwADCAUABAoAAA==.',Ch='Chumdungler:AwAFCAgABAoAAA==.',Ci='Cindereller:AwAECAcABAoAAA==.Cision:AwAFCAwABAoAAA==.',Co='Cobár:AwAGCAwABAoAAA==.Collossuss:AwAFCAcABAoAAA==.',Cr='Cry:AwAFCAoABAoAAA==.',Cu='Curacao:AwAECAkABAoAAA==.',Di='Diegoknight:AwAICAgABAoAAA==.',Dr='Dreea:AwAECAsABAoAAA==.Drunkenchi:AwAICBAABAoAAA==.',El='Elij:AwAECAcABAoAAA==.',Em='Emeraldwish:AwABCAEABAoAAA==.',En='Endz:AwAICA8ABAoAAA==.',Fu='Fujiyama:AwACCAMABAoAAA==.',Gl='Glenndanzig:AwAGCAkABAoAAA==.',Go='Goldenshield:AwAFCAsABAoAAA==.',Ho='Hoshua:AwADCAMABAoAAA==.',Ke='Keliandros:AwAECAMABAoAAA==.',Ki='Kinkster:AwAFCAcABAoAAA==.Kitosol:AwABCAIABRQCBAAIAQiuAgBcwzIDBAoABAAIAQiuAgBcwzIDBAoAAA==.',Ko='Korialstrazs:AwAECAcABAoAAA==.',Ks='Kschwev:AwAECAQABAoAAA==.',Ku='Kupz:AwAHCA0ABAoAAA==.',Mi='Minimum:AwAECAcABAoAAA==.Mitchmayyne:AwAFCA4ABAoAAA==.',Mk='Mkmuffin:AwABCAEABAoAAA==.',Mo='Monkiato:AwAFCAcABAoAAA==.',My='Mylianne:AwAGCBQABAoCBgAGAQhbMAA0xWUBBAoABgAGAQhbMAA0xWUBBAoAAA==.',Ni='Nithari:AwAFCAsABAoAAA==.',No='Nohealsforu:AwAFCAYABAoAAA==.Nost:AwADCAUABAoAAA==.',Nv='Nv:AwAICAgABAoAAA==.',Ob='Obright:AwAFCAoABAoAAA==.',Og='Ogrelock:AwADCAMABAoAAA==.',Oj='Ojikan:AwACCAIABAoAAA==.',Ol='Oleshallen:AwABCAEABAoAAA==.',Pr='Preorcthego:AwABCAEABRQAAA==.',Ra='Rasscellion:AwAICBAABAoAAA==.',Ru='Ruheezy:AwADCAYABAoAAA==.',Sa='Sauceguzzler:AwAGCAMABAoAAA==.Savagery:AwAFCAwABAoAAA==.',Sc='Schreck:AwACCAIABAoAAA==.',Se='Seniref:AwAFCAcABAoAAA==.',Sh='Shiball:AwAICBAABAoAAA==.',Si='Siegescale:AwAECAsABAoAAA==.Sionshope:AwADCAQABAoAAA==.',Sl='Slayermage:AwAECAcABAoAAA==.',Sn='Snkrsotoole:AwAFCAcABAoAAA==.',St='Stravas:AwAGCAEABAoAAA==.Strychnine:AwAGCA8ABAoAAA==.',Sy='Syrelynna:AwAFCAcABAoAAA==.',Ta='Tacoy:AwABCAEABAoAAA==.Tagsy:AwADCAYABAoAAA==.Tasamoshi:AwADCAMABAoAAQEARrwGCBUABAo=.',Th='Then:AwAECAIABAoAAA==.',Tr='Troiikâ:AwACCAEABAoAAA==.',Tt='Ttevinn:AwAICAgABAoAAQUAAAAICAwABAo=.Ttevoker:AwAICAwABAoAAA==.',Wo='Woozydrgn:AwAGCA8ABAoAAA==.',Za='Zapali:AwAGCBIABAoAAA==.',Zu='Zulinzul:AwACCAIABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end