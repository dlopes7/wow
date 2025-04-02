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
 local lookup = {'Druid-Balance','Druid-Feral','Shaman-Enhancement','Shaman-Elemental','Hunter-Survival','Warrior-Arms','DeathKnight-Frost','DemonHunter-Vengeance','Priest-Holy','Priest-Shadow','Shaman-Restoration','DeathKnight-Unholy','DeathKnight-Blood','Mage-Fire','Monk-Mistweaver','Evoker-Devastation',}; local provider = {region='US',realm='TheUnderbog',name='US',type='weekly',zone=42,date='2025-03-28',data={Al='Alasong:AwAICAkABAoAAA==.',Ar='Arbys:AwAICAMABAoAAA==.',Av='Avadakedern:AwAFCAMABAoAAA==.',Bi='Bigtoop:AwACCAQABRQDAQAIAQiuBQBbSRUDBAoAAQAIAQiuBQBbSRUDBAoAAgABAQibHAAV9ToABAoAAA==.',Bu='Buddi:AwACCAQABRQDAwAIAQjDAABfBnYDBAoAAwAIAQjDAABfBnYDBAoABAAGAQiUKgAZWwUBBAoAAA==.',Ca='Caladin:AwABCAEABRQAAA==.',Ch='Chaos:AwAHCBUABAoCBQAHAQi+AABhdwEDBAoABQAHAQi+AABhdwEDBAoAAA==.',Cr='Crackbird:AwAECAcABAoAAA==.',Da='Damagexx:AwABCAEABAoAAA==.Dankula:AwACCAIABAoAAA==.Darkaged:AwABCAEABAoAAA==.',Di='Diggity:AwABCAEABAoAAA==.',Dr='Dragonboi:AwAFCAsABAoAAA==.',Em='Embolis:AwAGCBIABAoAAA==.',Ev='Evildead:AwABCAEABAoAAA==.',Gr='Graf:AwABCAEABRQCBgAIAQhtAQBa/D0DBAoABgAIAQhtAQBa/D0DBAoAAA==.',He='Hellsdk:AwAICAgABAoAAA==.Hellshunter:AwAICBEABAoAAA==.',Hi='Hiyabusa:AwACCAQABAoAAA==.',Hn='Hnp:AwACCAIABAoAAA==.',Hy='Hyukhan:AwABCAEABRQAAA==.',Ju='Judgynomnom:AwAGCAgABAoAAA==.',Ks='Kshotte:AwAHCBUABAoCBQAHAQhaAQBTXKUCBAoABQAHAQhaAQBTXKUCBAoAAA==.',La='Lanachan:AwAGCAcABAoAAA==.',Ld='Ldn:AwADCAIABAoAAA==.',Li='Liann:AwADCAQABAoAAA==.Lilwhorde:AwACCAIABAoAAA==.',['LÃ']='LÃ­onheart:AwAICAgABAoAAA==.',Me='Mellen:AwADCAUABAoAAA==.',Mi='Mistynomnom:AwAGCAwABAoAAA==.',Pa='Pak:AwAGCBIABAoAAA==.Palion:AwAECAQABAoAAA==.',Pu='Pumpsndumps:AwACCAIABAoAAA==.',Re='Relic:AwABCAIABRQCBwAIAQiIAwBFRZwCBAoABwAIAQiIAwBFRZwCBAoAAA==.',Ro='Roborizzler:AwADCAUABAoAAA==.Roykevious:AwAGCAsABAoAAA==.',['RÃ']='RÃ¢ziel:AwAECAgABAoAAA==.',Sa='Sammie:AwAGCAQABAoAAA==.Sarromand:AwAHCBUABAoCCAAHAQgmBABbIsACBAoACAAHAQgmBABbIsACBAoAAA==.Savant:AwAICAMABAoAAA==.Sayl:AwAFCBQABAoDCQAFAQgnNgAhgO0ABAoACQAFAQgnNgAhgO0ABAoACgADAQilNwAldYsABAoAAA==.',Sc='Scrap:AwAHCAMABAoAAA==.',Sh='Shamewow:AwACCAQABRQCCwAIAQi6AwBZdw4DBAoACwAIAQi6AwBZdw4DBAoAAA==.Sharkbite:AwAECAUABAoAAA==.Sheam:AwADCAMABRQCDAAIAQj5BQBYmf0CBAoADAAIAQj5BQBYmf0CBAoAAA==.',Si='Sicknnasty:AwADCAUABRQCDQADAQicAwBA6/IABRQADQADAQicAwBA6/IABRQAAA==.Sicsickly:AwACCAIABAoAAA==.',Sp='Speed:AwAFCAkABAoAAA==.',Sw='Sweaty:AwAFCA4ABAoAAA==.',Ta='Taelium:AwAECAUABAoAAQ4AOQUCCAQABRQ=.Tallanno:AwAHCBUABAoCDwAHAQjqEgBFDhkCBAoADwAHAQjqEgBFDhkCBAoAAA==.Talrip:AwAGCA0ABAoAAA==.Tandriael:AwADCAgABAoAAA==.',Tr='Tri:AwAGCAcABAoAAA==.',Un='Unholylord:AwAECAYABAoAAA==.',Ys='Ystarian:AwAFCBwABAoCEAAFAQi+GgA64kwBBAoAEAAFAQi+GgA64kwBBAoAAA==.',Zi='Zilldrax:AwAECAcABAoAAA==.',Zv='Zvsp:AwABCAEABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end