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
 local lookup = {'Warrior-Arms','Shaman-Elemental','Unknown-Unknown','Druid-Balance','Evoker-Devastation','Warrior-Fury','Shaman-Enhancement','Druid-Feral','Monk-Brewmaster','Monk-Mistweaver','Rogue-Assassination','DemonHunter-Havoc','Monk-Windwalker','Priest-Holy','Warlock-Demonology','Priest-Shadow','Priest-Discipline',}; local provider = {region='US',realm='Windrunner',name='US',type='weekly',zone=42,date='2025-03-28',data={Ad='Adämwest:AwAICBIABAoAAA==.',Ak='Akaros:AwADCAIABAoAAA==.',Al='Allerïah:AwAECAgABAoAAA==.',Am='Amoxil:AwAICAMABAoAAA==.',An='Anasztaizia:AwABCAMABAoAAA==.Anorah:AwADCAYABAoAAA==.',Aq='Aqualeta:AwAICBEABAoAAA==.',Ar='Arath:AwADCAMABAoAAA==.',As='Asar:AwAECAQABAoAAA==.',Av='Avengelina:AwACCAIABAoAAA==.',Ay='Ayvangeline:AwAECAUABAoAAA==.',Ba='Baggedmilk:AwACCAIABAoAAA==.Barthelo:AwAFCAkABAoAAA==.',Be='Beldaran:AwABCAMABAoAAA==.Belldândy:AwABCAEABAoAAA==.',Br='Brickpuncher:AwACCAMABAoAAA==.Brillina:AwAFCAUABAoAAA==.Brugamen:AwAECAQABAoAAA==.',Bu='Bunnylajoya:AwADCAQABAoAAA==.',Ca='Carmelita:AwADCAEABAoAAA==.',Ce='Celtigar:AwABCAEABAoAAA==.',Ch='Chamcham:AwABCAEABAoAAA==.Chlorin:AwAECAIABAoAAA==.',Cl='Clikytrigers:AwACCAIABRQCAQAHAQhpBwBUk4MCBAoAAQAHAQhpBwBUk4MCBAoAAA==.',Cy='Cyber:AwADCAMABAoAAA==.Cyntaria:AwADCAEABAoAAA==.',De='Deltavariant:AwABCAEABAoAAA==.Deschain:AwACCAMABAoAAA==.',Di='Diin:AwADCAcABAoAAA==.',Dr='Dredd:AwACCAIABAoAAA==.',Ea='Earthenfüry:AwABCAIABRQCAgAIAQhtCgBGe4QCBAoAAgAIAQhtCgBGe4QCBAoAAA==.',Ek='Ekkaia:AwAFCAUABAoAAA==.',En='Ender:AwADCAcABAoAAA==.',Er='Ericgb:AwABCAEABRQAAA==.Erutreya:AwADCAIABAoAAA==.',Ez='Ezmerelda:AwACCAEABAoAAA==.',Fc='Fcknfear:AwADCAQABAoAAQMAAAAHCA8ABAo=.',Fi='Fistoflurry:AwABCAEABAoAAA==.',Fo='Fochtface:AwAECAQABAoAAA==.',Fr='Franksuba:AwABCAIABRQCBAAIAQg1EgBFO2UCBAoABAAIAQg1EgBFO2UCBAoAAA==.',Fu='Fuzzybahls:AwAECAQABAoAAA==.',Ga='Gator:AwACCAIABAoAAQMAAAAECAQABAo=.',Go='Gobfather:AwACCAIABAoAAA==.Goodfaith:AwABCAEABAoAAA==.',Gr='Greyquinn:AwADCAEABAoAAA==.',Gu='Gullibull:AwAGCAIABAoAAA==.',Gw='Gwynne:AwAFCAcABAoAAA==.',Ha='Hadoxx:AwADCAEABAoAAA==.Halanad:AwABCAMABAoAAA==.',He='Hecklerkoch:AwAGCAIABAoAAA==.Hereticslick:AwADCAMABAoAAA==.Herevoker:AwABCAIABRQCBQAHAQhgDgBBdBMCBAoABQAHAQhgDgBBdBMCBAoAAA==.Hermonk:AwAGCAwABAoAAQUAQXQBCAIABRQ=.',Hi='Hildia:AwAGCA0ABAoAAA==.Hishunter:AwAFCAYABAoAAA==.Hiswarrior:AwABCAEABRQCBgAHAQhYFABB0z8CBAoABgAHAQhYFABB0z8CBAoAAA==.',Il='Ilidanick:AwACCAEABAoAAA==.',Is='Ismirea:AwABCAEABAoAAA==.',Ka='Kaho:AwAECAYABAoAAA==.Kazu:AwACCAIABAoAAA==.Kazuhiro:AwAECAYABAoAAQcAXS0BCAIABRQ=.',Ke='Keagan:AwABCAEABAoAAA==.Keekyo:AwAECAYABAoAAA==.',Kh='Khaluha:AwABCAEABAoAAA==.',Ku='Kueball:AwAECAMABAoAAA==.',['K�']='Káli:AwABCAEABRQAAA==.Kìngpin:AwAGCAEABAoAAA==.',La='Lanolin:AwAICA4ABAoAAA==.',Le='Lethaldx:AwABCAEABAoAAA==.',Li='Liski:AwACCAMABAoAAA==.Lizora:AwABCAEABRQCCAAHAQhgCgAdaYsBBAoACAAHAQhgCgAdaYsBBAoAAA==.',Lo='Locktuah:AwADCAMABAoAAQMAAAAECAQABAo=.Loriol:AwACCAMABAoAAQMAAAAFCAgABAo=.',Lu='Lunaclaw:AwADCAMABAoAAA==.',['L�']='Lüffy:AwADCAEABAoAAA==.',Ma='Mack:AwAICAcABAoDCQAFAQhnDgAm9PYABAoACQAFAQhnDgAm9PYABAoACgACAQjGVwAp5FcABAoAAA==.Madrina:AwABCAEABAoAAA==.Magicwithin:AwAFCAsABAoAAA==.Malevolens:AwACCAEABAoAAA==.Malkinish:AwAECAMABAoAAQMAAAAECAMABAo=.Mancant:AwADCAIABAoAAA==.Mavanahlia:AwACCAMABAoAAA==.',Mc='Mcsprinkles:AwAECAQABAoAAA==.',Me='Megamana:AwACCAIABAoAAA==.Megladoon:AwADCAUABAoAAA==.Messdupllama:AwAECAMABAoAAA==.',Mi='Microcharge:AwAECAgABAoAAA==.Missmoodý:AwABCAEABAoAAA==.',Mo='Moltenbeast:AwACCAIABAoAAA==.Moonpenance:AwABCAEABAoAAA==.Morbidi:AwACCAEABAoAAA==.',My='Mylanara:AwAECAMABAoAAA==.Mysterymeåt:AwACCAMABAoAAQMAAAAICAsABAo=.Mythalias:AwAGCAUABAoAAA==.',Na='Naffer:AwADCAgABRQCCwADAQhdAQA0/v4ABRQACwADAQhdAQA0/v4ABRQAAA==.Nambers:AwAICAsABAoAAQsANP4DCAgABRQ=.Nathi:AwABCAMABAoAAA==.',Ne='Nezax:AwADCAIABAoAAA==.',No='Novacat:AwAHCBEABAoAAA==.',Ny='Nyndra:AwAHCBQABAoCDAAHAQhgFwBMLFwCBAoADAAHAQhgFwBMLFwCBAoAAQsANP4DCAgABRQ=.',On='Onetwenty:AwACCAMABAoAAA==.',Pa='Palidan:AwADCAIABAoAAA==.Paneer:AwAECAQABAoAAA==.Pangho:AwACCAIABRQCDQAHAQipCABY86sCBAoADQAHAQipCABY86sCBAoAAA==.',Pe='Percent:AwAECAcABAoAAA==.',Pr='Proioxis:AwAFCAIABAoAAA==.',Py='Pyroclàstic:AwADCAcABAoAAA==.',Qu='Quendia:AwAICAsABAoAAA==.',Re='Rettyruxpin:AwAECAcABAoAAA==.',Ro='Roguehuman:AwABCAEABAoAAA==.',Ru='Rutira:AwAHCA0ABAoAAA==.',Sa='Sashaslay:AwABCAEABAoAAQMAAAADCAEABAo=.Saucymack:AwABCAIABRQDCAAIAQg0BAA+vHwCBAoACAAIAQg0BAA+vHwCBAoABAABAQjvbwAL3SYABAoAAA==.Saula:AwAECAIABAoAAQMAAAABCAIABRQ=.',Se='Seapal:AwAECAQABAoAAA==.Serakor:AwACCAMABAoAAA==.',Sh='Shamdaddy:AwAGCBIABAoAAA==.Shlapp:AwACCAIABAoAAA==.Shåmpon:AwAHCA8ABAoAAA==.Shênanigens:AwAHCAwABAoAAA==.',Si='Siandine:AwADCAMABAoAAA==.Silencespace:AwAECAsABAoAAA==.Sinai:AwAFCAkABAoAAA==.Sindir:AwADCAMABAoAAQ4AO5ECCAIABRQ=.',Sl='Slayjaxx:AwAECAQABAoAAA==.Sleêp:AwABCAMABAoAAA==.',Sn='Snaptrap:AwAGCAEABAoAAA==.',So='Sonny:AwACCAMABAoAAA==.',Sp='Spriggs:AwAECAUABAoAAA==.',Su='Sullyboy:AwAGCA4ABAoAAA==.',Sy='Symphonica:AwAECAkABAoAAA==.Synclaer:AwACCAMABAoAAA==.',Ta='Tankyouvm:AwACCAMABAoAAA==.Tarò:AwABCAEABRQCDgAHAQhyHwApP4YBBAoADgAHAQhyHwApP4YBBAoAAA==.',Th='Themonks:AwAGCBAABAoAAA==.Therfudin:AwAECAEABAoAAQoARrYICBcABAo=.Thetamoon:AwAFCAkABAoAAA==.',Ti='Tiktikboom:AwABCAEABAoAAA==.',To='Tomoé:AwACCAIABAoAAA==.Totemtrixx:AwAFCAUABAoAAA==.Toxique:AwADCAEABAoAAA==.',Tr='Try:AwAFCAoABRQCBwAFAQhhAAA60dgBBRQABwAFAQhhAAA60dgBBRQAAA==.Trybu:AwAFCA8ABAoAAA==.',Tu='Tuldia:AwABCAEABAoAAA==.Turtlesaurus:AwADCAUABAoAAA==.',Un='Unfleshed:AwAICAQABAoAAA==.',Va='Valtaran:AwABCAEABAoAAQMAAAACCAMABAo=.Vampirism:AwADCAQABAoAAA==.',Vi='Vidu:AwAFCAsABAoAAA==.Vivilyn:AwACCAMABAoAAA==.Vivitryxia:AwABCAEABAoAAA==.',Vo='Vordis:AwAGCA0ABAoAAA==.',Vy='Vyrstal:AwAFCAEABAoAAA==.',Wa='Waifuu:AwABCAEABRQAAA==.Wargisao:AwAHCA0ABAoAAA==.',We='Weavile:AwABCAEABRQAAA==.Wef:AwABCAEABAoAAA==.Weirdtotem:AwAICAQABAoAAA==.',Wi='Willemdabow:AwABCAEABAoAAA==.Wimboheotii:AwACCAMABAoAAA==.',Wu='Wud:AwAFCA4ABAoAAA==.',Xa='Xanthrite:AwADCAcABAoAAA==.',Za='Zachspitfire:AwAHCA4ABAoAAQ8AWBkICBUABAo=.Zakma:AwACCAIABRQEDgAIAQh9FQA7kd8BBAoADgAHAQh9FQA/td8BBAoAEAADAQicJwBQWAcBBAoAEQABAQgBTgAemj0ABAoAAA==.Zalen:AwAFCAUABAoAAA==.',Ze='Zeraven:AwABCAEABAoAAA==.',Zo='Zonksmoose:AwACCAEABAoAAA==.Zonkspaladin:AwADCAIABAoAAA==.',Zy='Zynskie:AwABCAEABAoAAA==.',['Ø']='Ødger:AwADCAMABAoAAA==.',['ß']='ßerlain:AwABCAMABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end