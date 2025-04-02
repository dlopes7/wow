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
 local lookup = {'DeathKnight-Blood','Mage-Frost','DeathKnight-Unholy','Paladin-Holy','Monk-Windwalker','Shaman-Restoration','Hunter-Marksmanship','Hunter-BeastMastery','Druid-Balance','Warrior-Arms','Warrior-Fury','Monk-Mistweaver','Unknown-Unknown','Priest-Holy','Shaman-Enhancement','Evoker-Devastation','DemonHunter-Havoc','Warlock-Affliction','Warlock-Destruction','Monk-Brewmaster','Paladin-Retribution','Priest-Shadow','Priest-Discipline','Mage-Fire','Paladin-Protection','Druid-Restoration','Warlock-Demonology','Mage-Arcane','Shaman-Elemental',}; local provider = {region='US',realm='Ghostlands',name='US',type='weekly',zone=42,date='2025-03-29',data={Ae='Aethylthryth:AwADCAsABAoAAA==.',Af='Aft:AwAFCBUABAoCAQAFAQguFABNi6ABBAoAAQAFAQguFABNi6ABBAoAAA==.',Ak='Akumu:AwAECAgABAoAAA==.',Al='Alcarde:AwAGCBUABAoCAgAGAQjsJAA6uIwBBAoAAgAGAQjsJAA6uIwBBAoAAA==.Alistraza:AwACCAUABRQCAwACAQj3BgAy958ABRQAAwACAQj3BgAy958ABRQAAA==.Alleutian:AwACCAMABAoAAA==.Alpal:AwACCAMABRQCBAAIAQicAgBQiOcCBAoABAAIAQicAgBQiOcCBAoAAA==.',An='Andraszun:AwAGCAsABAoAAA==.Anicon:AwADCAUABAoAAA==.',Ap='Apollonius:AwAFCAIABAoAAA==.Appetiser:AwAHCBYABAoCBQAHAQgJDABO93ECBAoABQAHAQgJDABO93ECBAoAAA==.',Ar='Arshika:AwAFCAEABAoAAA==.',As='Ascendis:AwAICAgABAoAAA==.',At='Atretes:AwAFCAYABAoAAA==.',Au='Audiopanda:AwACCAIABAoAAA==.',Av='Avö:AwAHCAIABAoAAA==.',Ax='Axionar:AwAHCBMABAoAAA==.',Ba='Bahula:AwAECAsABAoAAA==.Bastianos:AwADCAYABAoAAA==.',Be='Belvis:AwABCAIABRQCBgAGAQgpGgBM1vIBBAoABgAGAQgpGgBM1vIBBAoAAA==.',Bi='Bigdumbhuntr:AwACCAIABRQDBwAIAQiKCwBK6SkCBAoABwAHAQiKCwBKnCkCBAoACAAHAQj1PwAxqJUBBAoAAA==.Biggjax:AwAFCAkABAoAAA==.Biozone:AwAECAQABAoAAA==.Birdmanjonez:AwADCAEABAoAAA==.',Bl='Blastbark:AwACCAQABRQCCQAIAQjoCQBS1dsCBAoACQAIAQjoCQBS1dsCBAoAAA==.Bloodcircus:AwABCAEABRQDCgAIAQjCAABgQGUDBAoACgAIAQjCAABgQGUDBAoACwACAQi9UAA/R5MABAoAAA==.Bloodreign:AwABCAEABAoAAA==.Blotto:AwACCAMABRQDBQAIAQhzDABMq2gCBAoABQAHAQhzDABMUWgCBAoADAACAQjGUgAqdXkABAoAAA==.',Bo='Bobertbigg:AwAHCBIABAoAAA==.Bobsaget:AwAECAQABAoAAQ0AAAAHCBIABAo=.Boxiebrown:AwACCAMABRQCCAAIAQg6JwAwRSQCBAoACAAIAQg6JwAwRSQCBAoAAA==.Boxmorliny:AwAHCA8ABAoAAA==.',Br='Brkenclass:AwADCAMABAoAAA==.Brooklyn:AwAECAIABAoAAA==.',Bu='Bubblebish:AwAHCBIABAoAAA==.Buzzlez:AwACCAMABRQCDgAIAQhHDQA+4EgCBAoADgAIAQhHDQA+4EgCBAoAAA==.',Ca='Canaalberona:AwACCAUABAoAAQ0AAAAFCAwABAo=.Carl:AwAECAQABAoAAA==.Carnage:AwAFCAsABAoAAA==.',Ce='Ceo:AwAFCAUABAoAAA==.',Ch='Cheerwine:AwABCAIABAoAAA==.Cheeto:AwAECAQABAoAAQ0AAAAHCBMABAo=.Cheetostains:AwAICAIABAoAAA==.Cheezits:AwAHCBMABAoAAA==.',Cl='Clerity:AwABCAEABAoAAA==.',Co='Cougsham:AwACCAUABRQCDwACAQhZBgA42q8ABRQADwACAQhZBgA42q8ABRQAAA==.',Cr='Crunching:AwACCAMABRQCEAAIAQj9DQA9ESYCBAoAEAAIAQj9DQA9ESYCBAoAAA==.',Cu='Cutefeet:AwAHCBMABAoAAA==.',Da='Damageplan:AwAECAoABAoAAA==.Danìel:AwACCAMABRQCEQAIAQi6EgBC1JICBAoAEQAIAQi6EgBC1JICBAoAAA==.Darkanggell:AwAICAgABAoAAA==.Darkdaddy:AwADCAYABAoAAA==.',De='Deleted:AwAHCBEABAoAAQUASyYHCBYABAo=.Dendalaus:AwACCAMABRQAAA==.Dertkalock:AwABCAIABAoAAA==.',Do='Dotyoudead:AwAHCAgABAoAAA==.',Dr='Dramonk:AwACCAQABRQDBQAIAQgyCABMgLsCBAoABQAIAQgyCABMgLsCBAoADAABAQjQYQAZWz0ABAoAAA==.Drayco:AwACCAIABAoAAA==.',Dw='Dwaynà:AwACCAIABAoAAA==.',Dy='Dyre:AwAHCBMABAoAAA==.',Ex='Exstatic:AwACCAIABAoAAA==.',Fa='Fabléd:AwACCAMABRQDEgAIAQhCBQBTnOwBBAoAEgAHAQhCBQBU/OwBBAoAEwAFAQi6IQBXRNwBBAoAAA==.Fablêd:AwABCAEABRQAARIAU5wCCAMABRQ=.Fatë:AwACCAEABAoAAA==.',Fi='Finiith:AwACCAMABRQCFAAIAQhmAQBY1gYDBAoAFAAIAQhmAQBY1gYDBAoAAA==.Fitzooth:AwABCAQABAoAAA==.',Fl='Flarecorona:AwAECAgABAoAAQ0AAAAFCAwABAo=.',Fo='Foneer:AwAFCAgABAoAAA==.Forestsky:AwADCAYABAoAAA==.',Fr='Frenchieboi:AwACCAIABAoAAA==.',Ga='Garroshjr:AwAECAMABAoAAA==.',Gh='Ghosimoon:AwAFCAsABAoAAA==.',Gn='Gnollzy:AwAHCBMABAoAAA==.',Gr='Gremory:AwADCAsABAoAAA==.',He='Heafk:AwACCAIABAoAAA==.Hedgehog:AwAHCAIABAoAAA==.',Ho='Hokuo:AwABCAEABRQAAA==.Holybuttkick:AwABCAMABRQCFQAIAQi1CwBc6hMDBAoAFQAIAQi1CwBc6hMDBAoAAA==.Holynova:AwAFCAgABAoAAA==.Honsoulo:AwAICBsABAoCFgAIAQioCABMo7YCBAoAFgAIAQioCABMo7YCBAoAAA==.Horordk:AwAFCAwABAoAAA==.',['H�']='Hönk:AwAECAYABAoAAA==.',Ig='Igniting:AwAICAgABAoAAA==.',Im='Impressions:AwACCAMABRQDFwAIAQjYAABgymMDBAoAFwAIAQjYAABgymMDBAoAFgAEAQg9HwBSV2UBBAoAAA==.',Io='Ioboma:AwACCAQABRQCGAAIAQiYDgBNP7gCBAoAGAAIAQiYDgBNP7gCBAoAAA==.',Ir='Ironwolf:AwAHCAIABAoAAA==.',It='Itache:AwACCAIABAoAAA==.',Ja='Jabba:AwAGCAoABAoAAA==.Jaden:AwAFCAMABAoAAA==.Jamirus:AwACCAIABAoAAA==.',Je='Jerrad:AwADCAUABAoAAA==.',Jo='Joftokal:AwAFCAcABAoAAA==.Jonnibravo:AwABCAEABAoAAA==.Joranji:AwACCAIABAoAAA==.',Ka='Kakiso:AwAECAkABAoAAA==.Kargothica:AwADCAIABAoAAA==.Kattle:AwAGCBUABAoCDwAGAQisGwAv85oBBAoADwAGAQisGwAv85oBBAoAAA==.',Ki='Kikuu:AwAGCBYABAoCGQAGAQjcFQAus0EBBAoAGQAGAQjcFQAus0EBBAoAAA==.',Kn='Knoks:AwAHCAIABAoAAA==.Knuckleup:AwAECAkABAoAAA==.',Kr='Kregann:AwAGCA0ABAoAAA==.',Ku='Kuni:AwADCAYABAoAAA==.',Le='Leithia:AwAFCA8ABAoAAA==.',Li='Lilvoids:AwAGCAEABAoAAA==.Lilwang:AwADCAEABAoAAA==.',Lo='Loriella:AwACCAMABRQCGgAIAQiVBABRu90CBAoAGgAIAQiVBABRu90CBAoAAA==.',Ma='Maalk:AwAFCAEABAoAAA==.Makanii:AwAECAgABAoAAA==.Maylet:AwADCAMABAoAAA==.Maylèt:AwAICAkABAoAAA==.',Mi='Milk:AwAHCBUABAoCCQAHAQiPEABXxIICBAoACQAHAQiPEABXxIICBAoAAA==.',Mo='Mormel:AwADCAYABAoAAA==.',['M�']='Møø:AwAFCAoABAoAAA==.',Ne='Nebyula:AwAFCAMABAoAAA==.Neccrom:AwABCAIABRQAAA==.',No='Noskillidan:AwABCAIABRQCEQAIAQivEwBD2ogCBAoAEQAIAQivEwBD2ogCBAoAAA==.',Od='Odinn:AwABCAEABAoAAA==.',Og='Ogmonk:AwAHCAQABAoAAA==.',Os='Osò:AwADCAYABAoAAA==.',Ou='Oukom:AwACCAMABRQCDwAIAQjuCQBHzagCBAoADwAIAQjuCQBHzagCBAoAAA==.',Ov='Overpressure:AwAGCBQABAoDAgAGAQh1DwBZ61MCBAoAAgAGAQh1DwBZ61MCBAoAGAADAQhCXgAb6X0ABAoAAA==.',Ow='Owocutedk:AwACCAQABRQCAQAIAQiBAQBgeVkDBAoAAQAIAQiBAQBgeVkDBAoAAA==.',Oz='Ozyy:AwABCAEABAoAAA==.',Pa='Paean:AwACCAIABAoAAA==.Panish:AwABCAEABAoAAQUASyYHCBYABAo=.Panthrax:AwAHCBYABAoCBQAHAQhVDQBLJloCBAoABQAHAQhVDQBLJloCBAoAAA==.',Pi='Pibbs:AwACCAIABRQDGAAIAQglFABJBHwCBAoAGAAIAQglFABFpnwCBAoAAgAHAQhyHABFh9IBBAoAAA==.',Po='Poisons:AwAECAMABAoAAA==.',Py='Pyrophobiac:AwADCAMABAoAARsAXrkCCAMABRQ=.',Qw='Qwayne:AwABCAEABAoAAA==.',Ra='Rafig:AwACCAMABRQDGAAIAQgLEwBTrIgCBAoAGAAIAQgLEwBLYogCBAoAHAAGAQjHAgBXB9UBBAoAAA==.Ramses:AwACCAMABRQCHQAIAQjfDgA/5EUCBAoAHQAIAQjfDgA/5EUCBAoAAA==.',Re='Retdaddy:AwAGCAoABAoAAA==.Rettic:AwAGCAEABAoAAA==.Rexx:AwAHCA0ABAoAAA==.',Rh='Rhazzah:AwABCAEABAoAAA==.Rhoc:AwADCAUABAoAAA==.',Ri='Riskyshammy:AwAHCA8ABAoAAA==.',Ro='Robe:AwABCAEABAoAAQ0AAAAFCAwABAo=.Ronok:AwADCAUABAoAAA==.Rorthach:AwABCAIABAoAAA==.Rosethebrute:AwAGCA4ABAoAAA==.Rosetheholy:AwADCAMABAoAAQ0AAAAGCA4ABAo=.',Ru='Ruskro:AwADCAkABAoAAA==.Rusticele:AwADCAUABAoAAQ0AAAAECAYABAo=.',Sa='Saavi:AwAFCAkABAoAAA==.Sabeck:AwAECAQABAoAAA==.Sand:AwAGCA0ABAoAAA==.Satansoul:AwAECAsABAoAAQ0AAAAFCAwABAo=.',Se='Seina:AwADCAYABAoAAA==.Sep:AwABCAEABAoAAA==.',Sh='Shupasins:AwAHCBIABAoAAA==.',Si='Simpleyfire:AwAECAYABAoAAA==.',Sk='Skullanbonez:AwAECAgABAoAAA==.',Sp='Sparlyy:AwACCAMABRQDFgAIAQjoAgBa+DIDBAoAFgAIAQjoAgBa+DIDBAoAFwABAQisRwBQ0V8ABAoAAA==.',Ss='Sswordy:AwACCAMABRQCCAAIAQhkHwA/ilwCBAoACAAIAQhkHwA/ilwCBAoAAA==.',St='Stormcloak:AwADCAcABAoAAA==.',Su='Sueme:AwABCAEABAoAAA==.',Ta='Takis:AwAECAgABAoAAA==.',Te='Terrastormx:AwAFCAgABAoAAA==.Tessia:AwAHCAwABAoAAA==.',Th='Thundergunt:AwABCAEABAoAAQ0AAAAHCBIABAo=.',Ti='Tingletong:AwABCAEABAoAAQ0AAAAHCBMABAo=.Tintaglia:AwADCAsABAoAAA==.',To='Touchofdebt:AwAECAcABAoAAA==.',Va='Vavfurion:AwAHCA0ABAoAAA==.',Vi='Vinsama:AwABCAIABAoAAA==.',Vo='Voidpriest:AwACCAMABAoAAA==.Volkov:AwAFCAQABAoAAA==.Vonmack:AwADCAQABAoAAA==.',Wh='Whoopyy:AwAECAsABAoAAA==.Whyamialive:AwACCAMABRQCAQAIAQjGAQBgI1ADBAoAAQAIAQjGAQBgI1ADBAoAAA==.Whyrun:AwAHCAoABAoAAA==.',Wi='Willowest:AwABCAEABAoAAA==.Willowish:AwAHCBEABAoAAA==.Winterz:AwACCAIABAoAAA==.',Xc='Xcat:AwABCAIABRQCFQAIAQieGwBRU5kCBAoAFQAIAQieGwBRU5kCBAoAAA==.',Za='Zatrekaz:AwAHCBUABAoCCwAHAQhfFwA3gicCBAoACwAHAQhfFwA3gicCBAoAAA==.',Ze='Zellorine:AwAHCAIABAoAAA==.',Zo='Zompt:AwABCAIABAoAAA==.',Zu='Zuess:AwAECAQABAoAAQ0AAAAHCAoABAo=.',Zy='Zyasa:AwADCAgABAoAAA==.Zymar:AwADCAUABAoAAA==.',['Â']='Âstaroth:AwAGCBIABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end