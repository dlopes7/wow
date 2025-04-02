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
 local lookup = {'Priest-Shadow','Priest-Discipline','Priest-Holy','Paladin-Holy','Unknown-Unknown','Druid-Feral','DeathKnight-Unholy','Paladin-Retribution',}; local provider = {region='US',realm='Muradin',name='US',type='weekly',zone=42,date='2025-03-29',data={Am='Amaneeda:AwAECAgABAoAAA==.',An='Anotherdh:AwAECAQABAoAAA==.',Ar='Arkhorn:AwADCAEABAoAAA==.',Au='Auragasm:AwAFCAQABAoAAA==.Aurite:AwACCAYABRQEAQACAQjFBgBRw8EABRQAAQACAQjFBgBRw8EABRQAAgABAQi4CwBcSlsABRQAAwABAQjfDABWJEYABRQAAA==.',Ba='Bammbamm:AwAECAYABAoAAA==.',Be='Berñy:AwAECAcABAoAAA==.',Bo='Bovinebishop:AwAECAYABAoAAA==.',Bu='Bubba:AwACCAIABAoAAA==.Buldgeoning:AwACCAMABAoAAA==.',Da='Dahlie:AwAECAcABAoAAA==.Daliela:AwABCAEABAoAAA==.',De='Deleche:AwADCAMABAoAAA==.',Di='Dist:AwAICA8ABAoAAA==.',Dr='Dragunov:AwAECAQABAoAAA==.Dreathhammer:AwAHCBQABAoCBAAHAQjPBABYb5sCBAoABAAHAQjPBABYb5sCBAoAAA==.',Du='Dunadin:AwAECAcABAoAAA==.Duramot:AwADCAMABAoAAA==.',Ev='Evan:AwACCAIABAoAAA==.',['F�']='Fálísta:AwAFCA4ABAoAAA==.',Ga='Gampy:AwAECAcABAoAAA==.',Gr='Grumblinpal:AwADCAMABAoAAA==.',Gu='Gundyr:AwABCAEABAoAAA==.',Ho='Holyknight:AwADCAMABAoAAA==.',Il='Illvasa:AwAECAcABAoAAA==.',Ja='Jarlyss:AwAECAYABAoAAA==.',Ka='Kaiv:AwAICBEABAoAAA==.',Ki='Kielann:AwAECAQABAoAAA==.',Kl='Klonopin:AwABCAEABAoAAA==.',Le='Lebaidan:AwADCAUABAoAAA==.Legonator:AwADCAEABAoAAA==.',Lo='Loepesci:AwADCAMABAoAAA==.Lopus:AwADCAEABAoAAA==.Lostchi:AwAFCAEABAoAAA==.',Lu='Lumastus:AwAFCA0ABAoAAA==.Lunal:AwAGCA4ABAoAAA==.Lussra:AwABCAEABAoAAA==.',Ly='Lyda:AwAECAQABAoAAA==.',['L�']='Lûnitari:AwADCAEABAoAAA==.',Ma='Magicmike:AwAICAMABAoAAQUAAAAICAgABAo=.Malibubarbie:AwAECAQABAoAAA==.Maneevent:AwAICAUABAoAAA==.Marlika:AwABCAEABRQAAA==.Materesa:AwAECAcABAoAAA==.Maus:AwAFCAUABAoAAA==.',Me='Menapaws:AwACCAYABRQCBgACAQh4AQBN+rcABRQABgACAQh4AQBN+rcABRQAAA==.',Mi='Mikebot:AwAICAgABAoAAA==.Milk:AwADCAUABAoAAA==.',Mo='Moonbayne:AwAECAMABAoAAA==.',Ne='Nephlim:AwACCAYABRQCBwACAQhTBwAwxZsABRQABwACAQhTBwAwxZsABRQAAA==.',Ni='Nimbleminx:AwAECAQABAoAAA==.',No='Notaholyman:AwADCAQABAoAAA==.',Re='Reptilectric:AwADCAEABAoAAA==.Retxd:AwAECAUABAoAAA==.Reylan:AwAECAUABAoAAA==.',Ri='Ririkari:AwACCAIABAoAAA==.',Se='Sedoÿ:AwAFCA0ABAoAAA==.Semdorii:AwAECAcABAoAAA==.Seven:AwAGCBQABAoCCAAGAQhaZQArEWYBBAoACAAGAQhaZQArEWYBBAoAAA==.Sevenpaws:AwAFCAEABAoAAA==.',Sh='Shaidon:AwAFCAoABAoAAA==.',Sp='Spaxtic:AwAGCAsABAoAAA==.',Su='Supersport:AwADCAEABAoAAA==.',Th='Thauriel:AwAGCAYABAoAAA==.',Tr='Treesummoner:AwAFCAEABAoAAA==.',Tu='Tulu:AwABCAMABAoAAA==.',Va='Vasilia:AwAECAYABAoAAA==.',Ve='Venn:AwABCAMABAoAAA==.',Wo='Wompwomp:AwAFCAkABAoAAA==.Wotwind:AwAICAgABAoAAA==.',Xu='Xulong:AwABCAEABRQAAA==.',Za='Zachxd:AwABCAEABAoAAA==.',Zi='Zipit:AwAFCAgABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end