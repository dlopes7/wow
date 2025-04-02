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
 local lookup = {'Warrior-Fury','DemonHunter-Havoc','Unknown-Unknown','Hunter-BeastMastery','Warlock-Demonology','Warlock-Destruction','Warlock-Affliction','Shaman-Elemental','Evoker-Preservation','Paladin-Protection','Druid-Restoration',}; local provider = {region='US',realm='Tanaris',name='US',type='weekly',zone=42,date='2025-03-28',data={Am='Amiradormi:AwABCAEABAoAAA==.',An='Anarirn:AwABCAIABAoAAA==.Antamun:AwAICBUABAoCAQAIAQiVIQAXSLwBBAoAAQAIAQiVIQAXSLwBBAoAAA==.',Ao='Aoasis:AwADCAMABAoAAA==.',Av='Avande:AwAICBYABAoCAgAIAQhuDABPidQCBAoAAgAIAQhuDABPidQCBAoAAA==.',Ba='Baelout:AwACCAQABAoAAA==.Baubbles:AwAGCA4ABAoAAA==.',Be='Beetsalad:AwAICBMABAoAAA==.Betamage:AwACCAIABAoAAA==.',Br='Braghima:AwADCAQABAoAAA==.',Ci='Cimmaraya:AwADCAEABAoAAA==.',Co='Coagulation:AwAFCAoABAoAAA==.',Cy='Cyione:AwAGCAoABAoAAA==.',Da='Dadu:AwADCAQABAoAAA==.',Dr='Draxillidari:AwAICAgABAoAAA==.',Ds='Dsypha:AwABCAEABAoAAA==.',['D�']='Dÿlïläh:AwACCAIABAoAAA==.',Ed='Edric:AwADCAMABAoAAA==.',Ef='Efreet:AwAECAcABAoAAA==.',El='Elimae:AwAICAgABAoAAA==.',Eu='Eurae:AwADCAQABAoAAA==.',Fa='Fadedhalo:AwADCAgABAoAAA==.Farrahmoans:AwADCAQABAoAAA==.',Fr='Frostyie:AwABCAIABAoAAQMAAAAGCAgABAo=.Frøzen:AwADCAMABAoAAA==.',Ga='Galmeditates:AwAFCAkABAoAAA==.',Gi='Gitrog:AwADCAYABAoAAA==.',Go='Goodisdead:AwADCAMABAoAAA==.',Gu='Gurren:AwAICBAABAoAAA==.',He='Hellenita:AwABCAEABAoAAA==.',Hi='Hisayo:AwADCAoABAoAAA==.',Ho='Holyoshyy:AwACCAYABAoAAA==.Holyvengence:AwAGCAgABAoAAA==.',Hu='Hukawa:AwADCAYABAoAAA==.',Ie='Iemanja:AwABCAEABAoAAA==.',Ir='Ironmaged:AwADCAoABAoAAA==.',It='Ithaka:AwADCAMABAoAAA==.',Ka='Kahrul:AwADCAcABAoAAA==.',Ly='Lytka:AwAGCAEABAoAAA==.',Mi='Miandra:AwAGCAEABAoAAA==.',Mo='Moonarch:AwABCAEABAoAAA==.',Ne='Neilrodimus:AwAFCAgABAoAAA==.Nessva:AwAFCA8ABAoAAA==.Neçromonger:AwAICBYABAoCBAAIAQjwAQBh9nEDBAoABAAIAQjwAQBh9nEDBAoAAA==.',Ni='Nightfire:AwAFCA8ABAoAAA==.',['N�']='Nïghtmärë:AwACCAMABAoAAA==.',Ob='Obsessedwith:AwADCAEABAoAAA==.',Or='Orcofmeister:AwACCAIABAoAAA==.',Pa='Pandatude:AwAHCBEABAoAAA==.',Ra='Rashi:AwADCAMABAoAAA==.Razør:AwACCAIABAoAAA==.',Re='Rebekah:AwACCAIABAoAAA==.',Ro='Ronrad:AwAICBYABAoEBQAIAQhIAQBUx+wCBAoABQAIAQhIAQBUx+wCBAoABgACAQhUXgBDv4wABAoABwABAQgCIwBUKlAABAoAAA==.Ronsteur:AwACCAIABAoAAQUAVMcICBYABAo=.Rozzinor:AwADCAQABAoAAA==.',Ru='Rubytues:AwADCAMABAoAAA==.Rukía:AwADCAcABAoAAA==.',Sa='Sai:AwACCAIABAoAAA==.Savageslayer:AwAHCBEABAoAAA==.',Se='Sentientmist:AwABCAEABAoAAA==.',Sh='Sharona:AwADCAMABAoAAA==.',Si='Sinuouss:AwADCAUABAoAAA==.',Ta='Takerfan:AwAECAIABAoAAA==.Tangerine:AwADCAMABAoAAA==.',Te='Testsubject:AwAICBUABAoCCAAIAQjrDQA9bkkCBAoACAAIAQjrDQA9bkkCBAoAAA==.',Th='Thich:AwAFCAUABAoAAA==.Throld:AwAHCBEABAoAAA==.Thundrer:AwABCAEABAoAAA==.',Ti='Tibernius:AwACCAIABAoAAA==.',Tu='Tunipps:AwAFCA0ABAoAAA==.',Va='Vahriis:AwACCAIABAoAAA==.Vandal:AwAGCA0ABAoAAA==.',Vi='Vilyns:AwACCAIABAoAAQMAAAADCAYABAo=.',Vm='Vmax:AwADCAYABAoAAA==.',Wa='Wardrel:AwAFCAkABAoAAA==.Wastedpriest:AwAICA8ABAoAAA==.',Wi='Wiind:AwAICBYABAoCCQAIAQjuBQA2ziECBAoACQAIAQjuBQA2ziECBAoAAA==.',Xo='Xonz:AwAICBYABAoCCgAIAQhBCAA7XzACBAoACgAIAQhBCAA7XzACBAoAAA==.',Ze='Zenezar:AwACCAIABAoAAA==.',Zi='Zirnbie:AwADCAgABAoAAA==.',Zx='Zxon:AwAICBYABAoCCwAIAQh6CABLZXUCBAoACwAIAQh6CABLZXUCBAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end