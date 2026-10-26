--[[
    excluse universal loader (Fixed DQR Detection)
--]]

-- 1. FIX FOR XENO COREGUI CRASH
pcall(function()
    if game:GetService("CoreGui"):FindFirstChild("RobloxGui") then
        local resetBindable = game:GetService("CoreGui").RobloxGui:FindFirstChild("ResetButton")
        if resetBindable then resetBindable:Destroy() end
    end
end)

-- ===================================================================
-- === PART 1: MINIMAL INTRO ===
-- ===================================================================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local player = Players.LocalPlayer

local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "EXC_LoadingScreen"
loadingGui.IgnoreGuiInset = true
loadingGui.DisplayOrder = 9999
loadingGui.Parent = player:WaitForChild("PlayerGui")

local bgFrame = Instance.new("Frame")
bgFrame.Size = UDim2.new(1, 0, 1, 0)
bgFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
bgFrame.BorderSizePixel = 0
bgFrame.Parent = loadingGui

local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(0, 200, 0, 100)
textLabel.Position = UDim2.new(0.5, -100, 0.5, -50)
textLabel.BackgroundTransparency = 1
textLabel.Text = "EXC"
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.TextScaled = true
textLabel.Font = Enum.Font.GothamBlack
textLabel.TextTransparency = 1
textLabel.Parent = bgFrame

local uiStroke = Instance.new("UIStroke")
uiStroke.Thickness = 2
uiStroke.Color = Color3.fromRGB(150, 200, 255)
uiStroke.Transparency = 1
uiStroke.Parent = textLabel

TweenService:Create(textLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {TextTransparency = 0}):Play()
TweenService:Create(uiStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Transparency = 0}):Play()
task.wait(0.7)

local fadeInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad)
TweenService:Create(bgFrame, fadeInfo, {BackgroundTransparency = 1}):Play()
TweenService:Create(textLabel, fadeInfo, {TextTransparency = 1}):Play()
TweenService:Create(uiStroke, fadeInfo, {Transparency = 1}):Play()
task.wait(0.3)
loadingGui:Destroy()

-- ===================================================================
-- === PART 2: RAYFIELD SETUP ===
-- ===================================================================
getgenv().SecureMode = false
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local CyberNeonTheme = {
    TextColor = Color3.fromRGB(255, 255, 255), Background = Color3.fromRGB(8, 5, 15),
    Topbar = Color3.fromRGB(12, 8, 20), Shadow = Color3.fromRGB(0, 0, 0),
    NotificationBackground = Color3.fromRGB(15, 10, 25), NotificationActionsBackground = Color3.fromRGB(20, 15, 35),
    TabBackground = Color3.fromRGB(15, 10, 25), TabStroke = Color3.fromRGB(255, 0, 150),
    TabBackgroundSelected = Color3.fromRGB(255, 0, 150), TabTextColor = Color3.fromRGB(150, 150, 150),
    SelectedTabTextColor = Color3.fromRGB(255, 255, 255), ElementBackground = Color3.fromRGB(15, 10, 25),
    ElementBackgroundHover = Color3.fromRGB(25, 15, 40), SecondaryElementBackground = Color3.fromRGB(10, 5, 20),
    ElementStroke = Color3.fromRGB(0, 255, 255), SecondaryElementStroke = Color3.fromRGB(50, 50, 100),
    SliderBackground = Color3.fromRGB(255, 0, 150), SliderProgress = Color3.fromRGB(0, 255, 255),
    SliderStroke = Color3.fromRGB(255, 255, 255), ToggleBackground = Color3.fromRGB(20, 15, 35),
    ToggleEnabled = Color3.fromRGB(0, 255, 255), ToggleDisabled = Color3.fromRGB(50, 50, 60),
    ToggleEnabledStroke = Color3.fromRGB(255, 255, 255), ToggleDisabledStroke = Color3.fromRGB(80, 80, 90),
    ToggleEnabledOuterStroke = Color3.fromRGB(0, 255, 255), ToggleDisabledOuterStroke = Color3.fromRGB(50, 50, 60),
    DropdownSelected = Color3.fromRGB(255, 0, 150), DropdownUnselected = Color3.fromRGB(15, 10, 25),
    InputBackground = Color3.fromRGB(10, 5, 20), InputStroke = Color3.fromRGB(0, 255, 255),
    PlaceholderColor = Color3.fromRGB(100, 100, 120)
}

