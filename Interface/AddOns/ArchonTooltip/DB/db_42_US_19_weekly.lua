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
 local lookup = {'Unknown-Unknown','Hunter-Survival','Hunter-BeastMastery','Shaman-Enhancement','Shaman-Restoration','Druid-Balance',}; local provider = {region='US',realm='ArgentDawn',name='US',type='weekly',zone=42,date='2025-03-29',data={Ab='Abriel:AwACCAEABAoAAA==.',Ae='Aentharion:AwADCAUABAoAAA==.',Ai='Aileen:AwAGCAwABAoAAA==.',Al='Alahn:AwACCAMABAoAAA==.Alyssa:AwADCAMABAoAAA==.',Am='Amy:AwAFCAgABAoAAA==.',An='Andiril:AwACCAIABAoAAA==.',Ar='Arcaisme:AwAECAgABAoAAA==.',As='Ashlyngrace:AwABCAEABAoAAQEAAAAFCA4ABAo=.Astoreth:AwAFCAIABAoAAA==.',Au='Audetiang:AwAHCBAABAoAAA==.',Av='Avicena:AwAECAQABAoAAA==.Avrice:AwACCAIABAoAAA==.',Be='Belfwannabe:AwADCAIABAoAAA==.Ben:AwAECAYABAoAAA==.Bevee:AwAGCAgABAoAAA==.',Bo='Bohrnir:AwAGCAsABAoAAA==.Bouldershot:AwABCAEABAoAAA==.',Br='Brawngard:AwADCAYABAoAAA==.',Bu='Bubblesonyou:AwADCAMABAoAAA==.Burmeister:AwADCAUABAoAAA==.',Ch='Chick:AwADCAQABAoAAA==.Chunks:AwABCAEABRQAAA==.',Co='Coree:AwAFCAoABAoAAA==.',Cr='Crazyhorse:AwAICA8ABAoAAA==.Crotalhusk:AwAECAcABAoAAA==.',Da='Dathea:AwAFCAUABAoAAA==.',De='Deathbodach:AwADCAMABAoAAA==.Deathjingle:AwABCAEABRQAAA==.Decklyn:AwAGCAkABAoAAA==.Deecayed:AwADCAMABAoAAA==.Deemonic:AwADCAMABAoAAA==.Deetermined:AwADCAQABAoAAA==.Denchy:AwACCAIABAoAAA==.Deviistate:AwADCAMABAoAAA==.',Di='Disdain:AwADCAgABAoAAA==.Dispersion:AwACCAIABAoAAQEAAAADCAQABAo=.',Do='Dorden:AwAGCAwABAoAAA==.Dorilax:AwAECAYABAoAAA==.',Dr='Dracon:AwAECAcABAoAAA==.Drzapato:AwADCAMABAoAAA==.',Du='Duelpour:AwACCAIABAoAAQEAAAAGCA4ABAo=.Duncan:AwAICAgABAoAAA==.',['D�']='Dâvid:AwAECAkABAoAAA==.Dëërez:AwAFCAcABAoAAA==.',El='Elleth:AwAECAoABAoAAA==.',Ep='Epoxous:AwAFCAsABAoAAA==.',Er='Eriyasaka:AwADCAQABAoAAA==.Erodoreal:AwADCAUABAoAAA==.',Ev='Evocore:AwAGCA4ABAoAAA==.',Fa='Fayemoon:AwACCAIABAoAAA==.',Fe='Felbutton:AwADCAQABAoAAA==.',Fl='Florabelle:AwADCAUABAoAAA==.',Fo='Fozzle:AwAECAoABAoAAA==.',Fr='Francus:AwECCAQABRQDAgAIAQjNAABWQwMDBAoAAgAIAQjNAABWQwMDBAoAAwACAQjvlwAu/G4ABAoAAA==.Frenndi:AwADCAMABAoAAA==.',Fy='Fynnyntyss:AwAGCAwABAoAAA==.Fyrè:AwAGCAwABAoAAA==.',Ha='Haelynn:AwAFCA8ABAoAAA==.Harmonize:AwAGCAoABAoAAA==.',He='Hellzpawn:AwADCAMABAoAAA==.',Hu='Huhu:AwAECAcABAoAAA==.',Ic='Icyhotish:AwACCAEABAoAAA==.',In='Inflikted:AwADCAgABAoAAA==.',Iz='Izaer:AwADCAMABAoAAA==.Iziel:AwAECAkABAoAAA==.',Jo='Jorianna:AwAECAQABAoAAA==.Joru:AwAFCBAABRQCBAAFAQhGAABNRPkBBRQABAAFAQhGAABNRPkBBRQAAA==.',Ju='Justyna:AwAECAoABAoAAA==.',Ka='Kaahi:AwAECAkABAoAAA==.Kaelon:AwAICBAABAoAAA==.Kaiyne:AwAGCAgABAoAAA==.Kalaman:AwADCAMABAoAAA==.Kaomix:AwAGCA0ABAoAAA==.Katieey:AwAFCBAABRQCBQAFAQgHAABfkBYCBRQABQAFAQgHAABfkBYCBRQAAA==.Kaylyna:AwAGCAwABAoAAA==.',Ke='Keishkadin:AwADCAUABAoAAA==.Kennyloggy:AwADCAYABRQCBgADAQjLAwBcHjgBBRQABgADAQjLAwBcHjgBBRQAAA==.Kerlochk:AwACCAIABAoAAA==.Keson:AwAECAkABAoAAA==.',Ki='Kitix:AwAICAoABAoAAA==.',Ko='Kowbir:AwADCAUABAoAAA==.',Kr='Kramz:AwABCAEABAoAAA==.',Ky='Kyouya:AwAECAYABAoAAA==.',La='Laoftey:AwAFCBEABAoAAA==.',Le='Leitner:AwACCAIABAoAAA==.Lekai:AwADCAQABAoAAA==.',Li='Lifegrind:AwAECAkABAoAAA==.Lillshooter:AwADCAUABAoAAA==.Livicecia:AwAECAgABAoAAA==.',Lu='Lurik:AwAECAoABAoAAA==.Luthane:AwADCAYABAoAAA==.',Ma='Macrohunter:AwAGCAYABAoAAA==.Maepai:AwAECAgABAoAAA==.Makanai:AwAECAkABAoAAA==.Makishi:AwADCAYABAoAAA==.Mazzarzul:AwADCAMABAoAAA==.',Me='Meebles:AwAGCAwABAoAAA==.Melanna:AwADCAQABAoAAA==.Meneglaives:AwABCAEABAoAAA==.Mes:AwAGCAoABAoAAA==.Metacarpal:AwAICBAABAoAAA==.',Mi='Micklaa:AwADCAMABAoAAA==.Millenium:AwAGCAEABAoAAA==.Miracul:AwAGCAwABAoAAA==.Mizzpan:AwADCAMABAoAAA==.',Mo='Moorlight:AwAHCBIABAoAAA==.',Na='Narima:AwADCAIABAoAAA==.',Ne='Nephina:AwADCAQABAoAAA==.',Ni='Ninali:AwAECAoABAoAAA==.',Og='Ogion:AwAGCAkABAoAAA==.',Pa='Paranne:AwAGCAwABAoAAA==.',Py='Pythe:AwAGCAwABAoAAA==.',Ra='Rally:AwAECAoABAoAAA==.Ranelle:AwAGCAwABAoAAA==.Ravnyr:AwAGCAEABAoAAA==.Razekial:AwAECAkABAoAAA==.',Re='Regilock:AwAFCAsABAoAAA==.',Ro='Rolhen:AwACCAIABAoAAA==.Roquen:AwAGCAcABAoAAA==.',Ry='Rynnia:AwAECAkABAoAAA==.',Sh='Shamwhoa:AwAHCBQABAoCBQAHAQgHMgAfJlYBBAoABQAHAQgHMgAfJlYBBAoAAA==.Shellshocker:AwAGCA8ABAoAAA==.',Si='Sinõn:AwAGCAwABAoAAA==.',Sk='Skoogar:AwACCAEABAoAAA==.Skywatcher:AwADCAYABAoAAA==.',St='Stargyle:AwAECAYABAoAAA==.',Sy='Sylvanase:AwAECAYABAoAAA==.',Ta='Talasama:AwAHCBIABAoAAA==.Taniz:AwAECAgABAoAAA==.Tavis:AwADCAcABAoAAA==.',Td='Td:AwAICAUABAoAAA==.',Te='Tearinurside:AwAECAkABAoAAA==.',Th='Thaddeaus:AwAECAkABAoAAA==.Thebeefyone:AwAECAMABAoAAA==.Therizin:AwADCAYABAoAAA==.Theruz:AwADCAMABAoAAA==.Thumpette:AwADCAEABAoAAA==.Thurtus:AwAGCA8ABAoAAA==.',Tm='Tmai:AwAECAYABAoAAA==.',To='Tominaetor:AwADCAMABAoAAA==.',Ty='Tyernan:AwADCAQABAoAAA==.Tyrael:AwAGCA0ABAoAAA==.',Ug='Uglack:AwACCAIABAoAAA==.',Ur='Urgost:AwACCAIABAoAAA==.',Va='Vandill:AwADCAcABAoAAA==.Vandél:AwAFCAoABAoAAQEAAAAGCA8ABAo=.',Ve='Vena:AwAECAcABAoAAA==.',Vi='Victo:AwAFCA0ABAoAAA==.',Xi='Xipa:AwAFCBEABAoAAA==.',Ya='Yamato:AwAFCAYABAoAAA==.',Yo='Youwas:AwABCAEABRQAAA==.',Yu='Yukmouf:AwAICAkABAoAAA==.Yukvan:AwADCAMABAoAAA==.Yukwarr:AwABCAEABAoAAA==.',Za='Zarvoxaan:AwABCAEABAoAAA==.',Ze='Zeniita:AwABCAEABAoAAA==.',Zo='Zoldor:AwADCAUABAoAAA==.',['Ð']='Ðaniel:AwAECAgABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end