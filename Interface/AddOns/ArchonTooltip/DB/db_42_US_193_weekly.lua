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
 local lookup = {'Unknown-Unknown','Hunter-BeastMastery','Monk-Mistweaver','Warrior-Protection','Paladin-Holy','Paladin-Retribution','Mage-Frost','Priest-Discipline','Shaman-Enhancement','Druid-Restoration','Druid-Feral','Druid-Balance','DeathKnight-Unholy','Rogue-Subtlety','Rogue-Assassination','Paladin-Protection','Warlock-Destruction','Shaman-Elemental','Mage-Fire','Warlock-Affliction',}; local provider = {region='US',realm='ShatteredHand',name='US',type='weekly',zone=42,date='2025-03-28',data={Ab='Absorption:AwAGCAYABAoAAQEAAAABCAEABRQ=.',Ah='Ahroo:AwAECAcABAoAAQEAAAAGCAsABAo=.Ahrue:AwAGCAsABAoAAA==.',Ai='Airc:AwADCAUABAoAAA==.',An='Antu:AwADCAMABAoAAA==.',At='Atomicrednax:AwAECAcABRQCAgAEAQhtAgBGH2kBBRQAAgAEAQhtAgBGH2kBBRQAAA==.',Ba='Ballsofury:AwAHCA4ABAoAAA==.Baptism:AwADCAMABAoAAA==.Battousaiha:AwADCAgABAoAAA==.',Bi='Bigsmokeyy:AwAFCAgABAoAAA==.',Bu='Burlapt:AwADCAQABRQCAwAIAQgmBABXRQ0DBAoAAwAIAQgmBABXRQ0DBAoAAA==.Burney:AwAFCA0ABAoAAA==.',['B�']='Bònesaw:AwAHCBUABAoCBAAHAQhjBgA/JPoBBAoABAAHAQhjBgA/JPoBBAoAAA==.',Ca='Carll:AwABCAEABRQCBQAHAQhcDQA46NUBBAoABQAHAQhcDQA46NUBBAoAAA==.Cathartic:AwAGCA4ABAoAAA==.',Ch='Chamah:AwADCAMABAoAAA==.Chilin:AwACCAIABAoAAA==.',Da='Darig:AwAFCAoABAoAAA==.',De='Decimez:AwADCAgABAoAAA==.Decimock:AwADCAMABAoAAA==.Dellandra:AwAFCAcABAoAAA==.Devoidmon:AwAECAUABAoAAA==.',Di='Dipz:AwAHCA4ABAoAAA==.',Dr='Drandy:AwAFCAoABAoAAA==.Drchow:AwAFCAsABAoAAA==.',['D�']='Dáin:AwADCAMABAoAAA==.',Ei='Eianija:AwAECAoABAoAAA==.',El='Elice:AwABCAEABAoAAA==.Elixir:AwAICAgABAoAAA==.',Ep='Epinephrine:AwAHCBUABAoCBgAHAQheEgBdwtMCBAoABgAHAQheEgBdwtMCBAoAAA==.',Es='Escorpiøn:AwAGCAMABAoAAA==.',Fa='Falkor:AwAECAcABAoAAA==.Fartinhaler:AwADCAUABAoAAQIARh8ECAcABRQ=.Farven:AwAFCAwABAoAAQYAYtkDCAcABRQ=.',Fi='Firecall:AwADCAMABAoAAA==.Fireflight:AwABCAEABAoAAQEAAAADCAMABAo=.Firekill:AwACCAIABAoAAQEAAAADCAMABAo=.',Fo='Foops:AwADCAcABRQCBwADAQgUAQAxkPEABRQABwADAQgUAQAxkPEABRQAAA==.Foopsadin:AwAFCAoABAoAAQcAMZADCAcABRQ=.',Fu='Futured:AwADCAMABAoAAA==.',Ge='Genosaur:AwAECAMABAoAAA==.',Gi='Giing:AwAECAkABRQCBgAEAQhIAABh4MUBBRQABgAEAQhIAABh4MUBBRQAAA==.Gimermonty:AwAHCBUABAoCAgAHAQgqOwApHZ8BBAoAAgAHAQgqOwApHZ8BBAoAAA==.Ging:AwAFCAoABAoAAQYAYeAECAkABRQ=.Ginza:AwAECAoABRQCCAAEAQiqAQAtIEYBBRQACAAEAQiqAQAtIEYBBRQAAA==.',Gr='Gregiously:AwADCAUABRQCCQADAQixBAAedeIABRQACQADAQixBAAedeIABRQAAA==.Gronk:AwABCAEABAoAAA==.',Ha='Halvor:AwACCAQABAoAAA==.',Hu='Hukdemon:AwADCAgABAoAAA==.',Il='Illidaner:AwABCAEABAoAAA==.',Je='Jeda:AwAECAcABAoAAA==.',Jh='Jhamin:AwAECAcABAoAAA==.',Jo='Joltasaurus:AwAECAQABAoAAA==.',Ka='Kai:AwAECAcABAoAAA==.',Ki='Kisma:AwAECAoABRQCCgAEAQiIAABOVngBBRQACgAEAQiIAABOVngBBRQAAA==.',Kl='Klickyy:AwABCAEABRQAAQYAYtkDCAcABRQ=.Kliiden:AwADCAQABAoAAQYAYtkDCAcABRQ=.Kllcky:AwADCAcABRQCBgADAQiQAgBi2VYBBRQABgADAQiQAgBi2VYBBRQAAA==.',Kv='Kvothè:AwAFCBEABAoAAA==.',Ky='Kyi:AwAHCA4ABAoAAA==.',['K�']='Kîrîto:AwACCAIABAoAAA==.',La='Lammh:AwACCAIABAoAAA==.Landar:AwABCAEABRQCCgAHAQgBFQAzOr0BBAoACgAHAQgBFQAzOr0BBAoAAA==.',Ma='Machine:AwACCAQABRQECgAIAQgZDABCCDQCBAoACgAIAQgZDABCCDQCBAoACwAEAQidDQA9lzIBBAoADAABAQiEaAAu3jkABAoAAA==.Mahk:AwACCAIABAoAAA==.Mahra:AwAECAcABAoAAA==.',Me='Meekseek:AwABCAEABRQAAA==.',Mi='Mixmasterg:AwAFCAgABAoAAA==.',Mo='Mograinez:AwAECAoABRQCDQAEAQgoAABhGsoBBRQADQAEAQgoAABhGsoBBRQAAA==.',Na='Namthor:AwAFCAkABAoAAA==.',Ol='Oldshotz:AwAECAkABAoAAA==.',On='Onapalehorse:AwADCAEABAoAAA==.',Pa='Panzerwolf:AwAECAoABRQCBAAEAQgMAQAcW+wABRQABAAEAQgMAQAcW+wABRQAAA==.Panzwulf:AwAFCAoABAoAAQQAHFsECAoABRQ=.',Pe='Peepaw:AwAECAwABRQCAwAEAQhXAgAzJkcBBRQAAwAEAQhXAgAzJkcBBRQAAA==.',Po='Pondus:AwABCAIABRQDDgAIAQiyBgBMCq4CBAoADgAIAQiyBgBMCq4CBAoADwABAQj3KQAeNkIABAoAAA==.',Qu='Quigong:AwACCAMABAoAAA==.',Ra='Rakkasei:AwAHCBAABAoAAA==.Randark:AwAGCA8ABAoAAA==.Razkal:AwAICBIABAoAAA==.',Ri='Rizzu:AwAFCAUABAoAAQEAAAAICBIABAo=.',Ru='Ruwa:AwAECAcABAoAAA==.',Sa='Samitsu:AwABCAEABAoAAA==.',Sc='Screwtåpe:AwAHCAcABAoAAA==.',Se='Serenity:AwAECAIABAoAAA==.Seseria:AwAHCBUABAoCEAAHAQgaDwAyBJwBBAoAEAAHAQgaDwAyBJwBBAoAAA==.Seshin:AwAHCBUABAoCEQAHAQheEwBLBkwCBAoAEQAHAQheEwBLBkwCBAoAAA==.',Sh='Shaithis:AwADCAQABAoAAA==.Shanic:AwADCAgABAoAAA==.Sheilarokwen:AwAFCAMABAoAAA==.Shiftor:AwACCAIABAoAAA==.',Sl='Slavka:AwABCAMABRQCEgAIAQjACwBHuGsCBAoAEgAIAQjACwBHuGsCBAoAAA==.',Sn='Snipyterror:AwAICAgABAoAAA==.Snoodly:AwADCAgABAoAAA==.',Sp='Spirallidan:AwAHCBIABAoAAA==.',St='Stinksauce:AwAFCAYABAoAAA==.Stormstrike:AwAFCAoABAoAARMAOqYECAgABRQ=.Stuffinhole:AwADCAQABAoAAA==.',Su='Superchunk:AwADCAIABAoAAA==.',Ta='Tasahof:AwABCAIABRQCFAAHAQgvAwBHdTwCBAoAFAAHAQgvAwBHdTwCBAoAAA==.',Ti='Timeout:AwACCAIABAoAARQAR3UBCAIABRQ=.',To='Tone:AwABCAIABRQAAA==.Totemlycool:AwABCAEABRQAAA==.',Ts='Tsayid:AwADCAcABAoAAA==.',Ty='Tyrith:AwADCAYABAoAAA==.',['T�']='Töömis:AwADCAcABAoAAA==.',Ug='Ugotgotpal:AwADCAUABAoAAA==.',Un='Unease:AwADCAMABAoAAA==.',Uv='Uvokevoke:AwADCAYABAoAAA==.',Va='Vaas:AwADCAMABAoAAA==.',Vi='Visenthra:AwAECAcABAoAAA==.Viì:AwAECAcABAoAAA==.',Wa='Waronyou:AwADCAcABAoAAA==.',Xe='Xenophanes:AwACCAIABAoAAA==.',Xp='Xplosivslunt:AwAECAkABAoAAA==.',Ze='Zen:AwAFCAgABAoAAA==.Zephyrpriest:AwACCAIABAoAARMAOqYECAgABRQ=.',Zu='Zugmaster:AwAICBcABAoCDwAIAQjMBQBL1JUCBAoADwAIAQjMBQBL1JUCBAoAAA==.',Zz='Zzephyrmage:AwAECAgABRQCEwAEAQjfAgA6pmMBBRQAEwAEAQjfAgA6pmMBBRQAAA==.',['Â']='Âsunâ:AwACCAIABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end