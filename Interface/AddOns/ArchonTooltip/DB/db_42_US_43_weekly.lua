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
 local lookup = {'Hunter-Marksmanship','Unknown-Unknown','Mage-Fire','Hunter-BeastMastery','Mage-Arcane',}; local provider = {region='US',realm='BoreanTundra',name='US',type='weekly',zone=42,date='2025-03-29',data={Ad='Adrighton:AwAECAEABAoAAA==.',Al='Alcomyst:AwADCAQABAoAAA==.',Ar='Arroyo:AwAFCAMABAoAAA==.Artowelemis:AwAICAgABAoAAA==.',Av='Avoidlum:AwABCAEABAoAAA==.',Ba='Bauer:AwADCAQABAoAAA==.',Bo='Boatsandho:AwAHCAQABAoAAA==.Boneman:AwAFCAkABAoAAA==.Bonsucksme:AwAICAgABAoAAA==.',By='Byssrak:AwABCAEABAoAAA==.',Cl='Cloudxll:AwABCAEABAoAAA==.',Co='Cocofluff:AwADCAEABAoAAA==.',De='Deatnshadow:AwAECAUABAoAAA==.Derogatory:AwACCAIABAoAAA==.',Do='Dotnotzee:AwAICAgABAoAAQEAViYCCAMABRQ=.',Dr='Dryrain:AwAGCBEABAoAAA==.',Fa='Falkor:AwADCAUABAoAAA==.Fayway:AwAGCAMABAoAAA==.',Fu='Fulgore:AwADCAIABAoAAA==.',Gl='Glennspyder:AwADCAMABAoAAA==.',Gr='Groddo:AwABCAEABAoAAA==.',Ha='Hanjo:AwAECAIABAoAAA==.',Hy='Hypatia:AwAHCBMABAoAAA==.',Ig='Igrisa:AwADCAQABAoAAA==.',Ja='Jatzull:AwADCAUABAoAAA==.',Ka='Kaanâ:AwAECAIABAoAAA==.Kaltorak:AwAICAoABAoAAA==.Karyudo:AwAECAEABAoAAA==.Kateblue:AwAECA0ABAoAAA==.',Ke='Keeble:AwAGCAsABAoAAA==.',Ki='Kinkreet:AwADCAQABAoAAA==.',Kr='Krispeytraps:AwAICAYABAoAAQIAAAAICAgABAo=.',Le='Leonidus:AwADCAMABAoAAA==.Lexijen:AwADCAQABAoAAA==.',Lo='Longhorse:AwABCAEABAoAAQMARqMBCAEABRQ=.',Lu='Luminaeda:AwADCAYABAoAAA==.Luminouss:AwAGCAIABAoAAA==.',Ma='Magicgal:AwAHCAEABAoAAA==.Magiere:AwADCAQABAoAAA==.',Me='Mezi:AwAGCBEABAoAAA==.',Mo='Moneyshotinc:AwACCAMABRQDAQAIAQgVAwBWJvwCBAoAAQAIAQgVAwBWJvwCBAoABAACAQhEiwBGnJAABAoAAA==.',My='Myshella:AwAECAIABAoAAA==.',Ni='Nightsky:AwACCAIABAoAAA==.',On='Onlyfeigns:AwADCAQABAoAAA==.',Pa='Pallirot:AwAGCAgABAoAAA==.',Ph='Phané:AwAICA8ABAoAAA==.',Pl='Plagueblade:AwAECAIABAoAAA==.',Pu='Purrcules:AwABCAEABAoAAA==.',Ra='Ramorin:AwAGCAYABAoAAA==.Rassarudk:AwABCAEABAoAAA==.',Re='Restofarian:AwAGCAEABAoAAA==.',Rh='Rhagnor:AwAGCBIABAoAAA==.Rhoda:AwAGCAIABAoAAA==.',Sa='Sandrill:AwABCAEABAoAAA==.Satorugojo:AwAGCBAABAoAAA==.',Se='Semila:AwADCAQABAoAAA==.',Sh='Shaazrah:AwAECAYABAoAAA==.Sharkie:AwAFCAYABAoAAA==.Shimakaze:AwAGCBEABAoAAA==.Shymistress:AwAFCAwABAoAAA==.',Si='Sins:AwADCAMABAoAAA==.',Sk='Skiá:AwAFCAMABAoAAA==.',Sl='Slain:AwABCAEABAoAAA==.',Sp='Spanknmonkey:AwADCAMABAoAAA==.',Th='Thanatus:AwAGCBMABAoAAA==.Theredcross:AwABCAEABAoAAA==.Thyng:AwADCAQABAoAAA==.',To='Tosar:AwAFCAkABAoAAA==.',Ut='Utherr:AwAECAUABAoAAA==.',Ve='Vergus:AwAICAEABAoAAA==.',Vi='Violin:AwACCAIABAoAAQMAXK0DCAQABRQ=.Violinmax:AwADCAQABRQDAwAIAQiwBQBcrSQDBAoAAwAIAQiwBQBcrSQDBAoABQADAQh5CQAp25kABAoAAA==.',Vo='Votka:AwAICAgABAoAAA==.',Wa='Watchurback:AwADCAQABAoAAA==.',Wr='Wrathirnesta:AwADCAMABAoAAA==.',Xa='Xanagore:AwAFCAQABAoAAA==.',Xx='Xxie:AwAICAoABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end