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
 local lookup = {'Warlock-Demonology','Warlock-Destruction','Warlock-Affliction','Hunter-Marksmanship','Hunter-BeastMastery','Unknown-Unknown','Shaman-Enhancement','Warrior-Arms','Priest-Discipline','Mage-Frost','Mage-Fire','Druid-Restoration','Warrior-Protection','Rogue-Outlaw','Mage-Arcane','Evoker-Devastation','Priest-Holy','Priest-Shadow','Monk-Windwalker','Warrior-Fury',}; local provider = {region='US',realm='Stormscale',name='US',type='weekly',zone=42,date='2025-03-28',data={Ab='Abor:AwAECAEABAoAAA==.',Am='Amerha:AwAFCA4ABAoAAA==.',An='Anasterion:AwAGCA8ABAoAAA==.',At='Atlasdark:AwACCAMABAoAAA==.Atlasfallen:AwABCAEABAoAAA==.',Ba='Barron:AwAGCAIABAoAAA==.',Be='Beacon:AwAGCAEABAoAAA==.Beardwaffle:AwAECAQABAoAAA==.',Bl='Blax:AwADCAMABAoAAA==.Blinkss:AwADCAQABAoAAA==.Bloodhoundss:AwAECAcABAoAAA==.',Bo='Bobfx:AwADCAgABRQEAQADAQhkAQAqwaMABRQAAQACAQhkAQAuCKMABRQAAgACAQhBCwAb+Y8ABRQAAwACAQihBgAaIYsABRQAAA==.Bofft:AwAFCAoABAoAAA==.',Br='Brandonp:AwADCAgABAoAAA==.Brewbender:AwAICAgABAoAAA==.',Ca='Cake:AwAECAMABAoAAA==.Catgera:AwADCAMABAoAAA==.',Cl='Clefable:AwACCAIABAoAAA==.Clevelandoe:AwAHCA4ABAoAAA==.',Co='Conquest:AwAGCAwABAoAAA==.Corriius:AwAFCAsABAoAAA==.',Cr='Crixes:AwADCAMABAoAAA==.',Cu='Curso:AwABCAEABAoAAA==.',De='Deathcreed:AwAFCAkABAoAAA==.Demiplo:AwAICAUABAoAAA==.Deselle:AwAECAEABAoAAA==.',Dr='Drakuza:AwAFCAEABAoAAA==.Drinkndrive:AwAECAcABAoAAA==.Dropshotta:AwADCAcABRQDBAADAQjvAABYJSMBBRQABAADAQjvAABYJSMBBRQABQACAQh3FAArvXwABRQAAA==.',Du='Duo:AwADCAYABAoAAQYAAAAECAEABAo=.',Dy='Dydonks:AwAHCAwABAoAAA==.',Fe='Fenka:AwADCAYABRQCBwADAQi7AwA8PAMBBRQABwADAQi7AwA8PAMBBRQAAA==.',Fr='Frostflame:AwAGCBAABAoAAA==.',Fu='Fullsenderr:AwABCAIABAoAAA==.Furrbidden:AwADCAMABAoAAA==.',Ga='Garrosh:AwAICAMABAoCCAADAQiPKQBEDb8ABAoACAADAQiPKQBEDb8ABAoAAA==.Gazløwe:AwAGCAgABAoAAA==.',Ge='Geraniho:AwAICBkABAoEAgAIAQimBABRiAkDBAoAAgAIAQimBABRiAkDBAoAAwABAQhlJwAf2j8ABAoAAQABAQhVQAAaDC0ABAoAAA==.',Go='Goblinmyrock:AwAGCAsABAoAAA==.Gotfleas:AwEBCAQABRQAAA==.',Gr='Grommkar:AwAGCAkABAoAAA==.Grífter:AwAFCAkABAoAAA==.',Ha='Hanaka:AwAGCAsABAoAAA==.',He='Healjob:AwADCAcABRQCCQADAQg4BQAa6cQABRQACQADAQg4BQAa6cQABRQAAA==.',Hi='Hintolisu:AwAGCBEABAoAAA==.',Ho='Hoofinit:AwAFCAQABAoAAA==.Houdrat:AwAECAQABAoAAA==.',Im='Imrah:AwADCAQABAoAAA==.',Ir='Iriana:AwACCAIABAoAAA==.',It='Itscapo:AwAECAQABAoAAA==.',Ja='Jaybowski:AwAFCAoABAoAAA==.',Je='Jen:AwAGCA4ABAoAAA==.',Jo='Jo:AwAHCA4ABAoAAA==.',Ka='Kaori:AwAFCAkABAoAAA==.Kaynyx:AwADCAYABAoAAA==.',Ki='Killinflak:AwADCAMABAoAAA==.Kissyboots:AwAGCAwABAoAAA==.',Kn='Knuckles:AwADCAQABAoAAA==.',Ko='Konjur:AwADCAYABRQDCgADAQjzBQA9NF8ABRQACwACAQhjDwA0PpsABRQACgABAQjzBQBPIV8ABRQAAA==.Koshchey:AwAICAEABAoAAA==.',La='Lakeyy:AwABCAEABRQCDAAIAQhwBABUSdsCBAoADAAIAQhwBABUSdsCBAoAAA==.Lakeyys:AwAFCBIABAoAAQwAVEkBCAEABRQ=.',Le='Leidaraion:AwADCAYABRQCDQADAQgkAQAvjOUABRQADQADAQgkAQAvjOUABRQAAA==.',Li='Lisex:AwABCAIABAoAAA==.',Lo='Locklear:AwAFCA0ABAoAAA==.Logic:AwADCAQABRQCCwAIAQizCwBWUtICBAoACwAIAQizCwBWUtICBAoAAA==.Lomunn:AwACCAIABAoAAA==.Lorecan:AwADCAYABAoAAA==.',Lu='Luchenta:AwAFCBIABAoCDgAFAQiYBgAsAQ0BBAoADgAFAQiYBgAsAQ0BBAoAAA==.',Ly='Lynaperez:AwAICAQABAoAAA==.',Ma='Macktruk:AwAECAgABAoAAA==.Magicmate:AwAECAcABAoAAA==.Maples:AwABCAEABRQDCwAIAQjgDQBOALoCBAoACwAIAQjgDQBOALoCBAoADwABAQg8DQBHez0ABAoAAA==.',Me='Mekboi:AwAECAUABAoAAA==.',Mi='Minata:AwABCAEABAoAAA==.',Mo='Mokoko:AwACCAYABRQCEAACAQgfCAAnCYkABRQAEAACAQgfCAAnCYkABRQAAA==.Moothai:AwAGCAwABAoAAA==.',Na='Narkotik:AwAFCAUABAoAAA==.',Ne='Neuron:AwADCAYABRQCDAADAQi+AQBNPyEBBRQADAADAQi+AQBNPyEBBRQAAA==.',Ni='Nickademon:AwADCAMABAoAAA==.',Ov='Overdose:AwACCAQABRQCEQAIAQgrBwBPGqUCBAoAEQAIAQgrBwBPGqUCBAoAAA==.',Pa='Padle:AwAECAsABAoAAA==.Palazar:AwAFCBAABAoAAA==.',Pi='Piglittle:AwACCAQABRQCEgAIAQgdCwBH5IACBAoAEgAIAQgdCwBH5IACBAoAAA==.',Pr='Priestoe:AwADCAYABAoAAA==.',Ra='Raetage:AwABCAEABRQDEgAIAQhtEwBG+PQBBAoAEgAGAQhtEwBOUPQBBAoAEQAEAQh7MgA6dwEBBAoAAA==.',Re='Reagann:AwADCAYABAoAAA==.',Ry='Ryujinsimp:AwADCAgABRQCEAADAQh3AgBX9iYBBRQAEAADAQh3AgBX9iYBBRQAAA==.',Sh='Shamanigans:AwACCAEABAoAAA==.Shooder:AwADCAEABAoAAA==.',Sl='Slyde:AwAFCAUABAoAAA==.',Sn='Snowingmagic:AwADCAUABAoAAA==.',So='Sotawar:AwADCAcABRQCDQADAQghAQA+A+YABRQADQADAQghAQA+A+YABRQAAA==.',St='Staxstax:AwACCAYABRQCBwACAQhjBwAjr5wABRQABwACAQhjBwAjr5wABRQAAA==.Stealthdeath:AwAFCAsABAoAAA==.Steelrend:AwAECAkABAoAAA==.Steven:AwADCAQABRQCEwAIAQjVDABGC1gCBAoAEwAIAQjVDABGC1gCBAoAAA==.',Su='Superheroes:AwADCAMABAoAAA==.Supersaiyan:AwACCAIABAoAAA==.',Ta='Tagbone:AwAFCAoABAoAAA==.Taotien:AwADCAYABAoAAA==.',Tc='Tchaik:AwADCAYABAoAAA==.',Te='Terthane:AwADCAQABAoAAA==.',Ts='Tsunt:AwAFCAoABAoAAA==.',Va='Vanion:AwAGCAYABAoAAA==.Varkon:AwACCAEABAoAAA==.',Ve='Veronique:AwABCAEABRQCEAAIAQiJBwBJG6kCBAoAEAAIAQiJBwBJG6kCBAoAAA==.',Vi='Vikindia:AwABCAEABAoAAA==.Vizzeek:AwAFCAgABAoAAA==.',Wu='Wulong:AwADCAMABAoAAA==.',Xb='Xbalanque:AwAFCAEABAoAAA==.',Xe='Xesa:AwAGCAoABAoAAA==.Xesdrah:AwAICAgABAoAAA==.',Xi='Xitty:AwAFCAIABAoAAA==.',Xt='Xta:AwABCAQABRQDFAAIAQiWDgBBoYECBAoAFAAIAQiWDgA9z4ECBAoACAAHAQjBDABAghkCBAoAAA==.',Ye='Yey:AwAECAoABAoAAA==.',Yo='Yok:AwAHCAMABAoAAA==.',Za='Zaycursed:AwAFCAsABAoAAA==.',Zi='Ziggybeast:AwABCAEABRQAAA==.',Zo='Zorbyde:AwAFCAUABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end