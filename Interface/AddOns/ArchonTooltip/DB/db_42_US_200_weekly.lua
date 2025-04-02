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
 local lookup = {'Unknown-Unknown','Shaman-Restoration','Priest-Holy','Monk-Windwalker','Monk-Brewmaster','Hunter-BeastMastery','Shaman-Enhancement','DemonHunter-Havoc','DeathKnight-Unholy','DemonHunter-Vengeance',}; local provider = {region='US',realm='Smolderthorn',name='US',type='weekly',zone=42,date='2025-03-28',data={Al='Alorothius:AwAFCAEABAoAAA==.',An='Anarisa:AwADCAMABAoAAA==.',Ap='Aposentado:AwACCAMABAoAAQEAAAAECAgABAo=.',Aq='Aquatide:AwACCAIABAoAAQIAT3sCCAMABRQ=.',Ax='Axisall:AwADCAYABAoAAQMAVxIDCAYABRQ=.Axisalldk:AwADCAUABAoAAQMAVxIDCAYABRQ=.',Bl='Bluetide:AwACCAMABRQCAgAIAQiJCABPe7ECBAoAAgAIAQiJCABPe7ECBAoAAA==.',Ce='Cellcept:AwACCAYABAoAAA==.Cerelook:AwAGCAYABAoAAA==.',Di='Diddily:AwABCAEABAoAAA==.',Dr='Draconae:AwACCAgABAoAAA==.Dragonhealz:AwACCAMABAoAAQEAAAADCAMABAo=.',Fa='Fantasy:AwAFCA0ABAoAAA==.',Fe='Felbourn:AwAECAQABAoAAA==.',Fr='Frigamortis:AwAGCAsABAoAAA==.',Fy='Fysr:AwAECAcABAoAAA==.',Ge='Gemini:AwAECAEABAoAAA==.',Gr='Graamps:AwADCAYABAoAAA==.Graveheart:AwAGCA4ABAoAAA==.',He='Heeheeshamon:AwACCAMABRQAAA==.Heisenberg:AwAGCAsABAoAAA==.',Jo='Joyjoy:AwADCAMABAoAAA==.',Ju='Jujuhla:AwACCAIABAoAAA==.',Ka='Karlek:AwAGCAwABAoAAA==.Karma:AwAECAgABRQDBAAEAQgSAQBApXEBBRQABAAEAQgSAQBApXEBBRQABQABAQghBQAV5zEABRQAAA==.Kassanndra:AwEFCAUABAoAAQEAAAAICBAABAo=.',Kr='Krispy:AwABCAIABRQCBgAIAQiPFQBEq6QCBAoABgAIAQiPFQBEq6QCBAoAAA==.',Li='Lilith:AwABCAEABRQAAA==.',Lu='Lumie:AwAFCAIABAoAAA==.',Ma='Manfred:AwADCAYABAoAAA==.',No='Noobsham:AwACCAUABRQCBwACAQjCBgAr86UABRQABwACAQjCBgAr86UABRQAAA==.',Pa='Parallax:AwAFCAUABAoAAA==.',Pu='Putz:AwAHCBQABAoCCAAHAQgtHQA+USoCBAoACAAHAQgtHQA+USoCBAoAAA==.Putzlock:AwACCAIABAoAAQgAPlEHCBQABAo=.',Ra='Razzar:AwABCAIABAoAAQEAAAAECAoABAo=.',Re='Reapinghavok:AwACCAIABAoAAA==.Redeagle:AwABCAEABRQCBgAHAQhfKABCzhACBAoABgAHAQhfKABCzhACBAoAAA==.Reika:AwABCAEABAoAAA==.',Rh='Rhinos:AwADCAQABAoAAA==.',Sa='Sabs:AwACCAIABRQCCQAIAQjXBABbMxMDBAoACQAIAQjXBABbMxMDBAoAAA==.',Se='Serafina:AwABCAEABRQAAQEAAAABCAEABRQ=.',Sk='Skallagrimur:AwAICBAABAoAAA==.',Sl='Slayerfang:AwAGCAUABAoAAA==.',Sn='Snowx:AwADCAMABAoAAA==.',Va='Varfus:AwACCAUABRQCCgACAQjvAgBNbK8ABRQACgACAQjvAgBNbK8ABRQAAA==.',Wi='Wickerman:AwACCAMABAoAAA==.Wishingwell:AwAFCAkABAoAAA==.',Ya='Yarlyah:AwADCAkABAoAAA==.',Ze='Zeposoh:AwADCAMABAoAAQIAS5AGCBYABAo=.Zeproot:AwAECAEABAoAAQIAS5AGCBYABAo=.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end