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
 local lookup = {'Shaman-Enhancement','Unknown-Unknown','Paladin-Retribution','Druid-Balance','Mage-Fire','Priest-Discipline','Priest-Holy','Warlock-Demonology','Warlock-Destruction',}; local provider = {region='US',realm='Bloodhoof',name='US',type='weekly',zone=42,date='2025-03-29',data={An='Ancane:AwAFCAMABAoAAA==.',Ap='Aplcyder:AwAHCBEABAoAAA==.Apocryphea:AwADCAIABAoAAA==.',Ar='Armagazer:AwADCAMABAoAAA==.',Au='Audwizard:AwADCAIABAoAAA==.',Av='Avallohn:AwADCAEABAoAAA==.',Be='Beastmaster:AwAGCAIABAoAAA==.',Bi='Bissafiyah:AwAICBsABAoCAQAIAQgtAwBfZi0DBAoAAQAIAQgtAwBfZi0DBAoAAA==.',Bl='Bloodgon:AwAECAkABAoAAA==.',Bo='Bokue:AwAFCAwABAoAAA==.',Br='Brewsome:AwAFCAoABAoAAA==.Brighthammer:AwADCAMABAoAAA==.Bryybryy:AwADCAIABAoAAA==.Brz:AwADCAEABAoAAA==.',Ca='Canadani:AwAFCAgABAoAAA==.Caphriel:AwAECAQABAoAAA==.Capita:AwADCAcABAoAAA==.Casualbongos:AwADCAMABAoAAA==.',Ce='Cell:AwAFCAoABAoAAA==.',Cr='Critkittie:AwAGCAgABAoAAA==.',Cu='Current:AwADCAMABAoAAA==.',Da='Datsombeech:AwACCAMABAoAAA==.',De='Demonhunter:AwABCAIABRQAAA==.Densth:AwABCAEABAoAAA==.Deàdly:AwABCAIABAoAAA==.',Di='Disgruntled:AwABCAEABAoAAA==.',Do='Doncorlleone:AwACCAEABAoAAA==.Dorco:AwAHCBEABAoAAA==.',Dr='Draevan:AwAGCA0ABAoAAA==.Dranodon:AwAECAMABAoAAA==.Drminnowphd:AwACCAIABAoAAA==.Drspoon:AwAFCA0ABAoAAA==.',Dy='Dyspepsia:AwAFCAUABAoAAA==.',Es='Essence:AwAHCA4ABAoAAA==.',Fe='Feenii:AwAFCA0ABAoAAA==.',Fl='Flounder:AwAFCAwABAoAAA==.',Fo='Foxdeer:AwADCAEABAoAAA==.',Gl='Glimzrak:AwABCAEABAoAAA==.',Go='Gochujang:AwAGCA8ABAoAAA==.',Gr='Grandad:AwACCAIABAoAAA==.Grimrox:AwAECAEABAoAAA==.Grixx:AwADCAMABAoAAA==.Groupie:AwABCAEABAoAAQIAAAADCAUABAo=.Grumar:AwAICAUABAoAAA==.',Gw='Gwalcmai:AwACCAIABAoAAA==.',Ha='Haynk:AwADCAgABAoAAA==.',Hi='Hiccups:AwAFCAQABAoAAA==.',Ho='Holdmyagro:AwACCAIABAoAAA==.Holemeister:AwAHCBIABAoAAA==.Holymann:AwACCAMABAoAAA==.Holyz:AwAECAEABAoAAA==.',Is='Ishkala:AwABCAEABRQAAA==.',Ja='Jartik:AwAECAQABAoAAA==.',Ji='Jimbus:AwAECAQABAoAAQIAAAABCAIABRQ=.',Ka='Kaldra:AwAFCA8ABAoAAA==.Kalirkaz:AwADCAIABAoAAA==.Karasu:AwAGCAkABAoAAA==.',Ki='Kiemen:AwAHCA4ABAoAAA==.',['K�']='Kål:AwACCAIABAoAAA==.',Le='Len:AwAFCAsABAoAAA==.',Li='Liliara:AwAHCBEABAoAAA==.Lillyslight:AwACCAIABAoAAA==.Lindalinda:AwABCAIABAoAAA==.',Lo='Lokusnake:AwAGCBIABAoAAA==.',Ma='Mapleman:AwACCAQABAoAAA==.',Me='Mellow:AwADCAMABAoAAA==.Mervenious:AwAFCAUABAoAAA==.',Mi='Minmzey:AwAHCAUABAoAAA==.Minrô:AwAGCBAABAoAAA==.Mistdeeznuts:AwABCAEABRQAAA==.',Mo='Mograine:AwADCAUABAoAAA==.',Ms='Mskelsier:AwACCAIABAoAAA==.',Mu='Muclor:AwABCAIABRQAAA==.',['M�']='Måzikeen:AwACCAIABAoAAA==.',Nd='Ndiz:AwACCAMABAoAAA==.',Ni='Nipsparkles:AwADCAIABAoAAA==.',Ol='Olgon:AwAGCBEABAoAAA==.',Pa='Pattycakes:AwAGCA4ABAoAAA==.',Ph='Pherocious:AwAECAkABAoAAA==.',Pr='Primordinor:AwADCAcABAoAAA==.',Qu='Quasigeddon:AwACCAIABAoAAA==.',Ra='Rakan:AwAHCA8ABAoAAA==.Rallick:AwAGCBEABAoAAA==.',Re='Renard:AwADCAcABAoAAA==.Rendkick:AwAGCA0ABAoAAA==.',Rh='Rhatchet:AwADCAMABAoAAQIAAAAECAkABAo=.',Ro='Rodcet:AwAFCAEABAoAAA==.Roflmoist:AwADCAIABAoAAA==.Rookgue:AwAFCA0ABAoAAA==.Rookoker:AwAGCA0ABAoAAA==.Rossperot:AwACCAQABAoAAA==.',Sa='Saelara:AwAFCAcABAoAAA==.Samgee:AwACCAMABRQCAwAIAQgwFgBRX78CBAoAAwAIAQgwFgBRX78CBAoAAA==.Sancdruary:AwEFCAUABAoAAA==.',Sc='Schnoz:AwABCAEABAoAAA==.',Sl='Slappysocks:AwACCAIABRQCBAAIAQjVCABYX+oCBAoABAAIAQjVCABYX+oCBAoAAQUAVykECAsABRQ=.',Sn='Snuzzle:AwACCAQABAoAAA==.',So='Sourmash:AwADCAMABAoAAA==.',Sr='Srasjet:AwADCAMABAoAAA==.',St='Starlight:AwAFCAgABAoAAA==.Stealthed:AwAICBEABAoAAA==.Stårlyte:AwAICBEABAoAAA==.',Su='Sukul:AwAECAkABAoAAA==.Supersayan:AwADCAIABAoAAA==.',Ta='Taraylda:AwADCAMABAoAAQIAAAADCAMABAo=.',Tu='Tunda:AwADCAMABAoAAA==.',Ty='Tyg:AwABCAIABRQDBgAIAQgnFAAuz8gBBAoABgAIAQgnFAAnf8gBBAoABwADAQgKRQA2X6oABAoAAA==.',Ur='Urlaz:AwAFCAQABAoAAA==.',Va='Vampireshade:AwADCAIABAoAAA==.',Vo='Voidlink:AwAFCAsABAoAAA==.',Wa='Wakaekwondo:AwADCAEABAoAAA==.Wap:AwAICAEABAoAAA==.',Xy='Xylanthia:AwADCAMABAoAAA==.',Za='Zadai:AwAHCBEABAoAAA==.Zaen:AwAGCBUABAoDCAAGAQjbDABRL5MBBAoACAAFAQjbDABP8ZMBBAoACQAFAQi7KwBMNZIBBAoAAA==.Zané:AwABCAEABAoAAQgAUS8GCBUABAo=.',Zl='Zlyandien:AwADCAMABAoAAA==.',Zu='Zulrich:AwABCAEABRQAAA==.',['Â']='Âmerìssìs:AwADCAIABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end