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
 local lookup = {'Priest-Holy','DemonHunter-Havoc','Unknown-Unknown','Paladin-Retribution','Warrior-Fury','DemonHunter-Vengeance','Monk-Mistweaver','Rogue-Outlaw','Rogue-Subtlety','Priest-Shadow','Evoker-Devastation','Monk-Windwalker','Warrior-Protection','Druid-Restoration','Druid-Guardian',}; local provider = {region='US',realm='ShadowCouncil',name='US',type='weekly',zone=42,date='2025-03-29',data={Ad='Adrift:AwAECAYABAoAAA==.',Ak='Akatsuke:AwAECAEABAoAAA==.',Al='Alkaide:AwADCAEABAoAAA==.Alleriae:AwAGCAgABAoAAA==.',Am='Amaria:AwAFCAgABAoAAA==.',An='Angelstörm:AwABCAIABRQCAQAGAQhaHgBBHJoBBAoAAQAGAQhaHgBBHJoBBAoAAA==.Anjali:AwABCAIABRQAAA==.',Ap='Apaladin:AwABCAEABAoAAA==.',Ar='Aradrys:AwADCAMABAoAAA==.Arckenon:AwAFCAMABAoAAA==.Arclight:AwADCAUABAoAAA==.Ardilla:AwACCAIABAoAAA==.Arvi:AwADCAMABAoAAA==.',As='Ashog:AwADCAIABAoAAA==.',At='Atruon:AwAFCA0ABAoAAA==.',Ax='Axeflack:AwAGCBEABAoAAA==.',Ba='Bacuda:AwACCAMABAoAAA==.',Bi='Biturbo:AwAFCAsABAoAAA==.',Bl='Blindslayer:AwAICBoABAoCAgAIAQhDHAA81jkCBAoAAgAIAQhDHAA81jkCBAoAAA==.',Br='Broland:AwAECAcABAoAAA==.',Bu='Bubbleofive:AwACCAMABAoAAA==.',Ch='Chey:AwAECAsABAoAAA==.Chipsahoy:AwAFCAgABAoAAA==.Choga:AwAECAcABAoAAA==.Chooka:AwAICAYABAoAAA==.',Co='Conorix:AwACCAUABAoAAA==.',Da='Daereth:AwACCAIABAoAAA==.Damnitsu:AwEGCAwABAoAAA==.Daylight:AwABCAEABAoAAA==.',De='Denaris:AwABCAEABAoAAA==.Denero:AwAECAgABAoAAA==.Dewalt:AwADCAQABAoAAA==.',Di='Dinnu:AwADCAMABAoAAA==.',Do='Dotspot:AwABCAEABAoAAQMAAAAFCAIABAo=.',Dr='Dracthayr:AwAHCBAABAoAAA==.Dragonhammer:AwABCAEABRQCBAAGAQgdPgBOJ/EBBAoABAAGAQgdPgBOJ/EBBAoAAA==.Dreáming:AwADCAEABAoAAA==.Drsokola:AwAGCAoABAoAAA==.',Ev='Everios:AwABCAIABRQCBQAGAQjqHgBJ++ABBAoABQAGAQjqHgBJ++ABBAoAAA==.',Fa='Faevelina:AwAICAgABAoAAA==.',Fr='Frostshade:AwAFCAEABAoAAA==.',Ga='Galbur:AwAGCAsABAoAAA==.Gassann:AwABCAEABRQCBAAHAQhjHQBS2Y0CBAoABAAHAQhjHQBS2Y0CBAoAAA==.',Ge='Geers:AwAECAEABAoAAA==.Getarage:AwAHCBEABAoAAA==.',Gh='Ghunter:AwAFCAIABAoAAA==.',Gr='Graymayn:AwADCAYABAoAAA==.Grimthorn:AwAECAoABAoAAA==.Grumpally:AwABCAEABRQAAA==.Grumpin:AwACCAQABAoAAA==.',Gu='Gunboyten:AwADCAEABAoAAA==.Gunderthirth:AwAHCBEABAoAAA==.Guulfang:AwAECAQABAoAAA==.',Ha='Handsoap:AwADCAMABAoAAA==.Haquar:AwABCAEABAoAAA==.',He='Hevensrath:AwAFCA0ABAoAAA==.',Ho='Horsebananas:AwACCAYABAoAAA==.',Ik='Ikki:AwABCAEABRQAAA==.',In='Indecent:AwAFCA0ABAoAAA==.',Ja='Jackiecrazed:AwABCAIABRQCBgAGAQiLDwBDArUBBAoABgAGAQiLDwBDArUBBAoAAA==.',Ju='Jusstice:AwAFCA4ABAoAAA==.',Ka='Kaia:AwAFCAwABAoAAA==.Kardio:AwABCAIABRQCBwAGAQgdEQBYlzkCBAoABwAGAQgdEQBYlzkCBAoAAA==.Kaylleath:AwAFCA0ABAoAAA==.',Ke='Keylerin:AwAICBcABAoDCAAIAQixAQBIdqECBAoACAAIAQixAQBIdqECBAoACQACAQi7KQAqaGoABAoAAA==.',Ki='Kishaleth:AwACCAUABAoAAA==.',Kr='Krampus:AwAFCAwABAoAAA==.Kranok:AwADCAIABAoAAA==.',Ky='Kyrun:AwADCAcABAoAAA==.',La='Ladaris:AwABCAIABRQCAgAGAQhHHQBRJTECBAoAAgAGAQhHHQBRJTECBAoAAA==.Lapz:AwAECAgABAoAAA==.',Le='Leafshadow:AwABCAEABRQCCgAGAQhxDgBZTU4CBAoACgAGAQhxDgBZTU4CBAoAAA==.',Li='Liadrin:AwAHCBEABAoAAA==.',Ma='Machlain:AwAFCAcABAoAAA==.Magnon:AwAHCBAABAoAAA==.Malaah:AwAFCAkABAoAAA==.Maregasm:AwAFCA4ABAoAAA==.',Mi='Mileta:AwADCAkABAoAAA==.',Na='Narnluz:AwAFCAEABAoAAA==.Narrashirn:AwAECAYABAoAAA==.',Ne='Nessee:AwACCAYABAoAAA==.',Ni='Nielal:AwAFCA0ABAoAAA==.Nigth:AwACCAMABAoAAA==.',Pi='Pight:AwADCAMABAoAAA==.',Po='Potential:AwADCAMABAoAAA==.Poxi:AwACCAIABAoAAA==.',Py='Pyree:AwAFCAsABAoAAA==.',Qu='Quáck:AwAICBcABAoCBwAIAQi3DQBHGmgCBAoABwAIAQi3DQBHGmgCBAoAAA==.',Ra='Raiköu:AwABCAEABAoAAA==.Rairdi:AwAICAgABAoAAA==.Raistlain:AwAFCAgABAoAAA==.Rallsdemon:AwAFCAkABAoAAA==.Ratrot:AwADCAMABAoAAA==.',Re='Rena:AwAFCAoABAoAAA==.Rezjyk:AwADCAMABAoAAA==.',Rh='Rhonus:AwADCAEABAoAAA==.',Sa='Saymyname:AwADCAYABAoAAA==.',Sc='Scary:AwAHCAoABAoAAA==.',Sh='Shalriss:AwADCAMABAoAAA==.Shamunroe:AwAFCA0ABAoAAA==.Shingra:AwAICBcABAoCCwAIAQh4CQBJv4UCBAoACwAIAQh4CQBJv4UCBAoAAA==.Shuamyl:AwADCAQABAoAAA==.Shyznkicks:AwAHCAcABAoAAA==.',Sk='Skillidan:AwAFCAgABAoAAA==.',Sl='Slighttrash:AwAECAYABAoAAA==.',Sm='Smallcrow:AwABCAEABRQCDAAIAQhbAgBb70YDBAoADAAIAQhbAgBb70YDBAoAAA==.',Sn='Snowsong:AwABCAEABAoAAA==.',Sp='Spaz:AwAECAoABAoAAA==.Spheredfrog:AwAFCAIABAoAAA==.',St='Starge:AwADCAYABAoAAA==.Sturgeson:AwAICBcABAoCDQAIAQhuAgBOjcECBAoADQAIAQhuAgBOjcECBAoAAA==.',Sw='Swiftfeet:AwAFCAgABAoAAA==.',Ta='Tanequil:AwABCAEABRQCDgAGAQipLQAaTPoABAoADgAGAQipLQAaTPoABAoAAA==.',Te='Terpsícore:AwABCAIABRQCDwAGAQhcBgA7n34BBAoADwAGAQhcBgA7n34BBAoAAA==.',Ti='Timothy:AwAECAkABAoAAA==.Timpany:AwAHCBAABAoAAA==.Tinkphooey:AwAECAcABAoAAA==.',Ts='Tsuruga:AwAFCAwABAoAAA==.',Va='Valton:AwABCAIABRQCDAAGAQgpDgBXe00CBAoADAAGAQgpDgBXe00CBAoAAA==.',Ve='Ventosa:AwAFCAUABAoAAA==.Vestrae:AwABCAIABRQCDgAGAQgrIgA5T1EBBAoADgAGAQgrIgA5T1EBBAoAAA==.',Vi='Violeta:AwACCAQABAoAAA==.',Vo='Vonbrew:AwABCAEABAoAAA==.Vonnpal:AwAHCBYABAoCBAAHAQg7MwBAYB0CBAoABAAHAQg7MwBAYB0CBAoAAA==.Vonns:AwABCAEABAoAAA==.Vostok:AwAFCAcABAoAAA==.',We='Wetsock:AwADCAgABAoAAA==.',Wi='Wikket:AwADCAsABAoAAA==.',Xo='Xodar:AwAFCAcABAoAAA==.',Za='Zarisedra:AwAICBIABAoAAA==.',Ze='Zernacho:AwAFCAcABAoAAA==.Zevvo:AwAFCA4ABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end