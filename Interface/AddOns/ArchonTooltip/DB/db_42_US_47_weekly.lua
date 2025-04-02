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
 local lookup = {'Priest-Shadow','Warlock-Affliction','Warrior-Arms','Warrior-Fury','Warlock-Destruction','Druid-Balance','Mage-Frost','Hunter-Survival','Mage-Arcane','Hunter-BeastMastery','Mage-Fire','Unknown-Unknown','DemonHunter-Vengeance','DeathKnight-Unholy','Priest-Discipline','Priest-Holy','Paladin-Retribution','DeathKnight-Blood','DemonHunter-Havoc','Shaman-Restoration','Druid-Restoration','Rogue-Assassination','Druid-Feral','Shaman-Enhancement','Hunter-Marksmanship','Evoker-Devastation','Evoker-Preservation','Rogue-Subtlety','Paladin-Protection','Monk-Mistweaver','Monk-Windwalker','Druid-Guardian','Warlock-Demonology','Warrior-Protection',}; local provider = {region='US',realm='BurningLegion',name='US',type='weekly',zone=42,date='2025-03-28',data={Ad='Aderren:AwAGCA0ABAoAAA==.',Ae='Aevella:AwAHCAgABAoAAQEAUvsBCAEABRQ=.',Ag='Agidan:AwAGCA4ABAoAAA==.',Al='Alizar:AwAGCAkABAoAAA==.',An='Ancalime:AwACCAMABRQCAgAIAQhcAQBNf7gCBAoAAgAIAQhcAQBNf7gCBAoAAA==.Andromeda:AwABCAIABAoAAA==.Anduinlothar:AwABCAEABRQCAwAIAQgtAwBULfkCBAoAAwAIAQgtAwBULfkCBAoAAA==.Anthal:AwAICAgABAoAAA==.Anthreas:AwAGCBEABAoAAA==.',Ar='Argorok:AwAHCAMABAoAAA==.Armous:AwACCAIABAoAAA==.Arrano:AwABCAEABRQDAwAIAQhHDQBVCA8CBAoAAwAFAQhHDQBbNw8CBAoABAAFAQguJABEUqMBBAoAAA==.Arzuros:AwAFCAwABAoAAA==.',Ba='Baconarrow:AwAICA4ABAoAAA==.Bagpipe:AwAICAgABAoAAA==.Bannthis:AwAGCAEABAoAAA==.',Be='Beanse:AwAHCBIABAoAAA==.Belladonna:AwADCAMABRQCBQAIAQihCgBICq0CBAoABQAIAQihCgBICq0CBAoAAA==.',Bi='Bigones:AwAICBsABAoCBgAIAQgGHAArzvwBBAoABgAIAQgGHAArzvwBBAoAAA==.',Bl='Blinksoncd:AwABCAEABRQCBwAHAQjtDgBJmFICBAoABwAHAQjtDgBJmFICBAoAAA==.Bloodbott:AwAGCA0ABAoAAA==.Bloodrainer:AwAHCBMABAoAAA==.Blutregen:AwACCAMABAoAAQgAIR4GCBYABAo=.',Bo='Bobfriskit:AwAHCBUABAoCCQAHAQj9AQA/5RgCBAoACQAHAQj9AQA/5RgCBAoAAA==.Boot:AwABCAEABRQCCgAIAQijIQA8mkACBAoACgAIAQijIQA8mkACBAoAAA==.Bowlcut:AwAECAkABRQDCwAEAQjhBAA0yDwBBRQACwAEAQjhBAA0yDwBBRQABwABAQh1CQBATUUABRQAAA==.',Br='Bradshoona:AwAHCBMABAoAAA==.Braedron:AwABCAEABAoAAQwAAAAGCBIABAo=.',Bu='Buroode:AwAGCBYABAoDCAAGAQhABwAhHiIBBAoACAAGAQhABwAhHiIBBAoACgABAQj/sAAaHykABAoAAA==.',['B�']='Bèat:AwADCAMABRQCDQAIAQi0AwBP9NECBAoADQAIAQi0AwBP9NECBAoAAA==.',Ch='Chazberry:AwABCAIABRQCDgAIAQguDwBEtmECBAoADgAIAQguDwBEtmECBAoAAA==.Cheekblaster:AwACCAEABAoAAA==.Chronalys:AwAGCAYABAoAAA==.',Ci='Cialis:AwABCAEABRQDDwAHAQg7GwAnwG4BBAoADwAHAQg7GwAnwG4BBAoAEAACAQjmVQANQlQABAoAAA==.Cillocybin:AwACCAIABAoAAREALY8GCBQABAo=.',Cl='Clöüdÿ:AwAFCAkABAoAAA==.',Co='Cocoraptor:AwAFCAUABAoAAA==.Cologa:AwAICB0ABAoCAQAIAQhVDwA5gDYCBAoAAQAIAQhVDwA5gDYCBAoAAA==.Comfypants:AwAHCAcABAoAAA==.Congruentz:AwACCAMABAoAAA==.Coola:AwAFCAkABAoAAA==.',Da='Darkaunnas:AwAECAkABAoAAA==.',De='Deathchamp:AwACCAQABRQCEgAIAQhrAgBbTTQDBAoAEgAIAQhrAgBbTTQDBAoAAA==.Declan:AwAGCAwABAoAAA==.Demonetizer:AwACCAcABRQCEwACAQhDCQBFI7gABRQAEwACAQhDCQBFI7gABRQAAA==.Denniecrane:AwEDCAMABRQCFAAIAQhPBABWUgEDBAoAFAAIAQhPBABWUgEDBAoAAA==.',Do='Doominique:AwABCAEABAoAAA==.Dotty:AwADCAQABAoAAA==.Dozo:AwABCAEABRQCFAAIAQidCABM+rACBAoAFAAIAQidCABM+rACBAoAAA==.',Dr='Draotan:AwABCAEABAoAAA==.Dreygor:AwAGCA8ABAoAAA==.',Dw='Dwayne:AwACCAEABAoAAA==.',['D�']='Dürn:AwAGCBQABAoCEQAGAQgaYgAtj2EBBAoAEQAGAQgaYgAtj2EBBAoAAA==.',El='Eldarin:AwAFCAoABAoAAA==.Elintha:AwAFCAkABAoAAA==.Ellja:AwAFCAkABAoAAA==.Ellwine:AwADCAEABAoAAA==.',Em='Emmahotson:AwACCAMABRQDFQAIAQg/HgAcBWYBBAoAFQAIAQg/HgAcBWYBBAoABgACAQgfZgAJ/0EABAoAAA==.',Er='Eriborn:AwADCAYABAoAAA==.',Es='Escaflowne:AwACCAMABRQCEQAIAQiQBwBaCzYDBAoAEQAIAQiQBwBaCzYDBAoAAA==.',Ev='Evanator:AwADCAEABAoAAA==.Evilin:AwABCAEABAoAAA==.',Fa='Faithe:AwAICBAABAoAAA==.',Fe='Felbeard:AwACCAQABRQCBQAIAQhNAwBaaSUDBAoABQAIAQhNAwBaaSUDBAoAAQUASAoDCAMABRQ=.',Fi='Fingoflin:AwAFCAUABAoAAA==.',Fl='Fleakertwo:AwABCAIABRQCFgAIAQjvCQAxqR8CBAoAFgAIAQjvCQAxqR8CBAoAAA==.',Fo='Foddercannon:AwAGCAYABAoAAA==.',Fr='Friedrib:AwACCAcABRQDFwACAQiyAQAyyqwABRQAFwACAQiyAQAyyqwABRQAFQABAQipDwAFeTYABRQAAA==.Frostybuds:AwABCAEABAoAAA==.',Ga='Gangsta:AwAGCAkABAoAAA==.',Ge='Genaveive:AwABCAEABRQAAA==.',Gh='Ghazat:AwAGCBIABAoAAA==.',Gi='Gilgi:AwABCAEABAoAAA==.',Gn='Gnelf:AwABCAEABAoAAA==.',Go='Gobbylynn:AwABCAEABRQCAQAIAQg9BwBS+8sCBAoAAQAIAQg9BwBS+8sCBAoAAA==.',Gw='Gwisztaxman:AwAECAkABAoAAA==.Gwiszz:AwABCAEABAoAAQwAAAAECAkABAo=.',Ha='Hakuzami:AwAGCAYABAoAAA==.Halrath:AwAFCAsABAoAAA==.',He='Healah:AwAFCAEABAoAAA==.Hegotthedrip:AwADCAYABRQCBQADAQiRBAA2LPEABRQABQADAQiRBAA2LPEABRQAAA==.Hellscarred:AwAFCAUABAoAAQwAAAAGCAUABAo=.',Hi='Hijackpneuma:AwADCAkABAoAAQwAAAAGCAkABAo=.Hinotama:AwAGCBAABAoAAA==.',Ho='Holdthatthot:AwAGCBUABAoCGAAGAQgpGAA4Db4BBAoAGAAGAQgpGAA4Db4BBAoAAA==.Holynova:AwAFCAkABAoAAA==.Hovy:AwAFCAwABAoAAA==.',Hu='Humanpaladin:AwABCAIABAoAAA==.',Hy='Hyhu:AwAGCBQABAoCGQAGAQhvCQBdRUcCBAoAGQAGAQhvCQBdRUcCBAoAAA==.Hyku:AwABCAEABAoAARkAXUUGCBQABAo=.',Ic='Iced:AwACCAMABRQDGgAIAQjXBwBFRqICBAoAGgAIAQjXBwBFRqICBAoAGwABAQjVHgAEuykABAoAAA==.Icrìtmypants:AwAGCAwABAoAAA==.',Id='Ideetentee:AwACCAIABAoAAA==.',Im='Immutable:AwAFCAMABAoAAA==.',Is='Isentropic:AwAFCAMABAoAAA==.',It='Itwasaphase:AwACCAQABRQDEAAIAQhDAwBYDP8CBAoAEAAIAQhDAwBYDP8CBAoAAQABAQj/SAAuey8ABAoAAA==.',Ja='Jabamental:AwABCAEABRQCFAAIAQhhCABSHLQCBAoAFAAIAQhhCABSHLQCBAoAAA==.Jamx:AwEBCAEABAoAARYAR4cBCAEABRQ=.Jarhead:AwADCAUABAoAAA==.Jashin:AwAFCAsABAoAAA==.Jaycifer:AwABCAEABRQDAgAIAQhWCAA5Xo0BBAoABQAHAQgVIwA4UscBBAoAAgAGAQhWCAAzeI0BBAoAAA==.',Jm='Jmy:AwEBCAEABRQDFgAIAQgfBgBHh4wCBAoAFgAIAQgfBgBGzIwCBAoAHAAHAQhVDwA1ge4BBAoAAA==.',Ju='Jurble:AwAGCBIABAoAAA==.Justydusty:AwADCAMABRQCEQAIAQjABABfblQDBAoAEQAIAQjABABfblQDBAoAAA==.',Ka='Kabbu:AwAGCAEABAoAAA==.Kaelord:AwAECAYABAoAAA==.Kaminari:AwABCAEABRQAAA==.Kardrig:AwADCAIABAoAAA==.Katwoman:AwAHCA4ABAoAAA==.',Ki='Killercold:AwADCAYABAoAAA==.Kissalicious:AwAFCAUABAoAARAAFfkDCAcABRQ=.Kissception:AwADCAcABRQCEAADAQgGBAAV+csABRQAEAADAQgGBAAV+csABRQAAA==.Kisstrosity:AwACCAIABRQAARAAFfkDCAcABRQ=.',Ko='Kodoseeker:AwAHCAMABAoAAA==.',Kr='Krisali:AwABCAEABRQCBwAIAQgMBwBRIMoCBAoABwAIAQgMBwBRIMoCBAoAAA==.Krøol:AwABCAEABAoAAQwAAAAGCAkABAo=.',Ku='Kunarpala:AwACCAMABAoAAQwAAAAFCBIABAo=.Kunarr:AwAFCBIABAoAAA==.',La='Lathas:AwAFCAIABAoAAA==.Laø:AwACCAMABAoAAA==.',Lo='Loktad:AwAGCBUABAoCBAAGAQghGgBJPAQCBAoABAAGAQghGgBJPAQCBAoAAA==.Lotlizzard:AwADCAgABAoAAA==.Lowestdps:AwACCAQABAoAAA==.',Lt='Ltadori:AwADCAEABAoAAA==.',Lu='Lunarfel:AwAHCBcABAoDAgAHAQgtBwBCDKoBBAoAAgAHAQgtBwAsR6oBBAoABQAGAQj1JgBAnqkBBAoAAA==.',Ly='Lyvola:AwABCAEABRQDEQAIAQg0PgBKeeQBBAoAEQAGAQg0PgBU1OQBBAoAHQAGAQh4FwAlVyEBBAoAAA==.',['L�']='Lätêx:AwABCAEABRQCEQAIAQhpCgBbdhkDBAoAEQAIAQhpCgBbdhkDBAoAAA==.',Ma='Madsquatch:AwAFCAQABAoAAA==.Magello:AwABCAMABAoAAA==.Magicmeatxxl:AwAHCBAABAoAAA==.Magusgobrr:AwAGCBQABAoCCwAGAQhnFABfHnMCBAoACwAGAQhnFABfHnMCBAoAAA==.Makaveli:AwAECAQABAoAAA==.Makellos:AwAICAgABAoAAA==.Malzhar:AwAHCBMABAoAAA==.Manafist:AwAFCAoABAoAAA==.Mastan:AwADCAEABAoAAA==.Mattdamon:AwAICAEABAoAAA==.Maxvertrappn:AwADCAQABRQAAA==.',Mi='Michael:AwACCAEABAoAAA==.Mikan:AwACCAIABAoAAA==.Mirajane:AwAICBAABAoAAA==.Miriya:AwADCAUABAoAAA==.',Mo='Mojojojo:AwAFCAYABAoAAA==.Mokek:AwAHCAYABAoAAA==.Monumentus:AwAICAgABAoAAA==.Moonberry:AwADCAMABRQCGgAIAQiyCgBDI2ICBAoAGgAIAQiyCgBDI2ICBAoAAA==.Moonlock:AwABCAEABAoAAA==.',My='Myriad:AwADCAMABRQCHgAIAQguAABjYI0DBAoAHgAIAQguAABjYI0DBAoAAA==.',['M�']='Màyhém:AwAICBcABAoCEQAIAQghGwBD4pICBAoAEQAIAQghGwBD4pICBAoAAA==.',Na='Nadyanefario:AwAFCAEABAoAAA==.Naraynne:AwABCAIABRQDDwAIAQi0CABCVncCBAoADwAIAQi0CABCVncCBAoAEAADAQgdTgAPvHYABAoAAA==.',Ni='Nidos:AwADCAIABAoAAA==.Ninjustu:AwACCAMABRQCHgAIAQjoBQBRtOgCBAoAHgAIAQjoBQBRtOgCBAoAAA==.Nishiki:AwAGCAYABAoAAQwAAAAGCAkABAo=.',Nn='Nnuan:AwAECAIABAoAAA==.',No='Nopantsment:AwAFCAMABAoAAA==.',Or='Orcall:AwAICBwABAoCCgAIAQj3EQBKxMQCBAoACgAIAQj3EQBKxMQCBAoAAA==.',Ov='Overclocked:AwABCAEABAoAAA==.',Pa='Pakku:AwACCAMABRQCHwAIAQijBgBMYNUCBAoAHwAIAQijBgBMYNUCBAoAAA==.Paladaine:AwAFCAkABAoAAA==.Panzi:AwACCAIABAoAAA==.Papal:AwABCAEABAoAAA==.Pastureprime:AwADCAcABAoAAQwAAAAGCAUABAo=.',Pe='Peachmangos:AwAGCA0ABAoAAA==.',Ph='Phigon:AwAFCAsABAoAAA==.',Pi='Pickletimz:AwAHCAMABAoAAA==.Piikarogue:AwAGCAoABAoAAQUAV0MDCAgABRQ=.Pikalock:AwADCAgABRQDBQADAQgHAgBXQzQBBRQABQADAQgHAgBXQzQBBRQAAgABAQj5CwAjkkoABRQAAA==.',Po='Popegregory:AwADCAEABAoAAA==.',Pr='Priestythorp:AwACCAMABAoAAR0AWdkGCBQABAo=.',Pu='Putmeincoach:AwAECAUABAoAAA==.',Qu='Quancho:AwABCAIABRQCIAAIAQh/AQBMuKACBAoAIAAIAQh/AQBMuKACBAoAAA==.',Qw='Qwade:AwAGCAoABAoAAA==.',Ra='Radishes:AwAHCAsABAoAAA==.Ramza:AwADCAcABRQCEQADAQhWAwBg80UBBRQAEQADAQhWAwBg80UBBRQAAA==.Ranbou:AwABCAEABRQDCQAIAQjVAABN1cACBAoACQAIAQjVAABMs8ACBAoACwAGAQjKLQBETYwBBAoAAA==.',Re='Redeemer:AwAFCAIABAoAAA==.Repens:AwAFCAMABAoAAA==.Revoked:AwAGCAUABAoAAA==.',Rh='Rhaid:AwAFCA4ABAoAAA==.Rhordrick:AwAECAcABAoAAA==.',Ru='Runawaynasty:AwABCAEABAoAAA==.',Sa='Sabilla:AwABCAEABAoAAA==.Samdeathfoot:AwAFCAsABAoAAA==.Sankeman:AwAFCAEABAoAAA==.Sanq:AwAFCAwABAoAAA==.Sappho:AwABCAEABRQDIQAIAQgFEgA1UkQBBAoAIQAFAQgFEgA4CkQBBAoABQAEAQgZRAAujPsABAoAAA==.',Se='Sevenfold:AwACCAQABRQCCgAIAQi+BwBbGycDBAoACgAIAQi+BwBbGycDBAoAAA==.Seyuri:AwAFCAsABAoAAA==.Seán:AwAFCAIABAoAAA==.',Sh='Shadowar:AwAECAoABAoAAA==.',Si='Sidekickz:AwADCAUABAoAAA==.',St='Stellarèé:AwACCAQABRQCBQAIAQgzBQBVcgADBAoABQAIAQgzBQBVcgADBAoAAA==.Stêllastraza:AwAECAgABAoAAA==.',Su='Sudip:AwABCAEABAoAAA==.',Sv='Svaval:AwADCAMABRQCEgAIAQjUAgBbyCgDBAoAEgAIAQjUAgBbyCgDBAoAAA==.',Sy='Synder:AwAGCAsABAoAAA==.',['S�']='Sìmp:AwADCAYABAoAAQwAAAAECAQABAo=.Sòúl:AwAECAYABAoAAA==.Sõren:AwAFCAwABAoAAA==.',Ta='Tangents:AwAGCBEABAoAAA==.Tankinpánda:AwAECAoABAoAAA==.Tarekk:AwAGCAoABAoAAA==.',Te='Tehcountess:AwAGCAoABAoAAA==.Tehworlok:AwAFCA0ABAoAAQwAAAAGCAoABAo=.Terps:AwAGCBQABAoEAgAGAQgdFgAphrsABAoAIQAEAQjFIAAcUcgABAoAAgADAQgdFgAtYrsABAoABQADAQiNXwAkXocABAoAAA==.',Th='Thebeerwiz:AwAECAQABAoAAA==.Thelianne:AwAFCAsABAoAAA==.Thepot:AwAGCAkABAoAAA==.Thorps:AwAGCBQABAoCHQAGAQiuBgBZ2VwCBAoAHQAGAQiuBgBZ2VwCBAoAAA==.Thugoneous:AwAGCBEABAoAAA==.',Ti='Tilexer:AwAHCBUABAoCCgAHAQhUKgA5cQICBAoACgAHAQhUKgA5cQICBAoAAA==.',To='Tollingbell:AwAFCA4ABAoAAA==.Tonyrigatoni:AwAHCA4ABAoAAA==.',Tr='Trugi:AwAGCAcABAoAAA==.',Tw='Twerkulez:AwAICAgABAoAAA==.Twösix:AwAGCAsABAoAAA==.',Ty='Tymbyr:AwAFCA4ABAoAAA==.',Va='Vaellian:AwAHCBEABAoAAA==.Valei:AwAICA8ABAoAAA==.Valvadime:AwADCAUABAoAAA==.',Ve='Velassi:AwAHCAMABAoAAA==.Venuusaur:AwAHCAEABAoAAA==.',Vy='Vyndaris:AwAGCA0ABAoAAA==.',Wh='Whely:AwABCAEABRQCIgAIAQgPAQBZriUDBAoAIgAIAQgPAQBZriUDBAoAAA==.',Wi='Wilcoxx:AwAICBQABAoEIQAIAQhrEQAo3EsBBAoAIQAFAQhrEQAsIUsBBAoABQAGAQheOAAfLzgBBAoAAgABAQgpKQANFTgABAoAAA==.',['W�']='Wîxx:AwABCAEABRQCFQAIAQhKAQBc+kYDBAoAFQAIAQhKAQBc+kYDBAoAAA==.',Xa='Xantizzle:AwAFCAgABAoAAA==.',Ya='Yacuto:AwABCAEABRQCEQAIAQgRHQBJOoUCBAoAEQAIAQgRHQBJOoUCBAoAAA==.Yanasampanno:AwAGCA0ABAoAAA==.',Za='Zacheeus:AwABCAEABRQCCgAHAQgIGABVxI4CBAoACgAHAQgIGABVxI4CBAoAAA==.Zacka:AwAECAEABAoAAA==.Zardragon:AwAICB0ABAoCGgAIAQiZAwBa0AYDBAoAGgAIAQiZAwBa0AYDBAoAAA==.',Ze='Zelethor:AwABCAEABRQCBwAIAQhrBgBQz9YCBAoABwAIAQhrBgBQz9YCBAoAAA==.Zerolf:AwAECAUABAoAAA==.',Zi='Zilodactyl:AwADCAMABRQDGgAIAQhtCABUPpUCBAoAGgAHAQhtCABUtpUCBAoAGwAHAQj7BQBCvyACBAoAAA==.',['ß']='ßadßunny:AwAFCAUABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end