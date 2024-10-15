local addonName, addonTab = ...
local L = addonTab.L --{ Localization
addonTab.version = C_AddOns.GetAddOnMetadata(addonName, "Version")

local buttonHeight = 20;
local numEntries = 5; --{ How many entries to show at a time. Includes Default Text, Titles, and Dividers. Don't get #table, we don't want to show them all as this is a scrollable dropdown list.
local maxScrollExtent = buttonHeight * numEntries;

local Dropdown = CreateFrame("DropdownButton", nil, UIParent, "WowStyle1DropdownTemplate")
    Dropdown:SetDefaultText("Current Profile") --{ Get current profile
    Dropdown:SetPoint("CENTER")

    Dropdown:SetupMenu(function(dropdown, rootDescription)
        -- rootDescription:SetScrollMode(maxScrollExtent);
        rootDescription:CreateTitle("Test Menu")
        rootDescription:CreateButton("Button 1", function() print("Clicked 1") end)
        rootDescription:CreateButton("Button number 2 Button number 2 Button number 2", function() print("Clicked button 2") end)
        rootDescription:CreateButton("Third Button", function() print("Clicked the third button") end)
        rootDescription:CreateDivider()
        rootDescription:CreateTitle(addonName)





        local function debugButtonFactor(buttonName)
            rootDescription:CreateButton("Button "..buttonName, function() print("Clicked Button "..buttonName) end)



            --{ Radio Buttons showing Honor Example }
            -- local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(1792) --{ Honor Player vs. Player from patch 9.0.1
            -- local radio = rootDescription:CreateRadio("Button "..buttonName, IsSelected, SetSelected, currencyData);
            -- radio:AddInitializer(function(button, description, menu)
            --     local rightTexture = button:AttachTexture();
            --     rightTexture:SetSize(18, 18);
            --     rightTexture:SetPoint("RIGHT");
            --     rightTexture:SetTexture(currencyInfo.iconFileID);
            --     local fontString = button:AttachFontString();
            --     fontString:SetHeight(20);
            --     fontString:SetPoint("LEFT");
            --     fontString:SetJustifyH("LEFT");
            --     fontString:SetText(BreakUpLargeNumbers(currencyInfo.quantity));
            --     -- fontString:SetTextColor(1,1,1,1);
            --     -- local fontString2 = button:AttachFontString();
            --     -- fontString2:SetHeight(20);
            --     -- fontString2:SetPoint("RIGHT");
            --     -- fontString2:SetJustifyH("RIGHT");
            --     -- fontString2:SetText(BreakUpLargeNumbers(currencyInfo.quantity));
            --     -- Manual calculation required to accomodate aligned text.
            --     local pad = 7;
            --     local width = pad + fontString:GetUnboundedStringWidth() + rightTexture:GetWidth();
            --     local height = 20;
            --     return width, height;
            -- end);
        end

        for i=6, 22 do
            debugButtonFactor(i)
        end

        local columns = 3;
        rootDescription:SetGridMode(MenuConstants.VerticalGridDirection, columns);
        local function AutoCalculateColumns(count)
            if count > 36 then
                return 4;
            elseif count > 24 then
                return 3;
            elseif count > 10 then
                return 2;
            end
            return 1;
        end

    end)
