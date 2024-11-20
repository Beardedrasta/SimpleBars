SimpleBars = CreateFrame("Frame")
SimpleBars.elements = {}
SimpleBars.api = {}

local function round(input, places)
    if not places then places = 0 end
    if type(input) == "number" and type(places) == "number" then
        local pow = 1
        for i = 1, places do pow = pow * 10 end
        return floor(input * pow + 0.5) / pow
    end
end

SimpleBars.round = round

local defaults = {
    manaFrame = {
        width = 150,
        height = 20,
        point = "CENTER",
        relativeTo = "UIParent",
        relativePoint = "CENTER",
        xOfs = 0,
        yOfs = -220,
        statusBarTexture = "Interface\\AddOns\\SimpleBars\\Media\\statusbar-texture.blp",
        statusBarColor = {
            mana = { 0.33, 0.61, 0.78 },
            energy = { 0.85, 0.65, 0.27 },
            rage = { 0.68, 0.33, 0.33 }

        },
        backgroundTexture = "Interface\\AddOns\\SimpleBars\\Media\\background.blp",
        backgroundColor = { 1, 1, 1, 1 },
    },
    healthFrame = {
        width = 150,
        height = 20,
        point = "CENTER",
        relativeTo = "UIParent",
        relativePoint = "CENTER",
        xOfs = 0,
        yOfs = -200,
        statusBarTexture = "Interface\\AddOns\\SimpleBars\\Media\\statusbar-texture.blp",
        statusBarColor = { 0.33, 0.68, 0.33 },
        backgroundTexture = "Interface\\AddOns\\SimpleBars\\Media\\background.blp",
        backgroundColor = { 1, 1, 1, 1 },
    },
    petFrame = {
        width = 75,
        height = 20,
        point = "CENTER",
        relativeTo = "UIParent",
        relativePoint = "CENTER",
        xOfs = -150,
        yOfs = -200,
        statusBarTexture = "Interface\\AddOns\\SimpleBars\\Media\\statusbar-texture.blp",
        statusBarColor = { 0.33, 0.68, 0.33 },
        backgroundTexture = "Interface\\AddOns\\SimpleBars\\Media\\background.blp",
        backgroundColor = { 1, 1, 1, 1 },
    },
    altFrame = {
        height = 12,
    },
    textures = {
        "Interface\\BUTTONS\\WHITE8X8",
        "Interface\\TargetingFrame\\UI-StatusBar",
        "Interface\\Tooltips\\UI-Tooltip-Background",
        "Interface\\AddOns\\SimpleBars\\Media\\background.blp",
    },
    fonts = {
        Blank = "Interface\\AddOns\\SimpleBars\\Media\\Font\\AdbobeBlank.ttf",
        BigNoodle = "Interface\\AddOns\\SimpleBars\\Media\\Font\\BigNoodleTitling.ttf",
        Continuum = "Interface\\AddOns\\SimpleBars\\Media\\Font\\Continuum.ttf",
        DieDieDie = "Interface\\AddOns\\SimpleBars\\Media\\Font\\DieDieDie.ttf",
        Expressway = "Interface\\AddOns\\SimpleBars\\Media\\Font\\Expressway.ttf",
        Homespun = "Interface\\AddOns\\SimpleBars\\Media\\Font\\Homespun.ttf",
        Hooge = "Interface\\AddOns\\SimpleBars\\Media\\Font\\Hooge.ttf",
        MyriadPro = "Interface\\AddOns\\SimpleBars\\Media\\Font\\Myriad-Pro.ttf",
        PTSansNarrowBold = "Interface\\AddOns\\SimpleBars\\Media\\Font\\PT-Sans-Narrow-Bold.ttf",
        PTSansNarrowRegular = "Interface\\AddOns\\SimpleBars\\Media\\Font\\PT-Sans-Narrow-Regular.ttf",
        RobotoMono = "Interface\\AddOns\\SimpleBars\\Media\\Font\\RobotoMono.ttf"
    },
    borders = {
       ["Simple"] = "Interface\\AddOns\\SimpleBars\\Media\\Border\\border.blp",
       ["Simple Thick"] = "Interface\\AddOns\\SimpleBars\\Media\\Border\\border-thick.blp",
       ["Roth Black"] = "Interface\\AddOns\\SimpleBars\\Media\\Border\\rothblack.blp",
       ["Roth"] = "Interface\\AddOns\\SimpleBars\\Media\\Border\\roth",
       ["Roth Blue"] = "Interface\\AddOns\\SimpleBars\\Media\\Border\\roth blue",
       ["Roth Green"] = "Interface\\AddOns\\SimpleBars\\Media\\Border\\roth green",
       ["Roth Orange"] = "Interface\\AddOns\\SimpleBars\\Media\\Border\\roth orange",
       ["Roth Red"] = "Interface\\AddOns\\SimpleBars\\Media\\Border\\roth red",
       ["Roth White"] = "Interface\\AddOns\\SimpleBars\\Media\\Border\\roth white",
       ["Roth Yellow"] = "Interface\\AddOns\\SimpleBars\\Media\\Border\\roth yellow",
       ["Neav"] = "Interface\\AddOns\\SimpleBars\\Media\\Border\\neav",
       ["Gray Border"] = "Interface\\AddOns\\SimpleBars\\Media\\Border\\grayborder",
       ["Couture"] = "Interface\\AddOns\\SimpleBars\\Media\\Border\\couture",
       ["Couture Blue"] = "Interface\\AddOns\\SimpleBars\\Media\\Border\\couture blue",
       ["Couture Gray"] = "Interface\\AddOns\\SimpleBars\\Media\\Border\\couture gray",
       ["Couture Green"] = "Interface\\AddOns\\SimpleBars\\Media\\Border\\couture green",
       ["Couture Orange"] = "Interface\\AddOns\\SimpleBars\\Media\\Border\\couture orange",
       ["Couture Red"] = "Interface\\AddOns\\SimpleBars\\Media\\Border\\couture red",
       ["Couture White"] = "Interface\\AddOns\\SimpleBars\\Media\\Border\\couture white",
       ["Couture Yellow"] = "Interface\\AddOns\\SimpleBars\\Media\\Border\\couture yellow",
       ["Caith"] = "Interface\\AddOns\\SimpleBars\\Media\\Border\\Caith",
       ["Caith Blue"] = "Interface\\AddOns\\SimpleBars\\Media\\Border\\Caith blue",
       ["Caith Green"] = "Interface\\AddOns\\SimpleBars\\Media\\Border\\Caith green",
       ["Caith Orange"] = "Interface\\AddOns\\SimpleBars\\Media\\Border\\Caith orange",
       ["Caith Red"] = "Interface\\AddOns\\SimpleBars\\Media\\Border\\Caith red",
       ["Caith White"] = "Interface\\AddOns\\SimpleBars\\Media\\Border\\Caith white",
       ["Caith Yellow"] = "Interface\\AddOns\\SimpleBars\\Media\\Border\\Caith yellow",
       
    },
    globalFont = "Interface\\AddOns\\SimpleBars\\Media\\Font\\Expressway.ttf",
    globalBorder = "Interface\\AddOns\\SimpleBars\\Media\\Border\\border.blp",
    borderInset = 14,
    borderSize = 14,
    mainFontSize = 14,
    petFontSize = 12,
    oocFade = false,
    oocFadeAlpha = 0.5,
    enableHealth = true,
    enableMana = true,
    enablePet = true,
    useClassColorForHealth = true,
    mouseOverText = true,
    minimapButtonAngle = 45,
    appearance = {
        border = {
            default = 3,
        }
    },
}

