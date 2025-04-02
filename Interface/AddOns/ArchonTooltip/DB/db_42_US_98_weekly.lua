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
 local lookup = {'Shaman-Restoration','Unknown-Unknown','Warrior-Arms','DemonHunter-Vengeance','Paladin-Retribution','Paladin-Holy','Monk-Mistweaver','Shaman-Elemental','DemonHunter-Havoc','Hunter-BeastMastery','Evoker-Devastation','Warrior-Protection','DeathKnight-Frost','DeathKnight-Unholy','Priest-Discipline','Priest-Holy','Druid-Balance','Druid-Restoration','Druid-Feral','Hunter-Survival','Monk-Windwalker','Warlock-Destruction','Mage-Frost','Mage-Arcane','Rogue-Subtlety','Priest-Shadow','Rogue-Outlaw','Shaman-Enhancement','Warrior-Fury','Warlock-Demonology','Warlock-Affliction','Mage-Fire',}; local provider = {region='US',realm='Frostmane',name='US',type='weekly',zone=42,date='2025-03-29',data={Ac='Acethepirate:AwADCAIABAoAAA==.',Ad='Advacus:AwABCAEABRQAAA==.',Al='Aletriss:AwACCAIABAoAAA==.Alexsham:AwABCAIABRQCAQAIAQilBQBQ8eoCBAoAAQAIAQilBQBQ8eoCBAoAAA==.',Am='Amnorpse:AwAECAQABAoAAA==.',An='Analori:AwAICAgABAoAAA==.',Ar='Arvenor:AwAGCAsABAoAAA==.',At='Atheristina:AwAECAcABAoAAQIAAAAFCAMABAo=.Atroce:AwAGCAoABAoAAA==.',Aw='Awnen:AwABCAEABAoAAA==.',Ax='Axes:AwADCAUABRQCAwADAQiuAABKnS4BBRQAAwADAQiuAABKnS4BBRQAAA==.',Be='Belialz:AwAHCBcABAoCBAAHAQjLEwAsiHcBBAoABAAHAQjLEwAsiHcBBAoAAA==.',Bi='Bigolcrities:AwAHCBEABAoAAA==.',Bl='Blisstinaz:AwAFCAkABAoAAA==.Blt:AwAICAMABAoAAA==.',Bo='Bohvicce:AwAFCAYABAoAAA==.Boomo:AwAFCAEABAoAAA==.Boutdatbass:AwACCAIABAoAAA==.',Bu='Buttermeupz:AwAHCBcABAoDBQAHAQhYXAAibIIBBAoABQAHAQhYXAAibIIBBAoABgABAQhjNwAAbwsABAoAAA==.',Ch='Chijisus:AwAICAEABAoAAQYAL7YDCAUABRQ=.',Co='Colagirl:AwABCAEABAoAAA==.Cornish:AwABCAIABRQCBwAIAQjrCQBMk6QCBAoABwAIAQjrCQBMk6QCBAoAAA==.',Cr='Critsncaps:AwAICAgABAoAAQgARpICCAQABRQ=.',Cu='Culdadrink:AwAECAMABAoAAA==.Curserodlock:AwAECAQABAoAAA==.Cutsman:AwABCAEABRQAAA==.',Da='Dabbinshamin:AwAFCAgABAoAAA==.Daddiest:AwAECAQABAoAAQIAAAABCAEABRQ=.Dads:AwABCAEABRQAAA==.Dakeyras:AwAGCAsABAoAAA==.Darcshaman:AwAICBwABAoCAQAIAQj9BwBRKMACBAoAAQAIAQj9BwBRKMACBAoAAA==.',De='Decynth:AwADCAcABAoAAA==.Demodorn:AwAICCMABAoDBAAIAQh2FQArI2EBBAoACQAGAQiEOQAhP2UBBAoABAAGAQh2FQAxxWEBBAoAAA==.Demonicapple:AwABCAEABAoAAA==.Denszel:AwAGCAYABAoAAA==.',Di='Disengage:AwADCAQABRQCCgAIAQjxAgBhK2MDBAoACgAIAQjxAgBhK2MDBAoAAA==.Disruptive:AwABCAEABAoAAA==.',Do='Dobby:AwAFCAwABAoAAA==.',Ev='Evion:AwAECAUABAoAAA==.Evoiga:AwABCAEABRQCCwAIAQhVDQBA0zQCBAoACwAIAQhVDQBA0zQCBAoAAA==.',Fo='Foxyjen:AwACCAIABAoAAA==.',Fr='Freebandz:AwABCAIABRQAAA==.',['F�']='Fáelen:AwAFCAoABAoAAA==.',Ga='Galø:AwACCAQABRQCDAAIAQjJBgA12voBBAoADAAIAQjJBgA12voBBAoAAA==.',Ge='Gep:AwAHCBMABAoAAA==.',Gi='Gibbleh:AwAICAgABAoAAA==.Girthfury:AwAICAIABAoAAQYAL7YDCAUABRQ=.',Go='Goobman:AwADCAQABAoAAQIAAAAHCAkABAo=.',Gr='Gravykin:AwACCAIABAoAAA==.Grishy:AwAICAIABAoAAQoAYSsDCAQABRQ=.Gromulous:AwACCAIABAoAAA==.',Ha='Hairloss:AwAGCAoABAoAAA==.Handofnature:AwAGCAQABAoAAA==.Hazblubulls:AwAICAgABAoAAA==.',He='Heiny:AwAHCBUABAoDDQAHAQhJAgBez+8CBAoADQAHAQhJAgBez+8CBAoADgAFAQiwMwBGFDEBBAoAAA==.',Ho='Holytest:AwABCAEABRQDDwAIAQjJBgBC36gCBAoADwAIAQjJBgBCWagCBAoAEAAEAQjpLgBFxiIBBAoAAA==.',Hy='Hypocrisy:AwAICBAABAoAAA==.',Id='Idotyouto:AwAFCAIABAoAAA==.',Il='Illidrag:AwAICBcABAoCCQAIAQhPFwA6umMCBAoACQAIAQhPFwA6umMCBAoAAA==.',Im='Immørtlzed:AwADCAQABRQCAQAIAQgUAABjsJEDBAoAAQAIAQgUAABjsJEDBAoAAA==.',Ir='Ironboxy:AwAICAcABAoAAA==.',Ja='Jadeclaw:AwAGCAQABAoAAA==.Jarlraven:AwAICBcABAoDEQAIAQhlFwA6ZDcCBAoAEQAIAQhlFwA6ZDcCBAoAEgAHAQjMKwAM9QgBBAoAAA==.Jaxek:AwACCAYABRQCEwACAQgSAQBVRc0ABRQAEwACAQgSAQBVRc0ABRQAAA==.',Je='Jeanne:AwAGCAMABAoAAA==.',Jo='Jopha:AwADCAUABRQCAwADAQi9AABE5ysBBRQAAwADAQi9AABE5ysBBRQAAA==.',Ju='Jumpn:AwABCAEABRQAAA==.Justgetme:AwAHCAEABAoAAA==.',Ka='Kainchaiwind:AwAGCAsABAoAAA==.Kalisti:AwAECAoABAoAAA==.Kalloh:AwAFCAoABAoAAA==.Kardoroth:AwAECAcABAoAAA==.Kariss:AwADCAEABAoAAQIAAAAFCAMABAo=.Karîba:AwACCAMABRQCDgAIAQj4AgBdYUMDBAoADgAIAQj4AgBdYUMDBAoAAA==.',Ke='Keelle:AwAHCA0ABAoAAA==.Keinari:AwAFCAoABAoAAA==.Kelsaz:AwACCAQABRQDCgAIAQgzCQBYoRwDBAoACgAIAQgzCQBYoRwDBAoAFAAFAQgbCAA+oBIBBAoAAA==.Kelsi:AwAHCBUABAoCFQAHAQivFAA6cesBBAoAFQAHAQivFAA6cesBBAoAAA==.Kerrìgàn:AwABCAMABRQDCQAHAQgEHABCGDsCBAoACQAHAQgEHABCGDsCBAoABAACAQgFOgAZOkoABAoAAA==.',Ko='Kookiie:AwACCAIABRQCCQAIAQh4CQBWe/4CBAoACQAIAQh4CQBWe/4CBAoAAA==.',Kr='Krall:AwABCAEABAoAAA==.Kromdor:AwABCAEABRQCFgAHAQhsHgA7oPUBBAoAFgAHAQhsHgA7oPUBBAoAAA==.',Ku='Kup:AwAECAkABAoAAA==.',La='Larra:AwABCAEABRQAAA==.',Le='Legoyoda:AwAECAQABAoAAA==.Leman:AwAFCA8ABAoAAA==.Levitas:AwAECAEABAoAAA==.Leyahna:AwABCAEABAoAAQIAAAABCAEABRQ=.',Li='Lilienna:AwABCAEABRQAAA==.Liljit:AwAECAcABAoAAA==.',Lo='Lockxeno:AwAGCA0ABAoAAA==.Logical:AwABCAEABRQCEwAIAQiuBAA9M20CBAoAEwAIAQiuBAA9M20CBAoAAA==.Lon:AwAECAEABAoAAA==.Longsham:AwAFCAkABAoAAA==.Lostvoker:AwACCAIABRQCCwAIAQiMCQBIvIMCBAoACwAIAQiMCQBIvIMCBAoAAA==.Louieballz:AwADCAYABAoAAA==.',Ly='Lyntara:AwAGCBAABAoAAA==.',Ma='Maddelyn:AwADCAQABRQDFwAIAQg4AgBex0kDBAoAFwAIAQg4AgBex0kDBAoAGAACAQh9CwAxx2QABAoAAA==.Magewreck:AwAFCAkABAoAAA==.Mapp:AwACCAMABAoAAA==.Mazur:AwAICAgABAoAAA==.',Me='Melaan:AwAFCAMABAoAAA==.',Mo='Moarass:AwAGCAQABAoAAA==.Morgor:AwACCAIABAoAAA==.Morguth:AwABCAEABRQAAA==.',Mu='Muggy:AwAGCAoABAoAAA==.Murky:AwAECAgABAoAAA==.',My='Myssa:AwEBCAIABRQCBAAIAQhbAwBTE+QCBAoABAAIAQhbAwBTE+QCBAoAAA==.',Ne='Neoma:AwACCAQABAoAAA==.',No='Noobletstomp:AwABCAEABRQAAA==.Norex:AwABCAEABRQAAA==.',Nu='Nuggie:AwAFCAsABAoAAA==.',Ny='Nymia:AwAFCAsABAoAAA==.',Ol='Oldmagic:AwAECAIABAoAAA==.',Oo='Ooglaboogla:AwAHCBUABAoDCAAHAQgkEwBQYAoCBAoACAAGAQgkEwBQsAoCBAoAAQADAQjCUgAs5LkABAoAAA==.',Pa='Pandra:AwAGCBEABAoAAA==.Panzeria:AwAICBAABAoAAA==.Pathruz:AwAFCAYABAoAAA==.',Pl='Plzsaveme:AwADCAMABAoAAA==.',Po='Popavlad:AwABCAEABRQAAA==.',Ra='Rainbowpally:AwAICBMABAoAAA==.Ramaan:AwAGCAEABAoAAA==.Ramble:AwAFCAoABAoAAA==.Ravette:AwAHCBUABAoCCQAHAQhIHgBARygCBAoACQAHAQhIHgBARygCBAoAAA==.',Re='Reach:AwABCAIABRQCGQAIAQiHCwA2XkICBAoAGQAIAQiHCwA2XkICBAoAAA==.Reveurus:AwAFCAsABAoAAA==.',Ri='Riceroll:AwABCAEABAoAAA==.',Ru='Rupertedh:AwADCAUABRQCBAADAQiHAQBCF/MABRQABAADAQiHAQBCF/MABRQAAA==.',Ry='Ryddian:AwAECAgABAoAAA==.Ryteousvigor:AwAFCAkABAoAAQgARpICCAQABRQ=.',Sa='Samwìse:AwABCAEABRQDEAAIAQhsCgBHEXICBAoAEAAIAQhsCgBHEXICBAoAGgACAQglRwAW0D4ABAoAAA==.Sareina:AwAFCAUABAoAAA==.',Sc='Scarlla:AwAFCAoABAoAAA==.Scire:AwABCAEABAoAAA==.',Se='Sereinee:AwABCAEABAoAAA==.',Sh='Shambam:AwAFCAEABAoAAQkAQhgBCAMABRQ=.Shaqira:AwAFCAkABAoAAA==.Shuttle:AwACCAIABRQDGwAIAQgsAgBLJmYCBAoAGQAIAQhCCQBHLXUCBAoAGwAIAQgsAgBBFmYCBAoAAA==.Sháo:AwABCAEABAoAAQIAAAAHCBIABAo=.',Si='Silmarils:AwAFCAsABAoAAA==.Sinswrath:AwACCAIABRQCBQAIAQh4EwBZpNICBAoABQAIAQh4EwBZpNICBAoAAA==.',Sl='Slaye:AwAFCAsABAoAAA==.',Sm='Smrts:AwABCAEABRQAAA==.',Sn='Snaccident:AwABCAIABRQCCwAHAQgBGgAZDWABBAoACwAHAQgBGgAZDWABBAoAAA==.Snaccidentev:AwACCAIABAoAAA==.Sneakyteeth:AwAGCAsABAoAAA==.Sneedragosa:AwABCAEABAoAAA==.',So='Songi:AwAFCAsABAoAAA==.Soulwhisper:AwADCAUABRQCDgADAQimAwA3cfoABRQADgADAQimAwA3cfoABRQAAA==.',Sp='Spyrodruid:AwAGCBAABAoAAA==.',Sq='Sqwhirly:AwAECAQABAoAAA==.',St='Störmblessed:AwAFCAYABAoAAA==.',Su='Sugarblast:AwABCAEABRQCHAAIAQjqBABVWgUDBAoAHAAIAQjqBABVWgUDBAoAAA==.Sunadoria:AwAGCA0ABAoAAA==.Suou:AwABCAEABRQAAA==.Supadupafly:AwAHCAEABAoAAQIAAAAHCBEABAo=.Supafly:AwAHCBEABAoAAA==.',Sv='Svekke:AwAICAYABAoAAA==.',Sw='Swifting:AwAGCAsABAoAAA==.',Ta='Tacoss:AwABCAEABAoAAA==.Tannyphantom:AwAHCBIABAoAAA==.',Te='Texastacô:AwACCAQABAoAAA==.',Th='Thunderbut:AwACCAIABAoAAA==.Thundermist:AwABCAEABRQDFQAIAQhPEwA0sP8BBAoAFQAHAQhPEwA5m/8BBAoABwADAQjYUwAN9nUABAoAAA==.',Ti='Tippsi:AwABCAEABRQCHQAHAQixDQBVEJMCBAoAHQAHAQixDQBVEJMCBAoAAA==.Tirent:AwAICBgABAoEFgAIAQi0FQBIzT0CBAoAFgAHAQi0FQBOAj0CBAoAHgACAQiNJwBG4K0ABAoAHwABAQhQKAAaC0AABAoAAA==.',Tr='Tranq:AwABCAEABAoAAA==.Traylay:AwABCAEABRQAAA==.',Tt='Ttocs:AwAICAQABAoAAA==.',Tu='Tujori:AwADCAUABRQCDwADAQi/BAAnIN8ABRQADwADAQi/BAAnIN8ABRQAAA==.',Tw='Twherk:AwADCAUABRQDBgADAQjFBAAvtpkABRQABgACAQjFBAAz7JkABRQABQABAQjSJAAA/DgABRQAAA==.Twinmoonfury:AwAGCA8ABAoAAA==.Twobit:AwABCAEABAoAAA==.',['T�']='Tîtån:AwAHCBIABAoAAA==.',Ug='Uglydorf:AwAGCAwABAoAAA==.',Ve='Vectoronie:AwAFCAgABAoAAA==.Verion:AwACCAIABAoAAA==.',Vo='Vodka:AwAFCAkABAoAAA==.',Wa='Warhéad:AwAHCA8ABAoAAA==.Warm:AwADCAUABAoAAA==.Waterbôy:AwABCAIABRQCHAAIAQg5CABMNcUCBAoAHAAIAQg5CABMNcUCBAoAAA==.',We='Weissbrew:AwAECAQABAoAAA==.',Wh='Whoasked:AwABCAIABRQAAA==.',Wo='Wourthe:AwAGCAUABAoAAA==.',Wt='Wtfheal:AwAICBEABAoAAQYAL7YDCAUABRQ=.',Xa='Xanistra:AwABCAEABRQAAA==.',Ya='Yahyah:AwAHCBgABAoCDwAHAQiAEQA67+wBBAoADwAHAQiAEQA67+wBBAoAAA==.',Ys='Yscaarj:AwAICBwABAoCGgAIAQhwDgA8N04CBAoAGgAIAQhwDgA8N04CBAoAAA==.',Za='Zakuro:AwAECAMABAoAAA==.Zaszadin:AwEBCAEABRQCBQAIAQj9DQBXwQADBAoABQAIAQj9DQBXwQADBAoAAA==.',Ze='Zerax:AwAFCAsABAoAAA==.Zexs:AwACCAIABAoAAA==.',Zo='Zoìdberg:AwAFCAUABAoAAA==.',Zy='Zysko:AwAFCAoABAoAAA==.',Zz='Zzor:AwABCAEABRQEIAAIAQgcFwBUe14CBAoAIAAIAQgcFwBJEV4CBAoAGAAFAQiaAwBJqJUBBAoAFwACAQiPSABZGMEABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end