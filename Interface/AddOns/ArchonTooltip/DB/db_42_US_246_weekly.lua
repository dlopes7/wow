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
 local lookup = {'Priest-Discipline','Evoker-Devastation','Evoker-Preservation','Druid-Restoration','Unknown-Unknown','Shaman-Restoration','Mage-Fire','Mage-Frost','Monk-Windwalker','Paladin-Retribution','Rogue-Subtlety','Rogue-Assassination','Hunter-BeastMastery','DeathKnight-Blood','DeathKnight-Unholy','Priest-Shadow','Shaman-Enhancement','Shaman-Elemental',}; local provider = {region='US',realm='Zuluhed',name='US',type='weekly',zone=42,date='2025-03-28',data={Ai='Aid:AwAHCB0ABAoCAQAHAQhaBwBRm5QCBAoAAQAHAQhaBwBRm5QCBAoAAA==.',Ak='Akharru:AwAHCBUABAoDAgAHAQjHGwBCVT8BBAoAAgAFAQjHGwA9yz8BBAoAAwAGAQihDQAe1DcBBAoAAA==.',Al='Allmaick:AwACCAUABAoAAA==.',An='Antimovsky:AwAFCAMABAoAAA==.',Ar='Arlare:AwACCAIABRQCBAAIAQiuCABEo3ECBAoABAAIAQiuCABEo3ECBAoAAA==.',Ba='Banin:AwADCAEABAoAAA==.',Be='Beasle:AwAICAUABAoAAA==.',Bi='Bigwilli:AwABCAEABAoAAA==.',Ce='Cernnunnos:AwAECAkABAoAAQUAAAAFCAUABAo=.',Da='Dankins:AwACCAIABRQCBgAIAQjbCgBLzo4CBAoABgAIAQjbCgBLzo4CBAoAAA==.',De='Devilchaser:AwAFCAMABAoAAA==.',Dr='Droopnoot:AwADCAYABAoAAA==.',Em='Emulsifier:AwAFCAwABAoAAA==.',Er='Erusgizmo:AwAHCBMABAoAAA==.',Fi='Finester:AwAFCA4ABAoAAA==.',Fr='Friendlybob:AwAGCAUABAoAAA==.',['G�']='Gímli:AwADCAMABAoAAQUAAAAECAcABAo=.',Ha='Haveaburitto:AwACCAIABRQDBwAHAQhhDwBdZqgCBAoABwAHAQhhDwBX8qgCBAoACAAGAQj1EwBYMhgCBAoAAA==.',He='Hee:AwACCAIABRQCCQAHAQi8CABVFqkCBAoACQAHAQi8CABVFqkCBAoAAA==.',Ho='Holycøw:AwAFCAkABAoAAA==.Holyshizzle:AwAICBQABAoCCgAIAQiaHQBFYoICBAoACgAIAQiaHQBFYoICBAoAAA==.',Hq='Hqèrny:AwABCAEABAoAAA==.',Ih='Ihureciv:AwAHCBMABAoAAA==.',Ik='Ikadii:AwABCAEABAoAAA==.Ikur:AwAECAEABAoAAA==.',Ip='Ipopkidneys:AwACCAUABRQDCwACAQhzBgA+1aUABRQACwACAQhzBgA+1aUABRQADAABAQgrBwAydEoABRQAAA==.',['J�']='Jîmlahey:AwACCAIABAoAAA==.',Le='Leeroy:AwAICAgABAoAAA==.',Li='Livmoore:AwADCAUABAoAAA==.',Lu='Lunastorm:AwAHCBMABAoAAA==.Lunie:AwADCAUABAoAAA==.Luponero:AwAHCBYABAoCDQAHAQi6EQBYLMYCBAoADQAHAQi6EQBYLMYCBAoAAA==.Luvyaa:AwABCAEABAoAAA==.',Ma='Mageyoudie:AwAICA4ABAoAAA==.Mandos:AwAFCAUABAoAAA==.',Me='Merlini:AwAECAMABAoAAA==.Meshflow:AwADCAMABAoAAA==.',Mo='Moomookitty:AwACCAIABAoAAA==.',My='Myronalor:AwADCAMABAoAAQQARKMCCAIABRQ=.',Na='Najta:AwADCAgABAoAAA==.',Ne='Nezblorc:AwAECAkABAoAAA==.Nezzywezzy:AwABCAEABAoAAA==.',Oc='Ocra:AwAHCBMABAoAAA==.',Of='Offspeck:AwAHCBAABAoAAA==.',Ou='Outkkast:AwACCAIABAoAAA==.',Oz='Ozwald:AwAHCBMABAoAAA==.',Pe='Petures:AwABCAIABRQAAA==.',Ph='Phosphorus:AwAHCBMABAoAAA==.',Pl='Plagüë:AwAHCBMABAoAAA==.',Qt='Qtmenopaws:AwABCAEABAoAAA==.',Ra='Radiantsloth:AwAFCAUABAoAAA==.Raelynne:AwADCAYABAoAAA==.Ravioles:AwAHCBMABAoAAA==.',Rh='Rhae:AwAECAQABAoAAQUAAAAFCAUABAo=.',Sa='Sacerbelator:AwAGCAkABAoAAA==.',Se='Sedda:AwAHCBcABAoCCgAHAQgdEwBfTs0CBAoACgAHAQgdEwBfTs0CBAoAAA==.Sensual:AwAHCBEABAoAAA==.Sesshomaru:AwAHCBMABAoAAA==.',Si='Siare:AwADCAMABAoAAA==.',Sk='Skadî:AwAECAcABAoAAA==.',Sn='Sneetchme:AwABCAEABRQCCQAIAQi6BQBRw+sCBAoACQAIAQi6BQBRw+sCBAoAAA==.',Ta='Taxgirly:AwAFCA4ABAoAAA==.Taxwalker:AwADCAMABAoAAQUAAAAFCA4ABAo=.',Te='Tekios:AwAHCBkABAoCAgAHAQj5EQA1fdABBAoAAgAHAQj5EQA1fdABBAoAAA==.',Th='Thizzles:AwAICBYABAoDDgAIAQjbCQBHNVQCBAoADgAHAQjbCQBLeFQCBAoADwACAQieTQA3i3cABAoAAQUAAAABCAMABRQ=.',Un='Undread:AwABCAEABRQCDAAGAQhmCABYqEsCBAoADAAGAQhmCABYqEsCBAoAAA==.',Ve='Veil:AwACCAIABAoAARAARD4DCAgABRQ=.',Vi='Viserion:AwADCAMABAoAAA==.',Vo='Voidchaos:AwAECAQABAoAAA==.',Vu='Vue:AwAHCBMABAoAAA==.',Wa='Wakasham:AwAGCBYABAoCEQAGAQhQDABemXYCBAoAEQAGAQhQDABemXYCBAoAAA==.',Wi='Willpower:AwABCAEABAoAAA==.',Wu='Wunderlust:AwAHCA4ABAoAAA==.',Ye='Yellowshaman:AwAHCBUABAoCEgAHAQg2CgBV0IgCBAoAEgAHAQg2CgBV0IgCBAoAAA==.',Yu='Yuruse:AwAECAYABAoAAA==.',Zz='Zzëd:AwABCAEABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end