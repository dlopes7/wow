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
 local lookup = {'Mage-Fire','Shaman-Enhancement','Shaman-Restoration','Hunter-Marksmanship','Hunter-BeastMastery','Priest-Discipline','Priest-Shadow','Warlock-Destruction','Unknown-Unknown','Mage-Frost','Druid-Balance','Druid-Restoration','Monk-Windwalker',}; local provider = {region='US',realm='Nazgrel',name='US',type='weekly',zone=42,date='2025-03-29',data={As='Asila:AwABCAEABAoAAA==.Asminamuel:AwACCAIABAoAAA==.',Ba='Batazpa:AwABCAEABAoAAA==.',Bl='Blazinember:AwAFCA0ABAoCAQAFAQgjRgAcwvgABAoAAQAFAQgjRgAcwvgABAoAAA==.',Bo='Bofa:AwABCAIABRQDAgAIAQi9DABTKXMCBAoAAgAHAQi9DABSanMCBAoAAwABAQiidQAZjTwABAoAAA==.',Ca='Calinor:AwAECAQABAoAAA==.',Ch='Chaol:AwADCAkABRQDBAADAQhOAQBeGiYBBRQABAADAQhOAQBeGiYBBRQABQABAQgsHgBOs0UABRQAAA==.Chaolz:AwAGCAYABAoAAQQAXhoDCAkABRQ=.Charming:AwAHCBUABAoDBgAHAQixJQASLxwBBAoABgAHAQixJQASLxwBBAoABwACAQjBSAASLzgABAoAAA==.Chasseressé:AwAGCAEABAoAAA==.',Cy='Cyro:AwACCAIABAoAAA==.',['C�']='Câloosâ:AwADCAMABAoAAA==.',Dh='Dhjacob:AwAECAIABAoAAA==.',Do='Dotpockets:AwAFCAgABAoAAA==.',El='Elek:AwABCAEABAoAAA==.',Gi='Gilidar:AwAECAoABAoAAA==.',Ic='Icrucify:AwAICAIABAoAAA==.',Ji='Jiyao:AwAHCA8ABAoAAA==.',Kh='Khalessie:AwADCAcABAoAAA==.',Ki='Kiselle:AwABCAEABAoAAA==.',Kr='Krillian:AwAGCAgABAoAAA==.',Li='Liths:AwAGCA0ABAoAAA==.',['L�']='Lèonàrdo:AwAFCA0ABAoAAQgAI7IDCAYABRQ=.',Me='Melunaura:AwABCAEABAoAAQkAAAAECAwABAo=.Meta:AwACCAQABRQDAQAIAQi/AwBg6kIDBAoAAQAIAQi/AwBfqEIDBAoACgACAQiZQABjOeQABAoAAA==.',Ne='Neb:AwAGCA0ABAoCCAAGAQhhOwAhEDEBBAoACAAGAQhhOwAhEDEBBAoAAA==.Necroy:AwAECAgABAoAAA==.',Ni='Nic:AwACCAMABRQDCwAIAQhqDgBYR58CBAoACwAHAQhqDgBWq58CBAoADAACAQimSQAZL2YABAoAAA==.Nightflurry:AwADCAgABAoAAA==.Niidalee:AwAFCAoABAoAAQkAAAAICAIABAo=.',No='Nosebleeds:AwAHCA8ABAoAAA==.',Oo='Oobydooby:AwACCAIABAoAAA==.',Re='Relaeha:AwAECAYABAoAAA==.',Rp='Rp:AwAFCAUABAoAAA==.',Sh='Shadowlich:AwAECBIABAoAAA==.Shamanoodles:AwABCAEABAoAAQkAAAAECAwABAo=.Shurie:AwAGCAQABAoAAA==.',Sn='Snoom:AwAGCAEABAoAAA==.',St='Stacks:AwADCAQABAoAAA==.',Th='Themuffinman:AwABCAEABAoAAQkAAAAFCA8ABAo=.',To='Tom:AwAFCAYABAoAAA==.',Ty='Tyvm:AwAECAcABAoAAA==.',Vi='Vinny:AwAGCA4ABAoAAA==.',Vo='Volti:AwABCAEABAoAAQ0ASLsBCAEABRQ=.Voltizen:AwABCAEABRQCDQAHAQheDgBIu0oCBAoADQAHAQheDgBIu0oCBAoAAA==.',Wh='Wheredabois:AwADCAQABAoAAA==.',Wi='Witheria:AwAECAwABAoAAA==.',Xa='Xarous:AwAFCA8ABAoAAA==.',Xw='Xweekling:AwAECAwABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end