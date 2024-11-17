local _G = getfenv(0)
local T = CreateFrame("Frame")
T.Ticks = {}
local PrevMana = 0
local SimpleBars_Mana = {
	Length = 2,
	Start = 0,
	End = 0,
	Mana = 0,
}

--[[ -- Event handler function
function SimpleBars_OnEvent(event)
    -- Handle mana events
    if (event == "UNIT_MANA" or event == "UNIT_MAXMANA") and arg1 == "player" then
        local currMana = UnitMana("player")
        if currMana > PrevMana and PrevMana ~= 0 then
            local manaGain = currMana - PrevMana
            _G["SimpleBars_TicksMana"]:SetText("MP/Tick: |c00FFFFFF" .. manaGain .. "|r")
            _G["SimpleBars_TickOverlay"].alphamana = 1 -- Reset alpha value
            print("Resetting alphamana to 1")
            _G["SimpleBars_TicksMana"]:SetAlpha(1)
            _G["SimpleBars_TicksMana"]:Show()

             -- Reset StatusBar
             local currTime = GetTime()
             SimpleBars_Mana.Start = currTime
             SimpleBars_Mana.End = currTime + SimpleBars_Mana.Length
            _G["SimpleBars_ManaTickBar"]:SetMinMaxValues(SimpleBars_Mana.Start, SimpleBars_Mana.End)
            _G["SimpleBars_ManaTickBar"]:SetValue(SimpleBars_Mana.Start)
            _G["SimpleBars_ManaTickBar"]:Show()
            _G["SimpleBars_ManaTickSpark"]:Show()
        end
        PrevMana = currMana
    end

    -- Handle other events like VARIABLES_LOADED or PLAYER_ENTERING_WORLD
    if event == "VARIABLES_LOADED" or event == "PLAYER_ENTERING_WORLD" then
        print("Addon initialized or Player entered world.")
        _G["SimpleBars_ManaTickSpark"]:SetVertexColor(0, 0.8, 0.8, 0.7)
    end
end ]]

-- Event handler function for managing different events
    function SimpleBars_OnEvent(event)
        if event == "UNIT_MANA" or event == "UNIT_MAXMANA" then
            if arg1 == "player" then
                local currMana = UnitMana("player")
                if currMana > PrevMana and PrevMana ~= 0 then
                    local manaGain = currMana - PrevMana
                    UpdateManaText(manaGain)
                    ResetManaTickAnimation()
                end
                PrevMana = currMana
            end
        elseif event == "VARIABLES_LOADED" or event == "PLAYER_ENTERING_WORLD" then
            InitializeAddon()
        end
    end

    -- Update mana text when mana regenerates
function UpdateManaText(manaGain)
    _G["SimpleBars_TicksMana"]:SetText("MP/Tick: |c00FFFFFF" .. manaGain .. "|r")
    _G["SimpleBars_TickOverlay"].alphamana = 1
    _G["SimpleBars_TicksMana"]:SetAlpha(1)
    _G["SimpleBars_TicksMana"]:Show()
end

-- Reset and initialize the mana tick animation
function ResetManaTickAnimation()
    local currTime = GetTime()
    SimpleBars_Mana.Start = currTime
    SimpleBars_Mana.End = currTime + SimpleBars_Mana.Length
    _G["SimpleBars_ManaTickBar"]:SetMinMaxValues(SimpleBars_Mana.Start, SimpleBars_Mana.End)
    _G["SimpleBars_ManaTickBar"]:SetValue(SimpleBars_Mana.Start)
    _G["SimpleBars_ManaTickBar"]:Show()
    _G["SimpleBars_ManaTickSpark"]:Show()
end

-- Initialize addon settings on load
function InitializeAddon()
    _G["SimpleBars_ManaTickSpark"]:SetVertexColor(0, 0.8, 0.8, 0.7)
end

-- Handle fading of the mana text
function T.Ticks:SimpleBars_Fade()
    if ( this.alphamana <= 0.25) then
        return
    end
    this.alphamana = this.alphamana - 0.0075
    _G["SimpleBars_TicksMana"]:SetAlpha(this.alphamana)
end


-- Handle the animation of the mana tick spark
function T.Ticks:SimpleBars_AnimateBar()
    local currTime = GetTime()
    if currTime <= SimpleBars_Mana.End then
        local sparkPosition = ((currTime - SimpleBars_Mana.Start) / (SimpleBars_Mana.End - SimpleBars_Mana.Start)) * SimpleBarsDB.manaFrame.width
        if sparkPosition > SimpleBarsDB.manaFrame.width then
            sparkPosition = SimpleBarsDB.manaFrame.width
        end
        _G["SimpleBars_ManaTickSpark"]:SetPoint("CENTER", _G["SimpleBars_ManaTickBar"], "LEFT", sparkPosition, 0)
    else
        _G["SimpleBars_ManaTickBar"]:Hide()
        _G["SimpleBars_TicksMana"]:Hide()
    end
end

function SimpleBars_AnimateBar()
    T.Ticks:SimpleBars_AnimateBar()
end

function SimpleBars_FadeAll(elapsed)
    this.update = this.update + elapsed
    if ( this.update >= 0.01 ) then
        this.update = this.update - 0.01
        T.Ticks:SimpleBars_Fade()
    end
end

T:RegisterEvent("PLAYER_ENTERING_WORLD")
T:SetScript("OnEvent", function()
    --_G["SimpleBars_TickOverlay"]:SetPoint("TOP", _G["SimpleBarsManaFrame"], "BOTTOM", 0, -5)
    _G["SimpleBars_TickOverlay"]:ClearAllPoints()
    --_G["SimpleBars_TickOverlay"]:SetPoint("TOP", _G["SimpleBarsManaFrame"], "BOTTOM", 0, -5)
    _G["SimpleBars_TickOverlay"]:SetAllPoints(_G["SimpleBarsManaFrame"])
    _G["SimpleBars_TickOverlay"]:SetWidth(SimpleBarsDB.manaFrame.width)
    _G["SimpleBars_TickOverlay"]:SetHeight(SimpleBarsDB.manaFrame.height)
    _G["SimpleBars_ManaTickBar"]:ClearAllPoints()
    _G["SimpleBars_ManaTickBar"]:SetAllPoints(_G["SimpleBars_TickOverlay"])
    _G["SimpleBars_ManaTickBar"]:SetWidth(SimpleBarsDB.manaFrame.width)
    _G["SimpleBars_ManaTickBar"]:SetHeight(SimpleBarsDB.manaFrame.height)
    _G["SimpleBars_ManaTickBar"]:SetFrameLevel(_G["SimpleBarsManaFrame"]:GetFrameLevel())
    _G["SimpleBars_ManaTickSpark"]:SetHeight(SimpleBarsDB.manaFrame.height)
end)
