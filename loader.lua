--[[
    excluse universal loader (Master Build)
--]]

-- 1. FIX FOR XENO COREGUI CRASH
pcall(function()
    if game:GetService("CoreGui"):FindFirstChild("RobloxGui") then
        local resetBindable = game:GetService("CoreGui").RobloxGui:FindFirstChild("ResetButton")
        if resetBindable then
            resetBindable:Destroy()
        end
    end
end)

print("LOADER STARTED")

-- 2. THEME
getgenv().SecureMode = false
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
print("RAYFIELD LOADED")

local GalaxyTheme = {
    TextColor = Color3.fromRGB(240, 245, 255), Background = Color3.fromRGB(10, 12, 18),
    Topbar = Color3.fromRGB(15, 18, 28), Shadow = Color3.fromRGB(0, 0, 0),
    NotificationBackground = Color3.fromRGB(20, 25, 35), NotificationActionsBackground = Color3.fromRGB(30, 35, 45),
    TabBackground = Color3.fromRGB(15, 18, 28), TabStroke = Color3.fromRGB(40, 45, 60),
    TabBackgroundSelected = Color3.fromRGB(60, 100, 180), TabTextColor = Color3.fromRGB(150, 160, 180),
    SelectedTabTextColor = Color3.fromRGB(255, 255, 255), ElementBackground = Color3.fromRGB(18, 22, 32),
    ElementBackgroundHover = Color3.fromRGB(28, 35, 50), SecondaryElementBackground = Color3.fromRGB(15, 18, 28),
    ElementStroke = Color3.fromRGB(45, 55, 75), SecondaryElementStroke = Color3.fromRGB(35, 45, 60),
    SliderBackground = Color3.fromRGB(60, 100, 180), SliderProgress = Color3.fromRGB(180, 220, 255),
    SliderStroke = Color3.fromRGB(100, 150, 220), ToggleBackground = Color3.fromRGB(30, 35, 50),
    ToggleEnabled = Color3.fromRGB(80, 150, 255), ToggleDisabled = Color3.fromRGB(60, 60, 70),
    ToggleEnabledStroke = Color3.fromRGB(150, 200, 255), ToggleDisabledStroke = Color3.fromRGB(80, 80, 90),
    ToggleEnabledOuterStroke = Color3.fromRGB(120, 160, 220), ToggleDisabledOuterStroke = Color3.fromRGB(50, 50, 60),
    DropdownSelected = Color3.fromRGB(60, 100, 180), DropdownUnselected = Color3.fromRGB(18, 22, 32),
    InputBackground = Color3.fromRGB(15, 18, 28), InputStroke = Color3.fromRGB(50, 60, 80),
    PlaceholderColor = Color3.fromRGB(120, 130, 150)
}

local Window = Rayfield:CreateWindow({
    Name = "excluse universal loader", LoadingTitle = "Initializing...",
    LoadingSubtitle = "by excluse", Theme = GalaxyTheme, DisableRayfieldPrompts = true, 
    DisableBuildWarnings = true, ConfigurationSaving = { Enabled = false }, KeySystem = false
})
print("WINDOW CREATED")

-- 3. DATABASE
local PlaceId = game.PlaceId
local Scripts = {
    ["15899178400"] = { Name = "Call of Mini: Zombies 2", URL = "https://raw.githubusercontent.com/ExcluseDev/excluse-hub/main/comz2.lua" },
    ["77649408247578"] = { Name = "Dungeon Quest Reborn", URL = "https://raw.githubusercontent.com/ExcluseDev/excluse-hub/main/dqr.lua" },
    ["6447798030"] = { Name = "Funky Friday", URL = "https://raw.githubusercontent.com/InfernusScripts/Null-Fire/main/Loader" },
    ["142823291"] = { Name = "Murder Mystery 2", URL = "https://raw.githubusercontent.com/ExcluseDev/excluse-hub/main/mm2.lua" },
    ["4588604953"] = { Name = "Criminality", URL = "https://raw.githubusercontent.com/ExcluseDev/excluse-hub/main/criminality.lua" }
}
local UNIVERSAL_URL = "https://raw.githubusercontent.com/ExcluseDev/excluse-hub/main/universal.lua"

local success, GameName = pcall(function() return game:GetService("MarketplaceService"):GetProductInfo(PlaceId).Name end)
if not success then GameName = "Unknown Game" end

-- 4. UI & EXECUTION
local mainTab = Window:CreateTab("🏠 Home")
mainTab:CreateSection("Detection")
mainTab:CreateLabel("Game: " .. GameName)
mainTab:CreateSection("Launch")

local function executeScript(url, name)
    pcall(function() Window:Destroy() end)
    local pg = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
    if pg and pg:FindFirstChild("Rayfield") then pg.Rayfield:Destroy() end
    
    task.wait(1) -- Prevent Rayfield overlap crash
    
    local ok, err = pcall(function() loadstring(game:HttpGet(url))() end)
    if not ok then 
        warn("Failed to load: " .. tostring(err))
    end
end

if Scripts[tostring(PlaceId)] then
    local s = Scripts[tostring(PlaceId)]
    mainTab:CreateLabel("✅ Script found for " .. s.Name)
    mainTab:CreateButton({
        Name = "🚀 Launch " .. s.Name,
        Callback = function() executeScript(s.URL, s.Name) end,
    })
else
    mainTab:CreateLabel("❌ No specific script found for this game.")
    mainTab:CreateButton({
        Name = "🌐 Launch Universal Hub",
        Callback = function() executeScript(UNIVERSAL_URL, "Universal Hub") end,
    })
end

Rayfield:Notify({ Title = "Loader Ready", Content = "Detected: " .. GameName, Duration = 5 })
