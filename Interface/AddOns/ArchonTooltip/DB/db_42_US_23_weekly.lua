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
 local lookup = {'Hunter-BeastMastery','Hunter-Survival','Druid-Guardian','Rogue-Subtlety','Paladin-Retribution','DeathKnight-Blood','Monk-Mistweaver','Warlock-Affliction','Warrior-Fury','Mage-Arcane','Mage-Fire','Shaman-Restoration','Shaman-Elemental','Hunter-Marksmanship','Warrior-Protection','Unknown-Unknown','Rogue-Outlaw','Monk-Brewmaster','Priest-Holy','Priest-Discipline',}; local provider = {region='US',realm='Azgalor',name='US',type='weekly',zone=42,date='2025-03-29',data={Ab='Abaria:AwADCAIABAoAAA==.',Ad='Addalynn:AwACCAQABAoAAA==.',Ae='Aelín:AwABCAEABRQAAA==.',Af='Aftershocks:AwAECAUABAoAAA==.',Al='Aliakin:AwAFCAYABAoAAA==.',Am='Amarxd:AwADCAQABAoAAA==.',An='Anduin:AwAGCBEABAoAAA==.Anetelle:AwAECAkABAoAAA==.Animal:AwAECAgABAoAAA==.',Ap='Apoth:AwAICA0ABAoAAA==.Apothe:AwAICAgABAoAAA==.',Ar='Artemmis:AwABCAMABRQDAQAIAQiGEgBOjsUCBAoAAQAIAQiGEgBNgsUCBAoAAgAGAQj9BgAqpzkBBAoAAA==.',As='Asimity:AwAGCAcABAoAAA==.',Ba='Baed:AwAECAcABAoAAA==.Bambilivvy:AwAECAUABAoAAA==.',Bl='Bloodymenses:AwAFCAgABAoAAA==.',Bo='Bosihunter:AwAFCAcABAoAAA==.',Bu='Bunniez:AwAHCCQABAoCAwAHAQhgAgBNo1oCBAoAAwAHAQhgAgBNo1oCBAoAAA==.',Ca='Capncrunch:AwAICBAABAoAAA==.Cardattackz:AwAECAYABAoAAA==.',Ch='Charisma:AwAGCBEABAoAAA==.Chomsky:AwAICAIABAoAAA==.Chøppy:AwAGCAYABAoAAA==.',Cl='Clipsi:AwABCAEABAoAAQQAHdADCAUABRQ=.',Co='Couraegus:AwABCAIABRQCBQAHAQgFEQBgB+YCBAoABQAHAQgFEQBgB+YCBAoAAA==.',Cr='Cryhavok:AwAECAQABAoAAA==.',Cu='Cutefox:AwAICAgABAoAAA==.',Da='Darknrahll:AwAFCAYABAoAAA==.Davosi:AwAGCBAABAoAAA==.',De='Deadtalini:AwABCAIABRQCBgAHAQjPCQBPrF0CBAoABgAHAQjPCQBPrF0CBAoAAA==.Deepa:AwACCAEABAoAAA==.Demgraybush:AwAECAgABAoAAA==.Derathen:AwAECAQABAoAAA==.',Di='Dirtyhooves:AwAFCAUABAoAAA==.Diâblö:AwADCAYABRQCBwADAQjwAQBi+F0BBRQABwADAQjwAQBi+F0BBRQAAA==.',Do='Doragan:AwADCAYABAoAAA==.Dosin:AwAICAUABAoAAA==.',Dr='Draenold:AwABCAEABRQCCAAIAQg2BgAji80BBAoACAAIAQg2BgAji80BBAoAAA==.Dralvira:AwAHCBIABAoAAA==.Drugraybush:AwABCAIABAoAAA==.',Eh='Ehayron:AwAGCAEABAoAAA==.',Ei='Eirrin:AwAGCBMABAoAAA==.',El='Eligar:AwAECAQABAoAAA==.Elleredreaux:AwACCAIABAoAAA==.',Fa='Fancyret:AwADCAMABAoAAA==.Fayia:AwAHCBcABAoCAQAHAQi+LQA/TvkBBAoAAQAHAQi+LQA/TvkBBAoAAA==.',Fe='Fearpriest:AwAICAgABAoAAA==.Fearshaman:AwAICBEABAoAAA==.Felbrew:AwAHCBIABAoAAA==.',Fl='Florin:AwACCAEABAoAAA==.',Fr='Frampton:AwADCAMABAoAAA==.',Ga='Gabeowners:AwAFCA4ABAoAAA==.Galaedus:AwADCAQABAoAAA==.Gatorglaive:AwAFCAUABAoAAA==.',Go='Goontoelune:AwAICAIABAoAAA==.',Gr='Grapfee:AwACCAMABAoAAA==.Gravisher:AwAICBEABAoAAA==.Graybushfist:AwABCAIABAoAAA==.Graybushpri:AwAICAgABAoAAA==.Grendar:AwADCAMABAoAAA==.',Ha='Haniesh:AwAGCA4ABAoAAA==.',He='Healingapple:AwAFCAgABAoAAA==.Hexasaur:AwAHCBMABAoAAA==.',Hu='Husser:AwAGCAEABAoAAA==.',Im='Imcooleddown:AwAFCAQABAoAAA==.Imonlun:AwAECAMABAoAAA==.',Is='Isos:AwAHCBIABAoAAA==.',Je='Jedai:AwAICAkABAoAAA==.',Jo='Joel:AwEGCBEABAoAAA==.Jolrael:AwAFCAoABAoAAA==.',Ka='Kalrock:AwADCAcABAoAAA==.Katyperrier:AwAICAgABAoAAA==.',Kh='Khagolith:AwAGCBEABAoAAA==.',Km='Kmini:AwAECAIABAoAAA==.',Ko='Kobito:AwABCAEABRQCCQAHAQhQGABALh0CBAoACQAHAQhQGABALh0CBAoAAA==.Koup:AwAICBgABAoCAQAIAQg+BwBaAzEDBAoAAQAIAQg+BwBaAzEDBAoAAA==.',Ku='Kuroguro:AwACCAIABAoAAA==.',La='Lavs:AwAGCA4ABAoAAA==.',Le='Legololz:AwABCAEABAoAAA==.Lev:AwADCAUABRQCBAADAQgSBQAd0OQABRQABAADAQgSBQAd0OQABRQAAA==.',Lo='Lonníe:AwAFCAEABAoAAA==.Lorilyn:AwAGCA4ABAoAAA==.Louisviton:AwADCAMABAoAAA==.Love:AwAHCBIABAoAAA==.',Lu='Lunarus:AwAECAMABAoAAA==.',Ma='Manbearpig:AwAECAYABAoAAA==.Mandysmores:AwACCAIABAoAAA==.',Mc='Mctigly:AwACCAQABAoAAA==.',Mi='Miniblué:AwAECAgABAoAAA==.',Mo='Mogrogarg:AwAICAsABAoAAA==.Mooglet:AwABCAEABRQDCgAIAQiXAwAoPpYBBAoACgAHAQiXAwAstZYBBAoACwABAQgPegAJABoABAoAAA==.Morriffic:AwAHCBIABAoAAA==.',My='Myw:AwABCAMABRQDDAAIAQjnAgBaEiQDBAoADAAIAQjnAgBaEiQDBAoADQABAQjZVgAHLhwABAoAAA==.',Na='Nachobussy:AwABCAIABRQDDgAHAQj6BgBbR4wCBAoADgAHAQj6BgBbJYwCBAoAAQACAQiOfwBKGLAABAoAAA==.Nautico:AwADCAUABAoAAA==.',Ni='Nihility:AwAICBEABAoAAA==.',No='Notanowl:AwAECAUABAoAAA==.',['N�']='Nùtter:AwAFCAgABAoAAA==.',Oo='Oof:AwAECAYABAoAAA==.',Op='Oprahwînfury:AwADCAYABAoAAA==.Optimize:AwABCAEABAoAAA==.',Or='Oroki:AwAICBAABAoAAA==.',Pe='Pee:AwAHCAcABAoAAA==.',Ph='Physiopriest:AwAECAcABAoAAA==.',Pu='Purpleeyes:AwAFCAoABAoAAA==.',Qt='Qtlewl:AwAGCA4ABAoAAA==.',Ra='Rackhen:AwAFCBAABAoAAA==.Ragestrike:AwACCAIABAoAAA==.Ragnaara:AwABCAIABAoAAA==.',Re='Rekiehunter:AwAHCBEABAoAAA==.Remsie:AwAECAYABAoAAA==.Retnuh:AwAGCBEABAoAAA==.Revivified:AwAICBAABAoAAA==.',Rh='Rhynai:AwAGCA8ABAoAAA==.Rhynpi:AwACCAIABAoAAA==.',Ro='Rogier:AwAFCAsABAoAAA==.Rolvaria:AwABCAEABAoAAA==.',Ru='Runicstrike:AwAHCAsABAoAAA==.',Sc='Schandor:AwADCAMABAoAAA==.Schnookmz:AwADCAQABAoAAA==.Scootyflyjr:AwAFCA4ABAoAAQkANSEBCAIABRQ=.Scootypuffjr:AwABCAEABAoAAQkANSEBCAIABRQ=.Scootytankjr:AwABCAIABRQDCQAIAQgyEwA1IVECBAoACQAIAQgyEwA1IVECBAoADwAFAQhWEAAtqxkBBAoAAA==.',Se='Serpompom:AwAECAQABAoAAA==.',Sh='Shhlurpo:AwAFCAYABAoAAA==.Shunkd:AwADCAYABAoAAA==.',Sk='Skinwalk:AwADCAQABAoAAA==.',Sl='Slamhog:AwADCAUABAoAAA==.Slurpz:AwAICAMABAoAAA==.Slöth:AwAECAQABAoAAA==.',Sr='Srgtbingo:AwAICAgABAoAARAAAAAICAgABAo=.Srgtpeepaw:AwAICAgABAoAAA==.',St='Stabsfortrix:AwABCAIABRQCEQAHAQjTAABibgUDBAoAEQAHAQjTAABibgUDBAoAAA==.Steelsham:AwAGCAEABAoAAA==.Stwilliam:AwAFCA8ABAoAAA==.',Sw='Swicht:AwAECAQABAoAAA==.',Sy='Sylvie:AwAFCAgABAoAAA==.',Ta='Talrad:AwADCAMABAoAAA==.Tanisha:AwACCAEABAoAAA==.Tauralyon:AwEGCBAABAoAAA==.',Te='Teldrasa:AwACCAMABAoAAA==.Telenesh:AwAFCAwABAoAAA==.',Th='Theoob:AwACCAIABAoAAA==.Thighgapy:AwADCAIABAoAAA==.Thorkel:AwABCAEABAoAAA==.Thrashworld:AwAFCAgABAoAAA==.',Ti='Timbop:AwACCAMABAoAAA==.',To='Tofrenm:AwACCAIABAoAAA==.Totalzug:AwAHCBMABAoAARAAAAAICAgABAo=.',Tr='Trunkmuffin:AwACCAMABAoAAA==.',Tu='Tumtums:AwABCAMABRQCEgAIAQg2AwBJ0noCBAoAEgAIAQg2AwBJ0noCBAoAAA==.',Um='Umbriella:AwABCAEABRQDEwAGAQioEwBSF/sBBAoAEwAGAQioEwBSF/sBBAoAFAAEAQgQLQAwDOkABAoAAA==.',Vi='Viridioss:AwAFCAIABAoAAA==.',Wa='Wackah:AwAHCA4ABAoAAA==.Wanpisu:AwAFCBAABAoAAA==.',Wu='Wulfgeng:AwAGCA0ABAoAAA==.',Xa='Xalmont:AwAHCAMABAoAAA==.Xandertheone:AwAGCBIABAoAAA==.Xandi:AwAFCAIABAoAAA==.',Za='Zaakk:AwABCAEABRQAAA==.',Zh='Zhygår:AwAFCAUABAoAAA==.',['Ä']='Ätheist:AwAICAYABAoAAA==.',['Å']='Åtheist:AwAICAUABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end