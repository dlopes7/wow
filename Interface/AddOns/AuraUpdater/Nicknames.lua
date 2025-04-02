---@diagnostic disable: undefined-field
local _, LUP = ...

local CustomNames
local Grid2NicknameStatus
local vuhDoHooks = {}
local nicknameToCharacterCache = {} -- For use in GetCharacterInGroup()

local presetNicknames = {
    ["Algo#2565"] = "Algo",
    ["Azortharion#2528"] = "Azor",
    ["Naemesis#2526"] = "Bart",
    ["Cavollir#2410"] = "Cav",
    ["Chaos#26157"] = "Chaos",
    ["c1nder#21466"] = "Cinder",
    ["khebul#2314"] = "Crt",
    ["EffyxWoW#2713"] = "Effy",
    ["Freddynqkken#2913"] = "Freddy",
    ["jackazzem#2214"] = "Jack",
    ["Jhonz#2356"] = "Jon",
    ["Kantom#2289"] = "Mini",
    ["Mytheos#1649"] = "Mytheos",
    ["Sors#2676"] = "Nick",
    ["Nightwanta#2473"] = "Night",
    ["Saunderz#2405"] = "Olly",
    ["Ottojj#2715"] = "Otto",
    ["Prebby#2112"] = "Prebby",
    ["Rose#22507"] = "Rose",
    ["Ryler#1217"] = "Ryler",
    ["Drarrven#2327"] = "Soul",
    ["Tínie#2208"] = "Tinie",
    ["Tonikor#2964"] = "Toni",
    ["Vespion#2971"] = "Vespion",
    ["Wrexad#21129"] = "Wrexa",
}

-- Pescorus players have preset nicknames associated with their BattleTag
-- This returns their preset nickname
function LUP:GetPresetNickname()
    local _, battleTag = BNGetInfo()
    
    return battleTag and presetNicknames[battleTag]
end

-- Returns Name-Realm for a unit
-- Nicknames are always stored using Name-Realm as indices
local function RealmIncludedName(unit)
    local name, realm = UnitNameUnmodified(unit)

    if not realm then
        realm = GetNormalizedRealmName()
    end

    if not realm then return end -- Called before PLAYER_LOGIN

    return string.format("%s-%s", name, realm)
end

-- VuhDo
local vuhDoPanelSettings = {}

local function UpdateVuhDoName(unit, nameText, buttonName)
    local name = LiquidUpdaterSaved.settings.vuhDoNicknames and AuraUpdater:GetNickname(unit) or UnitName(unit)

    -- Respect the max character option (if set)
    local panelNumber = buttonName and buttonName:match("^Vd(%d+)")
    panelNumber = tonumber(panelNumber)

    local maxChars = panelNumber and vuhDoPanelSettings[panelNumber] and vuhDoPanelSettings[panelNumber].maxChars
    
    if name and maxChars and maxChars > 0 then
        name = name:sub(1, maxChars)
    end

    nameText:SetFormattedText(name or "") -- SetText is hooked, so we use this instead
end

local function RefreshVuhDoNameForUnit(unit)
    if not VUHDO_UNIT_BUTTONS then return end
    if not unit then return end
    if not UnitExists(unit) then return end

    for vuhDoUnit, unitButtons in pairs(VUHDO_UNIT_BUTTONS) do
        if UnitIsUnit(unit, vuhDoUnit) then
            for _, button in ipairs(unitButtons) do
                local unitButtonName = button:GetName()
                local nameText = _G[unitButtonName .. "BgBarIcBarHlBarTxPnlUnN"]
                
                UpdateVuhDoName(unit, nameText, unitButtonName)
            end

            break
        end
     end
end

function LUP:RefreshAllVuhDoNames()
    if not VUHDO_UNIT_BUTTONS then return end

    for unit, unitButtons in pairs(VUHDO_UNIT_BUTTONS) do
        for _, button in ipairs(unitButtons) do
            local unitButtonName = button:GetName()
            local nameText = _G[unitButtonName .. "BgBarIcBarHlBarTxPnlUnN"]

            UpdateVuhDoName(unit, nameText, unitButtonName)
        end
     end
end

local function HookVuhDo()
    if VUHDO_PANEL_SETUP then
        for i, settings in pairs(VUHDO_PANEL_SETUP) do
            local textSettings = type(settings) == "table" and settings.PANEL_COLOR and settings.PANEL_COLOR.TEXT

            vuhDoPanelSettings[i] = textSettings
        end
    end

	hooksecurefunc(
		"VUHDO_getBarText",
		function(unitHealthBar)
			local unitFrameName = unitHealthBar and unitHealthBar.GetName and unitHealthBar:GetName()

			if not unitFrameName then return end

			local nameText = _G[unitFrameName .. "TxPnlUnN"]

			if not nameText then return end
			if vuhDoHooks[nameText] then return end

            local unitButton = _G[unitFrameName:match("(.+)BgBarIcBarHlBar")]

            if not unitButton then return end

			hooksecurefunc(
				nameText,
				"SetText",
				function(self)
                    local unit = unitButton.raidid

                    UpdateVuhDoName(unit, self, unitFrameName)
				end
			)

			vuhDoHooks[nameText] = true
		end
	)
