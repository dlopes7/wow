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
 local lookup = {'Warlock-Destruction','Unknown-Unknown','Mage-Frost','Evoker-Devastation','Warrior-Arms','Warrior-Fury','Mage-Fire','Shaman-Restoration','Warlock-Affliction','Warlock-Demonology','Monk-Windwalker','Paladin-Retribution','Paladin-Holy','Priest-Holy','Priest-Discipline','Shaman-Enhancement','Evoker-Preservation','Priest-Shadow',}; local provider = {region='US',realm="Lightning'sBlade",name='US',type='weekly',zone=42,date='2025-03-29',data={Ab='Abeyance:AwAICAsABAoAAA==.',Ad='Addictionn:AwAGCA0ABAoAAA==.',Ag='Aguni:AwAFCA4ABAoAAA==.',Aj='Ajunlucky:AwAHCBEABAoAAA==.',Al='Alody:AwACCAUABAoAAA==.Aluene:AwAFCAsABAoAAA==.',An='Andrea:AwADCAYABAoAAA==.',Ao='Aoibhinn:AwAECAEABAoAAA==.',Ar='Arallinx:AwAHCBQABAoCAQAHAQhODABSnJ4CBAoAAQAHAQhODABSnJ4CBAoAAA==.Argentzephyr:AwAECAgABAoAAA==.',Ay='Ayumi:AwABCAEABAoAAA==.',Ba='Bastrasz:AwAICAUABAoAAA==.',Be='Beasti:AwAFCAIABAoAAA==.Bellator:AwABCAEABAoAAA==.',Bi='Bigvikingg:AwAGCAoABAoAAA==.Binnyi:AwAECAIABAoAAA==.',Bl='Blabidael:AwAECAYABAoAAA==.Blabidil:AwACCAIABAoAAA==.Blastphemy:AwAECAcABAoAAA==.',Bo='Bouberry:AwAECA8ABAoAAA==.Bowzer:AwAECAIABAoAAA==.',Bu='Bunsu:AwAFCA0ABAoAAA==.',Ca='Caliet:AwAFCAcABAoAAA==.',Ch='Chess:AwACCAIABAoAAA==.',Cr='Crazysoul:AwABCAEABAoAAQIAAAAFCA0ABAo=.Cryogenicsz:AwAICAgABAoAAQIAAAAICBAABAo=.Cryosham:AwAICBAABAoAAA==.',Da='Dainsleif:AwAHCAEABAoAAA==.Dampundies:AwABCAEABAoAAA==.Darkàn:AwAECAIABAoAAA==.',De='Dekomori:AwAHCAcABAoAAA==.Demonchicken:AwADCAMABAoAAQIAAAAFCAsABAo=.Demonhumper:AwAFCAEABAoAAA==.Dereksama:AwAFCAsABAoAAA==.Devbusswife:AwABCAIABRQAAA==.Deviiarrc:AwAFCAIABAoAAA==.Devisper:AwADCAMABAoAAA==.',Di='Dibi:AwABCAIABRQAAA==.',Dr='Dracarrow:AwAFCAEABAoAAA==.Dreyvina:AwAECAIABAoAAA==.Druidzinga:AwAHCBAABAoAAA==.',['D�']='Dâvîs:AwAHCAQABAoAAA==.',Ek='Ekitten:AwABCAEABRQAAA==.',Eq='Eq:AwACCAEABAoAAQIAAAAFCAQABAo=.',Er='Erals:AwAFCAEABAoAAA==.Eralt:AwAECAIABAoAAA==.',Fa='Faithshand:AwAECAIABAoAAA==.Fartybumbum:AwADCAMABAoAAA==.',Fe='Fellumir:AwAGCA8ABAoAAA==.',Fi='Finkenator:AwABCAIABRQCAwAIAQhBBABZYg0DBAoAAwAIAQhBBABZYg0DBAoAAA==.',Fl='Flameshock:AwAFCA0ABAoAAA==.',Fr='Fragility:AwACCAIABRQAAA==.Freeman:AwACCAIABAoAAA==.Frïgïdbïch:AwACCAIABAoAAA==.',Ge='Gethoofed:AwABCAEABRQAAQIAAAABCAEABRQ=.',Gl='Globalwarmin:AwAICAgABAoAAA==.Globoe:AwAFCA4ABRQCBAAFAQgsAABfkCQCBRQABAAFAQgsAABfkCQCBRQAAA==.Gloreb:AwAECAQABAoAAA==.',Ha='Harrowing:AwAGCA0ABAoAAA==.Harufnahlem:AwADCAQABAoAAA==.Haurt:AwAFCAIABAoAAA==.',He='Healsbro:AwAFCAEABAoAAA==.Heavyload:AwAICAkABAoAAA==.',Hu='Hu:AwABCAIABRQAAA==.',Ic='Icebucket:AwAHCAkABAoAAA==.',Ig='Ignius:AwABCAEABAoAAQUAUowDCAUABRQ=.',In='Insanë:AwAICAgABAoAAA==.Invisibulls:AwACCAIABAoAAQIAAAABCAEABRQ=.',Ir='Iron:AwAECAoABRQDBgAEAQi6AABXOKkBBRQABgAEAQi6AABXOKkBBRQABQABAQiHCwATYTsABRQAAA==.',Jo='Josefjostar:AwAHCAQABAoAAA==.',Ki='Kidneyshot:AwACCAIABAoAAQIAAAABCAIABRQ=.',Ku='Kungfudegru:AwAFCAkABAoAAA==.',Ky='Kyvoker:AwAICAgABAoAAA==.',La='Lathril:AwACCAIABAoAAQIAAAAFCAsABAo=.',Le='Leibowitzy:AwADCAgABAoAAA==.',Lh='Lhehitman:AwABCAIABRQDAwAHAQh0HQBD4MkBBAoAAwAGAQh0HQBJZMkBBAoABwAHAQgJKQAwGL8BBAoAAA==.',Lu='Ludey:AwAHCBMABAoAAA==.Lutray:AwAECAkABAoAAA==.',Ma='Magelinn:AwAFCAwABAoAAA==.Marodd:AwAECAgABAoAAA==.',Me='Meklena:AwAECAIABAoAAA==.',Mo='Moonslayer:AwAECAIABAoAAA==.Morega:AwAICAoABAoAAA==.Morphinne:AwACCAIABAoAAA==.',Na='Nabaar:AwACCAIABRQCCAAIAQhkIAApnsQBBAoACAAIAQhkIAApnsQBBAoAAA==.Nazum:AwADCAMABAoAAA==.',Ne='Nefeli:AwAGCAYABAoAAA==.Nestia:AwACCAIABAoAAA==.Never:AwABCAEABRQECQAIAQjnCABFVIcBBAoACQAFAQjnCAA32YcBBAoAAQAFAQifLQBGf4YBBAoACgACAQjsJwBPbqsABAoAAA==.',Ni='Nile:AwAFCA4ABAoAAA==.Nitron:AwAICAgABAoAAQIAAAABCAEABRQ=.Nitrun:AwABCAEABRQAAA==.',No='Nocturnalls:AwACCAMABRQCCwAIAQjkDABLc2ACBAoACwAIAQjkDABLc2ACBAoAAA==.',['N�']='Nìle:AwACCAIABAoAAA==.',Ob='Oblaan:AwAECAkABAoAAA==.',Oj='Ojo:AwAECAgABAoAAA==.',Ot='Ot:AwAFCAQABAoAAA==.Otum:AwABCAEABAoAAA==.',Pa='Pachi:AwAECAcABAoAAA==.Pallydyne:AwAHCBQABAoDDAAHAQifVQA2LJkBBAoADAAGAQifVQA1WZkBBAoADQAGAQiZGwAU1QwBBAoAAA==.Panter:AwAECAYABAoAAA==.',Ph='Phalanxphil:AwAICA4ABAoAAA==.Pharaoh:AwAGCA8ABAoAAA==.Phodoe:AwAECAIABAoAAA==.',Pl='Playne:AwAECAkABAoAAA==.',Pt='Ptheve:AwABCAIABRQAAQYAXIQECAwABRQ=.',Pu='Pumper:AwADCAMABAoAAA==.',Ra='Raidboss:AwAECAIABAoAAA==.Ramira:AwADCAQABAoAAA==.',Re='Reichata:AwAGCBEABAoAAA==.',Ro='Roxxiloxxi:AwAFCAIABAoAAA==.',Sa='Sabria:AwAFCAsABAoAAA==.Sapph:AwACCAIABAoAAA==.',Sc='Scalpelheals:AwAFCA4ABRQDDgAFAQi4AAA521kBBRQADgAEAQi4AABF6VkBBRQADwABAQgEDAAJo1YABRQAAA==.Schizlol:AwAICAgABAoAAA==.',Se='Sebekuul:AwAGCA0ABAoAAA==.Sephurik:AwADCAYABRQCBwADAQhzCAAwgQsBBRQABwADAQhzCAAwgQsBBRQAAA==.',Si='Sion:AwAFCA0ABAoAAA==.',Sk='Sky:AwADCAMABAoAAA==.Skyelf:AwAFCAQABAoAAA==.',Sm='Smoog:AwAFCAgABAoAAA==.',So='Socratez:AwAGCAEABAoAAA==.',Sp='Spudnik:AwADCAMABAoAAA==.',St='Steve:AwADCAkABRQCEAADAQiLAgA6miIBBRQAEAADAQiLAgA6miIBBRQAAA==.Streetcat:AwADCAMABAoAAA==.',Su='Sunhoof:AwAECAMABAoAAA==.',Ta='Tabi:AwAECAIABAoAAA==.Tawakkul:AwABCAEABAoAAA==.',Te='Temtation:AwAICAgABAoAAA==.Terroth:AwAECAMABAoAAA==.',Th='Thechikening:AwAFCAsABAoAAA==.Theliono:AwADCAUABAoAAA==.Thetaint:AwAHCAYABAoAAA==.Thug:AwADCAgABAoAAA==.Thunderkow:AwAGCA8ABAoAAA==.',Ti='Tirris:AwAFCAEABAoAAA==.',To='Toastiekins:AwACCAIABAoAAA==.Tomahawkchow:AwADCAMABAoAAA==.Totemofpeace:AwADCAMABAoAAA==.',Tr='Trentvoker:AwABCAEABRQDBAAIAQjsBwBUdKYCBAoABAAHAQjsBwBZzqYCBAoAEQADAQhwFQAn4pwABAoAAA==.',Ts='Tsu:AwACCAIABAoAAA==.',Tu='Turagh:AwADCAYABAoAAA==.',Va='Valdrynn:AwAGCAsABAoAAA==.',Vi='Vil:AwAFCA4ABRQCEgAFAQhJAABQeQECBRQAEgAFAQhJAABQeQECBRQAAA==.',Wa='Wanred:AwAFCAUABAoAAA==.',We='Weirdboy:AwADCAMABAoAAA==.',Wi='Wideload:AwAICAgABAoAAA==.Williie:AwAICAgABAoAAA==.',Wo='Wo:AwAECAcABAoAAA==.',Xa='Xaliko:AwAECAoABAoAAA==.',Xe='Xeleria:AwAHCBQABAoCAwAHAQhREABJuUkCBAoAAwAHAQhREABJuUkCBAoAAA==.',Ze='Zealous:AwACCAEABAoAAA==.Zerlan:AwAFCAMABAoAAA==.',['Æ']='Æynsof:AwAECAQABAoAAA==.Æzekiel:AwAICAgABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end