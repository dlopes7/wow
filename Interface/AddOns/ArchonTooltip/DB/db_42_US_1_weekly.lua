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
 local lookup = {'Rogue-Assassination','Paladin-Retribution','Evoker-Devastation','Unknown-Unknown','Hunter-BeastMastery','Paladin-Protection','DemonHunter-Havoc','DeathKnight-Frost','Warrior-Protection','Druid-Balance','Monk-Mistweaver','Mage-Frost','DemonHunter-Vengeance','Priest-Holy','Druid-Feral','Druid-Restoration','Warrior-Arms','Warrior-Fury','Mage-Fire','Priest-Shadow','Warlock-Affliction','Warlock-Destruction','Rogue-Subtlety','Monk-Brewmaster','Shaman-Enhancement','Evoker-Preservation',}; local provider = {region='US',realm='Aegwynn',name='US',type='weekly',zone=42,date='2025-03-29',data={Ac='Acienlahora:AwADCAIABAoAAA==.',Ad='Adrastos:AwABCAEABAoAAA==.Adrenal:AwABCAEABAoAAA==.',Ah='Ahzidal:AwAFCAUABAoAAA==.',Ai='Airbinwl:AwAFCAEABAoAAA==.',Al='Alexiathorne:AwADCAwABAoAAA==.Alicebuff:AwAECAEABAoAAA==.Aliciandra:AwABCAEABAoAAA==.Alivana:AwADCAUABAoAAA==.Alèx:AwAFCA4ABAoAAA==.',Am='Amaterasü:AwAGCA8ABAoAAA==.',An='Angren:AwADCAMABAoAAA==.',Ar='Aragons:AwACCAIABAoAAA==.Arioch:AwAICAgABAoAAA==.Arlanios:AwABCAEABAoAAA==.Aronis:AwACCAIABAoAAA==.',As='Asterìa:AwADCAEABAoAAA==.',Av='Averich:AwAGCAQABAoAAA==.',Aw='Aware:AwACCAUABRQCAQACAQjWAgBSy7cABRQAAQACAQjWAgBSy7cABRQAAA==.',Az='Azurekurama:AwAICA4ABAoAAA==.',Ba='Baboya:AwAECAMABAoAAA==.Ballthezar:AwABCAEABAoAAA==.Balzofire:AwAFCAIABAoAAA==.Balztodawalz:AwABCAEABRQCAgAHAQjkHwBStn4CBAoAAgAHAQjkHwBStn4CBAoAAA==.Banehollow:AwACCAIABAoAAA==.Basticus:AwADCAYABAoAAA==.Battlebear:AwAHCAcABAoAAA==.',Be='Beanie:AwADCAIABAoAAA==.Bellyjelly:AwAGCAEABAoAAA==.Bennyboy:AwACCAUABRQCAwACAQjCBgBEt6gABRQAAwACAQjCBgBEt6gABRQAAA==.Bennylock:AwAGCAkABAoAAQMARLcCCAUABRQ=.Berserkguts:AwAECAMABAoAAA==.',Bi='Bighippo:AwACCAMABAoAAA==.',Bl='Blazinzerker:AwAICAgABAoAAA==.',Bo='Bonnetta:AwABCAEABAoAAA==.',Br='Breedin:AwABCAEABAoAAA==.Brufknight:AwAECAYABAoAAA==.',Bu='Buzan:AwABCAEABAoAAA==.',Ca='Caibutou:AwAFCAEABAoAAA==.Calasindre:AwAFCAsABAoAAA==.',Ch='Chaoscat:AwAHCAsABAoAAA==.Chillenbeard:AwACCAIABAoAAQQAAAAGCAEABAo=.',Ci='Cindyryujin:AwAICAgABAoAAA==.',Co='Coffeesbow:AwADCAcABAoAAQQAAAAHCAsABAo=.Coomer:AwAGCAsABAoAAA==.',Cr='Crotailor:AwAICAgABAoCBQAGAQjFkgAPoHwABAoABQAGAQjFkgAPoHwABAoAAA==.',Cu='Curiousray:AwADCAMABAoAAA==.',Cy='Cyrus:AwACCAQABAoAAA==.Cysterfyster:AwAHCBQABAoDBgAHAQhiDwBAAqEBBAoABgAHAQhiDwA3IaEBBAoAAgAEAQi9ewBEBiYBBAoAAA==.',Da='Dabbsimus:AwADCAMABAoAAA==.Dahaaka:AwAFCA4ABAoAAA==.Danhunter:AwAGCA0ABAoAAA==.Darknarsin:AwADCAMABAoAAA==.Davidwan:AwABCAEABRQAAA==.Daze:AwAGCA8ABAoAAA==.',De='Deathful:AwACCAcABRQCBwACAQgjCwA+eKwABRQABwACAQgjCwA+eKwABRQAAA==.Dedaraydria:AwAGCAgABAoAAA==.',Dh='Dhdog:AwAECAUABAoAAA==.',Do='Dodgen:AwEGCAoABAoAAA==.',Dr='Dradoath:AwAECAEABAoAAA==.Dragindeezz:AwAGCA0ABAoAAA==.Dragoncito:AwABCAEABAoAAA==.Dragónball:AwABCAEABAoAAA==.Dravenuz:AwAFCAIABAoAAA==.Drewphus:AwAICBYABAoCCAAIAQgOBABGOoYCBAoACAAIAQgOBABGOoYCBAoAAA==.Drhealgood:AwAFCAcABAoAAA==.Drone:AwAHCAkABAoAAQkAYVgCCAUABRQ=.Druiden:AwACCAQABRQCCgAIAQgZBwBUiwMDBAoACgAIAQgZBwBUiwMDBAoAAA==.',Ei='Eigenvectors:AwAICAgABAoAAA==.Eillirras:AwAHCA4ABAoAAA==.Eilys:AwACCAMABAoAAQsAQVQBCAIABRQ=.',El='Eleinna:AwAFCA8ABAoAAA==.Elizabethi:AwADCAQABAoAAA==.Elrion:AwABCAEABRQAAA==.Elrioth:AwAICBgABAoCDAAIAQhWEwA15SkCBAoADAAIAQhWEwA15SkCBAoAAA==.',Er='Erarvien:AwACCAIABAoAAQQAAAADCAUABAo=.',Es='Espresso:AwAHCAsABAoAAA==.',Et='Ethee:AwABCAEABAoAAA==.',Ev='Evonohn:AwABCAEABAoAAA==.',Ez='Ezeque:AwAECAUABAoAAA==.Ezrabunbun:AwAHCA0ABAoAAA==.',Fa='Falaszun:AwAICBgABAoCDQAIAQiUAwBSuNsCBAoADQAIAQiUAwBSuNsCBAoAAA==.Faluna:AwABCAIABRQCDgAIAQjHBgBKobQCBAoADgAIAQjHBgBKobQCBAoAAA==.',Fe='Fe:AwAHCBYABAoCCgAHAQjjFwBJ8DICBAoACgAHAQjjFwBJ8DICBAoAAA==.',Fl='Flaypeebird:AwAGCAwABAoAAA==.Flowerx:AwADCAEABAoAAA==.',Fo='Form:AwACCAMABAoAAA==.',Fr='Fregore:AwADCAMABAoAAA==.Frooza:AwAECAEABAoAAA==.',Fu='Furryarthur:AwABCAEABAoAAA==.',['F�']='Føøtballhead:AwAICBEABAoAAA==.',Ga='Gabicanh:AwADCAMABAoAAA==.Gabipalc:AwACCAIABAoAAA==.Gabrinator:AwABCAEABAoAAA==.',Ge='Geø:AwAFCAgABAoAAA==.',Gi='Giantess:AwAHCBMABAoAAA==.Giggless:AwAHCBYABAoCAgAHAQgnNwA9lA0CBAoAAgAHAQgnNwA9lA0CBAoAAA==.Gilsaur:AwAECAYABAoAAA==.Girlpaladin:AwAGCAoABAoAAA==.',Go='Gobay:AwADCAUABAoAAA==.Gomie:AwABCAEABRQDDwAHAQhvCAA3Bc8BBAoADwAGAQhvCAA94s8BBAoAEAABAQg4WgANcywABAoAAA==.Gorillamage:AwAFCAwABAoAAA==.',Gr='Grazlekroz:AwAHCBYABAoCCgAHAQjkMAAf8WEBBAoACgAHAQjkMAAf8WEBBAoAAA==.Greatdeku:AwAGCBIABAoAAA==.Greyleb:AwABCAEABRQAAA==.Grung:AwAGCAoABAoAAA==.',Gu='Gumbyalqizm:AwAICBcABAoCAgAIAQjkNgA2sQ4CBAoAAgAIAQjkNgA2sQ4CBAoAAA==.Gunthurr:AwABCAEABAoAAA==.',Gy='Gynecologist:AwADCAUABAoAAQEAUssCCAUABRQ=.',['G�']='Gîbby:AwABCAEABRQCEAAIAQgtCgBC410CBAoAEAAIAQgtCgBC410CBAoAAA==.',He='Helloexcel:AwADCAoABAoAAA==.Hellslord:AwAICBAABAoAAA==.Hepp:AwACCAIABAoAAA==.',Hi='Hijosol:AwADCAMABAoAAA==.Himtyson:AwABCAEABAoAAA==.',Ho='Hodgey:AwAICBcABAoEEQAIAQiLCgBLdEgCBAoAEQAHAQiLCgBGR0gCBAoAEgAHAQh7GQA//xICBAoACQABAQi2JQAZHzMABAoAAA==.Holycrapola:AwADCAsABAoAAA==.Hotstreak:AwAHCBQABAoCEwAHAQheIQA/D/0BBAoAEwAHAQheIQA/D/0BBAoAAA==.',Hu='Huhuwarnin:AwABCAIABAoAAA==.Huntinz:AwAFCAgABAoAAA==.',Hy='Hyorin:AwADCAgABAoAAA==.',Ic='Iceyhunts:AwABCAEABAoAAA==.',Im='Imacöw:AwACCAIABAoAAA==.',In='Iniingg:AwAHCAcABAoAAA==.Insanewaffle:AwADCAMABAoAAA==.',Ip='Ipaska:AwABCAEABRQAAA==.',Is='Isuppose:AwAHCAYABAoAAA==.',It='Itsbatien:AwAHCBMABAoAAA==.',Ja='Jahko:AwABCAEABAoAAA==.Jamesmcclave:AwAECAsABAoAAA==.Jax:AwAECAEABAoAAA==.Jayia:AwAICBQABAoCEwAIAQioFwA/01kCBAoAEwAIAQioFwA/01kCBAoAAA==.',Jh='Jhonofjimmy:AwAICAEABAoAAA==.',Ji='Jimadlertx:AwAHCBQABAoCAgAHAQilagAYLFYBBAoAAgAHAQilagAYLFYBBAoAAA==.',Ka='Kaikah:AwAICAgABAoAAA==.Kaorinite:AwABCAEABRQCFAAHAQgVDQBI+GYCBAoAFAAHAQgVDQBI+GYCBAoAAA==.Karismâ:AwADCAQABAoAAA==.Kartsunpally:AwACCAIABAoAAQQAAAAFCA4ABAo=.Kartzondk:AwAFCA4ABAoAAA==.Kaskiz:AwACCAYABAoAAA==.Kazmal:AwABCAIABAoAAA==.',Ke='Keirakai:AwACCAQABAoAAA==.Kelorein:AwADCAEABAoAAA==.Kendoku:AwAFCAsABAoAAQQAAAABCAEABRQ=.Keyelements:AwADCAQABAoAAA==.',Ki='Kimanip:AwAICAgABAoAAA==.Kirin:AwABCAEABAoAAA==.',Kn='Knoom:AwAGCBAABAoAAA==.',Ko='Kolu:AwAICAQABAoAAA==.',Kr='Krell:AwACCAMABAoAAA==.Kriddy:AwAECAUABAoAAA==.',['K�']='Káydó:AwADCAIABAoAAA==.',La='Laeparkbench:AwACCAIABAoAAQQAAAAGCA4ABAo=.Lainiwakura:AwAECAYABAoAAA==.',Le='Leguiz:AwAFCA4ABAoAAA==.Lemonsquash:AwACCAIABAoAAA==.Lemontree:AwAICAYABAoAAA==.',Li='Lilmittens:AwAECAQABAoAAA==.Lilteddyg:AwAFCAYABAoAAA==.',Lo='Lobalance:AwAFCAUABAoAAA==.Lokrosa:AwAHCBIABAoAAA==.Lonelypally:AwACCAQABAoAAA==.',Lu='Lucet:AwAHCAsABAoAAA==.',['L�']='Löckrocks:AwAECAgABAoAAA==.',Ma='Madarm:AwAICAgABAoAAA==.Maelliana:AwACCAIABAoAAA==.Makuxixi:AwEBCAEABAoAAA==.Manatees:AwAICBUABAoCFQAIAQgsAQBS3M4CBAoAFQAIAQgsAQBS3M4CBAoAAA==.Marimadelene:AwAFCAkABAoAAA==.Marquessan:AwAECAUABAoAAA==.Martelstorm:AwADCAYABAoAAA==.Mattatk:AwABCAEABAoAAA==.Maxflow:AwACCAIABAoAAA==.',Me='Medgevon:AwAGCAEABAoAAA==.Meion:AwABCAEABAoAAA==.',Mh='Mhoria:AwADCAcABAoAAA==.',Mi='Mistyteapot:AwABCAEABRQCCwAHAQhMJwAjmWkBBAoACwAHAQhMJwAjmWkBBAoAAA==.',Mo='Mokthul:AwAHCAkABAoAAA==.Moosetafa:AwAFCAwABAoAAA==.Moosubi:AwAFCAgABAoAAA==.Mooudini:AwAECAYABAoAAA==.Morphyus:AwABCAMABRQCEAAIAQghDQA5/iwCBAoAEAAIAQghDQA5/iwCBAoAAA==.',Mu='Mutilager:AwADCAMABAoAAA==.',Na='Nastirox:AwAFCAYABAoAAA==.',Ne='Nejedi:AwACCAMABAoAAA==.Nelfmeta:AwAECAEABAoAAA==.',Ni='Nicholai:AwADCAMABAoAAA==.Nicki:AwACCAIABAoAAA==.Nihilist:AwACCAQABAoAAQQAAAAGCAYABAo=.Niina:AwADCAMABAoAAQsATvYHCBUABAo=.Nimica:AwAECAgABAoAAA==.',No='Noobslayerr:AwAGCBYABAoCCgAGAQiJKgA2zY0BBAoACgAGAQiJKgA2zY0BBAoAAA==.Noopy:AwAHCAsABAoAAA==.Noteily:AwABCAIABRQCCwAIAQhsCgBBVJwCBAoACwAIAQhsCgBBVJwCBAoAAA==.',Nu='Nuvem:AwAFCAwABAoAAA==.',Ny='Nymira:AwAICBkABAoCBQAIAQgdGgBDZIUCBAoABQAIAQgdGgBDZIUCBAoAAA==.',Oc='Octane:AwADCAQABAoAAA==.',Od='Odyssa:AwAFCAgABAoAAQUAVAoDCAgABRQ=.',On='Oniichanx:AwABCAEABAoAAA==.Oniichanxd:AwACCAMABRQCAgAIAQjTDwBYQPACBAoAAgAIAQjTDwBYQPACBAoAAA==.',Oo='Oolong:AwAICAIABAoAAA==.',Pa='Palared:AwAICBgABAoCAgAIAQh2KABEWk8CBAoAAgAIAQh2KABEWk8CBAoAAA==.Pantycannon:AwABCAEABRQCBQAIAQhhJgA3AyoCBAoABQAIAQhhJgA3AyoCBAoAAA==.',Pe='Pedialight:AwAICAgABAoAAA==.Pennÿ:AwADCAEABAoAAA==.',Ph='Phaze:AwABCAEABRQCFgAIAQixOgAR2zUBBAoAFgAIAQixOgAR2zUBBAoAAA==.Philoktetes:AwABCAEABRQCCAAHAQjZAgBcOswCBAoACAAHAQjZAgBcOswCBAoAAA==.',Po='Poiison:AwABCAEABAoAAA==.Popmosh:AwAGCAUABAoAAA==.Pow:AwAECAsABAoAAA==.',Ra='Raellé:AwADCAQABAoAAA==.Rakrahirn:AwAFCAEABAoAAA==.Ramlethal:AwABCAMABRQAAA==.Razerbuff:AwADCAMABAoAAA==.',Re='Reaps:AwAICAgABAoAAA==.Redpee:AwACCAMABAoAAQIARFoICBgABAo=.Redrellan:AwABCAEABAoAAA==.Redwindy:AwABCAEABAoAAA==.Rekenize:AwAFCAwABAoAAA==.',Rh='Rhythm:AwAECAEABAoAAA==.',Ro='Roaka:AwAFCAUABAoAAA==.Rockette:AwADCAcABAoAAA==.Rocknuts:AwAFCAYABAoAAA==.Rogued:AwAICBgABAoCFwAIAQiVAwBWNgEDBAoAFwAIAQiVAwBWNgEDBAoAAA==.Rokhan:AwAICAsABAoAAA==.Rookermooke:AwACCAIABAoAAQQAAAABCAEABRQ=.Rowdawg:AwAECAcABAoAAA==.',Ru='Rudeboyheals:AwABCAEABRQAAA==.',Sa='Sakshooter:AwAFCAgABAoAAA==.Salchypapa:AwAECAoABAoAAA==.Sanches:AwADCAYABAoAAA==.',Sc='Scv:AwACCAUABRQCCQACAQguAQBhWOMABRQACQACAQguAQBhWOMABRQAAA==.',Se='Seranitio:AwABCAEABAoAARMAP9MICBQABAo=.Serejh:AwABCAEABRQCBwAIAQhyIQAuaA4CBAoABwAIAQhyIQAuaA4CBAoAAA==.Serenitynoww:AwAICAsABAoAAA==.Sergiotaco:AwACCAEABAoAAA==.',Sh='Shnid:AwADCAcABAoAAA==.',Si='Sibilance:AwAFCAMABAoAAA==.Sigrùn:AwACCAQABAoAAQQAAAADCAMABAo=.Sillyhots:AwACCAEABAoAAA==.Siofremm:AwAECAoABAoAAA==.',Sk='Skibidipp:AwABCAEABAoAAA==.Skotanx:AwAHCA0ABAoAAA==.',Sl='Slabull:AwAGCAwABAoAAA==.Slamford:AwACCAIABAoAAA==.',So='Soipt:AwAFCAsABAoAAA==.Somonia:AwACCAUABRQCGAACAQhWAQBfLNwABRQAGAACAQhWAQBfLNwABRQAAA==.Soupsamitch:AwACCAIABAoAAA==.',Sp='Splattercuss:AwAFCAsABAoAAA==.',St='Stender:AwAICBgABAoCBwAIAQg5CgBT5vUCBAoABwAIAQg5CgBT5vUCBAoAAA==.Stendur:AwAECAQABAoAAQcAU+YICBgABAo=.Stompalittle:AwAHCAEABAoAAQEAUssCCAUABRQ=.Stonesboyw:AwACCAIABAoAAA==.Stormm:AwAFCA8ABAoAAA==.Stormydniels:AwAGCBIABAoAAA==.Stunurazz:AwAHCBAABAoAAA==.',Su='Sunmoonstar:AwABCAEABAoAAA==.Sunsetglow:AwACCAIABRQAAA==.Superdurg:AwAECAMABAoAAA==.Suralias:AwAGCAIABAoAAA==.Surial:AwABCAEABRQAAA==.',Sw='Sweaticus:AwAECAgABAoAAA==.',Ta='Taoozz:AwAECAEABAoAAA==.Targaryin:AwABCAEABRQCAgAIAQgpKABD91ECBAoAAgAIAQgpKABD91ECBAoAAA==.Tarkslight:AwADCAMABAoAAA==.Tarrodan:AwACCAIABAoAAA==.',Te='Tealuung:AwAECAEABAoAAA==.Tenoritaiga:AwACCAIABAoAAA==.',Th='Thabootyman:AwAGCAYABAoAAA==.Thatlightboy:AwADCAIABAoAAA==.Thebigtank:AwAFCAQABAoAAA==.Thorcepriest:AwAHCBMABAoAAA==.Thoromyr:AwAGCBAABAoAAA==.Thundercats:AwABCAEABAoAAA==.Thvnder:AwAHCBUABAoCGQAHAQi+EwA5SwYCBAoAGQAHAQi+EwA5SwYCBAoAAA==.',Ti='Tiankenghu:AwAECAMABAoAAA==.Tiing:AwACCAEABAoAAA==.',To='Tobisch:AwACCAgABAoAAA==.Tofunny:AwAGCAwABAoAAA==.',Tr='Triredgy:AwABCAEABRQCGgAHAQgYBQBITksCBAoAGgAHAQgYBQBITksCBAoAAA==.',Ts='Tsakalomage:AwAICAUABAoCDAAFAQijWAANX4AABAoADAAFAQijWAANX4AABAoAAA==.Tsurisu:AwAFCAEABAoAAA==.',Tu='Turalya:AwAICBAABAoAAA==.',Tw='Twocansam:AwACCAIABAoAAA==.',['T�']='Tázed:AwABCAEABRQAAA==.',Ul='Ulddon:AwABCAIABRQAAA==.',Un='Unstuck:AwABCAEABRQCFgAIAQiTBwBSUd8CBAoAFgAIAQiTBwBSUd8CBAoAAA==.',Ut='Utherschin:AwAGCAEABAoAAA==.',Va='Varelline:AwAGCAYABAoAAA==.',Ve='Veiðimaður:AwACCAIABAoAAA==.Velistraza:AwADCAMABAoAAA==.Veraciouz:AwADCAMABAoAAA==.Vesrynn:AwAECAQABAoAAA==.',Vo='Voidas:AwABCAEABAoAAA==.',Vr='Vroak:AwAECAQABAoAAA==.',Wa='Waranar:AwADCAIABAoAAA==.Waylodps:AwAHCA4ABAoAAA==.',We='Welbiner:AwACCAMABAoAAA==.',Wh='Whoopty:AwADCAYABAoAAA==.',Wi='Wildspeakër:AwAGCBUABAoCEAAGAQgdHgA3AXMBBAoAEAAGAQgdHgA3AXMBBAoAAA==.Williamjakj:AwABCAEABAoAAA==.Wincks:AwABCAEABAoAAA==.Winterkiller:AwADCAMABAoAAA==.',Wu='Wuxidixivy:AwAECAIABAoAAA==.',Xa='Xamei:AwACCAEABAoAAA==.',Xo='Xoilbiss:AwAHCAEABAoAAA==.',Yy='Yyna:AwAECAIABAoAAA==.',Za='Zappd:AwAGCBAABAoAAA==.',Ze='Zemcatl:AwABCAEABRQAAA==.Zeål:AwABCAEABAoAAA==.',Zi='Zimdeal:AwADCAUABAoAAA==.',Zu='Zurickx:AwAECAMABAoAAA==.',Zy='Zymm:AwAGCBYABAoCGQAGAQgcGwAyOaIBBAoAGQAGAQgcGwAyOaIBBAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end