local Dewdrop = AceLibrary("Dewdrop-2.0")
local MinimapHolder = {}

local IsMinimapSquare
do
	local value
	function IsMinimapSquare()
		if value == nil then
			if not AceEvent or not AceEvent:IsFullyInitialized() then
				return IsAddOnLoaded("CornerMinimap") or IsAddOnLoaded("SquareMinimap") or IsAddOnLoaded("Squeenix")
			else
				value = IsAddOnLoaded("CornerMinimap") or IsAddOnLoaded("SquareMinimap") or IsAddOnLoaded("Squeenix") and true or false
			end
		end
		return value
	end
end

function MinimapHolder:Add(panel)
    panel.panel = self
    if not panel.minimapButton then
        local frame = CreateFrame("Button", panel.frame:GetName().."MinimapButton", Minimap)
        panel.minimapButton = frame
        frame.panel = panel
        frame:SetWidth(28)
        frame:SetHeight(28)
        frame:SetFrameStrata("BACKGROUND")
        frame:SetFrameLevel(4)
        frame:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
        local icon = frame:CreateTexture(frame:GetName().."Icon", "BACKGROUND")
        panel.minimapIcon = icon
        local path = "Interface\\AddOns\\SimpleBars\\Media\\mapIcon"
        icon:SetTexture(path)
        icon:SetAllPoints()
        local overlay = frame:CreateTexture(frame:GetName() .. "Overlay","OVERLAY")
        overlay:SetTexture("Interface\\AddOns\\SimpleBars\\Media\\configBorder.blp")
        overlay:SetAllPoints()
        frame:EnableMouse(true)
        frame:RegisterForClicks("LeftButtonUp")
        frame.panel = panel
        frame:SetScript("OnClick", function()
			if type(panel.OnClick) == "function" then
				if not this.dragged then
					panel:OnClick(arg1)
				end
			end
		end)
        frame:SetScript("OnReceiveDrag", function()
			if type(panel.OnReceiveDrag) == "function" then
				if not this.dragged then
					panel:OnReceiveDrag()
				end
			end
		end)
        frame:SetScript("OnMouseDown", function()
			this.dragged = false
			if arg1 == "LeftButton" and not IsShiftKeyDown() and not IsControlKeyDown() and not IsAltKeyDown() then
				HideDropDownMenu(1)
				if type(panel.OnMouseDown) == "function" then
					panel:OnMouseDown(arg1)
				end
			elseif arg1 == "RightButton" and not IsShiftKeyDown() and not IsControlKeyDown() and not IsAltKeyDown() then
				if Dewdrop:IsOpen(this) then
                    Dewdrop:Close()
                else
                    Dewdrop:Open(this, 'children', function(level, value)
                        if level == 1 then
                            Dewdrop:AddLine(
                                'text', "|cff66a07dSimpleBars QuickMenu|r",
                                'isTitle', true
                            )
                            Dewdrop:AddLine(
                                'text', " "
                            )
                            Dewdrop:AddLine(
                                'text', "Quick Toggles",
                                'isTitle', true
                            )
                            Dewdrop:AddLine(
                                'text', "Options",
                                'func', function() SB_ToggleOptions() end
                            )
                            Dewdrop:AddLine(
                                'text', "Health",
                                'func', function()
                                    SimpleBarsDB.enableHealth = not SimpleBarsDB.enableHealth
                                    SB_UpdateHealthVisibility()
                                  end,
                                'checked', SimpleBarsDB.enableHealth
                            )
                            Dewdrop:AddLine(
                                'text', "Power",
                                'func', function()
                                    SimpleBarsDB.enableMana = not SimpleBarsDB.enableMana
                                    SB_UpdateManaVisibility()
                                end,
                                'checked', SimpleBarsDB.enableMana
                            )
                            Dewdrop:AddLine(
                                'text', "Pet",
                                'func', function()
                                    SimpleBarsDB.enablePet = not SimpleBarsDB.enablePet
                                    SB_UpdatePetVisibility()
                                end,
                                'checked', SimpleBarsDB.enablePet
                            )
                        end
                    end)
                end
			else
				HideDropDownMenu(1)
				if type(panel.OnMouseDown) == "function" then
					panel:OnMouseDown(arg1)
				end
			end
		end)
        frame:SetScript("OnMouseUp", function()
			if not this.dragged and type(panel.OnMouseUp) == "function" then
				panel:OnMouseUp(arg1)
			end
		end)
        frame:SetScript("OnEnter", function() 
            GameTooltip:SetOwner(this, "ANCHOR_LEFT")
            GameTooltip:SetText("SimpleBars", 0.40, 0.63, 0.49)
            GameTooltip:AddLine("|cffffd700Left-Click|r to display commands", 1, 1, 1)
            GameTooltip:AddLine("|cffffd700Right-click|r for menu", 1, 1, 1)
            GameTooltip:AddLine("|cffffd700Drag|r to move", 1, 1, 1)
            GameTooltip:AddLine("|cffffd700Alt + Drag|r to move away from minimap", 1, 1, 1)
            GameTooltip:Show()
        end)
        frame:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)
        frame:RegisterForDrag("LeftButton")
        frame:SetScript("OnDragStart", self.OnDragStart)
        frame:SetScript("OnDragStop", self.OnDragStop)
    end
    panel.frame:Hide()
    panel.minimapButton:Show()
    self:Relocate(panel)
    --table.insert(self.panels, panel)
    local exists = false
    return true
