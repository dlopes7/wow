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
 local lookup = {'Hunter-BeastMastery','Druid-Balance','Unknown-Unknown','Mage-Fire',}; local provider = {region='US',realm='Goldrinn',name='US',type='weekly',zone=42,date='2025-03-29',data={Ac='Ackko:AwADCAUABAoAAA==.',Al='Alfajhor:AwAHCBAABAoAAA==.Alleriane:AwAFCAQABAoAAA==.Allunt:AwAGCA0ABAoAAA==.',An='Angraa:AwAECAEABAoAAA==.',Ar='Artronis:AwAGCAcABAoAAA==.',At='Atriuz:AwAGCAcABAoAAA==.',['A�']='Aëlius:AwAFCAMABAoAAA==.',Ba='Barbabruto:AwABCAEABRQAAA==.Battowsai:AwABCAEABRQAAA==.',Be='Beehemoth:AwADCAEABAoAAA==.Bergrj:AwAFCAQABAoAAA==.',Bo='Borne:AwADCAQABAoAAA==.',Cr='Cristcalad:AwADCAYABAoAAA==.',Da='Danoprox:AwADCAEABAoAAA==.Darklara:AwAECAcABAoAAA==.',Di='Dimeros:AwAFCAMABAoAAA==.',Do='Donora:AwADCAEABAoAAA==.Doutoritalo:AwAFCAQABAoAAA==.',Dr='Drackmontana:AwAGCAEABAoAAA==.',Fa='Faölin:AwAECAUABAoAAA==.',Fr='Freyá:AwADCAQABAoAAA==.',Gi='Giafar:AwADCAUABAoAAA==.',Gr='Gramabruxao:AwABCAEABAoAAA==.',['G�']='Gøvers:AwADCAMABAoAAA==.',Ha='Harumix:AwACCAQABAoAAA==.',Hu='Hunfox:AwAHCBYABAoCAQAHAQgKIgBJYkgCBAoAAQAHAQgKIgBJYkgCBAoAAA==.',Il='Ily:AwAECAsABAoAAA==.',Iv='Ivina:AwAECAIABAoAAA==.',Je='Jetset:AwACCAQABAoAAA==.',Ji='Jin:AwAECAYABAoAAA==.',Ju='Juaup:AwADCAQABAoAAA==.',Ka='Kalazshar:AwACCAMABAoAAA==.',Kh='Khisto:AwAFCAYABAoAAA==.',Ko='Kolerath:AwACCAMABAoAAA==.',Ky='Kyohen:AwABCAEABAoAAQIAYJsDCAYABRQ=.',['K�']='Kínder:AwABCAEABAoAAA==.Kÿdou:AwABCAEABRQAAA==.',Le='Lequinhou:AwAHCAEABAoAAA==.',Lh='Lhwei:AwAECAcABAoAAA==.',Li='Lindaah:AwAECAQABAoAAA==.Lislfox:AwAECAkABAoAAA==.',Me='Medz:AwADCAMABAoAAA==.Metamorful:AwAFCAEABAoAAA==.',Mo='Mohanninha:AwABCAEABAoAAA==.Morkhar:AwAECAkABAoAAA==.',Mu='Mubbada:AwAICA4ABAoAAA==.',Ne='Necronx:AwAFCAsABAoAAA==.',Or='Orob:AwAGCAEABAoAAA==.',Pa='Pandong:AwAECAcABAoAAA==.Parký:AwAFCAYABAoAAA==.',Pu='Punhodourado:AwACCAEABAoAAA==.',Ra='Raio:AwAGCAoABAoAAA==.',Ro='Roderik:AwAFCAkABAoAAA==.',Sa='Sanchez:AwAGCAoABAoAAA==.',Se='Sereiaa:AwAECAoABAoAAA==.',Sh='Shedo:AwAECAUABAoAAA==.',Si='Simsalabim:AwACCAIABAoAAA==.',St='Stëlla:AwABCAEABAoAAQMAAAAGCAwABAo=.',Sw='Swarlock:AwAECAYABAoAAA==.',Ta='Talandar:AwAGCA0ABAoAAA==.',Th='Thamior:AwAGCAcABAoAAA==.Thenagi:AwADCAUABAoAAQQAMAMECAcABRQ=.Thessi:AwAGCAEABAoAAA==.Thëo:AwABCAEABAoAAA==.',Va='Valus:AwAFCAQABAoAAA==.',Vy='Vygh:AwAECAUABAoAAA==.',Wm='Wmzz:AwAECAQABAoAAA==.',Wo='Wolfsokoon:AwADCAcABAoAAA==.',Yo='Yongar:AwABCAEABAoAAA==.',['Ø']='Øvesso:AwACCAEABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end