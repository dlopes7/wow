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
 local lookup = {'Warlock-Destruction','Evoker-Devastation','DeathKnight-Blood','Warrior-Arms','Warrior-Fury','Druid-Balance','Hunter-BeastMastery','Evoker-Preservation','Hunter-Marksmanship','Mage-Fire','Mage-Arcane','Unknown-Unknown','DeathKnight-Unholy','Warlock-Demonology','Warlock-Affliction','Priest-Shadow','Monk-Mistweaver','Shaman-Enhancement','Mage-Frost','Paladin-Retribution','Monk-Windwalker','DeathKnight-Frost','Shaman-Elemental','Priest-Holy','Monk-Brewmaster','DemonHunter-Vengeance','Rogue-Subtlety',}; local provider = {region='US',realm='Dragonmaw',name='US',type='weekly',zone=42,date='2025-03-29',data={Ad='Adelphie:AwACCAMABRQAAA==.',Ai='Aidasul:AwABCAEABAoAAA==.',Al='Alvar:AwACCAEABAoAAA==.',Ap='Applejackz:AwADCAEABAoAAA==.',Ar='Ariste:AwAHCA8ABAoCAQAHAQhNIAA+1ucBBAoAAQAHAQhNIAA+1ucBBAoAAA==.Arkadd:AwAHCA4ABAoCAgAHAQgmDwA+Gw8CBAoAAgAHAQgmDwA+Gw8CBAoAAA==.Arus:AwABCAIABRQAAA==.',As='Ashaxxi:AwACCAIABRQCAwAIAQg6DAA92ykCBAoAAwAIAQg6DAA92ykCBAoAAA==.Asuwish:AwADCAcABAoAAA==.',At='Atcjedi:AwAECAUABAoAAA==.',Av='Avaeya:AwADCAEABAoAAA==.',Ba='Baep:AwAFCA0ABAoAAA==.',Be='Bernthul:AwABCAEABAoAAA==.',Bi='Bizzbee:AwAECAgABAoAAA==.',Bl='Blax:AwADCAYABAoAAA==.Blindcow:AwACCAMABRQDBAAIAQhBAwBbm/oCBAoABAAHAQhBAwBfR/oCBAoABQAEAQhHOQA0WRQBBAoAAA==.',Bo='Boeuf:AwACCAQABAoAAA==.Boicrystian:AwADCAQABAoAAA==.Bombombom:AwAGCAwABAoAAA==.',Br='Brockaree:AwACCAMABAoAAA==.Bromga:AwAHCAcABAoAAA==.',Bu='Buhbles:AwACCAUABRQCBgACAQhdCABaL88ABRQABgACAQhdCABaL88ABRQAAA==.Burnadebt:AwADCAYABAoAAA==.',Ca='Cardbord:AwACCAIABAoAAA==.Carloshot:AwAGCBQABAoCBwAGAQh8RAA5OYABBAoABwAGAQh8RAA5OYABBAoAAA==.Cauterize:AwABCAEABAoAAA==.Cavaloris:AwADCAgABAoAAA==.',Ch='Chainhugs:AwABCAEABAoAAA==.Chickensalad:AwADCAEABAoAAA==.Chubsy:AwAICAYABAoAAA==.Chuckkyd:AwAFCA0ABAoAAA==.',Ci='Ciriwyn:AwAFCAwABAoAAA==.',Cl='Claugh:AwAFCAwABAoAAA==.Clocker:AwADCAMABAoAAA==.',Co='Colton:AwAFCA0ABRQCCAAFAQgIAABR4egBBRQACAAFAQgIAABR4egBBRQAAA==.Combatcow:AwACCAMABRQCBQAIAQghCQBSHtYCBAoABQAIAQghCQBSHtYCBAoAAA==.Cozmic:AwAGCBAABAoAAA==.',Cr='Crabgit:AwAICAgABAoAAA==.Craftymidget:AwAHCBUABAoCCQAHAQgxGQAo6WgBBAoACQAHAQgxGQAo6WgBBAoAAA==.Crimsonhoof:AwAECAQABAoAAA==.Crustybread:AwAHCBUABAoDCgAHAQieIABIwAUCBAoACgAHAQieIABHTAUCBAoACwABAQi/CwBavF8ABAoAAA==.',Cu='Curandero:AwABCAEABRQAAA==.',Da='Dameck:AwAHCBUABAoCBQAHAQh7FwA+ZyYCBAoABQAHAQh7FwA+ZyYCBAoAAA==.Dawgis:AwAECAYABAoAAQwAAAAFCAUABAo=.',De='Deathpetals:AwABCAIABRQCDQAIAQilAABiD4EDBAoADQAIAQilAABiD4EDBAoAAA==.Decembre:AwACCAQABRQCDQAIAQhqBQBY1A8DBAoADQAIAQhqBQBY1A8DBAoAAA==.Decepciona:AwAGCBUABAoEDgAGAQjKFwBWVhsBBAoAAQAFAQjQNQBDZlEBBAoADgADAQjKFwBYbhsBBAoADwADAQjxEABJtwABBAoAAA==.Demoos:AwAICAgABAoAAA==.Derailed:AwACCAIABAoAAQwAAAAICAgABAo=.Despir:AwAECAgABRQCEAAEAQgTAQBPn4MBBRQAEAAEAQgTAQBPn4MBBRQAAA==.Destroker:AwABCAEABAoAAA==.Devilpoing:AwAECAkABAoAAA==.',Dh='Dharén:AwACCAIABAoAAA==.',Do='Doak:AwAGCAgABAoAAA==.Dortz:AwADCAEABAoAAA==.',Dr='Dragonturd:AwADCAcABAoAAA==.Drethor:AwAGCBAABAoAAA==.',['D�']='Dáwgis:AwAFCAUABAoAAA==.Dóc:AwAICAgABAoAAA==.',El='Elspeth:AwAGCBEABAoAAA==.Elysstaa:AwAECAgABAoAAA==.',Ev='Evelyn:AwACCAMABRQCEQAIAQg5DQBDnm8CBAoAEQAIAQg5DQBDnm8CBAoAAA==.',Ex='Exaltowar:AwAGCAsABAoAAA==.',Fa='Faminex:AwAECAoABRQCEgAEAQjlAABFSH4BBRQAEgAEAQjlAABFSH4BBRQAAA==.Farns:AwAHCBUABAoCEwAHAQidBABgtwUDBAoAEwAHAQidBABgtwUDBAoAAA==.',Fe='Felinepriest:AwADCAEABAoAAA==.',Ff='Ffxivsucks:AwAGCAkABAoAAA==.',Fi='Firebäne:AwACCAQABAoAAA==.',Fl='Flarex:AwAFCAUABAoAAA==.',Fo='Foxz:AwAFCA4ABAoAAA==.',Fr='Frain:AwACCAIABAoAAA==.',Fu='Fullgabagool:AwAHCAgABAoAAREAI+YDCAYABRQ=.Fullmist:AwADCAYABRQCEQADAQjBBgAj5uAABRQAEQADAQjBBgAj5uAABRQAAA==.',Gc='Gcozz:AwAFCA0ABAoAAA==.',Gh='Ghidorah:AwABCAEABAoAAA==.',Gi='Gigastar:AwAFCAwABAoAAA==.',Gr='Grimknight:AwAHCA8ABAoAAA==.Groovi:AwADCAcABAoAAA==.Grubergeiger:AwAFCAsABAoAAA==.Gruunele:AwACCAEABAoAAA==.',Gu='Gunzandfundz:AwAHCBMABAoCEwAHAQg9FABFmR8CBAoAEwAHAQg9FABFmR8CBAoAAA==.',['G�']='Gðre:AwAICAEABAoAAA==.Gókee:AwAFCAgABAoAAA==.',Ha='Hashbrowns:AwAHCBUABAoCFAAHAQgoKQBLF0wCBAoAFAAHAQgoKQBLF0wCBAoAAA==.Hawkan:AwAHCAkABAoAAA==.Hayleythor:AwACCAIABAoAAA==.',He='Hema:AwADCAUABAoAAA==.',Ho='Hoa:AwABCAMABRQCFQAIAQjVBgBNgNcCBAoAFQAIAQjVBgBNgNcCBAoAAA==.',Hu='Hungus:AwAECAsABAoAAA==.',Hy='Hygelac:AwAICBAABAoAAA==.',['H�']='Hâra:AwACCAIABAoAAA==.',Ig='Igotchubruh:AwADCAcABAoAAA==.',In='Indigolemon:AwAHCAIABAoAAA==.Inkinjector:AwACCAMABAoAAA==.Inouskee:AwADCAQABAoAAA==.',Ja='Jahuana:AwAFCAYABAoAAA==.',Ji='Jizzoner:AwAECAMABAoAAA==.',Ju='Juuice:AwAECAUABAoAAA==.',Ka='Karona:AwADCAEABAoAAA==.Kawaiihealer:AwAFCAwABAoAAA==.',Ke='Kegrolld:AwABCAEABAoAAA==.Kev:AwACCAMABRQDBwAIAQjkDABWwPgCBAoABwAIAQjkDABWPvgCBAoACQAEAQhYJgA6cdgABAoAAA==.',Kk='Kkrantuq:AwAICBMABAoAAA==.',Kn='Knownentity:AwACCAQABAoAAA==.',Ko='Kokopuff:AwAFCAYABAoAAA==.',Kr='Krsdk:AwABCAEABRQCFgAIAQiLAQBTgh8DBAoAFgAIAQiLAQBTgh8DBAoAAA==.Krystelin:AwADCAMABAoAAA==.',Ku='Kumojo:AwADCAUABAoAAA==.',['K�']='Kênsêi:AwAECAQABAoAARQAO/oBCAEABRQ=.',Le='Leafyjoe:AwAGCAoABAoAAA==.',Lu='Lucas:AwADCAEABAoAAA==.Luvabull:AwAFCAsABAoAAA==.Luzarious:AwAECAcABRQDDQAEAQi7BQA3FbMABRQADQACAQi7BQBB7bMABRQAAwACAQgqCAAsPYcABRQAAA==.',Ma='Magerowr:AwEECAkABAoAAA==.',Me='Mengolo:AwACCAUABAoAAA==.Meray:AwAECAQABAoAAQwAAAAECAgABAo=.Mesmerise:AwADCAEABAoAAA==.',Mo='Mokari:AwEHCBUABAoCBwAHAQgdGABTq5UCBAoABwAHAQgdGABTq5UCBAoAAA==.Monkel:AwACCAMABAoAAA==.Moonslights:AwAGCBEABAoAAA==.Morglum:AwABCAEABRQAAA==.',Ms='Mstrhybryd:AwAGCA0ABAoAAA==.',['M�']='Mäwl:AwAGCBQABAoCFwAGAQiLGABD98QBBAoAFwAGAQiLGABD98QBBAoAAQwAAAAICAgABAo=.',Na='Narunî:AwAHCBEABAoAAA==.',Ne='Neauxla:AwAFCAkABAoAAA==.Neciena:AwAHCBUABAoCGAAHAQjSDABNnk8CBAoAGAAHAQjSDABNnk8CBAoAAA==.Nee:AwAHCAoABAoAAA==.',Ni='Nikes:AwAECAYABAoAAA==.',No='Nomtok:AwAICAYABAoAAA==.',['N�']='Nêllìël:AwABCAEABRQCFAAHAQhkOQA7+gMCBAoAFAAHAQhkOQA7+gMCBAoAAA==.Nímmue:AwAHCBUABAoCBwAHAQiIJQBFJi8CBAoABwAHAQiIJQBFJi8CBAoAAA==.',Og='Ogre:AwACCAMABRQCEgAIAQisAgBceDkDBAoAEgAIAQisAgBceDkDBAoAAA==.',Or='Oreojeezcake:AwADCAUABAoAAA==.',Ow='Owlette:AwABCAEABRQAAA==.',Pa='Painfrayne:AwAFCAkABAoAAA==.Palmarez:AwABCAEABRQAAA==.Papas:AwAECAQABAoAAA==.Pawcat:AwADCAMABAoAAA==.',Pe='Pegasus:AwAICA4ABAoAAA==.Pewpewz:AwAECAUABAoAAA==.',Ph='Phobos:AwADCAcABAoAAA==.Phogood:AwACCAIABAoAAA==.Phosani:AwAHCBMABAoAAA==.',Pl='Plot:AwAFCAwABAoAAA==.',Po='Polpo:AwAFCA8ABAoAAA==.Poppinin:AwAECAMABAoAAA==.',Pu='Puppybaby:AwAFCA4ABAoAAA==.',['P�']='Pànzer:AwAGCBAABAoAAA==.',Ra='Raggar:AwACCAEABAoAAA==.Rainakamugi:AwADCAMABAoAAA==.Raybear:AwAECAgABAoAAA==.Razorbrew:AwAECAkABRQDFQAEAQj7AAA/4nsBBRQAFQAEAQj7AAA/4nsBBRQAGQABAQiPBAAtx0AABRQAAA==.',Re='Rellim:AwAICAgABAoAAA==.',Rn='Rnbodash:AwAFCAUABAoAAA==.',Ry='Ryeholie:AwAHCBIABAoAAA==.',['R�']='Rèmi:AwAFCAoABAoAAA==.',Sa='Sagë:AwAFCAIABAoAAA==.',Se='Sermet:AwAFCA0ABAoAAA==.Serous:AwAECAsABAoAAA==.Setal:AwAFCA4ABAoAAA==.',Sh='Shaeman:AwAFCAwABAoAAQwAAAAGCAgABAo=.Sheepe:AwADCAcABAoAAA==.Shinydude:AwABCAEABAoAAA==.',Si='Siomara:AwACCAIABAoAAA==.',Sk='Skwsham:AwAFCA8ABAoAAA==.Skybandit:AwADCAEABAoAAA==.Skyroh:AwAGCAgABAoAAA==.Skyzen:AwADCAYABRQCFQADAQjQAgBEXxgBBRQAFQADAQjQAgBEXxgBBRQAAA==.',Sl='Slabbhammer:AwAFCAYABAoAAA==.Slamdunks:AwAICAgABAoAAA==.',So='Solis:AwABCAEABAoAAA==.',Sp='Springz:AwABCAEABRQAAA==.',St='Stovepiping:AwAECAgABAoAAA==.Striga:AwAGCAEABAoAAA==.',Sw='Swingin:AwACCAIABAoAAA==.',Sy='Sycho:AwAGCBAABAoAAA==.',Ta='Tartan:AwABCAEABRQAAA==.',Te='Tenindis:AwAICAwABAoAAA==.Tentoestwo:AwAFCAwABAoAAA==.',Th='Tharekon:AwAHCBAABAoAAA==.Thelgore:AwAHCBUABAoCEgAHAQj4FAA0CfIBBAoAEgAHAQj4FAA0CfIBBAoAAA==.Thrikal:AwACCAIABAoAAA==.',To='Torno:AwAFCAoABAoAAA==.',Tr='Trollfer:AwACCAIABAoAAA==.',Tu='Tufluk:AwAECAMABAoAAA==.',Ul='Ultarok:AwADCAcABAoAAA==.',Va='Varcor:AwAGCAkABAoAAA==.Vasai:AwADCAEABAoAAA==.',Vi='Vinda:AwAHCBUABAoCEAAHAQjiJgARvhoBBAoAEAAHAQjiJgARvhoBBAoAAA==.Vivixia:AwAFCAoABAoAAA==.',Vl='Vladious:AwAHCBQABAoCAQAHAQg3DgBUaIkCBAoAAQAHAQg3DgBUaIkCBAoAAQwAAAAICAgABAo=.',Vv='Vvs:AwAECAYABAoAAA==.',Wa='Warnor:AwACCAMABAoAAA==.Washedbolt:AwADCAMABAoAAA==.',Za='Zahhtisimus:AwAHCBUABAoCGgAHAQjDCwBBU/sBBAoAGgAHAQjDCwBBU/sBBAoAAQwAAAAICAgABAo=.',Ze='Zerofort:AwAICAgABAoAAA==.',Zi='Zieg:AwACCAIABAoAAA==.',Zm='Zmoney:AwACCAIABRQCGwAIAQj5BwBHNJMCBAoAGwAIAQj5BwBHNJMCBAoAAA==.',Zo='Zombienolan:AwAECAgABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end