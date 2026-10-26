--[[
    excluse universal loader (Starry Night Edition)
--]]

-- ===================================================================
-- === PART 1: TELEPORT HANDLER (AUTO-RELOAD) ===
-- ===================================================================
local LOADER_URL = "https://raw.githubusercontent.com/ExcluseDev/excluse-hub/main/loader.lua" 

if LOADER_URL ~= "" then
    local payload = string.format([[loadstring(game:HttpGet("%s"))()]], LOADER_URL)
    if type(syn) == "table" and syn.queue_on_teleport then pcall(function() syn.queue_on_teleport(payload) end) end
    if type(queue_on_teleport) == "function" then pcall(function() queue_on_teleport(payload) end) end
    if type(fluxus) == "table" and fluxus.queue_on_teleport then pcall(function() fluxus.queue_on_teleport(payload) end) end
end

-- ===================================================================
-- === PART 2: CUSTOM "EXC" STARFIELD INTRO ===
-- ===================================================================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "EXC_LoadingScreen"
loadingGui.IgnoreGuiInset = true
loadingGui.DisplayOrder = 9999
loadingGui.Parent = player:WaitForChild("PlayerGui")

local bgFrame = Instance.new("Frame")
bgFrame.Size = UDim2.new(1, 0, 1, 0)
bgFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 10) -- Deep space black
bgFrame.BorderSizePixel = 0
bgFrame.Parent = loadingGui

-- A subtle nebula gradient behind the text
local bgGradient = Instance.new("UIGradient")
bgGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(5, 5, 10)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 15, 35)), -- Subtle dark purple
    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 10))
}
bgGradient.Rotation = 45
bgGradient.Parent = bgFrame

task.spawn(function()
    while bgFrame and bgFrame.Parent do
        TweenService:Create(bgGradient, TweenInfo.new(4, Enum.EasingStyle.Sine), {Rotation = 405}):Play()
        task.wait(4)
    end
end)

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
uiStroke.Color = Color3.fromRGB(150, 200, 255) -- Starlight blue
uiStroke.Transparency = 1
uiStroke.Parent = textLabel

local popIn = TweenService:Create(textLabel, TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 300, 0, 150), TextTransparency = 0})
local strokeIn = TweenService:Create(uiStroke, TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Transparency = 0})
popIn:Play(); strokeIn:Play(); popIn.Completed:Wait(); task.wait(1)

local fadeOut = TweenService:Create(bgFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
local textOut = TweenService:Create(textLabel, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})
local strokeOut = TweenService:Create(uiStroke, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1})
fadeOut:Play(); textOut:Play(); strokeOut:Play(); fadeOut.Completed:Wait()
if loadingGui then loadingGui:Destroy() end

-- ===================================================================
-- === PART 3: SETUP & THEME ===
-- ===================================================================
getgenv().SecureMode = false
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local PlaceId = game.PlaceId

-- Starry Night / Milky Way Theme
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

-- ===================================================================
-- === PART 4: DATABASE & SMART DETECTION ===
-- ===================================================================
local Scripts = {
    ["15899178400"] = { Name = "Call of Mini: Zombies 2", URL = "https://raw.githubusercontent.com/ExcluseDev/excluse-hub/main/comz2.lua" },
    ["77649408247578"] = { Name = "Dungeon Quest Reborn", URL = "https://raw.githubusercontent.com/ExcluseDev/excluse-hub/main/dqr.lua" },
    ["6447798030"] = { Name = "Funky Friday", URL = "https://raw.githubusercontent.com/InfernusScripts/Null-Fire/main/Loader" }
}
local UNIVERSAL_URL = "https://raw.githubusercontent.com/ExcluseDev/excluse-hub/main/universal.lua"

local success, GameName = pcall(function() return game:GetService("MarketplaceService"):GetProductInfo(PlaceId).Name end)
if not success then GameName = "Unknown Game" end

-- Smart Detection: Treat "Level" or "Dungeon" as DQR
local isDQRDungeon = string.find(string.lower(GameName), "level") or string.find(string.lower(GameName), "dungeon")
local targetScriptUrl = nil
local targetScriptName = ""

if Scripts[tostring(PlaceId)] then
    targetScriptUrl = Scripts[tostring(PlaceId)].URL
    targetScriptName = Scripts[tostring(PlaceId)].Name
elseif isDQRDungeon then
    targetScriptUrl = Scripts["77649408247578"].URL
    targetScriptName = "Dungeon Quest Reborn (In Dungeon)"
end

-- ===================================================================
-- === PART 5: UI & EXECUTION ===
-- ===================================================================
local mainTab = Window:CreateTab("🏠 Home")
mainTab:CreateSection("Detection")
mainTab:CreateLabel("Game: " .. GameName)

local autoLaunchEnabled = false
mainTab:CreateSection("Auto-Launch (For Dungeon Teleports)")
mainTab:CreateToggle({
    Name = "Auto-Launch Script on Teleport",
    CurrentValue = false,
    Callback = function(v) autoLaunchEnabled = v end,
})
mainTab:CreateLabel("If enabled, the script will automatically load when you enter a dungeon.")

mainTab:CreateSection("Launch")

local function executeScript(url, name)
    pcall(function() Window:Destroy() end)
    local pg = player:FindFirstChild("PlayerGui")
    if pg and pg:FindFirstChild("Rayfield") then pg.Rayfield:Destroy() end
    task.wait(1.5) -- Prevent crash by letting Rayfield close fully
    local ok, err = pcall(function() loadstring(game:HttpGet(url))() end)
    if not ok then Rayfield:Notify({ Title = "Error", Content = "Failed to load " .. name, Duration = 5 }) end
end

if targetScriptUrl then
    mainTab:CreateLabel("✅ Specific script found for " .. targetScriptName)
    mainTab:CreateButton({
        Name = "🚀 Launch " .. targetScriptName,
        Callback = function() executeScript(targetScriptUrl, targetScriptName) end,
    })
    
    -- Auto-launch logic
    if autoLaunchEnabled or isDQRDungeon then
        task.spawn(function()
            task.wait(1)
            executeScript(targetScriptUrl, targetScriptName)
        end)
    end
else
    mainTab:CreateLabel("❌ No specific script found for this game.")
    mainTab:CreateButton({
        Name = "🌐 Launch Universal Hub",
        Callback = function() executeScript(UNIVERSAL_URL, "Universal Hub") end,
    })
end

Rayfield:Notify({ Title = "Loader Ready", Content = "Detected: " .. GameName, Duration = 5 })