end

function MinimapHolder:RemovePanel(i)
    if type(i) == "table" then
        i = self:IndexOfPanel(i)
        if not i then
            return
        end
    end
    local t = self.panels
    local panel = t[i]
    assert(panel.panel == self, "Panel has improper panel field")
    panel:SetPanel(nil)
    --table.remove(t, i)
end

function MinimapHolder:Relocate(panel)
	local frame = panel.minimapButton
	if SimpleBarsDB and SimpleBarsDB.minimapPositionWild then
		frame:SetPoint("CENTER", UIParent, "BOTTOMLEFT", SimpleBarsDB.minimapPositionX, SimpleBarsDB.minimapPositionY)
	elseif not SimpleBarsDB and panel.minimapPositionWild then
		frame:SetPoint("CENTER", UIParent, "BOTTOMLEFT", panel.minimapPositionX, panel.minimapPositionY)
	else
		local position
		if SimpleBarsDB then
			position = SimpleBarsDB.minimapPosition or panel.defaultMinimapPosition or math.random(1, 360)
		else
			position = panel.minimapPosition or panel.defaultMinimapPosition or math.random(1, 360)
		end
		local angle = math.rad(position or 0)
		local x,y
		if not IsMinimapSquare() then
			x = math.cos(angle) * 80
			y = math.sin(angle) * 80
		else
			x = 110 * math.cos(angle)
			y = 110 * math.sin(angle)
			x = math.max(-82, math.min(x, 84))
			y = math.max(-86, math.min(y, 82))
		end
		frame:SetPoint("CENTER", Minimap, "CENTER", x, y)
	end
