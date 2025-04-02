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
 local lookup = {'Paladin-Retribution','Paladin-Protection','Warrior-Fury','Unknown-Unknown','Monk-Mistweaver','Shaman-Elemental','Shaman-Restoration','DeathKnight-Blood','DeathKnight-Frost','DeathKnight-Unholy','Rogue-Assassination','Druid-Balance',}; local provider = {region='US',realm='Norgannon',name='US',type='weekly',zone=42,date='2025-03-29',data={Ab='Abraenchtail:AwACCAIABAoAAA==.Abrácadabra:AwADCAIABAoAAA==.',Ac='Achilles:AwABCAEABRQDAQAIAQhOUQAkpKgBBAoAAQAIAQhOUQAkUKgBBAoAAgAEAQgfKAAdn5UABAoAAA==.Acinorev:AwADCAQABAoAAA==.',Ae='Aeon:AwADCAcABAoAAA==.',Ai='Airnahken:AwAICBMABAoAAA==.',Ak='Akela:AwACCAIABAoAAA==.Akos:AwADCAYABAoAAA==.',Al='Allivoker:AwAGCAwABAoAAA==.Alrighty:AwAFCAEABAoAAA==.',An='Anamis:AwADCAUABAoAAA==.Anomagus:AwADCAYABAoAAA==.',Ap='Aphalock:AwAECAkABAoAAA==.',Au='Aubani:AwAGCBIABAoAAA==.',Ay='Ayperos:AwAFCAoABAoAAA==.',Ba='Bakedmage:AwAFCAIABAoAAA==.',Be='Beavur:AwAECAQABAoAAA==.Belliae:AwADCAYABAoAAA==.',Bl='Blackautumn:AwAGCAYABAoAAA==.Blindfail:AwAECAQABAoAAA==.',Bo='Bolts:AwAECAsABAoAAA==.',Br='Broadzinatl:AwABCAEABAoAAA==.',Ca='Callock:AwAECAgABAoAAA==.',Ci='Ciphkin:AwAICAgABAoAAA==.',Co='Coldvengance:AwADCAYABAoAAA==.Corpser:AwACCAIABAoAAA==.',Cr='Cryomancer:AwAGCBMABAoAAA==.',Cu='Cuensour:AwAICAgABAoAAA==.',Da='Day:AwACCAIABAoAAA==.Dazen:AwAICBMABAoAAA==.',De='Dejno:AwABCAEABRQCAwAGAQgWFABbv0cCBAoAAwAGAQgWFABbv0cCBAoAAA==.',Dr='Drikken:AwAFCA4ABAoAAA==.Drougs:AwAECAoABAoAAA==.Drëmägë:AwAECAQABAoAAA==.',En='Entrerie:AwABCAEABAoAAA==.',Ep='Ephemeral:AwADCAQABAoAAA==.',Fa='Faillock:AwABCAEABAoAAQQAAAAECAQABAo=.Farnsworth:AwAFCAgABAoAAA==.',Fe='Fefifredrich:AwAECAEABAoAAA==.Felinemarie:AwAFCAsABAoAAA==.',Fi='Fistersister:AwABCAEABRQCBQAIAQi7GAAtr+IBBAoABQAIAQi7GAAtr+IBBAoAAA==.',Fl='Flairvoker:AwABCAIABAoAAA==.',Go='Gottrik:AwAECAgABAoAAA==.',Gr='Graymage:AwABCAEABRQAAA==.',Ha='Happymeel:AwAFCA4ABAoAAA==.Hazard:AwADCAYABAoAAA==.',Ho='Holo:AwAECAoABRQDBgAEAQjfAAA+W1MBBRQABgAEAQjfAAA+W1MBBRQABwACAQjrCQAvSI4ABRQAAA==.',Hr='Hrumpy:AwADCAIABAoAAA==.',Je='Jed:AwAICAgABAoAAA==.',Ji='Jinxta:AwADCAYABAoAAA==.',Ka='Kaimargonar:AwADCAQABAoAAA==.Kamayla:AwAHCAMABAoAAA==.',Kh='Khui:AwAGCA4ABAoAAA==.',Kn='Knìghtmàrè:AwAHCBwABAoECAAHAQjvBgBX+KMCBAoACAAHAQjvBgBWj6MCBAoACQAFAQhaCQBU7sQBBAoACgAEAQjiPgA2JeUABAoAAA==.',Ko='Kolaghan:AwAGCAYABAoAAA==.',Ky='Kytania:AwADCAYABAoAAA==.',La='Laatt:AwAGCAYABAoAAA==.Lawluss:AwAECAEABAoAAA==.',Li='Lighthouse:AwAGCA8ABAoAAA==.Lightrain:AwADCAYABAoAAA==.Lileth:AwABCAEABAoAAA==.',Ly='Lypally:AwAECAsABAoAAA==.',Ma='Madeah:AwADCAMABRQCCwAIAQgHBwA/H3MCBAoACwAIAQgHBwA/H3MCBAoAAA==.Magnyson:AwAECAEABAoAAA==.Marynne:AwAFCA4ABAoAAA==.',Mc='Mcdo:AwAHCBYABAoCBQAHAQgGDwBMd1YCBAoABQAHAQgGDwBMd1YCBAoAAA==.',Mo='Monteman:AwADCAUABAoAAA==.',['M�']='Mâgs:AwAGCBEABAoAAA==.',Na='Nakasid:AwAFCAIABAoAAA==.',Ne='Nevaehstar:AwAGCA0ABAoAAA==.',No='Nohkoh:AwACCAQABAoAAA==.',Oz='Ozzarion:AwAFCAYABAoAAA==.',Pa='Papirus:AwAHCAEABAoAAA==.',Qu='Quikglaives:AwACCAEABAoAAA==.Quiksilver:AwAFCAsABAoAAA==.',Ra='Rathabeast:AwAICBUABAoCDAAIAQhyHgAsIPEBBAoADAAIAQhyHgAsIPEBBAoAAA==.Rathasaurus:AwADCAMABAoAAA==.',Re='Redwinter:AwADCAYABAoAAQQAAAAGCAYABAo=.',Ro='Rodeo:AwAICAgABAoAAA==.',Sa='Saeti:AwAGCAsABAoAAA==.',Sh='Shano:AwAGCAgABAoAAA==.',Sk='Skyweaver:AwAFCAsABAoAAA==.',Sn='Snickernack:AwAFCAMABAoAAA==.',So='Sonna:AwAFCAoABAoAAA==.',St='Strumpeltini:AwAFCAkABAoAAA==.Stylos:AwAECAQABAoAAA==.',Sw='Swarli:AwAFCAoABAoAAA==.',Te='Tegbolt:AwAGCBIABAoAAA==.',Th='Theholymatt:AwAGCA0ABAoAAA==.Theodus:AwAECAUABAoAAA==.Thorrune:AwADCAcABAoAAA==.',To='Toaster:AwAHCAMABAoAAQQAAAAICA8ABAo=.Toastiewulf:AwAHCBAABAoAAA==.Touchmeudie:AwADCAUABAoAAA==.',Tr='Tricarys:AwADCAMABAoAAA==.Troglodyte:AwABCAEABRQCBgAHAQj1DwBJqDYCBAoABgAHAQj1DwBJqDYCBAoAAA==.',Tu='Tunagosa:AwAFCAkABAoAAA==.',Ty='Tye:AwAFCAgABAoAAA==.',Vo='Volundr:AwADCAYABAoAAA==.',Vy='Vylorin:AwAGCAkABAoAAA==.',We='Wesleysnipes:AwAFCAkABAoAAA==.',['W�']='Wùsthof:AwAGCAoABAoAAA==.',Ya='Yasuke:AwADCAYABAoAAA==.',Yo='Yokoriazen:AwAHCAUABAoAAA==.',Yv='Yvesass:AwAFCA4ABAoAAA==.',Zm='Zmona:AwAFCAoABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end