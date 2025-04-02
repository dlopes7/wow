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
 local lookup = {'Warlock-Demonology','Warlock-Destruction','Warlock-Affliction','Unknown-Unknown','Hunter-BeastMastery','Hunter-Marksmanship','DeathKnight-Frost','DeathKnight-Unholy','Paladin-Retribution','Paladin-Holy','Monk-Windwalker',}; local provider = {region='US',realm='BloodFurnace',name='US',type='weekly',zone=42,date='2025-03-29',data={Af='Aftergone:AwAECAUABAoAAA==.Afterlife:AwACCAIABAoAAA==.',Al='Alexie:AwAECAQABAoAAA==.',An='Angarr:AwABCAEABAoAAA==.',Ar='Aryndinnin:AwAFCAYABAoAAA==.',At='Attincy:AwADCAQABAoAAA==.',Au='Auphenix:AwADCAMABAoAAA==.',Av='Avandia:AwAFCAUABAoAAA==.',Ba='Baalzebub:AwABCAMABRQEAQAIAQgXFAAwIzwBBAoAAQAFAQgXFAAqyjwBBAoAAgAFAQi0QAAkCRUBBAoAAwACAQjrHAA3k4QABAoAAA==.',Be='Beefboy:AwAECAoABAoAAA==.',Bi='Billyisme:AwACCAUABAoAAA==.Binodawiz:AwACCAQABAoAAA==.',Bl='Blakerd:AwAECAIABAoAAA==.Bluelicht:AwAFCAwABAoAAA==.',Bo='Bonki:AwABCAEABAoAAA==.Boodiica:AwABCAEABAoAAA==.Botsford:AwAECAkABAoAAA==.',Br='Brazadin:AwAICA8ABAoAAA==.Brazzen:AwAHCAsABAoAAQQAAAAICA8ABAo=.',Ca='Cadance:AwADCAEABAoAAA==.Calahunts:AwAHCBYABAoDBQAHAQh2IABKnlMCBAoABQAHAQh2IABKnlMCBAoABgACAQjYLwA6/IoABAoAAA==.',Ch='Chadfrey:AwADCAUABAoAAA==.Chrysostom:AwAHCAoABAoAAA==.Chwamz:AwAGCAIABAoAAA==.',Ci='Cisk:AwADCAMABAoAAA==.',Cl='Cloggy:AwAGCA4ABAoAAA==.',Co='Coeus:AwAFCAEABAoAAA==.Coffeerocks:AwABCAEABAoAAA==.Cosmonaut:AwACCAIABAoAAA==.Cowchucker:AwACCAEABAoAAA==.',Cr='Cringanutz:AwAFCAcABAoAAA==.',Cy='Cyrissa:AwABCAEABRQAAA==.',Da='Darkry:AwABCAEABAoAAA==.',De='Deathpack:AwAGCBgABAoDBwAGAQiBBgBXHx8CBAoABwAGAQiBBgBXHx8CBAoACAACAQioSgBSJ5wABAoAAA==.',Di='Diam:AwAICAgABAoAAA==.',Dr='Dragoncream:AwADCAEABAoAAA==.',Dv='Dvill:AwACCAMABAoAAA==.',Eu='Euki:AwACCAIABAoAAA==.',Fr='Framcha:AwACCAIABAoAAA==.',Gr='Greenmonk:AwAFCAUABAoAAA==.',Ha='Halfpint:AwABCAEABAoAAA==.Hammerstorm:AwAFCAkABAoAAA==.',He='Hearah:AwAHCA4ABAoAAA==.',Ho='Holyheelz:AwABCAIABAoAAA==.Hondò:AwAECAcABAoAAQQAAAAFCAYABAo=.Hondô:AwADCAMABAoAAQQAAAAFCAYABAo=.',['H�']='Hôndo:AwAFCAYABAoAAA==.',Id='Idra:AwADCAQABAoAAA==.',In='Inshallah:AwABCAEABAoAAA==.',Ja='Jatza:AwADCAQABAoAAA==.',Je='Jehon:AwAGCA0ABAoAAA==.',Ju='Judinous:AwAFCAoABAoAAA==.',Ka='Kasrah:AwAICA0ABAoAAA==.',Ke='Kekul:AwAECAcABAoAAA==.',Ko='Kokobinks:AwEGCBEABAoAAA==.',Kr='Krazgul:AwACCAIABAoAAA==.',Li='Lightfemboy:AwAFCAUABAoAAA==.Lilliana:AwAECAkABAoAAA==.',Lu='Lucilight:AwAECAUABAoAAA==.',['L�']='Lðxic:AwAGCAYABAoAAA==.',Ma='Manathirsty:AwABCAEABAoAAA==.Mandrei:AwABCAEABAoAAA==.Masinverter:AwAECAEABAoAAQQAAAAECAIABAo=.Mastalys:AwAICBAABAoAAA==.Mavina:AwAHCA4ABAoAAA==.Maximinoe:AwAFCAUABAoAAA==.',Me='Methenistul:AwABCAIABAoAAA==.Metro:AwAICBAABAoAAA==.Mewow:AwAECAQABAoAAA==.',Mi='Miasmun:AwAECAIABAoAAA==.Mikemike:AwACCAIABAoAAA==.Mitsunari:AwABCAIABAoAAQQAAAADCAIABAo=.',Mo='Moosetorin:AwAGCA0ABAoAAA==.',No='Nossaviah:AwAECAEABAoAAA==.',Pe='Pepperss:AwABCAEABRQAAA==.Pezz:AwACCAIABAoAAA==.',Pu='Puffiepuff:AwABCAEABAoAAA==.Purifried:AwAFCAEABAoAAA==.',['P�']='Pááuul:AwAFCAUABAoAAA==.',Qu='Quietdemon:AwAICAgABAoAAA==.Quietdwarff:AwAICAIABAoAAQQAAAAICAgABAo=.Quietlock:AwAGCAYABAoAAQQAAAAICAgABAo=.',Ro='Roguedbo:AwAECAIABAoAAA==.',Ry='Ryoko:AwACCAIABAoAAA==.',Sa='Saintofthetp:AwAECAIABAoAAA==.',Se='Serencio:AwAICAoABAoAAA==.Sevvro:AwAFCAEABAoAAA==.',Sh='Shaemuss:AwAFCAsABAoAAA==.',Sk='Skaborn:AwAFCAwABAoAAA==.Skullshine:AwADCAIABAoAAA==.Skybreaker:AwACCAIABAoAAA==.',Sl='Slushadin:AwABCAEABAoAAA==.',Sp='Spicolii:AwAICAcABAoAAA==.Splits:AwADCAQABAoAAA==.',St='Stormshade:AwABCAIABAoAAA==.Stunllub:AwABCAEABAoAAA==.',Su='Suggs:AwAGCA0ABAoAAA==.Superlight:AwAFCAwABAoAAA==.',Sy='Sysk:AwABCAEABRQCCQAHAQgDJQBNfWECBAoACQAHAQgDJQBNfWECBAoAAA==.',Ta='Tara:AwABCAEABAoAAA==.',Th='Theradestria:AwADCAcABAoAAA==.',Ti='Tillswarrior:AwACCAIABAoAAA==.Timmyjam:AwADCAMABAoAAA==.',To='Toebean:AwAECAYABAoAAA==.',Tr='Trazalthen:AwACCAEABAoAAA==.Troxy:AwAFCAgABAoAAA==.',Ud='Udderless:AwADCAMABAoAAA==.',Un='Understorm:AwACCAIABAoAAQQAAAAECAQABAo=.',Us='Ussyologist:AwAHCA8ABAoAAA==.',Ve='Velro:AwAGCAoABAoAAA==.',Wi='Wigglypuffsr:AwAFCAoABAoAAQQAAAAFCAwABAo=.Wiikkid:AwACCAIABAoAAA==.',Wl='Wll:AwAECAcABAoAAA==.',Wo='Woogyboogy:AwADCAUABAoAAA==.',Xa='Xaclov:AwAGCAUABAoAAA==.Xalcor:AwEGCAIABAoAAA==.',Xy='Xygon:AwAFCAgABAoAAA==.',Ya='Yahtzeé:AwAGCBQABAoCCgAGAQiOCwBNgv4BBAoACgAGAQiOCwBNgv4BBAoAAA==.',Yo='Yoshisune:AwAICBAABAoAAA==.',Za='Zaffira:AwAICAgABAoAAA==.Zapz:AwEECAQABAoAAQsASaoECAoABRQ=.',Ze='Zenshay:AwABCAEABAoAAA==.Zerochii:AwABCAEABRQAAA==.',Zo='Zolmijin:AwAFCA4ABAoAAA==.',['Â']='Âpophis:AwACCAEABAoAAQQAAAAECAQABAo=.',['Ç']='Çélädor:AwABCAIABRQCCQAIAQiqBABfOVgDBAoACQAIAQiqBABfOVgDBAoAAA==.',['ß']='ßozo:AwABCAEABRQAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end