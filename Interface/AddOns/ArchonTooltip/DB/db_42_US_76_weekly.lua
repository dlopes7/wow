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
 local lookup = {'Paladin-Protection','Paladin-Retribution','Paladin-Holy','Warrior-Fury','Unknown-Unknown','Shaman-Restoration','Shaman-Elemental','Monk-Mistweaver','Warrior-Protection','Warrior-Arms','Mage-Frost','Warlock-Demonology','Warlock-Destruction','Shaman-Enhancement',}; local provider = {region='US',realm='Draka',name='US',type='weekly',zone=42,date='2025-03-29',data={Ab='Aberaht:AwAGCBEABAoAAA==.',Al='Alestria:AwACCAEABAoAAA==.',Ar='Arthoss:AwAGCBEABAoAAA==.',As='Asheosh:AwAECAkABAoAAA==.',At='Athenä:AwACCAIABRQCAQAHAQjeDwAwxJoBBAoAAQAHAQjeDwAwxJoBBAoAAA==.',Ax='Axodar:AwACCAUABAoAAA==.',Ay='Ayle:AwADCAUABAoAAA==.',Ba='Batiatös:AwABCAEABAoAAA==.',Be='Benjinana:AwABCAEABAoAAA==.',Bk='Bkunstopabl:AwAGCAYABAoAAA==.',Bl='Bluespark:AwAGCBMABAoAAA==.',Bo='Boogiebrew:AwAGCA0ABAoAAA==.',Ca='Cakyn:AwAGCAIABAoAAA==.',Ce='Cereel:AwAFCA8ABAoAAA==.',Cl='Clampz:AwAHCBsABAoDAgAHAQhlGwBc0JsCBAoAAgAGAQhlGwBjIpsCBAoAAwAGAQjXDQBC2dYBBAoAAA==.',Co='Combobreaker:AwAFCAEABAoAAA==.Cowbõy:AwAGCAIABAoAAA==.',['C�']='Cüpid:AwAICBAABAoAAA==.',Da='Darthsix:AwAECAIABAoAAA==.Dasharnkal:AwAECAYABAoAAA==.',De='Dergigg:AwAGCBMABAoAAA==.',Di='Digifoxx:AwABCAEABAoAAA==.Disowneege:AwAECAgABAoAAQQAWgkCCAIABRQ=.',Dr='Drcornbread:AwABCAEABAoAAA==.Drcornellia:AwABCAEABAoAAQUAAAABCAEABAo=.Drprominus:AwAFCA4ABAoAAA==.',Du='Dubstepsanta:AwAECAgABAoAAA==.',El='Ellimist:AwECCAIABRQDBgAHAQj/DABUZnkCBAoABgAHAQj/DABUZnkCBAoABwACAQiIRQAjr2UABAoAAA==.Elí:AwAECAcABAoAAA==.',Er='Erazar:AwAECAkABAoAAA==.',Es='Essense:AwAGCBEABAoAAA==.',Fa='Faydien:AwADCAMABAoAAA==.',Fi='Fillthy:AwACCAIABRQCCAAIAQhiCgBI8p0CBAoACAAIAQhiCgBI8p0CBAoAAA==.Fizban:AwADCAUABAoAAA==.',Ge='Gelankh:AwAHCAoABAoAAA==.Gelen:AwABCAEABAoAAQUAAAAHCAoABAo=.Gerlinde:AwABCAEABAoAAA==.',Gf='Gfr:AwACCAEABAoAAA==.',Go='Goatylocks:AwABCAEABAoAAA==.',Gr='Gramma:AwAGCBEABAoAAA==.Grunngie:AwADCAcABAoAAA==.',Gu='Guilds:AwABCAEABRQAAA==.',['G�']='Gíga:AwAECAoABAoAAA==.',Ha='Hanhaine:AwACCAIABAoAAA==.',Hi='Hitt:AwACCAIABAoAAA==.',Ho='Holyshawk:AwACCAQABAoAAA==.Holywon:AwAFCAwABAoAAA==.',Hr='Hroc:AwAECAYABAoAAA==.',Ih='Ihatepriest:AwACCAIABAoAAA==.',Il='Illie:AwAGCBAABAoAAA==.',In='Intoodeeper:AwAGCBMABAoAAA==.',Io='Ionzz:AwAFCAgABAoAAA==.',Ir='Iroann:AwAGCAQABAoAAA==.',Is='Isawarriorr:AwAFCAoABAoAAA==.',Je='Jet:AwAGCA8ABAoAAA==.',Ka='Kagebushin:AwAFCAoABAoAAA==.Kalinnora:AwAECAcABAoAAA==.Karynos:AwAGCBEABAoAAA==.',Ke='Kejin:AwADCAcABAoAAA==.',Kl='Kleavor:AwAGCAsABAoAAA==.',Kr='Kryv:AwAECAIABAoAAA==.',La='Lafiel:AwAGCBEABAoAAA==.Lau:AwAECAEABAoAAA==.',Lu='Luckykilla:AwAECAIABAoAAA==.Luxtyrannica:AwAFCA0ABAoAAA==.',Ma='Malshot:AwAFCAQABAoAAA==.',Mc='Mcchi:AwABCAEABAoAAA==.',Me='Medion:AwAGCBEABAoAAA==.Meristem:AwAFCA0ABAoAAA==.',Mo='Moegu:AwAECAUABAoAAA==.Mondgrille:AwADCAMABAoAAA==.Moonlights:AwADCAMABAoAAA==.Morrold:AwABCAEABAoAAA==.Moxxzi:AwACCAIABAoAAA==.',Na='Navaljuices:AwAECA0ABAoAAA==.',Ne='Neifeb:AwAECAIABAoAAA==.',Ni='Nights:AwACCAQABRQCCQAIAQjpAQBQFuICBAoACQAIAQjpAQBQFuICBAoAAA==.Ninh:AwAGCBMABAoAAA==.',No='Nomlok:AwABCAEABAoAAA==.',Ny='Nyyia:AwAGCAwABAoAAA==.',Om='Ommaar:AwAFCAsABAoAAA==.',On='Ontop:AwAGCBMABAoAAA==.',Ow='Owneege:AwACCAIABRQDBAAHAQiwDABaCZ8CBAoABAAHAQiwDABaCZ8CBAoACgAHAQiqCQBH2loCBAoAAA==.',Pa='Pallypump:AwACCAMABAoAAA==.Pasquale:AwAGCA4ABAoAAA==.',Pe='Pebbles:AwACCAIABRQCAgAHAQjuMwBCmxoCBAoAAgAHAQjuMwBCmxoCBAoAAA==.',Ph='Phases:AwADCAEABAoAAA==.',Pi='Pixydragon:AwABCAEABAoAAA==.',Po='Poshpotty:AwAFCAEABAoAAA==.',Pw='Pwnjitsu:AwAFCAIABAoAAA==.',Py='Pyrothermia:AwACCAIABRQCCwAHAQifCQBTcKACBAoACwAHAQifCQBTcKACBAoAAA==.',Qu='Quason:AwAHCAQABAoAAA==.',Ra='Razak:AwAFCAMABAoAAA==.',Re='Renarin:AwAGCBMABAoAAA==.Reu:AwACCAMABAoAAA==.',Rh='Rhoupert:AwAECAYABAoAAA==.',Ro='Rognvald:AwACCAIABAoAAA==.Royalpotty:AwAFCAEABAoAAA==.',Sa='Sanyakulak:AwAICBoABAoDAQAIAQi/DwAwRZsBBAoAAQAHAQi/DwA0YpsBBAoAAgABAAgAAAATfgAABAoAAA==.Sashafreya:AwAFCAoABAoAAA==.',Sc='Scalycat:AwAECAYABAoAAA==.',Sh='Shadowbear:AwADCAUABAoAAA==.Shamaslam:AwAECAcABAoAAA==.',Si='Silverocean:AwAFCAsABAoAAA==.Silverstorm:AwAECAUABAoAAA==.',Sk='Skittlez:AwAECAYABAoAAA==.',Sn='Snooptrogg:AwAECAkABAoAAA==.',So='Soldiah:AwAFCAoABAoAAA==.',St='Steakhaus:AwAFCAoABAoAAA==.Stormï:AwAECAcABAoAAA==.Stouty:AwAICAgABAoAAA==.Stüka:AwAGCBIABAoAAA==.',Su='Sukonamí:AwAECAQABAoAAA==.',Sw='Swifters:AwAGCBAABAoAAA==.',Sy='Sybaek:AwAECAQABAoAAA==.',Th='Thade:AwAGCBUABAoDCgAGAQjNHABDdUcBBAoACgAFAQjNHAA0Q0cBBAoABAAEAQgrNQBFYjEBBAoAAA==.Thirinis:AwACCAIABAoAAA==.',Tr='Trr:AwAICBoABAoCDAAIAQhUCAAwn+kBBAoADAAIAQhUCAAwn+kBBAoAAA==.Trõnlight:AwADCAEABAoAAA==.',Un='Unvoiced:AwEGCAcABAoAAQYAVGYCCAIABRQ=.',Ur='Urzual:AwADCAIABAoAAA==.',Uu='Uuna:AwAFCA0ABAoAAA==.',Ve='Velsiana:AwAHCBsABAoCDQAHAQj3JwAr6awBBAoADQAHAQj3JwAr6awBBAoAAA==.Velveetah:AwABCAEABAoAAQUAAAABCAEABAo=.',Wa='Wayloren:AwAECAIABAoAAA==.',Wh='Whoopzz:AwAGCA8ABAoAAA==.',Wi='Withering:AwACCAIABAoAAA==.',Wo='Worstdps:AwAFCAEABAoAAA==.',Za='Zapdôs:AwAGCAoABAoAAA==.',Ze='Zephyris:AwABCAMABRQCDgAIAQhTAwBaoSoDBAoADgAIAQhTAwBaoSoDBAoAAA==.',Zr='Zryda:AwAECAYABAoAAA==.',Zw='Zweimal:AwAGCA0ABAoAAA==.',['Ð']='Ðìaßlo:AwAECAkABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end