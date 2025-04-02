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
 local lookup = {'Unknown-Unknown','Warrior-Fury','Warrior-Arms','DemonHunter-Havoc','Priest-Shadow','DemonHunter-Vengeance','DeathKnight-Unholy','Rogue-Assassination','Warlock-Affliction','Warlock-Destruction','Warlock-Demonology','DeathKnight-Frost','Hunter-BeastMastery','Warrior-Protection','Paladin-Holy','Paladin-Retribution','Monk-Mistweaver','Mage-Fire','Monk-Brewmaster','Priest-Holy',}; local provider = {region='US',realm="Cho'gall",name='US',type='weekly',zone=42,date='2025-03-29',data={Ae='Aeyther:AwAGCA8ABAoAAA==.',Al='Alukarrd:AwACCAQABAoAAA==.Alybeth:AwABCAEABAoAAA==.',An='Angelle:AwAGCBAABAoAAA==.',Ar='Arae:AwAGCBIABAoAAQEAAAAICAYABAo=.Arkkon:AwADCAgABAoAAA==.Arylynn:AwADCAQABAoAAA==.',Av='Avocadorable:AwADCAYABAoAAA==.Avâtre:AwAGCBEABAoAAA==.',Ba='Bajingobomb:AwAFCAoABAoAAA==.Baneful:AwAFCAsABAoAAA==.Barndoogle:AwADCAQABAoAAA==.Barnpall:AwAFCAoABAoAAA==.',Be='Be:AwADCAgABAoAAA==.',Bi='Bigdingus:AwAGCA8ABAoAAA==.',Bl='Blassphamy:AwADCAMABAoAAA==.Blooddrain:AwABCAEABAoAAA==.',Bo='Boaj:AwABCAIABRQAAA==.Boomboomboom:AwAGCBAABAoAAA==.Booyay:AwAHCBEABAoAAA==.Bosmina:AwAICAwABAoAAA==.',Ce='Cernsarn:AwAGCA8ABAoAAA==.',Ch='Chiri:AwAFCAkABAoAAA==.',Co='Conmammoth:AwACCAMABAoAAA==.Coohwhip:AwAFCA8ABAoAAA==.',Cr='Crinaa:AwABCAEABAoAAA==.Cristobal:AwADCAQABAoAAA==.',Da='Daedak:AwAFCAcABAoAAA==.Dagda:AwADCAgABAoAAA==.Dannybruh:AwACCAIABAoAAA==.Davaan:AwAGCAsABAoAAA==.Davidpumpkin:AwAGCAwABAoAAA==.',De='Deadde:AwAICBgABAoDAgAIAQhCDQBHL5gCBAoAAgAIAQhCDQBHL5gCBAoAAwACAQg8NwAujGoABAoAAA==.Degey:AwAFCAsABAoAAA==.Deign:AwAICBUABAoCBAAIAQizLgAZkqwBBAoABAAIAQizLgAZkqwBBAoAAA==.Deriso:AwAGCAoABAoAAA==.',Di='Digitz:AwAHCA4ABAoAAA==.Divah:AwAECAYABAoAAA==.',Dr='Dragonkay:AwAECAcABAoAAA==.Dreadpimp:AwAHCBEABAoAAA==.Dronebot:AwAGCBEABAoAAA==.Drucifer:AwAECAoABAoAAA==.',Du='Durky:AwAECAEABAoAAA==.Dusa:AwAGCA8ABAoAAA==.',Dv='Dvrotan:AwACCAIABAoAAA==.',Dy='Dys:AwAECAoABAoAAA==.',El='Elavyn:AwAGCBIABAoAAA==.Elfnp:AwAFCAsABAoAAQEAAAAICAQABAo=.',Eu='Euphoricxx:AwAGCBMABAoAAA==.',Fa='Faell:AwAGCAYABAoAAA==.Faewynn:AwADCAcABAoAAA==.Faithles:AwAICBUABAoCBQAIAQi0CwBDcH0CBAoABQAIAQi0CwBDcH0CBAoAAA==.Falgur:AwAICBIABAoAAA==.Fau:AwAGCA8ABAoAAA==.',Fe='Fear:AwADCAMABAoAAA==.',Fi='Findal:AwAFCAoABAoAAA==.Fivemagics:AwAHCBIABAoAAA==.',Fo='Foxlock:AwABCAIABAoAAA==.',Fr='Fraaz:AwAICBcABAoDBgAIAQheAwBVLOICBAoABgAIAQheAwBVLOICBAoABAABAQhtggAYhTEABAoAAA==.',Fy='Fyaball:AwAFCAkABAoAAA==.',Ga='Gamer:AwAGCAoABAoAAA==.Gammaray:AwAGCAwABAoAAA==.Gash:AwABCAMABRQAAA==.Gawdric:AwAHCBEABAoAAA==.',Gi='Gibsmedats:AwAFCAsABAoAAA==.',Gl='Glenlivet:AwAFCAgABAoAAA==.',Gn='Gnartusk:AwADCAUABAoAAA==.',Go='Goat:AwAGCA8ABAoAAA==.Goldendragon:AwAECAQABAoAAA==.Goops:AwABCAEABRQAAA==.',Gr='Greenshanker:AwACCAYABAoAAA==.Grïma:AwAGCBMABAoAAA==.',Gu='Gueritestje:AwAFCAoABAoAAA==.Guldaniel:AwABCAEABAoAAA==.Guzzlord:AwAGCAsABAoAAA==.',Ha='Halp:AwADCAIABAoAAA==.',Hi='Hitoshura:AwAGCBAABAoAAA==.',Ho='Holygail:AwAGCBAABAoAAA==.',Hy='Hypérîon:AwAGCBAABAoAAA==.',Id='Idlehand:AwAECAUABAoAAQEAAAAICAIABAo=.',Il='Illanya:AwAECAcABAoAAQEAAAAGCBMABAo=.',In='Infidel:AwAGCBIABAoAAA==.Innogen:AwAHCBIABAoAAA==.',Io='Iorlas:AwADCAgABAoAAA==.',Ip='Ippep:AwADCAYABAoAAA==.',Ir='Irisharcher:AwAGCAoABAoAAA==.Irishfury:AwACCAIABAoAAA==.',Is='Isometrics:AwAGCBEABAoAAA==.',Ja='Jardabeans:AwAECAUABAoAAA==.',Je='Jelial:AwACCAIABAoAAA==.',Jf='Jf:AwAGCA8ABAoAAA==.',Ji='Jinrokh:AwAGCBEABAoAAA==.',Jo='Johnnycool:AwADCAEABAoAAQEAAAAGCBEABAo=.Johnpalagodx:AwACCAIABAoAAA==.Johnsurvivor:AwAGCBIABAoAAA==.',Ju='Juendi:AwACCAIABAoAAQEAAAAICBEABAo=.Juice:AwAHCBIABAoAAA==.',Ka='Kachigga:AwAECAkABAoAAQEAAAAGCBEABAo=.Karina:AwACCAIABAoAAA==.Karpathous:AwAGCAgABAoAAA==.Kavo:AwACCAMABAoAAQEAAAAHCBIABAo=.',Ke='Keladorn:AwADCAYABAoAAA==.Kelithel:AwAGCA0ABAoAAA==.',Kh='Khanyiso:AwAGCBAABAoAAA==.Khazadûm:AwADCAYABAoAAA==.',Ki='Kieran:AwAGCBAABAoAAA==.',Kr='Krelothin:AwAGCAoABAoAAA==.Krittykitkat:AwAECAYABAoAAA==.',Kw='Kwaz:AwAHCBEABAoAAA==.',['K�']='Kÿllor:AwAFCAoABAoAAA==.',La='Lankyntanky:AwAGCBEABAoAAA==.',Le='Legomyeggojr:AwAECAQABAoAAQcAObYCCAUABRQ=.',Li='Livalil:AwAFCAkABAoAAA==.',Lo='Lorren:AwAFCAUABAoAAA==.',Lu='Lustbot:AwAGCA8ABAoAAA==.',Ly='Lysergicburn:AwAICAIABAoAAA==.',Ma='Mago:AwAGCBIABAoAAA==.Magturri:AwAFCAsABAoAAA==.Maiwaife:AwAGCAYABAoAAA==.Manolo:AwABCAEABRQAAA==.Maxfirepower:AwACCAQABAoAAA==.',Me='Meliiodas:AwAECAcABAoAAA==.Mellky:AwAGCBMABAoAAA==.Mello:AwABCAEABRQCCAAIAQjHAwBR+NkCBAoACAAIAQjHAwBR+NkCBAoAAA==.Merrinx:AwAGCBQABAoDCQAGAQhUAgBfmHUCBAoACQAGAQhUAgBfmHUCBAoACgABAQgwgQAOqy0ABAoAAA==.',Mg='Mgamer:AwACCAMABAoAAA==.',Mi='Mibb:AwAGCAYABAoAAQsAVKcBCAEABRQ=.Misfit:AwACCAIABRQAAA==.',Mo='Momojojo:AwAFCAcABAoAAA==.Moonmoonmoon:AwAICA0ABAoAAA==.Morphyne:AwAGCBMABAoAAA==.Moserr:AwADCAQABAoAAA==.',My='Mysaria:AwABCAEABAoAAA==.Mystictomato:AwAICAsABAoAAA==.',['M�']='Mæl:AwACCAIABAoAAA==.Mèowcenaary:AwAECAcABAoAAA==.',Na='Natasa:AwAGCAsABAoAAA==.Natedog:AwAGCBMABAoAAA==.',Ne='Neamheaglach:AwACCAQABRQCDAAIAQjhAgBNu8sCBAoADAAIAQjhAgBNu8sCBAoAAA==.Neotahr:AwAICBQABAoCDQAHAQiyMAA/FOcBBAoADQAHAQiyMAA/FOcBBAoAAA==.Neuron:AwAFCAgABAoAAA==.Nex:AwADCAIABAoAAA==.Nezzot:AwAGCA0ABAoAAA==.',Ni='Nikz:AwAGCA4ABAoAAA==.Nincom:AwADCAUABAoAAA==.',Ny='Nymuni:AwABCAEABAoAAQEAAAACCAIABRQ=.',['N�']='Növacaïn:AwAFCAkABAoAAA==.',Oi='Oistos:AwAHCAMABAoAAA==.',Om='Omicron:AwAFCAUABAoAAA==.',On='Onslaught:AwACCAYABRQCDgACAQikAgAiwHoABRQADgACAQikAgAiwHoABRQAAA==.',Or='Oreum:AwAFCAgABAoAAA==.',Pa='Pancakessuck:AwAHCBQABAoDDwAHAQhbEgApkIgBBAoADwAHAQhbEgApkIgBBAoAEAAFAQh+iwAmkf4ABAoAAA==.Pattonius:AwAECAYABAoAAA==.',Ph='Phraasz:AwAECAUABAoAAA==.',Po='Popaheal:AwAECAUABAoAAA==.',Pr='Praystatiøn:AwAICAoABAoAAA==.Profitlord:AwADCAgABAoAAA==.',Ps='Psyop:AwAECAoABAoAAA==.',['P�']='Päntera:AwAFCAsABAoAAA==.',Qy='Qyill:AwAECAIABAoAAA==.',Ra='Raisa:AwAHCBUABAoDCwAHAQgACgBPbMcBBAoACwAFAQgACgBXi8cBBAoACgAEAQgJQABEIBgBBAoAAA==.Rapturo:AwAECAoABAoAAA==.Rawdric:AwABCAEABAoAAA==.',Re='Remade:AwABCAEABRQAAA==.Ret:AwAGCBEABAoAAA==.Retardvarrk:AwADCAQABAoAAA==.Rexxice:AwAECAcABAoAAA==.',Ri='Riddlez:AwAECAcABAoAAA==.',Ro='Rockenrolla:AwABCAEABAoAAA==.Romoko:AwAGCA8ABAoAAA==.',Ry='Rycicle:AwACCAIABAoAAA==.',['R�']='Rågnår:AwACCAIABAoAAA==.',Sa='Savrynn:AwAGCBEABAoAAA==.',Sc='Scalelord:AwABCAEABRQAAA==.Scarycat:AwAGCA4ABAoAAREAQL8ICBkABAo=.',Se='Senjougahara:AwAGCBgABAoCDAAGAQjiBABaIlsCBAoADAAGAQjiBABaIlsCBAoAAA==.Serph:AwADCAcABAoAAA==.Sesshumaru:AwADCAYABAoAAA==.',Sh='Shabane:AwADCAoABAoAAA==.Shame:AwADCAMABAoAAA==.Shamorond:AwAECAcABAoAAA==.Shidayah:AwAGCBYABAoCEgAGAQhjJgBKN9MBBAoAEgAGAQhjJgBKN9MBBAoAAA==.Shirls:AwAGCA8ABAoAAA==.Shivaetwo:AwAICBUABAoDCQAIAQjhDwAZxw4BBAoACgAGAQgiQQAabRMBBAoACQAFAQjhDwAcJw4BBAoAAA==.Shock:AwAICAYABAoAAA==.',Si='Silenthobo:AwAGCAUABAoAAA==.',Sk='Skylinex:AwACCAIABAoAAA==.Skïttles:AwADCAcABAoAAA==.',Sn='Snakxpac:AwAFCAsABAoAAA==.',So='Sobek:AwAECAoABAoAAA==.Softkiller:AwACCAIABAoAAA==.Songraven:AwAGCAkABAoAAA==.Sotipie:AwAFCAMABAoAAA==.Southie:AwAHCBIABAoAAA==.Soviette:AwABCAEABAoAAA==.',St='Stepdag:AwAICBUABAoCEwAIAQiJBABA1DQCBAoAEwAIAQiJBABA1DQCBAoAAA==.',Su='Suigintou:AwAGCBEABAoAAA==.Supervisor:AwAECAMABAoAAA==.',Sy='Synder:AwAGCBAABAoAAA==.',Ta='Tahharruk:AwAICA0ABAoAAA==.Talogos:AwAECAcABAoAAA==.Tarynna:AwADCAoABAoAAA==.',Te='Telrissan:AwAGCA0ABAoAAA==.Tenyroldemon:AwABCAEABAoAAA==.',Th='Thald:AwAFCAcABAoAAA==.Thaltrois:AwAGCA8ABAoAAA==.Thirst:AwAECAsABAoAAQEAAAAICAIABAo=.',Ti='Tidechi:AwACCAEABAoAAA==.Tidewell:AwAGCAwABAoAAA==.Tisakna:AwAICBEABAoAAA==.',To='Tomatoes:AwAGCA0ABAoAAA==.',Tu='Tugglight:AwAHCBIABAoAAA==.Turbowar:AwAFCAcABAoAARAATzYHCBUABAo=.',Us='Usedgoods:AwAICAgABAoAAA==.',Va='Vanderuid:AwAHCA0ABAoAAA==.Vanquìsh:AwAFCAoABAoAAA==.',Vu='Vuradra:AwAGCA0ABAoAAA==.',We='Wethands:AwADCAMABAoAAA==.',Wi='Wibb:AwABCAEABRQECwAIAQgFDQBUp5EBBAoACwAFAQgFDQBQ7pEBBAoACgAEAQjxLQBWiYQBBAoACQAEAQjHCwBUIUwBBAoAAA==.Windfury:AwACCAIABAoAAA==.',Xa='Xany:AwABCAEABAoAAA==.',Xe='Xelinic:AwADCAcABAoAAA==.',Xi='Xiangorne:AwADCAgABAoAAA==.Xinara:AwAGCAoABAoAAA==.',Xr='Xrxyz:AwAFCA8ABAoAAA==.',Ye='Yewna:AwAICBUABAoCFAAIAQgTBABVg+0CBAoAFAAIAQgTBABVg+0CBAoAAA==.',Zu='Zugstyle:AwAGCA0ABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end