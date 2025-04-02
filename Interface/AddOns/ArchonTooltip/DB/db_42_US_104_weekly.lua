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
 local lookup = {'Monk-Windwalker','Hunter-Marksmanship','Hunter-BeastMastery','Paladin-Protection','Warrior-Fury','Warrior-Protection','Unknown-Unknown','Druid-Balance','Warlock-Affliction','Warlock-Destruction','Warlock-Demonology','Druid-Feral','Druid-Restoration','Warrior-Arms','Paladin-Retribution','Mage-Fire','Shaman-Elemental','DemonHunter-Havoc','DemonHunter-Vengeance','DeathKnight-Frost',}; local provider = {region='US',realm='Garona',name='US',type='weekly',zone=42,date='2025-03-29',data={Ai='Airz:AwADCAMABAoAAA==.',Ak='Akâkiôs:AwADCAMABAoAAA==.Akäne:AwADCAMABAoAAA==.',Al='Aladorman:AwADCAMABAoAAA==.',Am='Amakuagsak:AwADCAYABAoAAA==.',An='Angelcastiel:AwAHCBAABAoAAA==.Aniravia:AwABCAIABRQCAQAHAQjvCgBSOoYCBAoAAQAHAQjvCgBSOoYCBAoAAA==.Anthren:AwAECAQABAoAAA==.',Ar='Arasthel:AwAFCAgABAoAAA==.Aryasilly:AwADCAMABAoAAA==.',As='Ashe:AwADCAUABRQCAgADAQj1AQA4pfQABRQAAgADAQj1AQA4pfQABRQAAA==.',At='Atownbrew:AwABCAEABAoAAA==.Attaraxia:AwABCAIABRQCAwAIAQhKCABYZCUDBAoAAwAIAQhKCABYZCUDBAoAAA==.',Ba='Baddington:AwADCAMABAoAAA==.Baphomett:AwAGCBIABAoAAA==.Bartolomew:AwAGCA8ABAoAAA==.',Be='Beepers:AwAHCBAABAoAAA==.Bestmonk:AwACCAIABAoAAA==.',Bi='Bibz:AwAICBAABAoAAA==.Bigdemon:AwAICBAABAoAAA==.Birchtix:AwADCAQABAoAAA==.',Br='Breeder:AwABCAEABAoAAA==.Brightxan:AwAGCBYABAoCBAAGAQhjDwA6ZaEBBAoABAAGAQhjDwA6ZaEBBAoAAA==.',Bu='Burninator:AwAECAEABAoAAA==.Bus:AwAICCEABAoDBQAIAQhFBABctSgDBAoABQAIAQhFBABctSgDBAoABgABAQgJKQAlTyEABAoAAQcAAAABCAEABRQ=.Buse:AwADCAMABAoAAA==.Bussdefense:AwADCAYABAoAAA==.Butterrs:AwAICBkABAoCCAAIAQivEQBFLHQCBAoACAAIAQivEQBFLHQCBAoAAA==.',Ca='Caelan:AwACCAIABAoAAA==.Casmilla:AwADCAYABAoAAA==.',Ce='Celadorn:AwABCAEABAoAAA==.',Ch='Chapszz:AwAGCAsABAoAAA==.',Cl='Cleaveland:AwAECAcABAoAAA==.',Co='Codizzle:AwAHCAsABAoAAA==.Corneater:AwAHCAQABAoAAA==.Cortc:AwAGCAMABAoAAA==.',Da='Daevas:AwAGCAIABAoAAA==.',De='Deku:AwAGCAQABAoAAA==.Dendrada:AwAECAYABAoAAA==.',Do='Doobeey:AwAFCAQABAoAAA==.Doobeyglaive:AwADCAMABAoAAA==.Dotisa:AwADCAYABAoAAA==.',Dr='Dragonite:AwAGCAkABAoAAA==.',Du='Dumpliius:AwADCAYABAoAAA==.',Ed='Edisonn:AwABCAEABRQECQAIAQiGBABOaQcCBAoACQAGAQiGBABLwAcCBAoACgAGAQizLgA39n8BBAoACwAFAQijDgBQ43oBBAoAAA==.',El='Elghinn:AwAGCAIABAoAAA==.',En='Enderra:AwAICA8ABAoAAA==.',Ev='Evoke:AwABCAEABAoAAA==.',Ex='Excidium:AwAFCAoABAoAAA==.',Fa='Faeria:AwADCAMABAoAAA==.Falkopal:AwAECAsABRQCBAAEAQiAAABTTIoBBRQABAAEAQiAAABTTIoBBRQAAA==.Fashoitis:AwAECAIABAoAAA==.Fatswag:AwAFCAYABAoAAA==.',Fe='Fender:AwACCAQABAoAAA==.',Fi='Fishier:AwAGCAoABAoAAA==.',Fl='Flory:AwAGCAUABAoAAA==.',Fu='Fuzzycheese:AwAECAwABAoAAA==.',['F�']='Fìsher:AwAFCAUABAoAAQcAAAAGCAoABAo=.',Ga='Gacke:AwAGCAIABAoAAA==.Galathil:AwAECAcABAoAAA==.',Gd='Gdiddy:AwABCAEABAoAAA==.Gdlez:AwADCAUABAoAAA==.',Ge='Gengara:AwABCAEABAoAAQcAAAAFCA4ABAo=.Geofflolz:AwAECAUABAoAAA==.',Gh='Gholdnor:AwAICBMABAoAAA==.',Go='Golorious:AwAHCBAABAoAAA==.',Gr='Grishnakh:AwAFCAsABAoAAA==.',Gu='Guttershark:AwAGCA4ABAoAAA==.',Ha='Haoasakura:AwAGCA4ABAoAAA==.',He='Heap:AwAHCBUABAoEDAAHAQibBwA6lu0BBAoADAAGAQibBwA7r+0BBAoACAADAQg6VQAiP5MABAoADQACAQi4WQAEKy0ABAoAAA==.Hewnoshaqa:AwAFCA0ABAoAAA==.',Hi='Hitormist:AwAFCAIABAoAAQcAAAAGCAIABAo=.',Ic='Icoulddowork:AwAGCA8ABAoAAA==.',Ik='Ikazuchi:AwAFCAwABAoAAA==.',Im='Imagirl:AwADCAMABAoAAQcAAAAGCAMABAo=.Imreadytodie:AwADCAYABAoAAA==.',Io='Iock:AwAICAgABAoAAA==.',Ir='Ironarms:AwAHCBEABAoAAA==.',It='Itskae:AwADCAkABAoAAA==.Itssolyce:AwADCAgABAoAAA==.',Ja='Jardarkbinks:AwADCAIABAoAAA==.',Jj='Jjennypoo:AwAECAYABAoAAA==.',Jo='Johnwarrior:AwAGCA0ABAoAAA==.',Jr='Jrobocop:AwAFCBEABAoAAA==.',Ju='Juduspriestt:AwAECAMABAoAAA==.Jurt:AwAECAQABAoAAA==.Justjake:AwACCAIABAoAAA==.',Ka='Kalerito:AwAFCAUABAoAAA==.Kamaria:AwAECAcABAoAAA==.Kayblood:AwAHCBAABAoAAA==.Kazaf:AwADCAIABAoAAA==.Kazrik:AwABCAEABAoAAA==.',Ke='Keitrek:AwAGCAIABAoAAA==.Kenichï:AwAFCAEABAoAAA==.',Kh='Khallan:AwADCAYABAoAAA==.',Ki='Killbent:AwABCAIABAoAAA==.Kivdruid:AwAGCAIABAoAAA==.',Kr='Kreettip:AwAFCAIABAoAAA==.Kror:AwAHCBUABAoCDgAHAQhPDwA1qPkBBAoADgAHAQhPDwA1qPkBBAoAAA==.',Ku='Kugamoo:AwAHCBAABAoAAA==.',Ky='Kyng:AwADCAMABAoAAA==.Kyntarra:AwAICAoABAoAAA==.',La='Lagshot:AwABCAEABRQDAgAHAQiJCgBRezsCBAoAAwAHAQhKHgBOz2UCBAoAAgAHAQiJCgBFxTsCBAoAAA==.Langet:AwAGCAIABAoAAA==.',Li='Lilobear:AwAECAIABAoAAA==.',Ll='Llinth:AwADCAQABAoAAQcAAAAGCAsABAo=.',Lo='Lovi:AwAICBAABAoAAA==.',Lu='Lumos:AwAHCA8ABAoAAA==.Lusciifi:AwABCAMABRQCDwAIAQjiBABd61YDBAoADwAIAQjiBABd61YDBAoAAA==.',Ly='Lycanroc:AwAFCAUABAoAAA==.Lykith:AwAHCBEABAoAAA==.',Ma='Mafic:AwAHCAUABAoAAA==.Magaggie:AwAFCAEABAoAAA==.Mageyoulookk:AwACCAIABAoAAA==.Manywagons:AwAHCBEABAoAARAAW6gFCA0ABRQ=.Masacre:AwAECAgABAoAAA==.Mavaman:AwAHCBQABAoCEQAHAQiBDABP9moCBAoAEQAHAQiBDABP9moCBAoAAA==.',Me='Meatballer:AwACCAIABAoAAA==.',Mi='Mihawk:AwAFCAYABAoAAA==.Mithras:AwAICA8ABAoCDQAIAQhAQwAD2IIABAoADQAIAQhAQwAD2IIABAoAAA==.',Mo='Moonq:AwAECAcABAoAAA==.Moorti:AwADCAIABAoAAA==.Moosaurus:AwAFCAIABAoAAA==.Moremage:AwABCAEABAoAAQcAAAACCAIABAo=.',Mu='Muffy:AwAECAYABAoAAA==.',My='Myoko:AwAFCAwABAoAAA==.',['M�']='Mônster:AwAECAEABAoAAA==.',Na='Nadíne:AwACCAIABAoAAA==.',Ne='Nene:AwACCAIABAoAAA==.',Ni='Nikle:AwAICAgABAoAAA==.Nikor:AwADCAcABAoAAA==.',['N�']='Nèlo:AwADCAYABAoAAA==.',Oc='Oceansgrave:AwADCAMABAoAAA==.',Or='Origin:AwADCAUABAoAAA==.Orlytheowl:AwADCAYABAoAAA==.',Os='Ossuly:AwAICAgABAoAAA==.Osywar:AwAGCAEABAoAAA==.',Ov='Overture:AwAECAkABAoAAA==.',Pa='Palaslap:AwACCAEABAoAAA==.Parkadion:AwAHCBIABAoAAA==.Parkour:AwAECAIABAoAAQcAAAAHCBIABAo=.Paullyfists:AwAGCAcABAoAAA==.Payal:AwABCAEABAoAAQkATmkBCAEABRQ=.',Ph='Phantazma:AwACCAIABAoAAA==.',Pi='Pintobeans:AwAFCA4ABAoAAA==.',Po='Popkorn:AwADCAUABRQDEgADAQgqCQBaZsYABRQAEgACAQgqCQBWjcYABRQAEwABAQg9BQBiGHMABRQAAA==.',Ps='Psysolf:AwADCAEABAoAAA==.',Qu='Quasient:AwADCAMABAoAAA==.Quickspell:AwAFCA4ABAoAAA==.',Ra='Raedyyn:AwADCAUABAoAAA==.Ragequits:AwAICBIABAoAAA==.Ratsnart:AwADCAUABAoAAA==.',Re='Renn:AwADCAIABAoAAA==.',Rh='Rholdentodor:AwAFCAsABAoAAA==.',Ri='Rift:AwAFCA0ABAoAAA==.',Ru='Runecast:AwADCAMABAoAAA==.',Ry='Rynk:AwAHCBUABAoCAQAHAQhQFAA7qPABBAoAAQAHAQhQFAA7qPABBAoAAA==.Ryze:AwAFCAIABAoAAA==.',Sa='Sarapheena:AwAHCBAABAoAAA==.Saterli:AwAGCAUABAoAAA==.Sauronknight:AwAFCAsABAoAAA==.',Sc='Scalypanda:AwAHCAsABAoAAA==.Scamander:AwAICAgABAoAAA==.Sculi:AwAICAoABAoAAA==.',Se='Senyor:AwAFCAcABAoAAA==.',Sh='Shacklebolt:AwAHCBQABAoECwAHAQjtCgBCx7IBBAoACwAFAQjtCgBLkbIBBAoACQAFAQh7CwA/ZlEBBAoACgACAQgCcQApQ1cABAoAAQcAAAAICAgABAo=.Shaelistra:AwADCAYABAoAAA==.Shawover:AwAGCAIABAoAAA==.Shiorii:AwAGCA4ABAoAAA==.Shotiin:AwAFCAEABAoAAQcAAAAGCAIABAo=.',Si='Simpo:AwAFCAcABAoAAA==.Sistershadow:AwABCAEABAoAAA==.Siwe:AwAGCAsABAoAAA==.',Sl='Slackback:AwAICAoABAoAAA==.Sloot:AwADCAMABAoAAA==.',So='Sockszz:AwADCAMABAoAAQcAAAAGCAsABAo=.',Sp='Splendaboo:AwAHCBEABAoAAA==.Spoon:AwAECAEABAoAAA==.Sprints:AwAGCBMABAoAAA==.Spwany:AwABCAEABAoAAA==.Spyderelite:AwAFCAwABAoAAA==.',Sq='Squirrel:AwAGCA8ABAoAAA==.',St='Stankstarstu:AwADCAQABAoAAQcAAAAFCAIABAo=.Stupandus:AwAFCAIABAoAAA==.',Su='Supersasian:AwABCAEABRQAAA==.',Ta='Taterdotz:AwAFCAkABAoAAA==.Tatyrra:AwABCAIABAoAAA==.',Th='Thelonecone:AwAHCCEABAoCFAAHAQhuAgBeZ+gCBAoAFAAHAQhuAgBeZ+gCBAoAAA==.',Ti='Tigrex:AwAFCAoABAoAAA==.',To='Toenak:AwAECAYABAoAAA==.',Tr='Treebranch:AwAHCBAABAoAAA==.Trias:AwAICAgABAoAAA==.Trnzqt:AwACCAIABAoAAQcAAAADCAUABAo=.',Tu='Tularana:AwACCAIABAoAAQcAAAAGCAEABAo=.',Tw='Twodogz:AwADCAYABAoAAA==.',Ty='Tyknight:AwAHCBAABAoAAA==.',Ud='Uddershøck:AwACCAQABAoAAA==.',Va='Vashie:AwAGCA4ABAoAAA==.',Ve='Vemo:AwAFCAUABAoAAA==.Verolish:AwAGCA8ABAoAAA==.Vexus:AwAICAUABAoAAA==.Vexuus:AwAICA8ABAoAAA==.',Vo='Vordarian:AwAGCA4ABAoAAA==.Votox:AwACCAMABAoAAA==.',Wh='Whaler:AwAECAcABAoAAA==.Whos:AwAICBAABAoAAA==.',Xe='Xel:AwABCAEABAoAAA==.',Yo='Yoan:AwAGCBEABAoAAA==.',Zb='Zbiblerr:AwACCAIABAoAAA==.',Ze='Zeerkk:AwAGCA8ABAoAAA==.',Zh='Zhuong:AwADCAEABAoAAA==.',['À']='Àrtémis:AwAGCAsABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end