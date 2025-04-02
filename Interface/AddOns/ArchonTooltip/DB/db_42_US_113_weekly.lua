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
 local lookup = {'Evoker-Devastation','Rogue-Subtlety','Druid-Feral','Druid-Balance','Warrior-Fury','Warrior-Protection','Unknown-Unknown','Mage-Fire','Mage-Frost','Mage-Arcane','Priest-Holy','Monk-Windwalker','Hunter-Survival','Hunter-BeastMastery','Rogue-Assassination','Shaman-Enhancement','Hunter-Marksmanship','DeathKnight-Blood',}; local provider = {region='US',realm='GrizzlyHills',name='US',type='weekly',zone=42,date='2025-03-29',data={Al='Alecto:AwABCAEABRQCAQAIAQh3EAApzvcBBAoAAQAIAQh3EAApzvcBBAoAAA==.',Am='Amarella:AwAFCAYABAoAAA==.',An='Anubis:AwAHCBMABAoAAA==.',Ar='Arangarr:AwAECAoABAoAAA==.Arendt:AwACCAIABAoAAA==.Aristotle:AwAFCAgABAoAAA==.',Az='Az:AwADCAQABAoAAA==.',Ba='Bacondk:AwAHCBAABAoAAA==.Baconhammr:AwADCAMABAoAAA==.',Be='Berengier:AwAICAgABAoAAA==.',Bl='Bloodnfury:AwAFCAoABAoAAA==.Bloodopal:AwABCAEABAoAAA==.',Bo='Boscoray:AwADCAIABAoAAA==.',By='Byzantium:AwADCAYABAoAAA==.',Ca='Cabledryer:AwABCAEABRQAAA==.',Cb='Cbt:AwADCAEABAoAAA==.',Ch='Chronic:AwAFCA0ABAoAAA==.',Co='Connceal:AwABCAIABRQCAgAIAQiTBgBKVbQCBAoAAgAIAQiTBgBKVbQCBAoAAA==.',Cy='Cynyia:AwAHCBMABAoAAA==.',Da='Dagon:AwABCAIABAoAAA==.Daveejones:AwADCAYABAoAAA==.',De='Deathblitz:AwAICBEABAoAAA==.Deathiron:AwAFCAQABAoAAA==.Deecent:AwAICAYABAoAAA==.Demonicus:AwAGCAEABAoAAA==.',Do='Domw:AwADCAcABAoAAA==.Donham:AwABCAEABRQAAA==.Dorkimedes:AwAHCBAABAoAAA==.',Dr='Drunkenrage:AwACCAEABAoAAA==.',Dw='Dwadler:AwACCAIABAoAAA==.',Eb='Ebt:AwADCAMABAoAAA==.',Em='Embre:AwAGCA0ABAoAAA==.',Ev='Evojak:AwADCAYABAoAAA==.',Fi='Fizehtotems:AwADCAMABAoAAA==.',Fl='Fluffytank:AwAFCAsABAoAAA==.',Fo='Foragarn:AwADCAoABAoAAA==.',Fr='Froggierlynx:AwACCAIABRQAAA==.Froznfate:AwAECAcABAoAAA==.',Ga='Gabriellá:AwEICA4ABAoAAA==.Galencharred:AwACCAQABAoAAA==.Garurumon:AwAGCAgABAoAAA==.Gauss:AwAGCAEABAoAAA==.',Ge='Gerva:AwADCAYABAoAAA==.',Gi='Gilas:AwADCAYABAoAAA==.',Gw='Gwenivive:AwAFCAwABAoAAA==.',He='Hexada:AwABCAEABRQDAwAHAQgSBwBCZwECBAoAAwAHAQgSBwA6SwECBAoABAAGAQh2NgAsmDsBBAoAAA==.',Ho='Hobokenjones:AwAFCA0ABAoAAA==.Holgo:AwADCAcABRQDBQADAQjMBwAzisUABRQABQACAQjMBwBKp8UABRQABgABAQjbBQAFUC8ABRQAAA==.Holyshirt:AwAICBAABAoAAA==.',Ic='Icia:AwAICAgABAoAAA==.',Im='Imphysema:AwACCAQABAoAAA==.',It='Ithoran:AwABCAEABAoAAA==.Ithorus:AwABCAEABAoAAA==.',Iv='Ivyleaves:AwAECAEABAoAAA==.',Ja='Jamien:AwAFCAIABAoAAA==.',Ji='Jiyeon:AwADCAYABAoAAQcAAAAGCBIABAo=.',Ka='Kaidiis:AwAECAgABAoAAA==.Katrina:AwACCAMABAoAAA==.',Ke='Kegbreaker:AwAFCAoABAoAAA==.Kelehm:AwACCAIABAoAAA==.',Ki='Kilauea:AwACCAIABAoAAA==.Kimbustible:AwAHCBMABAoAAA==.',Kn='Knockknocko:AwADCAMABAoAAA==.Knocko:AwADCA4ABAoAAA==.',Kr='Krid:AwAFCAYABAoAAA==.',Ku='Kunuku:AwAECAEABAoAAA==.',['K�']='Këy:AwAGCAEABAoAAA==.',La='Latrice:AwACCAMABRQECAAIAQjzFQBU22sCBAoACAAIAQjzFQBL6GsCBAoACQAHAQhYIQA5kqgBBAoACgACAQgtCABa0cEABAoAAA==.Laviosa:AwAFCAcABAoAAA==.',Li='Lilblitzz:AwABCAEABAoAAA==.Lilriotzz:AwABCAEABAoAAA==.',Lu='Lunarmist:AwABCAEABRQAAA==.',Ma='Marhukai:AwAFCAoABAoAAA==.Maximiliian:AwABCAEABRQAAQsAV3kCCAcABRQ=.',Mi='Mickhaggis:AwACCAQABAoAAA==.Minikloon:AwADCAUABRQCDAADAQjxAwApBPQABRQADAADAQjxAwApBPQABRQAAA==.Mistorri:AwAFCAoABAoAAA==.',Mo='Monstertamer:AwABCAEABAoAAA==.Morpheus:AwADCAMABAoAAA==.Moxy:AwADCAQABAoAAA==.',Mu='Muzzler:AwAHCBUABAoCCQAHAQjvEABIMUICBAoACQAHAQjvEABIMUICBAoAAA==.',My='Mysticmeat:AwADCAUABAoAAA==.',Na='Nado:AwAGCAcABAoAAA==.Narcissistic:AwAICA0ABAoAAA==.',Ne='Nerdrage:AwAHCBMABAoAAA==.',No='Northspirit:AwABCAEABAoAAA==.',Oh='Ohyikers:AwABCAIABRQCBAAIAQj2AwBbyDcDBAoABAAIAQj2AwBbyDcDBAoAAA==.',Op='Openedfalcon:AwAICB4ABAoDDQAIAQilAQBJ/40CBAoADQAIAQilAQBJ/40CBAoADgAEAQgmUwBHckEBBAoAAA==.',Pa='Pasta:AwACCAMABRQDAgAIAQieBQBN4cwCBAoAAgAIAQieBQBNUswCBAoADwACAQj6IwBLdH4ABAoAAA==.',Pe='Perkz:AwADCAMABAoAAQcAAAABCAIABRQ=.',Ph='Phatcow:AwAGCBQABAoCEAAGAQg1HgAnR38BBAoAEAAGAQg1HgAnR38BBAoAAA==.Phude:AwAHCBMABAoAAA==.',Po='Polyamorous:AwAECAoABAoAAA==.Poohynok:AwADCAMABAoAAA==.',Ps='Psylent:AwACCAEABAoAAA==.',Pt='Ptoughneigh:AwADCAEABAoAAA==.',Pu='Puke:AwABCAIABAoAAA==.',Re='Retro:AwABCAEABAoAAA==.',Sa='Saltfoo:AwACCAQABAoAAA==.',Sc='Scarlett:AwAHCBQABAoCCAAHAQgDLAAvdKcBBAoACAAHAQgDLAAvdKcBBAoAAA==.Scoreboard:AwABCAEABAoAAQcAAAAICA0ABAo=.',Se='Sesskaa:AwADCAUABAoAAA==.',Sh='Shadowcursed:AwADCAYABAoAAA==.Shimmyshammy:AwAICAgABAoAAA==.Shnorp:AwAFCAcABAoAAA==.Shockrocks:AwAHCAcABAoAAQQAW8gBCAIABRQ=.Shätterz:AwAICAgABAoAAA==.Shünúkh:AwABCAIABAoAAA==.',Si='Sinos:AwAHCA8ABAoAAA==.',So='Sojü:AwABCAEABAoAAA==.',St='Stoopin:AwADCAMABAoAAA==.Stratichnut:AwADCAYABAoAAA==.',Sw='Swifte:AwAECAQABAoAAA==.',Ta='Tagiathan:AwAFCAoABAoAAA==.Taloon:AwAHCA4ABAoAAA==.Taltost:AwACCAIABAoAAQcAAAACCAQABAo=.Taterthot:AwABCAIABAoAAA==.',Te='Tenithon:AwAECAEABAoAAA==.',Th='Thaodinhealz:AwAICAgABAoAAA==.Thierry:AwAFCAUABAoAAA==.Thierrye:AwAFCAkABAoAAA==.Thrissa:AwACCAMABAoAAA==.',Ti='Tinkerspell:AwAHCBIABAoAAA==.',To='Touchit:AwAECAgABAoAAA==.',Tr='Trudru:AwAFCAwABAoAAA==.',Ud='Udari:AwADCAIABAoAAA==.',Va='Vast:AwADCAMABAoAAA==.',Ve='Venawyn:AwADCAYABAoAAA==.',Vo='Voidling:AwABCAEABRQAAQQAW8gBCAIABRQ=.Vortan:AwAGCBQABAoCEQAGAQgbDgBQA/8BBAoAEQAGAQgbDgBQA/8BBAoAAA==.',We='Wergis:AwAGCBQABAoCEgAGAQiNEQBCfsYBBAoAEgAGAQiNEQBCfsYBBAoAAA==.',Wh='Whatmyname:AwADCAYABAoAAA==.Whoopsie:AwABCAEABRQAAA==.',Yo='Yoonie:AwADCAMABAoAAQcAAAAICAgABAo=.Yordi:AwABCAMABAoAAA==.',Yu='Yuzuriha:AwAHCBQABAoCDgAHAQh3LgBDBvUBBAoADgAHAQh3LgBDBvUBBAoAAA==.',['Å']='Ålïce:AwAFCAYABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end