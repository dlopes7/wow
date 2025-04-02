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
 local lookup = {'Unknown-Unknown','DeathKnight-Unholy',}; local provider = {region='US',realm='Doomhammer',name='US',type='weekly',zone=42,date='2025-03-29',data={Ad='Adraeus:AwAHCAcABAoAAQEAAAABCAEABRQ=.',Ae='Aesthelyan:AwADCAcABAoAAA==.',Ag='Agnia:AwAFCAEABAoAAA==.',Al='Aldo:AwAICAQABAoAAA==.Alestiana:AwADCAMABAoAAA==.',Am='Amethyste:AwAFCAsABAoAAA==.',Ao='Aoba:AwADCAQABAoAAA==.',Ap='Apox:AwAFCAoABAoAAA==.',Ar='Arenar:AwABCAEABAoAAQEAAAABCAEABRQ=.Artemisixion:AwADCAYABAoAAA==.',At='Athená:AwADCAMABAoAAA==.',Ba='Bashanu:AwABCAIABAoAAQEAAAAFCAsABAo=.',Be='Beerntotems:AwABCAEABAoAAA==.Beernuts:AwAECAoABAoAAA==.',Bi='Bigbubscotch:AwACCAEABAoAAA==.Bigdsenpai:AwABCAEABAoAAA==.Bip:AwAHCBAABAoAAA==.',Bo='Bobbette:AwABCAEABAoAAQEAAAAFCAEABAo=.Bottd:AwABCAEABAoAAA==.',Br='Bronkowitz:AwAFCAEABAoAAA==.',Bu='Bubblebum:AwADCAQABAoAAA==.',Ca='Cahae:AwABCAEABAoAAA==.',Ce='Ceramagz:AwAECAYABAoAAA==.',Ch='Chilblain:AwADCAMABAoAAA==.',Co='Colenan:AwABCAEABAoAAA==.Corrum:AwAECAYABAoAAA==.',Da='Daeshan:AwADCAQABAoAAA==.Daldolarette:AwAHCBAABAoAAA==.Darkkef:AwACCAIABAoAAA==.Dasecondone:AwAGCAcABAoAAA==.',De='Decapa:AwAFCAkABAoAAA==.',Dr='Drakakeen:AwAFCAEABAoAAA==.',Du='Duckey:AwAFCAEABAoAAA==.',Ec='Ech:AwADCAQABAoAAA==.',El='Elyptikan:AwADCAMABAoAAA==.',Fr='Franchise:AwACCAIABAoAAA==.Fricorith:AwAFCAIABAoAAA==.',Fu='Fu:AwABCAEABAoAAA==.Fuuz:AwAFCAEABAoAAA==.',Go='Goneville:AwAHCBAABAoAAA==.Gopopo:AwAHCBIABAoAAA==.',Gr='Grakata:AwABCAEABAoAAQEAAAAFCAsABAo=.Gretorix:AwAECAQABAoAAA==.',Gt='Gtx:AwAICAgABAoAAA==.',Ha='Haldevarik:AwAGCA0ABAoAAA==.',He='Heavywinner:AwAHCBAABAoAAA==.Hellwing:AwABCAEABAoAAA==.Heyitsnaz:AwAECAQABAoAAA==.',Ho='Hongsolo:AwAGCAsABAoAAA==.',Ka='Kammordial:AwAFCAsABAoAAA==.',Ke='Keiiha:AwABCAEABRQAAA==.',Ki='Kirean:AwADCAQABAoAAA==.Kirikoa:AwAICAgABAoAAA==.',Kn='Knives:AwAFCAsABAoAAA==.',Ko='Kobesama:AwADCAQABAoAAA==.',['K�']='Köra:AwAICAMABAoAAA==.',Lo='Lorlea:AwACCAIABAoAAA==.',Lu='Luckystars:AwAECAYABAoAAA==.Lunariel:AwAECAgABAoAAA==.',Me='Mecho:AwADCAQABAoAAA==.',Mi='Mizblumkin:AwADCAMABAoAAA==.',Mo='Moonbeam:AwABCAEABAoAAA==.Moriar:AwADCAMABAoAAA==.',No='Noran:AwAECAEABAoAAA==.',Oa='Oakfang:AwAHCAkABAoAAA==.',Ok='Okira:AwADCAEABAoAAA==.',Pe='Peterparker:AwACCAIABAoAAA==.',Pl='Plethknight:AwABCAEABRQAAA==.',Pr='Prôfessôrôdd:AwAECAcABAoAAA==.',Qr='Qrebel:AwABCAIABAoAAA==.',Ra='Rageballa:AwABCAIABAoAAA==.Ramsis:AwAFCAEABAoAAA==.Randir:AwAFCAsABAoAAA==.Rath:AwAECAQABAoAAA==.',Re='Remedivhs:AwADCAcABAoAAQEAAAADCA8ABAo=.Revy:AwAFCAsABAoAAA==.Rexkramer:AwABCAIABAoAAA==.',Ri='Rizjo:AwACCAEABAoAAA==.',Ro='Robinhoodx:AwADCAQABAoAAA==.Rooflsmcrofl:AwABCAEABAoAAA==.',Ru='Rudef:AwAECAIABAoAAA==.',['R�']='Rööster:AwAFCAcABAoAAA==.',Sa='Salvation:AwAGCAgABAoAAA==.',Se='Seiba:AwAGCAYABAoAAA==.',Sh='Shamyuge:AwADCAMABAoAAA==.',Si='Sicnus:AwADCAMABAoAAA==.Sinadin:AwADCAQABAoAAA==.',Sm='Smâlls:AwAECAcABAoAAA==.',So='Solarion:AwAFCAEABAoAAA==.',Sp='Spiceballs:AwAFCAgABAoAAA==.',St='Steppinrazor:AwAICAYABAoAAA==.',Sv='Svlla:AwABCAEABRQCAgAIAQimGwAtlO8BBAoAAgAIAQimGwAtlO8BBAoAAA==.',Th='Thelock:AwAHCBAABAoAAA==.Thur:AwAGCBAABAoAAA==.',Ti='Timoris:AwADCAMABAoAAQEAAAAFCAkABAo=.',Tr='Travelbones:AwAICAgABAoAAA==.',Ts='Tsilver:AwAECAQABAoAAA==.',Tu='Tuldag:AwAFCAEABAoAAA==.',Um='Umbrascale:AwAHCA4ABAoAAA==.',Ve='Vecna:AwACCAEABAoAAA==.Veleria:AwAFCAsABAoAAA==.',Vi='Vinaya:AwACCAIABAoAAA==.Virgil:AwAHCBAABAoAAA==.Visulidan:AwAFCAsABAoAAA==.',Wi='Windsaber:AwAGCAMABAoAAA==.Wisegurl:AwAFCAsABAoAAA==.',Wo='Woblatus:AwADCA8ABAoAAA==.',Wy='Wylectra:AwADCAQABAoAAA==.',Ye='Yeetuis:AwAFCBAABAoAAA==.',Za='Zaphiell:AwADCAEABAoAAA==.',Ze='Zeid:AwAFCAsABAoAAA==.',Zi='Zinderalanot:AwABCAEABAoAAQEAAAADCA8ABAo=.',Zu='Zurnox:AwABCAEABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end