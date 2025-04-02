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
 local lookup = {'DemonHunter-Havoc','Druid-Balance','Mage-Frost','Mage-Fire',}; local provider = {region='US',realm='Fenris',name='US',type='weekly',zone=42,date='2025-03-29',data={Aj='Ajudicater:AwAGCA8ABAoAAA==.',At='Atonement:AwAHCAgABAoAAA==.',Az='Azerennia:AwADCAUABAoAAA==.',Be='Beerless:AwADCAYABAoAAA==.Berzerkush:AwADCAYABAoAAA==.',Bl='Blinkjob:AwAFCAcABAoAAA==.',Ca='Cair:AwAICBUABAoCAQAIAQgQCgBV/vcCBAoAAQAIAQgQCgBV/vcCBAoAAA==.Catrik:AwADCAUABAoAAA==.',Co='Cocoabean:AwAHCBEABAoAAA==.',De='Deanwinchest:AwADCAMABAoAAA==.',Dr='Dragonpet:AwADCAQABAoAAA==.Drunk:AwADCAUABAoAAA==.',Ep='Epicchub:AwAGCAsABAoAAA==.',Fw='Fwan:AwAECAQABAoAAA==.',Ga='Gametheory:AwABCAEABRQAAA==.',Ge='Genge:AwADCAUABAoAAA==.Gertrex:AwADCAUABAoAAA==.',Go='Goatlord:AwABCAEABAoAAA==.',Gr='Grayfox:AwAHCA0ABAoAAA==.',Ha='Hadtorename:AwABCAEABRQCAgAHAQhtFgBNOkECBAoAAgAHAQhtFgBNOkECBAoAAA==.',In='Ineluki:AwACCAMABAoAAA==.',Ip='Ipod:AwABCAEABAoAAA==.',Ja='Jambipriest:AwAGCAIABAoAAA==.',Ka='Kalzak:AwADCAYABAoAAA==.',Ke='Kelaveil:AwACCAQABAoAAA==.',Ki='Kiwistunna:AwABCAEABAoAAA==.',Kr='Krystaline:AwADCAYABAoAAA==.',Ky='Kyriakratos:AwAFCAcABAoAAA==.',Li='Lilfist:AwAECAEABAoAAA==.',Ma='Mauklindaufe:AwAGCAEABAoAAA==.',Me='Melancholy:AwABCAEABAoAAA==.Mewjuice:AwABCAEABAoAAA==.',Mu='Murlefox:AwABCAEABAoAAA==.',Na='Natsudragnee:AwADCAUABAoAAA==.',Oc='Octaley:AwAHCA0ABAoAAA==.',Od='Odiousego:AwAECAEABAoAAA==.',Or='Orlin:AwAHCBQABAoCAwAHAQjrFQA/8Q4CBAoAAwAHAQjrFQA/8Q4CBAoAAA==.',Po='Powerhøuse:AwAGCA4ABRQCBAAGAQgmAABHKFACBRQABAAGAQgmAABHKFACBRQAAA==.',Ql='Qlaryx:AwADCAUABAoAAA==.',Qu='Quinner:AwAGCBEABAoAAA==.',Ra='Rahomira:AwAECAQABAoAAA==.Raptorw:AwAICAEABAoAAA==.',Sa='Salvaa:AwADCAUABAoAAA==.',Se='Secretkeeper:AwABCAEABAoAAA==.Seda:AwADCAUABAoAAA==.',Sh='Shiftysmash:AwAHCAkABAoAAA==.',Si='Silk:AwABCAEABAoAAA==.',Sn='Snowlord:AwABCAEABAoAAA==.',St='Starryknight:AwABCAEABAoAAA==.',Su='Summersm:AwACCAIABAoAAA==.Surtür:AwADCAcABAoAAA==.',Wa='Warglaive:AwAFCAgABAoAAA==.',Xo='Xotha:AwACCAUABAoAAA==.',Ze='Zec:AwADCAEABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end