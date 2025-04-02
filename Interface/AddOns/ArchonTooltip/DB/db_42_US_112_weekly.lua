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
 local lookup = {'Warrior-Fury','Warrior-Arms','Monk-Windwalker','Unknown-Unknown','Mage-Fire','DeathKnight-Blood','Mage-Frost','Druid-Feral','Shaman-Restoration',}; local provider = {region='US',realm='Greymane',name='US',type='weekly',zone=42,date='2025-03-29',data={Al='Alektophobia:AwADCAMABAoAAA==.',Am='Amorina:AwADCAQABAoAAA==.',An='Angellena:AwAECAMABAoAAA==.Angered:AwAICBYABAoCAQAIAQiNBgBUjwADBAoAAQAIAQiNBgBUjwADBAoAAA==.Angrygnome:AwADCAMABAoAAA==.Anoxa:AwACCAIABAoAAA==.',Ar='Arcashi:AwADCAcABAoAAA==.Arlenbales:AwACCAIABAoAAA==.',As='Ashlly:AwADCAYABAoAAA==.',Ba='Bamboola:AwAFCAkABAoAAA==.Bananahammik:AwAFCAEABAoAAA==.',Be='Belgran:AwADCAEABAoAAA==.',Bi='Bigdaddynik:AwAFCAkABAoAAA==.Bileshots:AwABCAEABAoAAA==.',Ca='Caric:AwADCAYABAoAAA==.',Cd='Cdss:AwAECAEABAoAAA==.',Ch='Chiblet:AwAICAgABAoAAA==.Chuubak:AwAICBAABAoAAA==.',Cl='Clunk:AwADCAUABAoAAA==.',Da='Dakon:AwAGCBMABAoAAA==.Daneaus:AwAFCAkABAoAAA==.',De='Deathbydruid:AwADCAEABAoAAA==.Deloras:AwADCAMABAoAAA==.Dethrift:AwAECAcABAoAAA==.',Do='Dorozh:AwADCAMABAoAAA==.',Dr='Dragonstorm:AwAECAEABAoAAA==.Drater:AwADCAMABAoAAA==.',Dy='Dyana:AwADCAYABAoAAA==.',['D�']='Därrow:AwAICAMABAoAAA==.',Ea='Eathast:AwAICBYABAoCAgAIAQgmBgBJkqoCBAoAAgAIAQgmBgBJkqoCBAoAAA==.',Ed='Edlund:AwAFCAkABAoAAA==.',El='Electricfun:AwADCAMABAoAAA==.',Ev='Evilblood:AwAICBAABAoAAA==.Evilstar:AwADCAEABAoAAA==.',Fe='Felysria:AwADCAUABAoAAA==.Fertle:AwADCAYABAoAAA==.',Ga='Galdryn:AwAFCAkABAoAAA==.Galianna:AwADCAMABAoAAA==.',Gr='Groon:AwADCAMABAoAAA==.',Gy='Gyroflux:AwABCAEABAoAAA==.',Ha='Haveabubble:AwAFCAgABAoAAA==.Havvoc:AwADCAQABAoAAA==.',He='Helena:AwAGCAEABAoAAA==.',In='Inknose:AwABCAIABAoAAA==.',It='Itchyfeet:AwAICBcABAoCAwAIAQgrAwBaeDEDBAoAAwAIAQgrAwBaeDEDBAoAAA==.',Ja='Jaydevis:AwAHCAcABAoAAA==.Jaydu:AwADCAMABAoAAA==.',Ji='Jigs:AwADCAQABAoAAA==.',Ka='Kayano:AwAFCAcABAoAAA==.',Kg='Kglizard:AwADCAgABAoAAA==.',Kh='Khemical:AwADCAEABAoAAA==.',Ko='Korrasae:AwADCAYABAoAAA==.',La='Ladrona:AwABCAEABAoAAA==.Lassandrok:AwADCAMABAoAAA==.Latëralus:AwACCAMABAoAAA==.Laurasaurus:AwACCAQABAoAAQQAAAAGCA4ABAo=.Lavenderloot:AwAECAcABAoAAA==.',Le='Legzala:AwAECAEABAoAAA==.Legzanot:AwAECAkABAoAAA==.Lemonylime:AwAFCAkABAoAAA==.',Li='Lightningfox:AwADCAUABAoAAA==.',Lu='Lucielbaal:AwAFCAcABAoAAA==.Luciferus:AwAECAwABAoAAA==.Luckystop:AwADCAQABAoAAQQAAAAECAgABAo=.',Ma='Magnusaureli:AwADCAMABAoAAA==.Makgar:AwAFCAsABAoAAA==.Maniksmage:AwABCAEABRQAAA==.Mannypack:AwADCAMABAoAAA==.Maximos:AwACCAIABAoAAA==.',Me='Mephizto:AwAFCAQABAoAAA==.',Mi='Miyagii:AwAECAYABAoAAA==.',Mo='Mojachhe:AwAICBYABAoCBQAIAQgEDABSYNQCBAoABQAIAQgEDABSYNQCBAoAAA==.Monoxidê:AwABCAEABAoAAA==.Moonwarriorx:AwADCAEABAoAAA==.Morthorne:AwADCAUABAoAAA==.',Ni='Ninjypunch:AwADCAgABAoAAA==.Nivora:AwABCAIABAoAAA==.',No='Nobrain:AwADCAMABAoAAA==.Norst:AwADCAMABAoAAA==.',Ol='Olmek:AwACCAUABRQCAQACAQjHCwAfBZsABRQAAQACAQjHCwAfBZsABRQAAA==.',Op='Oprahwndfury:AwAECAYABAoAAA==.',Or='Ormagöden:AwAGCAYABAoAAA==.',Pe='Pelly:AwAECAoABAoAAA==.',Ph='Pharaa:AwADCAUABAoAAA==.',Pj='Pj:AwAICBYABAoCBgAIAQiIAgBb2jQDBAoABgAIAQiIAgBb2jQDBAoAAA==.',Qi='Qikkaw:AwADCAEABAoAAA==.',Re='Relmax:AwADCAMABAoAAA==.',Rh='Rhaenýs:AwADCAEABAoAAA==.',Ri='Riccroll:AwADCAMABAoAAA==.Rikershipdwn:AwADCAYABAoAAA==.',Ro='Robertkenway:AwADCAMABAoAAQQAAAAECAwABAo=.Rod:AwADCAcABAoAAA==.',Ru='Rubimoon:AwABCAEABAoAAQQAAAADCAcABAo=.Rudepoodle:AwADCAMABAoAAA==.',Se='Sedrick:AwADCAEABAoAAA==.Semyshadow:AwADCAEABAoAAA==.',Sh='Shalath:AwACCAMABAoAAQMAWngICBcABAo=.Shankinator:AwACCAIABAoAAA==.Shaunna:AwABCAEABAoAAA==.',Si='Silentdeadly:AwABCAEABAoAAA==.',Sl='Slashbndcoot:AwAECAkABAoAAA==.Slumbermist:AwAFCAMABAoAAA==.',So='Solidsnake:AwADCAMABAoAAA==.Sophra:AwAFCAsABAoAAA==.',Ta='Taytayswift:AwAECAYABAoAAA==.',Tb='Tbn:AwAECAcABAoAAA==.',Th='Thalira:AwADCAMABAoAAA==.',Ti='Tiger:AwAICBAABAoAAQcATrcDCAUABRQ=.',To='Toiletpooper:AwACCAMABRQCCAAIAQhvAQBfmR0DBAoACAAIAQhvAQBfmR0DBAoAAA==.',Tr='Treantreznor:AwAECAMABAoAAA==.Troag:AwACCAEABAoAAA==.Troagstar:AwABCAEABAoAAA==.',Tu='Turvold:AwAICBAABAoAAA==.',Uv='Uvitax:AwAFCAEABAoAAA==.',Va='Vandalism:AwACCAIABRQAAA==.Vasrannah:AwAECAkABAoAAA==.Vavriel:AwAECAsABAoAAA==.',Vy='Vyrahildard:AwAFCAkABAoAAA==.',Wa='Wasteland:AwAHCAEABAoAAA==.',We='Weaselhunter:AwADCAMABAoAAA==.',Wy='Wyr:AwACCAEABAoAAA==.',Xa='Xaquillis:AwAHCAMABAoAAA==.',Xe='Xeyvara:AwAFCAkABAoAAA==.',Xy='Xyata:AwAICBYABAoCCQAIAQiOMgAPnVIBBAoACQAIAQiOMgAPnVIBBAoAAA==.',Ze='Zengore:AwADCAMABAoAAA==.Zenshi:AwAICA0ABAoAAA==.',Zo='Zorc:AwAICA4ABAoAAA==.Zorin:AwADCAUABAoAAA==.',Zy='Zyrnyxia:AwAFCAgABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end