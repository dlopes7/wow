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
 local lookup = {'Shaman-Elemental','Warlock-Destruction','DemonHunter-Havoc','Monk-Mistweaver','Druid-Restoration','Druid-Guardian','Druid-Balance','Priest-Holy','Priest-Discipline','Priest-Shadow','Unknown-Unknown','DeathKnight-Blood','Paladin-Protection','Hunter-Marksmanship','DeathKnight-Unholy','Paladin-Retribution','Paladin-Holy',}; local provider = {region='US',realm='Bladefist',name='US',type='weekly',zone=42,date='2025-03-29',data={Aa='Aatrix:AwABCAEABRQCAQAIAQhcDQBC4FwCBAoAAQAIAQhcDQBC4FwCBAoAAA==.',Ai='Ailuria:AwADCAEABAoAAA==.',Al='Alikith:AwADCAEABAoAAA==.',Am='AmÃ¨lia:AwACCAIABAoAAA==.',An='Antuco:AwAECAoABAoAAA==.',Ar='Artemidoros:AwADCAMABAoAAA==.',As='Ashkaari:AwAGCBIABAoAAA==.',Au='Aursuna:AwAFCAcABAoAAA==.',Az='Azu:AwABCAEABAoAAA==.',Ba='Backerrz:AwABCAEABRQCAgAIAQhREwA+jVMCBAoAAgAIAQhREwA+jVMCBAoAAA==.',Be='Bellwynn:AwAFCAsABAoAAA==.Berzerked:AwAHCBIABAoAAA==.',Bo='Bobdalantern:AwABCAEABAoAAA==.Bordy:AwAFCAoABAoAAA==.',Br='Brejevol:AwADCAEABAoAAA==.Brotherdread:AwAFCAUABAoAAA==.',Bu='Burningdruid:AwAICAcABAoAAA==.',Co='Cornpop:AwADCAEABAoAAA==.',De='Demonnick:AwABCAIABRQCAwAIAQgIGQA5GlQCBAoAAwAIAQgIGQA5GlQCBAoAAA==.',Di='Dillexis:AwAGCBIABAoAAA==.',Dr='Drac:AwADCAkABAoAAA==.Dregon:AwABCAIABRQCBAAIAQjIAABgzGsDBAoABAAIAQjIAABgzGsDBAoAAA==.',Ea='Earthboy:AwABCAEABAoAAA==.',El='Elreasa:AwAFCAIABAoAAA==.',Et='Ettal:AwADCAEABAoAAA==.',Fa='Faydris:AwADCAMABAoAAA==.',Fe='Felkey:AwABCAEABAoAAA==.',Fi='Fivebigbooms:AwABCAIABRQEBQAIAQg8AwBVpAQDBAoABQAIAQg8AwBVpAQDBAoABgABAQgnFABYV18ABAoABwABAQgCbgAvsjQABAoAAA==.',Ga='Ganden:AwADCAgABAoAAA==.',Gi='Gimmli:AwAGCBAABAoAAA==.',Ha='Hawtpotato:AwABCAIABRQCAgAIAQhnDQBG5pECBAoAAgAIAQhnDQBG5pECBAoAAA==.',Jh='Jhoria:AwABCAEABAoAAA==.',Ka='Kastaritha:AwADCAMABAoAAA==.',Ke='Keiry:AwADCAUABAoAAA==.',Ki='Kickstarter:AwAFCAoABAoAAA==.',Kn='KnÃ¬ghtmare:AwADCAQABAoAAA==.',Kr='Krakenyoheed:AwADCAEABAoAAA==.',['KÃ']='KÃªÃ¿:AwABCAIABRQAAA==.',Le='Leigor:AwABCAIABRQECAAIAQivAABgp2QDBAoACAAIAQivAABgp2QDBAoACQABAQixTQBP4EgABAoACgABAQhGTQAaSSgABAoAAA==.Lestaat:AwABCAEABAoAAA==.',Li='Lionature:AwAFCAkABAoAAA==.Liteshocklet:AwAGCBIABAoAAA==.',Ma='Mackeygee:AwADCAQABAoAAQsAAAAECAgABAo=.',Mc='Mcksquizy:AwAGCAkABAoAAA==.',Me='Meatsheathe:AwADCAMABAoAAA==.',Mi='Mikedraven:AwACCAEABAoAAA==.Milenco:AwABCAEABAoAAA==.',Mo='Mooseknukle:AwABCAEABRQAAA==.Moritura:AwAECAkABAoAAA==.',Ni='Nickoftime:AwABCAEABAoAAQMAORoBCAIABRQ=.Niconte:AwACCAIABRQCCQAIAQhoBwBIEJoCBAoACQAIAQhoBwBIEJoCBAoAAA==.Nikonte:AwADCAMABAoAAQkASBACCAIABRQ=.',No='Nolan:AwAHCBEABAoAAA==.',Od='Odinsxshield:AwABCAEABAoAAA==.',Ov='Overkill:AwAFCAcABAoAAA==.',Pa='Pandakisses:AwABCAEABAoAAA==.',Ph='Philster:AwAFCBEABAoAAA==.',Pv='Pvp:AwAFCAgABAoAAA==.',Re='Rebeka:AwADCAcABAoAAA==.',['RÃ']='RÃ¨gekt:AwAICAcABAoAAA==.',Se='Seireitei:AwACCAEABAoAAA==.Selaheal:AwADCAkABAoAAA==.',Sh='Shortstackz:AwABCAEABAoAAA==.',Sl='Slivamane:AwAECAEABAoAAA==.',Sp='Spacebubby:AwADCAUABAoAAA==.Spyroh:AwADCAYABAoAAA==.',['SÃ']='SÃ¤m:AwADCAEABAoAAA==.',Ta='Tatoo:AwADCAYABAoAAA==.',Te='Teeice:AwAECAcABAoAAA==.',Ti='Tiddlywinks:AwABCAIABAoAAQsAAAAFCAsABAo=.',To='Toosus:AwABCAIABRQCDAAIAQgVBQBSwN8CBAoADAAIAQgVBQBSwN8CBAoAAA==.Toridian:AwADCAEABAoAAA==.',Tt='Tturtle:AwABCAIABRQCDQAIAQiGDAAv/dkBBAoADQAIAQiGDAAv/dkBBAoAAA==.',Vo='Voidedge:AwAFCAwABAoAAA==.',Vs='Vs:AwABCAIABRQCDgAIAQgmCABIUG8CBAoADgAIAQgmCABIUG8CBAoAAQoAMiYFCAoABRQ=.',['VÃ']='VÃ¡li:AwABCAEABAoAAA==.',Wi='Willybwankin:AwABCAIABRQCDwAIAQixAwBbWjIDBAoADwAIAQixAwBbWjIDBAoAAA==.',Wo='Wowgazm:AwAFCAsABAoAAA==.',Ze='Zesdragon:AwACCAMABAoAAA==.Zeseroth:AwABCAIABRQAAA==.',Zu='Zugg:AwAHCBYABAoDEAAHAQhBSgA178IBBAoAEAAHAQhBSgA178IBBAoAEQAFAQiFHgAbfOsABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end