end

function MinimapHolder:GetPanel(i)
	return self.panels[i]
end

function MinimapHolder:GetNumPanels()
	return table.getn(self.panels)
end

function MinimapHolder:IndexOfPanel(panel)
	for i,p in ipairs(self.panels) do
		if p == panel then
			return i, "MINIMAP"
		end
	end
end

function MinimapHolder:HasPanel(panel)
	return self:IndexOfPanel(panel) ~= nil
end

function MinimapHolder:GetPanelSide(panel)
	local index = self:IndexOfPanel(panel)
	assert(index, "Panel not in panel")
	return "MINIMAP"
end

function MinimapHolder.OnDragStart()
	this.dragged = true
	this:LockHighlight()
	this:SetScript("OnUpdate", MinimapHolder.OnUpdate)
end

function MinimapHolder.OnDragStop()
	this:SetScript("OnUpdate", nil)
	this:UnlockHighlight()
end

function MinimapHolder.OnUpdate()
	if not IsAltKeyDown() then
		local mx, my = Minimap:GetCenter()
		local px, py = GetCursorPosition()
		local scale = UIParent:GetEffectiveScale()
		px, py = px / scale, py / scale
		local position = math.deg(math.atan2(py - my, px - mx))
		if position <= 0 then
			position = position + 360
		elseif position > 360 then
			position = position - 360
		end
		if SimpleBarsDB then
			SimpleBarsDB.minimapPosition = position
			SimpleBarsDB.minimapPositionX = nil
			SimpleBarsDB.minimapPositionY = nil
			SimpleBarsDB.minimapPositionWild = nil
		else
			this.panel.minimapPosition = position
			this.panel.minimapPositionX = nil
			this.panel.minimapPositionY = nil
			this.panel.minimapPositionWild = nil
		end
	else
		local px, py = GetCursorPosition()
		local scale = UIParent:GetEffectiveScale()
		px, py = px / scale, py / scale
		if SimpleBarsDB then
			SimpleBarsDB.minimapPositionX = px
			SimpleBarsDB.minimapPositionY = py
			SimpleBarsDB.minimapPosition = nil
			SimpleBarsDB.minimapPositionWild = true
		else
			this.panel.minimapPositionX = px
			this.panel.minimapPositionY = py
			this.panel.minimapPosition = nil
			this.panel.minimapPositionWild = true
		end
	end
	MinimapHolder:Relocate(this.panel)
