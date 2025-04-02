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
 local lookup = {'Paladin-Protection','DemonHunter-Vengeance','Druid-Balance','Paladin-Retribution','Druid-Restoration','Monk-Windwalker','Unknown-Unknown','Mage-Arcane','Mage-Fire','Mage-Frost','DeathKnight-Frost','Shaman-Elemental','Hunter-BeastMastery',}; local provider = {region='US',realm='Hakkar',name='US',type='weekly',zone=42,date='2025-03-29',data={Ae='Aeronier:AwAFCAgABAoAAA==.',Ai='Aia:AwADCAQABAoAAA==.',Al='Alcahawlick:AwAFCAkABAoAAA==.Alexious:AwAGCBQABAoCAQAGAQgFBgBd+n0CBAoAAQAGAQgFBgBd+n0CBAoAAA==.Alexstar:AwADCAMABAoAAA==.',An='Animalhowse:AwAECAoABAoAAA==.',Az='Azaria:AwADCAMABAoAAA==.',Ba='Bahalana:AwAFCAIABAoAAA==.Bast:AwABCAEABRQCAgAHAQikCABJ5D8CBAoAAgAHAQikCABJ5D8CBAoAAA==.Bayn:AwADCAEABAoAAA==.',Be='Bealzebob:AwADCAIABAoAAA==.',Bi='Bigbeardaddy:AwAHCBQABAoCAwAHAQghJgAwkbEBBAoAAwAHAQghJgAwkbEBBAoAAA==.',Bl='Bloodhusk:AwAFCAwABAoAAA==.',Bo='Bonepalace:AwABCAEABAoAAA==.Boogiebobby:AwAICAoABAoAAA==.',Br='Brixlo:AwAGCAEABAoAAA==.',Ca='Cambrier:AwAGCAcABAoAAA==.',Ch='Chad:AwABCAIABRQDBAAHAQh5SwAuRr4BBAoABAAHAQh5SwAuRr4BBAoAAQADAQi6NgAGokMABAoAAA==.Charmaldin:AwACCAIABAoAAA==.Chatnoir:AwAFCAwABAoAAA==.',Ci='Cipherdam:AwACCAIABAoAAA==.',Co='Collamus:AwAFCAEABAoAAA==.Corklaw:AwABCAIABRQAAA==.',Cp='Cptdangles:AwADCAMABAoAAA==.',Ct='Ctrly:AwABCAEABRQAAA==.',Da='Dabjack:AwAFCAwABAoAAA==.Darkayls:AwABCAEABAoAAA==.Darkivie:AwABCAEABAoAAA==.Darknass:AwAFCAgABAoAAA==.Davoker:AwADCAMABAoAAA==.',De='Devildj:AwACCAQABAoAAA==.Devllmaycry:AwACCAIABAoAAA==.',Do='Dordim:AwADCAQABAoAAA==.Dorwin:AwAGCAUABAoAAA==.Dotdotloot:AwAICAgABAoAAA==.Doz:AwAGCAwABAoAAA==.',Dr='Druken:AwAICAEABAoCBQABAQhNUQBDFEgABAoABQABAQhNUQBDFEgABAoAAA==.',Du='Dustdruid:AwAICBoABAoCAwAIAQiPDwBKbZACBAoAAwAIAQiPDwBKbZACBAoAAA==.',Eg='Egilironwolf:AwAICA8ABAoAAA==.',Em='Emillie:AwACCAEABAoAAA==.',Fi='Fistymisty:AwADCAcABAoAAA==.',Fr='Frozenlizzy:AwABCAEABRQAAA==.',Ge='Gemelli:AwAFCAgABAoAAA==.Gerodd:AwAGCAEABAoAAA==.Gerogero:AwABCAEABAoAAA==.',Gr='Grullander:AwAFCAwABAoAAA==.',Gu='Guiguiie:AwABCAEABAoAAA==.',He='Helane:AwADCAMABAoAAA==.Hettrak:AwACCAUABRQCBgACAQj7BQA+mKkABRQABgACAQj7BQA+mKkABRQAAA==.',Ic='Icuriozity:AwADCAMABAoAAA==.',Id='Idkwtfid:AwAFCAQABAoAAA==.',Ji='Jinwoo:AwACCAIABAoAAA==.',Ka='Katelynn:AwAFCAsABAoAAA==.Katrina:AwADCAQABAoAAA==.',Km='Kmarti:AwADCAYABAoAAA==.',Kr='Kriona:AwAECA0ABAoAAA==.',Le='Leasin:AwAECAMABAoAAA==.Legorocky:AwACCAcABAoAAQcAAAADCAEABAo=.',Li='Lilminh:AwABCAEABAoAAA==.Lizzyvoker:AwAFCAgABAoAAA==.',Ly='Lyio:AwAGCAEABAoAAA==.',Ma='Malaias:AwACCAMABRQECAAIAQgRAQBafp0CBAoACQAIAQj+CwBZVdQCBAoACAAHAQgRAQBZxJ0CBAoACgACAQhsVQBVBowABAoAAA==.Marlowe:AwAFCA4ABAoAAA==.',Mi='Mirukoo:AwAICAgABAoAAA==.',Mo='Mofopriest:AwAICAcABAoAAA==.Monkyqueene:AwAECAQABAoAAA==.',My='Mystiicmoo:AwABCAEABRQAAA==.',Na='Nahtan:AwADCAgABAoAAA==.Natefrost:AwAECAgABAoAAA==.',No='Noktis:AwAFCA4ABAoAAA==.Noobtoober:AwABCAIABRQCCwAIAQh9AwBG2aQCBAoACwAIAQh9AwBG2aQCBAoAAA==.',Np='Npmonk:AwACCAIABAoAAA==.',['N�']='Näm:AwACCAEABAoAAA==.',Oe='Oek:AwACCAIABAoAAA==.',Og='Ogpally:AwABCAEABAoAAA==.',Pa='Pakkohruun:AwAFCAUABAoAAA==.',Pc='Pcm:AwACCAEABAoAAA==.',Pe='Percheron:AwABCAEABAoAAA==.',Pi='Piyo:AwABCAEABRQAAA==.',Pl='Plowpatine:AwADCAEABAoAAA==.',Po='Poolius:AwACCAEABAoAAA==.',Pr='Pridemoore:AwABCAEABAoAAA==.',Ra='Raianx:AwAICAgABAoAAA==.Raptorizer:AwAGCAEABAoAAA==.',Re='Reversi:AwAGCA8ABAoAAA==.',Ri='Rivër:AwACCAQABAoAAA==.',Sa='Saintmerg:AwAICBAABAoAAA==.Sathenset:AwAGCA4ABAoAAA==.',Se='Seitrune:AwADCAMABAoAAA==.Sepulchrè:AwADCAMABAoAAA==.Sevdh:AwAECAcABAoAAA==.',Sh='Shamrocc:AwADCAEABAoAAA==.Shoeless:AwAICBAABAoAAA==.',Si='Silentstrike:AwAHCAoABAoAAA==.',Sk='Skädoosh:AwAFCAYABAoAAA==.',So='Souledmysoul:AwAECAQABAoAAA==.',St='Steppenhoof:AwAICBAABAoAAA==.Stormroid:AwAGCAMABAoAAA==.',Su='Sullii:AwAFCAwABAoAAA==.Sunmx:AwAGCAYABAoAAA==.Surewould:AwAGCA8ABAoAAA==.',Sw='Swurves:AwADCAEABAoAAA==.',Sy='Sylvaina:AwADCAYABAoAAA==.',Ta='Talonstryke:AwABCAEABAoAAA==.',Ti='Titø:AwAICAgABAoAAA==.',To='Totemika:AwADCAQABRQCDAAIAQiIBgBSvdkCBAoADAAIAQiIBgBSvdkCBAoAAA==.Tourmalynne:AwAFCAQABAoAAA==.',Tr='Tristanias:AwAICBAABAoAAA==.',Tv='Tvak:AwACCAQABAoAAA==.',Va='Vandersus:AwADCAcABAoAAA==.',Ve='Vergill:AwAECAgABAoAAA==.',Wa='Waidmanns:AwABCAEABRQCDQAHAQjCIwBAODsCBAoADQAHAQjCIwBAODsCBAoAAA==.',Wh='Wheramii:AwAICA4ABAoAAA==.',Wi='Windrocky:AwABCAEABAoAAQcAAAADCAEABAo=.',Wr='Wrongname:AwABCAEABAoAAA==.',Yo='Yogsothoth:AwEBCAEABRQCDQAIAQhqGQBD24sCBAoADQAIAQhqGQBD24sCBAoAAA==.',Za='Zataladin:AwABCAEABRQAAA==.Zatara:AwAECAQABAoAAQcAAAABCAEABRQ=.',Ze='Zedadin:AwAECAQABAoAAA==.Zermu:AwADCAMABAoAAA==.Zerofoxgiven:AwABCAEABAoAAA==.',Zy='Zynthera:AwAHCAQABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end