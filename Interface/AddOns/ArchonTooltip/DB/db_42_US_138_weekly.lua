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
 local lookup = {'DeathKnight-Unholy','DeathKnight-Frost','Mage-Frost','Shaman-Restoration','Warlock-Affliction','Priest-Shadow','Hunter-BeastMastery','Hunter-Survival','Druid-Restoration','Druid-Balance','Shaman-Enhancement','Unknown-Unknown','Druid-Feral','Paladin-Retribution','Warrior-Fury','Mage-Fire',}; local provider = {region='US',realm='KulTiras',name='US',type='weekly',zone=42,date='2025-03-29',data={Ab='Abp:AwAECAQABAoAAA==.',Ae='Aevumu:AwADCAMABAoAAA==.',Af='Affonasei:AwAICAwABAoAAA==.',Ak='Akashi:AwABCAIABRQDAQAHAQgpEQBM8lUCBAoAAQAHAQgpEQBM8lUCBAoAAgADAQgoHAAh+nsABAoAAA==.',An='Ansok:AwACCAIABAoAAA==.Antoccino:AwAECAEABAoAAA==.',Ba='Badonka:AwADCAkABAoAAA==.',Bo='Bogwin:AwAGCAEABAoAAA==.',Br='Bronad:AwABCAIABRQCAwAIAQgLAQBhzHEDBAoAAwAIAQgLAQBhzHEDBAoAAA==.',Bu='Burinn:AwADCAkABAoAAA==.',Ca='Carnaubaa:AwAECAEABAoAAA==.',Cl='Clifton:AwAECAYABAoAAA==.',Co='Coraf:AwABCAIABRQCBAAIAQieAwBZxhUDBAoABAAIAQieAwBZxhUDBAoAAA==.',Cr='Cruoris:AwAECAgABAoAAA==.',Da='Darkdaddle:AwAGCA4ABAoAAA==.',De='Demisi:AwAECAEABAoAAA==.Derangedsp:AwAFCAoABAoAAQUASM4ECAoABRQ=.',Dr='Drooidz:AwADCAYABAoAAA==.Dryan:AwAECAEABAoAAA==.',Dy='Dying:AwAECAUABAoAAA==.',Ea='Ear:AwAECAQABAoAAA==.',En='Endressa:AwAECAgABAoAAA==.',Fa='Faddeyshnek:AwAECAQABAoAAA==.Fake:AwAFCAUABAoAAA==.',Fi='Fish:AwAFCAsABAoAAQYAYgEDCAgABRQ=.',Fo='Forsynth:AwAECAcABAoAAA==.',Ge='Getrekt:AwAHCBEABAoAAA==.',Gr='Grapekoolaid:AwABCAEABRQDBwAIAQjdFwBLxJgCBAoABwAIAQjdFwBJ/ZgCBAoACAAEAQjOCABTBvsABAoAAA==.Greavas:AwAECAcABAoAAA==.Grimbaine:AwAECAEABAoAAA==.',Ha='Hartephinar:AwAHCA0ABAoAAA==.',In='Incubus:AwAFCAEABAoAAA==.Injustice:AwAHCAEABAoAAA==.',Jo='Jorden:AwADCAkABAoAAA==.',Ka='Kael:AwAECAEABAoAAA==.Kalyandra:AwAECAcABAoAAA==.Kantee:AwAECAQABAoAAA==.',Ko='Komodo:AwAHCBEABAoAAA==.',Kr='Kraka:AwACCAIABRQDCQAIAQjxDgA9+BICBAoACQAIAQjxDgA9+BICBAoACgADAQikVQAlZpEABAoAAA==.',Ku='Kurston:AwADCAEABAoAAA==.',Mi='Minaby:AwAECAkABAoAAA==.',Mo='Moddoxx:AwAECAEABAoAAA==.Monarch:AwACCAEABAoAAA==.Mongrave:AwAGCAgABAoAAA==.',['NÃ']='NÃªptune:AwABCAEABAoAAA==.',Og='Ogrekin:AwABCAIABRQCCwAIAQjPCABMpbsCBAoACwAIAQjPCABMpbsCBAoAAA==.',Ol='Olrong:AwAECAEABAoAAA==.',Pa='PapichulÃ´:AwAHCBAABAoAAA==.',Pe='Peacekeeper:AwAICAgABAoAAA==.',Re='Reeven:AwAECAEABAoAAA==.',Ri='Rike:AwAECAEABAoAAA==.',Ro='Rolzin:AwAECAEABAoAAA==.',Ry='Rylagosa:AwADCAYABAoAAA==.',Sa='Salandria:AwAECAQABAoAAA==.Sarionian:AwAECAkABAoAAA==.Sauronic:AwABCAEABAoAAQwAAAAECAUABAo=.',Se='Sevsa:AwAECAEABAoAAA==.',Sh='Sharle:AwADCAEABAoAAA==.',Sl='Slayix:AwACCAIABAoAAA==.',Sp='Spazzoid:AwABCAEABRQDDQAIAQjvAwBPWpECBAoADQAHAQjvAwBSm5ECBAoACgABAQjqawA4kjoABAoAAA==.',St='Starrling:AwAGCAwABAoAAA==.Steelshadow:AwAGCBIABAoAAA==.Stickybunz:AwADCAQABAoAAA==.Stonegying:AwADCAcABAoAAA==.',['SÃ']='SÃ¬rfuzywuzy:AwABCAEABAoAAA==.',Ta='Talandroz:AwAECAQABAoAAA==.',Te='Tearful:AwAICAkABAoAAA==.Teas:AwAGCAwABAoAAA==.Teostra:AwAGCBIABAoAAA==.',Th='Thaanee:AwABCAEABAoAAA==.Thanevoker:AwAGCBIABAoAAA==.Theodrid:AwACCAIABRQCDgAIAQipIQBJgnMCBAoADgAIAQipIQBJgnMCBAoAAA==.',Ti='Tigertigress:AwADCAEABAoAAA==.',To='Tosct:AwAFCAoABAoAAA==.',Tr='Tribonian:AwAHCBcABAoCDwAHAQhpEABOC3ECBAoADwAHAQhpEABOC3ECBAoAAA==.',Ty='Tyamat:AwADCAYABAoAAA==.',Va='Vains:AwAFCAkABAoAAA==.',Ve='Verren:AwAECAcABAoAAA==.',We='Weltazar:AwAECAEABAoAAA==.Westside:AwACCAMABRQDEAAIAQghBwBeHhEDBAoAEAAIAQghBwBeCxEDBAoAAwAEAQhZMQBauDcBBAoAAA==.',Wh='Whoosh:AwAECAQABAoAAA==.',Wi='Wintriscumin:AwADCAMABAoAAA==.',Wu='Wulfengrip:AwABCAIABAoAAA==.',Xe='Xeraphos:AwAECAQABAoAAA==.',Xf='Xfadez:AwABCAEABAoAAA==.',Xu='Xulon:AwAECAEABAoAAA==.',Yi='Yiff:AwAGCBAABAoAAA==.',Yu='Yurika:AwAGCA4ABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end