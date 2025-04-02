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
 local lookup = {'Shaman-Enhancement','Rogue-Subtlety','Rogue-Assassination','Unknown-Unknown','Hunter-Marksmanship','Hunter-BeastMastery','Priest-Discipline','Priest-Holy','Mage-Frost','Shaman-Restoration','Priest-Shadow','Warlock-Destruction','Warrior-Arms','Warrior-Fury','Paladin-Retribution','Paladin-Protection','Evoker-Devastation','Druid-Restoration','DeathKnight-Blood','DeathKnight-Unholy','DemonHunter-Havoc','Mage-Fire','Warlock-Demonology','Monk-Windwalker','Monk-Mistweaver','Druid-Balance','Shaman-Elemental','Paladin-Holy',}; local provider = {region='US',realm='Destromath',name='US',type='weekly',zone=42,date='2025-03-28',data={Ab='Abra:AwAGCBAABAoAAA==.',Ac='Acura:AwACCAIABAoAAA==.',Ad='Adeille:AwAGCAcABAoAAA==.',Ae='Aeddann:AwAICAgABAoAAA==.Aelarien:AwABCAEABAoAAQEAUHcECAsABRQ=.Aeleren:AwAICBYABAoDAgAIAQjJBwBHYZUCBAoAAgAIAQjJBwBHYZUCBAoAAwAEAQhDHAAp0sQABAoAAQEAUHcECAsABRQ=.',Ah='Ahnakal:AwABCAEABAoAAQQAAAAGCBAABAo=.',Al='Alalletsa:AwAECAIABAoAAA==.Alanmdh:AwAFCA8ABAoAAA==.Allegrata:AwAHCBIABAoAAA==.',Ar='Arcz:AwAGCA4ABAoAAA==.',As='Asenath:AwAGCA0ABAoAAA==.',Ba='Bajoojoo:AwABCAEABRQDBQAIAQhBCABZRGMCBAoABQAGAQhBCABbpmMCBAoABgAEAQiIWwA4PxQBBAoAAA==.Baka:AwAFCAEABAoAAA==.',Be='Beeneek:AwACCAIABAoAAA==.Berisha:AwACCAIABAoAAA==.',Bi='Bigblackhawk:AwAECAMABAoAAA==.',Bl='Blackinese:AwAICBkABAoDBwAIAQjDDgBBJgoCBAoABwAIAQjDDgA8gQoCBAoACAAFAQg3HABM36EBBAoAAA==.Bloodpocket:AwAECAIABAoAAA==.Bluestage:AwACCAIABAoAAA==.',Bo='Bolthir:AwABCAMABAoAAQkARucHCCAABAo=.Bolthirbolts:AwAHCCAABAoCCQAHAQhSEwBG5x8CBAoACQAHAQhSEwBG5x8CBAoAAA==.Bongzillattv:AwAFCAcABAoAAA==.Boss:AwAFCA4ABAoAAA==.',Br='Brewmojo:AwAICBIABAoAAA==.',Bu='Bubbz:AwADCAcABAoAAA==.Bullpup:AwAHCCMABAoCCgAHAQhAGABB3PsBBAoACgAHAQhAGABB3PsBBAoAAA==.Burt:AwACCAQABAoAAA==.',['B�']='Båstët:AwAGCA4ABAoAAA==.',Ca='Caalis:AwEICBAABAoAAA==.Callea:AwAHCCUABAoDBwAHAQieEQA6u+ABBAoABwAHAQieEQA6u+ABBAoACwABAQgNSwARNSkABAoAAA==.Camellia:AwAFCAYABAoAAA==.Catboidaddy:AwAECAIABAoAAQwARJ8DCAYABRQ=.Catechism:AwACCAMABRQDBwAIAQivHQAbNVcBBAoABwAIAQivHQASVFcBBAoACAAHAQjxKwATfioBBAoAAA==.',Ch='Cheesedragon:AwAGCBEABAoAAA==.Chugbug:AwABCAEABRQDDQAIAQiyEwBEwK4BBAoADQAFAQiyEwBLmK4BBAoADgAFAQjaJwBCcoUBBAoAAA==.',Cl='Clearlylight:AwABCAIABRQDDwAHAQisIABR1XACBAoADwAHAQisIABR1XACBAoAEAABAQg8PgAPkR8ABAoAAA==.Clubberlang:AwADCAQABAoAAA==.',Cp='Cptnafraido:AwAECAsABAoAAA==.',Cr='Crilla:AwABCAEABAoAAA==.',Cu='Cuttymofukuh:AwAECAQABAoAAQQAAAAGCAkABAo=.',Cy='Cybelis:AwAECAcABAoAAA==.Cynleis:AwABCAEABAoAAQQAAAAICBIABAo=.',Da='Dangnabbit:AwEHCBsABAoCEAAHAQgpCgBBXgECBAoAEAAHAQgpCgBBXgECBAoAAA==.Dannaris:AwACCAQABRQAAA==.Daranir:AwADCAQABAoAAA==.Darkblué:AwAECAQABAoAAA==.',De='Deadpinch:AwAFCAEABAoAAA==.Deadwolv:AwADCAYABAoAAA==.',Di='Dinga:AwAFCAUABAoAAA==.',Dl='Dliqnt:AwAECAcABAoAAA==.',Dr='Draconectar:AwAECAsABAoAAA==.Dragoncecil:AwAECAcABAoAAA==.Drakho:AwAECAQABAoAAA==.Drakkar:AwADCAEABAoAAA==.Dreezius:AwADCAYABRQCEQADAQisAgBM/B0BBRQAEQADAQisAgBM/B0BBRQAAA==.Drelle:AwAGCA4ABAoAAA==.Droll:AwADCAcABAoAAA==.',Ea='Eatmyrock:AwAECAQABAoAAA==.',Ee='Eevuhl:AwABCAEABAoAAA==.',Eg='Eggrotfemboy:AwAFCAgABAoAAQQAAAAGCAYABAo=.',El='Electroshock:AwAICAYABAoAAA==.',En='Enjuu:AwAFCBEABAoAAA==.',Ep='Ephsy:AwAGCAoABAoAAA==.',Er='Erebûs:AwAGCAYABAoAAQQAAAAGCAkABAo=.Eriaelyn:AwABCAEABAoAAA==.',Fa='Fade:AwACCAEABAoAAA==.',Fe='Fett:AwAECAYABAoAAA==.',Fh='Fhab:AwAICAgABAoAAA==.',Fi='Fixibik:AwAECAMABAoAAA==.',Fl='Florinne:AwAGCA0ABAoAAA==.Flott:AwAGCA4ABAoAAA==.',Fo='Fortyounce:AwACCAIABAoAARIAXBsDCAQABRQ=.',Fr='Frest:AwAECAYABAoAAA==.Frostedflake:AwAECAcABAoAAA==.Frostydurp:AwADCAUABRQCCQADAQjgAABCjQcBBRQACQADAQjgAABCjQcBBRQAAA==.',Fu='Fuknatku:AwAHCAgABAoAAA==.Funeralbread:AwABCAEABAoAAA==.',Gl='Glipbobotank:AwAECAwABRQCEwAEAQiAAABZIqoBBRQAEwAEAQiAAABZIqoBBRQAAA==.',Gr='Grandydin:AwAECAgABAoAAA==.Grapple:AwAFCAYABAoAAA==.',Ha='Harrokk:AwACCAIABAoAAA==.Haveck:AwAICAgABAoAAA==.',He='Heaton:AwADCAMABRQDDgAIAQhmDwBTCncCBAoADgAIAQhmDwBIc3cCBAoADQAEAQgKJAAqFPAABAoAAA==.Hellreiser:AwABCAEABRQCDwAHAQg8HgBXjH4CBAoADwAHAQg8HgBXjH4CBAoAAA==.Hellusive:AwACCAIABAoAAA==.Heävymetal:AwAECAcABAoAAA==.',Ho='Holymofuk:AwAGCAkABAoAAA==.Holypoca:AwAHCAcABAoAAA==.Holypony:AwAGCA4ABAoAAA==.Honeybuns:AwABCAEABAoAAA==.',Il='Ilidanyewest:AwAFCAcABAoAAA==.Illitotem:AwADCAcABAoAAA==.',Im='Imply:AwADCAIABAoAAA==.',It='Itshebum:AwAFCA8ABAoAAA==.',Iz='Izukumidorya:AwACCAEABAoAAA==.',Je='Jephph:AwAHCAMABAoAAA==.',Ju='Judgemoont:AwAHCA8ABAoAAQQAAAAHCA8ABAo=.',Ka='Kabrxis:AwACCAIABAoAAA==.Kazarez:AwADCAMABAoAAQQAAAAGCBAABAo=.',Ke='Kelh:AwAGCAsABAoAAA==.Ketheric:AwAECAQABAoAAA==.',Kn='Knifepuppy:AwACCAIABAoAAA==.',Ku='Kuloz:AwAECAIABAoAAA==.',['K�']='Königs:AwABCAEABRQAAA==.Königsberg:AwACCAEABAoAAQQAAAABCAEABRQ=.',La='Lawakaika:AwAFCBAABAoAAA==.',Li='Lindrelisa:AwACCAEABAoAAA==.',Lo='Locky:AwAECAMABAoAAA==.Loverboi:AwAFCAYABAoAAA==.',Lu='Lunagoodlove:AwABCAEABAoAAA==.Lutes:AwABCAEABAoAARQALRwDCAYABRQ=.Lutesectomy:AwADCAYABRQCFAADAQiSAwAtHO8ABRQAFAADAQiSAwAtHO8ABRQAAA==.',Ly='Lytta:AwADCAYABRQCFQADAQjUBwAmBtoABRQAFQADAQjUBwAmBtoABRQAAA==.',Ma='Madkingog:AwAGCAsABAoAAA==.Marelle:AwAHCBAABAoAAA==.',Me='Meshuugo:AwAHCBYABAoCBQAHAQiGDQBBlPwBBAoABQAHAQiGDQBBlPwBBAoAAA==.',Mi='Milashandi:AwADCAIABAoAAQQAAAAECAcABAo=.Milkisdank:AwABCAEABRQAAA==.Milkkratem:AwADCAQABRQCFgAIAQiDBgBcnxUDBAoAFgAIAQiDBgBcnxUDBAoAAA==.Minioreos:AwAECAgABAoAAA==.Missvanjie:AwABCAIABRQCEQAHAQgWBQBeROECBAoAEQAHAQgWBQBeROECBAoAAA==.Mistalgia:AwABCAEABAoAAA==.Miutsuki:AwABCAMABRQCFwAIAQhqBQAwHicCBAoAFwAIAQhqBQAwHicCBAoAAA==.',Mo='Moralewar:AwABCAEABAoAAA==.Morelm:AwAFCAIABAoAAA==.Moris:AwAECAkABAoAAQQAAAAGCAoABAo=.Mothbruh:AwADCAcABAoAAA==.',Na='Naxxremìs:AwAGCAwABAoAAA==.',Ni='Nianni:AwACCAIABAoAAQQAAAAGCBAABAo=.Nibii:AwACCAEABAoAAA==.Ninjasocks:AwAFCAkABAoAAA==.Nizzy:AwACCAUABRQCFQACAQikDQAfdpAABRQAFQACAQikDQAfdpAABRQAAA==.',Nw='Nwoye:AwAECAUABAoAAA==.',Ny='Nysiss:AwADCAUABAoAAA==.',Ok='Okiedoky:AwAFCAUABAoAAA==.',Om='Omezz:AwAECAcABAoAAA==.Omnilach:AwAGCA4ABAoAAA==.Omnomnom:AwAFCA8ABAoAAA==.',On='Onemeanduck:AwAGCA4ABAoAAA==.Onyxwolves:AwACCAEABAoAAA==.',Or='Orthic:AwABCAEABAoAAA==.',Pa='Parpilmonk:AwABCAEABAoAAA==.',Pi='Piker:AwAFCAsABAoAAA==.',Po='Popozhao:AwABCAMABRQDGAAIAQh9CwBBgHICBAoAGAAHAQh9CwBJQ3ICBAoAGQADAQgPSgAQnJYABAoAAA==.',Pu='Punchman:AwABCAEABRQCGAAGAQiQDgBUWjwCBAoAGAAGAQiQDgBUWjwCBAoAAA==.',Pw='Pwncess:AwAHCA8ABAoAAA==.',Ra='Raikirii:AwABCAEABRQAAA==.Rakka:AwADCAUABAoAAA==.',Re='Regstorm:AwABCAEABAoAAA==.Remonkz:AwAICAMABAoCGQADAQhaWgAFTE4ABAoAGQADAQhaWgAFTE4ABAoAAA==.Revan:AwAFCA4ABAoAAA==.',Ri='Rishix:AwAICAQABAoAAA==.Rishx:AwAICAIABAoAAA==.',Ro='Rokash:AwACCAIABAoAAA==.Roque:AwADCAMABAoAAA==.',Ru='Rumplez:AwABCAEABRQAAA==.',Sa='Saelzington:AwAGCA4ABAoAAA==.Sargeraz:AwAICAgABAoAAA==.Saucebòss:AwAFCAEABAoAAA==.',Sc='Schmomeister:AwADCAMABAoAAA==.Scroatotem:AwABCAEABAoAAA==.',Se='Seagul:AwADCAQABRQDEgAIAQghAgBcGycDBAoAEgAIAQghAgBcGycDBAoAGgABAQiWZABCdUYABAoAAA==.Semirhage:AwAHCAkABAoAARYAW00DCAYABRQ=.',Sg='Sgtfrosty:AwAICBAABAoAAA==.Sgtshifter:AwAICBAABAoAAA==.',Sh='Shadowcheed:AwADCAMABAoAAA==.Shaymiin:AwACCAIABAoAAA==.Shimmew:AwADCAMABRQDBQAIAQjOBABbU8ECBAoABQAIAQjOBABZusECBAoABgAGAQhIPQBPb5QBBAoAAA==.',Si='Sillysaurid:AwABCAMABRQCGgAIAQgDCQBWoeECBAoAGgAIAQgDCQBWoeECBAoAAA==.Sixtyninepal:AwACCAMABAoAAA==.',So='Softkitten:AwAGCAYABAoAAA==.Solarmonk:AwADCAYABRQCGAADAQhSBAAeq9UABRQAGAADAQhSBAAeq9UABRQAAA==.',Sp='Spadeous:AwABCAIABRQCCAAGAQj/GgA6EawBBAoACAAGAQj/GgA6EawBBAoAAA==.Spippey:AwAFCAYABAoAAA==.',St='Stalladin:AwACCAUABAoAAA==.Starflight:AwAFCAwABAoAAA==.Stashia:AwADCAIABAoAAA==.Stonemover:AwAECAUABAoAAA==.Strike:AwAECAcABAoAAQQAAAAFCAsABAo=.Stuuida:AwABCAEABAoAAA==.',Sw='Swagmonsta:AwADCAYABAoAAA==.Swayatta:AwABCAEABAoAAA==.Swaycos:AwAGCBIABAoAAA==.',Ta='Taevis:AwACCAEABAoAAA==.',Tb='Tboy:AwAECAQABAoAAA==.',Tf='Tft:AwABCAEABRQAAA==.',Th='Thickbottom:AwACCAIABAoAAA==.Thugbug:AwAECAUABAoAAA==.',Ti='Ticalpi:AwADCAQABAoAAA==.Ticklemytots:AwAFCAsABAoAAA==.Tirynis:AwEICAIABAoAAA==.',Ty='Tyalexzander:AwADCAUABAoAAA==.Tyronbigadin:AwACCAQABAoAAA==.',Uh='Uhtredd:AwAFCAYABAoAAA==.',Ve='Venjuu:AwABCAMABRQCGwAIAQiCAgBZGDMDBAoAGwAIAQiCAgBZGDMDBAoAAA==.Venusx:AwADCAkABAoAAQYAToQGCBcABAo=.Vextherius:AwABCAEABAoAAQQAAAAECAQABAo=.Vextheriá:AwAECAQABAoAAA==.Veygg:AwABCAEABRQAAA==.',Vi='Vierei:AwADCAYABAoAAA==.',Vl='Vlut:AwABCAEABRQAAA==.',Vo='Volbouridor:AwADCAMABAoAAQQAAAAICAMABAo=.Vorztrix:AwAGCBcABAoCBgAGAQhpKQBOhAgCBAoABgAGAQhpKQBOhAgCBAoAAA==.',Wa='Waterincone:AwAHCBYABAoCBQAHAQj6AwBfy9kCBAoABQAHAQj6AwBfy9kCBAoAAA==.',Wh='Whatisdamage:AwADCAMABAoAAA==.Whorabldruid:AwAECAIABAoAAA==.Whorablemage:AwACCAIABAoAAA==.',Wi='Wildshøt:AwAECAkABAoAAA==.',Wu='Wubbzy:AwAECAQABAoAAQQAAAAGCAMABAo=.',['W�']='Wìsdom:AwAFCAEABAoAAA==.',Xa='Xasp:AwACCAMABRQDHAAIAQimAgBVbN8CBAoAHAAIAQimAgBVbN8CBAoADwABAQig+AAkqi8ABAoAAA==.',Xe='Xerias:AwAFCA8ABAoAAA==.',Xi='Xieno:AwAFCAUABAoAAA==.',Xl='Xleander:AwACCAIABAoAAA==.',Xo='Xovyt:AwADCAYABRQDDAADAQhDBABEn/cABRQADAADAQhDBABCJfcABRQAFwABAQiWBQA9Mk8ABRQAAA==.',Ya='Yagnar:AwAICAgABAoAAA==.',Yo='Yoniss:AwACCAIABAoAAA==.',Za='Zarliri:AwADCAQABAoAAQQAAAADCAYABAo=.',Zo='Zohar:AwAECAYABAoAAA==.',Zu='Zuenname:AwAECAEABAoAAA==.',['Z�']='Záppy:AwADCAQABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end