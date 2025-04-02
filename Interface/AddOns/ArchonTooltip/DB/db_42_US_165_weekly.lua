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
 local lookup = {'Hunter-BeastMastery','DeathKnight-Frost','Evoker-Devastation','Unknown-Unknown','Warlock-Destruction','Warlock-Affliction','Priest-Shadow',}; local provider = {region='US',realm='Nazjatar',name='US',type='weekly',zone=42,date='2025-03-29',data={Ad='Adayb:AwAFCA8ABAoAAA==.',An='Anacristyno:AwAECAMABAoAAA==.',Ar='Argom:AwACCAIABAoAAA==.Ariaddne:AwAGCBEABAoAAA==.',As='Astora:AwADCAEABAoAAA==.Astrazenéca:AwACCAIABAoAAA==.',Ba='Barlow:AwAECAMABAoAAA==.',Bb='Bbldrizzy:AwABCAEABRQAAA==.',Be='Beanishunter:AwAICAEABAoAAA==.',Bi='Bigtac:AwAFCAUABAoAAA==.Binggus:AwABCAEABRQAAA==.',Bl='Blabbybootze:AwAFCAEABAoAAA==.Blighte:AwAFCBEABAoAAA==.Blondiepeblz:AwAGCAYABAoAAA==.',Bo='Bonito:AwAHCBAABAoAAA==.',Ce='Cemetery:AwAHCBMABAoAAA==.',Ch='Chimes:AwADCAMABAoAAA==.',Co='Comavok:AwABCAIABRQAAA==.',Da='Daemonbeard:AwAECAcABAoAAA==.',De='Deadergriff:AwABCAEABAoAAA==.Deathlyaura:AwAECAQABAoAAQEASLYBCAEABRQ=.Deathmark:AwABCAEABRQCAQAIAQgCGQBIto8CBAoAAQAIAQgCGQBIto8CBAoAAA==.Deathproof:AwAICAYABAoAAA==.Desunaito:AwABCAEABRQCAgAGAQiKBABcom0CBAoAAgAGAQiKBABcom0CBAoAAA==.Deviious:AwAFCAYABAoAAA==.',Dr='Dragonx:AwAFCAEABAoAAA==.Drewceratops:AwAFCAoABAoAAA==.Drimchi:AwABCAIABRQCAwAGAQg4FgA8zJYBBAoAAwAGAQg4FgA8zJYBBAoAAA==.Drossiechan:AwAHCBEABAoAAA==.',Du='Duality:AwAFCAUABAoAAQQAAAAICAoABAo=.',Eb='Ebisu:AwACCAMABAoAAA==.',El='Elvenviper:AwAFCAwABAoAAA==.',Er='Erismorn:AwACCAIABRQAAA==.',Fa='Fail:AwAFCAoABAoAAA==.Fallen:AwACCAEABAoAAA==.',Fe='Felt:AwABCAEABAoAAQQAAAAECAkABAo=.',Fi='Fiercetaco:AwAFCAIABAoAAA==.',Fr='Frankzorrzz:AwAFCAYABAoAAA==.Freshlydead:AwADCAMABAoAAA==.',Fu='Funeral:AwADCAUABRQDBQADAQg9CAA7qLIABRQABQACAQg9CABRCLIABRQABgABAQhtDQAQ50UABRQAAA==.',['F�']='Fàstïk:AwACCAIABAoAAA==.',Ga='Galladin:AwAICAQABAoAAA==.Gallory:AwAICAgABAoAAA==.',Gi='Gimmedatmouf:AwAECAUABAoAAA==.Gimmedatneck:AwADCAIABAoAAA==.',Gw='Gwenindoubt:AwAGCAUABAoAAA==.',Ha='Hamatyme:AwADCAEABAoAAA==.Haraldsson:AwACCAYABAoAAA==.Hasaro:AwAHCAYABAoAAA==.',Hw='Hwere:AwAGCAIABAoAAA==.',Il='Illuminaughd:AwAFCAIABAoAAA==.',Is='Isolde:AwAICAgABAoAAA==.',Jo='Jonsweetfox:AwADCAEABAoAAA==.',Ka='Kaymen:AwAFCA8ABAoAAA==.',Ke='Kelera:AwACCAUABAoAAA==.Kell:AwAFCBAABAoAAA==.',Ko='Kodera:AwACCAMABAoAAA==.',Ku='Kuroakuma:AwAICAgABAoAAA==.',Li='Lilbits:AwADCAMABAoAAA==.',Ma='Maylinfenora:AwAHCBAABAoAAA==.',Mi='Mikecoxwall:AwAFCAkABAoAAA==.',Mu='Murelia:AwAECAUABAoAAA==.',Pa='Palatine:AwACCAQABAoAAA==.Pariss:AwADCAEABAoAAA==.',Pe='Pemdas:AwAICAMABAoAAA==.Pewpewqt:AwADCAIABAoAAA==.',Ph='Phlawless:AwAHCBMABAoAAA==.',Pi='Pierone:AwAFCAkABAoAAA==.',Po='Pocho:AwAHCBEABAoAAA==.Pomonk:AwAFCAsABAoAAA==.Popcola:AwAECAkABAoAAA==.',Pp='Ppc:AwAFCAcABAoAAA==.',Pr='Prees:AwAFCBwABAoCBwAFAQjZJQAp/iQBBAoABwAFAQjZJQAp/iQBBAoAAA==.',Ra='Rakunan:AwAICAEABAoAAA==.Ranal:AwAHCBEABAoAAA==.Rannir:AwAICA8ABAoAAA==.',Ri='Ridic:AwAICAwABAoAAA==.',Ro='Ronal:AwABCAEABAoAAA==.Roomieboomie:AwABCAEABAoAAA==.',Ru='Runaki:AwAHCBEABAoAAA==.',Sa='Sapphii:AwAICA4ABAoAAA==.',Sh='Shaboing:AwADCAIABAoAAA==.Shadowpoke:AwACCAEABAoAAA==.Shammywrath:AwABCAEABAoAAQQAAAAICAYABAo=.Shasta:AwAHCBEABAoAAA==.',St='Statík:AwADCAUABAoAAA==.',Su='Sumnèr:AwAECAMABAoAAA==.',Ta='Talatin:AwABCAEABAoAAA==.Tardo:AwACCAIABAoAAA==.',Te='Tempis:AwAFCA0ABAoAAA==.Texie:AwAICA4ABAoAAA==.',Th='Thorýn:AwAHCA0ABAoAAA==.',Tr='Tralleth:AwACCAIABAoAAA==.Trismegistus:AwAECAEABAoAAA==.',Ty='Tylovath:AwAHCAoABAoAAA==.',Ur='Urgh:AwAFCAwABAoAAA==.',Vi='Victavia:AwACCAIABAoAAA==.',Xa='Xaxen:AwAICAcABAoAAA==.',Ya='Yahro:AwABCAEABRQAAA==.',Zo='Zordak:AwAFCBAABAoAAA==.',['Ø']='Ørsted:AwAECAgABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end