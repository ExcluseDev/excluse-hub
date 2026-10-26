--[[
    excluse universal loader (Crash-Proof)
--]]

-- 1. CLEANUP OLD UIs (Prevents stacking and crashing)
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local pg = player:FindFirstChild("PlayerGui")
if pg then
    for _, gui in pairs(pg:GetChildren()) do
        if gui.Name == "Rayfield" or gui.Name == "RayfieldToggleScreen" or gui.Name == "EXC_LoadingScreen" then
            gui:Destroy()
        end
    end
end

-- 2. EXC INTRO ANIMATION
local TweenService = game:GetService("TweenService")
local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "EXC_LoadingScreen"
loadingGui.IgnoreGuiInset = true
loadingGui.DisplayOrder = 9999
loadingGui.Parent = pg

local bgFrame = Instance.new("Frame")
bgFrame.Size = UDim2.new(1, 0, 1, 0)
bgFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
bgFrame.BorderSizePixel = 0
bgFrame.Parent = loadingGui

local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(0, 0, 0, 0)
textLabel.Position = UDim2.new(0.5, -150, 0.5, -75)
textLabel.BackgroundTransparency = 1
textLabel.Text = "EXC"
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.TextScaled = true
textLabel.Font = Enum.Font.GothamBlack
textLabel.TextTransparency = 1
textLabel.Parent = bgFrame

local uiStroke = Instance.new("UIStroke")
uiStroke.Thickness = 3
uiStroke.Color = Color3.fromRGB(150, 200, 255)
uiStroke.Transparency = 1
uiStroke.Parent = textLabel

local popIn = TweenService:Create(textLabel, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 300, 0, 150), TextTransparency = 0})
local strokeIn = TweenService:Create(uiStroke, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Transparency = 0})
popIn:Play(); strokeIn:Play(); popIn.Completed:Wait(); task.wait(0.5)

local fadeOut = TweenService:Create(bgFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
local textOut = TweenService:Create(textLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})
local strokeOut = TweenService:Create(uiStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1})
fadeOut:Play(); textOut:Play(); strokeOut:Play(); fadeOut.Completed:Wait()
if loadingGui then loadingGui:Destroy() end

-- 3. LOAD RAYFIELD
getgenv().SecureMode = false
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local PlaceId = game.PlaceId

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

-- 4. DATABASE
local Scripts = {
    ["15899178400"] = { Name = "Call of Mini: Zombies 2", URL = "https://raw.githubusercontent.com/ExcluseDev/excluse-hub/main/comz2.lua" },
    ["77649408247578"] = { Name = "Dungeon Quest Reborn", URL = "https://raw.githubusercontent.com/ExcluseDev/excluse-hub/main/dqr.lua" },
    ["6447798030"] = { Name = "Funky Friday", URL = "https://raw.githubusercontent.com/InfernusScripts/Null-Fire/main/Loader" },
    ["142823291"] = { Name = "Murder Mystery 2", URL = "https://raw.githubusercontent.com/ExcluseDev/excluse-hub/main/mm2.lua" }
    ["1537690962"] = { Name = "Bee Swarm Simulator", URL = "https://raw.githubusercontent.com/ExcluseDev/excluse-hub/main/bss.lua" }
}
local UNIVERSAL_URL = "https://raw.githubusercontent.com/ExcluseDev/excluse-hub/main/universal.lua"

local success, GameName = pcall(function() return game:GetService("MarketplaceService"):GetProductInfo(PlaceId).Name end)
if not success then GameName = "Unknown Game" end

local isDQRDungeon = string.find(string.lower(GameName), "level") or string.find(string.lower(GameName), "dungeon")
local targetScriptUrl = nil
local targetScriptName = ""

if Scripts[tostring(PlaceId)] then
    targetScriptUrl = Scripts[tostring(PlaceId)].URL
    targetScriptName = Scripts[tostring(PlaceId)].Name
elseif isDQRDungeon then
    targetScriptUrl = Scripts["77649408247578"].URL
    targetScriptName = "Dungeon Quest Reborn"
end

-- 5. UI & EXECUTION
local mainTab = Window:CreateTab("🏠 Home")
mainTab:CreateSection("Detection")
mainTab:CreateLabel("Game: " .. GameName)
mainTab:CreateSection("Launch")

local function executeScript(url, name)
    pcall(function() Window:Destroy() end)
    local pGui = player:FindFirstChild("PlayerGui")
    if pGui and pGui:FindFirstChild("Rayfield") then pGui.Rayfield:Destroy() end
    
    task.wait(1) -- CRITICAL: Let the engine breathe before loading the next UI
    
    local ok, err = pcall(function() loadstring(game:HttpGet(url))() end)
    if not ok then 
        warn("Failed to load: " .. tostring(err))
    end
end

if targetScriptUrl then
    mainTab:CreateLabel("✅ Script found for " .. targetScriptName)
    mainTab:CreateButton({
        Name = "🚀 Launch " .. targetScriptName,
        Callback = function() executeScript(targetScriptUrl, targetScriptName) end,
    })
else
    mainTab:CreateLabel("❌ No specific script found for this game.")
    mainTab:CreateButton({
        Name = "🌐 Launch Universal Hub",
        Callback = function() executeScript(UNIVERSAL_URL, "Universal Hub") end,
    })
end

Rayfield:Notify({ Title = "Loader Ready", Content = "Detected: " .. GameName, Duration = 5 })
