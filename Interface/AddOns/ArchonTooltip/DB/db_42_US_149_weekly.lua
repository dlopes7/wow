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
 local lookup = {'Unknown-Unknown','Hunter-Survival','Druid-Guardian','Druid-Restoration','Mage-Fire','Warrior-Protection','Warrior-Fury','Warrior-Arms','DemonHunter-Vengeance','Paladin-Protection','Hunter-BeastMastery','DemonHunter-Havoc','Evoker-Devastation','Druid-Balance','Paladin-Retribution','Paladin-Holy','Druid-Feral',}; local provider = {region='US',realm='Maiev',name='US',type='weekly',zone=42,date='2025-03-29',data={Ab='Abilities:AwADCAMABAoAAA==.',Ai='Airwrecka:AwAECAwABAoAAA==.',Ar='Arahgon:AwAICAIABAoAAQEAAAAICAgABAo=.',Ba='Bananagirl:AwADCAMABAoAAA==.',Br='Bratlax:AwACCAIABRQAAQIAUD8DCAUABRQ=.Briz:AwABCAEABRQAAA==.',Bu='Bumpi:AwAICBUABAoDAwAIAQhiAwBVMg4CBAoAAwAFAQhiAwBgMw4CBAoABAADAQijOQArLrEABAoAAA==.',Ca='Caarcus:AwAHCAEABAoAAA==.Calculusx:AwAGCBEABAoAAA==.',Ce='Cellice:AwADCAUABRQCBQADAQiYCgAtbe0ABRQABQADAQiYCgAtbe0ABRQAAA==.',Ch='Challah:AwAGCAgABAoAAA==.Chatha:AwADCAMABAoAAA==.',Da='Daddydimes:AwABCAEABAoAAA==.',De='Deliveryboy:AwABCAEABAoAAA==.Deshield:AwAICBUABAoEBgAIAQiDDQBd6E4BBAoABwAEAQgRKwBYp3gBBAoABgADAQiDDQBgD04BBAoACAADAQgTIQBVWBkBBAoAAA==.Dewry:AwADCAQABAoAAA==.',Di='Diemertz:AwAFCAsABAoAAA==.',El='Elimere:AwAECAwABAoAAA==.Elywen:AwAGCAMABAoAAA==.',Ev='Evilzshifter:AwABCAIABRQAAA==.',Ex='Excessive:AwADCAcABAoAAA==.',Fi='Fiammetta:AwEFCAUABAoAAQkATs8DCAgABRQ=.Firemge:AwEICAgABAoAAQoAQAgECAoABRQ=.',Fu='Furionix:AwABCAEABRQAAA==.',Go='Gobiasinds:AwAECAQABAoAAA==.',Ha='Hakk:AwAGCBEABAoAAA==.',He='Heck:AwAECAgABAoAAA==.',Im='Imari:AwADCAcABRQDCwADAQi5BQBcSysBBRQACwADAQi5BQBVtSsBBRQAAgACAQhqAABQgLgABRQAAA==.',Iz='Izanamie:AwABCAEABAoAAA==.',Ja='Jachlo:AwAICAgABAoAAA==.',Ka='Kaer:AwADCAIABAoAAA==.Kaidia:AwAHCAwABAoAAA==.',Ko='Kookler:AwAECAYABAoAAA==.Kookluhh:AwADCAMABAoAAQEAAAAECAYABAo=.',Ky='Kyirr:AwACCAIABAoAAA==.Kyralen:AwAFCAgABAoAAA==.',Ma='Magicae:AwAECAQABAoAAQwAPngCCAcABRQ=.',My='Myrl:AwADCAQABAoAAA==.',Na='Navillus:AwADCAYABRQCDQADAQgzAwBXjg4BBRQADQADAQgzAwBXjg4BBRQAAA==.',No='Notavailable:AwAGCA4ABAoAAA==.',Op='Ophindis:AwAFCA4ABAoAAA==.',Or='Oreck:AwACCAEABAoAAA==.',Pe='Pewpop:AwAGCAoABAoAAA==.',Pu='Puki:AwADCAEABAoAAA==.Purification:AwADCAcABAoAAQwAPngCCAcABRQ=.',Rc='Rckola:AwABCAIABRQCDgAIAQh0BQBbWx4DBAoADgAIAQh0BQBbWx4DBAoAAA==.',Re='Rennx:AwAECAYABRQCDgAEAQinAQBFGHEBBRQADgAEAQinAQBFGHEBBRQAAA==.',Ru='Rucket:AwAHCBAABAoAAA==.',Sa='Saphari:AwEDCAgABRQCCQADAQj4AABOzxgBBRQACQADAQj4AABOzxgBBRQAAA==.Saphyr:AwEBCAEABRQAAQkATs8DCAgABRQ=.',Se='Sevfists:AwAICAgABAoAAA==.',Sh='Shadda:AwAECAgABAoAAA==.Sheesh:AwAFCA4ABAoAAA==.Shieldpapi:AwAFCAsABAoAAA==.Shinru:AwAECAgABAoAAA==.',Si='Sicktides:AwAGCAEABAoAAA==.',Sm='Smashley:AwAECAoABAoAAA==.',So='Sophie:AwABCAEABRQDDwAIAQinLgBQ7zICBAoADwAGAQinLgBVXjICBAoAEAAIAQiwCwAv0PsBBAoAAQIAUD8DCAUABRQ=.Sophisticate:AwADCAUABRQCAgADAQgiAABQPyIBBRQAAgADAQgiAABQPyIBBRQAAA==.Sox:AwAECAwABAoAAA==.',Sq='Squattinchop:AwAFCAgABAoAAA==.',St='Stormcaller:AwACCAIABAoAAQEAAAAGCA0ABAo=.',Ty='Tyranis:AwAICAgABAoAAA==.',Ve='Vee:AwAECAIABAoAAA==.',Vi='Visable:AwAFCAEABAoAAA==.',We='Welgo:AwAECAcABAoAAA==.',Wh='Whimsical:AwAECAoABAoAAA==.',Wi='Wickeddemon:AwACCAUABAoAAA==.',Yi='Yia:AwACCAcABRQCEQACAQgmAQBZqcIABRQAEQACAQgmAQBZqcIABRQAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end