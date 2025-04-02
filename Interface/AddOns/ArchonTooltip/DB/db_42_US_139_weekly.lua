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
 local lookup = {'Priest-Holy','Priest-Discipline','Paladin-Retribution','Shaman-Restoration','Unknown-Unknown','Hunter-BeastMastery','Mage-Fire','Mage-Frost','Rogue-Assassination','Shaman-Enhancement','Warlock-Destruction','Rogue-Subtlety','Monk-Windwalker','Shaman-Elemental',}; local provider = {region='US',realm='LaughingSkull',name='US',type='weekly',zone=42,date='2025-03-29',data={Ae='Aeoliana:AwAGCAMABAoAAA==.',Ah='Aholy:AwADCAoABAoAAA==.',Al='Alakazam:AwAECAsABAoAAA==.Allastian:AwABCAEABAoAAA==.',An='Anywayz:AwADCAYABRQDAQADAQjZAgA3uPMABRQAAQADAQjZAgA3uPMABRQAAgABAQh0DwAl8DwABRQAAA==.',Ap='Apeople:AwAGCBMABAoAAA==.Applebottum:AwADCAgABAoAAA==.',As='Asikashama:AwADCAUABAoAAA==.',Av='Avanti:AwADCAUABAoAAA==.Avendeloria:AwAFCAEABAoAAA==.',Az='Azirgos:AwABCAEABAoAAA==.',['A�']='Aüra:AwABCAEABRQAAA==.',Ba='Backmoist:AwABCAEABAoAAA==.Baeden:AwABCAEABAoAAA==.Bagmaster:AwAGCBMABAoAAA==.',Be='Bedazzled:AwAECAkABAoAAA==.',Bi='Bigdawg:AwAECAQABAoAAA==.',Bl='Blazeknight:AwAFCAcABAoAAA==.Blazemaker:AwACCAQABAoAAA==.Blazemaster:AwADCAMABAoAAA==.Bluberiez:AwAHCA8ABAoAAA==.Bluberriez:AwACCAIABAoAAA==.',Bo='Bolgrom:AwADCAQABAoAAA==.Bormes:AwAICBoABAoCAwAIAQjMFABQcsgCBAoAAwAIAQjMFABQcsgCBAoAAA==.Boydik:AwAECAkABAoAAA==.',Bu='Budskee:AwACCAMABAoAAA==.Bunni:AwAFCAUABAoAAA==.Burningmagic:AwAECAsABAoAAA==.',Ce='Cemo:AwABCAEABRQDAQAHAQhTFQA+g+oBBAoAAQAHAQhTFQA9qOoBBAoAAgAFAQiMJwAtTg4BBAoAAA==.Cerberusalfa:AwAGCBMABAoAAA==.',Co='Contagion:AwAGCBEABAoAAA==.',Cr='Createen:AwAFCAsABAoAAA==.Creatlach:AwAHCBcABAoCBAAHAQjoCgBW35QCBAoABAAHAQjoCgBW35QCBAoAAQUAAAACCAMABRQ=.',Da='Darktaynt:AwABCAIABAoAAA==.Darkweb:AwACCAMABAoAAA==.',De='Demise:AwABCAEABRQAAA==.',Di='Dinomight:AwACCAIABAoAAA==.Dirkuatah:AwABCAEABRQAAA==.Divinebehind:AwAGCBEABAoAAA==.',Do='Dozeybigguns:AwAECAUABAoAAA==.',Dr='Drakin:AwAGCBAABAoAAA==.Drakzos:AwAGCAMABAoAAA==.Drandpally:AwADCAQABAoAAA==.Dre:AwAECA0ABAoAAA==.Dreya:AwAGCAIABAoAAA==.',Du='Dutchman:AwAHCBUABAoCBgAHAQiFHgBM/WMCBAoABgAHAQiFHgBM/WMCBAoAAA==.',El='Eldrene:AwADCAcABAoAAA==.Elitepaladin:AwAGCA0ABAoAAA==.',Ep='Epicsause:AwAECAEABAoAAA==.',Fa='Falkorne:AwAGCBIABAoAAA==.Fatalminn:AwAGCBMABAoAAA==.',Fr='Frassk:AwAFCAgABAoAAA==.',Fu='Fuzzybunny:AwAGCAsABAoAAA==.',Ga='Galongore:AwADCAYABAoAAQMALnYHCBsABAo=.Gaymerboii:AwAGCBIABAoAAA==.',Gi='Giä:AwAFCAkABAoAAA==.',Go='Golem:AwACCAEABAoAAA==.Gorearrow:AwAGCBMABAoAAA==.',Gr='Graniteus:AwAECAcABAoAAA==.Greygg:AwADCAQABAoAAA==.Grimstroke:AwAGCAgABAoAAA==.',He='Heal:AwAHCAYABAoAAA==.',Ho='Holier:AwAHCBAABAoAAA==.Holyatrops:AwAGCA0ABAoAAA==.',Hu='Huggieebear:AwABCAEABAoAAA==.Hurrdurr:AwAFCAkABAoAAA==.',In='Inside:AwAECAUABAoAAA==.',Ju='Jurisdiction:AwADCAcABAoAAA==.',Ka='Kamela:AwABCAEABRQAAA==.',Ko='Konrados:AwADCAQABAoAAA==.',Kr='Kronnoxx:AwAECAcABAoAAQUAAAAGCBMABAo=.Kronotek:AwAGCBMABAoAAA==.',La='Laimaster:AwACCAMABAoAAA==.Lakiri:AwADCAUABAoAAA==.Landaeda:AwADCAMABAoAAA==.',Le='Leparse:AwAHCBAABAoAAQUAAAACCAMABRQ=.Lessar:AwAFCAoABAoAAA==.',Li='Lielilia:AwAGCAEABAoAAA==.Linarissa:AwAICBAABAoAAA==.Lisalisa:AwAECAkABAoAAA==.Littlebuss:AwADCAMABAoAAA==.',Me='Medìcus:AwAGCAEABAoAAA==.Mergosh:AwAHCAoABAoAAA==.',Mi='Mike:AwECCAQABRQDBwAIAQgRDgBQBb0CBAoABwAIAQgRDgBQBb0CBAoACAADAQh4UQAwP5sABAoAAA==.',Mo='Monkey:AwAGCBIABAoAAA==.Morechie:AwAFCAIABAoAAA==.',['M�']='Mírage:AwAECAgABAoAAQUAAAAGCAkABAo=.',Na='Nashwayne:AwAICBAABAoAAA==.',Ne='Nertt:AwABCAEABAoAAA==.',No='Nooj:AwADCAkABRQCCQADAQjnAABU/iwBBRQACQADAQjnAABU/iwBBRQAAA==.Notakoala:AwAGCAkABAoAAQUAAAAGCAsABAo=.',Ob='Obviouslykk:AwAICBEABAoAAA==.',Ok='Okefenokee:AwAHCAUABAoAAA==.',Om='Omeprazole:AwABCAIABAoAAA==.',Op='Opusone:AwAECAIABAoAAA==.',Or='Orgruddon:AwAECAsABAoAAA==.Oric:AwAICBUABAoCCgAIAQjMBQBVH/MCBAoACgAIAQjMBQBVH/MCBAoAAA==.',Ph='Pherra:AwADCAQABAoAAQUAAAAGCAMABAo=.Phoivos:AwAHCAkABAoAAA==.',Pl='Plagius:AwADCAQABAoAAA==.',Pu='Puggy:AwAECAcABAoAAA==.Purebacon:AwAFCAoABAoAAA==.',Re='Resyek:AwAGCA8ABAoAAA==.',Ro='Rosyred:AwAGCAwABAoAAA==.Rowdey:AwAGCAkABAoAAA==.',Sa='Samasear:AwAECAgABAoAAA==.Sanctus:AwADCAQABAoAAA==.',Sh='Shadrad:AwADCAQABAoAAA==.Shakka:AwAFCAsABAoAAA==.Shamtastico:AwAFCAoABAoAAA==.Shantz:AwAFCAkABAoAAA==.Shirtless:AwAFCAgABAoAAA==.Shiyue:AwAGCA0ABAoAAA==.',Sk='Skik:AwAECAcABAoAAA==.',Sl='Slasure:AwAGCBMABAoAAA==.',So='Soryan:AwAECAgABAoAAA==.Souls:AwABCAEABRQCCwAHAQi/DgBPlIMCBAoACwAHAQi/DgBPlIMCBAoAAA==.',St='Stormknight:AwADCAUABAoAAA==.Stripee:AwAICBcABAoDCQAIAQi0BwBDbmICBAoACQAIAQi0BwBAu2ICBAoADAAGAQgPFAA7OpwBBAoAAA==.',Su='Supermonks:AwACCAQABRQCDQAIAQhJAwBaIy0DBAoADQAIAQhJAwBaIy0DBAoAAA==.Superoutlaw:AwACCAIABAoAAA==.Superret:AwACCAQABRQCAwAIAQgTAwBhEGsDBAoAAwAIAQgTAwBhEGsDBAoAAA==.',Sw='Swagerty:AwACCAIABAoAAA==.',Ta='Talixis:AwADCAMABAoAAA==.Tandarì:AwAFCAoABAoAAA==.',Te='Termotanque:AwAFCAcABAoAAA==.',Ti='Tie:AwAHCBcABAoCDgAHAQj/DQBNzFICBAoADgAHAQj/DQBNzFICBAoAAA==.Tizlea:AwACCAIABAoAAA==.',To='Tomraedisk:AwADCAUABAoAAA==.Tonlee:AwAECAkABAoAAA==.',Tu='Turbobuns:AwABCAEABRQAAA==.Turekk:AwADCAgABAoAAA==.',Uh='Uhnderstood:AwAGCBMABAoAAA==.',Va='Vanhossin:AwACCAQABAoAAA==.',Ve='Vedronas:AwAHCBUABAoCAwAHAQgMGwBXVJ0CBAoAAwAHAQgMGwBXVJ0CBAoAAA==.',We='Wednesdayy:AwADCAEABAoAAA==.',Wu='Wumpkin:AwADCAQABAoAAA==.',Yo='Yooni:AwADCAUABAoAAA==.',Ze='Zeri:AwADCAcABAoAAA==.',Zi='Ziiz:AwAGCAgABAoAAA==.',Zo='Zodshot:AwADCAUABAoAAA==.Zooboo:AwACCAIABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end