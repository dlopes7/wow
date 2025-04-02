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
 local lookup = {'Mage-Fire','Shaman-Restoration','Shaman-Enhancement','Rogue-Subtlety','Priest-Shadow','Warrior-Fury','Warrior-Protection','Warlock-Destruction','Warlock-Affliction','Priest-Holy','Evoker-Devastation','Mage-Frost','DemonHunter-Havoc','Hunter-Marksmanship','Hunter-BeastMastery','Shaman-Elemental','Unknown-Unknown','Druid-Restoration','Paladin-Protection','Warrior-Arms','DemonHunter-Vengeance','Monk-Windwalker','Monk-Brewmaster','Druid-Balance','DeathKnight-Blood','DeathKnight-Unholy','DeathKnight-Frost','Paladin-Retribution','Rogue-Assassination','Monk-Mistweaver','Warlock-Demonology',}; local provider = {region='US',realm='Magtheridon',name='US',type='weekly',zone=42,date='2025-03-28',data={Ai='Airleenna:AwABCAEABAoAAA==.',Al='Allnutnosup:AwAECAQABAoAAA==.',Ar='Arnblass:AwAFCAsABAoAAA==.',As='Ashellestana:AwAFCAUABAoAAA==.',Av='Aviee:AwAFCAkABAoAAA==.',Az='Azazi:AwADCAYABRQCAQADAQiyCABB3/oABRQAAQADAQiyCABB3/oABRQAAA==.',Ba='Baced:AwAFCAsABAoAAA==.Baendron:AwAGCAYABAoAAA==.Bahnna:AwAECAEABAoAAA==.',Bi='Bigdady:AwABCAEABAoAAA==.Biomedic:AwAGCAQABAoAAA==.',Bl='Blackbolt:AwACCAQABRQDAgAIAQj4EwBBTiICBAoAAgAIAQj4EwBBTiICBAoAAwAGAQhvGQA1564BBAoAAA==.Blastfire:AwAGCAwABAoAAA==.Blorgin:AwADCAYABRQCBAADAQj+AwA55vwABRQABAADAQj+AwA55vwABRQAAA==.',Bo='Bookers:AwAFCAQABAoAAA==.Boulangerie:AwADCAYABRQCBQADAQjlAgBLkCsBBRQABQADAQjlAgBLkCsBBRQAAA==.Bouluid:AwADCAcABAoAAA==.Boyd:AwADCAYABRQDBgADAQhrBQA1vAcBBRQABgADAQhrBQA1vAcBBRQABwABAQjvBAAaAzkABRQAAA==.',Br='Brunhilda:AwACCAQABAoAAA==.',Ca='Cainpain:AwADCAkABAoAAA==.',Ce='Ceasarsalad:AwADCAUABRQCCAADAQgiBQArp+MABRQACAADAQgiBQArp+MABRQAAA==.',Ch='Chadlockb:AwADCAYABRQDCQADAQh2BABL/agABRQACQACAQh2BABLSKgABRQACAABAQh0DwBNaFsABRQAAA==.Char:AwABCAEABRQCCgAHAQiHCABUKYsCBAoACgAHAQiHCABUKYsCBAoAAA==.Cheesee:AwABCAEABRQAAA==.Chronite:AwAFCA8ABAoAAA==.',Ci='Cindr:AwABCAEABRQCCwAIAQjxAABhkGADBAoACwAIAQjxAABhkGADBAoAAA==.',Co='Codys:AwADCAQABRQCDAAIAQhjAABi14sDBAoADAAIAQhjAABi14sDBAoAAA==.Cololol:AwADCAQABRQCDQAIAQiRAQBgSXQDBAoADQAIAQiRAQBgSXQDBAoAAA==.Conen:AwAECAUABAoAAA==.Cooper:AwAFCA8ABAoAAA==.Corgal:AwAECAoABAoAAA==.Cosmos:AwAFCA8ABAoAAA==.',Cu='Cuddlestomp:AwADCAQABRQDDgAIAQg8BABdqdECBAoADwAIAQgJDgBXWOgCBAoADgAHAQg8BABbRtECBAoAAA==.Curgh:AwACCAMABAoAAA==.',Cy='Cyndor:AwADCAYABRQCCwAIAQi5BgBKxLwCBAoACwAIAQi5BgBKxLwCBAoAAA==.',Da='Darthmerlin:AwAECAUABAoAAA==.Dasmonster:AwABCAEABRQAAA==.',Dh='Dhsil:AwAFCBAABAoAAA==.',Dr='Drankincup:AwAICBYABAoCEAAIAQiSBwBW47sCBAoAEAAIAQiSBwBW47sCBAoAAA==.Drstagger:AwEFCA4ABAoAAA==.Drunkghaan:AwABCAEABAoAAA==.Drwisdom:AwEFCAoABAoAAREAAAAFCA4ABAo=.',Du='Duskflower:AwADCAYABRQCEgAIAQgwAgBXsiUDBAoAEgAIAQgwAgBXsiUDBAoAAA==.',Ea='Earlyaccess:AwACCAIABAoAAA==.',Ep='Epnodk:AwABCAEABRQAARMARFICCAUABRQ=.Epnopal:AwACCAUABRQCEwACAQj/AwBEUqAABRQAEwACAQj/AwBEUqAABRQAAA==.',Fa='Falaya:AwADCAYABRQCCAADAQiAAgBTqCQBBRQACAADAQiAAgBTqCQBBRQAAA==.Fatherpain:AwADCAQABAoAAA==.',Fe='Feral:AwADCAMABAoAAA==.',Fl='Flyntflosy:AwADCAYABRQCEAADAQh8AwAZydAABRQAEAADAQh8AwAZydAABRQAAA==.',Fo='Fossilgenera:AwACCAUABRQDFAACAQieAwA9FKsABRQAFAACAQieAwA7rqsABRQABgABAQhNDwA+7VUABRQAAA==.',Fr='Fragment:AwAECAEABAoAAA==.',Fu='Fuehriån:AwADCAQABAoAAA==.Funstar:AwACCAIABAoAAREAAAABCAIABRQ=.Fununcle:AwAGCAYABAoAAA==.',Ga='Gandorlf:AwABCAEABAoAAA==.Garolok:AwAGCAQABAoAAA==.Gazerielle:AwAHCBUABAoCFQAHAQgxCwBCEPwBBAoAFQAHAQgxCwBCEPwBBAoAAA==.',Gl='Glizzylizzy:AwABCAEABRQAAA==.',Go='Goldilockes:AwABCAEABAoAAA==.Gowownage:AwAECAQABAoAAREAAAABCAEABRQ=.',Gr='Graedeus:AwADCAYABRQDFgADAQigBwAZcoIABRQAFgACAQigBwAjLoIABRQAFwABAQiIBQAF/CYABRQAAA==.Greenmango:AwABCAEABRQAAA==.Grombear:AwAECAgABAoAAA==.',Ha='Halk:AwADCAQABRQAAA==.Havefun:AwABCAIABRQAAA==.',He='Hecachire:AwACCAUABRQCCgACAQjCBQA0up8ABRQACgACAQjCBQA0up8ABRQAAA==.Hecaquatre:AwAHCAcABAoAAA==.Hellrunner:AwAGCAYABAoAAA==.',Hi='Hilan:AwACCAIABRQAAA==.',Ho='Holydoyle:AwACCAMABAoAAA==.Hotpøcket:AwADCAYABRQDEgADAQjyBABJuasABRQAEgACAQjyBABJMasABRQAGAABAQgbEAAR5VAABRQAAA==.',Hu='Hugecheeks:AwAICA4ABAoAAA==.',Hy='Hyperìen:AwADCAYABRQCEwADAQgMAwAzWsEABRQAEwADAQgMAwAzWsEABRQAAA==.',Ia='Iampro:AwAHCBAABAoAAREAAAABCAEABRQ=.Iax:AwAGCAMABAoAAA==.',In='Inferna:AwACCAIABAoAAA==.',Ir='Irbaboon:AwACCAMABAoAAA==.',Ja='Jackiechàn:AwAFCAgABAoAAA==.Jacosta:AwAFCA0ABAoAAA==.Jal:AwABCAEABRQCBQAIAQiEBABWZggDBAoABQAIAQiEBABWZggDBAoAAA==.Jangokin:AwADCAYABRQCGAADAQg/BABRsyQBBRQAGAADAQg/BABRsyQBBRQAAA==.Jayded:AwADCAQABAoAAA==.',Je='Jermz:AwABCAEABAoAAA==.',Ji='Jinks:AwABCAEABAoAAA==.',Jo='Joelrobuchon:AwAECAoABAoAAA==.Jormungandr:AwACCAMABAoAAA==.',Ju='Jumalauta:AwAECAQABAoAAA==.',Ka='Kabang:AwAFCAYABAoAAA==.Kablam:AwAICBAABAoAAA==.Kaeris:AwACCAYABAoAAA==.Kaige:AwADCAUABAoAAA==.Kaladuun:AwAGCAQABAoAAA==.Kalerõn:AwAFCAYABAoAAA==.Karasmacks:AwAGCAIABAoAAA==.',Ke='Kellwildfire:AwAFCAkABAoAAA==.',Kh='Khamael:AwAICBkABAoCDAAIAQjKAwBaIxMDBAoADAAIAQjKAwBaIxMDBAoAAA==.Kheiron:AwAHCBUABAoDDwAHAQjiGgBOSHYCBAoADwAHAQjiGgBOSHYCBAoADgADAQhLKgBO4qYABAoAAA==.Khâron:AwAGCAwABAoAAA==.',Kl='Klue:AwABCAEABRQAAA==.',Kr='Krìeg:AwACCAMABAoAAA==.',Ku='Kurohail:AwAHCBUABAoCGQAHAQh5CABTxHQCBAoAGQAHAQh5CABTxHQCBAoAAA==.',Ky='Kyblade:AwAGCAQABAoAAA==.',['K�']='Kôrvus:AwADCAMABAoAAA==.',Le='Legoles:AwACCAIABAoAAA==.Leosbryn:AwAGCAQABAoAAA==.',Li='Liilliith:AwAECAEABAoAAA==.Lilhunt:AwACCAEABAoAAREAAAABCAEABRQ=.',Ma='Magikbeef:AwABCAEABAoAAA==.Majackula:AwABCAEABRQAAA==.Malforeign:AwADCAYABRQCGAADAQjVBQBCKAIBBRQAGAADAQjVBQBCKAIBBRQAAA==.Manapause:AwAECAQABAoAAA==.Masana:AwACCAIABAoAAA==.Matikz:AwADCAYABRQCBAADAQgXBQATTdkABRQABAADAQgXBQATTdkABRQAAA==.',Me='Meatless:AwABCAEABRQAAA==.Meddle:AwADCAUABRQCCgADAQjTAABg+U8BBRQACgADAQjTAABg+U8BBRQAAA==.Meyea:AwACCAMABRQEGgAIAQjpBwBUfNgCBAoAGgAIAQjpBwBUfNgCBAoAGwAEAQiaEgBFx/cABAoAGQABAQhfPgAsfy0ABAoAAA==.',Mi='Milfhhünter:AwAFCAUABAoAAA==.Mistreated:AwABCAEABRQCBgAIAQj7DABEbpgCBAoABgAIAQj7DABEbpgCBAoAAA==.Mizadra:AwAGCAQABAoAAA==.',Mo='Moonfun:AwADCAQABAoAAREAAAABCAIABRQ=.',My='Myrcat:AwAFCAYABAoAAA==.Myrodragon:AwADCAMABAoAAA==.Myronoriss:AwABCAEABAoAAREAAAADCAMABAo=.',['M�']='Mércy:AwAFCAoABAoAAA==.Müshü:AwADCAYABRQCFgADAQjFAgBCPxYBBRQAFgADAQjFAgBCPxYBBRQAAA==.',Na='Narlesbarkly:AwAECAQABAoAAA==.Nazthor:AwABCAEABAoAAA==.',Nu='Nuggi:AwAECAEABAoAAA==.',Nw='Nwt:AwABCAEABAoAAREAAAAECAUABAo=.',Ob='Obedus:AwADCAYABAoAAA==.',On='Onornu:AwAICAMABAoAAA==.',Pe='Pediatre:AwAECAkABAoAAA==.Peka:AwADCAYABRQCAgADAQiJAwA6OPQABRQAAgADAQiJAwA6OPQABRQAAA==.',Ph='Phobius:AwABCAEABRQCGgAHAQjDDwBMa1kCBAoAGgAHAQjDDwBMa1kCBAoAAA==.',Pi='Pileofschitt:AwAGCA8ABAoAAA==.Pippapjappin:AwABCAEABAoAAA==.',Pl='Plz:AwABCAEABRQAAA==.',Po='Poonzer:AwABCAEABRQCHAAIAQiiGQBL850CBAoAHAAIAQiiGQBL850CBAoAAA==.',Py='Pythros:AwAFCAgABAoAAA==.',Qe='Qetesh:AwAECAEABAoAAA==.',Qu='Quìèt:AwAECAIABAoAAA==.',Ra='Raehon:AwABCAEABRQCHQAHAQhSCABJ+E0CBAoAHQAHAQhSCABJ+E0CBAoAAA==.Razberry:AwABCAEABRQAAA==.',Re='Reikihealer:AwAICBAABAoAAA==.Reikitotem:AwAICAgABAoAAA==.Relentless:AwACCAIABAoAAA==.',Rh='Rhowa:AwEDCAYABRQCFQADAQihAQA14+UABRQAFQADAQihAQA14+UABRQAAA==.',Ri='Rickity:AwAICAgABAoAAA==.Riftraft:AwACCAIABAoAAA==.Rileyolsen:AwABCAEABAoAAA==.',Ry='Rynne:AwABCAEABRQAAA==.',Sa='Sawedoff:AwABCAEABAoAAA==.',Sc='Scamall:AwEDCAUABRQCEgADAQj9AABeDkYBBRQAEgADAQj9AABeDkYBBRQAAA==.Scorpe:AwAECAIABAoAAA==.',Se='Sedonia:AwAICBAABAoAAA==.',Sh='Shade:AwABCAEABRQCHQAHAQjQDQAqG78BBAoAHQAHAQjQDQAqG78BBAoAAA==.Shadoewolfe:AwABCAEABAoAAA==.Shageron:AwADCAMABRQDDwAIAQjeBABhB0gDBAoADwAIAQjeBABf5EgDBAoADgAIAQgzAgBcVRUDBAoAAA==.Shalirys:AwAICBYABAoCCgAIAQg2JAAQjWEBBAoACgAIAQg2JAAQjWEBBAoAAA==.Shankspec:AwACCAUABRQCHQACAQggAwA+za0ABRQAHQACAQggAwA+za0ABRQAAA==.Shocksock:AwACCAUABRQCAQACAQheDwA3F5sABRQAAQACAQheDwA3F5sABRQAAA==.Shoeboo:AwACCAQABRQDEAAIAQiLBwBcA7sCBAoAEAAHAQiLBwBfZbsCBAoAAgADAQjiRgBKeuIABAoAAA==.Shämash:AwAFCAUABAoAAA==.',Sm='Smokfun:AwAGCAoABAoAAA==.',St='Stojk:AwAECAQABAoAAA==.',Su='Sumx:AwADCAMABAoAAA==.',Sy='Sytryana:AwACCAIABAoAAQoAVCkBCAEABRQ=.',Te='Tealdragon:AwABCAEABRQAAA==.Tehdyrex:AwAHCBcABAoCDwAHAQgeNQAvSb8BBAoADwAHAQgeNQAvSb8BBAoAAA==.Terk:AwADCAYABRQCAwADAQj9AgBNDRMBBRQAAwADAQj9AgBNDRMBBRQAAA==.',Th='Thalrymere:AwAGCAQABAoAAA==.Thane:AwAGCAYABAoAAREAAAAICAsABAo=.Theepally:AwABCAEABAoAAA==.Thepaperbag:AwAFCBAABAoAAA==.',Ti='Tidejitsu:AwACCAMABRQCHgAIAQiHEQA7eyoCBAoAHgAIAQiHEQA7eyoCBAoAAA==.Tikz:AwAGCAQABAoAAA==.Tillurend:AwABCAEABAoAAA==.',To='Toe:AwAECAEABAoAAA==.Tokenwarrior:AwADCAYABAoAAA==.Topa:AwAECAUABAoAAA==.',Tr='Trapion:AwABCAEABAoAAA==.Trappypanda:AwABCAEABRQAAA==.Tricky:AwAHCBEABAoAAA==.Trivalence:AwADCAMABAoAAA==.Truegrit:AwACCAIABAoAAA==.',Tu='Tuv:AwAGCAMABAoAAA==.',Uz='Uzi:AwADCAYABRQCDQADAQg8BQA+WxoBBRQADQADAQg8BQA+WxoBBRQAAA==.',Va='Vaughn:AwACCAUABRQCBgACAQgdCgAuY6UABRQABgACAQgdCgAuY6UABRQAAA==.',Ve='Veggieboi:AwAGCBAABAoAAA==.',Vi='Vigilo:AwAHCBUABAoCFgAHAQjdBwBYQboCBAoAFgAHAQjdBwBYQboCBAoAAA==.Viki:AwAECAcABAoAAA==.',Wa='Warwonka:AwABCAEABRQAAA==.Watchurbeard:AwAGCAQABAoAAA==.',Wh='Whammer:AwAFCAUABAoAAA==.Whiiplash:AwABCAEABRQAAA==.',Wi='Willsmith:AwAGCAoABAoAAA==.',Xz='Xzayin:AwAGCAQABAoAAA==.',Ya='Yacob:AwADCAYABRQDAQADAQjKBQBWYSwBBRQAAQADAQjKBQBWYSwBBRQADAABAQiqCABPG0gABRQAAA==.Yako:AwAGCA0ABAoAAA==.',Za='Zauber:AwADCAcABRQECQADAQiIAABgJEoBBRQACQADAQiIAABgIEoBBRQAHwABAQg1BABhEVYABRQACAABAQgaFABKLEgABRQAAA==.',Zi='Zirraj:AwABCAEABRQCBgAIAQgEBQBWKRgDBAoABgAIAQgEBQBWKRgDBAoAAA==.',Zn='Zn:AwABCAEABAoAAA==.',Zu='Zuldar:AwABCAEABRQCDwAHAQi4IQBAykACBAoADwAHAQi4IQBAykACBAoAAA==.',Zy='Zygon:AwABCAEABRQAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end