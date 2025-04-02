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
 local lookup = {'Warlock-Affliction','Warlock-Destruction','Warlock-Demonology','Paladin-Retribution','Priest-Shadow','Evoker-Devastation','Priest-Holy','Unknown-Unknown','Paladin-Protection','Paladin-Holy','Evoker-Preservation','Warrior-Protection','Mage-Frost','Warrior-Fury','Warrior-Arms','Druid-Balance','Mage-Fire','Mage-Arcane','Rogue-Assassination','Rogue-Outlaw','Hunter-BeastMastery','DemonHunter-Havoc','Druid-Feral','Druid-Restoration','DeathKnight-Unholy','Shaman-Enhancement','Shaman-Restoration','DeathKnight-Frost','Priest-Discipline','DemonHunter-Vengeance','Shaman-Elemental','Hunter-Marksmanship','Druid-Guardian','DeathKnight-Blood',}; local provider = {region='US',realm='Thaurissan',name='US',type='weekly',zone=42,date='2025-03-28',data={Ag='Agony:AwACCAIABAoAAA==.Agradechaos:AwACCAIABAoAAA==.',Ai='Aisa:AwAECAwABRQEAQAEAQhuAQBDugcBBRQAAQADAQhuAQA8QQcBBRQAAgACAQgLBwBPMbwABRQAAwABAQgDBQAT3lEABRQAAA==.Aish:AwAECAsABRQCBAAEAQgSAQBTMokBBRQABAAEAQgSAQBTMokBBRQAAA==.',Al='Alexgrease:AwABCAEABAoAAQUAVlwECAwABRQ=.Alirann:AwAECAwABRQCBgAEAQj3AABSsosBBRQABgAEAQj3AABSsosBBRQAAA==.',Am='Ampuzzible:AwADCAMABAoAAA==.',An='Andyrios:AwACCAIABAoAAA==.Anngel:AwAECAoABAoAAA==.',Ar='Arahat:AwAFCAgABAoAAA==.Aralinya:AwACCAIABRQCBwAIAQgHBgBQeb8CBAoABwAIAQgHBgBQeb8CBAoAAA==.Arianagrindy:AwACCAIABAoAAQgAAAAGCA4ABAo=.Arleric:AwAECAwABRQCCQAEAQgtAQA/nC8BBRQACQAEAQgtAQA/nC8BBRQAAA==.Arlerknight:AwAGCA4ABAoAAA==.',As='Asahi:AwAECAEABAoAAA==.Asperonia:AwAECAwABRQCCgAEAQj5AAAl8TkBBRQACgAEAQj5AAAl8TkBBRQAAA==.Astinous:AwABCAEABAoAAA==.Astrid:AwACCAUABRQCCwACAQjYAQBLEK8ABRQACwACAQjYAQBLEK8ABRQAAA==.',At='Ataraxia:AwAFCAwABAoAAA==.Atheis:AwACCAIABAoAAA==.',Au='Auroborealis:AwADCAUABAoAAA==.Ausdemonic:AwADCAcABAoAAA==.',Av='Avell:AwAGCAwABAoAAA==.',Ax='Axiomatic:AwAECAoABAoAAA==.',Az='Azazyle:AwAGCAYABAoAAA==.Azraelin:AwADCAMABAoAAA==.Azsharia:AwAECAQABAoAAA==.',Ba='Badnabit:AwAGCAIABAoAAA==.Balance:AwAGCBIABAoAAA==.Barackobamyh:AwAECAwABRQCDAAEAQjKAAAj/wkBBRQADAAEAQjKAAAj/wkBBRQAAA==.Batrix:AwAHCAsABAoAAA==.Battletank:AwAGCAYABAoAAQ0AQoACCAMABRQ=.',Be='Bellibad:AwABCAEABAoAAA==.Betrayr:AwABCAIABRQAAA==.',Bi='Bigbadbaka:AwAECAwABRQDDgAEAQiqAwBLFisBBRQADgADAQiqAwBGoSsBBRQADwABAQjbBQBYeGkABRQAAA==.Bigbadbolts:AwAGCA4ABAoAAA==.',Bl='Blazez:AwACCAIABRQAAA==.',Bo='Bogart:AwABCAIABRQEAQAIAQjvAgBblUoCBAoAAQAGAQjvAgBQEUoCBAoAAgAEAQhfKgBcepIBBAoAAwADAQjKFABYECgBBAoAAA==.Boó:AwABCAIABAoAAA==.',Bu='Buibuis:AwAGCA4ABAoAAQ4ARFgDCAUABRQ=.Buikia:AwADCAUABRQDDgADAQg0BQBEWAwBBRQADgADAQg0BQBEWAwBBRQADwABAQhrCAAqNlEABRQAAA==.Builtdiff:AwADCAMABAoAAA==.Buthor:AwAGCAYABAoAARAAVmcECAkABRQ=.Buysfeetpics:AwACCAIABRQCEQAIAQifCwBO/9MCBAoAEQAIAQifCwBO/9MCBAoAAA==.',Ca='Cannicus:AwACCAIABRQDEQAIAQhwCQBS1u0CBAoAEQAIAQhwCQBSWe0CBAoAEgAFAQiwBABJBkkBBAoAAA==.Castrial:AwADCAYABRQCEQADAQgCCQA+TfUABRQAEQADAQgCCQA+TfUABRQAAA==.',Ce='Celavii:AwAGCAIABAoAAA==.',Ch='Cherrybelles:AwAHCA4ABAoAAA==.',Cl='Clairetorres:AwACCAIABAoAAA==.',Co='Colena:AwEFCBAABAoAAA==.Corbulus:AwABCAIABRQAAA==.',Cr='Crit:AwABCAEABRQAAQgAAAACCAIABRQ=.Crits:AwACCAIABRQAAA==.Cronus:AwADCAIABAoAAA==.Cruzes:AwACCAIABRQEAgAIAQjpEQBAeFoCBAoAAgAIAQjpEQA/kFoCBAoAAQADAQgzEQA+2fQABAoAAwABAQiQNgBGjlAABAoAAA==.',Cy='Cyndi:AwAECAgABAoAAA==.',Da='Darcious:AwAECAgABAoAAA==.',De='Deadlly:AwAGCA8ABAoAAA==.Dexiës:AwAICAgABAoAAA==.',Di='Dimzalor:AwAFCAUABAoAAA==.Divïne:AwAGCAgABAoAAA==.',Dj='Djenerate:AwACCAMABRQDEwAIAQh+BwBFymUCBAoAEwAIAQh+BwBFjWUCBAoAFAAIAQjaAgAvpBACBAoAAA==.',Dr='Dragonboar:AwAGCA4ABAoAAA==.Drasu:AwAICAgABAoAAA==.Drewsoario:AwADCAQABAoAAA==.Drewstormio:AwADCAMABAoAAQgAAAADCAQABAo=.Drohgba:AwAFCAcABAoAARUAUXMCCAMABRQ=.',Ds='Dsdh:AwACCAIABRQCFgAIAQjfBABauz0DBAoAFgAIAQjfBABauz0DBAoAAA==.',Du='Dulang:AwAGCAkABAoAAA==.',Dy='Dying:AwACCAMABAoAAA==.',Ec='Ectruby:AwACCAIABRQCFwAIAQiQAwA+hp8CBAoAFwAIAQiQAwA+hp8CBAoAAA==.',El='Elertricsoup:AwAECAgABAoAAA==.Elnoch:AwACCAIABAoAAA==.Elyndre:AwAECAcABRQCBgAEAQjKAQArqUsBBRQABgAEAQjKAQArqUsBBRQAAA==.',En='Endari:AwAECAkABRQEAwAEAQjFAABPEckABRQAAgACAQi5BQBdytcABRQAAwACAQjFAABFqskABRQAAQABAQhlCABT2F0ABRQAAA==.',Fa='Faeia:AwADCAQABRQCGAAIAQjCBgBLx50CBAoAGAAIAQjCBgBLx50CBAoAAA==.Faenirel:AwADCAMABAoAAQgAAAAHCA8ABAo=.Faeya:AwADCAgABAoAARgAS8cDCAQABRQ=.Fathersev:AwACCAMABAoAAA==.',Fe='Felanger:AwAFCAsABAoAAA==.',Fl='Fluxa:AwADCAUABAoAAA==.',Fr='Frodolol:AwADCAgABRQDEQADAQjJBwA/hAcBBRQAEQADAQjJBwA/hAcBBRQADQABAQipCQBCvkQABRQAAA==.Frostik:AwABCAEABRQCGQAIAQhQAwBcdDUDBAoAGQAIAQhQAwBcdDUDBAoAAA==.Frostyfruit:AwAGCBEABAoAAA==.',Fy='Fya:AwAECAkABAoAAA==.',Gr='Graoul:AwAECAcABAoAAA==.Greemlin:AwADCAoABRQCGgADAQilAwBE+QUBBRQAGgADAQilAwBE+QUBBRQAAA==.Grindelwald:AwAECAcABAoAAA==.Gryffin:AwAGCBEABAoAAA==.',Gu='Guangtou:AwABCAEABRQAAA==.Guiltyclown:AwAECAoABAoAAA==.Gunnina:AwAECAgABAoAAA==.',Hi='Hierophant:AwACCAIABAoAAQgAAAADCAMABAo=.Hiradaira:AwAECAoABRQCEQAEAQhXBAA2uEUBBRQAEQAEAQhXBAA2uEUBBRQAAA==.',Ho='Hopeless:AwAGCAwABAoAAA==.Hothotseckz:AwAFCAgABAoAAA==.',Hw='Hwhisashaman:AwABCAEABRQAAA==.',Ia='Ial:AwAFCA0ABAoAAA==.',Im='Imthebaglady:AwAICAkABAoAAA==.',Is='Isadrag:AwAGCAgABAoAAA==.Ish:AwAICBEABAoAAA==.Isvelte:AwAICAgABAoAAA==.',Je='Jeymeister:AwABCAEABRQAAA==.',Jo='Joeru:AwADCAkABAoAAA==.Johnthemonk:AwAHCA4ABAoAAA==.Jombii:AwAGCAYABAoAAA==.',Ju='Justbrew:AwAICA4ABAoAAA==.Justwings:AwAICBYABAoCBAAIAQjMNQAwRwcCBAoABAAIAQjMNQAwRwcCBAoAAA==.',Ka='Kayapau:AwACCAMABRQCGwAIAQibBwBNOMECBAoAGwAIAQibBwBNOMECBAoAAA==.',Ke='Ketupaat:AwAGCA4ABAoAAA==.Kevp:AwAFCAkABRQCBwAFAQgrAAA+7q8BBRQABwAFAQgrAAA+7q8BBRQAAA==.Kevpal:AwAHCAcABAoAAQcAPu4FCAkABRQ=.',Ko='Kopikia:AwAECAgABAoAAA==.',Kt='Ktl:AwAFCAIABAoAAA==.Kts:AwAECAMABAoAAQgAAAAFCAIABAo=.',Ky='Kyallr:AwAHCBYABAoCGgAHAQgFEwA8/gkCBAoAGgAHAQgFEwA8/gkCBAoAAA==.',Le='Lekunt:AwAICAgABAoAAA==.Lettuce:AwABCAIABRQCEAAHAQiMDABbcK8CBAoAEAAHAQiMDABbcK8CBAoAAA==.',Li='Littlehill:AwAGCAsABAoAAA==.Littleone:AwACCAQABRQCBwAHAQhjEABG7xgCBAoABwAHAQhjEABG7xgCBAoAARgAUj4ECAwABRQ=.',Lo='Lokomoko:AwAFCAcABAoAAA==.',Ly='Lyndra:AwABCAEABRQAAQYAK6kECAcABRQ=.',Ma='Maktann:AwAECAgABAoAAA==.',Me='Medisave:AwABCAEABRQAAQ0AQoACCAMABRQ=.Megadeath:AwABCAEABRQDGQAHAQj1GQA3n+8BBAoAGQAHAQj1GQA3n+8BBAoAHAAFAQiFEQAoWQoBBAoAAA==.Meku:AwAFCAcABAoAAA==.Melondawize:AwAICBEABAoAAA==.Meulah:AwAICAgABAoAAA==.Mezzy:AwAFCA4ABAoAAA==.',Mi='Miaomiaomiao:AwAECAwABRQCGAAEAQh5AABSPoUBBRQAGAAEAQh5AABSPoUBBRQAAA==.Mikäsa:AwACCAUABRQCFgACAQgvCwAukaUABRQAFgACAQgvCwAukaUABRQAAA==.Minamai:AwAECAoABAoAAA==.',Mo='Mooncakè:AwAHCAcABAoAAA==.Mousemarâ:AwAGCBEABAoAAA==.',Mu='Mugahtoo:AwAFCAUABAoAAA==.',Na='Nalska:AwADCAUABAoAAA==.',Ne='Necroticlol:AwACCAQABRQCGQAIAQhpAgBcFksDBAoAGQAIAQhpAgBcFksDBAoAAA==.Necroticlól:AwABCAEABRQAARkAXBYCCAQABRQ=.Nemovc:AwAECAgABAoAAA==.',Ni='Nightmovie:AwAFCAUABAoAAA==.',No='Nocchii:AwAECAkABAoAAA==.Notwiththêm:AwAGCBEABAoAAA==.Novis:AwAGCA0ABAoAAA==.',Nt='Ntdracarys:AwAGCA4ABAoAAA==.Nthope:AwABCAEABRQDHQAIAQi9CgBMgk4CBAoAHQAIAQi9CgA8XU4CBAoABwAHAQhsDwBKBSUCBAoAAA==.',On='Onlyhead:AwAECAMABAoAAA==.',Op='Oppanitystyl:AwAECAcABAoAAA==.',Pa='Pamie:AwAECAcABAoAAQgAAAAGCAYABAo=.',Pe='Peach:AwAECAQABAoAAQgAAAAGCAYABAo=.Petiina:AwACCAQABAoAAA==.',Ph='Phofor:AwAICBAABAoAAA==.',Po='Powerangers:AwACCAQABAoAAA==.',Pr='Prefmonk:AwAECAQABAoAAA==.Prodigal:AwAICBsABAoCHgAIAQjhFgAhDEUBBAoAHgAIAQjhFgAhDEUBBAoAAA==.',Ps='Psilocybin:AwAGCAYABAoAAA==.',Pu='Punshockable:AwEICBUABAoDHwAIAQgsEQBG8BcCBAoAGgAHAQhBEQBAhyICBAoAHwAFAQgsEQBenRcCBAoAAA==.',Pw='Pwndis:AwADCAUABAoAAA==.',Py='Pyroorc:AwAFCAIABAoAAA==.',Qh='Qhira:AwACCAIABRQDFQAIAQiFBQBfxkEDBAoAFQAIAQiFBQBfxkEDBAoAIAAFAQjAJAAm8NYABAoAAA==.',Ra='Raynoriel:AwAICAgABAoAAA==.',Re='Reindart:AwAECAUABAoAAA==.Restinpieces:AwAECAQABAoAAA==.',Ru='Rukkzh:AwAECAgABAoAAA==.Ruptured:AwACCAIABAoAAA==.',Sa='Sancbrew:AwADCAUABAoAAA==.',Se='Sendmegold:AwAFCAkABAoAAA==.',Sh='Shadowi:AwAHCAcABAoAAQMATxEECAkABRQ=.Shamdoy:AwAFCAsABAoAAA==.Shardsoffury:AwAHCBYABAoCHwAHAQjLFAA5fuUBBAoAHwAHAQjLFAA5fuUBBAoAAA==.Shidann:AwAECAkABRQCEAAEAQjCAABWZ5cBBRQAEAAEAQjCAABWZ5cBBRQAAA==.Shintopal:AwAFCAwABAoAAA==.Shiwann:AwACCAIABRQAARAAVmcECAkABRQ=.',Si='Sigourney:AwAGCA0ABAoAAA==.Silkwood:AwAGCA4ABAoAAA==.Sindrust:AwAGCAIABAoAAA==.Single:AwABCAIABRQAAA==.Sinorph:AwADCAQABAoAAQgAAAAGCAIABAo=.Sixy:AwAHCAcABAoAAQgAAAABCAEABRQ=.',Sn='Sneakyitch:AwADCAgABAoAAA==.Snowflake:AwAFCA0ABAoAAA==.',So='Soil:AwACCAUABRQCCwACAQjfAQBND60ABRQACwACAQjfAQBND60ABRQAAA==.Soka:AwADCAUABAoAAA==.Songfíre:AwAECAkABAoAAA==.',St='Stan:AwAECAsABRQCFQAEAQg6AgBMqW4BBRQAFQAEAQg6AgBMqW4BBRQAAA==.Stanstan:AwAGCAEABAoAARUATKkECAsABRQ=.Stanstanstan:AwAGCAkABAoAARUATKkECAsABRQ=.',Su='Superchaos:AwAFCAEABAoAAA==.Superfly:AwAECAEABAoAAA==.Sutiao:AwAECAgABRQDDQAEAQiYAQBQbM4ABRQAEQADAQjJBgBLeRkBBRQADQACAQiYAQBfAs4ABRQAAA==.Suvannah:AwAICBgABAoCGAAIAQi6FwAmfaIBBAoAGAAIAQi6FwAmfaIBBAoAAA==.',Sw='Swissknife:AwAGCAwABAoAAA==.',['S�']='Sìlverhunter:AwAECAQABAoAAA==.',Ta='Taurium:AwAHCBcABAoEBAAHAQgIaAAXhE8BBAoABAAHAQgIaAAXhE8BBAoACgADAQhTJAAuIZ8ABAoACQACAQjsNwAKBjUABAoAAA==.',Th='Thumpelina:AwAECAkABAoAAA==.',Tj='Tj:AwAECAcABAoAAA==.',To='Tommyh:AwAECAwABRQCBQAEAQivAABWXKUBBRQABQAEAQivAABWXKUBBRQAAA==.Totemistyk:AwAGCAEABAoAAA==.',Tr='Treantbag:AwAFCAcABAoAAA==.',Ts='Tsukukomi:AwACCAQABRQEFwAIAQhuAwBUW6YCBAoAFwAHAQhuAwBS5KYCBAoAEAADAQhfPQBH9wIBBAoAIQADAQiZDwAygpkABAoAAA==.',Ty='Tyranadia:AwACCAIABRQCGQAIAQhYDABJJ4wCBAoAGQAIAQhYDABJJ4wCBAoAAA==.',Va='Varnoxx:AwACCAIABRQCIgAIAQhiBwBM+JECBAoAIgAIAQhiBwBM+JECBAoAAA==.',Ve='Vehemence:AwAICBsABAoCBAAIAQgxGwBErZECBAoABAAIAQgxGwBErZECBAoAAA==.',Vi='Vip:AwAGCAYABAoAAA==.',Vn='Vnex:AwACCAIABRQCCgAIAQhCCgA1Xg4CBAoACgAIAQhCCgA1Xg4CBAoAAA==.',Wo='Wongtaisin:AwACCAMABRQCDQAIAQjJDABCgG4CBAoADQAIAQjJDABCgG4CBAoAAA==.',Xe='Xemmy:AwADCAMABAoAAA==.Xeph:AwADCAMABAoAAQgAAAABCAIABRQ=.',Xt='Xtion:AwACCAIABRQCIAAIAQiBAwBTrOgCBAoAIAAIAQiBAwBTrOgCBAoAAA==.',Yo='Yongbok:AwADCAQABAoAAA==.',Za='Zaloviee:AwAICBsABAoCCwAIAQghAwBHp5gCBAoACwAIAQghAwBHp5gCBAoAAA==.Zaraxes:AwAFCAgABAoAAA==.',Ze='Zenõ:AwECCAQABRQAAREAMhwCCAUABRQ=.',Zi='Zips:AwAFCA8ABAoAAA==.Zivda:AwAGCAsABAoAAA==.',['Z�']='Zéno:AwECCAUABRQCEQACAQgCEQAyHJAABRQAEQACAQgCEQAyHJAABRQAAA==.',['ß']='ßlüé:AwADCAMABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end