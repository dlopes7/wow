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
 local lookup = {'Rogue-Subtlety','Rogue-Assassination','DemonHunter-Havoc','Unknown-Unknown','DeathKnight-Blood',}; local provider = {region='US',realm='Draenor',name='US',type='weekly',zone=42,date='2025-03-29',data={Ab='Abhire:AwABCAEABAoAAA==.',Ad='Advisor:AwAGCAEABAoAAA==.',Ar='Ariopoppins:AwAICAgABAoAAA==.',Av='Aviss:AwAFCAMABAoAAA==.',Ba='Bananie:AwACCAUABAoAAA==.',Bb='Bbite:AwAFCAcABAoAAA==.',Bl='Bloomzy:AwAECAEABAoAAA==.',Bo='Boombástic:AwAGCBAABAoAAA==.',Bu='Butseczxyz:AwACCAEABAoAAA==.',De='Desp:AwAHCBAABAoAAA==.',Fa='Faeonia:AwAFCAIABAoAAA==.Fallerin:AwAFCAgABAoAAA==.Farling:AwAHCBIABAoAAA==.',Fi='Fiannigon:AwAFCA4ABAoAAA==.',Ga='Garwynn:AwAHCAYABAoAAA==.',Ha='Halixan:AwADCAQABAoAAA==.',Hi='Hitmonchamp:AwABCAEABAoAAA==.',Il='Illidadysgrl:AwAECAEABAoAAA==.',Je='Jestic:AwAHCBwABAoDAQAHAQhsDgBBywgCBAoAAQAHAQhsDgA6fQgCBAoAAgAFAQiKHAAgPtAABAoAAA==.',Ka='Kamiria:AwAHCBkABAoCAwAHAQgtNAAZ/ocBBAoAAwAHAQgtNAAZ/ocBBAoAAA==.Kaymyn:AwAGCBAABAoAAA==.',Kh='Khrisbkreme:AwACCAIABAoAAQQAAAAFCAgABAo=.',Ki='Killyoualot:AwAGCAsABAoAAA==.',Ky='Kynvana:AwABCAIABAoAAA==.',Le='Lebigmu:AwACCAIABAoAAA==.Leshwi:AwAFCAIABAoAAA==.',Li='Lisettar:AwAHCBIABAoAAA==.',Lo='Logra:AwAFCAIABAoAAA==.',Lu='Luxgasp:AwAECAQABAoAAA==.',['L�']='Lìnklîght:AwACCAIABAoAAA==.',Ma='Mangixstout:AwAFCAcABAoAAA==.Matdemon:AwABCAEABAoAAA==.',Me='Melzie:AwAECAoABAoAAA==.',Mi='Minko:AwAFCAUABAoAAA==.',Ne='Nero:AwAECAQABAoAAA==.',Nn='Nnightknight:AwACCAIABAoAAA==.',Or='Orcofmordor:AwABCAEABRQAAA==.Oreoscruunit:AwAFCAgABAoAAA==.',Pe='Persaud:AwAGCBEABAoAAA==.',Pu='Puma:AwABCAIABAoAAA==.Puny:AwADCAMABAoAAA==.',Ra='Raínbowdash:AwAFCAoABAoAAA==.',Ro='Rokavmic:AwACCAMABAoAAA==.',Sa='Sapphirian:AwAICAUABAoAAA==.',Sh='Shamania:AwAICAgABAoAAA==.',Sl='Slimjd:AwAHCBIABAoAAA==.',So='Sona:AwABCAEABAoAAQQAAAAGCAoABAo=.',St='Steppin:AwAFCAgABAoAAA==.',Ta='Tarok:AwADCAQABAoAAA==.',Wh='Whiskeylegz:AwADCAMABAoAAA==.Whéélcháír:AwABCAEABRQAAA==.',Wr='Wrecksalot:AwAECAEABAoAAA==.',Yo='Yogsarah:AwAFCAMABAoAAA==.',Ze='Zemere:AwACCAUABRQCBQACAQjHBwA2EY8ABRQABQACAQjHBwA2EY8ABRQAAA==.',Zi='Zipzip:AwACCAIABRQAAA==.',Zo='Zotharion:AwACCAIABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end