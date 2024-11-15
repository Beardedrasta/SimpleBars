local element = SimpleBars:register({
    title = "Resource Bars",
    description = "Display simple health and mana statusbars.",
    enabled = nil,
})

local DruidLib = AceLibrary("DruidLib-2.0")

element.enable = function()
    local statusbars = CreateFrame("Frame")
    SimpleBars.statusbars = statusbars

    local HealthBar, ManaBar = SimpleBarsHealthFrame, SimpleBarsManaFrame;
    local HealthBorder, ManaBorder = SimpleBarsHealthFrameBorder, SimpleBarsManaFrameBorder;
    local healthSettings = SimpleBarsDB.healthFrame
    local manaSettings = SimpleBarsDB.manaFrame

    HealthBar:ClearAllPoints()
    HealthBar:SetPoint(SimpleBarsDB.healthFrame.point, UIParent, SimpleBarsDB.healthFrame.relativePoint, SimpleBarsDB.healthFrame.xOfs, SimpleBarsDB.healthFrame.yOfs)
    HealthBar:RegisterForDrag("LeftButton")
    HealthBar:SetFrameLevel(1)
    HealthBorder:SetBackdrop({
        edgeFile = "Interface\\AddOns\\SimpleBars\\Media\\border.blp",
        edgeSize = 14,
    })
    HealthBorder:SetFrameLevel(3)
    HealthBorder:SetBackdropBorderColor(0.25, 0.25, 0.25, 1)

    HealthBar.statusBar = CreateFrame("StatusBar", nil, HealthBar)
    HealthBar.statusBar:SetMinMaxValues(0, UnitHealthMax("player"))
    HealthBar.statusBar:SetAllPoints()
    HealthBar.statusBar:SetStatusBarTexture(healthSettings.statusBarTexture)
    HealthBar.statusBar:SetStatusBarColor(unpack(healthSettings.statusBarColor))

    HealthBar.text = HealthBar.statusBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    HealthBar.text:SetPoint("CENTER", HealthBar.statusBar, "CENTER", 0, 0)

    ManaBar:ClearAllPoints()
    ManaBar:SetPoint(SimpleBarsDB.manaFrame.point, UIParent, SimpleBarsDB.manaFrame.relativePoint, SimpleBarsDB.manaFrame.xOfs, SimpleBarsDB.manaFrame.yOfs)
    ManaBar:RegisterForDrag("LeftButton")
    ManaBar:SetFrameLevel(3)
    ManaBorder:SetBackdrop({
        edgeFile = "Interface\\AddOns\\SimpleBars\\Media\\border.blp",
        edgeSize = 14,
    })
    ManaBorder:SetFrameLevel(5)
    ManaBorder:SetBackdropBorderColor(0.25, 0.25, 0.25, 1)

    ManaBar.statusBar = CreateFrame("StatusBar", nil, ManaBar)
    ManaBar.statusBar:SetMinMaxValues(0, UnitManaMax("player"))
    ManaBar.statusBar:SetAllPoints()
    ManaBar.statusBar:SetStatusBarTexture(manaSettings.statusBarTexture)
    ManaBar.statusBar:SetStatusBarColor(unpack(manaSettings.statusBarColor.mana))
    ManaBar.statusBar:SetFrameLevel(4)

    ManaBar.text = ManaBar.statusBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    ManaBar.text:SetPoint("CENTER", ManaBar.statusBar, "CENTER", 0, 0)

    ManaBar.altPower = CreateFrame("StatusBar", "SimpleBarsAltPowerFrame", ManaBar, "TextStatusBar")
    ManaBar.altPower:SetWidth(SimpleBarsDB.manaFrame.width / 2)
	ManaBar.altPower:SetHeight(12)
	ManaBar.altPower:SetStatusBarTexture(manaSettings.statusBarTexture)
	ManaBar.altPower:SetStatusBarColor(unpack(manaSettings.statusBarColor.mana))
    ManaBar.altPower:SetPoint("TOP", ManaBar, "BOTTOM", 0, -1)
    ManaBar.altPower:SetFrameLevel(ManaBar:GetFrameLevel() - 3)

    local bg = ManaBar.altPower:CreateTexture("$parentBackground", "BACKGROUND")
	bg:SetAllPoints(ManaBar.altPower)
	bg:SetTexture("Interface\\AddOns\\SimpleBars\\Media\\background.blp")
	bg:SetVertexColor(1, 1, 1, 1)
	ManaBar.altPower.bg = bg

    local bd = CreateFrame("Frame", "$parentBorder", ManaBar.altPower)
    bd:SetWidth(SimpleBarsDB.manaFrame.width / 2 + 12)
	bd:SetHeight(28)
    bd:SetPoint("CENTER", 0, 2)
    bd:SetBackdrop({
        edgeFile = "Interface\\AddOns\\SimpleBars\\Media\\thick-border.blp",
        edgeSize = 12,
    })
    bd:SetBackdropBorderColor(0.25, 0.25, 0.25, 1)
    bd:SetFrameLevel(ManaBar:GetFrameLevel() - 2)

