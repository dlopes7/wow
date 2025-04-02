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
 local lookup = {'Unknown-Unknown','Druid-Balance','Shaman-Restoration','Hunter-BeastMastery','Warlock-Demonology','Shaman-Elemental','Monk-Brewmaster','Paladin-Retribution','Mage-Frost','DeathKnight-Unholy','Warrior-Protection','Evoker-Devastation',}; local provider = {region='US',realm='Gorefiend',name='US',type='weekly',zone=42,date='2025-03-29',data={Ab='Abracadabra:AwAECAQABAoAAA==.',Am='Amatrake:AwACCAEABRQAAA==.Amyst:AwAECAQABAoAAA==.',An='Anjunabeets:AwABCAEABAoAAA==.',Ao='Ao:AwADCAMABAoAAA==.Aoiria:AwAGCAYABAoAAA==.',Ap='Applebottom:AwADCAMABAoAAA==.Apprehension:AwADCAMABAoAAA==.',Ar='Arcscythe:AwAECAMABAoAAA==.',Az='Azzar:AwAHCBEABAoAAA==.',Ba='Badcataracts:AwADCAYABAoAAA==.',Be='Beartaint:AwADCAMABAoAAA==.',Bi='Bigflex:AwAICBEABAoAAA==.',Bo='Boradora:AwABCAEABAoAAA==.Bosstradamus:AwADCAQABAoAAQEAAAAFCAUABAo=.',Br='Brontag:AwABCAEABAoAAA==.Bruus:AwADCAMABAoAAA==.',Bu='Buns:AwABCAEABRQAAA==.',Ca='Caneki:AwAGCAEABAoAAA==.',Ch='Chaboomy:AwACCAIABRQCAgAIAQi1BwBTVfoCBAoAAgAIAQi1BwBTVfoCBAoAAA==.Cheezypal:AwADCAMABAoAAA==.',Ci='Cindre:AwACCAMABRQCAwAIAQjCBABYJfwCBAoAAwAIAQjCBABYJfwCBAoAAA==.Cingz:AwAICBQABAoCAwAIAQh0EQBDBUICBAoAAwAIAQh0EQBDBUICBAoAAA==.',Co='Cola:AwAFCAUABAoAAA==.Collie:AwAHCBMABAoAAA==.',Cr='Crusadus:AwAICAkABAoAAA==.',Cy='Cypherrellik:AwADCAIABAoAAA==.',Da='Day:AwAICAkABAoAAQQASvIBCAIABRQ=.',De='Deo:AwAGCBIABAoAAA==.Depan:AwACCAIABAoAAQEAAAAFCAwABAo=.',Dr='Drago:AwAECA0ABAoAAA==.',Ea='Easyshift:AwAGCBAABAoAAA==.',Ec='Ecohez:AwADCAUABAoAAA==.',Eg='Eggwhites:AwADCAMABAoAAA==.',Ei='Eielmolate:AwACCAIABRQCBQAIAQhFAQBQxPMCBAoABQAIAQhFAQBQxPMCBAoAAA==.',Es='Esbern:AwABCAEABAoAAA==.',Fa='Falarion:AwAGCA0ABAoAAA==.Falinor:AwAECAIABAoAAA==.',Fi='Fisterdobble:AwAHCBAABAoAAA==.',Fl='Flightrisk:AwADCAMABAoAAA==.',Fo='Forgedd:AwADCAMABAoAAA==.Forgeddemon:AwAHCBMABAoAAA==.Forkinaround:AwAHCA8ABAoAAA==.',Fr='Frostbanshee:AwAGCAMABAoAAA==.',Fu='Furreal:AwACCAIABAoAAA==.',Ga='Galebrew:AwAFCAsABAoAAA==.',Ha='Harold:AwACCAMABRQCBgAIAQg3CwBKAoACBAoABgAIAQg3CwBKAoACBAoAAA==.',Hi='Highjinx:AwADCAMABAoAAA==.',Ho='Holyrollin:AwACCAIABAoAAA==.Howdoihammer:AwADCAMABAoAAQEAAAAGCBAABAo=.Howdoiheal:AwAGCBAABAoAAA==.',Ic='Icy:AwABCAEABAoAAA==.',In='Indademon:AwAGCAUABAoAAA==.',Ja='Jankeys:AwADCAQABAoAAA==.',Je='Jezak:AwABCAEABAoAAQEAAAAECAQABAo=.',Ji='Jimm:AwABCAIABRQCBwAIAQiTBwA0M7UBBAoABwAIAQiTBwA0M7UBBAoAAQEAAAACCAEABRQ=.',Jo='Johnnypizza:AwAHCBQABAoCCAAHAQgkEQBfO+UCBAoACAAHAQgkEQBfO+UCBAoAAA==.',['J�']='Jüdaspriest:AwACCAIABAoAAA==.',Ka='Kalei:AwAICAsABAoAAA==.',Kh='Khandak:AwAHCA4ABAoAAA==.',Ko='Kottonp:AwAECAgABAoAAA==.',Ku='Kurisutina:AwAHCAoABAoAAA==.',Le='Leethalfu:AwACCAIABAoAAA==.Lexxani:AwAICAgABAoAAQEAAAAICAgABAo=.',Ma='Mandioca:AwAECAkABAoAAA==.',Me='Metsutan:AwAHCBIABAoAAA==.',Mo='Moskeebee:AwACCAMABRQCBAAIAQjeCABZFB8DBAoABAAIAQjeCABZFB8DBAoAAA==.',Ne='Neighburz:AwADCAMABAoAAA==.Nekcrotic:AwAHCBMABAoAAA==.Nekromant:AwABCAEABAoAAA==.',Om='Omicron:AwACCAIABAoAAA==.',On='Onfleek:AwAECAkABAoAAA==.',Or='Orakrak:AwAFCAUABAoAAA==.',Pa='Pallom:AwAECAsABAoAAA==.Parra:AwAFCAUABAoAAA==.Pawerful:AwAHCBQABAoCCQAHAQg3BgBdf+ECBAoACQAHAQg3BgBdf+ECBAoAAA==.',Pi='Pillowpants:AwABCAEABRQAAA==.',Po='Porkins:AwAECAQABAoAAA==.',Pr='Prìncesskayy:AwAICAUABAoAAA==.',Pu='Punchykicky:AwADCAMABAoAAA==.',Py='Pyraxx:AwABCAEABRQAAA==.',Ra='Ragdas:AwAGCAkABAoAAA==.Ragfather:AwADCAUABAoAAA==.Raìdèn:AwAECAgABAoAAA==.',Re='Reftie:AwAGCA0ABAoAAA==.Replicate:AwACCAIABAoAAA==.',Ry='Ryri:AwAFCAEABAoAAA==.',Sa='Saveena:AwADCAMABAoAAA==.',Sc='Scottybones:AwABCAEABRQCCgAIAQigFwA2yhMCBAoACgAIAQigFwA2yhMCBAoAAA==.',Sh='Shaduw:AwACCAMABRQCCwAIAQgKAwBMHJcCBAoACwAIAQgKAwBMHJcCBAoAAA==.Shardgen:AwAFCAsABAoAAA==.Shâñk:AwAICAgABAoAAA==.Shåñk:AwAGCA4ABAoAAQEAAAAICAgABAo=.',Sm='Smackriest:AwADCAIABAoAAA==.',Sn='Sneekibreeki:AwADCAMABAoAAA==.',Sp='Spheeri:AwACCAEABAoAAA==.',St='Starella:AwAECAcABAoAAA==.Steamlock:AwAECAMABAoAAA==.',Ta='Tazath:AwAHCBUABAoCDAAHAQhlDwBCeQoCBAoADAAHAQhlDwBCeQoCBAoAAA==.',Th='Thaliria:AwAECAMABAoAAA==.Thicknveiny:AwABCAEABAoAAA==.',Ts='Tsinga:AwAGCAwABAoAAA==.',Un='Unshookable:AwAFCAEABAoAAA==.',Up='Uprooted:AwAECA0ABAoAAA==.',Ut='Uthran:AwADCAQABAoAAQkAXX8HCBQABAo=.',Ve='Vermax:AwAFCAwABAoAAA==.',Vo='Voidlockus:AwAGCAQABAoAAA==.',Vu='Vulcin:AwAFCAcABAoAAQEAAAABCAEABRQ=.',['V�']='Vín:AwABCAEABAoAAA==.',Xy='Xyfin:AwAFCAEABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end