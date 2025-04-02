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
 local lookup = {'Unknown-Unknown','Paladin-Protection','Hunter-BeastMastery','Druid-Restoration','Druid-Feral','Druid-Balance','Rogue-Assassination','Rogue-Subtlety','Warrior-Fury','Warrior-Protection','Druid-Guardian','Mage-Arcane',}; local provider = {region='US',realm='Velen',name='US',type='weekly',zone=42,date='2025-03-28',data={As='Aslan:AwACCAUABAoAAA==.',At='Atar:AwABCAEABAoAAA==.',Au='Aust:AwAGCAEABAoAAA==.',Ba='Bandadi:AwAHCBIABAoAAA==.',Be='Belii:AwAICAwABAoAAA==.',Bl='Blupaw:AwAICAgABAoAAA==.',Bu='Bubby:AwAHCA8ABAoAAA==.Bugonlight:AwAHCBAABAoAAA==.Bulletz:AwAGCAwABAoAAA==.',Ca='Carryplz:AwAECAYABAoAAA==.Cassandria:AwAGCA8ABAoAAA==.',Ch='Choginhood:AwAGCBIABAoAAA==.Choglana:AwAGCAwABAoAAQEAAAAGCBIABAo=.Châos:AwAICAgABAoAAA==.',Co='Cochar:AwAGCBAABAoAAA==.',Cr='Crona:AwAFCAkABAoAAA==.Crzyy:AwAHCBQABAoCAgAHAQhDBgBPwmwCBAoAAgAHAQhDBgBPwmwCBAoAAA==.',Cy='Cyhyraethia:AwADCAEABAoAAQEAAAAGCA8ABAo=.',Da='Danda:AwAFCAgABAoAAA==.Daricepicker:AwABCAEABRQCAwAHAQjLIgBHITcCBAoAAwAHAQjLIgBHITcCBAoAAA==.Darkbeef:AwACCAIABAoAAA==.Daten:AwAGCBAABAoAAQMARyEBCAEABRQ=.',De='Deadpool:AwAGCA8ABAoAAA==.Dermon:AwAECAkABAoAAA==.',Eq='Equipmunk:AwAECAYABAoAAA==.',Es='Estameling:AwAGCA8ABAoAAA==.',Ex='Exash:AwAECAEABAoAAA==.',Fr='Freemilk:AwABCAEABAoAAA==.Frosticulz:AwAHCAMABAoAAA==.',Ga='Gandaalf:AwAECAQABAoAAA==.Garrone:AwAHCA0ABAoAAA==.',Go='Goose:AwAECAQABAoAAA==.',Gr='Graycat:AwAHCAkABAoAAA==.Greedygrim:AwADCAYABAoAAA==.Gregmiller:AwAICAgABAoAAA==.Greygoon:AwAHCBAABAoAAA==.',Gu='Gup:AwACCAIABAoAAA==.',Hi='Hif:AwAECAQABAoAAA==.Highlight:AwAHCBEABAoAAA==.',Ho='Holyschist:AwADCAMABAoAAA==.',Il='Illyy:AwAGCAsABAoAAA==.',In='Indawhole:AwAHCBMABAoAAA==.',Ja='Javaluminous:AwAGCA8ABAoAAA==.Jaytsukitori:AwAHCBYABAoEBAAHAQieEgBDLtoBBAoABAAHAQieEgBDLtoBBAoABQAFAQhAEQAXyugABAoABgACAQjtXAAt82QABAoAAA==.',Ji='Jiani:AwAECAoABAoAAA==.',Jo='Joesepi:AwAHCBEABAoAAA==.',Ju='Jurdensmash:AwADCAMABAoAAA==.',Jy='Jyve:AwAECAcABAoAAA==.',Ka='Kazatre:AwACCAMABAoAAA==.',Ke='Kerisan:AwAECAgABAoAAA==.',Ki='Kilrah:AwAGCAUABAoAAA==.Kissmycrits:AwACCAIABAoAAA==.Kiyoine:AwAGCA8ABAoAAA==.',Kn='Knocksteady:AwABCAIABAoAAA==.Knoxrages:AwAGCA8ABAoAAA==.',Kp='Kpoppi:AwAHCBEABAoAAA==.',Kr='Krzzy:AwAICAgABAoAAA==.',Le='Letrissia:AwAGCA0ABAoAAA==.',Li='Littledog:AwAFCAwABAoAAA==.',Lo='Lotten:AwABCAEABAoAAA==.',Ma='Malv:AwAECAUABAoAAA==.Maverick:AwACCAIABRQDBwAHAQgZBwBLXW4CBAoABwAHAQgZBwBLXW4CBAoACAAHAQiJEgAoELEBBAoAAA==.',Mi='Midvast:AwAECAQABAoAAA==.',Mo='Mogar:AwAICA0ABAoAAA==.Mojitoflame:AwAGCAkABAoAAA==.Momonut:AwAGCAYABAoAAA==.Mossop:AwAHCAsABAoAAA==.',Na='Nazugar:AwABCAEABAoAAA==.',Ni='Nivmizzet:AwAGCA4ABAoAAA==.',No='Nokano:AwADCAYABAoAAA==.Novalea:AwAGCBEABAoAAA==.',Ny='Nyriune:AwACCAIABAoAAA==.',Od='Odogaren:AwAICBkABAoDCQAIAQhhCwBGpa0CBAoACQAIAQhhCwBGpa0CBAoACgABAQg9JAApXTMABAoAAA==.',Or='Origin:AwADCAMABAoAAA==.',Pi='Pinkfloydian:AwAGCBEABAoAAA==.',Pr='Praestrictus:AwAFCAoABAoAAQEAAAAGCAUABAo=.',Ra='Raveneyes:AwAFCAsABAoAAA==.',Re='Restorott:AwABCAEABAoAAA==.',Sa='Saddles:AwACCAIABAoAAA==.',Sc='Scorchmonkey:AwACCAMABAoAAA==.Scrumbles:AwAGCAwABAoAAA==.',Se='Seis:AwABCAEABAoAAA==.',Sh='Shamanizim:AwAGCA8ABAoAAA==.Shamonman:AwAGCA8ABAoAAA==.Sheeanna:AwAGCA4ABAoAAA==.Shinotenshi:AwADCAQABAoAAA==.Shugarae:AwAGCA4ABAoAAA==.',St='Strominatrix:AwAHCAgABAoAAA==.',Sy='Sylris:AwADCAYABAoAAA==.Sylvanthis:AwADCAIABAoAAA==.Synnimon:AwACCAMABAoAAA==.',Th='Thõrr:AwAICAgABAoAAA==.',To='Toth:AwAHCBEABAoAAA==.',Tr='Tritoch:AwADCAcABAoAAA==.',Ty='Tyræll:AwAECAIABAoAAQkARqUICBkABAo=.',Ug='Ugrup:AwADCAYABAoAAA==.',Ul='Ulurak:AwAICBwABAoEBgAIAQh0FwA/NSwCBAoABgAHAQh0FwBAlCwCBAoABAAIAQiTGgAg1IcBBAoACwABAQhlGQAT2yEABAoAAA==.',Ur='Urza:AwABCAEABAoAAA==.',Ve='Verkai:AwAHCBAABAoAAA==.',Vi='Vildaren:AwAFCAgABAoAAA==.',Wo='Woodryktor:AwACCAUABAoAAA==.',Xu='Xuefeiyan:AwAICBQABAoCDAAIAQjsAABSdbECBAoADAAIAQjsAABSdbECBAoAAA==.',Za='Zaralina:AwACCAMABAoAAA==.Zaralyndra:AwACCAMABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end