end

local myPanel = {
    frame = CreateFrame("Frame", "SimpleBarsPanelFrame", UIParent)
}

--[[ minimapButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(this, "ANCHOR_LEFT")
    GameTooltip:SetText("SimpleBars", 1, 1, 1)
    GameTooltip:AddLine("Left-Click to display commands", 1, 1, 1)
    GameTooltip:AddLine("Right-click for menu", 1, 1, 1)
    GameTooltip:AddLine("Shift + Drag to move", 1, 1, 1)
    GameTooltip:Show()
end)

minimapButton:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
end) ]]

local function UpdateDefault(t, s)
    for key, value in pairs(s) do
        if type(value) == "table" then
            if type(t[key]) ~= "table" then
                t[key] = {}
            end
            UpdateDefault(t[key], value)
        elseif t[key] == nil then
            t[key] = value
        end
    end
end

local function UpdateSettings()
	if not SimpleBarsDB then SimpleBarsDB = {} end
	UpdateDefault(SimpleBarsDB, defaults)
end


SimpleBars:RegisterEvent("VARIABLES_LOADED")
SimpleBars:RegisterEvent("PLAYER_LOGOUT")
SimpleBars:RegisterEvent("PLAYER_ENTERING_WORLD")

SimpleBars:SetScript("OnEvent", function(event)
    UpdateSettings()

    for title, element in pairs(SimpleBars.elements) do
        if not SimpleBarsDB[title] then
            SimpleBarsDB[title] = element.enabled and 1 or 0
        end

        element:enable()
    end

    MinimapHolder:Add(myPanel)

    if event == "PLAYER_LOGOUT" then
        UpdateSettings()
    end 
end)


SimpleBars.register = function(_, element)
    SimpleBars.elements[element.title] = element
    return SimpleBars.elements[element.title]
end

function SB_print(text)
    DEFAULT_CHAT_FRAME:AddMessage(text)
end

local sbR, sbG, sbB, sbA = .4, .4, .4, 1
local bdR, bdG, bdB, bdA = 0.8, 0.8, 0.8, 1
SimpleBars.api.CreateBackdrop = SimpleBars.api.CreateBackdrop or function(frame, inset, legacy, transparent)
    if not frame then
        return
    end

    local border = inset
    if not border then
        border = 3
    end

    if transparent then
        bdA = transparent
    end

    if legacy then
        frame:SetBackdrop({
            bgFile = "Interface\\AddOns\\SimpleBars\\Media\\background.blp",
            edgeFile = "Interface\\AddOns\\SimpleBars\\Media\\Border\\thick-border.blp",
            tile = false, tileSize = 16, edgeSize = 16,
            insets = { left = 8, right = 8, top = 8, bottom = 8 }})
        frame:SetBackdropColor(bdR, bdG, bdB, bdA)
        frame:SetBackdropBorderColor(sbR, sbG, sbB, sbA)
    else
        frame:SetBackdrop({
            bgFile = "Interface\\AddOns\\SimpleBars\\Media\\background.blp",
            edgeFile = "Interface\\AddOns\\SimpleBars\\Media\\Border\\border.blp",
            tile = false, tileSize = 16, edgeSize = 16,
            insets = { left = 8, right = 8, top = 8, bottom = 8 }})
        frame:SetBackdropColor(bdR, bdG, bdB, bdA)
        frame:SetBackdropBorderColor(sbR, sbG, sbB, sbA)
    end

    if frame.SetHitRectInsets then
        frame:SetHitRectInsets(-border, -border, -border, -border)
    end

    if not frame.backdrop then
        frame:SetBackdrop(nil)

        local border = border - 1
        local backdrop 
        if border < 1 then
            backdrop = {
                bgFile = "Interface\\AddOns\\SimpleBars\\Media\\background.blp",
                edgeFile = "Interface\\AddOns\\SimpleBars\\Media\\Border\\thick-border.blp",
                tile = false, tileSize = 16, edgeSize = 16,
                insets = { left = 8, right = 8, top = 8, bottom = 8 }
            }
        end
        local b = CreateFrame("Frame", nil, frame)
        b:SetPoint("TOPLEFT", frame, "TOPLEFT", -border, border)
        b:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", border, -border)

        local level = frame:GetFrameLevel()
        if level < 1 then
            b:SetFrameLevel(level)
        else
            b:SetFrameLevel(level - 1)
        end

        frame.backdrop = b
        b:SetBackdrop(backdrop)
    end

    local b = frame.backdrop
    b:SetBackdropColor(bdR, bdG, bdB, bdA)
    b:SetBackdropBorderColor(sbR, sbG, sbB, sbA)
