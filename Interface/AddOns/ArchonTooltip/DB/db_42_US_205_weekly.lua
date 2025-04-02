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
 local lookup = {'Warlock-Demonology','Warlock-Destruction','Warrior-Fury','DeathKnight-Frost','DeathKnight-Unholy','DeathKnight-Blood','Evoker-Devastation','Monk-Brewmaster','Warlock-Affliction','Druid-Restoration','Monk-Mistweaver','Mage-Fire','Unknown-Unknown','DemonHunter-Vengeance','Warrior-Arms','Warrior-Protection','Evoker-Preservation','Priest-Discipline','Priest-Holy','Shaman-Elemental','Paladin-Retribution','Shaman-Restoration','Paladin-Holy','Rogue-Subtlety','Druid-Feral','Hunter-BeastMastery','DemonHunter-Havoc','Mage-Frost','Evoker-Augmentation',}; local provider = {region='US',realm='Stonemaul',name='US',type='weekly',zone=42,date='2025-03-28',data={Aa='Aannte:AwAECAkABRQDAQAEAQgpAQA/nrIABRQAAgADAQh5BAA/y/MABRQAAQACAQgpAQBA2rIABRQAAA==.',Ad='Addalar:AwADCAMABAoAAA==.',Ah='Ahrianna:AwAECAgABRQCAwAEAQgoAgA00F8BBRQAAwAEAQgoAgA00F8BBRQAAA==.',Al='Alyaa:AwACCAQABAoAAA==.',An='Anzak:AwADCAYABAoAAA==.',Aw='Awoozehl:AwADCAIABRQEBAAIAQgmAQBgrjsDBAoABAAIAQgmAQBbdjsDBAoABQAIAQi+BQBarAIDBAoABgABAQiRNABcCWEABAoAAA==.',Az='Azgrodon:AwAFCAEABAoAAA==.',Ba='Bangmonk:AwABCAEABRQAAQcASs8ECAkABRQ=.',Be='Beleaves:AwAECAoABRQCCAAEAQjPAAAuXwkBBRQACAAEAQjPAAAuXwkBBRQAAA==.Bepsilock:AwAECAkABRQDCQAEAQiXAAAzmUYBBRQACQAEAQiXAAAzmUYBBRQAAgACAQhbCgAufZYABRQAAA==.',Bi='Bifurious:AwADCAMABAoAAA==.',Bl='Bloodgeon:AwACCAUABAoAAA==.',Br='Broccoliz:AwEECAoABRQCCgAEAQibAQAlbygBBRQACgAEAQibAQAlbygBBRQAAA==.',Bu='Bukhaki:AwAICBIABAoAAA==.',Co='Combination:AwABCAIABRQCCwAGAQgCFQBNvQACBAoACwAGAQgCFQBNvQACBAoAAA==.Corell:AwACCAIABAoAAQwARV0HCBQABAo=.',Da='Dancehall:AwAGCBAABAoAAA==.Darthdiddyus:AwADCAYABAoAAA==.Datlock:AwAECAEABAoAAA==.Datpally:AwAFCAUABAoAAA==.Dawnnie:AwAGCA4ABAoAAA==.',De='Deathpacman:AwADCAMABAoAAQ0AAAAGCA4ABAo=.',Di='Dirtydinker:AwAFCAYABAoAAA==.',Do='Donny:AwAECAUABAoAAA==.Dottprepared:AwAECAoABRQCDgAEAQhqAAA8JEYBBRQADgAEAQhqAAA8JEYBBRQAAA==.',Dr='Dradow:AwAGCAwABAoAAA==.Draul:AwACCAIABAoAAQ0AAAAFCAEABAo=.Drexl:AwACCAQABRQDDwAIAQhTBgBAwpwCBAoADwAIAQhTBgBAwpwCBAoAEAABAQg+KAATIh0ABAoAAA==.',Eg='Eggfooyung:AwACCAUABRQCCwACAQgbCQAuCqIABRQACwACAQgbCQAuCqIABRQAAA==.',Et='Ether:AwAFCAUABAoAAA==.',Ev='Evoulker:AwAECAgABRQCEQAEAQgfAABY0ZABBRQAEQAEAQgfAABY0ZABBRQAAA==.',Fa='Fabled:AwADCAMABAoAAA==.Fairytale:AwADCAYABRQDEgADAQgiBAAuKOQABRQAEgADAQgiBAAuKOQABRQAEwABAQgDDgAyCUEABRQAAA==.',Fi='Fists:AwAGCA8ABAoAAA==.',Fo='Foxypacman:AwADCAMABAoAAQ0AAAAGCA4ABAo=.',Ga='Gabryal:AwAGCAgABAoAAA==.Gallywix:AwAECAkABRQCFAAEAQj+AABF4EUBBRQAFAAEAQj+AABF4EUBBRQAAA==.',Ge='Georg:AwAECAcABRQCFQAEAQgXAwA3skoBBRQAFQAEAQgXAwA3skoBBRQAAA==.',Go='Gorasamaul:AwABCAEABRQCFgAIAQgaHQAxmdQBBAoAFgAIAQgaHQAxmdQBBAoAAA==.',Gr='Gregorz:AwABCAEABAoAAA==.',Gu='Guwudanielle:AwAECAcABRQCAgAEAQg/AwAcLxABBRQAAgAEAQg/AwAcLxABBRQAAA==.',He='Hexappeal:AwACCAIABAoAAA==.',Ic='Iconicmax:AwACCAIABAoAAA==.',Il='Ilweaver:AwAGCA4ABAoAAA==.Ilyiana:AwADCAgABRQCDAADAQikCAA9HfsABRQADAADAQikCAA9HfsABRQAAA==.',Is='Isabella:AwACCAIABAoAAQIAHC8ECAcABRQ=.',Ja='Jaqen:AwAFCAgABAoAAQ0AAAAGCAcABAo=.',Je='Jereico:AwAECAkABRQCBwAEAQiIAQA8s1sBBRQABwAEAQiIAQA8s1sBBRQAAA==.Jeryhn:AwADCAYABRQCFwADAQjpAQBHX/wABRQAFwADAQjpAQBHX/wABRQAAA==.',Ju='June:AwADCAgABRQCCwADAQjABQAq1uwABRQACwADAQjABQAq1uwABRQAAA==.',Ka='Kaida:AwACCAIABAoAAA==.',Kh='Khrezin:AwAGCAEABAoAAA==.',Ko='Koreth:AwADCAgABRQCGAADAQhuAwA0GAwBBRQAGAADAQhuAwA0GAwBBRQAAA==.',La='Lailaysia:AwAHCAEABAoAAA==.Laríca:AwABCAEABRQAAA==.Lavabursting:AwAGCAcABAoAAA==.Laydoutyota:AwAGCA0ABAoAAA==.',Li='Lilea:AwAGCA0ABAoAAA==.',Ma='Mababangong:AwABCAEABRQAAQcASs8ECAkABRQ=.Malachite:AwACCAEABAoAAA==.Manabananas:AwAECAgABRQCDAAEAQh+AgBJr24BBRQADAAEAQh+AgBJr24BBRQAAA==.',Mo='Mohit:AwAFCAUABAoAAA==.',Mv='Mvqchx:AwADCAUABAoAAA==.',Na='Narib:AwADCAMABAoAAQ0AAAADCAMABAo=.',Pa='Palaoben:AwAICAkABAoAAA==.Pasqualino:AwACCAIABAoAAA==.Passionate:AwADCAcABAoAAA==.',Ph='Phatmidas:AwACCAIABAoAAA==.',Pi='Pickle:AwACCAIABAoAAA==.Pillidan:AwAECAoABRQCDgAEAQh7AABF6UEBBRQADgAEAQh7AABF6UEBBRQAAA==.',Pl='Plutonyus:AwAFCAoABAoAAA==.',Po='Pounces:AwABCAEABRQCGQAIAQiMAgBLH9kCBAoAGQAIAQiMAgBLH9kCBAoAAA==.',Pr='Procter:AwAGCAkABAoAAA==.',Ra='Rautha:AwAFCAUABAoAAQ0AAAAICA4ABAo=.',Rh='Rhaegal:AwAHCAkABAoAAA==.',Ro='Robopacman:AwAGCA4ABAoAAA==.Rodstewart:AwADCAUABRQCGgADAQiCCAA4IPIABRQAGgADAQiCCAA4IPIABRQAAA==.',Sa='Savv:AwAECAkABRQCGwAEAQgHAQBV8JkBBRQAGwAEAQgHAQBV8JkBBRQAAA==.',Sh='Shockbull:AwACCAEABAoAAA==.Shruikan:AwADCAEABAoAAA==.',Sn='Snacks:AwADCAUABAoAAA==.',Sp='Spacelaces:AwAICBAABAoAAA==.Spaceship:AwAICA4ABAoAAA==.',Su='Subtox:AwACCAQABAoAAA==.',['S�']='Sêp:AwACCAMABAoAAA==.',To='Tolun:AwAHCBgABAoCHAAHAQiTDQBKp2MCBAoAHAAHAQiTDQBKp2MCBAoAAA==.',Tr='Troubly:AwAFCAQABAoAAA==.',Va='Valdi:AwADCAEABAoAAA==.',Vi='Vicarious:AwAGCAUABAoAAA==.',Wa='Waffledaßoy:AwADCAEABAoAAA==.Waobby:AwABCAIABAoAAA==.',Wh='Whodatdk:AwAFCAgABAoAAA==.',Wi='Wizzyy:AwAGCAwABAoAAA==.',Xa='Xaiahealwing:AwABCAEABRQEEQAGAQhlDQAiDT0BBAoAEQAGAQhlDQAiDT0BBAoABwABAQiPNgAO/S0ABAoAHQABAQhuBgAOVyEABAoAAA==.',Xg='Xgamingarc:AwAHCBQABAoDDAAHAQibKwAoaZ4BBAoADAAHAQibKwAoaZ4BBAoAHAAEAQhgSQAd97EABAoAAA==.',Yo='Yoduh:AwAGCAsABAoAAA==.Yoruichii:AwADCAMABAoAAA==.',Za='Zarathustra:AwACCAIABAoAAA==.',Zy='Zynjamin:AwAHCAQABAoAAA==.',['Ð']='Ðrèamless:AwAECAgABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end