--[[     local bd = ManaBar.altPower:CreateTexture("$parentBorder", "OVERLAY")
	bd:SetWidth(SimpleBarsDB.manaFrame.width / 2 + 19)
	bd:SetHeight(16)
	bd:SetTexture("Interface\\CharacterFrame\\UI-CharacterFrame-GroupIndicator")
    bd:SetPoint("TOPLEFT", -10, 0)
    bd:SetTexCoord(0.0234375, 0.6875, 1.0, 0.0)
    bd:SetVertexColor(0.25, 0.25, 0.25, 1) ]]
	ManaBar.altPower.bd = bd

    local text = ManaBar.altPower:CreateFontString("$parentText", "OVERLAY", "GameFontNormal")
	text:SetPoint("CENTER", 0, 0)
	SetTextStatusBarText(ManaBar.altPower, text)
	ManaBar.altPower.textLockable = 1
	ManaBar.altPower.text = text

    function UpdateAltPower()
        if UnitPowerType("player") ~= 0 then
		    ManaBar.altPower:Show()
	    else
		    ManaBar.altPower:Hide()
	    end
    end

    ManaBar.altPower:RegisterEvent("PLAYER_AURAS_CHANGED")
    ManaBar.altPower:RegisterEvent("UPDATE_SHAPESHIFT_FORMS")
    ManaBar.altPower:SetScript("OnEvent", function()
        UpdateAltPower()
    end)

    ManaBar.altPower:SetScript("OnUpdate", function()
		local currMana, maxMana = DruidLib:GetMana()
		ManaBar.altPower:SetMinMaxValues(0, maxMana)
		ManaBar.altPower:SetValue(currMana)
	end)


    local function UpdateHealth(statusbar, fontString)
        if SimpleBarsDB.useClassColorForHealth then
            local _, class = UnitClass("player")
            local classColor = RAID_CLASS_COLORS[class]
            if classColor then
                statusbar:SetStatusBarColor(classColor.r, classColor.g, classColor.b)
            end
        else
            statusbar:SetStatusBarColor(unpack(healthSettings.statusBarColor))
        end

        local currentMana = UnitHealth("player")
        local maxMana = UnitHealthMax("player")
        if maxMana > 0 then
            statusbar:SetMinMaxValues(0, maxMana)
            statusbar:SetValue(currentMana)
            fontString:SetText(currentMana .. " / " .. maxMana)
        end
    end

    local function UpdateMana(statusbar, fontString)
        local currentMana = UnitMana("player")
        local maxMana = UnitManaMax("player")
        if maxMana > 0 then
            statusbar:SetMinMaxValues(0, maxMana)
            statusbar:SetValue(currentMana)
            fontString:SetText(currentMana .. " / " .. maxMana)
        end
    end

    local function UpdatePowerType(statusbar)
        local powerType = UnitPowerType("player")
        if powerType == 0 then
            statusbar:SetStatusBarColor(unpack(manaSettings.statusBarColor.mana))
        elseif powerType == 3 then
            statusbar:SetStatusBarColor(unpack(manaSettings.statusBarColor.energy))
        elseif powerType == 1 then
            statusbar:SetStatusBarColor(unpack(manaSettings.statusBarColor.rage))
        end
    end

    local manaUpdate = 0
    ManaBar:SetScript("OnUpdate", function()
        manaUpdate = manaUpdate + arg1
        if manaUpdate > 0.1 then -- Update every 0.1 seconds
            UpdatePowerType(ManaBar.statusBar)
            UpdateMana(ManaBar.statusBar, ManaBar.text)
            manaUpdate = 0
        end
    end)

    local healthUpdate = 0
    HealthBar:SetScript("OnUpdate", function()
        healthUpdate = healthUpdate + arg1
        if healthUpdate > 0.1 then -- Update every 0.1 seconds
            UpdateHealth(HealthBar.statusBar, HealthBar.text)
            healthUpdate = 0
        end
    end)

    function statusbars:UpdateHealthVisibility()
        if SimpleBarsDB.enableHealth then
            HealthBar:Show()
        else
            HealthBar:Hide()
        end

        HealthBar:SetWidth(SimpleBarsDB.healthFrame.width)
        HealthBar:SetHeight(SimpleBarsDB.healthFrame.height)
        HealthBorder:SetWidth(SimpleBarsDB.healthFrame.width + 14)
        HealthBorder:SetHeight(SimpleBarsDB.healthFrame.height + 14)

    end

    function statusbars:UpdateManaVisibility()
        if SimpleBarsDB.enableMana then
            ManaBar:Show()
        else
            ManaBar:Hide()
        end

        ManaBar:SetWidth(SimpleBarsDB.manaFrame.width)
        ManaBar:SetHeight(SimpleBarsDB.manaFrame.height)
        ManaBorder:SetWidth(SimpleBarsDB.manaFrame.width + 14)
        ManaBorder:SetHeight(SimpleBarsDB.manaFrame.height + 14)
        ManaBar.altPower:SetWidth(SimpleBarsDB.manaFrame.width / 2)
        ManaBar.altPower.bd:SetWidth(SimpleBarsDB.manaFrame.width / 2 + 12)
    end


    local function UpdateFade()
        if SimpleBarsDB.oocFade then
            if InCombat() then
                HealthBar:SetAlpha(1)
                ManaBar:SetAlpha(1)
            else
                HealthBar:SetAlpha(SimpleBarsDB.oocFadeAlpha)
                ManaBar:SetAlpha(SimpleBarsDB.oocFadeAlpha)
            end
        else
            HealthBar:SetAlpha(1)
            ManaBar:SetAlpha(1)
        end
    end

    do
        UpdateHealth(HealthBar.statusBar, HealthBar.text)
        UpdatePowerType(ManaBar.statusBar)
        UpdateMana(ManaBar.statusBar, ManaBar.text)
        UpdateAltPower()
    end

    statusbars:RegisterEvent("PLAYER_ENTERING_WORLD")
    statusbars:RegisterEvent("VARIABLES_LOADED")
    statusbars:RegisterEvent("PLAYER_ENTER_COMBAT")
    statusbars:RegisterEvent("PLAYER_LEAVE_COMBAT")
    statusbars:RegisterEvent("PLAYER_REGEN_DISABLED")
    statusbars:RegisterEvent("PLAYER_REGEN_ENABLED")
    statusbars:SetScript("OnEvent", function()
        statusbars:UpdateHealthVisibility()
        statusbars:UpdateManaVisibility()
        UpdateFade()
        UpdateAltPower()
    end)

    SLASH_SIMPLEBARS1 = "/sb"
    SlashCmdList["SIMPLEBARS"] = function(msg)
        msg = string.lower(msg)
        if msg == "" or msg == nil then
            print("SimpleBars Commands:")
            print("/sb healthcolor - Toggle class color for health bar")
            print("/sb toggle health - Show/Hide the health bar")
            print("/sb toggle power - Show/Hide the mana bar")
            print("/sb toggle ooc - Enables fade out of combat situations")
            print("/sb ooc - Sets the fade amount for ooc fading")
            print("/sb health width <value> - Set the width of the health bar")
            print("/sb health height <value> - Set the height of the health bar")
            print("/sb mana width <value> - Set the width of the mana bar")
            print("/sb mana height <value> - Set the height of the mana bar")
        elseif msg == "healthcolor" then
            SimpleBarsDB.useClassColorForHealth = not SimpleBarsDB.useClassColorForHealth
            print("Class color for health bar: " .. (SimpleBarsDB.useClassColorForHealth and "Enabled" or "Disabled"))
            UpdateHealth(HealthBar.statusBar, HealthBar.text)
        elseif msg == "toggle health" then
            SimpleBarsDB.enableHealth = not SimpleBarsDB.enableHealth
            print("Health Bar: " .. (SimpleBarsDB.enableHealth and "Enabled" or "Disabled"))
            statusbars:UpdateHealthVisibility()
        elseif msg == "toggle power" then
            SimpleBarsDB.enableMana = not SimpleBarsDB.enableMana
            print("Mana Bar: " .. (SimpleBarsDB.enableMana and "Enabled" or "Disabled"))
            statusbars:UpdateManaVisibility()
        elseif msg == "toggle ooc" then
            SimpleBarsDB.oocFade = not SimpleBarsDB.oocFade
            print("Out of Combat fading: " .. (SimpleBarsDB.oocFade and "Enabled" or "Disabled"))
            UpdateFade()
        elseif msg == "ooc alpha" then
            local value = tonumber(rest)
        elseif msg == "reset" then
            SimpleBarsDB = nil
            ReloadUI()
        else
            -- Split command and value manually
            local firstSpace = string.find(msg, " ")
            if firstSpace then
                local command = string.sub(msg, 1, firstSpace - 1)
                local rest = string.sub(msg, firstSpace + 1)
    
                if command == "health" then
                    -- Find subcommand and value
                    local secondSpace = string.find(rest, " ")
                    if secondSpace then
                        local subCommand = string.sub(rest, 1, secondSpace - 1)
                        local value = tonumber(string.sub(rest, secondSpace + 1))
    
                        if subCommand == "width" and value then
                            SimpleBarsDB.healthFrame.width = value
                            HealthBar:SetWidth(value)
                            HealthBorder:SetWidth(value + 14)
                            print("Health Bar width set to " .. value)
                        elseif subCommand == "height" and value then
                            SimpleBarsDB.healthFrame.height = value
                            HealthBar:SetHeight(value)
                            HealthBorder:SetHeight(value + 14)
                            print("Health Bar height set to " .. value)
                        end
                    end
                elseif command == "mana" then
                    -- Find subcommand and value for mana bar
                    local secondSpace = string.find(rest, " ")
                    if secondSpace then
                        local subCommand = string.sub(rest, 1, secondSpace - 1)
                        local value = tonumber(string.sub(rest, secondSpace + 1))
    
                        if subCommand == "width" and value then
                            SimpleBarsDB.manaFrame.width = value
                            ManaBar:SetWidth(value)
                            ManaBorder:SetWidth(value + 14)
                            ManaBar.altPower:SetWidth(value / 2)
                            ManaBar.altPower.bd:SetWidth(value / 2 + 12)
                            print("Mana Bar width set to " .. value)
                        elseif subCommand == "height" and value then
                            SimpleBarsDB.manaFrame.height = value
                            ManaBar:SetHeight(value)
                            ManaBorder:SetHeight(value + 14)
                            print("Mana Bar height set to " .. value)
                        end
                    end
                elseif command == "ooc" then
                    local secondSpace = string.find(rest, " ")

                    if secondSpace then
                        local subCommand = string.sub(rest, 1, secondSpace - 1)
                        local value = tonumber(string.sub(rest, secondSpace + 1))
                        if subCommand == "alpha" then 
                            if value and value >= 0 and value <= 1 then
                                SimpleBarsDB.oocFadeAlpha = value
                                UpdateFade()
                                print("Out of Combat Alpha: " .. value)
                            else
                                print("Invalid value. Please provide a value between 0.0 and 1.0.")
                            end
                        end
                    end
                end
            end
        end
    end
end
