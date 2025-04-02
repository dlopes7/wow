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
 local lookup = {'DeathKnight-Frost','Shaman-Enhancement','Shaman-Elemental','Unknown-Unknown','Warrior-Arms','Warrior-Fury','Mage-Fire','Hunter-BeastMastery',}; local provider = {region='US',realm='Zangarmarsh',name='US',type='weekly',zone=42,date='2025-03-28',data={Ad='Adachï:AwABCAEABAoAAA==.',An='Angelistar:AwAECAIABAoAAA==.Anorel:AwAFCAUABAoAAA==.',Ar='Arielia:AwABCAEABAoAAA==.Arlia:AwACCAIABAoAAA==.',As='Aspir:AwAGCA4ABAoAAQEAW6AHCBYABAo=.',At='Atormentor:AwACCAIABAoAAA==.',Aw='Awasjr:AwAECAIABAoAAA==.',Ax='Axix:AwACCAIABAoAAA==.',Ba='Badfiremage:AwADCAcABAoAAA==.Badmal:AwAECAQABAoAAA==.Bazlu:AwAECAQABAoAAA==.',Be='Bean:AwAFCAUABAoAAA==.Bearhug:AwACCAIABAoAAA==.Belardor:AwAICAgABAoAAA==.Belladonia:AwAICAgABAoAAA==.Berrymage:AwAGCAsABAoAAA==.Beë:AwAECAcABAoAAA==.',Bi='Bibbly:AwABCAEABAoAAA==.Bigéd:AwACCAIABAoAAA==.',Bo='Bobasponga:AwAFCAwABAoAAA==.',Br='Brakug:AwADCAMABAoAAA==.Brecc:AwAECAYABAoAAA==.Bretagnesse:AwAECAIABAoAAA==.',Bu='Bumagak:AwAICAgABAoAAA==.Bundles:AwAECAkABAoAAA==.',By='Bylun:AwABCAEABAoAAA==.',Ca='Canyouzapit:AwAFCA0ABAoAAA==.Cashless:AwACCAIABAoAAA==.',Co='Cowevoker:AwAGCA8ABAoAAA==.',Cr='Cruces:AwADCAMABAoAAA==.',Cy='Cybelenleaf:AwAGCA8ABAoAAA==.',Da='Darkmagician:AwAECAQABAoAAA==.',De='Defend:AwADCAYABAoAAA==.',Di='Divix:AwAICBYABAoDAgAHAQimFAAzlPABBAoAAgAHAQimFAAzlPABBAoAAwABAQh5TwAbry0ABAoAAA==.',Dj='Djeelerix:AwABCAEABAoAAA==.',Dr='Drêck:AwABCAEABAoAAA==.',Dy='Dyadin:AwACCAIABAoAAQQAAAADCAMABAo=.Dymonic:AwADCAMABAoAAA==.',Ek='Ekatrina:AwAFCAUABAoAAA==.',Es='Esha:AwAFCAUABAoAAA==.',Fe='Felfüry:AwAECAIABAoAAA==.Feyd:AwABCAIABAoAAA==.',Fo='Folly:AwABCAIABRQDBQAHAQjdCQBHfk4CBAoABQAHAQjdCQBHfk4CBAoABgACAQjkZgAijC0ABAoAAA==.',Gl='Glitchy:AwAGCA8ABAoAAA==.',Gn='Gnomelion:AwABCAEABRQCBwAGAQjFQQAQ2AMBBAoABwAGAQjFQQAQ2AMBBAoAAA==.',Go='Gottahvyhand:AwADCAEABAoAAA==.',Gr='Greed:AwAFCAwABAoAAQQAAAABCAEABRQ=.Greeley:AwAGCBAABAoAAA==.Greggikins:AwAECAgABAoAAA==.',Gu='Guldandi:AwACCAEABAoAAA==.Gunnyal:AwADCAQABAoAAA==.',Hi='Hilarius:AwAHCA8ABAoAAA==.',Ho='Horz:AwABCAEABAoAAA==.Howlinntotem:AwAFCA0ABAoAAA==.',Ja='Javlin:AwADCAMABAoAAA==.',Jh='Jharlin:AwAECAIABAoAAA==.',Jo='Joehex:AwAECAcABAoAAA==.',Ka='Kaleesh:AwAECAcABAoAAA==.',Ke='Kerah:AwADCAYABAoAAA==.',Ki='Kieto:AwAFCAUABAoAAA==.',Le='Leighwoo:AwACCAEABAoAAA==.',Lo='Logankord:AwAECAIABAoAAA==.Lono:AwAECAIABAoAAA==.Lorath:AwAECAIABAoAAA==.',Ly='Lyara:AwAECAQABAoAAA==.',Ma='Malifae:AwAGCAoABAoAAA==.Mansa:AwAECAIABAoAAA==.Mastamojo:AwAGCA0ABAoAAA==.Maursu:AwACCAIABAoAAA==.Mayanah:AwABCAIABAoAAA==.',Me='Mechadoctor:AwADCAMABAoAAA==.',Mi='Miora:AwAGCAsABAoAAA==.',Ml='Mladjo:AwACCAIABAoAAA==.',Mo='Mortenius:AwAGCAYABAoAAA==.Morticiá:AwAFCAUABAoAAA==.Mozaic:AwAGCA0ABAoAAA==.',Mu='Munchdh:AwACCAIABAoAAA==.',Ni='Nilyaf:AwABCAEABRQAAA==.',Ny='Nyxstryl:AwAFCAUABAoAAQQAAAAHCAsABAo=.',Or='Ordanith:AwAGCBAABAoAAA==.Orionn:AwABCAMABRQCCAAIAQhIEABQw9MCBAoACAAIAQhIEABQw9MCBAoAAA==.Orlandò:AwACCAIABAoAAA==.',Pr='Prettyheels:AwADCAMABAoAAA==.',Rh='Rhielle:AwAECAEABAoAAA==.',Ri='Rinche:AwAFCA8ABAoAAA==.',Ru='Rumproblem:AwACCAIABAoAAA==.',Sa='Safety:AwADCAIABAoAAA==.Satyrane:AwAFCAoABAoAAA==.',Sc='Scalebagz:AwAGCA4ABAoAAA==.Schism:AwAFCAUABAoAAA==.',Sh='Shamalan:AwAFCAgABAoAAA==.Shen:AwAFCAEABAoAAA==.Shockblocked:AwAFCAUABAoAAA==.',Sm='Smashdiggity:AwAFCAUABAoAAA==.Smoothvelvet:AwAICAcABAoAAA==.',Sp='Spookasem:AwAECAUABAoAAA==.',St='Staretra:AwAGCA8ABAoAAA==.',Su='Surgeheals:AwADCAYABAoAAA==.',['S�']='Sèan:AwAFCAUABAoAAA==.',Ta='Talfuki:AwADCAIABAoAAA==.Talona:AwAHCAsABAoAAA==.Tandaan:AwAECAEABAoAAA==.',Te='Teachah:AwADCAIABAoAAA==.',Th='Thalrissa:AwACCAIABAoAAA==.Thoghar:AwAICAgABAoAAA==.',Ti='Tipsymancer:AwAGCA8ABAoAAA==.',To='Toochmagooch:AwAFCAUABAoAAA==.',Tr='Treesus:AwAFCAoABAoAAA==.',Tw='Twìztid:AwAGCA8ABAoAAA==.',Un='Undertow:AwADCAMABAoAAA==.',Ve='Veringetorix:AwACCAMABAoAAQQAAAACCAMABAo=.',Vi='Victorvega:AwAECAMABAoAAA==.Visandar:AwAICAgABAoAAA==.',['V�']='Vånkro:AwABCAEABRQAAA==.',Wa='Wayofthesnix:AwADCAMABAoAAA==.',Wi='Wiegraf:AwADCAMABAoAAA==.Wife:AwAFCAUABAoAAA==.',Wo='Wondersack:AwAFCAgABAoAAA==.',Yg='Yggrasdil:AwAGCAwABAoAAA==.',Ym='Ymir:AwACCAMABAoAAA==.',Yo='Yordle:AwACCAIABAoAAA==.',Za='Zadimonet:AwADCAMABAoAAA==.Zaeden:AwACCAIABAoAAA==.Zaft:AwAFCA8ABAoAAA==.',Ze='Zeusdh:AwAECAgABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end