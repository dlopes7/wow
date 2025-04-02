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
 local lookup = {'Unknown-Unknown','Evoker-Devastation','Warrior-Protection','Mage-Frost',}; local provider = {region='US',realm='Nesingwary',name='US',type='weekly',zone=42,date='2025-03-29',data={Ai='Airoh:AwAECAEABAoAAA==.',Ba='Badgerbadger:AwABCAEABAoAAA==.',Do='Dotdotded:AwABCAIABAoAAA==.Dotsomahan:AwAFCAEABAoAAA==.',Eo='Eo:AwAFCBIABAoAAA==.',Fa='Falorian:AwACCAIABAoAAA==.',Fl='Fluffinbaked:AwAECAoABAoAAA==.',Fr='Frankenberry:AwAGCA0ABAoAAA==.',Gl='Glüttony:AwAGCAIABAoAAA==.',Go='Gossip:AwAICAgABAoAAA==.',Gr='Gregiruma:AwAFCAcABAoAAA==.',He='Helsdottir:AwAFCBAABAoAAA==.Hesitant:AwAFCAsABAoAAA==.',It='Itzli:AwAHCA0ABAoAAQEAAAAHCA4ABAo=.',Jo='Jorj:AwAECAcABAoAAA==.',Ka='Kayos:AwAHCAEABAoAAA==.',Ku='Kungmoo:AwACCAIABAoAAA==.',Lo='Lochnessy:AwAHCA8ABAoCAgAHAQhBEQA5s+gBBAoAAgAHAQhBEQA5s+gBBAoAAA==.',Ma='Maldus:AwAHCA4ABAoAAA==.',Me='Melin:AwAECAYABAoAAA==.',Mi='Milough:AwADCAYABAoAAA==.Missfortune:AwACCAIABAoAAA==.',Mo='Molez:AwAICBAABAoCAwAIAQitAgBKuKwCBAoAAwAIAQitAgBKuKwCBAoAAA==.',Ni='Nic:AwAECAQABAoAAA==.Nicksamurai:AwADCAcABAoAAA==.',Ol='Oldrellik:AwABCAIABAoAAA==.',Om='Ombos:AwAHCAwABAoAAA==.',Ph='Pheldor:AwACCAEABAoAAA==.Phodacbiet:AwAECAIABAoAAA==.',Pr='Protector:AwAFCAEABAoAAQEAAAAGCAwABAo=.',Ra='Raelinn:AwADCAMABAoAAA==.Raevynn:AwAHCBIABAoAAA==.',Re='Rentetsuken:AwAGCAkABAoAAA==.',Sa='Samaeus:AwAGCAkABAoAAA==.',Si='Siddhartha:AwABCAEABAoAAQEAAAAGCA0ABAo=.',So='Sorwyn:AwABCAEABAoAAA==.',Sy='Synystersyd:AwAECAIABAoAAA==.',['S�']='Sýn:AwACCAQABAoAAA==.',Th='Thomasten:AwAICA8ABAoAAA==.Thunderlipz:AwAICA8ABAoAAA==.',Ut='Utopea:AwACCAIABAoAAA==.',Vi='Viddar:AwAHCA0ABAoAAA==.',Vo='Voxs:AwABCAIABRQCBAAHAQiUBwBYXcYCBAoABAAHAQiUBwBYXcYCBAoAAA==.',Wh='Whiny:AwAECAEABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end