end

SimpleBars.api.SetButtonFont = SimpleBars.api.SetButtonFont or function(button, font, size, flags)
    if button.SetFont then
        button:SetFont(font, size, flags)
    else
        local buttonText = button:GetFontString()
        if buttonText then
            buttonText:SetFont(font, size, flags)
        else
            buttonText = button:CreateFontString(nil, "OVERLAY")
            buttonText:SetFont(font, size, flags)
            buttonText:SetPoint("CENTER", button, "CENTER")
            button:SetFontString(buttonText)
        end
    end
end

SimpleBars.api.SkinButton = SimpleBars.api.SkinButton or function(button, colorR, colorG, colorB)
    local b = getglobal(button)
    if not b then
        b = button
    end
    if not b then
        return
    end
    if not colorR or not colorG or not colorB then
        _, class = UnitClass("player")
        local color = RAID_CLASS_COLORS[class]
        colorR, colorG, colorB = color.r, color.g, color.b
    end
    SimpleBars.api.CreateBackdrop(b, nil, false)
    b:SetNormalTexture(nil)
    b:SetHighlightTexture(nil)
    b:SetPushedTexture(nil)
    b:SetDisabledTexture(nil)
    b:SetScript("OnEnter", function()
        SimpleBars.api.CreateBackdrop(b, nil, false)
        b:SetBackdropBorderColor(colorR, colorG, colorB, 1)
    end)
    b:SetScript("OnLeave", function()
        SimpleBars.api.CreateBackdrop(b, nil, false)
    end)
    SimpleBars.api.SetButtonFont(b, STANDARD_TEXT_FONT, 12, "OUTLINE")
end

SimpleBarsCustomFont = CreateFont("SimpleBarsCustomFont_Main")
SimpleBarsCustomFont:SetFont("Interface\\AddOns\\SimpleBars\\Media\\Font\\Expressway.ttf", 14, "")
SimpleBarsCustomFont:SetTextColor(1, 0.82, 0)
SimpleBarsCustomFont:SetShadowColor(0, 0, 0, 1)
SimpleBarsCustomFont:SetShadowOffset(1, -1)

SimpleBarsCustomFont_Alt = CreateFont("SimpleBarsCustomFont_Alt")
SimpleBarsCustomFont_Alt:SetFont("Interface\\AddOns\\SimpleBars\\Media\\Font\\Expressway.ttf", 12, "")
SimpleBarsCustomFont_Alt:SetTextColor(1, 0.82, 0)
SimpleBarsCustomFont_Alt:SetShadowColor(0, 0, 0, 1)
SimpleBarsCustomFont_Alt:SetShadowOffset(1, -1)

SimpleBarsCustomFont_Pet = CreateFont("SimpleBarsCustomFont_Pet")
SimpleBarsCustomFont_Pet:SetFont("Interface\\AddOns\\SimpleBars\\Media\\Font\\Expressway.ttf", 12, "")
SimpleBarsCustomFont_Pet:SetTextColor(1, 0.82, 0)
SimpleBarsCustomFont_Pet:SetShadowColor(0, 0, 0, 1)
SimpleBarsCustomFont_Pet:SetShadowOffset(1, -1)

SimpleBarsFormFont = CreateFont("SimpleBarsFormFont")
SimpleBarsFormFont:SetFont("Interface\\AddOns\\SimpleBars\\Media\\Font\\Expressway.ttf", 24, "")
SimpleBarsFormFont:SetTextColor(1, 0.82, 0)
SimpleBarsFormFont:SetShadowColor(0, 0, 0, 1)
SimpleBarsFormFont:SetShadowOffset(1, -1)

function SB_ToggleOptions()
    if SimpleBarsOptions:IsShown() then
        SimpleBarsOptions:Hide()
    else
        SimpleBarsOptions:Show()
    end
end