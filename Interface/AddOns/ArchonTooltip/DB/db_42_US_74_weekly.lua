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
 local lookup = {'Evoker-Augmentation','Priest-Holy','Priest-Discipline','Paladin-Retribution','Paladin-Protection','DemonHunter-Havoc','Shaman-Elemental','Shaman-Enhancement','Unknown-Unknown','DeathKnight-Frost','DeathKnight-Unholy','DeathKnight-Blood','Druid-Guardian','Druid-Restoration','Warrior-Fury','Shaman-Restoration','DemonHunter-Vengeance','Mage-Fire','Priest-Shadow','Warlock-Affliction','Warlock-Destruction','Warlock-Demonology','Rogue-Outlaw','Warrior-Arms','Rogue-Assassination',}; local provider = {region='US',realm="Drak'Tharon",name='US',type='weekly',zone=42,date='2025-03-29',data={Am='Ambulance:AwAFCAsABAoAAA==.',Az='Azif:AwABCAEABAoAAA==.',Ba='Bastas:AwAHCAEABAoAAA==.',Be='Beekro:AwAHCBUABAoCAQAHAQhRAABar7UCBAoAAQAHAQhRAABar7UCBAoAAA==.Belatink:AwAHCBUABAoDAgAHAQjwJgAjb1cBBAoAAgAHAQjwJgAjb1cBBAoAAwABAQg8WwAK1yIABAoAAA==.',Bi='Bilando:AwAHCBMABAoAAA==.Billium:AwABCAEABAoAAA==.',Bl='Bloo:AwAICAgABAoAAA==.Blueberry:AwAECAgABAoAAA==.',Ca='Carat:AwABCAEABRQDBAAIAQgJBwBe3kEDBAoABAAIAQgJBwBe3kEDBAoABQABAQhNPgAZsyMABAoAAA==.',Ch='Chainer:AwAFCA0ABAoAAA==.',Ci='Cinderella:AwACCAQABAoAAA==.',Da='Darlocke:AwACCAQABAoAAA==.',De='Denarron:AwABCAEABRQCBgAIAQiyBABae0IDBAoABgAIAQiyBABae0IDBAoAAA==.',Dr='Dragonair:AwABCAEABAoAAA==.',Du='Durgrim:AwABCAEABRQDBwAIAQg4GAAptcgBBAoABwAIAQg4GAAkF8gBBAoACAAHAQhCHgAg5n4BBAoAAA==.',El='Elph:AwAFCAwABAoAAA==.',Er='Eralanazan:AwABCAEABAoAAQkAAAADCAMABAo=.',Fe='Fellbent:AwABCAEABRQCBgAIAQjtBgBY6yIDBAoABgAIAQjtBgBY6yIDBAoAAA==.',Fr='Frostfart:AwACCAIABRQECgAIAQgVAwBPLr4CBAoACgAIAQgVAwBPLr4CBAoACwAEAQiqOQA9DAgBBAoADAABAQi5QAAU/isABAoAAA==.',Ga='Garvielloken:AwADCAUABAoAAA==.',Gh='Ghogrim:AwADCAMABAoAAA==.',Gi='Githon:AwABCAEABRQDDQAIAQgIBAA4EuYBBAoADQAIAQgIBAA4EuYBBAoADgADAQjjQwAb1n8ABAoAAA==.Githpriest:AwAFCA8ABAoAAA==.',Gr='Grogrin:AwAFCA4ABAoCDwAFAQhfJABKVK8BBAoADwAFAQhfJABKVK8BBAoAAA==.',Ha='Harlíequinn:AwAFCBIABAoAAA==.',Ho='Horelock:AwAECAQABAoAAQkAAAABCAEABRQ=.Hotsytotsy:AwABCAEABRQCEAAIAQi7GQA2yfUBBAoAEAAIAQi7GQA2yfUBBAoAAA==.',Hu='Huntington:AwAHCAsABAoAAA==.',Il='Illidanmello:AwAHCBQABAoDBgAHAQghFQBcLHkCBAoABgAGAQghFQBdUXkCBAoAEQADAQgRHgBXJAgBBAoAAA==.',Jb='Jbubbleu:AwADCAMABAoAAA==.',Je='Jessïe:AwAFCAkABAoAAA==.',Ka='Katbelle:AwAHCBUABAoCEgAHAQgPPQASUC0BBAoAEgAHAQgPPQASUC0BBAoAAA==.',Ki='Kinkykelly:AwABCAEABRQAAA==.',Kr='Krogeena:AwACCAIABAoAAA==.',Ku='Kuntìngton:AwADCAQABAoAAA==.',Lo='Loxsmith:AwAFCAUABAoAAQYAWOsBCAEABRQ=.',Ma='Mageywagey:AwACCAIABAoAAA==.',Mi='Mistafridge:AwAFCAgABAoAAQYAWOsBCAEABRQ=.',Mo='Moocelee:AwACCAIABAoAAA==.',Mu='Murk:AwACCAMABAoAAA==.',Nh='Nhasir:AwAHCBUABAoCEwAHAQhNEQBFAR8CBAoAEwAHAQhNEQBFAR8CBAoAAA==.',Ny='Nyvara:AwAICAgABAoAAA==.',Pe='Peccator:AwAHCCEABAoCAgAHAQiFBwBTQKQCBAoAAgAHAQiFBwBTQKQCBAoAAA==.Pellet:AwAFCAoABAoAAA==.',Pg='Pgw:AwABCAEABRQEFAAIAQi3AgBT41wCBAoAFAAHAQi3AgBNGFwCBAoAFQAFAQhKNQBAelQBBAoAFgABAQjWOABEWFEABAoAAA==.',Ra='Raprïest:AwADCAMABAoAAA==.',Re='Reptarr:AwAFCAkABAoAAQYAWOsBCAEABRQ=.',Ri='Riskante:AwAGCA8ABAoAAA==.',Ro='Rosehip:AwAFCA0ABAoAARcATjUBCAEABRQ=.Rosey:AwABCAEABRQCFwAIAQiJAQBONbMCBAoAFwAIAQiJAQBONbMCBAoAAA==.',Sc='Scorn:AwACCAIABAoAAA==.Scottyno:AwABCAEABRQAAA==.',Se='Sevyen:AwAICBEABAoAAA==.',Sh='Shamtreyu:AwACCAMABAoAAA==.Shriven:AwABCAEABRQEAwAIAQhBIwApUTABBAoAAgAGAQghKQAvSkgBBAoAAwAHAQhBIwAW4jABBAoAEwACAQghPAAqKXsABAoAAA==.',Si='Sins:AwAFCAsABAoAAA==.',Sl='Slothy:AwAECAcABAoAAA==.',Sn='Sneakyhand:AwAHCBUABAoCGAAHAQhgAwBg8fcCBAoAGAAHAQhgAwBg8fcCBAoAAA==.',So='Soupson:AwACCAQABAoAAA==.',St='Stealthan:AwACCAMABRQCGQAIAQgkAwBMlvMCBAoAGQAIAQgkAwBMlvMCBAoAAA==.',Te='Teagen:AwAFCAgABAoAAA==.',Th='Thedoctor:AwAICAgABAoAAA==.',To='Towa:AwAFCBIABAoAAA==.',Ug='Ughwarrior:AwAFCAwABAoAAA==.',Ur='Uroboros:AwABCAEABAoAAA==.',Xt='Xtcpaladin:AwAFCBIABAoAAA==.',Za='Zamboui:AwAICAgABAoAAA==.Zargus:AwAHCBAABAoAAA==.Zarlunce:AwAECAsABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end