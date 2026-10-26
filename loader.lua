--[[
    excluse universal loader (ULTRA CYBER-NEON EDITION)
--]]

-- 1. FIX FOR XENO COREGUI CRASH
pcall(function()
    if game:GetService("CoreGui"):FindFirstChild("RobloxGui") then
        local resetBindable = game:GetService("CoreGui").RobloxGui:FindFirstChild("ResetButton")
        if resetBindable then resetBindable:Destroy() end
    end
end)

-- ===================================================================
-- === PART 1: INSANE GLITCH & SYNTHWAVE INTRO ===
-- ===================================================================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local player = Players.LocalPlayer

pcall(function()
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://1837727870" -- Heavy Cyberpunk Bass Drop
    sound.Volume = 1
    sound.Parent = SoundService
    sound:Play()
    game:GetService("Debris"):AddItem(sound, 5)
end)

local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "EXC_LoadingScreen"
loadingGui.IgnoreGuiInset = true
loadingGui.DisplayOrder = 9999
loadingGui.Parent = player:WaitForChild("PlayerGui")

local bgFrame = Instance.new("Frame")
bgFrame.Size = UDim2.new(1, 0, 1, 0)
bgFrame.BackgroundColor3 = Color3.fromRGB(2, 0, 5)
bgFrame.BorderSizePixel = 0
bgFrame.Parent = loadingGui

-- Synthwave Grid Background
local grid = Instance.new("ImageLabel")
grid.Size = UDim2.new(2, 0, 2, 0)
grid.Position = UDim2.new(-0.5, 0, -0.5, 0)
grid.BackgroundTransparency = 1
grid.Image = "rbxassetid://1316045217" -- Grid texture
grid.ImageColor3 = Color3.fromRGB(255, 0, 150)
grid.ImageTransparency = 0.5
grid.Parent = bgFrame
TweenService:Create(grid, TweenInfo.new(3, Enum.EasingStyle.Linear), {Position = UDim2.new(-0.5, 0, 0, 0)}):Play()

-- Chromatic Aberration Text Setup (3 Layers)
local function createText(offset, color)
    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(0, 300, 0, 150)
    txt.Position = UDim2.new(0.5, -150 + offset.X, 0.5, -75 + offset.Y)
    txt.BackgroundTransparency = 1
    txt.Text = "EXC"
    txt.TextColor3 = color
    txt.TextScaled = true
    txt.Font = Enum.Font.GothamBlack
    txt.TextTransparency = 1
    txt.Parent = bgFrame
    return txt
end

local txtRed = createText(Vector2.new(-4, 0), Color3.fromRGB(255, 0, 0))
local txtCyan = createText(Vector2.new(4, 0), Color3.fromRGB(0, 255, 255))
local txtWhite = createText(Vector2.new(0, 0), Color3.fromRGB(255, 255, 255))

-- UI Stroke for the main text
local uiStroke = Instance.new("UIStroke")
uiStroke.Thickness = 3
uiStroke.Color = Color3.fromRGB(255, 255, 255)
uiStroke.Transparency = 1
uiStroke.Parent = txtWhite

-- Loading Bar
local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(0, 300, 0, 2)
barBg.Position = UDim2.new(0.5, -150, 0.5, 100)
barBg.BackgroundColor3 = Color3.fromRGB(30, 20, 40)
barBg.BorderSizePixel = 0
barBg.Parent = bgFrame

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
barFill.BorderSizePixel = 0
barFill.Parent = barBg

