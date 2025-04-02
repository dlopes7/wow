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
 local lookup = {'Unknown-Unknown','Mage-Fire','Warlock-Destruction','Warlock-Affliction','Warlock-Demonology','Shaman-Enhancement','Mage-Frost','Hunter-BeastMastery','Paladin-Retribution','Paladin-Protection','Shaman-Restoration','Shaman-Elemental','Priest-Holy','Priest-Discipline','Evoker-Devastation',}; local provider = {region='US',realm='Gurubashi',name='US',type='weekly',zone=42,date='2025-03-29',data={Aa='Aaeryñ:AwAICAgABAoAAA==.Aaramis:AwAGCAYABAoAAA==.',Ad='Adrisehunt:AwABCAIABAoAAA==.',Ah='Ahrah:AwACCAIABAoAAA==.',Am='Amadayus:AwABCAEABAoAAQEAAAACCAMABAo=.',Ba='Barackoshama:AwAHCA8ABAoAAA==.',Bi='Bigskymage:AwAGCAgABAoAAA==.Bixel:AwADCAMABAoAAA==.',Bl='Bloqqchain:AwAICAwABAoAAA==.',Bo='Bobertz:AwAICAgABAoAAA==.Bombil:AwAFCAEABAoAAA==.Bovinegraze:AwADCAUABAoAAA==.Bowdiddly:AwAGCAYABAoAAA==.',Ca='Calystarenn:AwAHCBAABAoAAA==.Camipriest:AwAHCAQABAoAAA==.Caralanaa:AwAICBAABAoAAA==.',Ce='Cesarj:AwAECAYABAoAAA==.Cexiback:AwABCAEABRQAAA==.',Ch='Chairon:AwAECAIABAoAAA==.Chrisandrade:AwAICAgABAoAAA==.',Cl='Clintbstwood:AwAGCA4ABAoAAA==.',Co='Coko:AwAECAQABAoAAQEAAAAFCAgABAo=.',Cr='Critters:AwAGCAMABAoAAA==.Cryptîc:AwADCAYABRQCAgADAQi+CwAh49sABRQAAgADAQi+CwAh49sABRQAAA==.',Cu='Cujako:AwABCAEABRQEAwAHAQhSLQA1LIgBBAoAAwAHAQhSLQAsQ4gBBAoABAADAQhuFwA9JrYABAoABQACAQgEMQApznoABAoAAA==.',Da='Daekoo:AwABCAEABRQCBgAIAQh+DQA7CGgCBAoABgAIAQh+DQA7CGgCBAoAAA==.Dalranirn:AwAECAsABAoAAA==.Damented:AwADCAcABAoAAA==.',De='Dekuslice:AwADCAMABAoAAA==.Dekustick:AwABCAEABRQAAA==.',Dr='Dragonjade:AwACCAIABAoAAA==.Drathkar:AwAECAkABAoAAA==.Drpally:AwABCAEABAoAAA==.Drêto:AwAECAUABAoAAA==.',Es='Essekk:AwAHCBYABAoDBwAHAQiIDQBTrG0CBAoABwAHAQiIDQBTrG0CBAoAAgABAQh2bQA2TD8ABAoAAA==.',Fa='Farandis:AwABCAEABAoAAA==.',Fe='Fennecy:AwAECAcABAoAAA==.',Fy='Fyafya:AwAFCA0ABAoAAQgALC8DCAUABRQ=.Fyah:AwACCAIABAoAAQgALC8DCAUABRQ=.',Go='Gothika:AwACCAIABAoAAA==.',Gr='Gremmlins:AwAECAQABAoAAA==.Grippi:AwAHCBEABAoAAA==.',He='Healsor:AwAICBAABAoAAA==.Hemostasis:AwAHCBsABAoDCQAHAQjJSwAqSrwBBAoACQAHAQjJSwAqSrwBBAoACgACAQjkMAAkFmAABAoAAA==.',Ho='Hombreancho:AwAICAgABAoAAA==.',Ic='Icantplây:AwADCAEABAoAAA==.',Ik='Ikash:AwAECAEABAoAAA==.',Ir='Irrenadro:AwABCAIABRQAAA==.',Is='Ispittfuego:AwAFCAIABAoAAA==.',Iu='Iudi:AwADCAMABAoAAA==.',Ja='Jabaru:AwAECAgABAoAAA==.',Ji='Jisoo:AwADCAMABAoAAA==.',Jx='Jxe:AwABCAEABRQAAA==.',Ke='Keetra:AwAGCBMABAoAAA==.',Ki='Killbreed:AwADCAMABAoAAA==.',Ky='Kyleroach:AwADCAcABAoAAA==.',La='Lambeáu:AwAHCBIABAoAAA==.',Le='Letsgoo:AwADCAQABAoAAA==.Lexiras:AwAFCAEABAoAAA==.',Li='Liquidsmoke:AwAFCAsABAoAAA==.',Ma='Maakun:AwAFCA0ABAoAAA==.Mahzad:AwABCAEABRQCCwAIAQhmBgBRh9wCBAoACwAIAQhmBgBRh9wCBAoAAA==.Marox:AwAGCBEABAoAAA==.Mathrim:AwABCAIABRQAAA==.Matooka:AwADCAUABAoAAA==.',Mi='Milkinballz:AwABCAEABRQCCQAIAQisKABAqk4CBAoACQAIAQisKABAqk4CBAoAAA==.Misleading:AwAECAEABAoAAA==.',Mo='Monkgroom:AwAHCAIABAoAAA==.Montra:AwAGCAoABAoAAA==.',Na='Naandore:AwACCAEABAoAAA==.',Ne='Nebur:AwADCAUABAoAAA==.',On='Oneshothel:AwACCAIABAoAAA==.',Or='Ortillious:AwAECAcABAoAAA==.',Ov='Overblood:AwAECAcABAoAAA==.',Pi='Piklerik:AwAGCBIABAoAAA==.',Po='Polargirl:AwAFCAwABAoAAA==.Poppafury:AwAFCAgABAoAAA==.',Pr='Pritee:AwADCAcABAoAAQEAAAAGCAEABAo=.',Qh='Qhaoz:AwADCAIABAoAAA==.',Ra='Rabite:AwADCAgABAoAAA==.Raevz:AwADCAQABAoAAA==.Raldoron:AwAICAgABAoAAA==.Ranz:AwAFCAUABAoAAA==.',Re='Reddemon:AwAGCA4ABAoAAA==.Reddhunter:AwABCAEABRQAAA==.Redpaladin:AwABCAEABAoAAQEAAAABCAEABRQ=.Renae:AwAICAoABAoAAA==.Restotee:AwAGCAEABAoAAA==.',Ri='Riastrad:AwABCAEABAoAAA==.Richie:AwAICAgABAoAAA==.',Sc='Scrappycoco:AwAICAgABAoAAA==.',Se='Selydaria:AwABCAEABAoAAQEAAAADCAMABAo=.Semnickmonk:AwAFCAEABAoAAA==.Serahealer:AwABCAEABRQDCwAHAQi0JgAzI5oBBAoACwAHAQi0JgAzI5oBBAoADAABAQheVgAF1x4ABAoAAA==.Serazal:AwACCAMABAoAAA==.',Sh='Shamoocha:AwAECAcABAoAAA==.Shirrazaha:AwACCAIABAoAAA==.',Sl='Slopster:AwAECAgABAoAAA==.',St='Stingerjb:AwAFCAgABAoAAA==.Strox:AwACCAEABAoAAA==.',Tb='Tbaw:AwAFCAQABAoAAA==.',Te='Teemond:AwAECAQABAoAAQEAAAAGCAEABAo=.Tekraa:AwABCAEABRQCCQAHAQgaLwBBcjACBAoACQAHAQgaLwBBcjACBAoAAA==.',Th='Thormor:AwABCAEABRQDDQAIAQgrBQBSidYCBAoADQAIAQgrBQBPbtYCBAoADgAHAQjqDABI2S8CBAoAAA==.',To='Tovenaar:AwAFCAgABAoAAA==.',Tr='Trajann:AwABCAEABAoAAQkAUX4BCAEABRQ=.Trogie:AwADCAEABAoAAA==.',Ve='Vexigar:AwABCAEABAoAAA==.',Vy='Vyrexiona:AwABCAEABRQCDwAHAQjgGQAcIGIBBAoADwAHAQjgGQAcIGIBBAoAAA==.',Wi='Wickedsparkz:AwAFCA4ABAoAAA==.Winneronly:AwAFCAUABAoAAA==.',Wy='Wykdpally:AwACCAIABAoAAA==.',Xa='Xarttoplek:AwAFCAYABAoAAQEAAAAFCAgABAo=.',Xk='Xkreat:AwABCAIABRQCCAAIAQitCQBa0BcDBAoACAAIAQitCQBa0BcDBAoAAA==.',Zh='Zhazhijae:AwAECAcABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end