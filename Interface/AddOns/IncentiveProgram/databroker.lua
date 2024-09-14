-----------------------------
------Incentive Program------
----Created by: Jacob Beu----
-----Xubera @ US-Alleria-----
-----------Grubsey-----------
-------------Syl-------------
--------r22 | 2024/07/27-----
-----------------------------

local addonName, IncentiveProgram = ...
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local minimap = LibStub("LibDBIcon-1.0")

--Local copy of the class
local databroker

---------------------------------------
-- Class: DataBroker
-- This class creates the DataBroker
---------------------------------------
local IncentiveProgramDataBroker = {
    new = function(self)
        local obj = {}
        setmetatable(obj, self)
        self.__index = self
        
        obj.dataBroker = ldb:NewDataObject("IncentiveProgram", {
            type = "data source",
            text = "5",
            value = "5",
            label = "Incentive",
            
            icon = IncentiveProgram.Icons["INCENTIVE_RARE"],
            OnClick = function(clickedframe, button, down)
                IncentiveProgram:GetFrame():OnClick(button, down, clickedframe)
            end
        })

        minimap:Register("IncentiveProgram", obj.dataBroker, IncentiveProgram:GetSettings():GetSetting(IncentiveProgram.Settings["MINIMAP"]))
        
        return obj
    end,
 
---------------------------------------
-- SetData sets the DataBroker information
-- @params
--      self - DataBroker Class
--		count - the value to set to Text and Value
--		texture - the texture to use
-- @returns
--		nil
--------------------------------------- 
    SetData = function(self, count, texture)
        if ( not texture ) then
            texture = IncentiveProgram.Icons["INCENTIVE_NONE"]
        end
        
        self.dataBroker.text = count
        self.dataBroker.value = count
        self.dataBroker.icon = texture
    end

}

---------------------------------------
-- IncentiveProgram:GetDataBroker() is a global function.  This returns the DataBroker Class
-- @params
--      nil
-- @returns
--		DataBroker Class
---------------------------------------  
function IncentiveProgram:GetDataBroker()
    if not databroker then
        databroker = IncentiveProgramDataBroker:new()
    end
    return databroker
end