--[[
    excluse hub | Dungeon Quest Reborn (Intelligent Kiting AI)
--]]
local player = game:GetService("Players").LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- === MINIMAL INTRO ===
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.IgnoreGuiInset = true
local bg = Instance.new("Frame", gui); bg.Size = UDim2.new(1,0,1,0); bg.BackgroundColor3 = Color3.fromRGB(5,5,8)
local txt = Instance.new("TextLabel", bg); txt.Size = UDim2.new(0,200,0,100); txt.Position = UDim2.new(0.5,-100,0.5,-50); txt.BackgroundTransparency = 1; txt.Text = "EXC"; txt.TextColor3 = Color3.new(1,1,1); txt.TextScaled = true; txt.Font = Enum.Font.GothamBlack; txt.TextTransparency = 1
TweenService:Create(txt, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
task.wait(0.7)
TweenService:Create(bg, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
TweenService:Create(txt, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
task.wait(0.3)
gui:Destroy()

-- === RAYFIELD SETUP ===
getgenv().SecureMode = false
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
getgenv().excluseHubRunning = true

local VoidGlassTheme = {
    TextColor = Color3.fromRGB(255, 255, 255), Background = Color3.fromRGB(10, 10, 15),
    Topbar = Color3.fromRGB(15, 15, 25), Shadow = Color3.fromRGB(0, 0, 0),
    NotificationBackground = Color3.fromRGB(15, 15, 25), NotificationActionsBackground = Color3.fromRGB(25, 25, 40),
    TabBackground = Color3.fromRGB(15, 15, 25), TabStroke = Color3.fromRGB(60, 60, 100),
    TabBackgroundSelected = Color3.fromRGB(150, 50, 255), TabTextColor = Color3.fromRGB(180, 180, 200),
    SelectedTabTextColor = Color3.fromRGB(255, 255, 255), ElementBackground = Color3.fromRGB(20, 20, 30),
    ElementBackgroundHover = Color3.fromRGB(30, 30, 45), SecondaryElementBackground = Color3.fromRGB(10, 10, 15),
    ElementStroke = Color3.fromRGB(80, 80, 120), SecondaryElementStroke = Color3.fromRGB(40, 40, 60),
    SliderBackground = Color3.fromRGB(150, 50, 255), SliderProgress = Color3.fromRGB(0, 255, 255),
    SliderStroke = Color3.fromRGB(200, 100, 255), ToggleBackground = Color3.fromRGB(30, 30, 45),
    ToggleEnabled = Color3.fromRGB(0, 255, 255), ToggleDisabled = Color3.fromRGB(60, 60, 70),
    ToggleEnabledStroke = Color3.fromRGB(255, 255, 255), ToggleDisabledStroke = Color3.fromRGB(80, 80, 90),
    ToggleEnabledOuterStroke = Color3.fromRGB(0, 255, 255), ToggleDisabledOuterStroke = Color3.fromRGB(50, 50, 60),
    DropdownSelected = Color3.fromRGB(150, 50, 255), DropdownUnselected = Color3.fromRGB(15, 15, 25),
    InputBackground = Color3.fromRGB(10, 10, 15), InputStroke = Color3.fromRGB(80, 80, 120),
    PlaceholderColor = Color3.fromRGB(120, 120, 140)
}

local Window = Rayfield:CreateWindow({
    Name = "excluse hub | DQR", LoadingTitle = "Loading DQR AI...", LoadingSubtitle = "v3.0 Intelligent",
    Theme = VoidGlassTheme, KeySystem = false, ConfigurationSaving = { Enabled = false }
})

-- === GALAXY UI OVERRIDE ===
task.spawn(function()
    task.wait(1)
    local rayfieldGui = player:FindFirstChild("PlayerGui") and player:FindFirstChild("PlayerGui"):FindFirstChild("Rayfield")
    if rayfieldGui and rayfieldGui:FindFirstChild("MainFrame") then
        local mainFrame = rayfieldGui.MainFrame
        local bg = mainFrame:FindFirstChild("Background")
        if bg then
            local galaxyImage = Instance.new("ImageLabel")
            galaxyImage.Size = UDim2.new(1.5, 0, 1.5, 0); galaxyImage.Position = UDim2.new(-0.25, 0, -0.25, 0)
            galaxyImage.BackgroundTransparency = 1; galaxyImage.Image = "rbxassetid://7148785474"; galaxyImage.ImageTransparency = 0.2; galaxyImage.ZIndex = 0
            galaxyImage.Parent = bg
            task.spawn(function()
                while galaxyImage.Parent do
                    TweenService:Create(galaxyImage, TweenInfo.new(15, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Position = UDim2.new(-0.3, 0, -0.2, 0)}):Play()
                    task.wait(15)
                    TweenService:Create(galaxyImage, TweenInfo.new(15, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Position = UDim2.new(-0.2, 0, -0.3, 0)}):Play()
                    task.wait(15)
                end
            end)
        end
        for _, desc in ipairs(mainFrame:GetDescendants()) do
            if desc:IsA("Frame") and desc.Name ~= "Background" then
                desc.BackgroundTransparency = 0.3
                if not desc:FindFirstChildOfClass("UICorner") then
                    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 8); c.Parent = desc
                end
            end
            if desc:IsA("ImageLabel") and desc.Name ~= "GalaxyImage" then desc.Visible = false end
        end
    end
end)

-- === STATE ===
local State = {
    aiEnabled = false,
    -- AI Tuning
    kiteDistance = 25, -- Preferred distance from enemies
    dodgeThreshold = 15, -- Distance at which AI starts kiting
    healthThreshold = 40, -- % health to trigger RECOVER
    predictionWindow = 0.3, -- How often AI re-evaluates (seconds)
    -- Automation
    autoSell = false, autoEquip = false, autoReplay = false, autoStats = false,
    -- Movement
    fly = false, flySpeed = 50, walkspeed = 16, jumpPower = 50
}

-- === UTILITY FUNCTIONS ===
local function getEnemies()
    local list = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and obj ~= player.Character then
            table.insert(list, obj)
        end
    end
    return list
end

local function getClosestEnemy()
    local closest, dist = nil, math.huge
    local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil, dist end
    for _, enemy in ipairs(getEnemies()) do
        local eRoot = enemy:FindFirstChild("HumanoidRootPart")
        if eRoot then
            local d = (eRoot.Position - myRoot.Position).Magnitude
            if d < dist then dist = d; closest = enemy end
        end
    end
    return closest, dist
end

local function getTelegraph()
    local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    for _, obj in ipairs(Workspace:GetDescendants()) do
        local name = obj.Name:lower()
        if (name:find("telegraph") or name:find("warning") or name:find("attackzone") or name:find("hitbox") or name:find("aoe")) 
           and (obj:IsA("BasePart") or obj:IsA("Model")) then
            local pos
            if obj:IsA("BasePart") then pos = obj.Position
            elseif obj:IsA("Model") and obj.PrimaryPart then pos = obj.PrimaryPart.Position
            else continue end
            local dist = (pos - myRoot.Position).Magnitude
            if dist < 40 then
                return {object = obj, position = pos, distance = dist}
            end
        end
    end
    return nil
end

-- === AI STATE MACHINE ===
local function runAI()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local myRoot = char:FindFirstChild("HumanoidRootPart")
    if not hum or not myRoot then return end

    local closestEnemy, enemyDist = getClosestEnemy()
    local telegraph = getTelegraph()
    local healthPct = (hum.Health / hum.MaxHealth) * 100

    -- 1. RECOVER STATE (Low Health)
    if healthPct < State.healthThreshold then
        if closestEnemy then
            local eRoot = closestEnemy:FindFirstChild("HumanoidRootPart")
            if eRoot then
                local dir = (myRoot.Position - eRoot.Position).Unit
                hum:MoveTo(myRoot.Position + dir * 50) -- Run far away
            end
        end
        return
    end

    -- 2. DODGE STATE (Telegraph Detected)
    if telegraph then
        local dir = (myRoot.Position - telegraph.position).Unit
        -- Side-step perpendicular to the threat
        local sideDir = Vector3.new(-dir.Z, 0, dir.X) 
        hum:MoveTo(myRoot.Position + sideDir * State.kiteDistance)
        return
    end

    -- 3. KITE STATE (Too Close)
    if closestEnemy and enemyDist < State.dodgeThreshold then
        local eRoot = closestEnemy:FindFirstChild("HumanoidRootPart")
        if eRoot then
            local dir = (myRoot.Position - eRoot.Position).Unit
            hum:MoveTo(myRoot.Position + dir * (State.kiteDistance - enemyDist))
        end
        return
    end

    -- 4. ENGAGE STATE (Safe to Attack)
    if closestEnemy and enemyDist < (State.kiteDistance + 10) then
        -- Attack
        VirtualUser:CaptureController()
        VirtualUser:ClickButton1(Vector2.new(0, 0))
        -- Use Skills
        local virt = game:GetService("VirtualInputManager")
        virt:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
        virt:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
        task.wait(0.1)
        virt:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        virt:SendKeyEvent(false, Enum.KeyCode.E, false, game)
        
        -- Close distance slightly to stay in range
        local eRoot = closestEnemy:FindFirstChild("HumanoidRootPart")
        if eRoot and enemyDist > (State.kiteDistance - 5) then
            hum:MoveTo(eRoot.Position)
        end
        return
    end

    -- 5. IDLE STATE (No enemies)
    -- Optionally move to a default position or wait
end

-- AI Loop
task.spawn(function()
    while State.aiEnabled and getgenv().excluseHubRunning do
        pcall(runAI)
        task.wait(State.predictionWindow)
    end
end)

-- === FLY ===
local flyConnection
local function toggleFly(enabled)
    State.fly = enabled
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if enabled then
        local bg = Instance.new("BodyGyro", hrp); bg.P = 9e4; bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9); bg.CFrame = hrp.CFrame
        local bv = Instance.new("BodyVelocity", hrp); bv.Velocity = Vector3.new(0,0,0); bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        flyConnection = RunService.RenderStepped:Connect(function()
            if not State.fly or not hrp.Parent then if flyConnection then flyConnection:Disconnect() end return end
            local cam = Workspace.CurrentCamera; local move = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move -= Vector3.new(0,1,0) end
            bv.Velocity = move * State.flySpeed; bg.CFrame = cam.CFrame
        end)
    else
        if flyConnection then flyConnection:Disconnect() end
        for _, v in pairs(hrp:GetChildren()) do if v:IsA("BodyGyro") or v:IsA("BodyVelocity") then v:Destroy() end end
    end
end

-- === UI CONSTRUCTION ===
local mainTab = Window:CreateTab("⚔️ AI Combat")
local autoTab = Window:CreateTab("🤖 Automation")
local playerTab = Window:CreateTab("🏃 Player")
local settingsTab = Window:CreateTab("⚙️ Settings")

-- AI Combat Tab
mainTab:CreateSection("Intelligent Kiting AI")
mainTab:CreateToggle({ Name = "Enable AI Mode", CurrentValue = false, Callback = function(v) State.aiEnabled = v end })
mainTab:CreateSlider({ Name = "Kite Distance", Range = {10, 50}, Increment = 1, CurrentValue = 25, Callback = function(v) State.kiteDistance = v end })
mainTab:CreateSlider({ Name = "Dodge Threshold (Distance)", Range = {5, 30}, Increment = 1, CurrentValue = 15, Callback = function(v) State.dodgeThreshold = v end })
mainTab:CreateSlider({ Name = "Health Threshold (%)", Range = {10, 80}, Increment = 5, CurrentValue = 40, Callback = function(v) State.healthThreshold = v end })
mainTab:CreateSlider({ Name = "Prediction Window (s)", Range = {0.1, 1.0}, Increment = 0.1, CurrentValue = 0.3, Callback = function(v) State.predictionWindow = v end })

-- Automation Tab
autoTab:CreateSection("Item & Dungeon Automation")
autoTab:CreateToggle({ Name = "Auto Sell Items", CurrentValue = false, Callback = function(v) State.autoSell = v end })
autoTab:CreateToggle({ Name = "Auto Equip Best", CurrentValue = false, Callback = function(v) State.autoEquip = v end })
autoTab:CreateToggle({ Name = "Auto Replay Dungeon", CurrentValue = false, Callback = function(v) State.autoReplay = v end })
autoTab:CreateToggle({ Name = "Auto Allocate Stats", CurrentValue = false, Callback = function(v) State.autoStats = v end })

-- Player Tab
playerTab:CreateSection("Movement")
playerTab:CreateSlider({ Name = "WalkSpeed", Range = {16, 500}, Increment = 1, CurrentValue = 16, Callback = function(v) State.walkspeed = v end })
playerTab:CreateSlider({ Name = "JumpPower", Range = {50, 500}, Increment = 5, CurrentValue = 50, Callback = function(v) State.jumpPower = v end })
playerTab:CreateToggle({ Name = "Fly", CurrentValue = false, Callback = function(v) toggleFly(v) end })
playerTab:CreateSlider({ Name = "Fly Speed", Range = {10, 200}, Increment = 5, CurrentValue = 50, Callback = function(v) State.flySpeed = v end })

-- Apply Player Settings continuously
RunService.Heartbeat:Connect(function()
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = State.walkspeed
        hum.JumpPower = State.jumpPower
        hum.UseJumpPower = true
    end
end)

-- Settings Tab
settingsTab:CreateButton({ Name = "🛑 Unload Script", Callback = function()
    getgenv().excluseHubRunning = false
    State.aiEnabled = false; State.autoSell = false; State.autoEquip = false; State.autoReplay = false; State.autoStats = false; State.fly = false
    task.wait(0.3)
    pcall(function() Window:Destroy() end)
    local pg = player:FindFirstChild("PlayerGui")
    if pg then
        if pg:FindFirstChild("Rayfield") then pg.Rayfield:Destroy() end
        if pg:FindFirstChild("RayfieldToggleScreen") then pg.RayfieldToggleScreen:Destroy() end
    end
end })

Rayfield:Notify({ Title = "DQR AI Loaded", Content = "Intelligent Kiting AI is ready. It will bait, dodge, and attack automatically.", Duration = 6 })
