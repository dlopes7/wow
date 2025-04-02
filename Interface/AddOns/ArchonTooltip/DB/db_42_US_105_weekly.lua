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
 local lookup = {'Paladin-Retribution','Unknown-Unknown','Warrior-Fury','Shaman-Restoration','Monk-Brewmaster','Shaman-Elemental','DeathKnight-Unholy','Warlock-Destruction','Mage-Frost','Mage-Fire','Druid-Balance','Warlock-Demonology','Druid-Feral','Druid-Restoration','Hunter-Survival','Hunter-Marksmanship','Hunter-BeastMastery',}; local provider = {region='US',realm='Garrosh',name='US',type='weekly',zone=42,date='2025-03-29',data={Aa='Aadolin:AwAECAoABAoAAA==.',Ab='Abaddon:AwAICAgABAoAAA==.Abeblinkin:AwACCAgABAoAAA==.',Ai='Airbórne:AwACCAIABAoAAA==.',Al='Alisi:AwACCAIABAoAAA==.Alorisa:AwACCAIABAoAAA==.Alyana:AwAICAUABAoAAA==.',Ap='Apollogies:AwACCAUABRQCAQACAQhlCwBGTrYABRQAAQACAQhlCwBGTrYABRQAAA==.',As='Ascalypotato:AwAECAcABAoAAA==.Astrea:AwAGCA4ABAoAAA==.',Av='Avarya:AwAGCAcABAoAAA==.',Ba='Basixx:AwADCAMABAoAAA==.',Be='Beastrogue:AwACCAMABAoAAA==.',Bi='Bigwil:AwAICBAABAoAAA==.Biyanshi:AwAGCAcABAoAAA==.',Bl='Bladeshart:AwADCAMABAoAAA==.Blitzø:AwACCAMABAoAAA==.',Bo='Bobskizzle:AwADCAUABAoAAA==.Bowlinder:AwAGCAsABAoAAA==.',Br='Braldar:AwACCAMABAoAAA==.Brilin:AwADCAUABAoAAA==.Brucarus:AwAICAgABAoAAA==.Brucechi:AwABCAEABAoAAA==.',Bu='Buymyftpics:AwAGCAQABAoAAA==.',Ca='Calabag:AwAGCAYABAoAAQIAAAAGCA4ABAo=.Calarogue:AwAGCA4ABAoAAA==.Calzone:AwAECAQABAoAAA==.',Ch='Chainsoul:AwAECAoABAoAAA==.Chancec:AwABCAIABAoAAA==.Chanvoker:AwAICAkABAoAAA==.',Ci='Cindyr:AwACCAIABAoAAA==.',Co='Coranna:AwAHCA0ABAoAAA==.Corvos:AwACCAIABAoAAQIAAAAECAkABAo=.',Da='Darkroge:AwAHCAgABAoAAA==.',De='Demonrack:AwAECAgABAoAAA==.Demontoki:AwAICAgABAoAAA==.Denarious:AwAECAQABAoAAA==.',Di='Digbar:AwAFCAUABAoAAA==.Diimir:AwAECAcABAoAAA==.Dinda:AwAFCAsABAoAAA==.Dingz:AwABCAEABAoAAA==.',Dj='Djont:AwADCAEABAoAAA==.',Dk='Dkayy:AwAICAMABAoAAA==.',Dr='Drakarx:AwAGCAkABAoAAA==.',Du='Dullerdog:AwABCAIABRQCAQAIAQi9HQBGaIsCBAoAAQAIAQi9HQBGaIsCBAoAAA==.',['D�']='Dúbletap:AwAGCAcABAoAAA==.',Ea='Eartherntac:AwADCAMABAoAAA==.',El='Elagold:AwADCAUABRQCAwADAQj3BgASaN8ABRQAAwADAQj3BgASaN8ABRQAAA==.',Er='Eriselly:AwACCAIABAoAAA==.',Fa='Fathlia:AwAICAEABAoAAA==.',Fe='Felflames:AwAECAQABAoAAQIAAAAGCAwABAo=.Fezzjin:AwADCAsABAoAAA==.',Fi='Fireguard:AwACCAMABAoAAA==.Fistor:AwAGCAcABAoAAA==.',Fl='Fleric:AwAICAgABAoAAA==.',Fo='Forcedk:AwAFCAEABAoAAA==.Forcefaith:AwACCAMABRQCAQAIAQj5DQBW2wADBAoAAQAIAQj5DQBW2wADBAoAAA==.',Fr='Fronkness:AwACCAMABAoAAA==.',['F�']='Fäyelinn:AwADCAYABAoAAA==.',Ga='Galazar:AwAFCA8ABAoAAA==.Gamea:AwACCAIABAoAAA==.',Gi='Gizzinuz:AwABCAEABAoAAQQASj4GCBoABAo=.',Go='Golken:AwAGCA8ABAoAAA==.Goots:AwAECAQABAoAAQIAAAABCAEABRQ=.',Gr='Grifflez:AwADCAoABAoAAA==.',Ha='Halvanhelev:AwADCAQABAoAAA==.',He='Hellrisíng:AwADCAUABAoAAA==.',Ho='Holyholdy:AwAECAIABAoAAA==.Holypuuss:AwAECAMABAoAAA==.Holystepdad:AwABCAEABAoAAA==.Hornblende:AwAECAYABAoAAA==.',Ht='Htial:AwADCAkABAoAAA==.',Il='Iliïdãn:AwADCAEABAoAAA==.Ilous:AwADCAYABAoAAA==.Ilyamurometz:AwAGCBEABAoAAA==.',Im='Ime:AwABCAEABAoAAQIAAAAHCAcABAo=.Imyourdaddy:AwAICAgABAoAAA==.',Ja='Jandda:AwAGCA4ABAoAAA==.Jayri:AwAICAwABAoAAA==.',Jh='Jholdey:AwADCAYABAoAAA==.',Ji='Jinxme:AwACCAIABAoAAA==.',Jo='Johnmadden:AwADCAMABAoAAA==.',Jr='Jrocmfka:AwADCAUABAoAAA==.',Ju='Jurahanis:AwAECAQABAoAAA==.',Ka='Kaotiknuckle:AwAHCBQABAoCBQAHAQgBBQBFgBsCBAoABQAHAQgBBQBFgBsCBAoAAA==.Kattara:AwAECAoABAoAAA==.',Ki='Kiltree:AwAECAYABAoAAQIAAAAGCBMABAo=.Kiyoshie:AwAGCBMABAoAAA==.',Kn='Knox:AwADCAMABAoAAQIAAAAHCAcABAo=.',Ko='Kobl:AwAFCAkABAoAAA==.',Kr='Krieghelm:AwAHCBwABAoCAQAHAQiWEABfEukCBAoAAQAHAQiWEABfEukCBAoAAA==.',Ku='Kuzona:AwABCAEABAoAAQIAAAAHCBEABAo=.',Ky='Kyle:AwAFCAMABAoAAA==.',La='Lazzirus:AwAGCBQABAoCBgAGAQhfHgAx5oABBAoABgAGAQhfHgAx5oABBAoAAA==.',Le='Lebowskì:AwAGCA8ABAoAAA==.',Lo='Lorily:AwAGCBoABAoCBAAGAQiRIQBKPrsBBAoABAAGAQiRIQBKPrsBBAoAAA==.',Lu='Lucishifts:AwAHCAEABAoAAA==.',Ma='Magematics:AwAHCBIABAoAAA==.Marcuru:AwAECAEABAoAAA==.Margdan:AwACCAIABAoAAA==.Masonshyphy:AwAGCAEABAoAAA==.',Mo='Mochii:AwAFCAcABAoAAA==.Mojiin:AwABCAEABAoAAA==.Monomis:AwAFCAoABAoAAA==.Moonem:AwADCAIABAoAAA==.',Na='Naturalflame:AwAECAQABAoAAQIAAAAGCAwABAo=.',Ne='Necrotictofu:AwABCAIABRQCBwAIAQgDBQBZDRcDBAoABwAIAQgDBQBZDRcDBAoAAA==.Nerclopse:AwABCAEABRQCBgAGAQgWKAAZqiYBBAoABgAGAQgWKAAZqiYBBAoAAA==.Neverænder:AwACCAMABAoAAA==.',Ni='Nightiee:AwAICBAABAoAAA==.',No='Noritotem:AwADCAUABAoAAA==.',Nu='Nutnbolt:AwADCAMABAoAAQgASrwHCBwABAo=.',Oc='Octoberbenz:AwADCAQABRQCCQAIAQhUBABaIgwDBAoACQAIAQhUBABaIgwDBAoAAA==.',Ol='Oldboatshoe:AwADCAMABAoAAA==.Oliverckamzn:AwABCAEABAoAAA==.',Ow='Owl:AwAGCAEABAoAAA==.',Pa='Papahammer:AwACCAIABAoAAA==.Pasqal:AwAGCAcABAoAAA==.Pattycake:AwACCAIABAoAAA==.Pattycakers:AwAECAQABAoAAA==.',Pu='Pureza:AwABCAEABAoAAA==.',Qt='Qtx:AwAHCAcABAoAAA==.',Re='Reno:AwACCAIABAoAAA==.Renthyr:AwAGCAsABAoAAA==.Reportcard:AwABCAEABRQCCAAIAQjzJAAh2sIBBAoACAAIAQjzJAAh2sIBBAoAAA==.Retrospekt:AwACCAIABAoAAA==.',Ri='Ritalia:AwAFCAwABAoAAA==.',Ro='Rolisea:AwACCAIABAoAAQQASj4GCBoABAo=.Roobern:AwAECAYABAoAAA==.',Ru='Rune:AwAHCAcABAoAAA==.',Sa='Sandrinea:AwADCAYABAoAAA==.Sarcasm:AwAGCAYABAoAAA==.Sardenaris:AwAECAYABAoAAA==.Sarusx:AwACCAIABAoAAA==.Satella:AwABCAEABAoAAA==.Satephwar:AwACCAQABAoAAA==.',Sc='Scryix:AwAICBMABAoAAQoAL9cECAkABRQ=.',Se='Seo:AwABCAEABAoAAA==.',Sh='Shelon:AwAGCA4ABAoAAA==.Shibal:AwAFCA4ABAoAAA==.Shrednbones:AwAICAgABAoAAA==.',Si='Sill:AwAGCA8ABAoAAA==.Silvercore:AwAICAMABAoAAA==.Silverstarz:AwAGCAcABAoAAQsASsgDCAYABRQ=.',Sl='Slimeyy:AwABCAEABRQAAA==.Slimshadee:AwAGCAYABAoAAA==.',Sn='Sneakhaotik:AwAFCAEABAoAAA==.',So='Sophus:AwAECAoABAoAAA==.',Sp='Spagooter:AwAHCBwABAoDCAAHAQjyEgBKvFcCBAoACAAHAQjyEgBKvFcCBAoADAAEAQj+JAAwCLwABAoAAA==.',St='Sta:AwADCAcABAoAAA==.Stonemason:AwACCAMABAoAAA==.',Su='Sunthôr:AwADCAIABAoAAA==.',Sw='Swampcicle:AwAFCAcABAoAAA==.',Ta='Tac:AwAGCAcABAoAAA==.',Te='Tenntoes:AwAFCAEABAoAAA==.',Th='Thebgboss:AwACCAMABAoAAA==.Thesickness:AwACCAUABAoAAA==.',Ti='Tinyrage:AwACCAMABAoAAA==.',To='Tobiko:AwAICAEABAoAAA==.Tokitotem:AwAHCAQABAoAAA==.Toldyousoul:AwAFCAkABAoAAA==.Tommyd:AwADCAcABAoAAA==.Tonzlock:AwAICBcABAoCCAAIAQiiRwAOFPQABAoACAAIAQiiRwAOFPQABAoAAA==.',Tr='Trancformer:AwAICBgABAoDDQAIAQj8BwAnv+ABBAoADQAHAQj8BwAr3eABBAoADgADAQipSQAKdmYABAoAAA==.Treebeard:AwADCAQABAoAAA==.Treebirth:AwAFCAwABAoAAA==.',Ur='Uroldpalygos:AwADCAcABAoAAA==.',Va='Vanadora:AwAHCBUABAoEDwAHAQhdBABQfbYBBAoADwAGAQhdBABS1LYBBAoAEAAFAQhWGwA9mk0BBAoAEQADAQiVcwBIuNMABAoAAA==.Vandredor:AwAGCAcABAoAAA==.',Vi='Viølence:AwADCAsABAoAAA==.',Wh='Whippoorwill:AwAGCBQABAoCDQAGAQiXCQA01KsBBAoADQAGAQiXCQA01KsBBAoAAA==.',Wi='Willmoon:AwAFCAwABAoAAQIAAAAHCAcABAo=.',Wr='Wrathfil:AwAHCBMABAoAAA==.',Xe='Xene:AwAECAoABAoAAA==.',Ya='Yallah:AwACCAQABAoAAA==.',Za='Zancina:AwABCAEABAoAAA==.',Zy='Zywie:AwADCAIABAoAAQIAAAAFCAwABAo=.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end