local Window = Rayfield:CreateWindow({
    Name = "excluse hub", LoadingTitle = "Loading...",
    LoadingSubtitle = "v1.621", Theme = CyberNeonTheme, DisableRayfieldPrompts = true, 
    DisableBuildWarnings = true, ConfigurationSaving = { Enabled = false }, KeySystem = false
})

-- ===================================================================
-- === PART 3: ULTRA UI POST-PROCESSING ===
-- ===================================================================
task.spawn(function()
    task.wait(1)
    local pg = player:FindFirstChild("PlayerGui")
    local rayfieldGui = pg and pg:FindFirstChild("Rayfield")
    
    if rayfieldGui then
        local mainFrame = rayfieldGui:FindFirstChild("MainFrame")
        
        if mainFrame then
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 8)
            corner.Parent = mainFrame
            
            local border = Instance.new("UIStroke")
            border.Color = Color3.fromRGB(0, 255, 255)
            border.Thickness = 2
            border.Transparency = 0.2
            border.Parent = mainFrame

            task.spawn(function()
                local hue = 0
                while border.Parent do
                    hue = (hue + 0.005) % 1
                    border.Color = Color3.fromHSV(hue, 1, 1)
                    task.wait(0.05)
                end
            end)

            local bg = mainFrame:FindFirstChild("Background")
            if bg then
                local colors = {Color3.fromRGB(255, 0, 150), Color3.fromRGB(0, 255, 255), Color3.fromRGB(100, 0, 255)}
                for i = 1, 3 do
                    local nebula = Instance.new("ImageLabel")
                    nebula.Size = UDim2.new(1.5, 0, 1.5, 0)
                    nebula.Position = UDim2.new(0, 0, 0, 0)
                    nebula.BackgroundTransparency = 1
                    nebula.Image = "rbxassetid://1316045217"
                    nebula.ImageColor3 = colors[i]
                    nebula.ImageTransparency = 0.85
                    nebula.ZIndex = 0
                    nebula.Parent = bg

                    task.spawn(function()
                        while nebula.Parent do
                            local randX = math.random(-100, 100)
                            local randY = math.random(-100, 100)
                            TweenService:Create(nebula, TweenInfo.new(10, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                                Position = UDim2.new(0, randX, 0, randY)
                            }):Play()
                            task.wait(10)
                        end
                    end)
                end
            end

            for _, desc in ipairs(mainFrame:GetDescendants()) do
                if desc:IsA("Frame") and desc ~= mainFrame and desc ~= bg then
                    if not desc:FindFirstChildOfClass("UICorner") then
                        local c = Instance.new("UICorner")
                        c.CornerRadius = UDim.new(0, 6)
                        c.Parent = desc
                    end
                end
            end
            
            local particlesFolder = Instance.new("Folder")
            particlesFolder.Name = "Particles"
            particlesFolder.Parent = mainFrame

            task.spawn(function()
                while mainFrame.Parent do
                    local p = Instance.new("Frame")
                    p.Size = UDim2.new(0, math.random(2,4), 0, math.random(2,4))
                    p.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
                    p.BorderSizePixel = 0
                    p.Position = UDim2.new(math.random(), 0, 1, 0)
                    p.ZIndex = 10
                    
                    local pCorner = Instance.new("UICorner")
                    pCorner.CornerRadius = UDim.new(1, 0)
                    pCorner.Parent = p
                    
                    p.Parent = particlesFolder
                    
                    local speed = math.random(2, 6)
                    TweenService:Create(p, TweenInfo.new(speed, Enum.EasingStyle.Linear), {
                        Position = UDim2.new(p.Position.X.Scale, 0, -0.1, 0),
                        BackgroundTransparency = 1
                    }):Play()
                    
                    task.delay(speed, function() p:Destroy() end)
                    task.wait(0.1)
                end
            end)
        end
    end
end)

-- ===================================================================
-- === PART 4: DATABASE & EXECUTION ===
-- ===================================================================
local PlaceId = game.PlaceId
local UniverseId = game.GameId

