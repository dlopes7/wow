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
 local lookup = {'Priest-Holy','DemonHunter-Havoc','Paladin-Retribution','Warlock-Destruction','Warlock-Affliction','Priest-Shadow','Unknown-Unknown','Druid-Balance','Mage-Fire','Mage-Frost','DeathKnight-Unholy','DeathKnight-Frost','Rogue-Subtlety','Warrior-Protection','Rogue-Outlaw','Evoker-Preservation','Priest-Discipline',}; local provider = {region='US',realm='Dreadmaul',name='US',type='weekly',zone=42,date='2025-03-29',data={Ae='Aedaris:AwAGCBQABAoCAQAGAQiJJwAz3VMBBAoAAQAGAQiJJwAz3VMBBAoAAA==.Ael:AwAECAQABAoAAA==.',Ar='Artzlayer:AwAHCBMABAoAAA==.Aríes:AwAGCBQABAoCAgAGAQgYPwAbMkQBBAoAAgAGAQgYPwAbMkQBBAoAAA==.',Az='Az:AwAECAIABAoAAA==.Aznromeò:AwABCAEABAoAAA==.',Ba='Badtodabow:AwABCAEABAoAAA==.Baeko:AwACCAMABAoAAA==.',Be='Beastic:AwADCAYABRQCAwADAQitBQBeXyUBBRQAAwADAQitBQBeXyUBBRQAAA==.Beastroll:AwAECAUABAoAAA==.',Bi='Bigbubble:AwAFCBAABAoAAA==.Bigdaddylock:AwADCAYABRQDBAADAQgPBABMewQBBRQABAADAQgPBABMewQBBRQABQABAQh2CwA0Ak4ABRQAAA==.',Bl='Blightèye:AwAFCAMABAoAAA==.',Bo='Bombdiggity:AwAECAgABAoAAA==.Bonnierotted:AwADCAQABRQCBgAIAQjnBQBTJO0CBAoABgAIAQjnBQBTJO0CBAoAAA==.',Ce='Cecilz:AwABCAEABAoAAA==.',Cl='Cloneofhunt:AwAGCAwABAoAAA==.',Co='Cos:AwACCAIABAoAAA==.',Da='Datdatafter:AwABCAEABAoAAA==.',De='Deeptouch:AwAFCA0ABAoAAA==.Deloraine:AwACCAQABRQCBgAIAQh9BwBQdM0CBAoABgAIAQh9BwBQdM0CBAoAAA==.Demonicfaith:AwACCAMABAoAAA==.',Di='Dirtyfux:AwAICAgABAoAAA==.Dirtyneedles:AwAGCA0ABAoAAA==.',Do='Doomvedas:AwACCAIABAoAAA==.',Dr='Dracaena:AwAFCAwABAoAAA==.Dreadknìght:AwAHCAcABAoAAA==.Drekavach:AwAFCAcABAoAAA==.',En='Endlessdh:AwABCAEABAoAAA==.',Er='Eraserhead:AwADCAIABAoAAQcAAAAECAMABAo=.Ereshkigal:AwACCAIABAoAAA==.',Ex='Exiled:AwAHCBAABAoAAA==.',Fb='Fbk:AwADCAkABAoAAA==.',Fi='Filthyacts:AwAICAgABAoAAA==.Firstdegree:AwADCAMABAoAAA==.',Ga='Ganin:AwAGCAYABAoAAA==.Garfield:AwAECAQABAoAAQgAQ6EDCAYABRQ=.',Gh='Ghiroza:AwAGCBAABAoAAA==.',Gi='Gingermental:AwAGCBEABAoAAA==.',Gl='Glorpus:AwADCAcABAoAAA==.',Gu='Guayjeng:AwABCAIABAoAAA==.Guldannyboy:AwAFCAoABAoAAA==.',Ha='Habitat:AwADCAQABAoAAA==.Hanokano:AwAFCA8ABAoAAA==.',He='Heartdh:AwAFCAgABAoAAA==.Heartlessa:AwAFCAoABAoAAA==.Hellskeeper:AwAGCA4ABAoAAA==.',Ho='Holytanky:AwAGCAsABAoAAA==.Horizon:AwACCAEABAoAAA==.',Hu='Huntenei:AwAGCAEABAoAAA==.Huntistic:AwAHCAEABAoAAA==.Huskar:AwADCAkABAoAAA==.',In='Infine:AwACCAQABRQDCQAIAQgiCABYSgIDBAoACQAIAQgiCABXAQIDBAoACgAGAQj8GgBOyN8BBAoAAA==.Infyre:AwAGCAsABAoAAA==.',Ja='Jayy:AwAICBkABAoDCwAIAQi6FwA6lhICBAoACwAIAQi6FwA6lhICBAoADAADAQiyIgAILTwABAoAAA==.',Je='Jef:AwAGCA4ABAoAAQ0AUmkDCAkABRQ=.',Jk='Jkdemon:AwAFCA0ABAoAAA==.',Jo='Joelsdruid:AwAFCAQABAoAAA==.',Ju='Jubjub:AwABCAEABAoAAA==.',Ka='Kairon:AwAFCAQABAoAAA==.Katafon:AwADCAoABAoAAA==.',Ki='Kiel:AwAECAQABAoAAA==.',La='Lazer:AwACCAIABAoAAA==.',Ma='Maycé:AwADCAQABAoAAA==.Mazikeen:AwADCAEABAoAAQcAAAADCAQABAo=.',Me='Meownaruk:AwAFCAYABAoAAA==.',Mi='Micn:AwAFCA4ABAoAAA==.',Mo='Morisu:AwADCAMABAoAAA==.Morphio:AwAGCBEABAoAAA==.',My='Mysterio:AwACCAUABAoAAA==.',Ni='Nikola:AwABCAEABRQAAA==.Nimro:AwACCAIABRQCDgAIAQgaBgA5DRACBAoADgAIAQgaBgA5DRACBAoAAA==.Niub:AwABCAEABAoAAA==.',No='Noirebringer:AwAFCA4ABAoAAA==.',Os='Osíris:AwAHCBQABAoCCwAHAQjMDwBNuWYCBAoACwAHAQjMDwBNuWYCBAoAAA==.',Pa='Pakaww:AwAFCAwABAoAAA==.Palliative:AwAECAcABAoAAA==.',Pe='Peterrpanda:AwACCAMABAoAAA==.',Pi='Pisspig:AwACCAIABAoAAA==.',Po='Pom:AwAGCBMABAoAAA==.Popshot:AwAFCAoABAoAAA==.',Py='Pyrusdk:AwAFCA4ABAoAAA==.',Ro='Rondeath:AwACCAIABAoAAQcAAAACCAMABAo=.Ronhunts:AwABCAEABAoAAQcAAAACCAMABAo=.',Ry='Rythcard:AwADCAgABAoAAA==.',['R�']='Rôlayne:AwABCAEABAoAAA==.',Sa='Saaria:AwABCAEABAoAAA==.Salvare:AwAICBQABAoCDwAIAQi9AgA0BCsCBAoADwAIAQi9AgA0BCsCBAoAAA==.',Se='Sedge:AwADCAkABRQCDQADAQjNAgBSaSUBBRQADQADAQjNAgBSaSUBBRQAAA==.',Sh='Shocksy:AwADCAkABAoAAA==.',Si='Sicckbrew:AwAICBMABAoAAA==.',Sk='Skizzyy:AwAHCAsABAoAAA==.',Sn='Sneakyfella:AwABCAEABAoAAA==.Sneakyskele:AwADCAQABAoAAA==.',Sq='Squiish:AwADCAYABRQCCAADAQh/BgBDoQEBBRQACAADAQh/BgBDoQEBBRQAAA==.',St='Starwraith:AwACCAIABAoAAQcAAAABCAEABRQ=.Stickypriest:AwAGCBQABAoDBgAGAQixHQAtjnUBBAoABgAGAQixHQAtjnUBBAoAAQAFAQidLgA6iyQBBAoAAA==.Stinkyh:AwAGCAYABAoAAA==.Streamliner:AwAFCA0ABAoAAA==.Stunks:AwAGCBIABAoAAA==.',Su='Sustangelia:AwAFCA0ABAoAAA==.',Ta='Taintstank:AwAICAwABAoAAA==.Talletalanot:AwABCAIABRQCEAAGAQhxCABD9tYBBAoAEAAGAQhxCABD9tYBBAoAAA==.Tauladin:AwAFCAQABAoAAA==.',Te='Terrafirm:AwABCAEABAoAAA==.',Tr='Troubleleg:AwABCAEABRQAAA==.',Tu='Tuzz:AwAGCA0ABAoAAA==.',Va='Vallyssa:AwACCAIABAoAAA==.Varg:AwADCAMABAoAAA==.',['V�']='Vëë:AwAFCAgABAoAAA==.',Wi='Widdy:AwADCAUABAoAAQcAAAAICAgABAo=.',Wo='Wozzie:AwACCAIABAoAAA==.',Wy='Wyvern:AwAECAkABAoAAA==.',Xe='Xedd:AwACCAYABRQCEQACAQh4BwA/vZ0ABRQAEQACAQh4BwA/vZ0ABRQAAA==.',Xi='Xieer:AwADCAMABAoAAA==.',Ya='Yahmmit:AwABCAEABAoAAA==.Yaminosaishi:AwAFCA4ABAoAAA==.Yazdorzarn:AwABCAEABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end