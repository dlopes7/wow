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
 local lookup = {'Monk-Windwalker','Monk-Mistweaver','DeathKnight-Blood','Unknown-Unknown','Hunter-Marksmanship','Hunter-Survival','Paladin-Protection','Monk-Brewmaster','Mage-Frost',}; local provider = {region='US',realm='Llane',name='US',type='weekly',zone=42,date='2025-03-29',data={Al='Aliadra:AwADCAUABAoAAA==.',An='Antiresto:AwAGCAgABAoAAA==.',Ap='Apex:AwAICAgABAoAAA==.',Az='Azzog:AwAFCAcABAoAAA==.',Be='Betrayal:AwABCAEABAoAAA==.',Bi='Bigwhisky:AwAGCAcABAoAAA==.Billy:AwAFCAkABAoAAA==.',Bo='Boffadees:AwAFCAgABAoAAA==.',Br='Briiezee:AwAGCAUABAoAAA==.',Ca='Cashkin:AwAGCAsABAoAAA==.',Ch='Chimerax:AwAGCAQABAoAAA==.Chupfu:AwABCAEABRQCAQAHAQh9EgA58QoCBAoAAQAHAQh9EgA58QoCBAoAAA==.',Ci='Cindrozanot:AwABCAEABAoAAA==.',Co='Comadore:AwAGCAUABAoAAA==.',Cr='Credan:AwECCAQABRQCAgAIAQg7DgBDfGACBAoAAgAIAQg7DgBDfGACBAoAAA==.',Cz='Czzile:AwAECAQABAoAAA==.',Da='Daggz:AwAHCB0ABAoCAwAHAQhpDABG+yYCBAoAAwAHAQhpDABG+yYCBAoAAA==.Daphe:AwADCAYABAoAAA==.Darkplace:AwACCAIABAoAAQQAAAAFCAgABAo=.',Do='Dougyfresh:AwAICAgABAoAAA==.',Dr='Drekavac:AwAECAUABAoAAA==.',Ea='Earthsfury:AwAECAQABAoAAQQAAAAFCAcABAo=.',En='English:AwACCAIABAoAAA==.',Ex='Exek:AwADCAEABAoAAA==.',Fe='Felgetabouit:AwAGCAcABAoAAA==.Feywynn:AwAICAgABAoAAA==.',Ga='Gameslayer:AwACCAQABAoAAA==.',Gh='Ghalumvhar:AwACCAQABAoAAA==.Ghostybb:AwABCAEABAoAAA==.',Gi='Gila:AwACCAIABAoAAA==.Gizzle:AwAGCAgABAoAAA==.',Gr='Grunbar:AwAFCAwABAoAAA==.',Ic='Icxdin:AwAECAIABAoAAA==.',Il='Illandren:AwAHCBQABAoDBQAHAQi8DwBB2eYBBAoABQAHAQi8DwBB2eYBBAoABgACAQhoDwA9A2AABAoAAA==.Illuvatar:AwAICBAABAoAAA==.',Ju='Jubei:AwACCAMABRQAAA==.Justokpally:AwAHCBQABAoCBwAHAQj9CQBFLQ8CBAoABwAHAQj9CQBFLQ8CBAoAAA==.',Ka='Kalifist:AwAFCA8ABAoAAA==.Kamilock:AwAGCAYABAoAAA==.',Ki='Kitanyia:AwAGCAUABAoAAA==.',Le='Leynase:AwACCAIABAoAAA==.',Ma='Malgo:AwAFCAwABAoAAA==.Man:AwADCAIABAoAAA==.',Me='Meezee:AwACCAEABAoAAA==.',['MÃ']='MÃ´nkii:AwAHCBQABAoCCAAHAQgTAgBdPs0CBAoACAAHAQgTAgBdPs0CBAoAAA==.',Na='Naenia:AwABCAEABAoAAA==.',Ni='Nicksevokerc:AwAICAgABAoAAA==.',No='Nocainus:AwADCAcABAoAAA==.',['NÃ']='NÃ¸tsure:AwADCAkABAoAAA==.',Or='Orinoheal:AwAGCAwABAoAAA==.',Pi='Piccochill:AwACCAIABRQCCQAIAQg8AwBbdCcDBAoACQAIAQg8AwBbdCcDBAoAAA==.Piickles:AwAGCAUABAoAAA==.',['PÃ']='PÃ¹ggs:AwAECAUABAoAAA==.',Qu='Quaternion:AwADCAYABAoAAA==.Quilian:AwAGCAcABAoAAA==.',Ra='Raah:AwAFCAUABAoAAA==.Raevenhart:AwAGCAgABAoAAA==.',Sa='Salt:AwAGCAgABAoAAA==.Sanginie:AwAFCAwABAoAAA==.',Sc='Scubbs:AwAGCAYABAoAAA==.',Si='Siouxsie:AwABCAEABAoAAA==.',Sl='Sliverbane:AwAICAgABAoAAA==.',Sp='Spoilsport:AwADCAcABAoAAA==.',Ta='Taart:AwAFCAUABAoAAA==.',Te='Tezlyn:AwAFCAwABAoAAA==.',Th='Thoritalah:AwAFCAgABAoAAA==.',Ty='Typh:AwAHCBMABAoAAA==.Tyrkish:AwAFCAwABAoAAA==.',Un='Undeadscaly:AwAFCAoABAoAAA==.Undeadshaman:AwABCAIABAoAAQQAAAAFCAoABAo=.',We='Wegotthemonk:AwAFCAwABAoAAA==.',Xa='Xaneva:AwAGCAgABAoAAA==.',Ya='Yaktus:AwABCAEABAoAAA==.',Za='Zapheara:AwAFCAIABAoAAA==.',Ze='Zente:AwAGCAgABAoAAA==.Zevsticles:AwAHCBIABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end