end

-- Grid2 (can be found under Miscellaneous -> AuraUpdater Nickname)
local function AddGrid2Status()
    local statusName = "AuraUpdater Nickname"

    Grid2NicknameStatus = Grid2.statusPrototype:new(statusName)
    Grid2NicknameStatus.IsActive = Grid2.statusLibrary.IsActive

    function Grid2NicknameStatus:UNIT_NAME_UPDATE(_, unit)
        self:UpdateIndicators(unit)
    end

    function Grid2NicknameStatus:OnEnable()
        self:RegisterEvent("UNIT_NAME_UPDATE")
    end

    function Grid2NicknameStatus:OnDisable()
        self:UnregisterEvent("UNIT_NAME_UPDATE")
    end

    function Grid2NicknameStatus:GetText(unit)
        return AuraUpdater:GetNickname(unit) or ""
    end

    local function Create(baseKey, dbx)
        Grid2:RegisterStatus(Grid2NicknameStatus, {"text"}, baseKey, dbx)

        return Grid2NicknameStatus
    end

    Grid2.setupFunc[statusName] = Create

    Grid2:DbSetStatusDefaultValue(statusName, {type = statusName})
end

local function AddGrid2Options()
    if Grid2NicknameStatus then
        Grid2Options:RegisterStatusOptions("AuraUpdater Nickname", "misc", function() end)
    end
end

-- ElvUI (adds "nickname-lenX" tag, where X is the length between 1 and 12)
local function AddElvTag()
    if ElvUF and ElvUF.Tags then
        ElvUF.Tags.Events["nickname"] = "UNIT_NAME_UPDATE"
        ElvUF.Tags.Methods["nickname"] = function(unit)
            return AuraUpdater:GetNickname(unit) or ""
        end

        for i = 1, 12 do
            ElvUF.Tags.Events["nickname-len" .. i] = "UNIT_NAME_UPDATE"
            ElvUF.Tags.Methods["nickname-len" .. i] = function(unit)
                local nickname = AuraUpdater:GetNickname(unit)

                return nickname and nickname:sub(1, i) or ""
            end
        end
    end
end

-- Cell
local function UpdateCellNicknames()
    if not CellDB then return end
    if not CellDB.nicknames then return end

    -- Insert nicknames
    for name, nickname in pairs(LiquidUpdaterSaved.nicknames) do
        local cellFormat = string.format("%s:%s", name, nickname)

        -- Insert nickname if it doesn't already exist, and refresh unit frame if necessary
        if tInsertUnique(CellDB.nicknames.list, cellFormat) then
            Cell:Fire("UpdateNicknames", "list-update", name, nickname)
        end
    end
end

-- CustomNames
function LUP:RegisterCustomNamesNicknames()
    if not CustomNames then return end

    for name, nickname in pairs(LiquidUpdaterSaved.nicknames) do
        CustomNames.Set(name, nickname)
    end
end

function LUP:UnregisterCustomNamesNicknames()
    if not CustomNames then return end

    for name, nickname in pairs(LiquidUpdaterSaved.nicknames) do
        local customNamesNickname = CustomNames.Get(name)

        if customNamesNickname == nickname then
            CustomNames.Set(name)
        end
    end
end

