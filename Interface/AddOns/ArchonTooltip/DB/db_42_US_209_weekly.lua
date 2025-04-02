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
 local lookup = {'Unknown-Unknown','Priest-Holy','Priest-Shadow','Warlock-Destruction','Warlock-Demonology','Warlock-Affliction','Shaman-Restoration','DeathKnight-Blood','Hunter-Marksmanship','Warrior-Fury','Rogue-Assassination','Mage-Frost','Paladin-Protection','Paladin-Retribution','Mage-Fire','Evoker-Devastation','Hunter-BeastMastery',}; local provider = {region='US',realm='Suramar',name='US',type='weekly',zone=42,date='2025-03-28',data={Ac='Achievless:AwADCAQABAoAAA==.Achievsome:AwABCAEABRQAAA==.',Al='Aleisa:AwABCAEABAoAAA==.Allereith:AwAECAQABAoAAA==.Allimore:AwAECAEABAoAAA==.Allseer:AwAFCAgABAoAAA==.',An='Anielak:AwACCAIABAoAAQEAAAAGCAIABAo=.Anthaden:AwAFCAgABAoAAA==.',Ar='Arkanis:AwAFCAkABAoAAA==.Arrolexancas:AwAECAEABAoAAA==.',Au='Aureus:AwAGCA0ABAoAAA==.',Ay='Aynhillbeads:AwABCAMABAoAAA==.',Az='Azules:AwACCAIABAoAAA==.',Ba='Bathtub:AwADCAUABAoAAA==.',Bl='Blues:AwAGCAYABAoAAQEAAAAICAgABAo=.',Bp='Bpbreezy:AwAICBkABAoDAgAIAQhKDABA1k8CBAoAAgAIAQhKDABA1k8CBAoAAwABAQiYSQAkuC0ABAoAAA==.',Br='Bradwarrior:AwAHCAoABAoAAA==.Bray:AwADCAMABAoAAQQAQcIBCAEABRQ=.Braydrel:AwABCAEABRQEBAAHAQh+LABBwoMBBAoABAAGAQh+LAA7QIMBBAoABQADAQhcHABCP+YABAoABgADAQhLHAAXa4EABAoAAA==.Bredock:AwAECAQABAoAAA==.Brorighteous:AwACCAUABAoAAA==.',By='Bysokar:AwAECAoABAoAAA==.',Ca='Catanz:AwACCAMABRQCBwAIAQhzBgBSQtcCBAoABwAIAQhzBgBSQtcCBAoAAA==.',Ce='Cellineth:AwAECAQABAoAAA==.',Ch='Chinkiferus:AwAFCAEABAoAAA==.Chrnobog:AwACCAIABAoAAQQAWz0CCAQABRQ=.',Ci='Cinderlily:AwADCAcABAoAAA==.',Co='Conflagrate:AwAECAQABAoAAA==.',['C�']='Cüpcake:AwADCAYABAoAAA==.',Da='Datoneguy:AwAGCAYABAoAAA==.',De='Deemonz:AwAGCAYABAoAAA==.Delik:AwAECAIABAoAAA==.Derazal:AwACCAIABAoAAA==.',Do='Docsharpshot:AwAECAYABAoAAA==.Doomshield:AwADCAMABAoAAA==.',Dr='Dracodeez:AwAECAgABAoAAA==.Druss:AwAFCAsABAoAAA==.',Dy='Dyxx:AwADCAMABAoAAA==.',Er='Eradorn:AwAECAQABAoAAA==.Erisson:AwAFCAIABAoAAA==.',Es='Eszran:AwAECAcABAoAAA==.',Fe='Felblaster:AwAICAgABAoAAA==.Feldweller:AwAFCAsABAoAAA==.Ferosha:AwAGCBMABAoAAA==.Fexxyr:AwACCAIABAoAAQgALoMCCAIABRQ=.',Fi='Fistoffurry:AwAECAcABAoAAA==.',Fl='Flynae:AwAECAkABAoAAA==.',Fy='Fyxxer:AwACCAIABRQCCAAHAQgsFgAug3oBBAoACAAHAQgsFgAug3oBBAoAAA==.',Ge='Gendevo:AwAICAgABAoAAA==.',Gi='Gialiana:AwABCAEABRQCCQAHAQhQEQA33MEBBAoACQAHAQhQEQA33MEBBAoAAA==.',Go='Gorakk:AwADCAQABAoAAA==.',Gr='Greenymeany:AwAGCBUABAoCCgAGAQgaFwBNtSECBAoACgAGAQgaFwBNtSECBAoAAA==.Grully:AwABCAEABRQCBwAHAQgmMwAcu0YBBAoABwAHAQgmMwAcu0YBBAoAAA==.',Gu='Guf:AwABCAEABRQAAA==.',Ha='Haggard:AwAECAkABAoAAA==.',He='Heartstabber:AwADCAUABAoAAA==.Heishiro:AwAECAIABAoAAA==.',Hi='Hiryu:AwADCAUABAoAAA==.',Il='Ilyss:AwAECAQABAoAAQsAXwIGCBUABAo=.',Im='Imjustpika:AwACCAIABRQAAA==.',In='Inferniö:AwACCAIABRQCDAAHAQgXAwBjcCYDBAoADAAHAQgXAwBjcCYDBAoAAA==.Inkurushio:AwABCAEABAoAAA==.',Is='Ismat:AwAGCBMABAoAAA==.',Ja='Jadewhisper:AwAGCBAABAoAAA==.Jaycinth:AwACCAIABAoAAA==.',Je='Jenako:AwACCAMABRQCBwAIAQglCQBLsagCBAoABwAIAQglCQBLsagCBAoAAA==.Jentoo:AwAGCBQABAoCDAAGAQiRKAAxxGQBBAoADAAGAQiRKAAxxGQBBAoAAA==.',Ji='Jit:AwAECAYABAoAAA==.',Jo='Jonnathann:AwADCAEABAoAAA==.',Ka='Kairos:AwAECAcABAoAAA==.Kaveros:AwAECAcABAoAAA==.',Ke='Kelaan:AwABCAEABRQDDQAHAQjEDQA21LQBBAoADgAHAQhkRQAvmMcBBAoADQAHAQjEDQA1Y7QBBAoAAA==.Keladriel:AwADCAQABAoAAA==.',Kh='Khral:AwADCAEABAoAAA==.',Ki='Kiserys:AwADCAMABAoAAA==.',Ko='Kortek:AwAFCAcABAoAAA==.Kowwen:AwAGCAsABAoAAQwAMcQGCBQABAo=.',Kr='Krysto:AwAECAIABAoAAA==.',Ky='Kyr:AwABCAIABAoAAQEAAAAFCAsABAo=.',La='Lanféar:AwAICAgABAoAAA==.',Lo='Lookforlight:AwAGCA0ABAoAAA==.Lorenzo:AwADCAMABAoAAA==.',Ma='Maros:AwAECAQABAoAAA==.Maxander:AwABCAEABRQAAA==.',Me='Mechanix:AwAECAgABAoAAA==.Meibao:AwAFCA0ABAoAAQEAAAAGCBMABAo=.Metaphysical:AwADCAYABAoAAA==.',Mi='Millîe:AwAECAEABAoAAA==.',Mo='Moartuna:AwABCAEABAoAAA==.Mogchamp:AwAFCAYABAoAAA==.Mogmorphosis:AwAGCAsABAoAAA==.Mogtharrian:AwAFCA4ABAoAAA==.Mokomah:AwAECAcABAoAAA==.',Ms='Msironimps:AwACCAMABAoAAA==.',My='Mymeii:AwACCAEABAoAAA==.',['M�']='Méow:AwADCAUABAoAAA==.',Na='Nash:AwAECAQABAoAAA==.Nastyiam:AwACCAMABAoAAA==.',Ne='Nethfist:AwADCAMABAoAAA==.Nethris:AwABCAEABRQDDAAHAQgZHwArba4BBAoADAAHAQgZHwArba4BBAoADwACAQjhZwALoUkABAoAAA==.',Ni='Nienora:AwAECAgABAoAAA==.',Ob='Obi:AwADCAcABAoAAA==.',On='Onichanx:AwAFCAsABAoAAA==.Oné:AwADCAIABAoAAA==.',Or='Orgoan:AwACCAIABAoAAA==.',Os='Osmont:AwADCAEABAoAAA==.',Pi='Pikagosa:AwAHCBgABAoCEAAHAQixEgA0KMMBBAoAEAAHAQixEgA0KMMBBAoAAQEAAAACCAIABRQ=.',Pr='Prrine:AwAECAkABAoAAA==.',Qu='Quieres:AwADCAcABAoAAA==.',Re='Redeem:AwADCAMABAoAAA==.Reios:AwAECAIABAoAAA==.',Rh='Rhaz:AwADCAcABAoAAA==.',Ri='Rickyspanish:AwADCAcABAoAAA==.Rifter:AwABCAEABAoAAA==.',Ru='Rubyous:AwAECAQABAoAAA==.Ruibas:AwABCAEABAoAAA==.Rukaine:AwADCAQABAoAAQEAAAABCAIABRQ=.',Sa='Sabrîna:AwAGCAcABAoAAA==.',Se='Secton:AwAFCAEABAoAAQsAXwIGCBUABAo=.Selie:AwABCAEABAoAAA==.Seztras:AwAFCAIABAoAAA==.',Si='Sippycup:AwACCAIABAoAAA==.',Sl='Sleepyjoee:AwADCAEABAoAAA==.Sleepyyjoe:AwAFCAoABAoAAA==.',Sn='Snowmage:AwAECAEABAoAAA==.',So='Soap:AwACCAIABAoAAA==.Societte:AwADCAIABAoAAA==.Somebody:AwABCAEABAoAAA==.',Sp='Sparrhawk:AwADCAQABAoAAA==.Spiced:AwABCAEABRQAAA==.',Su='Suismort:AwABCAEABRQAAA==.',Ta='Tallerthenu:AwABCAEABAoAAA==.Taurrows:AwABCAEABRQCEQAHAQjTOwAnKJwBBAoAEQAHAQjTOwAnKJwBBAoAAA==.',Tb='Tbill:AwADCAMABAoAAA==.',Te='Tenson:AwACCAIABAoAAA==.',Th='Thealmighty:AwAECAYABAoAAA==.Theicemaker:AwAECAIABAoAAA==.Throwdini:AwAGCBAABAoAAA==.Thundermaker:AwABCAEABAoAAQEAAAAFCAsABAo=.',Tr='Trend:AwAECAcABAoAAA==.',Tu='Tulanis:AwAGCBUABAoCCQAGAQgRGAA4f2YBBAoACQAGAQgRGAA4f2YBBAoAAA==.',Tw='Twiggee:AwABCAEABAoAAA==.',Ty='Tyriem:AwAGCA8ABAoAAA==.Tyssanton:AwAECAIABAoAAA==.',Ug='Uggork:AwAGCAsABAoAAA==.Ugly:AwAICAcABAoAAA==.',Va='Vaticate:AwAECAkABAoAAA==.',Ve='Velaari:AwAGCBUABAoCCwAGAQjaBgBfAnQCBAoACwAGAQjaBgBfAnQCBAoAAA==.Velaán:AwADCAMABAoAAQ0ANtQBCAEABRQ=.',Vi='Villain:AwAGCBMABAoAAA==.Virginslyer:AwACCAIABAoAAA==.',Vo='Vodnar:AwABCAEABRQCEQAHAQgKJgBI8SACBAoAEQAHAQgKJgBI8SACBAoAAA==.',Vu='Vulcos:AwACCAEABAoAAA==.',Wa='Waachurback:AwABCAEABRQCCwAHAQhWCgA7dRQCBAoACwAHAQhWCgA7dRQCBAoAAA==.Walls:AwAECAkABAoAAA==.',We='Werragan:AwAFCAsABAoAAA==.Western:AwABCAEABRQEBAAHAQhhMgBBnlwBBAoABAAFAQhhMgA6tVwBBAoABgADAQh6EwA7E9cABAoABQACAQhEKgA7ppEABAoAAA==.',Wi='Willith:AwAFCAEABAoAAA==.Willîe:AwAECAwABAoAAA==.Wingbry:AwAECAIABAoAAA==.',Wr='Wrashis:AwADCAYABAoAAA==.',Xi='Xiolablu:AwAFCA8ABAoAAA==.',Ya='Yaffa:AwABCAEABAoAAA==.Yarragon:AwAGCA4ABAoAAA==.',Ye='Yeahyeah:AwAHCA0ABAoAAA==.',Yo='Yogí:AwAECAcABAoAAA==.',Za='Zaratul:AwACCAIABRQCDgAHAQigEwBdm8kCBAoADgAHAQigEwBdm8kCBAoAAA==.Zaroth:AwABCAEABRQCAgAIAQgEBwBRNqkCBAoAAgAIAQgEBwBRNqkCBAoAAA==.',Ze='Zennyo:AwAECAQABAoAAA==.',Zh='Zharrak:AwAFCAQABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end