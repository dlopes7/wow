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
 local lookup = {'Druid-Feral','Hunter-Marksmanship','Hunter-BeastMastery','Unknown-Unknown','Warrior-Protection','Shaman-Restoration','DeathKnight-Blood','Monk-Mistweaver','Shaman-Enhancement','Warlock-Affliction','Warrior-Arms','Warrior-Fury','Paladin-Retribution','Paladin-Protection','Monk-Windwalker','Priest-Shadow','Evoker-Devastation','DeathKnight-Unholy','DeathKnight-Frost','Warlock-Destruction','Warlock-Demonology','DemonHunter-Vengeance','Shaman-Elemental',}; local provider = {region='US',realm='Daggerspine',name='US',type='weekly',zone=42,date='2025-03-29',data={Ae='Aelaravia:AwABCAIABAoAAA==.Aethorn:AwACCAMABAoAAA==.',Ah='Ahuli:AwAICAgABAoAAQEAS8IBCAEABRQ=.',Ak='Akorlos:AwAHCAEABAoAAA==.Akorys:AwAFCAoABAoAAA==.',Al='Alandrodil:AwAGCA8ABAoAAA==.Alarysa:AwAHCBgABAoDAgAHAQg4CwBNRy4CBAoAAgAGAQg4CwBUbC4CBAoAAwADAQiqcwA3HNMABAoAAA==.Allybabalove:AwACCAIABAoAAA==.Allystra:AwAGCA4ABAoAAQQAAAABCAIABRQ=.',An='Anthe:AwAICAgABAoAAA==.Anwir:AwABCAEABAoAAA==.',Ar='Aratakiss:AwAGCAYABAoAAA==.Armius:AwAFCAoABAoAAA==.',Ax='Axemage:AwAHCAcABAoAAA==.',Az='Azzrael:AwAICBgABAoCBQAIAQg4DQAch1IBBAoABQAIAQg4DQAch1IBBAoAAA==.',Ba='Bagu:AwAFCAgABAoAAA==.',Bi='Bigolhuntard:AwAGCAIABAoAAA==.',Bl='Blazingbrews:AwACCAIABAoAAA==.Blindtide:AwABCAEABRQCBgAIAQjzIgAnOLEBBAoABgAIAQjzIgAnOLEBBAoAAA==.Bllur:AwAGCAYABAoAAA==.Bløøms:AwAICAgABAoAAA==.',Bo='Boombóx:AwAGCAcABAoAAA==.',Br='Bronzzi:AwADCAMABAoAAA==.Brrdingle:AwADCAUABAoAAA==.',Bu='Bubbayagafor:AwADCAMABAoAAA==.',Ca='Candez:AwAFCA0ABAoAAA==.',Ch='Chinder:AwAECAcABAoAAA==.Choggamik:AwABCAEABAoAAA==.',Co='Constatine:AwACCAIABAoAAA==.',Cr='Crafty:AwABCAEABAoAAA==.Cremesodax:AwAGCAsABAoAAA==.Crumbgutters:AwABCAEABAoAAA==.',Da='Dallthyrian:AwABCAEABRQAAA==.Dalthyyrian:AwAGCAoABAoAAQQAAAABCAEABRQ=.Darkndspooky:AwAFCAEABAoAAA==.Darkshock:AwAGCAEABAoAAA==.Darlough:AwACCAMABAoAAA==.',De='Deathlydeath:AwAECAoABAoAAA==.Debbydowner:AwACCAEABAoAAA==.Decado:AwAFCAgABAoAAA==.Deekend:AwABCAEABAoAAA==.Demoncas:AwACCAIABAoAAA==.Denimwar:AwAFCAoABAoAAA==.Dergiesmalls:AwACCAIABAoAAA==.',Dh='Dhalian:AwADCAIABAoAAA==.',Dk='Dkalliru:AwAGCAEABAoAAA==.',Do='Docfreez:AwAGCAcABAoAAA==.',Dr='Drbaobuns:AwADCAEABAoAAA==.Dreamerpala:AwACCAIABAoAAA==.Dreima:AwABCAEABAoAAA==.Drlocktapus:AwAGCAgABAoAAA==.Drtatersalad:AwABCAEABAoAAQQAAAADCAEABAo=.',Dy='Dyraxes:AwACCAIABAoAAA==.',Eb='Ebolabeef:AwACCAIABAoAAQQAAAAICA0ABAo=.',Ej='Ejisaint:AwABCAEABRQCBwAIAQiDEgAuzbgBBAoABwAIAQiDEgAuzbgBBAoAAA==.',El='Eleshan:AwABCAEABAoAAA==.Elezain:AwAHCAoABAoAAA==.',Em='Embedded:AwADCAIABAoAAA==.',En='Enël:AwACCAIABAoAAA==.',Et='Etherwing:AwAGCAwABAoAAA==.',Ex='Excruciator:AwAFCAwABAoAAA==.',Fa='Falloutz:AwAFCAUABAoAAA==.Farrkel:AwACCAIABAoAAA==.Fawxette:AwABCAIABRQAAA==.',Fe='Feeza:AwAFCAgABAoAAQgAFSkCCAUABRQ=.Feldrunk:AwAFCAsABAoAAA==.Feral:AwAFCAUABAoAAA==.Fezzek:AwACCAIABAoAAA==.',Ff='Ffxivraider:AwACCAQABRQCCQAIAQhDDwA+dkoCBAoACQAIAQhDDwA+dkoCBAoAAA==.',Fr='Frostyfreezy:AwAECAUABAoAAA==.',Fu='Fuzzycoochy:AwAHCAsABAoAAA==.',Ga='Gaurdianofow:AwAECAkABAoAAA==.',Gh='Ghostreveri:AwAFCAUABAoAAA==.Ghoulface:AwAFCAkABAoAAQoAPSQDCAUABRQ=.',Gi='Gingeroid:AwACCAEABAoAAA==.',Go='Golixza:AwABCAEABRQDCwAIAQjGAwBdiOsCBAoACwAHAQjGAwBeOusCBAoADAAFAQiwJQBLBaMBBAoAAA==.Gooncannon:AwAICAkABAoAAA==.',Gr='Grenthar:AwAECAMABAoAAA==.',Gu='Guerra:AwABCAEABAoAAA==.',Ha='Hashaa:AwACCAEABAoAAA==.',Hi='Histaint:AwAGCAIABAoAAA==.',Hu='Hugoman:AwAHCAoABAoAAA==.Huni:AwABCAEABAoAAA==.',Hy='Hydealyn:AwAECBEABAoAAA==.Hygea:AwAECAUABAoAAA==.',Ia='Iamyu:AwAECAEABAoAAA==.',Il='Illsmiteu:AwACCAQABRQAAA==.',Im='Imsomadbro:AwAFCAYABAoAAQ0AWS4CCAIABRQ=.',Ja='Jawbreak:AwADCAQABAoAAA==.',Jo='Jonesey:AwAGCBMABAoAAA==.Joreion:AwAGCA0ABAoAAA==.',Ka='Kahmaul:AwAICA0ABAoAAA==.Kalrendion:AwADCAkABAoAAA==.',Kh='Khorrin:AwACCAIABAoAAA==.',Ko='Koragg:AwACCAIABAoAAA==.Kout:AwAHCA8ABAoAAA==.',Kr='Krahlmak:AwABCAEABAoAAQQAAAAICA0ABAo=.Krigtolan:AwAICAgABAoAAQEAS8IBCAEABRQ=.',Le='Lelou:AwABCAEABRQAAA==.',Lf='Lfrith:AwAHCBIABAoAAA==.',Li='Lilathiaa:AwAECAIABAoAAA==.Lilîth:AwADCAQABAoAAA==.Liondori:AwACCAIABRQCDgAHAQgjBgBRjXgCBAoADgAHAQgjBgBRjXgCBAoAAA==.',Lm='Lmj:AwADCAcABAoAAA==.',Lo='Loikmonk:AwAFCAsABAoAAA==.',Lu='Lusk:AwABCAEABAoAAA==.',Ma='Mackschmack:AwABCAEABRQCDwAHAQjdEAA/lCMCBAoADwAHAQjdEAA/lCMCBAoAAA==.Maelmael:AwAFCAEABAoAAA==.Malrahn:AwAECAgABAoAAQQAAAAICA0ABAo=.Maraverly:AwAGCAYABAoAARAARPYICBgABAo=.',Me='Meddina:AwAFCAQABAoAAA==.Meimeimello:AwADCAMABAoAAQQAAAAECAgABAo=.Mellomeii:AwAECAgABAoAAA==.Melloollem:AwADCAMABAoAAQQAAAAECAgABAo=.',Mo='Monkatilt:AwAICA8ABAoAAA==.Moosers:AwAFCAQABAoAAA==.Morgañya:AwACCAIABAoAAQQAAAABCAIABRQ=.',Mu='Mudbutbrooks:AwADCAIABAoAAA==.',My='Myntefresh:AwAHCBAABAoAAA==.',Ne='Needhealz:AwAGCA8ABAoAAA==.Nezbirn:AwABCAEABAoAAA==.',Ni='Nidormi:AwAECAkABAoAAA==.',Nj='Njamani:AwABCAEABRQCAQAHAQg7BABLwoECBAoAAQAHAQg7BABLwoECBAoAAA==.',No='Notpyrada:AwADCAYABAoAAA==.',Nu='Nurspepper:AwAFCAMABAoAAA==.',Ny='Nyalore:AwAHCBMABAoAAA==.',Ok='Oktar:AwABCAEABRQAAA==.',Or='Oralen:AwAICBAABAoAAA==.Ordos:AwABCAEABRQCDQAIAQiiJQBFM10CBAoADQAIAQiiJQBFM10CBAoAAA==.',Ov='Overloader:AwAECAMABAoAAA==.',Oz='Ozempicjones:AwAHCAwABAoAAA==.',Pa='Partymchardy:AwABCAEABAoAAA==.',Pl='Pliyahs:AwAGCBMABAoAAA==.',Po='Pocketrocket:AwAGCAsABAoAAA==.',Py='Pyradin:AwAGCAsABAoAAA==.',Ra='Rageslave:AwEECAUABAoAAA==.Ramknight:AwADCAcABAoAAA==.',Re='Realistneil:AwAICBAABAoAAA==.Reck:AwAGCBEABAoAAA==.Repte:AwACCAUABAoAAA==.Restorooter:AwAHCAsABAoAAA==.',Ru='Ruibash:AwAGCAMABAoAAA==.Runè:AwACCAEABAoAAA==.',Se='Seldav:AwAHCBUABAoCEQAHAQgMFgAnKZkBBAoAEQAHAQgMFgAnKZkBBAoAAA==.Serrilyn:AwAHCA0ABAoAAA==.',Sh='Shamanater:AwADCAgABAoAAA==.',Si='Singlepull:AwABCAIABAoAAA==.Sinthein:AwAFCAUABAoAAA==.Sithax:AwADCAUABAoAAQQAAAAGCAsABAo=.',Sk='Skolandbones:AwAGCBQABAoDEgAGAQjHMAA0Z0YBBAoAEgAFAQjHMAAy4UYBBAoAEwAEAQgFFAAn2eoABAoAAA==.',Sl='Slabboy:AwAECAQABAoAAA==.',Sn='Snapping:AwAECAQABAoAAA==.',So='Sophillia:AwABCAEABAoAAA==.Sotan:AwAFCAsABAoAAA==.',Sp='Sparowprince:AwABCAEABRQCDQAIAQj7IwBIGWYCBAoADQAIAQj7IwBIGWYCBAoAAA==.',St='Steelshotz:AwABCAEABAoAAA==.Stellarum:AwAECAIABAoAAA==.Stormykitty:AwAICAgABAoAAA==.Striderdh:AwAGCBAABAoAAA==.Sturtza:AwAICBgABAoCAwAIAQiOHABErHICBAoAAwAIAQiOHABErHICBAoAAA==.',Sy='Sycotix:AwAICAgABAoAAA==.',Ta='Taleigha:AwAFCA4ABAoAAA==.Talisaie:AwABCAEABRQECgAHAQgQAwBZeUsCBAoACgAGAQgQAwBWjEsCBAoAFAAFAQgEJgBWDLsBBAoAFQACAQjgJABXkrwABAoAAA==.',Th='Thickrickk:AwAFCA8ABAoAAA==.Thingytoo:AwADCAMABAoAAA==.Thundis:AwACCAQABAoAAA==.',Tr='Travarii:AwAFCAsABAoAAA==.',Tu='Tums:AwAECAUABAoAAA==.Turandot:AwAECAEABAoAAA==.',Tw='Twixy:AwABCAEABAoAAA==.',Ty='Tylenill:AwACCAEABAoAAA==.',['T�']='Tìlted:AwABCAMABRQCAwAIAQgIBABeIVYDBAoAAwAIAQgIBABeIVYDBAoAAA==.',Ur='Uryuuishida:AwACCAIABAoAAA==.',Va='Valvalon:AwAECAgABAoAAA==.Valëria:AwAHCAoABAoAAA==.Vandrictus:AwAFCAcABAoAAQQAAAAGCAEABAo=.Vandroin:AwAICBcABAoCFgAIAQjtBwBEVlICBAoAFgAIAQjtBwBEVlICBAoAAA==.',Ve='Veelaria:AwADCAMABAoAAA==.',Vi='Vicalaus:AwAECBAABAoAAA==.Viridyana:AwADCAIABAoAAA==.',Wi='Wiidge:AwADCAMABAoAAA==.',Xa='Xantry:AwACCAIABRQDDQAIAQjEDwBZLvECBAoADQAIAQjEDwBZLvECBAoADgABAQh2QQAQQRoABAoAAA==.',Ze='Zenfox:AwACCAIABAoAAA==.Zengen:AwAFCAoABAoAAA==.Zephyrion:AwAECAcABAoAAA==.',Zu='Zubkarra:AwAICBgABAoCFwAIAQjxCABP76oCBAoAFwAIAQjxCABP76oCBAoAAA==.',['Ä']='Älcatraz:AwAGCAEABAoAAA==.',['ß']='ßløøms:AwAFCAgABAoAAQQAAAAICAgABAo=.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end