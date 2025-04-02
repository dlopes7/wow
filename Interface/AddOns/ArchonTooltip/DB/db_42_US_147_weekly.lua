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
 local lookup = {'Warlock-Demonology','Priest-Discipline','Shaman-Restoration','Evoker-Devastation','Hunter-Survival','DeathKnight-Unholy',}; local provider = {region='US',realm='Maelstrom',name='US',type='weekly',zone=42,date='2025-03-29',data={Ag='Aggronor:AwAGCA4ABAoAAA==.',Al='Altair:AwAECAEABAoAAA==.',Am='Amitalire:AwABCAEABRQAAA==.',An='Anned:AwADCAYABAoAAA==.',Ar='Arianá:AwACCAIABAoAAA==.',Au='Auróra:AwAICBgABAoCAQAIAQguAQBPHfsCBAoAAQAIAQguAQBPHfsCBAoAAA==.',Ba='Barve:AwADCAYABAoAAA==.',Ch='Chkemedaddy:AwADCAMABAoAAA==.',Dd='Ddrackattack:AwAHCBMABAoAAA==.',El='Elochian:AwAGCA8ABAoAAA==.',Er='Eriktherod:AwAGCAoABAoAAA==.',Fr='Fredò:AwACCAMABAoAAA==.',Fu='Fuzzykat:AwAICAgABAoAAA==.',Ho='Holythis:AwAGCA0ABAoAAA==.',Ik='Ikaruz:AwAHCAIABAoAAA==.',Ir='Irónknuckle:AwAGCAEABAoAAA==.',Ja='Janelik:AwACCAMABAoAAA==.',Jo='Jofixit:AwAGCBAABAoAAA==.',Ka='Kaddy:AwABCAIABRQCAgAIAQhAGAAp/pkBBAoAAgAIAQhAGAAp/pkBBAoAAA==.Kambucha:AwAGCA0ABAoAAA==.Katyli:AwACCAQABRQCAwAIAQj7CABQSbACBAoAAwAIAQj7CABQSbACBAoAAA==.',Ke='Keihas:AwAHCBcABAoCBAAHAQj8DQBGPCYCBAoABAAHAQj8DQBGPCYCBAoAAA==.',Ko='Kozanu:AwACCAIABAoAAA==.',Li='Lilpeggyhill:AwAGCAMABAoAAA==.',Me='Mehri:AwADCAQABAoAAA==.',Ms='Msdeath:AwADCAkABAoAAA==.',Na='Naois:AwADCAQABAoAAA==.Nashalion:AwAECAcABAoAAA==.',Ni='Nishalle:AwACCAMABAoAAA==.',No='Nodarf:AwADCAUABAoAAA==.',Pa='Panda:AwADCAcABRQCBQADAQgrAABDhhEBBRQABQADAQgrAABDhhEBBRQAAA==.Pawl:AwACCAIABRQCBgAIAQgXEABG9GICBAoABgAIAQgXEABG9GICBAoAAA==.',Po='Pocketank:AwAGCAEABAoAAA==.',Pr='Probono:AwADCAUABAoAAA==.',Pu='Puffymuffins:AwABCAEABRQAAA==.',Re='Revini:AwAFCA8ABAoAAA==.',Ro='Roadkilldk:AwAGCAMABAoAAA==.',Ry='Ryuma:AwAFCAEABAoAAA==.',Sa='Sabrina:AwAECAYABAoAAA==.Sang:AwACCAIABAoAAA==.',Sh='Shaunara:AwAGCBMABAoAAA==.',So='Solas:AwAFCAIABAoAAA==.',Su='Supermassive:AwAGCAkABAoAAA==.',To='Tohruu:AwAFCBAABAoAAA==.',Tr='Traydori:AwAFCAMABAoAAQEATx0ICBgABAo=.',Tw='Tweedledumm:AwADCAIABAoAAA==.',Ve='Vedredis:AwACCAIABAoAAA==.',Vi='Vilehatred:AwADCAYABAoAAA==.',Vo='Vokenntrot:AwAICA8ABAoAAA==.',Zo='Zodijackyl:AwABCAIABRQAAA==.',Zy='Zylph:AwADCAYABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end