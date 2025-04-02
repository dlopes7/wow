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
 local lookup = {'Monk-Brewmaster','Priest-Holy','Warlock-Demonology','Warlock-Affliction','Warlock-Destruction','Hunter-BeastMastery','Unknown-Unknown','Druid-Restoration','Paladin-Protection','Evoker-Devastation','Evoker-Augmentation','DeathKnight-Frost','Evoker-Preservation','Priest-Shadow','Shaman-Restoration','Druid-Feral','Druid-Balance','Druid-Guardian','DemonHunter-Havoc','Shaman-Enhancement','Mage-Fire','Mage-Arcane','Shaman-Elemental','Paladin-Holy','Warrior-Arms','Warrior-Fury',}; local provider = {region='US',realm='Lothar',name='US',type='weekly',zone=42,date='2025-03-29',data={Ae='Aeldron:AwAGCA0ABAoAAA==.Aeonnax:AwABCAEABAoAAA==.Aevisea:AwADCAQABAoAAA==.',Ai='Aidan:AwEECAoABRQCAQAEAQgXAABiBrcBBRQAAQAEAQgXAABiBrcBBRQAAA==.',Al='Aldrigor:AwADCAcABAoAAA==.Alett:AwADCAMABAoAAA==.Alivathus:AwABCAIABRQCAgAHAQhHCQBUy4UCBAoAAgAHAQhHCQBUy4UCBAoAAA==.Alystia:AwAECAYABAoAAA==.',Ar='Araina:AwAFCAUABAoAAA==.Arbark:AwAECAMABAoAAA==.Arcelf:AwABCAIABAoAAA==.',As='Aspinks:AwAECAsABAoAAQMAKzYGCBQABAo=.',Av='Availl:AwACCAIABAoAAA==.Avinôx:AwAECAkABAoAAA==.',Ba='Baiwushi:AwAGCAwABAoAAA==.Balbit:AwABCAMABRQCBAAIAQiUBAA7GQQCBAoABAAIAQiUBAA7GQQCBAoAAA==.',Be='Beardedzondo:AwABCAEABAoAAA==.',Bl='Blobney:AwACCAQABRQEBAAIAQg8BQBeDOwBBAoABAAFAQg8BQBaw+wBBAoABQAFAQjtLQBS/YQBBAoAAwADAQhjFABdUTkBBAoAAA==.',Br='Brohaha:AwABCAIABAoAAA==.',Bu='Butterflyy:AwAGCAwABAoAAA==.',['B�']='Bànying:AwAFCAQABAoAAA==.',Ce='Celafix:AwAFCAoABAoAAA==.Celestial:AwAHCBMABAoAAA==.',Ch='Christobol:AwAFCBYABAoCBgAFAQjSWAA0iywBBAoABgAFAQjSWAA0iywBBAoAAA==.Chuyz:AwAECAQABAoAAA==.',Cr='Crunch:AwAFCA4ABAoAAA==.',Cy='Cythraul:AwABCAIABAoAAA==.',Da='Daboommonk:AwAICBAABAoAAA==.Daddyuwu:AwAFCA0ABAoAAA==.Daisharagos:AwAFCAoABAoAAA==.Dalelor:AwAFCAgABAoAAA==.Darcie:AwAHCAwABAoAAA==.Dargeth:AwAFCAsABAoAAA==.Daylia:AwABCAEABAoAAA==.',Di='Dirtyfighter:AwAECAUABAoAAA==.Dirtylock:AwABCAEABAoAAQcAAAAECAUABAo=.Discosticks:AwABCAIABAoAAA==.',Dj='Djsnake:AwADCAYABAoAAA==.',Do='Donkofpuncho:AwAGCAcABAoAAA==.',Dr='Drphil:AwAECAkABAoAAA==.Drslay:AwAGCA8ABAoAAA==.',Ee='Eeviana:AwAECAgABRQCCAAEAQgCAQA14UoBBRQACAAEAQgCAQA14UoBBRQAAA==.',Ei='Eitharis:AwAFCA4ABAoAAA==.',El='Elbrujo:AwAFCA4ABAoAAA==.Elementals:AwAICAgABAoAAA==.',Fl='Flores:AwAGCBAABAoAAA==.',Fo='Foreheadkiss:AwAFCA0ABAoAAA==.Forinir:AwAHCBIABAoAAA==.',Fr='Frozenhawk:AwAGCAsABAoAAA==.',Ga='Galadis:AwAHCBMABAoAAA==.',Ge='Geewilkr:AwADCAYABAoAAA==.Geostorm:AwAGCA0ABAoAAA==.Gerhart:AwADCAcABAoAAA==.',Gh='Ghoost:AwAGCA0ABAoAAQQAWnsECAoABRQ=.Ghostsham:AwAGCAEABAoAAQQAWnsECAoABRQ=.',Gl='Glizzyman:AwAGCAkABAoAAA==.',Go='Goldoran:AwADCAQABAoAAA==.Goniff:AwAHCBQABAoCCQAHAQilBgBSRmkCBAoACQAHAQilBgBSRmkCBAoAAA==.Goransk:AwABCAIABAoAAA==.',Gr='Grenmosh:AwADCAMABAoAAA==.Grubber:AwABCAEABAoAAA==.',Gu='Guntran:AwAGCAwABAoAAA==.',Ha='Halios:AwADCAUABAoAAA==.Hambgusburg:AwAFCBEABAoAAQcAAAAICAcABAo=.Haterade:AwADCAYABRQDCgADAQjPBAA8OecABRQACgADAQjPBAA4z+cABRQACwABAQhbAABkADwABRQAAA==.',Hi='Hitmonlee:AwAGCA4ABAoAAA==.',Ho='Holypwr:AwAECAgABAoAAA==.Holyspurb:AwAECAQABAoAAA==.Hotdumpling:AwAGCAoABAoAAA==.',Hu='Hummockdwell:AwAHCBEABAoAAA==.',['H�']='Háyate:AwAECAEABAoAAA==.',In='Inspectadeck:AwACCAMABRQCBQAIAQgkDQBJH5UCBAoABQAIAQgkDQBJH5UCBAoAAA==.Insta:AwACCAIABAoAAA==.',Ir='Ironhoar:AwAGCA4ABAoAAA==.',Is='Istariel:AwAECAoABRQEBAAEAQj7AABaey4BBRQABAADAQj7AABcAi4BBRQAAwACAQjcAABb28gABRQABQABAQh6EwBekEwABRQAAA==.',Ja='Jasmines:AwABCAEABAoAAA==.',Je='Jerrane:AwACCAQABAoAAA==.Jetblue:AwABCAEABAoAAQcAAAAFCA0ABAo=.Jey:AwAHCAIABAoAAA==.',Jo='Joenips:AwAECAkABAoAAA==.Jorrell:AwAFCA0ABAoAAA==.',Ju='Juantoof:AwABCAEABAoAAA==.',Ka='Kaalar:AwAGCBMABAoAAA==.Kaimetsu:AwAICBAABAoAAA==.Kamikazzie:AwAHCBYABAoCDAAHAQjrCQAvCrYBBAoADAAHAQjrCQAvCrYBBAoAAA==.Kamoura:AwAFCAwABAoAAA==.Karmen:AwAECAoABRQCDQAEAQgYAABZEJkBBRQADQAEAQgYAABZEJkBBRQAAA==.Karnatron:AwAECAQABAoAAA==.Kaylea:AwACCAMABRQCDgAIAQj8BABTcAIDBAoADgAIAQj8BABTcAIDBAoAAA==.',Ke='Keli:AwAECAcABAoAAQ8ATbkECAcABRQ=.Kennagi:AwABCAEABAoAAA==.',Kh='Khovastis:AwAECAoABRQEEAAEAQgGAQA+QtMABRQAEAACAQgGAQBdINMABRQAEQACAQiPDQASzoAABRQAEgABAQjtAgApESsABRQAAA==.',Ki='Kianll:AwAICAkABAoAAA==.Kitchntabls:AwAECAgABRQCEwAEAQjiAgAwOFkBBRQAEwAEAQjiAgAwOFkBBRQAAA==.Kiuan:AwAGCAgABAoAAA==.',Ko='Kodiak:AwAICAgABAoAAA==.Koenji:AwAECAoABRQCFAAEAQhTAQAwCmEBBRQAFAAEAQhTAQAwCmEBBRQAAA==.Kort:AwAICAgABAoAAA==.',La='Lally:AwACCAMABAoAAA==.',Le='Leafey:AwAGCAYABAoAAQ8ATbkECAcABRQ=.Lerann:AwAFCAkABAoAAA==.',Li='Lick:AwAFCAkABAoAAA==.Lillea:AwAECAgABAoAAA==.Lilrob:AwAGCAkABAoAAA==.',Lo='Loktalaan:AwACCAMABRQCFAAIAQgLCwBIRpQCBAoAFAAIAQgLCwBIRpQCBAoAAA==.Lookinglimbo:AwAFCAMABAoAAA==.Lothartar:AwAFCAkABAoAAA==.',Ma='Mahito:AwAHCAIABAoAAA==.Marderer:AwAECAUABAoAAA==.Mariuss:AwAICA4ABAoAAA==.Masakari:AwAFCAoABAoAAA==.Maulfarm:AwACCAQABRQCEAAIAQh7AQBSPBoDBAoAEAAIAQh7AQBSPBoDBAoAAA==.',Me='Megameow:AwAFCA8ABAoAAA==.',Mi='Miamiganster:AwAICAcABAoAAA==.Mitrixx:AwACCAIABAoAAA==.Miztie:AwADCAIABAoAAA==.',Mo='Molley:AwAGCBAABAoAAA==.Monkey:AwABCAEABAoAAQcAAAAFCA0ABAo=.Moondrius:AwAFCA8ABAoAAA==.',Mu='Mustardkin:AwADCAMABAoAAA==.',My='Mythaltis:AwAFCAgABAoAAA==.',Na='Namswoam:AwAECAMABAoAAQcAAAAICAcABAo=.',Ne='Necrokai:AwAFCAkABAoAAA==.',Ni='Nikehalo:AwADCAcABAoAAA==.',No='Noctix:AwAICAQABAoAAA==.Notcold:AwAFCAoABAoAAA==.',Ns='Nswiz:AwAECAoABRQDFQAEAQj+BgAanCMBBRQAFQAEAQj+BgAaiiMBBRQAFgACAQiBAAAGkXIABRQAAA==.',Ov='Overclocked:AwAGCBQABAoCAwAGAQhlDwArNnABBAoAAwAGAQhlDwArNnABBAoAAA==.',Pa='Paladinaa:AwADCAQABAoAAA==.',Pe='Pendojo:AwACCAIABAoAAA==.',Ph='Phandros:AwAECAoABAoAAA==.Phindalari:AwAGCBMABAoAAA==.',Pi='Pip:AwADCAkABRQDFwADAQixAQBHZicBBRQAFwADAQixAQBHZicBBRQADwACAQiYCgAfOIcABRQAAA==.',Po='Poo:AwABCAEABRQAAA==.Pookiemonstr:AwAFCAsABAoAAA==.',Pu='Publictoilet:AwADCAcABRQCEQADAQghCAAsetgABRQAEQADAQghCAAsetgABRQAAA==.',Ra='Raegon:AwADCAcABAoAAA==.Rakury:AwACCAIABAoAAA==.Raulothim:AwAFCAoABAoAAA==.',Re='Repentance:AwABCAIABAoAAA==.',Rh='Rheina:AwAGCAoABAoAAA==.',Ri='Ricemachinex:AwAECAkABRQEBQAEAQhWBABJsP4ABRQABQADAQhWBABBBP4ABRQABAABAQgcCQBJplsABRQAAwABAQhEBgBOWE0ABRQAAA==.Ricemachnedk:AwAGCA0ABAoAAA==.Rizhky:AwAFCAoABAoAAA==.',Ro='Romarus:AwAFCAsABAoAAA==.Roses:AwAECAoABRQCGAAEAQgZAABhVr8BBRQAGAAEAQgZAABhVr8BBRQAAA==.',Sa='Saintrob:AwABCAEABAoAAA==.Sauce:AwAHCAcABAoAARkASTUICBoABAo=.',Sc='Scholoman:AwAFCAoABAoAAA==.',Se='Seerjohn:AwAICAgABAoAAQcAAAAICBAABAo=.Seerjonn:AwAICBAABAoAAA==.Severusevans:AwAHCBgABAoDEgAHAQjTAQBS6YcCBAoAEgAHAQjTAQBS6YcCBAoAEQACAQhJVABEgZcABAoAAA==.',Sh='Shamhuth:AwAFCAkABAoAAA==.Shartner:AwABCAEABAoAAA==.Shynox:AwAFCAkABAoAAA==.',Si='Sickorogue:AwADCAIABAoAAA==.Sivaartus:AwADCAMABAoAAA==.',Sk='Skuid:AwAECAkABAoAAA==.',Sl='Sledgesmite:AwAICAgABAoAAA==.',So='Sommin:AwAICBoABAoEFAAIAQhDCwBS/o8CBAoAFAAHAQhDCwBVFY8CBAoAFwADAQiQPAAxLJgABAoADwACAQiugQALzR8ABAoAAA==.Sorâ:AwACCAIABAoAAA==.',St='Steplok:AwAGCAwABAoAAA==.Stinks:AwABCAEABAoAAQcAAAAGCA0ABAo=.Stonestriker:AwADCAQABAoAAA==.Stooben:AwABCAIABRQAAA==.',Sw='Sweetivy:AwADCAMABAoAAA==.',Sy='Syanaria:AwAHCBIABAoAAA==.Sylarz:AwABCAEABAoAAQcAAAAFCAsABAo=.Syyindilia:AwAICBAABAoAAA==.',Th='Thadex:AwADCAMABAoAAA==.Thepriestguy:AwABCAEABAoAAA==.',Ti='Tigorga:AwAECAYABAoAAA==.',To='Toem:AwAGCBMABAoAAA==.Tootem:AwAECAYABAoAAA==.Tooyoo:AwAECAoABRQDGgAEAQgDBABQGSwBBRQAGgADAQgDBABNCywBBRQAGQABAQiUBgBZQ2AABRQAAA==.',Tr='Trashpixie:AwAGCBIABAoAAA==.Tremortotem:AwAECAQABAoAAQ4AU3ACCAMABRQ=.',Tu='Turthunt:AwADCAcABRQCBgADAQgfBwBH5xYBBRQABgADAQgfBwBH5xYBBRQAAA==.',Va='Valakar:AwAECAEABAoAAA==.',Ve='Veridale:AwACCAIABAoAAQQAXgwCCAQABRQ=.',Wa='Wahstella:AwAECAkABRQCFQAEAQjfBQAprjUBBRQAFQAEAQjfBQAprjUBBRQAAA==.Waraich:AwADCAgABRQCCQADAQgNAQBbFTwBBRQACQADAQgNAQBbFTwBBRQAAA==.Waraight:AwACCAIABRQAAA==.',Wh='Whelp:AwAECAkABAoAAA==.Whitelady:AwAICAgABAoAAA==.Whiterobot:AwAGCAIABAoAAA==.',Wo='Woozi:AwAECAcABRQCDwAEAQgfAQBNuVwBBRQADwAEAQgfAQBNuVwBBRQAAA==.',Wu='Wulgarr:AwAICBgABAoDGQAIAQihCgA5NUcCBAoAGQAIAQihCgA4d0cCBAoAGgABAQgaZAA2ezwABAoAAA==.',Xa='Xavierson:AwADCAcABAoAAA==.',Za='Zarf:AwAHCAIABAoAAA==.',Ze='Zelgius:AwAHCBMABAoAAA==.',Zh='Zhulee:AwAGCAMABAoAAA==.',Zx='Zxo:AwAGCAYABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end