-- Intro Animation Sequence
local function playIntro()
    -- Fade in texts
    TweenService:Create(txtRed, TweenInfo.new(0.5), {TextTransparency = 0.5}):Play()
    TweenService:Create(txtCyan, TweenInfo.new(0.5), {TextTransparency = 0.5}):Play()
    TweenService:Create(txtWhite, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
    TweenService:Create(uiStroke, TweenInfo.new(0.5), {Transparency = 0}):Play()
    
    -- Glitch effect (shaking the text rapidly)
    for i = 1, 10 do
        txtRed.Position = UDim2.new(0.5, -150 + math.random(-10, 10), 0.5, -75 + math.random(-5, 5))
        txtCyan.Position = UDim2.new(0.5, -150 + math.random(-10, 10), 0.5, -75 + math.random(-5, 5))
        task.wait(0.05)
    end
    
    -- Lock into place
    txtRed.Position = UDim2.new(0.5, -154, 0.5, -75)
    txtCyan.Position = UDim2.new(0.5, -146, 0.5, -75)
    
    -- Fill loading bar
    TweenService:Create(barFill, TweenInfo.new(1.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)}):Play()
    task.wait(1.5)
    
    -- Flash and Fade Out
    TweenService:Create(bgFrame, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    TweenService:Create(grid, TweenInfo.new(0.4), {ImageTransparency = 1}):Play()
    TweenService:Create(txtRed, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
    TweenService:Create(txtCyan, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
    TweenService:Create(txtWhite, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
    TweenService:Create(uiStroke, TweenInfo.new(0.4), {Transparency = 1}):Play()
    TweenService:Create(barBg, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    TweenService:Create(barFill, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    
    task.wait(0.4)
    loadingGui:Destroy()
end

playIntro()

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
-- === PART 3: ULTRA UI POST-PROCESSING (NEBULA & PARTICLES) ===
-- ===================================================================
task.spawn(function()
    task.wait(1) -- Wait for Rayfield to fully draw
    local pg = player:FindFirstChild("PlayerGui")
    local rayfieldGui = pg and pg:FindFirstChild("Rayfield")
    
    if rayfieldGui then
        local mainFrame = rayfieldGui:FindFirstChild("MainFrame")
        
        if mainFrame then
            -- 1. GLASSMORPHISM (Rounded Corners & Shadows)
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 8)
            corner.Parent = mainFrame
            
            -- 2. RGB GLOWING BORDER
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

            -- 3. FLUID NEBULA BACKGROUND
            local bg = mainFrame:FindFirstChild("Background")
            if bg then
                -- Create 3 massive, colored smoke clouds
                local colors = {Color3.fromRGB(255, 0, 150), Color3.fromRGB(0, 255, 255), Color3.fromRGB(100, 0, 255)}
                
                for i = 1, 3 do
                    local nebula = Instance.new("ImageLabel")
                    nebula.Size = UDim2.new(1.5, 0, 1.5, 0)
                    nebula.Position = UDim2.new(0, 0, 0, 0)
                    nebula.BackgroundTransparency = 1
                    nebula.Image = "rbxassetid://1316045217" -- Cloud texture
                    nebula.ImageColor3 = colors[i]
                    nebula.ImageTransparency = 0.85
                    nebula.ZIndex = 0
                    nebula.Parent = bg

                    -- Animate them to float around slowly
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

            -- 4. ROUND CORNERS ON ALL INNER ELEMENTS
            for _, desc in ipairs(mainFrame:GetDescendants()) do
                if desc:IsA("Frame") and desc ~= mainFrame and desc ~= bg then
                    if not desc:FindFirstChildOfClass("UICorner") then
                        local c = Instance.new("UICorner")
                        c.CornerRadius = UDim.new(0, 6)
                        c.Parent = desc
                    end
                end
            end
            
            -- 5. FLOATING DATA PARTICLES
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
                    
                    task.delay(speed, function()
                        p:Destroy()
                    end)
                    
                    task.wait(0.1) -- Spawn rate
                end
            end)
        end
    end
end)

-- ===================================================================
-- === PART 4: DATABASE & EXECUTION ===
-- ===================================================================
local PlaceId = game.PlaceId
local Scripts = {
    ["15899178400"] = { Name = "Call of Mini: Zombies 2", URL = "https://raw.githubusercontent.com/ExcluseDev/excluse-hub/main/comz2.lua" },
    ["77649408247578"] = { Name = "Dungeon Quest Reborn", URL = "https://raw.githubusercontent.com/ExcluseDev/excluse-hub/main/dqr.lua" },
    ["6447798030"] = { Name = "Funky Friday", URL = "https://raw.githubusercontent.com/InfernusScripts/Null-Fire/main/Loader" },
    ["142823291"] = { Name = "Murder Mystery 2", URL = "https://raw.githubusercontent.com/ExcluseDev/excluse-hub/main/mm2.lua" },
    ["4588604953"] = { Name = "Criminality", URL = "https://raw.githubusercontent.com/ExcluseDev/excluse-hub/main/criminality.lua" },
    ["1537690962"] = { Name = "Bee Swarm Simulator", URL = "https://raw.githubusercontent.com/ExcluseDev/excluse-hub/main/bss.lua" }
}
local UNIVERSAL_URL = "https://raw.githubusercontent.com/ExcluseDev/excluse-hub/main/universal.lua"

local success, GameName = pcall(function() return game:GetService("MarketplaceService"):GetProductInfo(PlaceId).Name end)
if not success then GameName = "Unknown Game" end

local mainTab = Window:CreateTab("🏠 Home")
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

Rayfield:Notify({ Title = "SYSTEM ONLINE", Content = "Detected: " .. GameName, Duration = 5 })
