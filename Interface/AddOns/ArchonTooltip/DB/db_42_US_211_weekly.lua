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
 local lookup = {'Warrior-Fury','Unknown-Unknown','Paladin-Retribution','Mage-Fire','Warlock-Demonology','Warlock-Destruction','Hunter-BeastMastery','Hunter-Marksmanship','Priest-Holy','Warrior-Arms','Rogue-Outlaw','Rogue-Subtlety','DeathKnight-Blood','Mage-Frost','Shaman-Elemental','Monk-Mistweaver','Warrior-Protection','Priest-Discipline',}; local provider = {region='US',realm='Terenas',name='US',type='weekly',zone=42,date='2025-03-28',data={Ad='Adversity:AwADCAYABRQCAQADAQg/BABE8h8BBRQAAQADAQg/BABE8h8BBRQAAA==.',Al='Aleset:AwACCAEABAoAAA==.',An='Anastazia:AwAGCBEABAoAAA==.',Ao='Aohikari:AwAHCAsABAoAAQIAAAACCAMABRQ=.',Ar='Argoroth:AwAGCBYABAoCAwAGAQgLSwA+frIBBAoAAwAGAQgLSwA+frIBBAoAAA==.Arick:AwADCAUABAoAAA==.Ark:AwAFCA0ABAoAAA==.',As='Asmodias:AwAFCAkABAoAAA==.',Av='Avian:AwAECAcABAoAAA==.',Be='Beerz:AwACCAIABAoAAQIAAAAGCA8ABAo=.Belgaron:AwACCAIABAoAAQIAAAAECAkABAo=.Beng:AwAGCAMABAoAAA==.',Bi='Bile:AwAGCA8ABAoAAA==.',Bl='Bluegrass:AwAGCAMABAoAAA==.',Bo='Borc:AwACCAIABAoAAA==.Borknagar:AwAECAUABAoAAA==.',Br='Brotherpsy:AwAGCAMABAoAAA==.',Ca='Caiphage:AwAGCAMABAoAAA==.Caladelm:AwACCAMABAoAAA==.Calipally:AwAFCBQABAoCAwAFAQhOPgBYUOMBBAoAAwAFAQhOPgBYUOMBBAoAAA==.Casusßelli:AwAFCAsABAoAAQIAAAAGCBEABAo=.',Ce='Cedra:AwAFCAUABAoAAA==.Cegeo:AwAGCBEABAoAAA==.',Ch='Cheepdeeps:AwAGCAMABAoAAA==.',Ci='Cinia:AwAHCBUABAoCBAAHAQhfGQBMpz4CBAoABAAHAQhfGQBMpz4CBAoAAA==.',Co='Cokesminokes:AwAGCAUABAoAAA==.',Cr='Creamington:AwADCAQABAoAAA==.',Da='Daddy:AwABCAEABRQAAA==.Darkcarnival:AwAECAkABAoAAA==.',De='Deemon:AwADCAcABAoAAA==.Demiish:AwACCAMABAoAAA==.Denedin:AwAHCB0ABAoDBQAHAQhpGQA5PAABBAoABgAEAQgAOwBAxCkBBAoABQAEAQhpGQA2lgABBAoAAA==.',Do='Doomace:AwADCAUABAoAAA==.',Dr='Druitt:AwAHCAoABAoAAQMAPUYDCAcABRQ=.',Ed='Edrik:AwAECAYABAoAAA==.',Ee='Eekata:AwAHCBUABAoDBwAHAQiWJwBAdxUCBAoABwAHAQiWJwA+JRUCBAoACAADAQh0LgAegYUABAoAAA==.',El='Elle:AwADCAMABAoAAA==.Ellä:AwAICBYABAoCCQAIAQgyEgAyywMCBAoACQAIAQgyEgAyywMCBAoAAA==.Elrythe:AwAGCBQABAoCBwAGAQg6JgBS+x8CBAoABwAGAQg6JgBS+x8CBAoAAA==.',Em='Emmandreyn:AwAHCBMABAoAAA==.',Es='Esjho:AwACCAIABAoAAA==.',Ev='Everfloof:AwAFCAwABAoAAA==.',Ew='Ewiyar:AwAFCAkABAoAAA==.',Fa='Faced:AwAGCA0ABAoAAA==.Fahari:AwAECAgABAoAAA==.',Fe='Felebash:AwADCAMABAoAAA==.Felknar:AwAECAYABAoAAA==.',Fl='Floofies:AwAGCBMABAoAAA==.Floofyfu:AwABCAEABAoAAA==.',Gh='Gherkkin:AwAHCBYABAoDCgAHAQjXCwBIvygCBAoACgAHAQjXCwA+eygCBAoAAQAGAQjdHQBLU+ABBAoAAA==.',Go='Goatastica:AwAECAQABAoAAA==.',Gr='Greyblade:AwADCAQABAoAAA==.',Gu='Gunslingr:AwAHCBQABAoDCwAHAQhdAgBGLkUCBAoACwAHAQhdAgBGLkUCBAoADAADAQjJIwA546UABAoAAA==.Gusgus:AwAFCAgABAoAAA==.',['G�']='Günzz:AwADCAYABAoAAA==.',Ha='Halleberries:AwAGCA8ABAoAAA==.Hartnello:AwADCAMABAoAAA==.',He='Hearthisrdy:AwAECAkABAoAAA==.',Hi='Hime:AwADCAgABAoAAA==.',Ho='Holyice:AwADCAUABAoAAA==.Hosemachine:AwAGCBcABAoCDQAGAQh+DgBMmvABBAoADQAGAQh+DgBMmvABBAoAAA==.',Hu='Hulksmasher:AwADCAQABAoAAA==.',In='Inarius:AwABCAEABAoAAQIAAAADCAMABAo=.',It='Itsnobigdeal:AwADCAQABAoAAA==.',Ja='Jasmind:AwAGCAMABAoAAA==.',Jo='Joecool:AwAECAkABAoAAA==.',Ka='Kadan:AwAFCAoABAoAAA==.Kakwaa:AwADCAQABAoAAA==.',Ke='Keyadistor:AwADCAUABAoAAA==.',Kh='Khazorin:AwAECAsABAoAAA==.',Ki='Kinderlin:AwACCAIABAoAAA==.',Ko='Korstruck:AwAHCA0ABAoAAA==.',Kr='Kragnaar:AwAECAUABAoAAA==.Kravvelocity:AwAHCBMABAoAAA==.',La='Laksa:AwADCAQABAoAAQIAAAAFCAkABAo=.',Le='Lexalia:AwAHCBYABAoCBwAHAQgTEABcBtUCBAoABwAHAQgTEABcBtUCBAoAAQkAT8MICBYABAo=.Lexorcist:AwAICBYABAoCCQAIAQhTBQBPw80CBAoACQAIAQhTBQBPw80CBAoAAA==.',Ma='Magepuppy:AwAICB4ABAoDBAAIAQhPGAA+ZkoCBAoABAAIAQhPGAA+ZkoCBAoADgACAQgnXQAw8mYABAoAAA==.Mail:AwAICAgABAoAAQ8AUI0DCAUABRQ=.Malagran:AwACCAIABAoAAA==.Marrilyn:AwAGCAIABAoAAQIAAAACCAIABRQ=.Mashbrownie:AwAECAcABAoAAA==.',Me='Melorea:AwADCAQABAoAAA==.Metricdotem:AwACCAMABAoAAA==.',Mi='Mistah:AwAHCBIABAoAAA==.',Mo='Mookoo:AwABCAEABAoAAQIAAAAHCBIABAo=.Mooya:AwAHCA8ABAoAAA==.',Na='Nachtelf:AwAGCBMABAoAAA==.Natadawn:AwAGCAMABAoAAA==.',No='Notoriginal:AwAGCAMABAoAAA==.',Pa='Palizane:AwAICAgABAoAAA==.',Ph='Phoneua:AwAECAEABAoAAA==.',Po='Porrigar:AwAGCAsABAoAAA==.',Pr='Provoker:AwAGCAEABAoAAA==.',Ps='Psykoo:AwACCAQABAoAAA==.',Ra='Raezil:AwAFCAkABAoAAA==.Raivyn:AwAECAkABAoAAA==.',Re='Remulis:AwADCAcABAoAAA==.',Ru='Rubï:AwAFCAYABAoAAA==.Rugiian:AwADCAcABRQCEAADAQgvAwBLti0BBRQAEAADAQgvAwBLti0BBRQAAA==.',Ry='Rylonk:AwAFCAoABAoAAA==.',Sa='Sabindeus:AwACCAIABAoAAA==.',Sc='Scoric:AwAGCAMABAoAAA==.',Sh='Shadowdancèr:AwACCAUABAoAAA==.Shaiden:AwAECAcABAoAAA==.',Sk='Skoto:AwADCAYABAoAAA==.',Sm='Smalls:AwADCAYABAoAAA==.',Sn='Sneakydeaky:AwABCAEABAoAAA==.',So='Solnar:AwAECAIABAoAAA==.',Ta='Taeus:AwAECAMABAoAAA==.Tamilu:AwAFCAIABAoAAA==.Tandsong:AwACCAQABAoAAA==.Taurenator:AwAICBcABAoCEQAIAQipAgBKp6UCBAoAEQAIAQipAgBKp6UCBAoAAA==.',Th='Thorclip:AwAICAUABAoAAA==.',To='Toguwah:AwACCAIABAoAAA==.',Tr='Tristyana:AwAGCAMABAoAAA==.',Ts='Tsuki:AwACCAMABRQAAA==.Tsunâde:AwAGCAMABAoAAA==.',Va='Valora:AwAGCBUABAoDEgAGAQjsFwA7sZIBBAoAEgAGAQjsFwA7sZIBBAoACQABAQgHYgAPFywABAoAAA==.Vargen:AwACCAMABAoAAA==.Vayla:AwAECAkABAoAAA==.',Vi='Vicunaward:AwACCAIABAoAAA==.',Wa='Warwizard:AwAHCAMABAoAAA==.',Wh='Whiizper:AwAICAgABAoAAA==.',Wi='Wispx:AwAGCAYABAoAAA==.',Wr='Wrathbourne:AwAGCAwABAoAAA==.',Wy='Wyrden:AwABCAIABAoAAA==.',Xa='Xaquandrel:AwABCAMABRQAAA==.',Xe='Xebryo:AwADCAEABAoAAA==.',Xi='Xiangfei:AwADCAQABAoAAA==.',Ya='Yaydarkness:AwACCAQABRQCAwAIAQhVAwBgFmYDBAoAAwAIAQhVAwBgFmYDBAoAAA==.',Yu='Yuriko:AwADCAUABAoAAA==.',Yz='Yzaak:AwAGCAoABAoAAA==.',Ze='Zeddiccus:AwADCAQABAoAAA==.',['É']='Éric:AwAGCAMABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end