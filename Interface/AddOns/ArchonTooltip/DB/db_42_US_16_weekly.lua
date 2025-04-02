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
 local lookup = {'Hunter-BeastMastery','Paladin-Retribution','Mage-Fire','Mage-Frost','Warlock-Destruction','Priest-Holy','Unknown-Unknown','Rogue-Assassination','Warlock-Affliction','Shaman-Elemental','Shaman-Restoration','Mage-Arcane',}; local provider = {region='US',realm='Arathor',name='US',type='weekly',zone=42,date='2025-03-29',data={Ab='Absoul:AwABCAIABAoAAA==.',Ad='Adellas:AwABCAEABRQAAA==.Adern:AwEBCAEABRQAAA==.',Ae='Aelali:AwAECAEABAoAAA==.',Al='Alavara:AwAGCBMABAoAAA==.',Am='Amets:AwAFCAEABAoAAA==.',An='Anamii:AwABCAEABAoAAA==.Ansuz:AwABCAMABAoAAA==.Anungunrama:AwAFCAEABAoAAA==.',Ar='Arachne:AwADCAMABAoAAA==.Aryya:AwACCAMABRQAAA==.',At='Athelia:AwAHCBIABAoAAA==.',Av='Avashammy:AwABCAEABRQAAA==.Aviendah:AwADCAEABAoAAA==.',Az='Azdfghop:AwABCAEABRQCAQAIAQirGgBHKIECBAoAAQAIAQirGgBHKIECBAoAAA==.',Ba='Babezila:AwAFCAEABAoAAA==.',Bl='Blaaze:AwAGCA8ABAoAAA==.Blaiddyd:AwAFCA4ABAoAAA==.',Br='Brain:AwAECAgABRQCAgAEAQjVAABb3pYBBRQAAgAEAQjVAABb3pYBBRQAAA==.Brainx:AwADCAMABAoAAA==.Brofesor:AwAGCA0ABAoAAA==.',Ca='Caladora:AwAECAEABAoAAA==.',Ce='Ceptor:AwAGCBgABAoDAwAGAQgLMAA58YgBBAoAAwAGAQgLMAA3IIgBBAoABAAEAQjaQwAzjtUABAoAAA==.',Ch='Chaotika:AwAGCBQABAoCBQAGAQiSLAA+BI0BBAoABQAGAQiSLAA+BI0BBAoAAA==.',Ci='Civilian:AwAECAUABAoAAA==.',Co='Cordran:AwAFCAEABAoAAA==.',Cr='Crizmon:AwAGCA8ABAoAAA==.',Da='Darkndeadly:AwAGCBMABAoAAA==.Darl:AwADCAMABAoAAA==.',De='Decimate:AwADCAYABAoAAA==.Delin:AwAFCAkABAoAAA==.Derpspunch:AwAFCAkABAoAAA==.',Di='Dieselcon:AwAECAIABAoAAA==.',Do='Dookiesmash:AwAGCAYABAoAAA==.Dovathuil:AwADCAMABAoAAA==.',Dr='Drakarenata:AwAGCAkABAoAAA==.',Er='Erata:AwACCAUABAoAAA==.',Es='Esdëath:AwAFCAEABAoAAA==.',Fa='Falerin:AwAECAUABAoAAA==.',Ge='Gerry:AwAFCAIABAoAAA==.',Gl='Glory:AwAGCAMABAoAAA==.',Gr='Gravedygger:AwAFCA0ABAoAAA==.Grimmkin:AwABCAEABAoAAA==.',Ha='Handivhe:AwABCAEABRQAAA==.Hasew:AwAGCAsABAoAAA==.',He='Heyner:AwADCAEABAoAAA==.',Ho='Holyluz:AwACCAQABAoAAA==.',Hu='Hunthor:AwAICAEABAoAAA==.',In='Inoshikacho:AwAFCAEABAoAAA==.Invý:AwAGCA8ABAoAAA==.',Jo='Johali:AwAICBAABAoAAA==.',['J�']='Jöhnblaze:AwABCAEABRQAAA==.',Ka='Kahoona:AwAFCA4ABAoAAA==.Kankuró:AwAGCA8ABAoAAA==.Katøøt:AwACCAUABAoAAA==.',Kr='Kristie:AwACCAMABAoAAA==.',Ky='Kyle:AwAICAsABAoAAA==.',La='Lairia:AwAGCAYABAoAAA==.Lawwdog:AwADCAQABAoAAA==.',Le='Legõlas:AwACCAIABAoAAA==.Leonora:AwAFCAoABAoAAA==.',Lo='Lorette:AwABCAEABRQAAA==.',Lu='Luckynyx:AwABCAEABAoAAA==.',Ly='Lymriina:AwAECAYABAoAAA==.',Ma='Machotedan:AwAFCAEABAoAAA==.',Me='Merchuntz:AwAECAUABAoAAA==.Meta:AwAGCA8ABAoAAA==.Metaphysis:AwADCAEABAoAAA==.',Mi='Milkmetender:AwACCAIABAoAAA==.Missteak:AwABCAIABAoAAA==.Missî:AwAGCA8ABAoAAA==.Mistaya:AwACCAQABAoAAA==.Mistglides:AwACCAMABRQAAA==.',Mo='Momjeans:AwAICA0ABAoCAwAFAQiyPgAp7iMBBAoAAwAFAQiyPgAp7iMBBAoAAA==.',['M�']='Mäylä:AwAFCA0ABAoAAA==.Míst:AwAGCAIABAoAAA==.',Ne='Nephie:AwABCAEABRQAAA==.',Ob='Obin:AwAECAkABAoAAA==.Oblivion:AwADCAMABAoAAA==.',On='Onomonopia:AwADCAMABAoAAA==.',Pa='Pandress:AwADCAYABAoAAA==.Panterra:AwACCAQABAoAAA==.',Pi='Pitipanda:AwADCAMABAoAAA==.',Po='Polymerase:AwAECAEABAoAAA==.',Pr='Protròast:AwACCAIABAoAAA==.',Ps='Psypriest:AwADCAYABAoAAQYAPjQCCAQABRQ=.',Ra='Rabbi:AwADCAEABAoAAA==.Rarepets:AwAGCBIABAoAAA==.Rayyvn:AwAGCBgABAoCBAAGAQg5JgA5poIBBAoABAAGAQg5JgA5poIBBAoAAA==.',Re='Rethrius:AwAGCBgABAoCAgAGAQj9YwAqdGoBBAoAAgAGAQj9YwAqdGoBBAoAAA==.Revpally:AwABCAEABRQAAA==.Reàper:AwABCAEABRQCBQAGAQjpNQAn91EBBAoABQAGAQjpNQAn91EBBAoAAA==.',Ri='Riverarose:AwACCAIABAoAAA==.',Sa='Salina:AwEDCAMABAoAAQcAAAAFCAwABAo=.Sandstique:AwAGCBAABAoAAA==.Sarlak:AwAGCAYABAoAAA==.Sarusuby:AwABCAEABRQAAA==.Satae:AwAFCAEABAoAAA==.',Sc='Scottypal:AwABCAEABRQAAA==.',Sh='Shadaddie:AwAFCAEABAoAAA==.Shroomgirl:AwAGCBgABAoCAQAGAQi4VwAjCzABBAoAAQAGAQi4VwAjCzABBAoAAA==.',Sl='Slipper:AwAFCBEABAoAAA==.Slipperyboi:AwACCAUABRQCCAACAQhQBAAl2JkABRQACAACAQhQBAAl2JkABRQAAA==.',Sp='Spookmeister:AwACCAQABRQDBQAIAQixJAAmUsQBBAoABQAIAQixJAAlf8QBBAoACQACAQg9HwAfNXAABAoAAA==.',Su='Supèrsonicc:AwAECAIABAoAAA==.',Ta='Tankbae:AwADCAEABAoAAA==.',Te='Tenacious:AwAFCAsABAoAAA==.',Th='Themyscira:AwAGCBgABAoCAQAGAQgbIQBaRU8CBAoAAQAGAQgbIQBaRU8CBAoAAA==.Thrappy:AwAGCA8ABAoAAA==.',Ti='Tigera:AwABCAEABAoAAA==.Tirtun:AwABCAEABRQAAA==.',To='Tomek:AwADCAcABAoAAA==.',Ts='Tsarran:AwAFCA0ABAoAAA==.',Tw='Twelvekill:AwAGCBgABAoCAQAGAQjFTwAsxE0BBAoAAQAGAQjFTwAsxE0BBAoAAA==.',Ty='Tyliaa:AwAFCAIABAoAAA==.',Ur='Uranious:AwAGCAkABAoAAQcAAAABCAEABRQ=.Urgoochness:AwADCAMABAoAAA==.',Va='Vapecloud:AwABCAEABAoAAQcAAAAECAcABAo=.',Vi='Vixxon:AwABCAEABAoAAA==.',['V�']='Vìolet:AwACCAUABAoAAQcAAAAFCA0ABAo=.',We='Werkajerk:AwACCAIABAoAAQoAWhABCAIABRQ=.Werkjathal:AwABCAIABRQDCgAIAQgpBwBaEM0CBAoACgAHAQgpBwBc280CBAoACwABAQhzdAAnK0AABAoAAA==.',Wh='Whereareyou:AwAFCAkABAoAAA==.',Wo='Worldbane:AwADCAcABAoAAA==.',Xa='Xalatath:AwAFCAEABAoAAA==.',Xi='Xianyu:AwACCAUABAoAAA==.Ximmer:AwAHCBwABAoCDAAHAQiNAABd9PUCBAoADAAHAQiNAABd9PUCBAoAAA==.',Yu='Yumi:AwADCAMABAoAAA==.',Zy='Zylaeri:AwAGCAYABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end