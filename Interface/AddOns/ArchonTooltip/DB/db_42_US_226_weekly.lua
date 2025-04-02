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
 local lookup = {'Monk-Windwalker','Monk-Mistweaver','Unknown-Unknown','Warrior-Fury','Warlock-Destruction','Mage-Fire','Mage-Frost','Druid-Balance','Hunter-Marksmanship','Hunter-BeastMastery','Hunter-Survival','Shaman-Elemental','Rogue-Assassination','Rogue-Outlaw','Warrior-Arms','Paladin-Holy','DemonHunter-Vengeance','Warrior-Protection','Priest-Holy','Warlock-Affliction','Warlock-Demonology','Paladin-Retribution','Paladin-Protection',}; local provider = {region='US',realm='Turalyon',name='US',type='weekly',zone=42,date='2025-03-28',data={Ad='Addlee:AwAGCAMABAoAAA==.Adverbs:AwACCAIABAoAAA==.',Ae='Aerallia:AwAFCAcABAoAAA==.',Al='Aldaris:AwAHCBYABAoDAQAHAQimCgBNToECBAoAAQAHAQimCgBNToECBAoAAgAGAQhPHwA33Z0BBAoAAA==.Alessie:AwAFCAUABAoAAA==.Allymarie:AwAGCBEABAoAAA==.',Am='Amalune:AwAFCAcABAoAAA==.Amelyn:AwAGCBMABAoAAA==.',An='Animism:AwAFCAgABAoAAA==.Anlaness:AwAFCAUABAoAAQMAAAAICAEABAo=.',Ar='Ardius:AwAFCAkABAoAAA==.Arenaria:AwABCAIABAoAAA==.',As='Astralis:AwABCAEABAoAAA==.',Au='Auzzy:AwACCAIABAoAAA==.',Av='Avido:AwAFCAoABAoAAA==.',Ba='Baelgoroth:AwAFCAoABAoAAA==.Bashnblock:AwABCAEABRQCBAAHAQjCEABH/WYCBAoABAAHAQjCEABH/WYCBAoAAA==.',Be='Berenger:AwAGCA4ABAoAAA==.',Bi='Bicurious:AwADCAMABAoAAA==.',Bl='Blackhammer:AwAICAgABAoAAQUAKNwDCAYABRQ=.Bleb:AwAFCAgABAoAAA==.Blebins:AwADCAQABRQDBgAIAQhUEABQf54CBAoABgAIAQhUEABPoJ4CBAoABwAGAQgLIwBCIo4BBAoAAA==.Blestknight:AwAICAgABAoAAA==.Blinknleap:AwADCAMABAoAAA==.',Bo='Bovinescat:AwAGCAUABAoAAA==.',Br='Brillz:AwABCAEABAoAAA==.Brobonic:AwECCAIABAoAAQMAAAAGCAwABAo=.Brokahn:AwAFCAoABAoAAA==.Bryan:AwADCAcABRQCAQADAQgVBAAjROQABRQAAQADAQgVBAAjROQABRQAAA==.',Bu='Bubbleyurie:AwAGCBMABAoAAA==.Buteryobread:AwADCAQABAoAAA==.',By='Byléana:AwAHCAkABAoAAA==.Bytem:AwABCAIABRQCCAAIAQiOBgBVPwcDBAoACAAIAQiOBgBVPwcDBAoAAA==.',Ca='Cadburry:AwAECAYABAoAAA==.Calel:AwAECAYABAoAAA==.Carleys:AwAECAcABAoAAA==.Carlosdanger:AwACCAIABAoAAA==.',Ce='Celekai:AwAGCBMABAoAAA==.Celi:AwAGCA8ABAoAAA==.Cerbywar:AwAGCA4ABAoAAA==.',Ch='Chaolmage:AwAFCAUABAoAAQkAXhoDCAkABRQ=.Chriis:AwAHCBQABAoECQAHAQgoBgBYwJoCBAoACQAHAQgoBgBYwJoCBAoACgADAQiDdABUicIABAoACwADAQjUDAArtYoABAoAAA==.',Ci='Cidal:AwABCAIABAoAAA==.',Cr='Crager:AwABCAIABAoAAA==.Crybearnate:AwAHCAkABAoAAA==.',Ct='Ctair:AwAGCAoABAoAAA==.',Cu='Culdreth:AwAGCAwABAoAAQMAAAABCAEABRQ=.',['C�']='Cørmøir:AwAICBAABAoAAA==.',Da='Dandron:AwADCAMABAoAAA==.Darknsanity:AwAGCAYABAoAAQwAUv4HCBUABAo=.Darksath:AwADCAMABAoAAA==.Darkspine:AwAGCAwABAoAAA==.Darkvag:AwAGCAQABAoAAA==.Daygos:AwAHCAkABAoAAA==.',De='Demoncrow:AwAHCAkABAoAAA==.Demonic:AwABCAIABAoAAA==.Demonscum:AwAFCAgABAoAAA==.Devilslayery:AwABCAEABRQAAA==.',Di='Dilandria:AwAFCAcABAoAAA==.',Dn='Dnov:AwAICAgABAoAAA==.',Do='Dommothop:AwACCAQABRQDDQAIAQgIAgBVTxcDBAoADQAIAQgIAgBVTxcDBAoADgACAQhmCwAYEFoABAoAAA==.',Dr='Dragonkinn:AwAFCAYABAoAAA==.Drakenjosh:AwAHCAgABAoAAA==.Dralia:AwADCAMABAoAAQMAAAAFCAMABAo=.Drayus:AwAGCAoABAoAAA==.Drekoning:AwAFCAgABAoAAA==.Drie:AwAECAIABAoAAA==.',Du='Dumbcat:AwAGCBAABAoAAA==.',['D�']='Døtdotboom:AwAFCAYABAoAAA==.',Ed='Eddiewix:AwAECAUABAoAAA==.',Ek='Eklypsis:AwAFCAcABAoAAA==.',El='Elding:AwAHCBUABAoCDAAHAQgYDABS/mUCBAoADAAHAQgYDABS/mUCBAoAAA==.Elgrandè:AwAGCAwABAoAAA==.',En='Entarri:AwAFCAkABAoAAA==.',Es='Eshel:AwAGCBIABAoAAA==.Essek:AwAGCBMABAoAAA==.',Ev='Evidicus:AwAGCA0ABAoAAA==.Evilsrampage:AwAHCAkABAoAAA==.',Fa='Faciem:AwADCAkABAoAAA==.',Fe='Fed:AwAFCAwABAoAAA==.Fenris:AwABCAEABAoAAA==.',Fi='Findale:AwAGCAEABAoAAA==.Fiodae:AwADCAcABAoAAA==.',Fk='Fkxstvebee:AwAICA8ABAoAAA==.',Fl='Flajj:AwADCAMABAoAAA==.Flamezephyr:AwABCAEABRQDBwAGAQhpFQBZPAkCBAoABwAGAQhpFQBLYwkCBAoABgAFAQjyMgA9s2MBBAoAAA==.Flintbane:AwAICAgABAoAAQMAAAAICBAABAo=.Fluffynstout:AwADCAMABAoAAA==.',Fr='Frenkenstyne:AwAGCAMABAoAAA==.',Fu='Fu:AwAHCA0ABAoAAQoAWjUGCA8ABRQ=.',Ga='Gagon:AwAFCAkABAoAAA==.Galahad:AwACCAIABAoAAA==.Gaveta:AwAFCAgABAoAAA==.',Ge='Georgigeo:AwAGCA0ABAoAAA==.',Gh='Ghelorne:AwAGCBIABAoAAA==.Ghostduster:AwAHCBYABAoCCgAHAQhLGwBSZXMCBAoACgAHAQhLGwBSZXMCBAoAAA==.',Go='Gogert:AwAHCBIABAoAAA==.Goreack:AwAICAgABAoAAA==.',Gr='Greenclaw:AwAHCBMABAoAAA==.',Gw='Gwynbleidd:AwAGCA4ABAoAAA==.',['G�']='Gàlàhàd:AwAHCAkABAoAAA==.',Ha='Hauntër:AwAFCA0ABAoAAA==.',He='Heathir:AwAHCBIABAoAAA==.Hexan:AwAGCAUABAoAAA==.',Hi='Himari:AwAHCBIABAoAAA==.',Ho='Hobkins:AwAHCAkABAoAAA==.Holcon:AwADCAkABAoAAA==.Hollypops:AwACCAIABAoAAA==.Holybo:AwABCAEABRQAAA==.',Hu='Hulksmash:AwAHCA8ABAoAAA==.',Im='Imakeupuddin:AwADCAcABRQCDwADAQgrAQAuovQABRQADwADAQgrAQAuovQABRQAAA==.',In='Inffected:AwAGCBEABAoAAA==.Inhumage:AwACCAIABAoAAA==.',It='Itkovian:AwABCAEABAoAAA==.',Ix='Ix:AwABCAEABRQAAA==.',Ja='Jadecakes:AwAFCAQABAoAAA==.Jademengsk:AwAFCAIABAoAAA==.Jahrobi:AwAECAcABAoAAA==.Jandokar:AwAHCBIABAoAAA==.',Jc='Jck:AwAFCAEABAoAAA==.',Je='Jeffrenna:AwAGCAUABAoAAA==.',Jh='Jheina:AwABCAIABAoAAA==.',Ji='Jimmbobb:AwABCAIABAoAAQMAAAAFCA8ABAo=.Jimmyvrr:AwAHCBIABAoAAA==.Jinnô:AwAHCAkABAoAAA==.',Ka='Kakon:AwAECAoABAoAAA==.Kalö:AwAICAEABAoAAA==.Karaglaz:AwAECAkABAoAAA==.Karalea:AwAHCBYABAoCBgAHAQhLKAAyT7kBBAoABgAHAQhLKAAyT7kBBAoAAA==.Kayo:AwACCAIABAoAAA==.Kazstorius:AwAFCAoABAoAAA==.',Ke='Kegarlem:AwADCAMABAoAAA==.Kelesh:AwAFCAUABAoAAA==.Kellandria:AwADCAQABAoAAA==.Keun:AwAECAYABAoAAA==.Kevdk:AwAGCAUABAoAAA==.',Kh='Khanvict:AwAGCAwABAoAAA==.Kharzaette:AwAHCBEABAoAAA==.Khuedan:AwAHCAkABAoAAA==.',Ki='Kiing:AwAFCBcABAoCEAAFAQidCwBb5PcBBAoAEAAFAQidCwBb5PcBBAoAAA==.Kiritsumi:AwABCAIABRQAAA==.',Kl='Kloin:AwAICAcABAoAAA==.',Ko='Kobebryant:AwAGCBEABAoAAA==.',Kr='Krackstar:AwABCAEABRQAAA==.',La='Lagaehr:AwADCAgABAoAAA==.Laserdisc:AwAFCAcABAoAAA==.Lazarus:AwAHCBAABAoAAA==.',Le='Lehp:AwABCAEABAoAAQMAAAAFCAgABAo=.Lexicage:AwADCAMABAoAAA==.',Li='Lidd:AwAGCAUABAoAAA==.Linlisten:AwAHCAIABAoAAA==.',Ll='Llik:AwAGCAUABAoAAA==.',Lo='Lotaki:AwAFCAUABAoAAA==.Louni:AwAGCAEABAoAAA==.',Lu='Lunchpunch:AwAGCBEABAoAAA==.',Ly='Lyck:AwAGCA0ABAoAAA==.Lylryth:AwADCAEABAoAAA==.',['L�']='Lümber:AwAECAcABAoAAA==.',Ma='Mailadin:AwABCAEABRQAAREAYfcFCA8ABRQ=.Mailbox:AwAFCA8ABRQCEQAFAQgDAABh9y0CBRQAEQAFAQgDAABh9y0CBRQAAA==.Majexs:AwAGCAsABAoAAA==.Majhealaho:AwACCAIABAoAAQMAAAABCAEABRQ=.Maldu:AwADCAUABAoAAA==.Mandragoran:AwAHCBUABAoEBAAHAQggGABBRRcCBAoABAAHAQggGAA+YxcCBAoADwABAQhWOwAisUgABAoAEgABAQiQKQAFKg8ABAoAAA==.Mavenarios:AwABCAEABAoAAA==.',Me='Mechanorris:AwAICBcABAoCAgAIAQi8HgAjHqIBBAoAAgAIAQi8HgAjHqIBBAoAAA==.Mefistofele:AwADCAQABAoAAA==.Megamon:AwACCAQABAoAAA==.Mephala:AwADCAUABAoAAA==.',Mi='Mikedawson:AwAHCBAABAoAAA==.Mikkuchan:AwADCAUABAoAAA==.Mistrbfkx:AwAFCAYABAoAAQMAAAAICA8ABAo=.',Mo='Moderñdruið:AwAFCAEABAoAAA==.Moonrocket:AwAFCAQABAoAAA==.Mothles:AwABCAEABRQAAA==.',My='Myrihwana:AwAHCBIABAoAAA==.Myths:AwADCAQABAoAAQMAAAAGCA4ABAo=.',['M�']='Mìstafista:AwAECAMABAoAAA==.',Na='Nazrul:AwAFCAMABAoAAA==.',Ne='Necrofrost:AwAFCAcABAoAAA==.Neep:AwAGCAgABAoAAA==.Nehemiä:AwAFCAkABAoAAA==.Neoordained:AwAFCAoABAoAAA==.Nerf:AwABCAIABAoAAA==.',Ni='Nit:AwAFCAwABAoAAA==.',No='Noraz:AwAECAIABAoAAA==.Noxiie:AwAHCBEABAoAAA==.',['N�']='Nèphelle:AwAFCAwABAoAAA==.',Od='Oddball:AwABCAEABAoAAA==.',Oi='Oiiai:AwACCAMABAoAAA==.',Ok='Okkgar:AwADCAQABAoAAA==.',Or='Orinek:AwAHCAkABAoAAA==.Orkney:AwAICBAABAoAAA==.',Os='Osogrande:AwAFCAkABAoAAA==.',Ot='Otzyy:AwADCAIABAoAAA==.',Ow='Owy:AwACCAIABAoAAA==.',Pa='Papasmurfog:AwAGCAUABAoAAA==.',Pc='Pcokalypse:AwAGCAUABAoAAA==.',Pe='Peterhunter:AwADCAMABAoAAA==.',Ph='Phaet:AwAGCBEABAoAAA==.Phasmo:AwABCAEABAoAAA==.Phi:AwAHCAEABAoAAA==.',Pl='Plaid:AwAFCAcABAoAAA==.',Po='Pofis:AwAGCAkABAoAAA==.Postbox:AwAGCAYABAoAAREAYfcFCA8ABRQ=.Powahmack:AwAHCBEABAoAAA==.',Pr='Protege:AwAGCAoABAoAAA==.Provi:AwADCAQABAoAAA==.',['Q�']='Qîîz:AwAGCAUABAoAAA==.',Ra='Raeyth:AwAGCAsABAoAAA==.Rambozam:AwAGCBAABAoAAA==.Randompriest:AwAICBoABAoCEwAIAQgrFgAvYtkBBAoAEwAIAQgrFgAvYtkBBAoAAA==.Rattaghast:AwAFCAcABAoAAA==.Ravenbella:AwABCAIABAoAAA==.Ravoks:AwABCAEABRQEBQAIAQjZCwBXSZ4CBAoABQAIAQjZCwBP/Z4CBAoAFAAFAQgvBgBPvMYBBAoAFQACAQixIwBS/bYABAoAAA==.Raxii:AwAHCAkABAoAAA==.',Ri='Ripetomato:AwACCAQABRQDFgAIAQhaHgBHa30CBAoAFgAIAQhaHgBGnn0CBAoAFwADAQjQJQAjppwABAoAAA==.',Ro='Roguethyr:AwAGCAoABAoAAA==.',Rt='Rtcmouse:AwAFCAoABAoAAA==.',Sa='Saintopsy:AwAFCAkABAoAAA==.Salatea:AwACCAEABAoAAA==.Sanchey:AwAHCAkABAoAAA==.',Se='Seeding:AwAGCAoABAoAAA==.Selaxim:AwAGCAwABAoAAA==.',Sh='Shabutie:AwAGCAYABAoAAA==.',Si='Sidioüs:AwAHCBIABAoAAA==.Sieghood:AwAFCAoABAoAAA==.Sindus:AwAFCAgABAoAAA==.Sinnaka:AwADCAYABAoAAA==.',Sk='Skahddoosh:AwAGCAUABAoAAA==.Skova:AwADCAIABAoAAQUAV0kBCAEABRQ=.',Sl='Slanch:AwAECAcABAoAAA==.',Sm='Smeckledorfd:AwACCAUABAoAAA==.',Sn='Snapshotz:AwAGCA0ABAoAAA==.',So='Soular:AwAFCAgABAoAAA==.',Sp='Spookypookie:AwAECAIABAoAAA==.',St='Starcrayon:AwAFCAUABAoAAA==.',Su='Suffrage:AwAGCA4ABAoAAA==.Sulveris:AwAGCBAABAoAAA==.Sussy:AwACCAQABAoAAA==.',['S�']='Sämael:AwADCAQABAoAAQMAAAAGCAoABAo=.',Ta='Taakeshi:AwAECAYABAoAAA==.Takin:AwAGCAgABAoAAA==.Taldara:AwABCAIABAoAAA==.Talent:AwAGCA4ABAoAAA==.Tanksomes:AwAHCBIABAoAAA==.Tarethad:AwACCAIABAoAAA==.Taurastt:AwACCAIABAoAAA==.',Te='Tecom:AwABCAIABAoAAA==.Temporality:AwAGCBAABAoAAA==.',Th='Thdrae:AwAICAgABAoAAA==.Thunderswift:AwAHCBIABAoAAA==.',Ti='Tiltion:AwABCAIABAoAAA==.',Tr='Treadlots:AwAFCAUABAoAAA==.',Ts='Tsaëb:AwACCAMABRQCCAAIAQjICwBXPLoCBAoACAAIAQjICwBXPLoCBAoAAA==.',Tu='Tulleren:AwAGCBMABAoAAA==.Turtmcsquirt:AwACCAEABAoAAA==.',Un='Unethikell:AwAFCAcABAoAAA==.',Ur='Urtotem:AwEFCAkABAoAAA==.',Va='Vaedarus:AwAGCAIABAoAAA==.Valvien:AwAFCAUABAoAAA==.Vashdman:AwAFCAoABAoAAA==.',Ve='Veidr:AwADCAQABAoAAA==.Vergio:AwAHCBEABAoAAA==.Vertonic:AwADCAMABAoAAA==.Vespå:AwABCAIABAoAAA==.',Vi='Vickirose:AwABCAEABRQAAA==.Virin:AwAECAQABAoAAA==.',Vo='Voxxra:AwABCAEABAoAAA==.',Vy='Vynariman:AwACCAIABAoAAA==.',Wa='Watermyrain:AwAHCBEABAoAAA==.',We='Welsley:AwAGCA4ABAoAAA==.',Wh='Whipshot:AwABCAEABAoAAA==.',Wi='Wilder:AwAGCBAABAoAAA==.',Wo='Wolfidan:AwAGCAUABAoAAA==.',Wr='Wranebo:AwAHCAkABAoAAA==.Wrathchildë:AwAHCAkABAoAAA==.',Xa='Xanthuus:AwAICAgABAoAAA==.',Ya='Yakles:AwAGCAgABAoAAA==.',Ye='Yeahnice:AwAFCAcABAoAAA==.',Yn='Ynotdude:AwAGCAEABAoAAA==.',Ze='Zeeke:AwABCAEABAoAAA==.Zeekill:AwABCAEABAoAAA==.',Zh='Zhangfeng:AwADCAMABAoAAA==.',Zo='Zoet:AwAHCBEABAoAAA==.Zorvox:AwAECAoABAoAAQUAV0kBCAEABRQ=.',Zu='Zulmongo:AwAFCAgABAoAAA==.',['À']='Àlik:AwAGCAYABAoAAA==.',['Ó']='Óms:AwACCAIABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end