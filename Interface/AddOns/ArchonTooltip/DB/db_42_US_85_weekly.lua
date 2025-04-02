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
 local lookup = {'Unknown-Unknown','Monk-Mistweaver','Warlock-Destruction','Paladin-Retribution','Paladin-Protection',}; local provider = {region='US',realm='Eitrigg',name='US',type='weekly',zone=42,date='2025-03-29',data={Al='Alcina:AwADCAMABAoAAA==.Alecthegreat:AwADCAEABAoAAA==.Alys:AwACCAQABAoAAA==.',An='Annabellelee:AwAECAEABAoAAA==.',Az='Azkicker:AwACCAIABAoAAQEAAAAFCAIABAo=.',Bi='Biggiepants:AwAFCAwABAoAAA==.Bighead:AwADCAMABAoAAA==.',Ch='Chaichi:AwABCAMABRQCAgAHAQgwJQAsyHkBBAoAAgAHAQgwJQAsyHkBBAoAAA==.Chogs:AwEECAIABAoAAA==.',De='Deathweéd:AwAGCA8ABAoAAA==.',Di='Diagnosis:AwADCAcABAoAAA==.',Do='Donnabb:AwADCAMABAoAAA==.Doppey:AwAECAoABAoAAA==.',Dr='Draelas:AwADCAUABAoAAA==.',['D�']='Déx:AwADCAQABAoAAA==.',Em='Emersil:AwAFCAkABAoAAA==.',Es='Esperzoa:AwACCAIABAoAAA==.',Fo='Fordinn:AwAFCAEABAoAAA==.',Fr='Frame:AwADCAUABAoAAA==.Fruittea:AwAFCAUABAoAAA==.',Gn='Gnoodles:AwADCAEABAoAAA==.',['H�']='Hüntress:AwAFCAIABAoAAA==.',Ib='Ibaar:AwAFCAcABAoAAA==.',Jo='Jonkle:AwAECAkABAoAAA==.Jonnyhuntman:AwAFCAEABAoAAA==.',Ko='Korihor:AwADCAUABAoAAA==.',Kr='Krix:AwACCAMABAoAAA==.',Li='Liyara:AwADCAoABAoAAQEAAAADCAoABAo=.',Mc='Mcgrowlin:AwAFCAMABAoAAA==.',Me='Megenta:AwABCAEABAoAAA==.Methinks:AwADCAUABAoAAA==.',Mi='Mildoo:AwAECAoABAoAAA==.',Mo='Monq:AwAECAcABAoAAA==.Morithus:AwADCAEABAoAAA==.Morphknight:AwAICAgABAoAAA==.',Na='Na:AwAGCAEABAoAAA==.',Ne='Neeston:AwABCAEABRQAAA==.',Ob='Obsidiian:AwABCAEABAoAAA==.',Op='Operian:AwAICAgABAoAAA==.',Pa='Padivyn:AwAECAkABAoAAA==.',Py='Pyro:AwADCAoABAoAAA==.',Ra='Raue:AwAECAEABAoAAA==.',Re='Redscööter:AwAECAYABAoAAA==.',Ri='Ristvakbaen:AwAGCBAABAoAAA==.',Se='Serea:AwAICBwABAoCAwAIAQiRLgAXyoABBAoAAwAIAQiRLgAXyoABBAoAAA==.',Sh='Shimadin:AwAHCBgABAoDBAAHAQi9NABFbBYCBAoABAAHAQi9NABFbBYCBAoABQABAQgbRQAB2wcABAoAAA==.',Sj='Sjazin:AwAECAQABAoAAA==.',Sn='Sneck:AwAFCAUABAoAAA==.',So='Solbin:AwADCAMABAoAAA==.',St='Stabmu:AwACCAIABAoAAA==.',Th='Thiarap:AwACCAQABAoAAA==.Threat:AwAFCAYABAoAAA==.',Ty='Tyletos:AwAFCA8ABAoAAA==.',Va='Vargas:AwADCAMABAoAAA==.',Vo='Vonbismarck:AwAECAcABAoAAA==.',Wu='Wudeeps:AwAGCAwABAoAAA==.',['ß']='ßoomer:AwABCAEABAoAAQEAAAADCAMABAo=.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end