local Scripts = {
    ["15899178400"] = { Name = "Call of Mini: Zombies 2", URL = "https://raw.githubusercontent.com/ExcluseDev/excluse-hub/main/comz2.lua" },
    ["77649408247578"] = { Name = "Dungeon Quest Reborn", URL = "https://raw.githubusercontent.com/ExcluseDev/excluse-hub/main/dqr.lua" },
    ["6447798030"] = { Name = "Funky Friday", URL = "https://raw.githubusercontent.com/InfernusScripts/Null-Fire/main/Loader" },
    ["142823291"] = { Name = "Murder Mystery 2", URL = "https://raw.githubusercontent.com/ExcluseDev/excluse-hub/main/mm2.lua" },
    ["4588604953"] = { Name = "Criminality", URL = "https://raw.githubusercontent.com/ExcluseDev/excluse-hub/main/criminality.lua" },
    ["1537690962"] = { Name = "Bee Swarm Simulator", URL = "https://raw.githubusercontent.com/ExcluseDev/excluse-hub/main/bss.lua" }
    ["112731528776884"] = { Name = "KNIFE DUELS", URL = "https://raw.githubusercontent.com/ExcluseDev/excluse-hub/main/knifeduels.lua" }
    ["114234929420007"] = { Name = "BloxStrike", URL = "https://raw.githubusercontent.com/ExcluseDev/excluse-hub/main/bloxstrike.lua" }
    ["122446657157717"] = { Name = "Sniper Arena", URL = "https://raw.githubusercontent.com/ExcluseDev/excluse-hub/main/sniperarena.lua" }
    ["17516596118"] = { Name = "Hypershot", URL = "https://raw.githubusercontent.com/ExcluseDev/excluse-hub/main/hypershot.lua" }
    ["90568084448279"] = { Name = "One Tap", URL = "https://raw.githubusercontent.com/ExcluseDev/excluse-hub/main/onetap.lua" }
}
local UNIVERSAL_URL = "https://raw.githubusercontent.com/ExcluseDev/excluse-hub/main/universal.lua"

local success, GameName = pcall(function() return game:GetService("MarketplaceService"):GetProductInfo(PlaceId).Name end)
if not success then GameName = "Unknown Game" end

-- SMART DETECTION (FIXED IDS)
local isDQRDungeon = (PlaceId == 77649408247578) or (UniverseId == 9931749389) or (string.find(string.lower(GameName), "dungeon quest")) or (string.find(string.lower(GameName), "level"))

local targetScriptUrl = nil
local targetScriptName = ""

if Scripts[tostring(PlaceId)] then
    targetScriptUrl = Scripts[tostring(PlaceId)].URL
    targetScriptName = Scripts[tostring(PlaceId)].Name
elseif isDQRDungeon then
    if Scripts["77649408247578"] then
        targetScriptUrl = Scripts["77649408247578"].URL
        targetScriptName = "Dungeon Quest Reborn (In Dungeon)"
    end
end

-- ===================================================================
-- === PART 5: TABS & UI ===
-- ===================================================================
local mainTab = Window:CreateTab("🏠 Home")
local gamesTab = Window:CreateTab("🎮 Supported Games")

mainTab:CreateSection("Detection")
mainTab:CreateLabel("Game: " .. GameName)
mainTab:CreateSection("Launch")

local function executeScript(url, name)
    pcall(function() Window:Destroy() end)
    local pg = player:FindFirstChild("PlayerGui")
    if pg then
        if pg:FindFirstChild("Rayfield") then pg.Rayfield:Destroy() end
        if pg:FindFirstChild("RayfieldToggleScreen") then pg.RayfieldToggleScreen:Destroy() end
    end
    
    task.wait(1)
    
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

gamesTab:CreateSection("All Supported Games")
for id, gameData in pairs(Scripts) do
    gamesTab:CreateButton({
        Name = "🌐 Join " .. gameData.Name,
        Callback = function()
            Rayfield:Notify({ Title = "Teleporting", Content = "Joining " .. gameData.Name .. "...", Duration = 3 })
            task.wait(0.5)
            pcall(function() TeleportService:Teleport(tonumber(id), player) end)
        end,
    })
end

Rayfield:Notify({ Title = "SYSTEM ONLINE", Content = "Detected: " .. GameName, Duration = 5 })
