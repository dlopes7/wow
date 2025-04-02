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
 local lookup = {'DeathKnight-Frost','Unknown-Unknown','Druid-Restoration','Warrior-Protection','Warrior-Fury','Priest-Shadow','Priest-Holy','DeathKnight-Blood','DeathKnight-Unholy','Mage-Fire','Shaman-Elemental','Paladin-Retribution','Hunter-BeastMastery',}; local provider = {region='US',realm='Kargath',name='US',type='weekly',zone=42,date='2025-03-29',data={Ae='Aellopus:AwAGCBAABAoAAA==.Aero:AwAFCA4ABAoAAA==.',Al='Allebazsi:AwACCAUABAoAAA==.Allure:AwAICBIABAoAAA==.',An='Anadrien:AwAFCA0ABAoAAA==.Angrimia:AwAFCA4ABAoAAA==.Annussa:AwADCAUABAoAAA==.',Ar='Araelun:AwADCAcABAoAAA==.Arcadea:AwAFCAwABAoAAA==.',Av='Avestara:AwAFCA4ABAoAAA==.',Az='Azazill:AwACCAIABAoAAA==.Azoril:AwAFCBMABAoAAA==.',Ba='Babadooeyy:AwAHCA8ABAoAAA==.Babs:AwADCAMABAoAAA==.Basicbenja:AwACCAIABAoAAA==.',Be='Bearserker:AwAECAUABAoAAA==.Beila:AwAFCA0ABAoAAA==.',Bi='Bierbro:AwAFCAkABAoAAA==.',Bo='Bombgen:AwAFCA4ABAoAAA==.',Br='Brae:AwAECAQABAoAAA==.Bricifernope:AwABCAIABRQAAA==.Brickedup:AwAECAoABAoAAA==.Brightblayde:AwAFCAwABAoAAA==.',Bu='Butterknight:AwAGCBQABAoCAQAGAQiBBQBbd0UCBAoAAQAGAQiBBQBbd0UCBAoAAA==.Buttertotem:AwACCAMABAoAAA==.',Ca='Callistine:AwAGCA0ABAoAAA==.Carbazole:AwACCAIABAoAAA==.Castymcheal:AwACCAIABAoAAQIAAAAGCAoABAo=.',Ce='Cervantés:AwAFCAQABAoAAA==.',Ch='Chise:AwAGCAwABAoAAA==.Chrispyloa:AwACCAIABAoAAA==.',Cr='Crankdhog:AwACCAQABAoAAA==.Critmypantz:AwADCAIABAoAAA==.Crosby:AwAGCBEABAoAAA==.',Cy='Cygna:AwABCAIABRQAAA==.Cyntheis:AwACCAIABAoAAA==.Cyntheria:AwAGCAwABAoAAA==.',Da='Daethera:AwAFCAgABAoAAA==.Daezerda:AwACCAIABAoAAA==.',De='Deathbylight:AwACCAEABAoAAA==.Deme:AwAFCAYABAoAAA==.Demonica:AwAFCAkABAoAAA==.Dendrax:AwAFCA0ABAoAAA==.Derivation:AwACCAIABAoAAA==.',Dr='Drakkisath:AwAFCA4ABAoAAA==.Drukhi:AwAGCAwABAoAAA==.',Du='Durtkal:AwAFCAMABAoAAA==.',Ep='Ephraelstern:AwADCAMABAoAAA==.',Eu='Eurythmics:AwAFCAwABAoAAA==.',Ev='Evileen:AwAHCAkABAoAAA==.',Fa='Facebegone:AwADCAEABAoAAA==.',Fi='Firmsmash:AwAECA0ABAoAAA==.',Fl='Flaccidphil:AwACCAIABAoAAA==.Flowermound:AwABCAEABAoAAA==.',Fo='Fourqto:AwAFCA4ABAoAAA==.',Fr='Fredmenethil:AwAFCAcABAoAAA==.Frona:AwAECAgABAoAAA==.',Fu='Fulmetal:AwADCAIABAoAAA==.Funkalicious:AwAHCAsABAoAAA==.Funnerris:AwACCAIABRQAAA==.',Ga='Gaila:AwAFCA4ABAoAAA==.Gazreyna:AwAECAoABAoAAA==.',Gc='Gcarne:AwADCAYABAoAAA==.',Gl='Glakenspheal:AwAGCBMABAoAAA==.Glitch:AwABCAEABAoAAA==.',Go='Gojano:AwAHCA4ABAoAAA==.',Gr='Greybeast:AwADCAMABRQCAwAIAQjJAgBaRhMDBAoAAwAIAQjJAgBaRhMDBAoAAA==.Grumpyazpapa:AwACCAEABAoAAQIAAAAFCAoABAo=.',['G�']='Gúldan:AwACCAMABAoAAA==.',Ha='Hairypitts:AwAECAkABAoAAA==.',He='Heiboss:AwADCAQABAoAAQIAAAAGCAwABAo=.Heimister:AwAECAQABAoAAQIAAAAGCAwABAo=.Helani:AwAFCAUABAoAAA==.',Ho='Honeyb:AwACCAIABAoAAA==.',Hu='Huran:AwAGCAwABAoAAA==.',Ig='Ignignokt:AwAFCA4ABAoAAA==.',In='Infinityevo:AwAFCAgABAoAAA==.',Ir='Ironshield:AwAECAwABAoAAA==.',Iw='Iwishiknew:AwAGCBQABAoDBAAGAQh9CgA4PYoBBAoABAAGAQh9CgA4PYoBBAoABQACAQjBWQAlcmkABAoAAA==.',Iz='Izzit:AwACCAIABAoAAA==.',Jo='Johannes:AwAGCBQABAoDBgAGAQiSDwBXTjoCBAoABgAGAQiSDwBXTjoCBAoABwAFAQikGgBULrcBBAoAAA==.',Ka='Kaizofire:AwABCAEABAoAAA==.Karigyn:AwAFCA0ABAoAAA==.Katrienne:AwAFCA4ABAoAAA==.Kaylid:AwAFCAoABAoAAA==.',Ki='Kiyree:AwAFCBMABAoAAA==.',Ko='Kosmos:AwABCAIABRQDCAAIAQjpEAAypdEBBAoACAAIAQjpEAAypdEBBAoACQAEAQhARgAb47YABAoAAA==.',Ky='Kyrei:AwADCAQABAoAAA==.',Le='Leakie:AwACCAIABAoAAQIAAAAGCAwABAo=.Leetlebug:AwAFCA4ABAoAAA==.Lettÿ:AwABCAIABAoAAA==.',Li='Lightheaded:AwADCAYABAoAAA==.Linitharieda:AwACCAMABAoAAQYAV04GCBQABAo=.',Lo='Lodiso:AwAECAEABAoAAA==.',Lu='Luminai:AwADCAUABAoAAA==.',Ma='Magikstik:AwAFCAUABAoAAA==.Magistra:AwADCAIABAoAAA==.Majestic:AwAICBYABAoCCgAIAQhSGAA7a1ICBAoACgAIAQhSGAA7a1ICBAoAAA==.Malvenue:AwAICBAABAoAAA==.Mauwy:AwABCAEABAoAAQIAAAAFCAcABAo=.',Mc='Mcbullseye:AwAGCA0ABAoAAA==.',Me='Menados:AwAGCAgABAoAAA==.',Mi='Miwah:AwAECAkABAoAAA==.',Mo='Modin:AwABCAEABAoAAA==.Momonk:AwADCAkABAoAAA==.Mordregan:AwAFCAIABAoAAA==.',Mu='Muerr:AwAGCAoABAoAAA==.Muerrlin:AwACCAIABAoAAQIAAAAGCAoABAo=.Mushroohead:AwAFCBQABAoCCwAFAQj7GgBPUKcBBAoACwAFAQj7GgBPUKcBBAoAAA==.',Mw='Mw:AwACCAIABAoAAQIAAAAFCAgABAo=.',['M�']='Mâsonsha:AwAHCAMABAoAAA==.',Na='Namii:AwAGCA8ABAoAAA==.',Ne='Nedrali:AwAFCAcABAoAAA==.Nekìshì:AwAICAgABAoAAA==.Nesuada:AwAECAoABAoAAA==.',Ni='Nienor:AwADCAMABAoAAA==.Nightle:AwAFCAoABAoAAA==.',No='Nooki:AwAGCAwABAoAAA==.',Pa='Pallipalegic:AwAGCAkABAoAAA==.Pancetta:AwADCAIABAoAAA==.Panikswitch:AwAICA4ABAoAAA==.Papabill:AwAFCAoABAoAAA==.Paranoria:AwAFCA0ABAoAAA==.',Pe='Pech:AwAGCAoABAoAAA==.Pewpewnotqq:AwAICAsABAoAAA==.',Po='Pokeybutz:AwAFCA4ABAoAAA==.',Pr='Promgen:AwAFCA4ABAoAAQwAUFMCCAQABRQ=.Pryxi:AwAFCAsABAoAAA==.',Py='Pynky:AwAECAcABAoAAA==.',['P�']='Pótatò:AwACCAQABAoAAA==.',Qu='Quandaale:AwABCAEABAoAAQIAAAAGCAoABAo=.',Ra='Randumb:AwAFCAkABAoAAA==.',Re='Rennyo:AwAFCA0ABAoAAA==.Reuss:AwACCAIABAoAAA==.',Ru='Ruadun:AwAECAQABAoAAA==.Rumlidorgah:AwAECAcABAoAAA==.Runem:AwACCAMABAoAAA==.Runenomore:AwADCAMABAoAAA==.',Se='Sefoniel:AwAFCA0ABAoAAA==.',Sh='Shakalaka:AwAFCAoABAoAAA==.Shinjô:AwACCAIABAoAAA==.Shêldor:AwACCAIABAoAAA==.',Si='Silvermind:AwAFCA4ABAoAAA==.',Sl='Slotz:AwAFCA4ABAoAAA==.',Sm='Smike:AwAFCA0ABAoAAA==.',Sp='Spacetotems:AwADCAYABAoAAA==.Spicymeat:AwAECAMABAoAAQoAO2sICBYABAo=.Sputty:AwADCAMABAoAAA==.',Sq='Squishface:AwACCAIABAoAAA==.',St='Stesha:AwAECAoABAoAAA==.',Su='Supreme:AwAECAQABAoAAA==.',Sw='Swaggles:AwADCAYABAoAAA==.',Ta='Tacitus:AwADCAMABAoAAA==.Tatshi:AwACCAIABAoAAA==.Tauntsinpvp:AwABCAEABAoAAA==.',Th='Thecapt:AwAHCAkABAoAAA==.',Ti='Tieriadk:AwADCAQABAoAAA==.Tikorito:AwADCAYABAoAAA==.Tinegle:AwACCAIABAoAAA==.',To='Tomdobbs:AwACCAIABAoAAA==.',Ts='Tsuyoimono:AwADCAQABAoAAA==.',['T�']='Täno:AwAICAEABAoAAA==.',Uk='Ukiru:AwAECAkABAoAAA==.',Va='Vaelort:AwACCAIABAoAAA==.',Ve='Velveen:AwAFCA0ABAoAAA==.',Vi='Vilesilencer:AwADCAkABAoAAA==.',Vo='Vori:AwACCAMABAoAAA==.',Vr='Vraak:AwABCAEABAoAAA==.',Wa='Waggus:AwAFCAsABAoAAA==.Warenhari:AwACCAMABAoAAA==.Warhawk:AwAECAYABAoAAA==.Warzak:AwADCAQABAoAAA==.',We='Wesleysnipez:AwAICBUABAoCDQAIAQhtIgA8JEUCBAoADQAIAQhtIgA8JEUCBAoAAA==.',Wi='Wickd:AwACCAIABAoAAQIAAAAFCA0ABAo=.Wield:AwAHCBMABAoAAA==.Wiickett:AwAFCA0ABAoAAA==.Wildebeard:AwAFCAkABAoAAA==.',Xa='Xandaro:AwABCAEABAoAAA==.',Ye='Yellowdragon:AwAHCA8ABAoAAA==.',Yo='Youngstunter:AwAICBQABAoCCgAIAQhxHAA3ASkCBAoACgAIAQhxHAA3ASkCBAoAAA==.',Za='Zarakii:AwAFCAUABAoAAA==.',Ze='Zelaina:AwACCAIABAoAAA==.',Zi='Ziffer:AwACCAIABAoAAA==.',Zu='Zun:AwAICA0ABAoAAA==.',['È']='Èlo:AwAFCA0ABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end