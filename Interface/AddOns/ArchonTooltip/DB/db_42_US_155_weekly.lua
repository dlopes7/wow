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
 local lookup = {'Paladin-Retribution','Hunter-BeastMastery','Unknown-Unknown','Rogue-Outlaw','Rogue-Subtlety','Rogue-Assassination','Shaman-Enhancement','Evoker-Preservation','Evoker-Devastation','Paladin-Holy','Mage-Frost','Priest-Holy','Shaman-Elemental','Shaman-Restoration','DemonHunter-Havoc','DemonHunter-Vengeance','Mage-Fire','Warrior-Arms','Warrior-Fury','Warrior-Protection','Priest-Discipline','Priest-Shadow','Warlock-Demonology','Warlock-Affliction','DeathKnight-Unholy','DeathKnight-Frost','Warlock-Destruction',}; local provider = {region='US',realm='Medivh',name='US',type='weekly',zone=42,date='2025-03-29',data={Ab='Abashai:AwACCAUABAoAAA==.',Ad='Adouken:AwADCAUABAoAAA==.',Ae='Aellyria:AwAECAQABAoAAA==.',Ag='Agga:AwACCAIABAoAAA==.',Ak='Akintharo:AwADCAUABAoAAA==.',Al='Alexiya:AwADCAUABAoAAA==.Allisandra:AwAFCAkABAoAAA==.Allumer:AwADCAoABAoAAA==.',An='Anconia:AwACCAMABAoAAA==.Antibear:AwAECAgABAoAAA==.',Ap='Apito:AwAGCAQABAoAAA==.',Ar='Arakar:AwAECAsABAoAAA==.Armorya:AwABCAEABRQAAA==.Armyofone:AwACCAIABAoAAA==.Artaius:AwAFCAoABAoAAA==.',As='Assari:AwAFCAsABAoAAA==.',At='Athelf:AwABCAIABRQCAQAHAQhdQQA6a+QBBAoAAQAHAQhdQQA6a+QBBAoAAA==.',Au='Augtistic:AwAFCAkABAoAAA==.',Ba='Baalos:AwAGCBEABAoAAA==.',Be='Beastkael:AwADCAUABAoAAA==.Beliir:AwADCAIABAoAAA==.Bellanca:AwADCAUABAoAAA==.Benadryl:AwACCAIABAoAAA==.',Bi='Bingo:AwAFCAkABAoAAA==.',Bl='Blackheárt:AwACCAMABAoAAA==.Blax:AwACCAIABAoAAA==.Blightbath:AwADCAcABAoAAA==.',Bo='Bolener:AwAGCAsABAoAAA==.Bolenor:AwAECAkABRQCAgAEAQi+AQBLBoMBBRQAAgAEAQi+AQBLBoMBBRQAAA==.Bonethugz:AwAHCBUABAoCAgAHAQjzKgBCvwwCBAoAAgAHAQjzKgBCvwwCBAoAAA==.Boombawks:AwAFCA0ABAoAAA==.Bourjay:AwAGCAkABAoAAA==.',Br='Brightside:AwAGCA4ABAoAAA==.Bruid:AwAHCAUABAoAAA==.Brunny:AwADCAMABAoAAQMAAAAHCAUABAo=.',Ca='Calastaa:AwADCAUABAoAAQMAAAAGCAoABAo=.Cammus:AwAICAgABAoAAA==.',Ce='Cerul:AwADCAMABAoAAA==.',Ch='Chifairy:AwADCAMABAoAAA==.Chissgoria:AwAFCAsABAoAAA==.',Cl='Cliss:AwACCAUABAoAAA==.',Co='Copiousconns:AwADCAIABAoAAA==.',Cp='Cptstabn:AwAHCBwABAoEBAAHAQgtAgBRGWYCBAoABAAHAQgtAgBRGWYCBAoABQADAQgLJAAlOqsABAoABgACAQgEJwAyhWMABAoAAA==.',Cr='Cranked:AwAECAoABAoAAA==.',Da='Dakkron:AwAFCAwABAoAAA==.Darkzehn:AwAECAcABAoAAA==.',De='Decaylol:AwAHCBwABAoCBwAHAQiAFAAzyvkBBAoABwAHAQiAFAAzyvkBBAoAAA==.Deceptakahn:AwABCAEABRQAAA==.Deelee:AwAFCAcABAoAAA==.Deydora:AwAHCA0ABAoAAA==.Deydoralia:AwAHCBEABAoAAA==.',Di='Diô:AwADCAUABAoAAA==.',Dj='Djs:AwACCAUABAoAAA==.',Do='Dorfe:AwADCAIABAoAAA==.',Dr='Dracofairy:AwABCAMABRQDCAAHAQgFBABMk3ICBAoACAAHAQgFBABMk3ICBAoACQAGAQgqDwBROA4CBAoAAA==.Draconas:AwADCAUABAoAAA==.Dragonpants:AwAHCBwABAoCCQAHAQheCwBU1FwCBAoACQAHAQheCwBU1FwCBAoAAA==.Draych:AwABCAMABRQCCgAHAQigDABAS+sBBAoACgAHAQigDABAS+sBBAoAAA==.Dreijer:AwABCAEABAoAAA==.Drewgarymore:AwAGCAcABAoAAA==.Drudgan:AwACCAEABAoAAA==.',Du='Durandall:AwABCAEABRQAAA==.Dustall:AwABCAIABRQCAQAHAQhgSAA1mckBBAoAAQAHAQhgSAA1mckBBAoAAA==.',Ei='Einkil:AwADCAUABAoAAA==.',El='Elki:AwAGCA0ABAoAAA==.Eluned:AwAFCAsABAoAAA==.Elurah:AwADCAMABAoAAA==.',Em='Emberlée:AwAECAMABAoAAQMAAAAHCBEABAo=.',Fi='Fibbs:AwADCAIABAoAAA==.Firocios:AwACCAUABAoAAA==.',Fr='Frankyzappa:AwADCAUABAoAAA==.Frink:AwADCAUABAoAAA==.Frostyfella:AwABCAIABRQCCwAHAQgHCQBaLaoCBAoACwAHAQgHCQBaLaoCBAoAAA==.',['F�']='Fëld:AwADCAMABAoAAA==.',Ga='Gardlier:AwAHCAsABAoAAA==.',Gl='Gleave:AwAGCA0ABAoAAA==.Glimmerdin:AwABCAEABAoAAQwAR+8DCAMABRQ=.',Go='Gorfot:AwAFCAYABAoAAA==.Gowancomando:AwACCAUABAoAAA==.',Gr='Grandd:AwADCAIABAoAAA==.Granpa:AwABCAEABAoAAA==.',Ha='Hashacha:AwADCAMABAoAAA==.',He='Hecaate:AwAHCAwABAoAAA==.Hendil:AwADCAIABAoAAA==.',Ho='Hobe:AwADCAcABAoAAA==.',Hu='Humoresque:AwADCAUABAoAAA==.',Ic='Icyblades:AwAGCA0ABAoAAA==.',Il='Ilyna:AwADCAIABAoAAA==.',Im='Immortalnut:AwAGCAwABAoAAA==.',It='Itscell:AwAFCAgABAoAAA==.',Iz='Izen:AwADCAIABAoAAA==.',Ja='Jagviper:AwABCAEABAoAAQMAAAAECAoABAo=.',Ji='Jirikì:AwAHCAgABAoAAA==.',Jo='Joobs:AwAGCA4ABAoAAA==.',Ka='Kali:AwACCAMABAoAAA==.Kapachka:AwABCAEABAoAAA==.Kazetricity:AwACCAIABRQDDQAIAQhVDgBDK04CBAoADQAIAQhVDgBDK04CBAoADgACAQihZwAT+GwABAoAAA==.',Ke='Keria:AwAECAgABRQCDwAEAQj8AABUkJ0BBRQADwAEAQj8AABUkJ0BBRQAAA==.Keyz:AwAGCAYABAoAAA==.',Ki='Killteam:AwAGCA4ABAoAAA==.',Ky='Kynetik:AwAGCAYABAoAARAAF88HCBwABAo=.',La='Lawlipopkid:AwADCAUABAoAAA==.',Le='Lexiê:AwADCAIABAoAAA==.',Li='Lilillidari:AwAGCA0ABAoAAA==.',Lt='Lto:AwADCAMABAoAAQMAAAADCAMABAo=.',Lu='Ludemon:AwAFCAsABAoAAA==.',Ly='Lysithea:AwADCAMABAoAAA==.',Ma='Mairek:AwABCAIABRQDEQAHAQhwJQA0gNsBBAoAEQAHAQhwJQA0gNsBBAoACwAEAQhQVQATn4wABAoAAA==.',Mi='Minevra:AwABCAEABAoAAA==.',Mo='Monkeydluffy:AwAECAQABAoAAA==.Moosand:AwAECAQABAoAAA==.',My='Myrrim:AwADCAYABAoAAA==.',['M�']='Móth:AwADCAEABAoAAA==.',Na='Nacia:AwADCAIABAoAAA==.Narbzy:AwACCAYABAoAAA==.',No='Notorious:AwAHCBMABAoAAA==.',Ny='Nyrri:AwACCAIABAoAAA==.Nysson:AwADCAcABAoAAA==.',On='Onlyslams:AwABCAEABRQEEgAGAQg0EABILuwBBAoAEgAGAQg0EABEpuwBBAoAEwAFAQg/NwArbCMBBAoAFAAFAQhrFQAiEMsABAoAAA==.',Or='Orter:AwADCAUABAoAAA==.',Pa='Pallylove:AwAICAkABAoAAA==.Parce:AwAFCAkABAoAAA==.',Ph='Phiba:AwAECAoABAoAAA==.',Pu='Puckish:AwABCAIABRQAAA==.Purifie:AwABCAEABAoAAA==.',Ra='Rafie:AwADCAIABAoAAA==.Rahlock:AwABCAEABAoAAA==.Rahruhai:AwAGCAwABAoAAA==.Raphael:AwADCAoABAoAAA==.Rasik:AwAFCAoABAoAAA==.Rayel:AwADCAcABAoAAA==.',Re='Rendingo:AwADCAMABAoAAA==.',Rh='Rhoana:AwACCAEABAoAAA==.',Ri='Ribald:AwADCAIABAoAAA==.',Ro='Rogirogue:AwADCAUABAoAAA==.',Ry='Ryzian:AwABCAEABAoAAA==.',Sa='Saintabes:AwADCAMABRQDDAAIAQjZCgBH72oCBAoADAAIAQjZCgBH72oCBAoAFQABAQjcVQAiDS0ABAoAAA==.Saiorse:AwAFCAgABAoAAA==.Sammael:AwACCAUABAoAAA==.Sandara:AwADCAMABRQDFgAIAQgTBQBWYwEDBAoAFgAIAQgTBQBWYwEDBAoAFQABAQg7VwAJKCsABAoAAA==.Sareinai:AwABCAEABAoAAA==.Sargarach:AwABCAEABAoAAA==.',Sc='Scapegoat:AwEFCAsABAoAAA==.Scaryspice:AwABCAEABAoAAA==.Scatty:AwAGCAwABAoAAA==.Scraime:AwAFCAoABAoAAA==.',Se='Seilah:AwADCAcABAoAAA==.Seliah:AwABCAEABAoAAA==.Senpai:AwAGCAIABAoAAA==.',Sh='Shadowglade:AwAFCAsABAoAAA==.Shammydavis:AwAICAcABAoAAA==.Shammysneg:AwABCAEABAoAAA==.Shraan:AwACCAUABAoAAA==.Shrapnel:AwACCAUABAoAAA==.',Sm='Smithers:AwAFCAkABAoAAA==.',Sn='Sneakybunny:AwAFCAsABAoAAA==.',So='Sockra:AwACCAIABAoAAA==.Soladriel:AwADCAcABAoAAA==.Soulbreaker:AwADCAIABAoAAA==.',St='Stozij:AwACCAIABAoAAA==.',Sy='Syvarris:AwAGCAEABAoAAA==.',Ta='Tahner:AwACCAEABAoAAA==.Taner:AwADCAIABAoAAA==.',Th='Thorin:AwAFCA8ABAoAAA==.Thorson:AwACCAIABAoAAA==.Thundertime:AwADCAIABAoAAA==.',To='Tonytonychop:AwACCAIABAoAAA==.Toshidot:AwAGCBYABAoDFwAGAQgcDwA5e3MBBAoAFwAFAQgcDwBEAHMBBAoAGAABAQh+LAAE4DAABAoAAA==.',Tr='Trajann:AwADCAMABAoAAQEAUX4BCAEABRQ=.Trazatra:AwACCAMABAoAAA==.Trolaso:AwAHCAMABAoAAA==.',Tu='Tuonadari:AwACCAUABAoAAA==.Tuprimitagil:AwAICBAABAoAAQEAQ7MDCAgABRQ=.Tust:AwAICCYABAoDGQAIAQhBBQBdgBIDBAoAGQAIAQhBBQBdYhIDBAoAGgAEAQghCwBcvpUBBAoAAQMAAAABCAIABRQ=.',Va='Valgor:AwAHCBwABAoCGwAHAQh7LgAnL4ABBAoAGwAHAQh7LgAnL4ABBAoAAA==.Valkuridk:AwAGCBEABAoAAA==.',Ve='Velcroh:AwABCAEABRQAAA==.Velcrøh:AwADCAMABAoAAQMAAAABCAEABRQ=.',Vi='Virulent:AwABCAEABAoAAA==.',Wa='Waghnakanaka:AwAFCAQABAoAAA==.Warkast:AwACCAUABAoAAA==.Watermelonz:AwADCAUABAoAAA==.',Wy='Wyldone:AwAICAUABAoAAA==.',['W�']='Wäyman:AwAFCAsABAoAAA==.',Xa='Xandraxh:AwADCAUABAoAAA==.',Xy='Xylarra:AwAFCAsABAoAAA==.',Yu='Yujikaido:AwAECAEABAoAAA==.',Zy='Zyther:AwADCAcABAoAAA==.',},}; provider.parse = parse;if ArchonTooltip.AddProviderV2 then ArchonTooltip.AddProviderV2(lookup, provider) end