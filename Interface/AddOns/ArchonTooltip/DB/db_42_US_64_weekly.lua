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
 local lookup = {'Warlock-Destruction','Warlock-Demonology','Druid-Feral','Shaman-Restoration','Mage-Frost','Warrior-Protection','DeathKnight-Blood','Unknown-Unknown','Mage-Fire','Priest-Discipline','Priest-Shadow','Priest-Holy','DemonHunter-Havoc','Shaman-Enhancement','Shaman-Elemental','Rogue-Assassination','Rogue-Subtlety','Evoker-Devastation','Druid-Balance','Druid-Restoration','DemonHunter-Vengeance','Monk-Windwalker','DeathKnight-Unholy','Paladin-Retribution','Hunter-BeastMastery','Hunter-Survival','Warrior-Arms','Warrior-Fury','Evoker-Preservation','Hunter-Marksmanship',}; local provider = {region='US',realm='Deathwing',name='US',type='weekly',zone=42,date='2025-03-29',data={Aa='Aamix:AwABCAIABRQDAQAIAQgsJAA7KckBBAoAAQAGAQgsJAA/E8kBBAoAAgACAQjzLgAva4YABAoAAA==.Aarom:AwABCAEABRQAAA==.',Ad='Adragen:AwAFCAUABAoAAA==.',Ae='Aerius:AwACCAIABAoAAA==.',Ak='Akasori:AwAICBYABAoCAwAHAQjTBQBFHzcCBAoAAwAHAQjTBQBFHzcCBAoAAA==.',Al='Albiro:AwABCAEABAoAAA==.Aldarus:AwAFCAoABAoAAA==.Alîsonshammy:AwABCAEABRQCBAAHAQjnCABYa7ECBAoABAAHAQjnCABYa7ECBAoAAA==.',Am='Ambersulfr:AwAECAgABAoAAA==.Amilis:AwAECAgABAoAAA==.',An='Andromeda:AwAFCAUABAoAAA==.',Ap='Aphroditez:AwAECAIABAoAAA==.',Ar='Armalight:AwAICBMABAoAAA==.',As='Astralus:AwAICBUABAoCBQAIAQgvEgBAiTUCBAoABQAIAQgvEgBAiTUCBAoAAA==.Astraía:AwAECAkABAoAAA==.',At='Athos:AwACCAEABAoAAA==.Atomicbarbie:AwACCAQABAoAAQQAWGsBCAEABRQ=.',Az='Aznoth:AwADCAMABAoAAQYAXa8BCAIABRQ=.',Be='Beefybel:AwADCAMABAoAAA==.Beleaf:AwAFCAUABAoAAA==.Berdron:AwAECAQABAoAAA==.',Bl='Blindeddie:AwAFCAUABAoAAQcAWDIECAoABRQ=.Blouses:AwAGCAYABAoAAA==.',Bo='Boned:AwAECAkABAoAAA==.Bowser:AwAFCAoABAoAAQgAAAABCAIABRQ=.',Ca='Caldec:AwAECAoABRQCCQAEAQi+BgAlqicBBRQACQAEAQi+BgAlqicBBRQAAA==.Casander:AwAICBAABAoAAA==.Catdog:AwAFCAkABAoAAA==.',Ch='Chainsmite:AwABCAIABRQECgAIAQjOFQAm+LUBBAoACgAIAQjOFQAm5bUBBAoACwAGAQgtGQBIaK4BBAoADAACAQhAVwARI1oABAoAAA==.Cheeno:AwAHCBgABAoCDQAHAQhuEABW76sCBAoADQAHAQhuEABW76sCBAoAAA==.Chillyblasta:AwACCAQABAoAAA==.',Cl='Clunk:AwAFCAMABAoAAA==.',Co='Coorslight:AwAGCAwABAoAAA==.Costco:AwAHCAwABAoAAA==.',Cr='Crantor:AwAFCAgABAoAAA==.Crelam:AwAECAoABRQCDgAEAQjvAgARSBYBBRQADgAEAQjvAgARSBYBBRQAAA==.',Da='Damoo:AwAECAEABAoAAA==.Damös:AwACCAIABAoAAA==.Darwin:AwADCAMABAoAAA==.Davrillian:AwAHCAsABAoAAA==.',De='Demnus:AwAECAEABAoAAA==.Dewfus:AwAFCAMABAoAAA==.',Dy='Dyami:AwAGCAwABAoAAA==.Dying:AwAHCBMABAoAAA==.',Ea='Earthcake:AwAHCBUABAoCDwAHAQilEgA9iBACBAoADwAHAQilEgA9iBACBAoAAA==.',Ed='Eddielich:AwAECAoABRQCBwAEAQifAABYMpkBBRQABwAEAQifAABYMpkBBRQAAA==.',Eg='Eggfumonk:AwABCAEABAoAAA==.',El='Elevandro:AwAICAgABAoAAA==.Elsan:AwAECAgABAoAAA==.',Ex='Extracter:AwAECAQABAoAAA==.',Fa='Fatevoker:AwAECAEABAoAAA==.Fattie:AwAHCAsABAoAAA==.',Fo='Folklore:AwAFCAsABAoAAA==.Forklift:AwAFCAoABAoAAA==.Forshizzle:AwADCAQABAoAAA==.',Fr='Frostyfoxy:AwAHCAoABAoAAA==.Frothtie:AwAICAgABAoAAA==.',Ga='Gardex:AwABCAEABAoAAA==.',Gi='Gisellina:AwAHCA8ABAoAAA==.',Gn='Gn:AwAHCBUABAoDEAAHAQicCwBTQPsBBAoAEAAGAQicCwBSLvsBBAoAEQAEAQgEGgBCTjoBBAoAAA==.',Gr='Grumpydik:AwAFCAUABAoAAA==.',Gy='Gymluigi:AwAGCAkABAoAAA==.',Hb='Hbheathenm:AwADCAQABRQCCQADAQg1DQARb70ABRQACQADAQg1DQARb70ABRQAAA==.',Ho='Holdenc:AwABCAEABAoAAQgAAAADCAgABAo=.Hoodz:AwAFCAkABAoAAA==.',Ib='Iblees:AwABCAEABRQAAQgAAAABCAEABRQ=.',Ic='Icerod:AwAECAgABAoAAA==.',Im='Imagined:AwAFCAUABAoAAA==.',Ja='Jadebobo:AwAECAgABAoAAA==.Jage:AwAGCAsABAoAAA==.',Je='Jeff:AwADCAUABAoAAA==.',Jw='Jwrs:AwAECAIABAoAAA==.',Ka='Kaelana:AwAGCAkABAoAAA==.',Kl='Klasik:AwACCAIABAoAAA==.',Ko='Kored:AwADCAQABAoAAQgAAAAECAEABAo=.Koyra:AwAECAoABRQCEgAEAQjEAABZp54BBRQAEgAEAQjEAABZp54BBRQAAA==.',Ku='Kurral:AwAECAkABRQCEwAEAQjLBQAX4A4BBRQAEwAEAQjLBQAX4A4BBRQAAA==.Kurstina:AwAGCAYABAoAAA==.',Ky='Kyramus:AwAECAgABAoAAA==.',La='Laconia:AwAGCA4ABAoAAA==.Lashstorm:AwABCAEABAoAAA==.',Le='Leafbeard:AwAICAgABAoAAA==.Leonardo:AwACCAIABAoAAQ0AVu8HCBgABAo=.',Lo='Loktardogard:AwAFCAkABAoAAA==.',Lu='Lurosa:AwAICBsABAoDFAAIAQgyCABLVYQCBAoAFAAIAQgyCABLVYQCBAoAEwAHAQiZGgBJcBYCBAoAAA==.',Ma='Maaz:AwABCAEABRQAAA==.Mahallo:AwADCAMABAoAAA==.Mairicade:AwAFCAUABAoAAA==.Mairidari:AwAECAoABRQCFQAEAQhiAABDvE4BBRQAFQAEAQhiAABDvE4BBRQAAA==.Marllowe:AwAICBkABAoCFgAIAQgQGwAkB6EBBAoAFgAIAQgQGwAkB6EBBAoAAA==.Marthros:AwAICAgABAoAAA==.Mawgdruid:AwABCAMABRQAAA==.',Mh='Mhunk:AwACCAMABAoAAA==.',Mu='Muggy:AwAECAgABRQCFwAEAQhIAABalqUBBRQAFwAEAQhIAABalqUBBRQAAA==.',Na='Narama:AwADCAYABRQCAQADAQgICAAOQLQABRQAAQADAQgICAAOQLQABRQAAA==.',Ne='Nep:AwAHCBUABAoCBwAHAQjMGgAl1E0BBAoABwAHAQjMGgAl1E0BBAoAAA==.Newtowel:AwAICAcABAoAAA==.',Ni='Nitewïng:AwABCAEABAoAAA==.',No='Nofbolt:AwAICB0ABAoCDwAIAQgaCgBLBJYCBAoADwAIAQgaCgBLBJYCBAoAAA==.Nooga:AwAHCBQABAoCDwAHAQiOCgBTIY4CBAoADwAHAQiOCgBTIY4CBAoAAA==.Nootao:AwABCAQABRQCFgAIAQjkAQBb+FMDBAoAFgAIAQjkAQBb+FMDBAoAAA==.',Or='Oraculus:AwAECAkABRQCFAAEAQgGAQA4EkkBBRQAFAAEAQgGAQA4EkkBBRQAAA==.Ore:AwAECAQABAoAAA==.',Pa='Pakaru:AwAICBMABAoAAA==.Palliate:AwAECAwABAoAAA==.Pam:AwACCAUABRQCDQACAQg8DAAzgKMABRQADQACAQg8DAAzgKMABRQAAA==.',Pe='Peremo:AwAGCA0ABAoAAA==.Perfectdark:AwAECAQABRQCDQAIAQiFBQBcYTcDBAoADQAIAQiFBQBcYTcDBAoAAA==.',Pi='Pipa:AwAFCAcABAoAAA==.',Po='Poacher:AwAFCAEABAoAAA==.',Pu='Pugna:AwAGCA4ABAoAAA==.',Ra='Rainhunter:AwAICBMABAoAAA==.',Re='Realfrojd:AwAGCBAABAoAAA==.Regginunchuk:AwADCAUABAoAAA==.Rextallion:AwADCAMABAoAAA==.',Ri='Ripyeet:AwABCAEABRQCGAAIAQhBGgBLUaICBAoAGAAIAQhBGgBLUaICBAoAAA==.',Ry='Ryuuter:AwAECAQABAoAAA==.',Sa='Sarkang:AwACCAMABAoAAA==.',Sc='Schutze:AwABCAIABRQDGQAIAQjlEQBSjcsCBAoAGQAIAQjlEQBPJMsCBAoAGgAGAQg1AgBZ+FMCBAoAAA==.',Se='Sertss:AwAECAoABRQDGwAEAQikAABUtzIBBRQAGwADAQikAABV8zIBBRQAHAADAQiOBABRwiIBBRQAAA==.',Sh='Shabobado:AwAFCAcABAoAAA==.Shamuz:AwADCAYABAoAAA==.',Si='Simplejakk:AwABCAEABRQAAA==.Sindralosa:AwAECAQABAoAARQAS1UICBsABAo=.',Sm='Smexyexpress:AwAFCAUABAoAAA==.Smeyplus:AwAECAgABRQCGAAEAQgHAwBFtFUBBRQAGAAEAQgHAwBFtFUBBRQAAA==.',Sn='Snofawl:AwAHCBUABAoCEgAHAQhjGAAfl3cBBAoAEgAHAQhjGAAfl3cBBAoAAA==.',So='Sovereign:AwAICBsABAoCEgAIAQghBgBS984CBAoAEgAIAQghBgBS984CBAoAAA==.',Sp='Spookypooky:AwADCAEABAoAAA==.',Sq='Squidd:AwAFCAEABAoAAA==.',St='Stonehenge:AwAICBMABAoAAA==.',Su='Sucramonkey:AwAFCAsABAoAAA==.',Sw='Swagpresence:AwAGCA0ABAoAAA==.',Sy='Syandris:AwAECAQABAoAAA==.',['S�']='Sæb:AwAICAgABAoAAA==.',Ta='Tahtou:AwADCAQABAoAAQgAAAAECAEABAo=.',To='Toonerfu:AwAECAgABAoAAA==.Toxovolia:AwADCAMABAoAAA==.',Tw='Twentyone:AwAGCA0ABAoAAA==.',Ty='Tyralen:AwAFCAMABAoAAQgAAAAGCAwABAo=.',Ve='Verz:AwAECAgABAoAAA==.',Vi='Vineeshewah:AwADCAMABAoAAA==.Vizu:AwAGCAsABAoAAA==.',Wo='Wormszer:AwAECAYABAoAAA==.Worrier:AwAICAYABAoAAA==.',Wy='Wylds:AwAFCAUABAoAAR0AZAAECAoABRQ=.Wynds:AwAECAoABRQCHQAEAQgKAABkAN4BBRQAHQAEAQgKAABkAN4BBRQAAA==.',Xi='Xiaozhi:AwEECAgABAoAAA==.',Xm='Xmone:AwACCAIABAoAAA==.',Xz='Xzariana:AwAECAcABAoAAA==.',Ya='Yakub:AwABCAEABRQCHgAIAQjuAQBa/ycDBAoAHgAIAQjuAQBa/ycDBAoAAA==.',Yo='Yoirr:AwAECAgABAoAAA==.',Ze='Zellyne:AwABCAIABRQCFAAIAQjfBABRZtUCBAoAFAAIAQjfBABRZtUCBAoAAA==.Zestt:AwAGCAoABAoAAA==.',Zo='Zorriya:AwAECAgABRQCGQAEAQjZBgAiURoBBRQAGQAEAQjZBgAiURoBBRQAAA==.Zovira:AwAFCAUABAoAARkAIlEECAgABRQ=.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end