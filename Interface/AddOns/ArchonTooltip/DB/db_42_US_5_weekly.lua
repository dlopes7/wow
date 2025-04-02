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
 local lookup = {'Unknown-Unknown','Warlock-Destruction','Warlock-Affliction','Warlock-Demonology','Evoker-Devastation','Paladin-Holy','Warrior-Protection','Priest-Shadow','Paladin-Protection','Paladin-Retribution','Shaman-Elemental','Druid-Balance','Shaman-Enhancement','Monk-Windwalker','Monk-Mistweaver','Warrior-Fury','Warrior-Arms','Hunter-Marksmanship','Priest-Holy','Shaman-Restoration','Evoker-Preservation','Hunter-BeastMastery','Hunter-Survival','Mage-Frost','Mage-Fire','DemonHunter-Vengeance',}; local provider = {region='US',realm='Akama',name='US',type='weekly',zone=42,date='2025-03-29',data={Ac='Achendron:AwADCAMABAoAAQEAAAADCAUABAo=.',Ad='Adrenaline:AwABCAEABAoAAA==.',Ae='Aelha:AwADCAMABAoAAA==.Aeratedlol:AwAECAoABRQEAgAEAQgPBwBSpMUABRQAAgACAQgPBwBVScUABRQAAwACAQhyBABSU6wABRQABAABAQjiAgBXHWUABRQAAA==.',Al='Aldrigor:AwAHCBMABAoAAA==.Alecto:AwAGCA8ABAoAAA==.',Ar='Aragörn:AwABCAEABAoAAA==.Arglock:AwACCAIABRQEAgAIAQiNJQA4gr4BBAoAAgAHAQiNJQA67b4BBAoAAwADAQgbFgAlUMIABAoABAACAQgPLgBBXooABAoAAA==.Arthaslk:AwACCAIABAoAAA==.',As='Astralock:AwADCAQABAoAAA==.',Au='Autocharge:AwAFCBIABAoAAA==.',Ba='Babycactus:AwAFCAYABAoAAA==.Baetrayer:AwACCAQABRQAAA==.Ballsofire:AwACCAcABAoAAA==.',Be='Belithel:AwAGCBMABAoAAA==.Bencreepin:AwACCAMABAoAAA==.Bernoulli:AwAGCAEABAoAAA==.Bestial:AwAICA4ABAoAAA==.',Bi='Bignose:AwAICAkABAoAAA==.',Bl='Blinkers:AwAGCAsABAoAAA==.',Bo='Boosted:AwADCAMABAoAAA==.Borgak:AwAICBAABAoAAA==.',Br='Bronnyjames:AwADCAMABAoAAQEAAAAGCAEABAo=.',Ca='Cactuscooler:AwADCAYABRQCBQADAQgYBABGB/cABRQABQADAQgYBABGB/cABRQAAA==.',Ch='Chape:AwABCAEABRQCBgAIAQhaCgA1LxUCBAoABgAIAQhaCgA1LxUCBAoAAA==.Chunkymonkey:AwAGCAwABAoAAA==.',Cl='Clawhalla:AwAGCA4ABAoAAA==.',Cn='Cnorthover:AwAECAQABAoAAA==.',Co='Conng:AwAFCAUABAoAAA==.',Cr='Crzyfluffy:AwAFCAkABAoAAA==.',Da='Daelin:AwAGCBEABAoAAA==.Darkacedia:AwABCAEABRQEBAAIAQieCABEM+EBBAoABAAGAQieCABG1eEBBAoAAgAEAQh/UQAjQ8gABAoAAwABAQjdKgA5WDcABAoAAA==.',De='Dealosed:AwAFCAwABAoAAA==.Deathimon:AwADCAQABAoAAQcANS4CCAUABRQ=.Deathkano:AwABCAEABAoAAQEAAAADCAIABAo=.Deremus:AwADCAIABAoAAA==.',Di='Disastasmite:AwACCAUABRQCCAACAQjUBgBV/L4ABRQACAACAQjUBgBV/L4ABRQAAA==.',Dr='Dragoneggs:AwAICBUABAoCBQAIAQhcCQBFqIcCBAoABQAIAQhcCQBFqIcCBAoAAA==.Drippyy:AwABCAIABRQDCQAIAQgGAQBfNFUDBAoACQAIAQgGAQBfNFUDBAoACgABAQhl+wARSDQABAoAAA==.Drum:AwACCAQABRQCCwAIAQgyCgBRdZQCBAoACwAIAQgyCgBRdZQCBAoAAA==.',El='Eldabearz:AwABCAEABRQCDAAIAQgDCwBPQcoCBAoADAAIAQgDCwBPQcoCBAoAAA==.',Em='Emz:AwAFCAUABAoAAA==.',En='Enemy:AwADCAUABAoAAA==.',Er='Erianda:AwAFCA0ABAoAAA==.',Et='Ethene:AwADCAUABAoAAA==.',Eu='Eurong:AwACCAUABRQCDAACAQiEDQAep4AABRQADAACAQiEDQAep4AABRQAAA==.',Ez='Ezynuff:AwADCAUABAoAAA==.',Fo='Foamgear:AwAFCA0ABAoAAA==.Fortescue:AwAFCA4ABAoAAA==.',Fr='Fretty:AwACCAIABAoAAQoAWT0CCAUABRQ=.Frewtlewps:AwAICAMABAoAAA==.',Ga='Gabbathegoo:AwAHCCEABAoDAgAHAQhCHABYKQYCBAoAAgAFAQhCHABa7AYCBAoABAADAQiJHQBIwusABAoAAA==.Gainzz:AwAICAgABAoAAA==.Garonnaa:AwAHCBAABAoAAA==.',Go='Gormasha:AwABCAEABRQCDQAIAQgZEAA9fz0CBAoADQAIAQgZEAA9fz0CBAoAAA==.',Gr='Greenus:AwABCAEABRQDDgAIAQhBEgBAbQ4CBAoADgAHAQhBEgBAPQ4CBAoADwABAQg+YQAhgT8ABAoAAA==.Greka:AwACCAIABAoAAA==.Gruhb:AwAECAQABAoAAQoAWT0CCAUABRQ=.Gruhm:AwACCAUABRQCCgACAQiOCwBZPbUABRQACgACAQiOCwBZPbUABRQAAA==.',Ha='Harrydötter:AwAHCA0ABAoAAA==.Hawkwood:AwADCAEABAoAAA==.',He='Heàl:AwACCAIABAoAAA==.',Ho='Holycrow:AwABCAEABAoAAA==.Hoovehearted:AwACCAMABRQCCQAIAQifCgA4iAECBAoACQAIAQifCgA4iAECBAoAAA==.',Ic='Icedrip:AwADCAIABAoAAA==.',Ig='Igluu:AwAECAQABAoAAA==.',Im='Immhotep:AwAICBgABAoCEAAIAQh4CABV4uACBAoAEAAIAQh4CABV4uACBAoAAA==.',Io='Iounn:AwAGCAsABAoAAA==.',It='Itsybityshiv:AwADCAcABAoAAA==.',Ja='Jajanken:AwAECAMABAoAAA==.Jambalam:AwADCAEABAoAAA==.Janesa:AwAECAEABAoAAA==.Jaysontatum:AwAGCAEABAoAAA==.',Ju='Juicer:AwABCAEABAoAAA==.',Ka='Kamin:AwAHCA4ABAoAAA==.Kaykaypally:AwAFCAsABAoAAA==.',Ki='Kilgharra:AwABCAEABAoAAA==.Kinji:AwAECAQABAoAAQEAAAAGCBMABAo=.Kittycatmeow:AwAHCAEABAoAAA==.',La='Lambshot:AwAFCAsABAoAAA==.Lambsy:AwAECAoABRQDEAAEAQjkAQBCWnIBBRQAEAAEAQjkAQBCWnIBBRQAEQABAQjFBwAxjFcABRQAAA==.',Le='Lerat:AwAFCA8ABAoAAA==.Lewpha:AwAFCAoABAoAAA==.',Li='Lisanalgaib:AwADCAsABAoAAA==.Lizzimcguire:AwAGCAgABAoAAA==.',Lo='Loth:AwABCAEABRQAAA==.Lowi:AwABCAEABAoAAA==.',Ma='Maelyn:AwAGCA4ABAoAAA==.Malalak:AwACCAIABAoAAA==.Markwahlbrew:AwAECAMABAoAAA==.Marsrover:AwACCAIABAoAARIASq4ECAoABRQ=.Matroxx:AwAHCBUABAoCDgAHAQg4FQA7weMBBAoADgAHAQg4FQA7weMBBAoAAA==.',Mi='Midareta:AwAICAkABAoAAA==.Minddagger:AwAICAgABAoAAA==.Mizby:AwACCAUABRQCEwACAQhGBABZeskABRQAEwACAQhGBABZeskABRQAAA==.',Mu='Muteki:AwAFCAsABAoAAA==.',Na='Nattylite:AwABCAEABAoAAA==.',No='Noemie:AwADCAcABAoAAA==.Norman:AwABCAEABRQAAQ4AXqUCCAQABRQ=.',Nu='Nubp:AwAECAwABAoAAA==.',Or='Orestes:AwAECAYABAoAAA==.Orexion:AwACCAIABAoAAA==.',Ou='Ouououououou:AwAHCBAABAoAAA==.',Pa='Palypekrtime:AwAECAQABAoAAA==.Parador:AwADCAEABAoAAA==.',Pe='Peacehoof:AwADCAQABAoAAA==.',Pr='Premonitions:AwAECAEABAoAAA==.Premune:AwAFCAoABAoAAA==.Primella:AwADCAUABRQCBgADAQgLAQBW5ToBBRQABgADAQgLAQBW5ToBBRQAAA==.',Pu='Pugna:AwADCAYABAoAAA==.Punchalle:AwAFCAsABAoAAA==.',Qt='Qt:AwAECAEABAoAAA==.',Ra='Raine:AwACCAcABRQCFAACAQgwBgBXDr0ABRQAFAACAQgwBgBXDr0ABRQAAA==.Rainmaker:AwADCAUABAoAAQEAAAADCAYABAo=.Ralfio:AwAGCAcABAoAAA==.Ramen:AwAFCAcABAoAAA==.Raynith:AwAGCAIABAoAAA==.',Re='Revelaen:AwABCAEABRQCFQAHAQhTBQBFZUACBAoAFQAHAQhTBQBFZUACBAoAAA==.',Ri='Rick:AwAHCBAABAoAAA==.',Rm='Rmagep:AwAECAYABAoAAA==.',Rn='Rngeezus:AwACCAIABAoAAA==.',Sa='Sakumo:AwAFCA8ABAoAAA==.Santificador:AwABCAEABAoAAA==.Sapphica:AwAECAIABAoAAA==.Sathreina:AwADCAQABAoAAA==.Savarina:AwACCAEABAoAAA==.',Sc='Scaries:AwAHCA0ABAoAAA==.',Sh='Shaddh:AwAGCAoABAoAAA==.Shadowbuilt:AwADCAUABAoAAA==.Shadowisbad:AwAFCAgABAoAAA==.Shotzzx:AwAECAoABRQEEgAEAQi9AgBKrrcABRQAFgACAQhQDABatr8ABRQAEgACAQi9AgA48LcABRQAFwABAQjLAABfzWgABRQAAA==.',Si='Sicempet:AwAGCBAABAoAAA==.',Sl='Slappee:AwAFCAUABAoAAA==.Slappypappy:AwADCAUABAoAAQEAAAAFCAUABAo=.',St='Stoneskin:AwACCAEABAoAAA==.Storienn:AwACCAMABAoAAA==.',Sw='Swaption:AwAGCAoABAoAAA==.',Ta='Tauloe:AwADCAQABAoAAA==.',Te='Tetrace:AwADCAEABAoAAQEAAAAECAgABAo=.',Th='Thatsograven:AwADCAUABAoAAA==.Thobias:AwACCAYABAoAAA==.Thunk:AwAGCAEABAoAAA==.',Ti='Timdawg:AwECCAUABRQDGAACAQhRAQBjMecABRQAGAACAQhRAQBjMecABRQAGQACAQjNEgAp/YwABRQAAA==.',To='Tomoto:AwAFCAwABAoAAA==.',Tu='Tum:AwACCAUABRQCGgACAQheAwBI0akABRQAGgACAQheAwBI0akABRQAAA==.',Ty='Ty:AwEHCAwABAoAAA==.',Ub='Ubi:AwAICBIABAoAAA==.',Va='Vallodon:AwAGCA4ABAoAAA==.',Ve='Verrexis:AwAHCA8ABAoAAA==.',Vo='Vodoc:AwAGCBUABAoCCQAGAQirBgBazGgCBAoACQAGAQirBgBazGgCBAoAAA==.',Vy='Vyndiesel:AwABCAIABRQAAA==.',Wa='Warrgodx:AwADCAMABAoAAA==.Warrimon:AwACCAUABRQCBwACAQg8AgA1LpAABRQABwACAQg8AgA1LpAABRQAAA==.',Wr='Wrongwookie:AwAFCAoABAoAAA==.',Xy='Xynthora:AwADCAMABAoAAA==.',Ze='Zedrakh:AwAFCAsABAoAAA==.Zetta:AwABCAEABRQCCAAHAQg+EgA9pxACBAoACAAHAQg+EgA9pxACBAoAAA==.',['Å']='Åmbrosio:AwAFCAsABAoAAA==.',['Æ']='Ænimal:AwAFCAMABAoAAA==.',['Ç']='Çorruption:AwAFCAgABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end