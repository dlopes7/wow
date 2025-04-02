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
 local lookup = {'Monk-Mistweaver','Warlock-Destruction','Hunter-Survival','Mage-Fire','Warlock-Affliction','Warlock-Demonology','Rogue-Assassination','Monk-Windwalker','Unknown-Unknown','DemonHunter-Havoc','Warrior-Fury','Shaman-Enhancement','Evoker-Preservation','Druid-Restoration','DemonHunter-Vengeance','DeathKnight-Unholy','Warrior-Protection','Priest-Shadow','Paladin-Protection','Shaman-Restoration','Druid-Balance',}; local provider = {region='US',realm="Dath'Remar",name='US',type='weekly',zone=42,date='2025-03-29',data={Ac='Ackleholic:AwACCAQABRQCAQAIAQgHCwBLWJECBAoAAQAIAQgHCwBLWJECBAoAAA==.',Ad='Advosary:AwADCAcABAoAAA==.',Ae='Aetherwind:AwAFCAoABAoAAA==.',Ai='Aigilas:AwAFCAMABAoAAA==.',Al='Alisandrah:AwADCAgABRQCAgADAQjgAgBWpyIBBRQAAgADAQjgAgBWpyIBBRQAAA==.Alistairr:AwACCAIABAoAAA==.Altaylia:AwAECAUABAoAAA==.',Am='Amilandris:AwADCAQABAoAAA==.',An='Antwonton:AwACCAEABAoAAA==.',Ap='Apoloc:AwADCAcABAoAAA==.Appolo:AwAECAwABAoAAA==.',Ar='Aralock:AwADCAMABAoAAA==.Archmeow:AwAGCA4ABAoAAA==.',As='Ashmend:AwADCAcABAoAAA==.Ashuruk:AwACCAMABAoAAA==.',Av='Avenged:AwACCAEABAoAAA==.',Aw='Awkward:AwACCAQABAoAAA==.',Az='Aztrayel:AwAGCA8ABAoAAA==.',Ba='Babychino:AwAECAkABAoAAA==.Baly:AwADCAQABAoAAA==.',Be='Beef:AwAGCA4ABAoAAA==.Belnewid:AwADCAcABAoAAA==.',Bi='Bigjawden:AwADCAcABAoAAA==.Billbee:AwADCAUABAoAAA==.',Bl='Blackbelter:AwACCAIABAoAAA==.Blaen:AwADCAUABAoAAA==.Bloodleater:AwAFCAUABAoAAA==.',Br='Brutus:AwAFCAoABAoAAA==.',Ca='Cactusnight:AwADCAcABAoAAA==.Caiaphas:AwAICAEABAoAAA==.Calasandria:AwADCAQABAoAAA==.Caramord:AwAFCAkABAoAAA==.Cas:AwAHCBYABAoCAwAHAQgOAQBa/doCBAoAAwAHAQgOAQBa/doCBAoAAA==.Castalight:AwADCAQABAoAAA==.Caylalais:AwAFCAoABAoAAA==.',Ce='Celestlmonk:AwACCAIABAoAAA==.',Ch='Chubi:AwAICAIABAoAAA==.',Ci='Cindell:AwAGCAwABAoAAA==.',Co='Corvys:AwABCAEABAoAAA==.',Cr='Cruz:AwAICBgABAoCBAAIAQhlDQBOJcUCBAoABAAIAQhlDQBOJcUCBAoAAA==.Cryos:AwAFCAYABAoAAA==.',Cy='Cynal:AwAHCBAABAoAAA==.',Da='Daddyy:AwABCAEABRQEAgAHAQixLgBPaH8BBAoAAgAFAQixLgBMQH8BBAoABQADAQhlEgBGze0ABAoABgACAQjMJwBOVawABAoAAA==.Dajelein:AwAICAgABAoAAA==.Dallado:AwAICAgABAoAAA==.Dammo:AwABCAEABAoAAA==.Darklady:AwACCAIABAoAAA==.',Dc='Dcver:AwACCAIABRQCBgAIAQidAQBTftoCBAoABgAIAQidAQBTftoCBAoAAA==.',De='Deadlynewbz:AwABCAIABRQCBwAHAQgJBABaVdECBAoABwAHAQgJBABaVdECBAoAAA==.Decypha:AwAFCAoABAoAAA==.Demtara:AwAGCAwABAoAAA==.Deomas:AwAECAQABAoAAA==.Depravitÿ:AwADCAQABAoAAA==.Dexillo:AwAECAQABAoAAA==.',Di='Diabolicus:AwAFCAoABAoAAA==.Dirtyret:AwADCAMABAoAAA==.',Dr='Draik:AwADCAcABAoAAA==.Drinian:AwAECAkABAoAAA==.Drooidd:AwAFCAYABAoAAA==.',Du='Ducker:AwADCAUABRQCCAADAQglAgBTDzIBBRQACAADAQglAgBTDzIBBRQAAA==.',Dy='Dylirium:AwAHCA8ABAoAAA==.',Ec='Eclipseqt:AwAFCAEABAoAAA==.',Ed='Ed:AwAECAQABAoAAA==.',Ek='Ekiome:AwAECAsABAoAAA==.',El='Elenadanvers:AwADCAEABAoAAA==.Elmaco:AwAGCBAABAoAAA==.Elysh:AwAHCAwABAoAAA==.Elyssaelm:AwABCAEABAoAAQkAAAAHCAwABAo=.',Er='Ero:AwAGCAEABAoAAA==.',Ev='Everleaf:AwACCAUABAoAAA==.',Fa='Fadepower:AwADCAEABAoAAA==.Faildave:AwACCAQABAoAAA==.Fallendivine:AwAHCAsABAoAAA==.',Fe='Felflayer:AwACCAMABRQCCgAIAQgMFQBAenoCBAoACgAIAQgMFQBAenoCBAoAAA==.Felissa:AwADCAIABAoAAA==.Fensmage:AwAHCA0ABAoAAA==.',Fm='Fmjxd:AwACCAIABAoAAA==.',Fo='Foreignerr:AwADCAYABAoAAA==.',['F�']='Fíredup:AwAGCA8ABAoAAQkAAAAGCBAABAo=.',Ga='Gallene:AwADCAUABRQCCwADAQhdBgAunfoABRQACwADAQhdBgAunfoABRQAAA==.Garthpally:AwADCAMABAoAAA==.',Ge='Genimaculata:AwAFCAYABAoAAQkAAAAFCAoABAo=.',Gh='Ghostxd:AwAHCA4ABAoAAA==.',Gi='Gingerbits:AwADCAEABAoAAA==.',Go='Going:AwAHCBcABAoCDAAHAQgAGgAis7ABBAoADAAHAQgAGgAis7ABBAoAAA==.',Gu='Gusta:AwADCAYABAoAAA==.',Ha='Harleybear:AwADCAUABAoAAA==.Harthius:AwABCAEABAoAAA==.',Ho='Hobo:AwADCAYABAoAAA==.',In='Invincibull:AwAFCAEABAoAAA==.',Ir='Irasa:AwACCAIABAoAAA==.Irtroll:AwAECAMABAoAAA==.Irvinia:AwAGCAsABAoAAA==.',It='Itzslappy:AwAGCAoABAoAAA==.',Ja='Jabato:AwADCAIABAoAAA==.Jadedoriana:AwAGCA4ABAoAAA==.Janinda:AwAICAMABAoAAA==.Janine:AwABCAEABRQCDQAIAQhoAQBU6QcDBAoADQAIAQhoAQBU6QcDBAoAAA==.',Jo='Joefist:AwAFCAMABAoAAA==.Joshst:AwACCAIABAoAAA==.Josto:AwABCAEABAoAAA==.',Ka='Kaidouu:AwAECAwABAoAAA==.Kamakazie:AwADCAYABAoAAA==.Kamelle:AwAGCA4ABAoAAA==.Kaul:AwAFCAMABAoAAA==.Kazson:AwAFCAEABAoAAA==.',Ke='Kelsern:AwAFCAoABAoAAA==.',Ki='Killuoneshot:AwADCAMABAoAAA==.Kinnigit:AwAFCAgABAoAAA==.Kithrah:AwABCAEABAoAAQkAAAAGCBMABAo=.Kithrâh:AwAGCBMABAoAAA==.',Ko='Konkar:AwAECAEABAoAAA==.',Kr='Kreedin:AwAECAYABAoAAA==.',La='Lars:AwACCAEABAoAAA==.Larxe:AwAECAQABAoAAA==.',Le='Lethanâ:AwAGCBAABAoAAA==.',Li='Lilind:AwADCAcABAoAAA==.',Lo='Lorieyxo:AwADCAYABAoAAA==.Lossdotjpeg:AwAECAoABAoAAA==.Loungedancer:AwAICAkABAoAAA==.',Lu='Lucifear:AwABCAEABAoAAA==.Luena:AwAGCAMABAoAAA==.',['L�']='Láiken:AwADCAYABAoAAA==.',Ma='Madcalve:AwAFCAgABAoAAA==.Madmoxxie:AwAFCAgABAoAAA==.Magikmidget:AwADCAUABAoAAA==.Mahonanida:AwAGCBQABAoCDgAGAQh5FABI684BBAoADgAGAQh5FABI684BBAoAAA==.Majinoodle:AwAFCAYABAoAAA==.Malachia:AwAECAwABAoAAA==.',Me='Mekke:AwAFCAEABAoAAA==.Meowthh:AwAICAEABAoAAA==.',Mi='Mickius:AwAICBAABAoAAA==.Mintchocchip:AwAFCAsABAoAAA==.Mishamigo:AwAECAQABAoAAQEAS1gCCAQABRQ=.Misokim:AwAGCA0ABAoAAA==.',Mo='Mochalatte:AwAFCA8ABAoAAA==.Moistfisting:AwADCAYABAoAAA==.Mordana:AwABCAEABRQCDwAIAQjwAgBVofUCBAoADwAIAQjwAgBVofUCBAoAAA==.',Na='Naakk:AwADCAIABAoAAA==.Nardaran:AwABCAIABRQAAA==.',Ne='Needcoffee:AwABCAEABAoAAA==.Neondh:AwADCAcABAoAAA==.',Ni='Nightravén:AwADCAUABAoAAQkAAAAGCAoABAo=.Nitevoker:AwADCAcABAoAAA==.',No='Nordalea:AwAHCBMABAoAAA==.Nospheratu:AwABCAEABRQAAA==.',Nu='Nuggetpouch:AwACCAQABAoAAA==.',Ny='Nycemonk:AwADCAcABAoAAA==.',On='Ondori:AwAFCAsABAoAAA==.Onigarou:AwAFCAMABAoAAA==.Onoitscarl:AwACCAMABAoAAA==.',Oz='Ozzy:AwACCAIABAoAAQkAAAADCAUABAo=.',Pa='Pallado:AwAECAYABAoAAQkAAAAICAgABAo=.Pallywings:AwAFCAMABAoAAA==.Pawpaww:AwAGCAIABAoAAA==.',Pe='Perameles:AwAFCAUABAoAAA==.',Po='Poodragon:AwABCAEABAoAAA==.Poùnd:AwAECAQABAoAAQkAAAAGCBAABAo=.',Pr='Predakìng:AwADCAcABAoAAA==.',Ra='Ramagos:AwACCAIABAoAAA==.Rav:AwAECAcABAoAAA==.Ravenimus:AwABCAEABAoAAA==.Razeld:AwADCAcABAoAAA==.Razia:AwADCAYABAoAAA==.Razzmata:AwADCAcABAoAAA==.',Re='Rehunt:AwABCAIABAoAAQkAAAAGCA8ABAo=.Relock:AwAGCA8ABAoAAA==.Revanyaup:AwAGCA0ABAoAAA==.Rexy:AwAGCAMABAoAAA==.',Rh='Rhudian:AwAHCAIABAoAAA==.',Rj='Rjrex:AwAICBMABAoAAA==.',Ro='Rodador:AwACCAEABAoAAA==.Rozabella:AwAFCAoABAoAAA==.',Sa='Sakuraharuno:AwAFCBEABAoAAA==.Saltburn:AwAFCAMABAoAAA==.Sargash:AwABCAEABRQCEAAIAQgyCgBVXrkCBAoAEAAIAQgyCgBVXrkCBAoAAA==.Sassyhealz:AwACCAIABAoAAA==.',Se='Selennys:AwAFCAEABAoAAA==.',Sh='Shadowkain:AwADCAMABAoAAA==.Shaydana:AwADCAUABAoAAA==.Shiphra:AwADCAMABAoAAA==.',Si='Silvanas:AwABCAEABAoAAA==.Sinaria:AwACCAIABAoAAQoAQHoCCAMABRQ=.Sinbin:AwADCAMABAoAAA==.',Sm='Smoldaddy:AwADCAUABAoAAA==.',Sn='Sneakybeaver:AwAECAIABAoAAA==.',So='Sokraxx:AwABCAEABRQCEQAIAQgoAABig4QDBAoAEQAIAQgoAABig4QDBAoAAA==.Sonogon:AwAGCBMABAoAAA==.',Sp='Spearzy:AwAGCBAABAoAAA==.Spårklïng:AwAGCBAABAoAAA==.',St='Stabit:AwACCAIABAoAAA==.Stae:AwAFCAsABAoAAA==.Steelbull:AwAFCAQABAoAAA==.Stifcoat:AwAECAMABAoAAA==.',Sy='Sycamore:AwABCAIABRQAAA==.',Sz='Szarni:AwADCAUABAoAAA==.',['S�']='Sênsêi:AwAGCAMABAoAAA==.',Te='Tehmage:AwAFCAoABAoAAA==.',Th='Thiea:AwAGCAEABAoAAA==.Thoor:AwABCAEABAoAAA==.Thunderpog:AwACCAIABRQCEgAIAQh1AgBbcD8DBAoAEgAIAQh1AgBbcD8DBAoAAA==.',To='Topshot:AwAFCAoABAoAAA==.',Ty='Tyielas:AwAGCBIABAoAAA==.Tyrlidon:AwADCAQABAoAAA==.',Uf='Ufknspaz:AwAGCA4ABAoAAA==.',Ul='Ulrike:AwAHCBUABAoCEwAHAQgREQAteYcBBAoAEwAHAQgREQAteYcBBAoAAA==.',Va='Varthele:AwADCAYABAoAAA==.',Ve='Veris:AwAECAQABAoAAQIAVqcDCAgABRQ=.',Vi='Vio:AwADCAcABRQCFAADAQhdAgBVWC4BBRQAFAADAQhdAgBVWC4BBRQAAA==.',Vo='Voidblade:AwADCAYABAoAAA==.',Wa='Wabaki:AwACCAMABRQAAA==.Wabbajacked:AwAGCBQABAoCEwAGAQgXDwBCJqcBBAoAEwAGAQgXDwBCJqcBBAoAAA==.Wabssevo:AwAECAQABAoAAQkAAAACCAMABRQ=.Wabssp:AwABCAEABRQAAQkAAAACCAMABRQ=.',We='Weiland:AwAGCBIABAoAAA==.',Wo='Wolfsguard:AwAICAgABAoAAA==.Wolvaren:AwAECAoABAoAAA==.',Xe='Xelbie:AwADCAUABAoAAA==.',Xw='Xwing:AwADCAEABAoAAA==.',Ye='Yeetcannon:AwAGCAoABAoAAA==.',Yi='Yidaki:AwADCAUABAoAAA==.',Za='Zaion:AwAECAMABAoAAA==.',Zo='Zoinlock:AwAECAQABAoAAA==.Zolce:AwACCAIABAoAAQkAAAAFCAUABAo=.Zolcey:AwAFCAUABAoAAA==.Zonkie:AwAECAcABAoAAA==.',Zw='Zwirbel:AwAFCAoABAoAAA==.',Zy='Zybaxos:AwAGCBQABAoCFQAGAQivHABTmAICBAoAFQAGAQivHABTmAICBAoAAA==.Zygfrryd:AwAECAgABAoAAA==.',['Ì']='Ìçê:AwABCAEABAoAAA==.',['Î']='Îssy:AwAECAsABAoAAA==.',['Ò']='Òbsidian:AwAGCBEABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end