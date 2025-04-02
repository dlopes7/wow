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
 local lookup = {'Unknown-Unknown','Hunter-BeastMastery','Warrior-Arms','Warrior-Protection','Monk-Windwalker','Mage-Arcane','Priest-Discipline','Hunter-Survival','Paladin-Holy','Hunter-Marksmanship','Mage-Fire',}; local provider = {region='US',realm='Malygos',name='US',type='weekly',zone=42,date='2025-03-29',data={Ac='Ache:AwADCAMABAoAAA==.',Ad='Adorapewpew:AwAFCAMABAoAAA==.Adrenaline:AwADCAYABAoAAA==.',Ah='Ahri:AwAFCAMABAoAAQEAAAAFCAUABAo=.',Ar='Arcannor:AwAECAwABAoAAA==.Aribella:AwABCAEABRQCAgAGAQjWNABDNs8BBAoAAgAGAQjWNABDNs8BBAoAAA==.',Az='Azdraka:AwACCAEABAoAAA==.',Ba='Banshee:AwAECAEABAoAAA==.',Be='Belg:AwAHCBUABAoDAwAHAQhfEQA2k9wBBAoAAwAHAQhfEQA2k9wBBAoABAAGAQizDQAvJEkBBAoAAA==.',Bl='Bluenovax:AwAFCAQABAoAAA==.',Bo='Bobb:AwACCAIABAoAAA==.Boosh:AwABCAIABRQCBQAIAQhyBABUJg0DBAoABQAIAQhyBABUJg0DBAoAAA==.Booshri:AwAFCAQABAoAAA==.Bowsho:AwAFCAkABAoAAA==.',Br='Brogas:AwACCAIABAoAAA==.Brovarde:AwAICAIABAoAAA==.Brynnyn:AwABCAEABAoAAA==.',['B�']='Bëcky:AwABCAEABRQAAA==.',Ce='Cellysia:AwAECAUABAoAAA==.Ceramyth:AwAECAIABAoAAA==.Cesara:AwADCAYABAoAAA==.',Ch='Chbribs:AwABCAEABAoAAA==.Cheeseycasty:AwAICBkABAoCBgAIAQhTAABSniQDBAoABgAIAQhTAABSniQDBAoAAA==.',Cl='Claus:AwABCAEABAoAAA==.',Cr='Craze:AwABCAEABAoAAA==.',Da='Damerot:AwAECAEABAoAAA==.Dawning:AwABCAEABAoAAA==.',De='Deepwater:AwADCAYABAoAAA==.Derithon:AwAFCAIABAoAAA==.',Dr='Dranius:AwADCAUABAoAAA==.',El='Electroshokk:AwADCAMABAoAAA==.Elybella:AwABCAEABRQAAA==.',En='Enticide:AwAGCA4ABAoAAA==.',Er='Ereko:AwADCAMABAoAAA==.Erythorbic:AwADCAMABAoAAA==.',Ev='Evojapan:AwAFCAUABAoAAA==.',Fa='Fanaticism:AwADCAMABAoAAA==.Fatbeard:AwAECAkABAoAAA==.',Ff='Ffugme:AwADCAMABAoAAA==.',Fo='Foozle:AwAICAgABAoAAA==.Forkinyou:AwAFCBAABAoAAA==.',Fr='Frostypie:AwAICAgABAoAAA==.',Ga='Gatsuji:AwABCAEABRQCBQAHAQj+CgBNCoUCBAoABQAHAQj+CgBNCoUCBAoAAA==.',Gi='Gimixxwar:AwABCAEABAoAAA==.',Gu='Gub:AwAECAUABAoAAA==.',['G�']='Günter:AwAECAMABAoAAA==.',He='Healinside:AwAFCAgABAoAAA==.Helynisong:AwAECAEABAoAAA==.',Ig='Iggey:AwAGCA0ABAoAAA==.',Il='Ilandras:AwAFCA0ABAoAAA==.',Jo='Jonnyquestt:AwAECAYABAoAAA==.',Ka='Kartii:AwABCAIABAoAAA==.Katarina:AwACCAIABAoAAA==.Katze:AwAECAgABAoAAA==.',Ke='Kenj:AwAGCBUABAoCBwAGAQgaDABVJT4CBAoABwAGAQgaDABVJT4CBAoAAA==.Kenjurr:AwAFCAEABAoAAQcAVSUGCBUABAo=.',Ki='Killahaseo:AwAFCAwABAoAAA==.Killmoedee:AwAFCAUABAoAAA==.',Ko='Koopa:AwAECAoABAoAAA==.',La='Laetri:AwACCAIABAoAAA==.Lazloo:AwAECAsABAoAAA==.',Le='Leftee:AwACCAIABAoAAQEAAAAGCA0ABAo=.Leginer:AwABCAEABAoAAA==.',['L�']='Lëfty:AwABCAkABAoAAQEAAAAGCA0ABAo=.',Ma='Magicwater:AwAFCAoABAoAAA==.Maizepriest:AwAFCA0ABAoAAA==.',Mi='Mimi:AwAFCA4ABRQDAgAFAQhEAABXRhMCBRQAAgAFAQhEAABXRhMCBRQACAABAQjnAABdFWAABRQAAA==.',Mo='Moltenkam:AwACCAIABAoAAA==.',Ne='Nezukô:AwABCAEABAoAAA==.',No='Nokomandy:AwEBCAEABRQCCQAHAQhXFAAi9GsBBAoACQAHAQhXFAAi9GsBBAoAAA==.',Or='Oreobigbelly:AwAFCAkABAoAAA==.',Ou='Outen:AwADCAIABAoAAA==.',Pa='Pakingshet:AwAECAgABAoAAA==.Pallinda:AwACCAIABAoAAA==.',Pe='Pendulumlaw:AwADCAYABAoAAA==.Penånce:AwAFCAsABAoAAA==.',Pi='Pinkbuns:AwADCAgABAoAAA==.',Po='Positivetude:AwADCAYABAoAAA==.',Pr='Prenton:AwADCAMABAoAAA==.',Qe='Qeini:AwAECAUABAoAAA==.',Ra='Randis:AwACCAIABAoAAA==.',Re='Restodruid:AwAECAUABAoAAA==.Rexiis:AwAECAUABAoAAA==.',Rh='Rhuby:AwADCAMABAoAAA==.',Ri='Riontai:AwADCAMABAoAAA==.Riptîde:AwAFCAUABAoAAA==.',Sa='Sathy:AwABCAIABRQDCgAIAQi6CABHmmMCBAoACgAIAQi6CABEK2MCBAoAAgAHAQiqMwA8dNYBBAoAAA==.',Sc='Schiism:AwADCAUABAoAAA==.',Se='Selènè:AwAFCAUABAoAAA==.',Si='Sikxrevenge:AwAGCAoABAoAAA==.Siliconista:AwAFCA0ABAoAAA==.',Sp='Sposi:AwAFCA0ABAoAAA==.',Su='Subliminal:AwAFCAIABAoAAA==.',Sy='Syravia:AwAFCAkABAoAAA==.',['S�']='Søck:AwABCAEABRQCCwAHAQiZHgBA3xYCBAoACwAHAQiZHgBA3xYCBAoAAA==.',Ta='Tardis:AwAICAcABAoAAA==.Tavinrayn:AwADCAUABAoAAA==.',Ti='Tigerliley:AwADCAIABAoAAA==.',Tw='Twinight:AwAGCAkABAoAAA==.Twinsha:AwAECAUABAoAAQEAAAAGCAkABAo=.',Ty='Tylanolian:AwAICAcABAoAAA==.Tyresious:AwADCAYABAoAAA==.',Va='Valedus:AwAGCA0ABAoAAA==.',Vo='Volcker:AwADCAMABAoAAA==.Voldamar:AwAICAsABAoAAA==.',Wa='Waeylith:AwAFCA0ABAoAAA==.Wallypaly:AwACCAIABAoAAA==.Waterliliy:AwAFCAkABAoAAA==.',We='Weroroakiji:AwAECAMABAoAAA==.',['W�']='Wýler:AwACCAIABAoAAA==.',Xa='Xarulyn:AwADCAcABAoAAA==.',Yi='Yitian:AwAFCAkABAoAAA==.',Zo='Zoboomafoo:AwAFCAUABAoAAA==.',['Ä']='Äcid:AwADCAYABAoAAA==.',['Å']='Åpollo:AwABCAEABRQAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end