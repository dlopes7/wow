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
 local lookup = {'DeathKnight-Unholy','Unknown-Unknown','Warlock-Destruction','Warlock-Affliction','Hunter-BeastMastery','Hunter-Marksmanship','DemonHunter-Havoc','Druid-Balance',}; local provider = {region='US',realm='KhazModan',name='US',type='weekly',zone=42,date='2025-03-29',data={Al='Alareul:AwAECAYABAoAAA==.Alexandre:AwADCAgABAoAAA==.',An='Angelina:AwAECAcABAoAAA==.',Ar='Ardyelle:AwADCAgABAoAAA==.',Au='Auriah:AwAICAgABAoAAA==.',Ba='Basara:AwAFCAYABAoAAA==.',Bl='Blackknife:AwAGCA4ABAoAAA==.Blazen:AwABCAIABRQAAA==.Blightfast:AwACCAIABAoAAA==.',Bo='Bobbidyboo:AwABCAIABRQAAA==.',Ch='Chillfang:AwABCAEABRQCAQAHAQhREwBKqz4CBAoAAQAHAQhREwBKqz4CBAoAAA==.',De='Deathberry:AwADCAQABAoAAA==.Delphron:AwAECAUABAoAAA==.',Di='Discodruid:AwACCAIABAoAAA==.Divinestorm:AwAGCA8ABAoAAA==.',Do='Dodgestrikes:AwABCAEABAoAAQIAAAAECAEABAo=.Dodgysenpai:AwAECAEABAoAAA==.Dotsy:AwABCAIABRQDAwAHAQhQEwBM0lQCBAoAAwAHAQhQEwBM0lQCBAoABAACAQhfIAAiOmoABAoAAA==.',Dr='Dracon:AwAICAgABAoAAA==.Dragonpower:AwABCAEABAoAAA==.Dreams:AwAFCAcABAoAAA==.',['D�']='Dàthguy:AwAGCAoABAoAAA==.',Ed='Edaras:AwABCAEABAoAAA==.',Fe='Fearmyhunter:AwAICAgABAoAAA==.Feylen:AwAGCAwABAoAAA==.',Fi='Fifthelement:AwADCAgABAoAAA==.',Fj='Fjalgeirr:AwADCAgABAoAAA==.',Fr='Freydra:AwABCAIABRQAAA==.Frìga:AwADCAgABAoAAA==.',Fu='Furcano:AwADCAMABAoAAA==.',Ga='Gankak:AwADCAgABAoAAA==.',Ge='Gearsprocket:AwADCAgABAoAAA==.Geiste:AwABCAMABRQAAA==.',Gh='Ghue:AwAECAQABAoAAA==.',Gn='Gnarleez:AwACCAEABAoAAA==.',Gr='Graywelcome:AwABCAEABRQAAA==.Grofiest:AwACCAIABAoAAA==.Groirdim:AwABCAIABAoAAA==.',['G�']='Gôö:AwAECAQABAoAAA==.',Ha='Haldor:AwACCAIABAoAAA==.Haohmaru:AwADCAYABAoAAA==.',He='Herc:AwABCAEABAoAAA==.',Ho='Holydark:AwADCAUABAoAAA==.Horexion:AwADCAMABAoAAA==.',Im='Imagindraggn:AwADCAQABAoAAA==.',Ja='Jaded:AwAFCAUABAoAAA==.Jahseh:AwADCAYABAoAAA==.',Je='Jett:AwAECAsABAoAAA==.',Ka='Kakahna:AwADCAYABAoAAA==.Kapkywa:AwAECAYABAoAAA==.',Ke='Kellumin:AwADCAIABAoAAA==.',Kh='Khaalshama:AwACCAIABAoAAA==.',Ki='Kilra:AwADCAUABAoAAA==.',Li='Lightrawne:AwACCAIABAoAAA==.',Lo='Lobø:AwADCAgABAoAAA==.',Lu='Lunatyc:AwAFCAcABAoAAA==.Luthex:AwADCAkABAoAAA==.',Ma='Malach:AwABCAIABRQAAA==.Marijane:AwADCAYABAoAAA==.',Mc='Mccruel:AwAGCAEABAoAAA==.',Me='Melar:AwADCAUABAoAAA==.Meliriir:AwADCAIABAoAAA==.',Mo='Movack:AwAECAYABAoAAA==.',Mu='Murderface:AwADCAYABAoAAA==.',Na='Nax:AwADCAMABAoAAA==.',Ne='Nessalove:AwABCAIABRQAAA==.',No='Nocte:AwADCAgABAoAAA==.',Nz='Nz:AwADCAUABAoAAA==.',Or='Orfantal:AwAFCAwABAoAAA==.Orrion:AwABCAIABRQDBQAHAQg+DQBfDvUCBAoABQAHAQg+DQBfDvUCBAoABgABAQhkQgAu7SkABAoAAA==.',Ov='Overshoot:AwADCAYABAoAAA==.',Pe='Petfox:AwADCAcABAoAAA==.',Re='Rendstein:AwADCAgABAoAAA==.Revzxy:AwAECAUABRQCBwAEAQg7AQA60o4BBRQABwAEAQg7AQA60o4BBRQAAA==.',Sa='Salliira:AwABCAEABAoAAA==.Sarnara:AwADCAgABAoAAA==.Savagehunt:AwABCAEABRQAAA==.',Se='Secord:AwADCAgABAoAAA==.Selvetarm:AwAGCAMABAoAAA==.Sevorous:AwAGCAsABAoAAA==.',Sp='Spiced:AwADCAcABRQCCAADAQheBABYtCwBBRQACAADAQheBABYtCwBBRQAAA==.',Su='Superant:AwAFCBEABAoAAA==.',Sv='Svenya:AwADCAgABAoAAA==.',Ta='Tassandie:AwADCAgABAoAAA==.',Ti='Tiarle:AwADCAMABAoAAA==.',To='Torrickgreed:AwAFCAwABAoAAA==.',Tr='Trender:AwABCAEABAoAAA==.',Va='Valquirie:AwAECAgABAoAAA==.Vanderlea:AwACCAIABAoAAA==.Varlamor:AwACCAIABAoAAA==.',Ve='Vervane:AwADCAgABAoAAA==.',Vi='Vidarus:AwADCAQABAoAAQUAXw4BCAIABRQ=.',Vo='Vohu:AwADCAgABAoAAA==.',Wd='Wdrchaos:AwADCAMABAoAAA==.',Ze='Zerowolf:AwADCAQABAoAAA==.',Zi='Zinzis:AwAECAQABAoAAA==.',['Î']='Îi:AwAICBAABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end