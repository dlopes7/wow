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
 local lookup = {'Shaman-Enhancement','Evoker-Devastation','Hunter-BeastMastery','Monk-Brewmaster','Monk-Mistweaver','Mage-Fire','DeathKnight-Unholy','Mage-Arcane','DemonHunter-Havoc','Warlock-Demonology','Warlock-Destruction','Unknown-Unknown','Rogue-Outlaw','Rogue-Subtlety','Paladin-Retribution','Shaman-Restoration','Shaman-Elemental','Rogue-Assassination','Warrior-Fury','Warrior-Arms','Priest-Holy','Druid-Balance','Druid-Restoration','Druid-Guardian','Mage-Frost','DemonHunter-Vengeance','Monk-Windwalker','Evoker-Augmentation',}; local provider = {region='US',realm='Aggramar',name='US',type='weekly',zone=42,date='2025-03-29',data={Ae='Aezir:AwAFCAwABAoAAA==.',Al='Altairx:AwADCAUABAoAAA==.Alttask:AwAECAYABAoAAA==.',Am='Amorelish:AwACCAMABAoAAA==.Amorous:AwAECA4ABAoAAA==.',An='Anuestart:AwAHCA4ABAoAAA==.',Ar='Arbiter:AwAHCBUABAoCAQAHAQhUEwA63AsCBAoAAQAHAQhUEwA63AsCBAoAAA==.Artórius:AwADCAUABAoAAA==.Arvad:AwAFCA4ABAoAAA==.',At='Athania:AwABCAEABAoAAA==.Atoli:AwAGCBIABAoAAA==.',Av='Avaligor:AwAFCAsABAoAAA==.',Az='Azalth:AwADCAoABRQCAgADAQiuAQBiaVMBBRQAAgADAQiuAQBiaVMBBRQAAA==.',Ba='Bandet:AwAFCAUABAoAAA==.',Be='Bellatrixt:AwAHCBUABAoCAwAHAQjTHQBMVWkCBAoAAwAHAQjTHQBMVWkCBAoAAA==.',Bi='Bigbeardy:AwAGCAIABAoAAA==.Bigshrimp:AwAFCAsABAoAAA==.',Bl='Blaqarrow:AwACCAQABAoAAA==.Blightreaver:AwAFCA8ABAoAAA==.',Bo='Boltlina:AwAFCA4ABAoAAA==.Booti:AwAGCAYABAoAAA==.Borz:AwADCAYABAoAAA==.',Br='Brewsmash:AwADCAMABAoAAA==.Brightblaze:AwAICBcABAoDBAAIAQjjBQA8RvUBBAoABAAHAQjjBQBDifUBBAoABQAFAQjRRAANQLoABAoAAA==.Brndo:AwADCAYABAoAAA==.Brogoth:AwAECAEABAoAAA==.Brunoxp:AwABCAEABRQAAA==.',Bu='Burdin:AwACCAMABAoAAA==.Buritek:AwABCAEABRQAAA==.Burlapsack:AwAICBgABAoCBgAIAQhyHgA71hgCBAoABgAIAQhyHgA71hgCBAoAAA==.',Ca='Carrot:AwAFCA8ABAoAAA==.Castorice:AwAECAIABAoAAA==.',Ce='Celesar:AwADCAMABAoAAA==.Cellasril:AwAECAgABAoAAA==.Celèste:AwAHCBEABAoAAA==.Cenoren:AwABCAEABRQCBwAIAQj5EgBAw0ECBAoABwAIAQj5EgBAw0ECBAoAAA==.',Ch='Chïllidan:AwAICAoABAoAAA==.',Cr='Crowmist:AwAHCAcABAoAAA==.',Da='Dahak:AwACCAIABAoAAA==.Dargonsevzer:AwAGCAsABAoAAA==.Darkshadowq:AwAECAUABAoAAA==.Darthteela:AwADCAUABAoAAA==.Daspen:AwAFCAYABAoAAA==.',De='Dedango:AwADCAMABAoAAA==.Delonge:AwAECAIABAoAAA==.Derzok:AwABCAEABAoAAA==.',Di='Diry:AwAGCAEABAoAAA==.',Dj='Djdeath:AwAECAEABAoAAA==.',Do='Dondoro:AwACCAIABAoAAA==.Dorknight:AwACCAEABAoAAA==.Doroo:AwABCAEABRQAAA==.',Dr='Drakros:AwACCAYABRQCCAACAQheAAA6sKgABRQACAACAQheAAA6sKgABRQAAA==.',Dy='Dyl:AwAFCAYABAoAAA==.',Ek='Eko:AwAGCAYABAoAAA==.',El='Elm:AwABCAIABRQCCQAIAQg4DgBWRMMCBAoACQAIAQg4DgBWRMMCBAoAAA==.',Es='Esdeäth:AwAICBgABAoDCgAIAQjxAwBBsWYCBAoACgAIAQjxAwBBsWYCBAoACwADAQhqagAZ7m4ABAoAAA==.Estar:AwABCAEABAoAAA==.',Eu='Eulerion:AwAGCAEABAoAAA==.',Fe='Felcrotic:AwAECAQABAoAAA==.',Fi='Fimbik:AwAFCA8ABAoAAA==.',Fl='Floriaris:AwAFCAUABAoAAQMALMgCCAYABRQ=.Fluffylight:AwABCAEABAoAAA==.',Fr='Frostibtch:AwABCAEABAoAAA==.',Gh='Ghostl:AwAICAgABAoAAQwAAAACCAIABRQ=.',Gr='Gratius:AwAFCAYABAoAAA==.Griiffith:AwADCAEABAoAAA==.',Gy='Gyoza:AwAICA4ABAoAAA==.',Ha='Handmemygun:AwAECAYABAoAAA==.Hanudan:AwAFCAwABAoAAA==.Hanzumbra:AwAICBgABAoDDQAIAQi/AABVKxEDBAoADQAIAQi/AABVKxEDBAoADgAGAQgfEABPg+YBBAoAAA==.Happyz:AwACCAMABAoAAQwAAAADCAMABAo=.Hard:AwADCAUABAoAAA==.Harpalyke:AwABCAEABRQAAA==.Hauntus:AwACCAIABAoAAA==.Hawk:AwACCAYABRQCDwACAQioEAAuGJMABRQADwACAQioEAAuGJMABRQAAA==.',He='Heiliger:AwAFCA0ABAoAAA==.Helioz:AwACCAEABAoAAA==.',Hi='Highpewxd:AwADCAIABAoAAA==.',Hy='Hyasept:AwAGCAkABAoAAA==.Hydraulic:AwAICAwABAoDEAAFAQgxWgARXZwABAoAEAAEAQgxWgAT6ZwABAoAEQADAQgJSQAJOFQABAoAAA==.',Ib='Ibroughtazoo:AwACCAYABRQCAwACAQiBCwBZC84ABRQAAwACAQiBCwBZC84ABRQAAA==.Ibz:AwAICBQABAoCEgAHAQhLBABf0cgCBAoAEgAHAQhLBABf0cgCBAoAAA==.',Im='Imago:AwACCAIABAoAAA==.',In='Intera:AwAFCAUABAoAAA==.',Ja='Jaiyanaa:AwAFCAgABAoAAA==.',Je='Jenkman:AwAGCAoABAoAAA==.',Ji='Jinsu:AwADCAIABAoAAA==.',Jj='Jjaammaal:AwAHCBUABAoDEwAHAQj4IQBSEcQBBAoAEwAFAQj4IQBS48QBBAoAFAADAQipIABTBh4BBAoAAA==.',Jo='Joshelloco:AwADCAYABAoAAA==.',Ju='Juñior:AwAGCAsABAoAAA==.',Ka='Kaax:AwAECAcABAoAAA==.Kalanonn:AwADCAYABAoAAA==.Karonalambnt:AwACCAIABAoAAA==.',Ki='Kind:AwACCAYABRQCFQACAQjSBwAdM4gABRQAFQACAQjSBwAdM4gABRQAAA==.',Kl='Klaezara:AwADCA4ABAoAAA==.',Kn='Knaring:AwAFCAQABAoAAA==.',Ko='Kojak:AwADCAEABAoAAA==.',Kr='Krîmsön:AwABCAEABRQEFgAIAQjMGwBFRwoCBAoAFgAGAQjMGwBQtwoCBAoAFwABAQiXVAApiDwABAoAGAABAQhHGwAOaB0ABAoAAA==.',Ku='Kudohaku:AwABCAEABAoAAA==.',Kv='Kvj:AwACCAMABAoAAA==.',Ky='Kylir:AwAICBkABAoDEAAIAQjLEgA4oTUCBAoAEAAIAQjLEgA4oTUCBAoAEQAHAQgeIAAeuG8BBAoAAA==.',La='Laochra:AwAICAkABAoAAA==.Lardios:AwABCAEABAoAAA==.Laterali:AwAECAcABAoAAA==.Layas:AwAGCAEABAoAAA==.Lazashaz:AwAHCBMABAoAAA==.Lazonk:AwAICAgABAoAAA==.',Lo='Loox:AwACCAYABRQCAwACAQgPEgAsyJEABRQAAwACAQgPEgAsyJEABRQAAA==.',Lu='Luckiee:AwABCAIABRQCFwAHAQgyFgA71rwBBAoAFwAHAQgyFgA71rwBBAoAAA==.Lumini:AwABCAIABAoAAA==.',Ma='Madpaladin:AwAFCAgABAoAAA==.Mayo:AwAECAwABAoAAA==.',Mi='Mikkjeanne:AwADCAgABRQCEAADAQhZAwBAVg8BBRQAEAADAQhZAwBAVg8BBRQAAA==.Miklick:AwAFCAUABAoAAA==.',Mo='Monthlyrage:AwACCAQABAoAAA==.Montrysk:AwABCAEABAoAAA==.Morebrews:AwABCAEABRQAAQMALMgCCAYABRQ=.Morghan:AwAFCAoABAoAAA==.',Ne='Nelyar:AwAFCAUABAoAAA==.Neokai:AwACCAIABAoAAA==.Nephiah:AwAECAwABAoAAA==.',Ni='Nightdrifter:AwAFCAgABAoAAA==.',No='Noro:AwAHCBYABAoEGQAHAQjMCwBbIoECBAoAGQAHAQjMCwBVbYECBAoABgAEAQgaSwA2Nd0ABAoACAABAQgUDABXOlkABAoAAA==.Notaghost:AwACCAIABAoAAQwAAAADCAMABAo=.Notprepared:AwAECAcABAoAAA==.',Nu='Nujabes:AwACCAIABAoAAQkAVkQBCAIABRQ=.',Ny='Nyeleen:AwAECAIABAoAAA==.Nyxanunit:AwACCAIABAoAAA==.',['N�']='Nächter:AwADCAUABAoAAA==.',Ok='Okamï:AwAHCA4ABAoAAA==.',Om='Omìnous:AwAICA4ABAoAAA==.',On='Onyxxia:AwAECAQABAoAAQwAAAAFCAkABAo=.',Or='Orthus:AwABCAEABRQAAA==.',Ov='Overknight:AwAGCBAABAoAAA==.',Oz='Oznah:AwAGCBAABAoAAA==.',Pa='Palalawladin:AwACCAIABAoAAA==.Pallyaustin:AwAFCAUABAoAAA==.',Ph='Pholken:AwAICBEABAoAAA==.',Pn='Pnub:AwAGCAYABAoAAA==.',Pr='Prancinggoat:AwADCAMABAoAAA==.Promithia:AwAECAoABAoAAA==.',['P�']='Pëëk:AwADCAYABAoAAA==.',Ra='Raiku:AwAECAQABAoAAA==.Ralthor:AwAICAgABAoAAA==.Rathalos:AwAECAQABAoAAA==.Ravsbeam:AwAGCBQABAoCGgAGAQj5CwBNi/cBBAoAGgAGAQj5CwBNi/cBBAoAAA==.',Re='Requyïm:AwADCAMABAoAAA==.',Ro='Rokokos:AwAICBgABAoCEQAIAQhPDQA+Gl0CBAoAEQAIAQhPDQA+Gl0CBAoAAA==.',['R�']='Rønín:AwACCAIABAoAAA==.',Sa='Sadow:AwABCAEABAoAAA==.Saimedin:AwAECAIABAoAAA==.Salubrious:AwAGCAQABAoAAA==.Sastor:AwADCAYABAoAAA==.Satanael:AwACCAIABAoAAA==.Saved:AwAECAcABRQCAwAEAQgIBQAvMTYBBRQAAwAEAQgIBQAvMTYBBRQAAA==.',Sc='Scene:AwAFCAIABAoAAA==.',Se='Seigshift:AwAFCAgABAoAAA==.',Sh='Shamanablast:AwAICAgABAoAAA==.Shamrexm:AwABCAEABAoAAA==.Shidae:AwADCAcABAoAAA==.Shocksi:AwAFCAcABAoAAA==.Shyé:AwAECAQABAoAAA==.Shàdðw:AwAFCAgABAoAAA==.',Si='Sini:AwACCAMABRQCBgAIAQikBgBYxhcDBAoABgAIAQikBgBYxhcDBAoAAA==.',Sk='Skrebsnop:AwAHCAwABAoAAQIAYmkDCAoABRQ=.Skyfel:AwAFCAcABAoAAA==.',Sl='Slampiece:AwABCAIABRQDGQAHAQijEABGyEUCBAoAGQAHAQijEABEM0UCBAoABgABAQjcbQAljT0ABAoAAA==.',So='Soarphan:AwADCAQABAoAAA==.Socuteboss:AwAFCAwABAoAAA==.Softboy:AwACCAEABAoAAA==.Softgrl:AwABCAEABAoAAA==.Sovereignt:AwAECAUABAoAAA==.',Sp='Sparechange:AwAGCAUABAoAAA==.',St='Stealthecho:AwAICBAABAoAAA==.Steelchi:AwAGCAYABAoAAA==.Stonelife:AwAFCAgABAoAAA==.',Su='Succiboi:AwAGCA4ABAoAAA==.',Ta='Tadaman:AwAECAYABAoAAA==.',Te='Techno:AwAICAsABAoAARsAUdQECAsABRQ=.Telriel:AwADCAYABAoAAA==.Terrabrew:AwAGCA8ABAoAAA==.',Th='Thakar:AwAGCAsABAoAAA==.Theonidus:AwAHCAcABAoAAA==.',Ti='Tiktokthøt:AwAGCA4ABAoAAA==.',To='Toetummy:AwAICBgABAoCEAAIAQjaBgBUA9QCBAoAEAAIAQjaBgBUA9QCBAoAAA==.Tonaris:AwACCAIABAoAAA==.Tougyu:AwAGCAwABAoAAA==.',Tr='Trashcän:AwAFCAkABAoAAA==.Treebean:AwADCAUABAoAAA==.',Tu='Tuurok:AwAECAcABAoAAA==.',Tw='Twezzle:AwABCAEABRQDCwAIAQj5BABY0wcDBAoACwAIAQj5BABY0wcDBAoACgABAQjeNgBTW1oABAoAAA==.',Ty='Tyronionn:AwAICAcABAoAAA==.',Va='Varlais:AwAECAwABAoAAA==.',Ve='Venecohunter:AwAFCAYABAoAAA==.Versatyle:AwAICAgABAoAAA==.',Vy='Vynthis:AwAECAUABAoAAA==.',Wh='Whelp:AwABCAEABAoAAA==.',Wi='Wifeleftme:AwABCAEABAoAAQYAO9YICBgABAo=.Winchèster:AwABCAMABRQCAwAIAQhhEABRz9kCBAoAAwAIAQhhEABRz9kCBAoAAA==.',Wr='Wrap:AwACCAYABRQCBAACAQgXAgBJoKgABRQABAACAQgXAgBJoKgABRQAAA==.',Wy='Wylidrana:AwAGCAUABAoAAQMALMgCCAYABRQ=.',['W�']='Wìndrush:AwABCAEABRQCAwAIAQh5FABOULUCBAoAAwAIAQh5FABOULUCBAoAAA==.',Xa='Xavaain:AwADCAUABAoAAA==.',Xd='Xd:AwABCAIABRQAAA==.',Ya='Yamon:AwACCAQABAoAAA==.',Za='Zahel:AwAICAgABAoAAA==.Zalzaki:AwAICBgABAoCHAAIAQhlAABEV5ACBAoAHAAIAQhlAABEV5ACBAoAAA==.',Ze='Zereora:AwAECAIABAoAAA==.',Zh='Zhutalan:AwAFCAEABAoAAA==.',Zi='Zilyn:AwAFCAwABAoAAA==.',['Ø']='Øzai:AwAFCAUABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end