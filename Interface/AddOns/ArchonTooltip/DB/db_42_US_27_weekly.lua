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
 local lookup = {'Hunter-BeastMastery','Shaman-Restoration','Unknown-Unknown','Rogue-Subtlety','Rogue-Assassination',}; local provider = {region='US',realm='Azuremyst',name='US',type='weekly',zone=42,date='2025-03-29',data={Ad='Adrillpws:AwACCAEABAoAAA==.',Al='Alohomora:AwADCAMABAoAAA==.',Ar='Archérhiro:AwACCAUABRQCAQACAQjzDgBAoaIABRQAAQACAQjzDgBAoaIABRQAAA==.',As='Asriél:AwADCAMABAoAAA==.',At='Atreus:AwAECA0ABAoAAA==.Attallaguyy:AwAICBEABAoAAA==.',Be='Beliria:AwAICAgABAoAAA==.',Br='Brandedroh:AwACCAQABAoAAA==.Broke:AwAFCAIABAoAAA==.',Bu='Bunnygf:AwAFCAsABAoAAA==.',Ca='Caidinn:AwAFCAoABAoAAA==.Carmpriest:AwAFCAMABAoAAA==.',Ce='Ceri:AwAICAgABAoAAA==.',Ch='Channingtotm:AwACCAUABRQCAgACAQgyCQA1ZZQABRQAAgACAQgyCQA1ZZQABRQAAA==.Chimecho:AwAGCA4ABAoAAA==.Chörk:AwAHCA4ABAoAAA==.',Cl='Closet:AwAECAYABAoAAA==.',Co='Cooperjoe:AwABCAEABAoAAA==.',Da='Dalaris:AwACCAIABAoAAA==.Darrosh:AwAECAIABAoAAA==.Dartian:AwACCAIABAoAAQMAAAADCAYABAo=.',De='Deathlorde:AwAGCAcABAoAAA==.Deovolente:AwACCAIABAoAAA==.',Di='Discontent:AwAECAwABAoAAA==.',Do='Domingos:AwADCAMABAoAAA==.',Dr='Dragonkin:AwAECAkABAoAAA==.Drylo:AwAICAoABAoAAA==.',Ec='Ectriond:AwABCAEABAoAAA==.',En='Envoy:AwADCAMABAoAAA==.',Es='Espers:AwAICAgABAoAAA==.',Et='Ethellin:AwACCAQABAoAAA==.',Fa='Fahrenheit:AwACCAMABAoAAA==.',Fr='Friendly:AwAECAoABRQDBAAEAQisAgA0aSoBBRQABAAEAQisAgAj/CoBBRQABQACAQibAgBXNL0ABRQAAA==.',Gr='Gruggrug:AwAICAoABAoAAA==.',Ha='Halji:AwAECAMABAoAAA==.',He='Heftyer:AwABCAEABAoAAA==.Hellcream:AwAHCBEABAoAAA==.',Hu='Huntinfuzzy:AwACCAIABAoAAA==.',Ip='Ipman:AwABCAEABAoAAA==.',Je='Jellytown:AwAGCAwABAoAAA==.',Ka='Kawdor:AwADCAUABAoAAA==.',La='Larac:AwAFCAEABAoAAA==.',Le='Leadge:AwAHCBMABAoAAA==.',Lo='Lovecannon:AwABCAEABAoAAA==.',Ma='Manawave:AwACCAIABAoAAA==.',Me='Metaphysical:AwAECAEABAoAAA==.',Mi='Mikaya:AwAICAgABAoAAA==.',Mo='Morgdrood:AwAECA0ABAoAAA==.',Ni='Nicksaban:AwACCAIABAoAAA==.Nightgear:AwABCAIABRQCAQAHAQhrIgBIeEUCBAoAAQAHAQhrIgBIeEUCBAoAAA==.Nixeava:AwABCAEABAoAAA==.',No='Nopetneeded:AwACCAIABAoAAQMAAAADCAQABAo=.Nopetsneeded:AwACCAEABAoAAQMAAAADCAQABAo=.Norepairbil:AwADCAQABAoAAA==.Noteworthy:AwAECAQABAoAAA==.',Ns='Nskanni:AwAICAoABAoAAA==.',Ny='Nyctera:AwAGCAIABAoAAA==.',Od='Odex:AwACCAIABAoAAA==.',Pa='Pally:AwAECAoABAoAAA==.Parse:AwACCAIABAoAAA==.',Ra='Ranbir:AwAFCAoABAoAAA==.',Re='Resilience:AwAGCAYABAoAAA==.Reyra:AwAGCAIABAoAAA==.',Sa='Sanitty:AwAECAcABAoAAA==.',Sc='Scubasteve:AwACCAIABAoAAA==.',Se='Sejta:AwADCAMABAoAAA==.Sephy:AwACCAIABAoAAA==.Sereyo:AwAECA0ABAoAAA==.',Sh='Shmooves:AwEDCAMABAoAAA==.',Sk='Skullace:AwACCAIABAoAAA==.',So='Soulraiser:AwAECAoABAoAAA==.',Sr='Srfreaky:AwACCAIABAoAAA==.',St='Steakmoose:AwADCAUABAoAAA==.',Ta='Tanlon:AwABCAEABAoAAA==.',Th='Thanthio:AwAECAoABAoAAA==.Thebigguns:AwACCAIABAoAAQMAAAADCAQABAo=.',To='Toniichopper:AwACCAIABAoAAA==.',Un='Unforgiven:AwADCAMABAoAAA==.',Ut='Uthersmight:AwAFCAUABAoAAA==.',Va='Valthaczar:AwAICAwABAoAAA==.',Ve='Velsetin:AwAGCAwABAoAAA==.',Wa='Was:AwAECAMABAoAAA==.',Wh='Whitetoothe:AwADCAMABAoAAA==.',Ye='Yevanendra:AwABCAEABAoAAA==.',Yo='Youneedhelp:AwAFCAUABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end