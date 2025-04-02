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
 local lookup = {'Unknown-Unknown','Warrior-Arms','Warrior-Protection','Priest-Holy','Priest-Discipline','Warlock-Destruction','Warlock-Demonology','Warlock-Affliction','Shaman-Enhancement','Shaman-Elemental','Monk-Windwalker','Mage-Frost','Mage-Fire','Paladin-Retribution','DemonHunter-Havoc','Hunter-BeastMastery','Rogue-Subtlety','Rogue-Assassination',}; local provider = {region='US',realm="Quel'dorei",name='US',type='weekly',zone=42,date='2025-03-29',data={Ad='Aderian:AwAGCA4ABAoAAA==.',Ai='Airehanna:AwACCAEABAoAAA==.',Al='Aleetaa:AwAGCA4ABAoAAQEAAAAICAIABAo=.Alex:AwAHCA0ABAoAAA==.Althir:AwAECAcABAoAAA==.',An='Ankén:AwAGCBEABAoAAA==.Anway:AwAECAQABAoAAA==.',Ar='Arkhetype:AwADCAkABAoAAA==.Aryahi:AwAICA0ABAoAAA==.',Ba='Banker:AwADCAcABAoAAA==.Barricade:AwAICAgABAoAAA==.',Be='Berko:AwAGCAcABAoAAA==.',Bi='Billyrage:AwAHCCgABAoDAgAHAQjEDQBECRACBAoAAgAHAQjEDQBDjhACBAoAAwADAQhMGQAye5sABAoAAA==.',Bl='Bluffz:AwACCAQABRQDBAAIAQjuBQBRNMYCBAoABAAIAQjuBQBRNMYCBAoABQAGAQjCIwAqXCsBBAoAAA==.Bluffztwo:AwAFCAUABAoAAQQAUTQCCAQABRQ=.',Br='Brynjalf:AwACCAIABAoAAA==.',['B�']='Bïcho:AwAICCIABAoEBgAIAQgaIQBJ2eEBBAoABgAGAQgaIQBR3uEBBAoABwAEAQi6EwBDZEABBAoACAADAQhjEQBG5/oABAoAAA==.',Ca='Calib:AwABCAEABRQDCQAHAQipGAAmycABBAoACQAHAQipGAAmycABBAoACgADAQj8PQAr/pAABAoAAA==.Carren:AwAGCAwABAoAAA==.',Ce='Ceilcya:AwABCAIABAoAAA==.Celryth:AwAICAgABAoAAA==.',Ch='Cheechin:AwAICBUABAoCCwAIAQg3CwBEdIACBAoACwAIAQg3CwBEdIACBAoAAA==.',Cu='Cutiez:AwABCAIABRQAAA==.',Cy='Cyndreya:AwABCAEABRQCBQAHAQjGFgAvMqoBBAoABQAHAQjGFgAvMqoBBAoAAA==.',De='Demonblades:AwAFCA4ABAoAAA==.',Do='Dockevorkian:AwABCAIABRQCBAAIAQidCABMn5ECBAoABAAIAQidCABMn5ECBAoAAA==.Doritosdan:AwACCAIABAoAAA==.',Dr='Dracoramnk:AwADCAMABAoAAQEAAAAGCA4ABAo=.Dracoramonk:AwAGCA4ABAoAAA==.Drbax:AwABCAEABAoAAA==.Drinntellect:AwAICBgABAoDDAAIAQgoBgBVGuMCBAoADAAIAQgoBgBSZuMCBAoADQADAQgfVwApAp8ABAoAAA==.Dritolus:AwAFCAkABAoAAA==.',Ea='Eamass:AwAFCAoABAoAAA==.',El='Elenari:AwAGCAgABAoAAA==.',En='Enthinz:AwABCAEABRQCAwAHAQhwAgBYBL8CBAoAAwAHAQhwAgBYBL8CBAoAAA==.',Ev='Evilrobot:AwABCAEABAoAAA==.',Fa='Faithfulness:AwAFCAcABAoAAA==.',Fe='Feikonia:AwABCAEABRQCDgAIAQhdHwBJf4ECBAoADgAIAQhdHwBJf4ECBAoAAA==.Felasong:AwAICA0ABAoAAA==.Felnollid:AwAICBkABAoCDwAIAQivDQBOI8oCBAoADwAIAQivDQBOI8oCBAoAAA==.',Fr='Frmßhínð:AwAGCBMABAoAAA==.',Fu='Fubina:AwAGCAsABAoAAA==.Fulgurithm:AwAICBgABAoCCQAIAQhiAQBfuV4DBAoACQAIAQhiAQBfuV4DBAoAAA==.',Gh='Ghostdog:AwAECAQABAoAAA==.',Gr='Greasmon:AwAHCAkABAoAAA==.Grolgan:AwACCAEABAoAAA==.',Hi='Himbo:AwAECAgABAoAAA==.',Hu='Humansoup:AwAECAoABAoAAA==.Huntess:AwAGCBEABAoAAA==.',Ia='Ianthel:AwAFCA4ABAoAAA==.',Ja='Jamaican:AwADCAMABAoAAA==.Jamarcus:AwADCAYABAoAAA==.',Ke='Kernal:AwADCAMABAoAAA==.',Kh='Kharmâ:AwAICAEABAoAAA==.',Ko='Kolden:AwABCAIABAoAAA==.Koltovincent:AwACCAIABAoAAA==.Koojoé:AwABCAEABAoAAA==.',Ku='Kurzulan:AwAGCAEABAoAAA==.',La='Laghles:AwAICBUABAoCEAAIAQj8GgBFw38CBAoAEAAIAQj8GgBFw38CBAoAAA==.',Li='Lishanoth:AwAGCAsABAoAAA==.',Lo='Loozer:AwABCAEABAoAAA==.',Lu='Luthais:AwABCAIABAoAAA==.',Ma='Maleikai:AwABCAEABRQAAA==.Malific:AwABCAEABAoAAQEAAAABCAEABRQ=.Margo:AwAGCAgABAoAAA==.Martilius:AwAFCAYABAoAAA==.',Mo='Monthir:AwACCAMABAoAAA==.Moris:AwAFCAEABAoAAA==.',Na='Nawperwoman:AwAECAcABAoAAA==.',Ne='Necrosis:AwABCAEABAoAAA==.Nep:AwACCAIABAoAAA==.',No='Nogg:AwABCAEABAoAAA==.Nozpickr:AwAFCAsABAoAAA==.',Or='Orlak:AwACCAIABAoAAA==.',Os='Oslacka:AwADCAYABAoAAA==.',Ou='Ourania:AwABCAEABAoAAA==.',Pa='Pallyboi:AwADCAMABAoAAA==.',Pe='Petito:AwAFCAIABAoAAA==.',Pi='Pinga:AwAECAMABAoAAA==.',Po='Poweradë:AwAHCB4ABAoCDAAHAQgQJQAkX4sBBAoADAAHAQgQJQAkX4sBBAoAAA==.',Pr='Prusik:AwACCAQABAoAAA==.',Re='Rezzinyouu:AwABCAEABAoAAA==.',Ru='Runeclad:AwADCAcABAoAAA==.Ruunnt:AwABCAEABAoAAA==.',Sa='Sapper:AwACCAUABAoAAA==.Sathi:AwAICBAABAoAAA==.',Se='Serafall:AwAGCA4ABAoAAA==.',Sh='Shakafaka:AwAFCAEABAoAAA==.Sharnlayne:AwAGCBEABAoAAA==.Shuttsy:AwADCAUABAoAAA==.',Si='Sickhealbro:AwAFCAsABAoAAA==.Sinnister:AwAICBUABAoDEQAIAQiRCQBQlW8CBAoAEQAHAQiRCQBSMG8CBAoAEgABAQj4KABFWlMABAoAAA==.',Sk='Skulf:AwAICAgABAoAAA==.',Sn='Snorina:AwAGCA8ABAoAAA==.',So='Sosozen:AwACCAMABAoAAA==.',Sp='Spitmuffin:AwAFCAwABAoAAA==.',Sw='Swytch:AwADCAcABAoAAA==.',Te='Teesha:AwAECAQABAoAAA==.Telath:AwABCAIABRQCDwAIAQiVGwA55j8CBAoADwAIAQiVGwA55j8CBAoAAA==.',Th='Thyushi:AwAGCA0ABAoAAA==.',To='Toomuchjuice:AwABCAEABAoAAA==.',Ty='Tyranick:AwAFCA4ABAoAAA==.',We='Wetandmoist:AwAGCAYABAoAAA==.',Wo='Wovvo:AwADCAIABAoAAA==.',Xc='Xcw:AwAECAgABRQCEAAEAQh6AQBXXYsBBRQAEAAEAQh6AQBXXYsBBRQAAA==.',Za='Zakuren:AwAHCBoABAoCEAAHAQj7NwAv8r4BBAoAEAAHAQj7NwAv8r4BBAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end