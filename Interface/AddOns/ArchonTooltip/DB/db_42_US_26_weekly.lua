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
 local lookup = {'Unknown-Unknown','Priest-Holy','Priest-Discipline','DeathKnight-Frost','Druid-Guardian','Shaman-Enhancement','Priest-Shadow','Shaman-Restoration','Warrior-Protection','Hunter-Marksmanship',}; local provider = {region='US',realm='Azshara',name='US',type='weekly',zone=42,date='2025-03-29',data={Ac='Achililes:AwAECAIABAoAAA==.',Af='Afeni:AwACCAMABAoAAA==.',Ai='Aidoneus:AwABCAEABRQAAA==.',Am='Amoxicillin:AwADCAEABAoAAA==.',An='Anitadrink:AwAFCAEABAoAAA==.',Ar='Arbysmeats:AwACCAMABAoAAA==.',Av='Averandra:AwABCAEABAoAAQEAAAAGCA4ABAo=.',Ba='Baameansno:AwABCAMABAoAAA==.Baldurss:AwAICBAABAoAAA==.',Be='Beefyheealz:AwAFCAUABAoAAA==.Behealzabub:AwACCAIABAoAAA==.Belpepper:AwAFCAgABAoAAA==.',Bh='Bhav:AwAICAkABAoAAA==.',Bi='Bigboycrits:AwAICAgABAoAAA==.',Bl='Bloodypall:AwAFCAEABAoAAA==.',Bo='Borednow:AwAHCBIABAoAAA==.',Br='Breticus:AwACCAIABRQCAgAIAQjgEgA6QAQCBAoAAgAIAQjgEgA6QAQCBAoAAA==.Brightmourne:AwAFCAoABAoAAA==.',Bu='Bubblefett:AwACCAEABAoAAA==.',Ca='Cannele:AwADCAUABAoAAA==.',Ci='Cinderkit:AwADCAYABAoAAQEAAAAHCBMABAo=.',Cl='Clockworks:AwADCAMABAoAAA==.',Co='Coompi:AwADCAUABRQCAwADAQieBQAZ6scABRQAAwADAQieBQAZ6scABRQAAA==.',Cu='Current:AwAFCAsABAoAAA==.',Da='Daemonfier:AwABCAIABRQCAwAGAQiUEQBKPesBBAoAAwAGAQiUEQBKPesBBAoAAA==.Daladiirn:AwADCAMABRQAAA==.Danoxen:AwADCAcABAoAAA==.',De='Deadbarcy:AwADCAMABAoAAQEAAAAGCBIABAo=.Deathhuntrr:AwACCAIABAoAAA==.Demonhater:AwADCAIABAoAAA==.Devilsblade:AwACCAMABAoAAA==.',Di='Diampiece:AwAECAIABAoAAA==.',Ec='Ecclesia:AwAECAEABAoAAA==.Echofoxxy:AwADCAEABAoAAA==.Ecxlipse:AwADCAYABRQCBAADAQhZAABSZEoBBRQABAADAQhZAABSZEoBBRQAAA==.',Ei='Eie:AwABCAEABRQAAA==.',El='Elrithien:AwADCAQABAoAAA==.',Em='Emberlinn:AwADCAEABAoAAA==.',Fa='Faetaria:AwABCAEABAoAAA==.',Fe='Fepo:AwAICBAABAoAAA==.',Fl='Flastage:AwACCAEABAoAAA==.',Ga='Garzett:AwAGCA0ABAoAAA==.',Gl='Glizzyys:AwAFCAkABAoAAA==.',Go='Gordo:AwADCAMABAoAAA==.',['G�']='Gðd:AwAICAwABAoAAA==.',He='Helfon:AwAGCAwABAoAAQEAAAAICA4ABAo=.',Ho='Holycharlie:AwAECAYABAoAAA==.Holydudy:AwABCAEABAoAAA==.Holyrager:AwADCAMABAoAAA==.Holyvez:AwADCAUABAoAAA==.',In='Invokër:AwACCAIABAoAAA==.',Ja='Jaded:AwACCAIABAoAAA==.',Je='Jechaen:AwAGCAUABAoAAA==.',Ji='Jihoon:AwADCAUABAoAAA==.Jimfro:AwABCAEABAoAAQUAVucCCAcABRQ=.',Ju='Justgoodman:AwAHCAEABAoAAA==.',Ka='Kayonna:AwAFCAUABAoAAA==.',Ke='Kegs:AwABCAIABRQAAA==.Keldanis:AwAECAoABAoAAA==.Kerangdk:AwABCAEABRQCBAAHAQh0BABQRnACBAoABAAHAQh0BABQRnACBAoAAA==.Ketink:AwACCAIABAoAAA==.',Ki='Kiin:AwACCAEABAoAAA==.Kittyarly:AwAGCAYABAoAAA==.',Ko='Koshima:AwAGCBEABAoAAA==.',Kr='Kreamer:AwAECAcABAoAAA==.',Ku='Kummerspeck:AwABCAEABAoAAA==.Kuori:AwACCAQABRQCBgAIAQiUAQBckVgDBAoABgAIAQiUAQBckVgDBAoAAA==.',La='Lamine:AwABCAEABRQAAA==.',Le='Leetheal:AwAHCBcABAoCBwAHAQjrEwBCB/cBBAoABwAHAQjrEwBCB/cBBAoAAA==.',Li='Lilfloozy:AwACCAIABAoAAA==.Lilheal:AwABCAEABAoAAA==.Linkdead:AwAGCAYABAoAAA==.Lirkö:AwABCAEABRQCBgAHAQjfHQAU7IIBBAoABgAHAQjfHQAU7IIBBAoAAA==.',Lu='Lurelune:AwAGCA4ABAoAAA==.',Me='Melthida:AwAFCAkABAoAAA==.',Mi='Mildindian:AwAECAYABAoAAA==.Missmouthoff:AwAICBIABAoAAA==.',Mt='Mtnoflight:AwADCAIABAoAAA==.',My='Myw:AwAECAYABAoAAQgAWhIBCAMABRQ=.',Na='Naturepickle:AwAECAoABAoAAA==.',Ne='Nervanas:AwAFCAUABAoAAA==.',No='Nokurai:AwAECAYABAoAAA==.Noonecaress:AwACCAMABAoAAA==.Novas:AwAICBIABAoAAA==.',Or='Oriá:AwAGCAoABAoAAA==.',Pi='Pitou:AwAFCAEABAoAAA==.',Po='Powderkegs:AwADCAMABAoAAQEAAAABCAIABRQ=.',['P�']='Pétro:AwAECAYABAoAAA==.',Qi='Qiz:AwABCAEABAoAAA==.',Ra='Ragekilling:AwAGCAsABAoAAA==.',Re='Rexraj:AwADCAEABAoAAA==.',Ri='Rianthresh:AwAGCAEABAoAAA==.Rickiticki:AwABCAEABAoAAA==.',Ro='Rosetoy:AwADCAMABAoAAA==.',Ru='Rufustitus:AwABCAMABRQCCQAIAQj5BQA3NBMCBAoACQAIAQj5BQA3NBMCBAoAAA==.',Sa='Safeladin:AwABCAEABRQAAA==.Sakanald:AwADCAEABAoAAA==.Sarrazine:AwADCAMABAoAAA==.Saryarus:AwAICA4ABAoAAA==.',Se='Sedgeshammy:AwACCAIABAoAAA==.',Sh='Shae:AwAHCAoABAoAAA==.Shmoopie:AwACCAIABAoAAA==.',Si='Silencio:AwABCAEABAoAAA==.Sipersjr:AwAGCAsABAoAAA==.',Sk='Skitzz:AwABCAIABAoAAA==.',Sn='Snipez:AwABCAEABAoAAA==.',So='Solclipeus:AwABCAEABRQAAA==.',Sp='Splashgnwild:AwAHCA0ABAoAAA==.',Ta='Talok:AwABCAEABAoAAA==.Talonhand:AwAFCAUABAoAAA==.Tanthoril:AwADCAEABAoAAA==.',Te='Teehole:AwAHCAwABAoAAA==.',Ti='Tigerpa:AwAFCAUABAoAAA==.Tinymerks:AwACCAIABAoAAA==.Tioklarus:AwAECAEABAoAAA==.',To='Tofulady:AwAHCBEABAoAAA==.Tonatos:AwAHCA4ABAoAAQEAAAABCAEABRQ=.',Ts='Tsukifang:AwAFCAUABAoAAA==.',Tt='Tteehee:AwADCAYABAoAAA==.',['T�']='Tìlly:AwAICAgABAoAAA==.',Ul='Ulala:AwACCAIABAoAAA==.',Va='Varakir:AwABCAIABRQAAA==.Varakiri:AwABCAEABRQAAA==.',Ve='Velanoria:AwAECAgABAoAAA==.Veldoga:AwAGCA0ABAoAAA==.Velenice:AwAECAQABAoAAQEAAAAFCAYABAo=.Venvalzhar:AwACCAIABAoAAA==.Vestammeni:AwAGCAoABAoAAA==.',['V�']='Vêzz:AwABCAEABRQCCAAHAQiBEwBJHS4CBAoACAAHAQiBEwBJHS4CBAoAAA==.',Wa='Waternbread:AwAECAcABAoAAA==.',We='Wetremin:AwAFCAcABAoAAA==.',Wi='Wingedlady:AwADCAMABAoAAA==.',Wl='Wlkqueenn:AwAECAkABAoAAA==.',Xi='Xiame:AwABCAEABRQAAQEAAAABCAEABRQ=.Xiing:AwAFCAEABAoAAA==.',Xw='Xwhitesnow:AwACCAIABAoAAA==.',Yo='Yodhevavhe:AwEICA8ABAoAAA==.',Za='Zabuto:AwAGCA4ABAoAAA==.Zazpal:AwABCAEABAoAAA==.',Ze='Zerocharisma:AwABCAEABAoAAA==.',Zh='Zhaoming:AwADCAQABAoAAA==.',Zy='Zyroz:AwAECAkABAoAAA==.',['À']='Àpöllö:AwABCAMABRQCCgAIAQg8DABCFh4CBAoACgAIAQg8DABCFh4CBAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end