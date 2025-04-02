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
 local lookup = {'Druid-Balance','Druid-Feral','Unknown-Unknown','Paladin-Retribution','Paladin-Holy','Druid-Restoration','Hunter-Marksmanship','Warlock-Destruction','Warrior-Arms','Warrior-Protection','Shaman-Elemental','Shaman-Restoration',}; local provider = {region='US',realm='Durotan',name='US',type='weekly',zone=42,date='2025-03-29',data={Al='Alliwishis:AwAGCAsABAoAAA==.Allykat:AwAFCAEABAoAAA==.',An='Ananiel:AwAECBAABAoAAA==.Andragos:AwABCAEABAoAAA==.',Au='Aumaril:AwAGCBEABAoAAA==.',Az='Azuriah:AwAECAkABAoAAA==.',Ba='Babnik:AwAECAoABAoAAA==.Baharroth:AwAGCAwABAoAAA==.',Be='Beástboy:AwABCAEABRQDAQAIAQjPIQBEOtYBBAoAAQAGAQjPIQBIWNYBBAoAAgAEAQhUDQA8+EQBBAoAAA==.',Br='Brabanzio:AwADCAcABAoAAQMAAAAFCA4ABAo=.',Ca='Catastrophia:AwAICBAABAoAAA==.',Cl='Clurehealz:AwAFCAIABAoAAA==.',Co='Corrosion:AwADCAEABAoAAA==.',Cy='Cybeast:AwAFCAIABAoAAA==.',De='Dedbull:AwACCAQABAoAAA==.',Dk='Dkpheonix:AwADCAMABAoAAA==.',Do='Dolemite:AwAFCAIABAoAAA==.Donalbain:AwAFCA4ABAoAAA==.',Du='Durock:AwACCAkABAoAAA==.',Ed='Edgemåster:AwABCAEABRQAAA==.',Eg='Eggroll:AwADCAYABAoAAA==.',El='Elayle:AwAFCAwABAoAAA==.Elyssaris:AwAFCA8ABAoAAA==.',En='Entaria:AwAGCBQABAoDBAAGAQhbMwBUhx0CBAoABAAGAQhbMwBUhx0CBAoABQABAQjtLABc/l0ABAoAAA==.',Ep='Episkey:AwACCAIABAoAAA==.',Er='Eroversion:AwAGCB4ABAoDBgAGAQjfJQAsjjMBBAoABgAGAQjfJQAsjjMBBAoAAQAFAQiWRAAbs+kABAoAAA==.',Es='Esmay:AwAFCAoABAoAAA==.',Ey='Eyebrows:AwAFCAEABAoAAA==.',Fa='Falcone:AwAECAQABAoAAA==.',Fe='Feorrior:AwADCAMABAoAAA==.',Fi='Filgulfin:AwAFCA8ABAoAAA==.',Fl='Flameclaws:AwACCAIABAoAAA==.Flamehunter:AwAICBEABAoAAA==.Flonominal:AwAFCA8ABAoAAA==.Flowing:AwAECAkABAoAAA==.',Fo='Foods:AwAHCBAABAoAAA==.',Fu='Furryfury:AwAFCA0ABAoAAA==.Fustín:AwAECAgABAoAAA==.',Ha='Halcyndraag:AwAECAkABAoAAA==.Happydk:AwAHCA8ABAoAAA==.Hartu:AwAFCA8ABAoAAA==.',He='Heimdal:AwAECAsABAoAAA==.',Hi='Hiddentaco:AwAFCA0ABAoAAA==.',Ho='Holydeath:AwACCAYABAoAAA==.Holyjak:AwACCAIABAoAAA==.',Ic='Ichigoson:AwAFCA0ABAoAAA==.',Id='Idiocracy:AwADCAgABAoAAA==.',In='Invisabo:AwACCAMABAoAAA==.',Ja='Jarnathan:AwADCAQABAoAAA==.Jaytoonice:AwAFCAsABAoAAA==.',Jo='Johan:AwAFCAwABAoAAA==.',Ka='Kaana:AwAECAgABAoAAA==.Kalgorathh:AwAICAYABAoCBwAGAQhoOQAIPFIABAoABwAGAQhoOQAIPFIABAoAAA==.Karungash:AwABCAIABRQCCAAIAQj6BQBYTfgCBAoACAAIAQj6BQBYTfgCBAoAAA==.Karvel:AwAFCAIABAoAAA==.',Kc='Kchowchow:AwAFCA0ABAoAAA==.',Kh='Khileen:AwADCAMABAoAAA==.',Kr='Krum:AwAFCA4ABAoAAA==.',Ku='Kuraokami:AwAFCA0ABAoAAA==.',Ky='Kyraalia:AwAICAgABAoAAQMAAAAICBAABAo=.',La='Lanval:AwAFCAoABAoAAA==.',Lm='Lminus:AwAECAEABAoAAA==.',Lo='Loudpocketz:AwABCAEABAoAAQMAAAABCAEABRQ=.Loveyourz:AwAFCAYABAoAAA==.',Ma='Maladin:AwAECAoABAoAAA==.Marshe:AwAGCAEABAoAAQMAAAAICAgABAo=.',Me='Meingift:AwADCAMABAoAAA==.',Mi='Minidude:AwABCAEABRQDCQAIAQhKCABAVncCBAoACQAIAQhKCABAVncCBAoACgACAQhnJgAGSS4ABAoAAA==.Minionghost:AwAFCA8ABAoAAA==.Mizuoh:AwAECAoABAoAAA==.',Mo='Moofasaha:AwABCAEABAoAAA==.',Na='Nashalie:AwAECAkABAoAAA==.',Ni='Nickyboy:AwADCAMABAoAAA==.Nightevel:AwABCAEABAoAAA==.',Nu='Nukras:AwAICAgABAoAAA==.',Ny='Nyxiê:AwADCAUABAoAAA==.',Oz='Ozo:AwACCAIABAoAAA==.',Pa='Pallyscorned:AwAFCAIABAoAAA==.',Po='Ponder:AwABCAEABAoAAA==.',Qu='Quasar:AwAFCAIABAoAAA==.',Ra='Raeku:AwAFCAgABAoAAA==.Raizei:AwAECAkABAoAAA==.',Re='Retribution:AwACCAEABAoAAA==.',Ro='Ronfax:AwABCAEABRQDCwAIAQjLEgA/3A0CBAoACwAHAQjLEgBFww0CBAoADAADAQizXwAVPIcABAoAAA==.Roqli:AwAFCAIABAoAAA==.',Sa='Sahmiya:AwAICBAABAoAAA==.Saint:AwADCAMABAoAAA==.',Sc='Schadoww:AwACCAIABAoAAA==.Scy:AwACCAIABAoAAA==.',Sh='Shacktown:AwAFCAkABAoAAA==.Shampagne:AwAECAYABAoAAA==.Shmurdaa:AwADCAIABAoAAA==.',Sl='Slewg:AwAGCAEABAoAAA==.Sloog:AwABCAEABAoAAA==.',Sr='Srgmcmuffin:AwADCAIABAoAAA==.',St='Standinfire:AwAGCA8ABAoAAA==.Straanger:AwACCAQABAoAAA==.',Sy='Sylphrenä:AwAFCAIABAoAAA==.',Ta='Tanedarel:AwAFCAEABAoAAA==.',Th='Thodos:AwACCAMABAoAAA==.Thornscale:AwAFCAgABAoAAA==.',To='Torcerotops:AwAFCA8ABAoAAA==.',Tu='Tusago:AwAGCAoABAoAAA==.',Va='Vapor:AwACCAIABAoAAA==.',Ve='Veebs:AwACCAMABAoAAA==.Verité:AwAECAYABAoAAA==.',Vi='Virauca:AwAFCA8ABAoAAA==.',Wa='Warriorguyes:AwADCAMABAoAAA==.',Wr='Wryn:AwAFCAgABAoAAA==.',Xa='Xaltheris:AwAFCAoABAoAAA==.',Yv='Yve:AwACCAQABAoAAA==.',Ze='Zeralan:AwABCAEABAoAAA==.',Zz='Zzillidanzz:AwABCAEABRQAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end