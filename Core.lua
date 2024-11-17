SimpleBars = CreateFrame("Frame")
SimpleBars.elements = {}

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
    textures = {
        "Interface\\BUTTONS\\WHITE8X8",
        "Interface\\TargetingFrame\\UI-StatusBar",
        "Interface\\Tooltips\\UI-Tooltip-Background",
    },
    oocFade = false,
    oocFadeAlpha = 0.5,
    enableHealth = true,
    enableMana = true,
    enablePet = true,
    useClassColorForHealth = true
}

local function UpdateSettings()
	if not SimpleBarsDB then SimpleBarsDB = {} end
	for option, value in defaults do
		if SimpleBarsDB[option] == nil then
			SimpleBarsDB[option] = value
		end
	end
end

SimpleBars:RegisterEvent("VARIABLES_LOADED")
SimpleBars:RegisterEvent("PLAYER_LOGOUT")
SimpleBars:SetScript("OnEvent", function(event)
    UpdateSettings()

    for title, element in pairs(SimpleBars.elements) do
        if not SimpleBarsDB[title] then
            SimpleBarsDB[title] = element.enabled and 1 or 0
        end

        element:enable()
    end

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