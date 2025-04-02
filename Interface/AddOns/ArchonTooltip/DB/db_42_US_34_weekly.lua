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
 local lookup = {'Shaman-Enhancement','Unknown-Unknown','Rogue-Assassination','Warlock-Demonology','Warlock-Affliction','Warlock-Destruction','Warrior-Arms','Hunter-BeastMastery','Hunter-Survival','Mage-Frost','Monk-Brewmaster','Warrior-Fury','DemonHunter-Havoc','Mage-Fire',}; local provider = {region='US',realm='BlackwaterRaiders',name='US',type='weekly',zone=42,date='2025-03-29',data={Ah='Ahskiskiski:AwADCAUABAoAAQEASaQBCAEABRQ=.',Al='Alba:AwADCAcABAoAAQIAAAAFCBEABAo=.',An='Andezard:AwADCAoABAoAAA==.',At='Athenaowl:AwAECAgABAoAAA==.',Au='Autonomic:AwAFCAoABAoAAA==.',Ay='Ayanoriko:AwABCAIABRQCAwAGAQiOCQBZjC8CBAoAAwAGAQiOCQBZjC8CBAoAAA==.',Be='Beans:AwAICBgABAoEBAAIAQj9BQBUliICBAoABAAGAQj9BQBVpiICBAoABQADAQjBEABRugMBBAoABgACAQiUYQBJr4kABAoAAA==.',Bi='Bigstones:AwABCAIABRQCBwAGAQiXGwAgX1QBBAoABwAGAQiXGwAgX1QBBAoAAA==.Bigzappski:AwABCAEABRQCAQAIAQgLCABJpMgCBAoAAQAIAQgLCABJpMgCBAoAAA==.',Bl='Blackjêsus:AwAECAkABAoAAA==.Bloodnightz:AwADCAYABAoAAA==.',Bo='Bobbydigital:AwAGCA0ABAoAAA==.Boneandarrow:AwAICBgABAoDCAAIAQibHABJAXICBAoACAAIAQibHABJAXICBAoACQADAQjPDAA28pUABAoAAA==.',Ca='Cappuchino:AwABCAEABAoAAA==.',Ch='Chrispy:AwAFCAkABAoAAA==.Christae:AwAFCAEABAoAAA==.Christoph:AwADCAYABAoAAA==.',Cl='Cloudra:AwADCAsABAoAAA==.Clydè:AwAHCBAABAoAAA==.Cláncey:AwAGCAwABAoAAA==.',Co='Coachhazzard:AwADCAUABAoAAA==.',Cr='Crab:AwAICBcABAoCAQAIAQgFBwBS0tkCBAoAAQAIAQgFBwBS0tkCBAoAAA==.',De='Deicidê:AwAICAgABAoAAA==.',Di='Dice:AwABCAEABRQAAA==.',El='Elementalqt:AwAECAUABAoAAA==.Elira:AwAFCAoABAoAAA==.',Er='Erosis:AwABCAIABRQCCgAGAQh4CQBigaICBAoACgAGAQh4CQBigaICBAoAAA==.',Fe='Fellaria:AwEFCBAABAoAAA==.',Fi='Fistofwayne:AwAHCBQABAoCCwAHAQgXCwAixk8BBAoACwAHAQgXCwAixk8BBAoAAA==.Fitzi:AwAICBYABAoCDAAIAQhkGAAwkxwCBAoADAAIAQhkGAAwkxwCBAoAAA==.',Fl='Flavortown:AwAFCAoABAoAAA==.',Fr='Frequency:AwAECAcABAoAAA==.Frostytip:AwACCAIABAoAAA==.',Ga='Gakopozy:AwADCAYABAoAAA==.Gander:AwABCAEABAoAAQIAAAAECAYABAo=.Gandermon:AwAECAYABAoAAA==.',Ha='Haruechan:AwAFCAEABAoAAA==.Havrin:AwAECAkABAoAAA==.',He='Headhûnter:AwADCAcABAoAAA==.Headshots:AwAFCBEABAoAAA==.',Io='Iona:AwABCAIABRQAAA==.',Ja='Jackbfistn:AwACCAIABAoAAA==.',Je='Jenstar:AwABCAIABRQAAA==.',Ka='Kainslamond:AwAFCBAABAoAAA==.Katbeans:AwADCAgABAoAAA==.',La='Lahrna:AwAGCAwABAoAAA==.Laxeron:AwAFCAsABAoAAA==.',Lu='Lucrecia:AwAFCAEABAoAAA==.Lunchhbox:AwADCAsABAoAAA==.',Mc='Mcflürry:AwADCAEABAoAAA==.',Me='Medivero:AwABCAEABAoAAA==.Memenora:AwAFCAoABAoAAA==.',Mi='Misakha:AwABCAEABAoAAA==.',Mo='Momobelfas:AwACCAIABAoAAA==.Morter:AwAECAkABAoAAA==.',Na='Naruto:AwAGCA0ABAoAAA==.',Ne='Necroreign:AwAFCAkABAoAAA==.',Ni='Nightcat:AwADCAgABAoAAA==.Nitezapper:AwAICAgABAoAAA==.',No='Nobonesjones:AwAFCAgABAoAAA==.',Nu='Nulux:AwADCAEABAoAAA==.',Og='Ogwarshock:AwABCAIABRQDBQAGAQjSBgBOy7oBBAoABQAFAQjSBgBPuroBBAoABgADAQh9VABBVLsABAoAAA==.',Pa='Pastortem:AwAECAQABAoAAQQAN64HCBQABAo=.',Ph='Pharout:AwACCAEABAoAAA==.',Pr='Prépared:AwAICBYABAoCDQAIAQidGgA2zEYCBAoADQAIAQidGgA2zEYCBAoAAA==.',Py='Pyrelic:AwAHCAwABAoAAA==.',Re='Reznor:AwAHCBEABAoAAA==.',Sa='Sagertirius:AwAICAgABAoAAA==.Sakra:AwADCAgABAoAAA==.Samarawrath:AwABCAEABAoAAA==.Satanicpiro:AwAICAgABAoAAA==.',Se='Senza:AwADCAQABAoAAA==.',Sh='Shamanation:AwAECAgABAoAAA==.',Si='Simic:AwADCAUABAoAAA==.',Sk='Skunk:AwABCAIABRQAAA==.',So='Sorle:AwAFCAEABAoAAA==.',Sp='Spippey:AwACCAMABRQAAA==.',St='Strongarmkin:AwAECAYABAoAAA==.',Sv='Sveela:AwACCAYABAoAAA==.',['S�']='Sácrilege:AwAECAgABAoAAA==.',Ta='Tacocat:AwAFCAoABAoAAA==.',Te='Temlock:AwAHCBQABAoDBAAHAQgyDwA3rnMBBAoABAAFAQgyDwBAqnMBBAoABgAFAQjjPAA1vCkBBAoAAA==.',Th='Thadrus:AwAHCBEABAoAAA==.',Ti='Tinyroxy:AwAECAYABAoAAA==.',To='Toofast:AwAFCAoABAoAAA==.',Tr='Trukarak:AwAFCAwABAoAAA==.',Ty='Tyeshath:AwABCAEABRQAAA==.Tylanin:AwADCAMABAoAAA==.',Wi='Wildama:AwADCAMABAoAAA==.',Yo='Yourasmiddy:AwAICBMABAoAAA==.',Ze='Zellspell:AwAICBcABAoDDgAIAQjuFgBFx2ACBAoADgAIAQjuFgBFx2ACBAoACgACAQi6XgA4SGsABAoAAA==.',Zi='Zithenot:AwABCAEABAoAAA==.Zitzik:AwAECAYABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end