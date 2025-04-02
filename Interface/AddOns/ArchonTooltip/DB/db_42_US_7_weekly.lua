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
 local lookup = {'Warrior-Fury','Warrior-Arms','DemonHunter-Havoc','Unknown-Unknown','Monk-Brewmaster','Priest-Discipline','Priest-Holy','Priest-Shadow','Evoker-Devastation','Hunter-Marksmanship','Druid-Balance','Warlock-Affliction','Warlock-Destruction','Warlock-Demonology','Shaman-Enhancement','Druid-Restoration','Mage-Frost','DemonHunter-Vengeance','Rogue-Assassination','Monk-Windwalker','DeathKnight-Blood','Shaman-Restoration','Druid-Guardian','Mage-Arcane','Hunter-BeastMastery','Monk-Mistweaver','Druid-Feral','DeathKnight-Unholy','Mage-Fire','Rogue-Subtlety','Warrior-Protection','Shaman-Elemental','Paladin-Holy','Paladin-Retribution',}; local provider = {region='US',realm='Alleria',name='US',type='weekly',zone=42,date='2025-03-29',data={Ag='Agrok:AwABCAEABRQDAQAIAQj4DQBB6I8CBAoAAQAIAQj4DQBB6I8CBAoAAgAFAQgLIgAjUw4BBAoAAA==.',Ai='Airese:AwADCAUABAoAAA==.',An='Andia:AwAECAcABAoAAA==.',As='Ashed:AwAICBUABAoCAwAIAQgvJAAs6fkBBAoAAwAIAQgvJAAs6fkBBAoAAA==.Ashlieghee:AwAFCA4ABAoAAA==.Ashron:AwABCAEABRQAAA==.Asiodinn:AwAHCAwABAoAAA==.Asterie:AwAHCBEABAoAAA==.',Av='Averlen:AwADCAUABAoAAA==.',Az='Azshadorn:AwABCAEABAoAAA==.',Ba='Baby:AwADCAoABAoAAQQAAAAGCBMABAo=.Banana:AwABCAEABRQCBQAIAQgTAABjSpEDBAoABQAIAQgTAABjSpEDBAoAAA==.Bayman:AwAFCAkABAoAAA==.',Bi='Bitesize:AwEICBYABAoDAgAIAQheDABHACcCBAoAAgAGAQheDABJxScCBAoAAQAGAQgTHwBBC98BBAoAAA==.',Bl='Blockparty:AwADCAoABAoAAA==.',Br='Brighter:AwABCAIABRQEBgAHAQjIEQA+SugBBAoABgAHAQjIEQA+SugBBAoABwADAQheTwAdTHwABAoACAACAQhNQAA19mEABAoAAA==.',Ca='Carapace:AwADCAIABAoAAA==.Caraxes:AwAGCBQABAoCCQAGAQi5EgBGjs4BBAoACQAGAQi5EgBGjs4BBAoAAA==.Casterrata:AwAGCAkABAoAAA==.',Ch='Chaosshot:AwABCAIABRQCCgAHAQh6AwBhcO8CBAoACgAHAQh6AwBhcO8CBAoAAA==.',Cl='Clawley:AwAGCAoABAoAAA==.Clayvicar:AwAHCBsABAoCBwAHAQjGGwAzea4BBAoABwAHAQjGGwAzea4BBAoAAA==.',Co='Costco:AwAGCBQABAoCCwAGAQiTJABBib4BBAoACwAGAQiTJABBib4BBAoAAA==.',Cu='Cuz:AwADCAkABAoAAA==.',['C�']='Cöffee:AwADCAMABAoAAA==.',Da='Daggard:AwADCAgABAoAAA==.Dannere:AwAECAgABAoAAA==.',De='Deathmars:AwAICAgABAoAAA==.Deepdarkdank:AwADCAQABAoAAA==.Demonsworn:AwACCAQABRQCAwAIAQhMCgBTbvQCBAoAAwAIAQhMCgBTbvQCBAoAAA==.',Di='Diabolicarl:AwAGCA0ABAoAAA==.Diri:AwAICBYABAoEDAAIAQinBgAfR78BBAoADAAIAQinBgAfR78BBAoADQABAQgiggAGSysABAoADgABAQgxRAANHykABAoAAA==.',Do='Donnieyen:AwADCAQABAoAAA==.Dookiez:AwAICBYABAoCDwAIAQjBAABiq3cDBAoADwAIAQjBAABiq3cDBAoAAA==.Doubledragin:AwAHCBsABAoCCQAHAQggFAA3RLYBBAoACQAHAQggFAA3RLYBBAoAAA==.',Dr='Dragfan:AwAECAgABAoAAA==.Drakthos:AwADCAcABAoAAA==.Druidgirls:AwAICBYABAoCEAAIAQiaCwBBLEYCBAoAEAAIAQiaCwBBLEYCBAoAAA==.',El='Ellim:AwACCAQABAoAAA==.',Em='Emer:AwABCAIABRQCEAAGAQjfMQANb98ABAoAEAAGAQjfMQANb98ABAoAAA==.',Eo='Eousphorus:AwABCAEABRQCEQAHAQgZDwBPWlgCBAoAEQAHAQgZDwBPWlgCBAoAAA==.',Ev='Evangelica:AwACCAEABAoAAA==.Evanpriest:AwABCAEABRQDBgAIAQj2BgBQs6QCBAoABgAHAQj2BgBWVaQCBAoACAAEAQj0LwAvac4ABAoAAA==.',Fa='Fatwater:AwACCAIABAoAAA==.',Fe='Feid:AwADCAMABAoAAA==.Fellynn:AwABCAIABRQCEgAHAQh/AwBett4CBAoAEgAHAQh/AwBett4CBAoAAA==.',Fi='Fistymidget:AwACCAMABAoAAA==.',Fl='Flashblood:AwACCAIABAoAAA==.',Fu='Furyan:AwABCAIABRQCAgAHAQjlCwA98DECBAoAAgAHAQjlCwA98DECBAoAAA==.',Ga='Garagos:AwABCAIABRQCEwAHAQg1CQBGETgCBAoAEwAHAQg1CQBGETgCBAoAAA==.',Gc='Gcj:AwAGCBkABAoCAwAGAQh6OQAlc2UBBAoAAwAGAQh6OQAlc2UBBAoAAA==.',Ge='Gebuss:AwAICBYABAoCEwAIAQg7BABP/MoCBAoAEwAIAQg7BABP/MoCBAoAAA==.',Gi='Gibbly:AwABCAEABAoAAA==.Gilford:AwABCAIABAoAAA==.',Gn='Gnesii:AwABCAIABRQCAwAHAQg6KwAs58UBBAoAAwAHAQg6KwAs58UBBAoAAA==.',Gr='Grf:AwAICBYABAoDCAAIAQhpIAApjFkBBAoACAAGAQhpIAAtJFkBBAoABwAIAQjBKQAOQkQBBAoAAA==.',Ha='Hammeredhole:AwACCAQABAoAAA==.',He='Herm:AwAHCBcABAoCFAAHAQgaCQBWeakCBAoAFAAHAQgaCQBWeakCBAoAAA==.',Ho='Hotsndots:AwAGCA8ABAoAAA==.',Hu='Hugsportatin:AwABCAIABRQCCQAHAQitDABJcUICBAoACQAHAQitDABJcUICBAoAAA==.Huzzy:AwACCAUABAoAAA==.',['H�']='Hölycürves:AwAICAgABAoAAA==.',Ig='Ignored:AwAFCAUABAoAAA==.',Il='Illadansend:AwADCAMABAoAAA==.',Im='Impuratus:AwAGCAYABAoAAA==.',In='Inq:AwAHCBEABAoAAA==.',Je='Jeeka:AwADCAMABAoAAA==.',Jo='Joube:AwAECAQABAoAAA==.',Jr='Jrrtrolkien:AwACCAMABAoAAA==.',Ju='Juicybutt:AwADCAMABAoAAQcAIl8DCAkABRQ=.',Ka='Kairiandel:AwAGCAYABAoAAA==.Kathenset:AwAECAcABAoAAA==.Kavindra:AwAECAYABAoAAA==.Kayybae:AwAGCAgABAoAAQQAAAACCAIABRQ=.',Ke='Kennel:AwAHCAsABAoAAA==.',Kh='Khlamps:AwACCAIABAoAAA==.',Ko='Korabas:AwABCAIABRQCFQAHAQh+BwBUQZQCBAoAFQAHAQh+BwBUQZQCBAoAAA==.',Ku='Kuchíki:AwACCAQABAoAAA==.',Ky='Kydris:AwABCAIABAoAAA==.',['K�']='Káyy:AwACCAIABRQAAA==.',La='Laethorne:AwACCAMABAoAAA==.Lavacakes:AwABCAIABRQCFgAGAQgUKwBBk38BBAoAFgAGAQgUKwBBk38BBAoAAA==.',Le='Leonard:AwAICAgABAoAAA==.',Li='Lightbendèr:AwADCAMABAoAAA==.',Ma='Mado:AwAECAcABAoAAA==.Maesia:AwAECAQABAoAAA==.Malfhunter:AwAICBYABAoCCgAIAQjrCABE8F4CBAoACgAIAQjrCABE8F4CBAoAAA==.Manofwood:AwABCAEABRQCFwAHAQgNAQBc2uQCBAoAFwAHAQgNAQBc2uQCBAoAAA==.Marahala:AwAICA8ABAoAAA==.',Me='Mekkatorqu:AwAECAEABAoAAA==.Merdocki:AwABCAIABRQDDQAHAQhvEABTH3ACBAoADQAHAQhvEABTH3ACBAoADAADAQg8FwA1gbgABAoAAA==.Merdre:AwABCAIABRQCBwAGAQgAIQA5qoQBBAoABwAGAQgAIQA5qoQBBAoAAA==.',Mi='Mickeyrorc:AwAICAgABAoAAA==.Milkymocha:AwADCAoABAoAAA==.Misarae:AwAECAsABAoAAA==.',Mo='Morlu:AwAGCAwABAoAAA==.Mortifaga:AwACCAIABAoAAA==.Mouthdiease:AwACCAUABAoAAA==.',Ni='Nightmehr:AwAICBYABAoDEQAIAQi0BABWtAMDBAoAEQAIAQi0BABWtAMDBAoAGAABAQjSDQBNyT4ABAoAAA==.Niimue:AwABCAEABAoAAA==.Ninewizerd:AwADCAYABRQDCgADAQihAQBC1wsBBRQACgADAQihAQBAfgsBBRQAGQACAQjlCwBd4MYABRQAAA==.',Nu='Nullable:AwAFCAkABAoAAA==.',On='Onlyjuans:AwADCAMABAoAAA==.',Or='Orlos:AwADCAUABAoAAA==.Oräkk:AwACCAIABAoAAA==.',Pa='Pandulce:AwADCAUABAoAAA==.Papacooldown:AwABCAEABAoAAA==.',Ph='Phaedriel:AwABCAEABAoAAA==.',Pi='Pillgrimm:AwAECAEABAoAAA==.',Po='Pocahuntas:AwABCAEABAoAAA==.Ponjun:AwAGCA0ABAoAAA==.',Pr='Praesidiel:AwAECAgABAoAAA==.Providence:AwAICBYABAoCAwAIAQiTEwBC+YkCBAoAAwAIAQiTEwBC+YkCBAoAAA==.Prsr:AwAGCAkABAoAAA==.',Pu='Pudgypaws:AwABCAIABRQDGgAHAQhNDQBPOm0CBAoAGgAHAQhNDQBPOm0CBAoAFAABAQgzUAAeOywABAoAAA==.Punishment:AwAECAEABAoAAA==.',Py='Pyrogasm:AwACCAIABAoAAQQAAAAGCAkABAo=.',Qu='Quicknok:AwAHCAgABAoAAA==.Quikbeard:AwABCAEABAoAAQQAAAAHCAgABAo=.',Ra='Ragehunter:AwAFCAsABAoAAA==.Ragged:AwAGCA4ABAoAAA==.Rankor:AwABCAIABRQCGwAHAQjDAwBRSJsCBAoAGwAHAQjDAwBRSJsCBAoAAA==.Rastann:AwAICBIABAoAAA==.Raycharles:AwAICAgABAoAAA==.',Re='Reapertoo:AwABCAIABRQCHAAGAQgkFQBWgisCBAoAHAAGAQgkFQBWgisCBAoAAA==.Redbaron:AwAHCBAABAoAAA==.',Rh='Rhenyi:AwACCAIABAoAAA==.',Ro='Rolas:AwACCAEABAoAAQQAAAADCAUABAo=.Rozalin:AwABCAIABRQDHQAHAQjwFABUJ3UCBAoAHQAHAQjwFABUJ3UCBAoAEQABAQiebQBIlTkABAoAAA==.',Ru='Run:AwABCAEABRQCHgAIAQjhAgBYuhUDBAoAHgAIAQjhAgBYuhUDBAoAAA==.',Ry='Ryme:AwAECAQABAoAAA==.',Sa='Sacredstorms:AwAGCAoABAoAAA==.Sacredswords:AwABCAEABRQAAA==.Saerious:AwADCAUABAoAAA==.Saintcosmo:AwAGCBMABAoAAA==.Salvos:AwACCAMABAoAAA==.',Se='Sergibbles:AwAFCAMABAoAAA==.',Sh='Shaundakul:AwACCAIABAoAAA==.Shiftyaxx:AwABCAEABAoAAA==.Shockakhan:AwADCAoABAoAAA==.Shãdow:AwACCAMABAoAAA==.',Sk='Skawalker:AwAICBQABAoCEAAIAQgJBwBKYp4CBAoAEAAIAQgJBwBKYp4CBAoAAA==.',Sl='Slaynne:AwABCAIABRQDAQAIAQiIBgBXCgADBAoAAQAIAQiIBgBXCgADBAoAHwABAQjnJAAuijgABAoAAA==.Slowvoid:AwAECAIABAoAAA==.',So='Sockz:AwAICBgABAoDHgAIAQj0DwAfCekBBAoAHgAIAQj0DwAe1ukBBAoAEwADAQjRIgAgbokABAoAAA==.Solea:AwAICAgABAoAAA==.Solrosenburg:AwADCAQABAoAAA==.Sorg:AwAFCAgABAoAAA==.',Sp='Spumanti:AwADCAMABAoAAA==.',Sq='Squirreltag:AwABCAIABRQCCgAHAQivCgBSADkCBAoACgAHAQivCgBSADkCBAoAAA==.Squozen:AwADCAMABAoAAA==.',St='Starnex:AwAECAEABAoAAA==.Styx:AwAGCBEABAoAAA==.',Su='Survival:AwABCAEABRQCGQAIAQjGHQBACmkCBAoAGQAIAQjGHQBACmkCBAoAAA==.',Sy='Sybela:AwADCAQABAoAAA==.Sylvestris:AwAFCAcABAoAAA==.',Ta='Tacodad:AwAGCBgABAoCIAAGAQhjKAAZLCQBBAoAIAAGAQhjKAAZLCQBBAoAAA==.Tacos:AwABCAEABAoAAA==.Tangie:AwAFCAkABAoAAA==.Tatsuyâ:AwAGCAUABAoAAA==.',Te='Tedoseirum:AwAICBEABAoAAA==.Telegram:AwACCAQABRQAAA==.',Th='Thedtwo:AwADCAYABAoAAA==.Thorgarrus:AwAHCA8ABAoAAA==.',Ti='Tigerwoodz:AwAECAYABAoAAA==.Tinada:AwABCAIABRQCFAAIAQgpBgBTuOcCBAoAFAAIAQgpBgBTuOcCBAoAAA==.',To='Toddie:AwAGCA0ABAoAAA==.Tormmod:AwACCAMABAoAAA==.',Tr='Trashypanda:AwAFCAsABAoAAA==.',Tw='Twentynine:AwAHCBsABAoCGQAHAQiuHwBLIVkCBAoAGQAHAQiuHwBLIVkCBAoAAA==.',Ty='Tyrnova:AwAGCBUABAoCDQAGAQgaFQBWREICBAoADQAGAQgaFQBWREICBAoAAA==.',Ul='Ultrear:AwACCAIABAoAAA==.',Um='Umbravolt:AwAICBYABAoCFwAIAQiQAABb2y8DBAoAFwAIAQiQAABb2y8DBAoAAA==.',Va='Valkarion:AwABCAEABAoAAA==.',Ve='Velordis:AwABCAIABRQCEgAIAQhtCABDCEUCBAoAEgAIAQhtCABDCEUCBAoAAA==.',Vo='Vorthe:AwABCAEABRQAAA==.',Vy='Vyagra:AwAICBAABAoAAA==.',Wh='Whis:AwABCAEABAoAAA==.',Wi='Wiimage:AwAECAQABAoAAQQAAAAGCA0ABAo=.Wiimann:AwAGCA0ABAoAAA==.Wildmanbill:AwACCAEABAoAAA==.',Xa='Xanberly:AwACCAIABAoAAA==.Xannah:AwAICBYABAoDBwAIAQgzFgA5COEBBAoABwAHAQgzFgA9XeEBBAoABgAHAQhyIQAZ9z4BBAoAAA==.Xantrys:AwADCAcABAoAAA==.',Yc='Yce:AwADCAQABAoAAA==.',Yo='Yoker:AwAECAIABAoAAA==.',Za='Zalorea:AwACCAUABAoAAA==.Zammonk:AwAICBYABAoDFAAIAQh/CQBMraICBAoAFAAHAQh/CQBTOKICBAoAGgABAQhAYwAS0TcABAoAAA==.Zanstrasz:AwACCAMABAoAAA==.',Ze='Zenez:AwADCAMABAoAAA==.Zentaco:AwAGCAoABAoAAA==.Zerc:AwABCAEABAoAAA==.Zeth:AwAGCA4ABAoAAA==.',Zi='Zilkir:AwABCAIABRQDIQAHAQhAEQAujJwBBAoAIQAHAQhAEQAujJwBBAoAIgADAQjU0AAVvnQABAoAAA==.',Zo='Zould:AwAECAoABAoAAA==.',Zu='Zuzzlin:AwAFCA0ABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end