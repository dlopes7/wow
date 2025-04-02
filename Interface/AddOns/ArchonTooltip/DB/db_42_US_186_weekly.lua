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
 local lookup = {'DeathKnight-Unholy','DeathKnight-Blood','Priest-Shadow','DemonHunter-Havoc','Hunter-BeastMastery','Hunter-Marksmanship','Monk-Mistweaver','Druid-Restoration','Warlock-Affliction','Warlock-Destruction','Shaman-Restoration','Unknown-Unknown','Warrior-Fury','Warlock-Demonology','Warrior-Protection','Paladin-Retribution','Druid-Balance','Priest-Holy','Rogue-Subtlety','Rogue-Assassination','Mage-Fire','Mage-Frost','Druid-Feral',}; local provider = {region='US',realm="Sen'jin",name='US',type='weekly',zone=42,date='2025-03-28',data={Aa='Aalliyah:AwADCAIABAoAAA==.',Ad='Adolinn:AwAHCBQABAoCAQAHAQgdGQA7pfcBBAoAAQAHAQgdGQA7pfcBBAoAAA==.',Am='Amaterasu:AwABCAIABRQCAgAIAQjHDgA5t+sBBAoAAgAIAQjHDgA5t+sBBAoAAA==.',At='Attrox:AwAECAgABAoAAA==.',Av='Avakai:AwADCAEABAoAAA==.',Ba='Bareeye:AwAECAsABAoAAA==.',Bi='Biroll:AwAICAUABAoAAA==.',Bl='Blasphemian:AwABCAIABRQCAwAIAQigEQA0chACBAoAAwAIAQigEQA0chACBAoAAA==.Blinddate:AwABCAEABRQCBAAIAQgVFQA5n3ICBAoABAAIAQgVFQA5n3ICBAoAAA==.Bloodbarne:AwADCAEABAoAAA==.',Bo='Bopya:AwADCAQABAoAAA==.',Br='Brandn:AwABCAIABRQDBQAIAQifDABeY/UCBAoABQAHAQifDABe9PUCBAoABgAFAQjoEQBaxboBBAoAAA==.',Ca='Cabrakan:AwAGCBIABAoAAA==.',Ce='Certaddboi:AwAGCBEABAoAAA==.',Ch='Chèt:AwABCAEABAoAAA==.',Cr='Crimes:AwABCAEABAoAAA==.Crimsonn:AwAFCAEABAoAAA==.Crössblesser:AwABCAMABAoAAA==.',Cy='Cytherea:AwACCAIABAoAAQcASYsBCAIABRQ=.',Da='Daijha:AwADCAEABAoAAA==.Damhealz:AwAGCAEABAoAAA==.Darctricity:AwAGCA8ABAoAAA==.',De='Deks:AwAGCA8ABAoAAA==.Delphia:AwAECAgABAoAAA==.Depletefist:AwAICBUABAoCBwAIAQijIwAesnoBBAoABwAIAQijIwAesnoBBAoAAA==.',Do='Dorania:AwADCAQABAoAAA==.Dorei:AwABCAIABAoAAA==.Doudounete:AwACCAIABAoAAA==.',Ed='Eddiebravo:AwADCAMABAoAAA==.',Ei='Eirtae:AwAECAcABAoAAA==.',En='Endlesstide:AwACCAIABAoAAA==.Envy:AwABCAIABRQCCAAIAQiFAQBdATwDBAoACAAIAQiFAQBdATwDBAoAAA==.',Er='Erisan:AwAFCAkABAoAAA==.',Ew='Ewaker:AwADCAEABAoAAA==.',Fe='Feign:AwAGCBAABAoAAA==.Felco:AwAICBIABAoAAA==.Ferice:AwADCAEABAoAAA==.',Fi='Firstdk:AwAFCAEABAoAAA==.Fitzjuno:AwADCAcABAoAAA==.',Fr='Frostnipplet:AwAICBgABAoDCQAIAQhIAwBUXTgCBAoACQAGAQhIAwBWuTgCBAoACgAEAQgSNwBPb0ABBAoAAA==.Frostyfreeze:AwADCAIABAoAAA==.',Fu='Funkymônk:AwACCAIABAoAAA==.',Ga='Gaius:AwABCAEABAoAAA==.',Gi='Gigashadow:AwAECAIABAoAAA==.',Gu='Gullurg:AwAECAUABAoAAA==.',Gw='Gweneviere:AwADCAEABAoAAA==.',Ha='Hadesfalcon:AwAECAgABAoAAA==.Hainne:AwAICBUABAoCCwAIAQhRCwBEKYcCBAoACwAIAQhRCwBEKYcCBAoAAA==.Handrob:AwAFCA0ABAoAAA==.',He='Hebrews:AwACCAQABRQAAA==.Heliös:AwABCAEABAoAAA==.',Ho='Hollywoodx:AwABCAEABAoAAA==.Hornyou:AwABCAEABAoAAA==.',['H�']='Hëbrews:AwACCAIABAoAAQwAAAACCAQABRQ=.',Ir='Irok:AwAECAQABAoAAA==.Irokk:AwABCAEABAoAAQwAAAAECAQABAo=.Irokrage:AwABCAEABAoAAQwAAAAECAQABAo=.',Iy='Iykyk:AwADCAkABAoAAA==.',Jh='Jhyl:AwAECAgABAoAAA==.',Jo='Jordroy:AwABCAIABRQCDQAIAQicBQBT0wwDBAoADQAIAQicBQBT0wwDBAoAAA==.',Ka='Kaanuu:AwADCAQABAoAAA==.Kabbage:AwAGCBUABAoCCwAGAQhbEgBVxzICBAoACwAGAQhbEgBVxzICBAoAAA==.Kamekage:AwAICAoABAoAAA==.',Kh='Khage:AwAGCA4ABAoAAA==.Khelad:AwADCAMABAoAAA==.',Ko='Kossak:AwACCAIABAoAAA==.',Ku='Kuber:AwABCAIABRQDCgAIAQhRKQAcnpkBBAoACgAIAQhRKQAZsJkBBAoADgACAQifMQAdZWgABAoAAA==.Kupó:AwADCAUABAoAAA==.',['K�']='Kéndo:AwAECAYABAoAAA==.',Le='Leah:AwAECAgABAoAAA==.Lehsmit:AwABCAIABRQCCwAIAQiSBgBUcdUCBAoACwAIAQiSBgBUcdUCBAoAAA==.',Li='Lightydragon:AwADCAMABAoAAA==.Lilclam:AwAGCA0ABAoAAA==.Lildookey:AwADCAQABAoAAA==.',Ll='Llucas:AwAICBcABAoCAQAIAQhfBgBX3/YCBAoAAQAIAQhfBgBX3/YCBAoAAA==.',Lo='Lostarcher:AwACCAQABAoAAA==.Loycen:AwABCAIABRQCDwAIAQi0AABckkcDBAoADwAIAQi0AABckkcDBAoAAA==.',Lu='Luftwaffles:AwAECAYABAoAAA==.',Ma='Madren:AwADCAUABAoAAA==.Manikk:AwACCAIABAoAAA==.',Me='Mechamist:AwADCAUABAoAAA==.Megadööm:AwAICBUABAoCEAAIAQjiPAAuj+kBBAoAEAAIAQjiPAAuj+kBBAoAAA==.Mephaal:AwABCAEABAoAAA==.Mercymorn:AwABCAIABRQCBwAIAQhtCQBJi6YCBAoABwAIAQhtCQBJi6YCBAoAAA==.',Mi='Miikowarrior:AwAFCAQABAoAAA==.Missfyre:AwAFCAcABAoAAA==.',Mo='Moistie:AwABCAEABRQAAA==.Montyopython:AwAECAgABAoAAA==.Moocowd:AwAICBUABAoCEAAIAQhNEQBV+9wCBAoAEAAIAQhNEQBV+9wCBAoAAA==.',Mu='Murista:AwADCAcABAoAAA==.',My='Mythalor:AwABCAEABAoAAA==.',Na='Nate:AwAECAQABAoAAA==.',Ne='Nefret:AwAECAgABAoAAA==.Nevertanked:AwAECAgABAoAAA==.',Ni='Nilophyte:AwABCAMABRQCAgAIAQiXEAA0mMsBBAoAAgAIAQiXEAA0mMsBBAoAAA==.Nitrous:AwADCAQABAoAAA==.',Ny='Nyxra:AwACCAIABAoAAA==.',['N�']='Nôvus:AwADCAUABAoAAA==.',Og='Ogden:AwAHCBMABAoAAA==.',Or='Orgazmoo:AwAGCAwABAoAAA==.',Pa='Pallywaker:AwAFCAwABAoAAA==.',Pe='Pennyvise:AwABCAEABAoAAA==.Pettychunt:AwABCAEABAoAAA==.',Ph='Phatemonk:AwAICBEABAoAAA==.Phiani:AwAECAYABAoAAA==.',Pi='Picomage:AwAGCAcABAoAAA==.',Po='Ponie:AwAGCA0ABAoAAA==.',Qu='Quihote:AwAFCAEABAoAAA==.',Rh='Rhaznak:AwAECAEABAoAAA==.',Ro='Rothron:AwABCAEABRQCAQAIAQhUBgBW2fcCBAoAAQAIAQhUBgBW2fcCBAoAAA==.',Ru='Rustybeer:AwAFCAYABAoAAA==.',Ry='Ryeal:AwABCAIABRQCEAAIAQjYIgBCfGICBAoAEAAIAQjYIgBCfGICBAoAAA==.',Sa='Saalokbear:AwABCAEABRQCEQAHAQiPGgBDAQsCBAoAEQAHAQiPGgBDAQsCBAoAAA==.Sarasvati:AwABCAEABRQCCAAIAQi5GwAeP30BBAoACAAIAQi5GwAeP30BBAoAAA==.Sashani:AwABCAEABAoAAA==.',Se='Seraphíné:AwAECAkABRQCEgAEAQjPAAA3NFABBRQAEgAEAQjPAAA3NFABBRQAAA==.Serzul:AwADCAMABAoAAA==.Sewazbek:AwAHCAsABAoAAA==.',Sh='Shakes:AwABCAEABAoAAA==.Sheprock:AwAECA0ABAoAAA==.Shizu:AwACCAIABAoAAA==.Shninzy:AwABCAIABRQDEwAIAQjUAQBenzMDBAoAEwAIAQjUAQBdzDMDBAoAFAAEAQhREgBMNmMBBAoAAA==.Shrilla:AwAECAgABAoAAA==.',Si='Sigal:AwAECAQABAoAAA==.',Sk='Skul:AwABCAEABAoAAA==.',Sn='Snufalupagus:AwAFCAUABAoAAQ0AK60CCAUABRQ=.',So='Sofee:AwACCAMABAoAAA==.Sous:AwAICBIABAoAAA==.Souss:AwAFCAkABAoAAA==.',Sp='Spamsalot:AwAICAoABAoAAA==.Sparklenips:AwAFCAgABAoAAA==.Spazzn:AwAFCAMABAoAAA==.',St='Stormlight:AwAFCAwABAoAAA==.Strangetank:AwADCAQABAoAAA==.',['S�']='Såyoko:AwADCAkABAoAAA==.',Ta='Tacødemøn:AwABCAEABAoAAA==.Tadinanefer:AwACCAEABAoAAA==.Tailstwo:AwABCAEABAoAAA==.Taintshockur:AwADCAYABAoAAA==.Tamiria:AwAECAgABAoAAA==.',Th='Thefearful:AwAFCAUABAoAAA==.Thelios:AwAICBUABAoCCQAIAQicBwAe/Z8BBAoACQAIAQicBwAe/Z8BBAoAAA==.Thragar:AwAFCAgABAoAAA==.',Ti='Tishoro:AwABCAEABAoAAA==.',To='Tooggy:AwAGCA8ABAoAAA==.Torrask:AwABCAEABAoAAA==.Toyle:AwAECAYABAoAAA==.',Tr='Trimi:AwADCAEABAoAAA==.Trinslight:AwADCAEABAoAAQwAAAAFCAcABAo=.Trus:AwAECAkABAoAAA==.',Tt='Ttonoy:AwAGCAMABAoAAA==.',Tu='Tuatha:AwABCAIABRQDFQAIAQiUFwBAl1ECBAoAFQAIAQiUFwA91VECBAoAFgAFAQioLQBIzkIBBAoAAA==.',Tw='Twisteddruid:AwAICAgABAoAAA==.',Ty='Tygroen:AwABCAEABRQCFwAIAQinBAA73WYCBAoAFwAIAQinBAA73WYCBAoAAA==.',Ud='Uday:AwACCAUABRQCDQACAQjSCwArrY4ABRQADQACAQjSCwArrY4ABRQAAA==.',Uf='Ufoaminbro:AwABCAEABAoAAA==.',Uh='Uhohdh:AwACCAMABRQCBAAIAQidCABQMAUDBAoABAAIAQidCABQMAUDBAoAAA==.',Un='Unos:AwADCAMABAoAAQwAAAAICAgABAo=.',Ve='Vennisa:AwAECAEABAoAAA==.Veruca:AwAECAcABAoAAA==.',Xa='Xanuel:AwADCAQABAoAAA==.',Xe='Xen:AwACCAMABAoAAA==.Xenie:AwAHCBEABAoAAA==.Xerorunes:AwACCAIABAoAAQwAAAAGCAsABAo=.Xerosyn:AwAGCAsABAoAAA==.',Ye='Yeezùs:AwAGCAcABAoAAA==.',Za='Zaboomafo:AwAICA4ABAoAAA==.Zanazoth:AwAGCA4ABAoAAA==.Zappyfoxx:AwAGCA0ABAoAAA==.',Ze='Zekwu:AwABCAEABAoAAA==.Zepher:AwADCAMABAoAAA==.',Zi='Zillaby:AwADCAQABAoAAA==.',Zl='Zlup:AwACCAIABAoAAA==.',Zo='Zoltair:AwADCAEABAoAAA==.',Zu='Zulimu:AwAICAgABAoAAA==.',['É']='Éviljèsus:AwADCAQABAoAAA==.',['Í']='Ízzÿ:AwADCAMABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end