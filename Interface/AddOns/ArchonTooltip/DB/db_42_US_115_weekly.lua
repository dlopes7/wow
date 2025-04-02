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
 local lookup = {'Evoker-Devastation','Warlock-Affliction','Warlock-Demonology','Warlock-Destruction','Druid-Feral','DeathKnight-Blood','Warrior-Arms','DemonHunter-Havoc','Druid-Balance','DeathKnight-Frost','Priest-Shadow','Hunter-BeastMastery','Hunter-Marksmanship','Monk-Windwalker','Unknown-Unknown','Shaman-Enhancement','Shaman-Restoration','Mage-Fire','Mage-Frost','Priest-Holy','Warrior-Protection','Paladin-Retribution',}; local provider = {region='US',realm='Gundrak',name='US',type='weekly',zone=42,date='2025-03-29',data={An='Andronicas:AwAECAsABAoAAA==.',As='Ashbringer:AwACCAMABAoAAA==.Aspect:AwAECAQABAoAAA==.',Ba='Barmrizzussy:AwADCAcABRQCAQADAQhvBAA9LvAABRQAAQADAQhvBAA9LvAABRQAAA==.',Bi='Binhunter:AwAFCAUABAoAAA==.',Br='Brewingmist:AwADCAgABAoAAA==.',Bu='Bubblôseven:AwAECAcABAoAAA==.Bucketz:AwACCAIABAoAAA==.',['B�']='Bùcket:AwADCAcABRQEAgADAQgnAgA9bPAABRQAAgADAQgnAgA3YvAABRQAAwABAQguBQBURFIABRQABAABAQh3FgAmwEQABRQAAA==.',Ca='Caprowo:AwADCAQABAoAAA==.Castalot:AwACCAIABAoAAA==.',Cv='Cvmage:AwAFCBAABAoAAA==.',De='Desariana:AwAHCA8ABAoAAA==.',Do='Dormas:AwABCAEABAoAAA==.',Ea='Earnir:AwACCAIABAoAAA==.',El='Eldh:AwADCAgABAoAAA==.',En='Endlessly:AwABCAEABRQCBQAHAQiRBABOinMCBAoABQAHAQiRBABOinMCBAoAAA==.',Ev='Evoslex:AwAGCBIABAoAAA==.',Ex='Exo:AwACCAMABRQCBgAHAQiVDgBDRvoBBAoABgAHAQiVDgBDRvoBBAoAAA==.',Fa='Facerolleh:AwADCA0ABRQCBwADAQioAABH2TEBBRQABwADAQioAABH2TEBBRQAAA==.',Fe='Feelgoodinc:AwADCAcABAoAAA==.',Fo='Fongere:AwACCAEABAoAAA==.',Gi='Giteff:AwADCAYABRQCCAADAQj5BABVNCoBBRQACAADAQj5BABVNCoBBRQAAA==.',Gr='Grumblefluff:AwAGCBQABAoCCQAGAQiCIwBEpMcBBAoACQAGAQiCIwBEpMcBBAoAAA==.',Ho='Holdmybeer:AwAICAgABAoAAA==.',Il='Illisera:AwADCAYABAoAAA==.',Ja='Jaedastraza:AwACCAIABAoAAA==.',Ka='Kalzaketh:AwADCAUABAoAAA==.Kassana:AwAECAQABAoAAA==.',Ki='Killerman:AwADCAYABRQDCgADAQhCAQA+UcwABRQACgACAQhCAQBWV8wABRQABgABAQitDgAORTMABRQAAA==.',Kr='Kregnar:AwADCAcABAoAAA==.',Ku='Kuroha:AwAGCA0ABAoAAA==.',['K�']='Käerie:AwAECAcABAoAAA==.',La='Lapinhom:AwABCAEABRQAAA==.',Le='Lembeng:AwAFCAUABAoAAA==.',Ma='Mantisar:AwAGCAEABAoAAA==.',Mi='Mimikyu:AwADCAMABAoAAA==.Mirrorimage:AwABCAIABRQCCwAHAQi0DgBKlEkCBAoACwAHAQi0DgBKlEkCBAoAAA==.',My='Mystweäver:AwAHCBMABAoAAA==.Myxomatosis:AwADCAUABAoAAA==.',Na='Nadus:AwADCAUABAoAAA==.',Ni='Niahal:AwAGCBIABAoAAA==.',No='Novacorp:AwABCAIABRQDDAAIAQj0CgBgEgoDBAoADAAIAQj0CgBgEgoDBAoADQABAQhGQgAdWSkABAoAAA==.',Pa='Paradøx:AwADCAYABRQCDgADAQj+AQBYMDoBBRQADgADAQj+AQBYMDoBBRQAAA==.',Po='Poot:AwAGCBAABAoAAA==.',Pr='Praystätion:AwAECAQABAoAAQ8AAAAHCBMABAo=.',Ra='Raymond:AwABCAEABAoAAA==.',Ri='Riddagain:AwADCAMABAoAAA==.Riggse:AwACCAIABAoAARAATu4DCAcABRQ=.Riggsie:AwADCAcABRQDEAADAQhpAgBO7iYBBRQAEAADAQhpAgBO7iYBBRQAEQABAQjSFAAXTDwABRQAAA==.Rippa:AwAICAEABAoAAA==.',Ro='Rolltoor:AwABCAMABRQCDgAIAQhZCwBEYn0CBAoADgAIAQhZCwBEYn0CBAoAAA==.Roronoa:AwAHCA4ABAoAAA==.',Sa='Sansa:AwAHCBIABAoAAA==.Saso:AwADCAYABRQDEgADAQhzCwAoC98ABRQAEgADAQhzCwAkIt8ABRQAEwABAQgbCgA/ikUABRQAAA==.',Sc='Scroll:AwAICBAABAoAAA==.',Sh='Shamoramo:AwAICBYABAoCEAAIAQiRCwBAT4kCBAoAEAAIAQiRCwBAT4kCBAoAAA==.Shugo:AwACCAIABAoAAA==.',Si='Silphy:AwAECAUABAoAAA==.',Sk='Sky:AwACCAUABRQCFAACAQgLBwAui5MABRQAFAACAQgLBwAui5MABRQAAA==.',St='Stepmom:AwADCAMABAoAAA==.',Te='Tealç:AwAECAQABAoAARUATwIHCBsABAo=.',Th='Thalaris:AwAHCBUABAoCFgAHAQi1HQBWD4sCBAoAFgAHAQi1HQBWD4sCBAoAAA==.',Ty='Tyladrhas:AwAECAcABAoAAA==.',Va='Valth:AwAGCA8ABAoAAA==.',Vu='Vulken:AwABCAEABRQAAA==.',Wh='Whitebeard:AwAGCAYABAoAAA==.',Yo='Yoú:AwAGCAYABAoAAA==.',Zi='Zihon:AwAECAwABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end