-- WeakAuras (overrides GetName etc. functions
-- This should only be done if CustomNames addon is not loaded, since that override them too, and has priority
local function OverrideWeakAurasFunctions()
    if WeakAuras.GetName then
        WeakAuras.GetName = function(name)
            if not name then return end

            return AuraUpdater:GetNickname(name) or name
        end
    end

    if WeakAuras.UnitName then
        WeakAuras.UnitName = function(unit)
            if not unit then return end

            local name, realm = UnitName(unit)

            if not name then return end

            return AuraUpdater:GetNickname(unit) or name, realm
        end
    end

    if WeakAuras.GetUnitName then
        WeakAuras.GetUnitName = function(unit, showServerName)
            if not unit then return end

            if not UnitIsPlayer(unit) then
                return GetUnitName(unit)
            end

            local name = UnitNameUnmodified(unit)
            local nameRealm = GetUnitName(unit, showServerName)
            local suffix = nameRealm:match(".+(%s%(%*%))") or nameRealm:match(".+(%-.+)") or ""

            return string.format("%s%s", AuraUpdater:GetNickname(unit) or name, suffix)
        end
    end

    if WeakAuras.UnitFullName then
        WeakAuras.UnitFullName = function(unit)
            if not unit then return end

            local name, realm = UnitFullName(unit)

            if not name then return end

            return AuraUpdater:GetNickname(unit) or name, realm
        end
    end
end

function LUP:UpdateNicknameForUnit(unit, nickname)
    -- Nicknames are always stored using Name-Realm as indices (even for your own characters)
    local realmIncludedName = RealmIncludedName(unit)

    if not realmIncludedName then return end

    -- Nicknames should not have leading or trailing spaces (this shouldn't be possible if set through AuraUpdater, but still)
    -- If a nickname is an empty string, set it to nil so we remove the entry from the database entirely
    nickname = nickname and strtrim(nickname)

    if nickname == "" then nickname = nil end

    -- Update nicknameToCharacterCache for use in GetCharacterInGroup()
    -- This has the potential to nil others' nicknames if two players share the same nickname, but take care of that inside GetCharacterInGroup()
    local oldNickname = LiquidUpdaterSaved.nicknames[realmIncludedName]

    if oldNickname then
        nicknameToCharacterCache[oldNickname] = nil
    end

    if nickname then
        nicknameToCharacterCache[nickname] = unit
    end

    LiquidUpdaterSaved.nicknames[realmIncludedName] = nickname

    -- Set nicknames in CustomNames addon if installed (used by several other addons)
    -- Check if the nickname already exists in CustomNames before we do, otherwise it spam prints
    -- Don't delete any CustomNames nicknames (if nickname is nil)
    if nickname and CustomNames and LiquidUpdaterSaved.settings.CustomNames then
        local customNamesNickname = CustomNames.Get(unit)

        if not customNamesNickname or customNamesNickname ~= nickname then
            CustomNames.Set(unit, nickname)
        end
    end

    -- If we are using Grid2, update the nickname on the character's unit frame
    if Grid2NicknameStatus then
        for groupUnit in LUP:IterateGroupMembers() do
            if UnitIsUnit(unit, groupUnit) then
                Grid2NicknameStatus:UpdateIndicators(groupUnit)

                break
            end
        end
    end

    -- If we are using Cell, update the nickname for this unit
    if Cell and CellDB and CellDB.nicknames then
        local oldEntry = oldNickname and string.format("%s:%s", realmIncludedName, oldNickname)
        local newEntry = nickname and string.format("%s:%s", realmIncludedName, nickname)

        local cellIndex -- Index in CellDB.nicknames.list of name:oldNickname (if any)

        if oldEntry then
            cellIndex = tIndexOf(CellDB.nicknames.list, oldEntry)
        end

        if cellIndex then -- Update existing nickname entry
            if newEntry then
                CellDB.nicknames.list[cellIndex] = newEntry
            else
                table.remove(CellDB.nicknames.list, cellIndex)
            end
        else -- Create new nickname entry
            table.insert(CellDB.nicknames.list, newEntry)
        end

        Cell:Fire("UpdateNicknames", "list-update", realmIncludedName, nickname)
    end

    -- If we are using VuhDo, refresh the unit frame name for this unit
    RefreshVuhDoNameForUnit(unit)
end

function AuraUpdater:GetNickname(unit)
    if not unit then return end
    if not UnitExists(unit) then return end

    if not UnitIsPlayer(unit) then
        return GetUnitName(unit)
    end

    local realmIncludedName = RealmIncludedName(unit)
    local nickname = LiquidUpdaterSaved.nicknames[realmIncludedName or ""]

    if not nickname then
        nickname = UnitNameUnmodified(unit)
    end

    local formatString = "%s"
    local classFileName = UnitClassBase(unit)

    if classFileName then
        formatString = string.format("|c%s%%s|r", RAID_CLASS_COLORS[classFileName].colorStr)
    end

    return nickname, formatString
end

-- For a given nickname, returns the character in the group that is associated with it
-- This could either be a name or an actual unit id (no guarantees)
function AuraUpdater:GetCharacterInGroup(nickname)
    local character = nicknameToCharacterCache[nickname]

    if not character then
        for unit in LUP:IterateGroupMembers() do
            local _nickname = AuraUpdater:GetNickname(unit)

            if _nickname == nickname then
                return unit
            end
        end
    end

    return character
end

function LUP:InitializeNicknames()
    CustomNames = C_AddOns.IsAddOnLoaded("CustomNames") and LibStub("CustomNames")

    -- WeakAuras functions
    if WeakAuras and not CustomNames and not LiquidAPI then
        OverrideWeakAurasFunctions()
    end

    -- Grid2 status
    if C_AddOns.IsAddOnLoaded("Grid2") then
        AddGrid2Status()
    end
    
    -- Elv tag
    if C_AddOns.IsAddOnLoaded("ElvUI") then
        AddElvTag()
    end

    -- Cell
    if C_AddOns.IsAddOnLoaded("Cell") then
        UpdateCellNicknames()
    end

    -- MRT
    if C_AddOns.IsAddOnLoaded("MRT") and GMRT and GMRT.F then
        GMRT.F:RegisterCallback(
            "RaidCooldowns_Bar_TextName",
            function(_, _, gsubData)
                if gsubData and gsubData.name then
                    gsubData.name = AuraUpdater:GetNickname(gsubData.name) or gsubData.name
                end
            end
        )
    end

    -- VuhDo
    if C_AddOns.IsAddOnLoaded("VuhDo") then
        HookVuhDo()
    end
end

-- When Grid2Options loads, add an empty set of options for AuraUpdater Nicknames
-- If this is not done, viewing the status throws a Lua error
local f = CreateFrame("Frame")

f:RegisterEvent("ADDON_LOADED")

f:SetScript(
    "OnEvent",
    function(_, _, addOnName)
        if addOnName == "Grid2Options" then
            AddGrid2Options()
        end
    end
)