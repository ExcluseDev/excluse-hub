--[[
    excluse hub | KNIFE DUELS (Advanced Galaxy Edition)
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
    Name = "excluse hub | KNIFE DUELS", LoadingTitle = "Loading KD...", LoadingSubtitle = "v1.0",
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
    silentAim = false, silentAimFOV = 150, silentAimPart = "Head",
    autoThrow = false, throwPrediction = 0.15,
    triggerbot = false, triggerDelay = 0.1,
    knifeAura = false, auraRange = 15,
    hitboxExpander = false, hitboxSize = 5,
    espEnabled = false, espRainbow = false, espMaxDistance = 500,
    infiniteSlide = false, slideSpeed = 100,
    walkspeed = 16, jumpPower = 50,
    highlights = {}
}

-- === HELPER FUNCTIONS ===
local function getTarget()
    local closest, dist = nil, State.silentAimFOV
    local cam = Workspace.CurrentCamera
    for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local part = p.Character:FindFirstChild(State.silentAimPart) or p.Character:FindFirstChild("Head")
            if part then
                local screenPos, onScreen = cam:WorldToViewportPoint(part.Position)
                if onScreen then
                    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
                    local d = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                    if d < dist then
                        dist = d
                        closest = part
                    end
                end
            end
        end
    end
    return closest
end

-- === SILENT AIM ===
RunService.RenderStepped:Connect(function()
    if State.silentAim then
        local target = getTarget()
        if target then
            local cam = Workspace.CurrentCamera
            local screenPos, onScreen = cam:WorldToViewportPoint(target.Position)
            if onScreen then
                pcall(function()
                    mousemoverel(screenPos.X - cam.ViewportSize.X / 2, screenPos.Y - cam.ViewportSize.Y / 2)
                end)
            end
        end
    end
end)

-- === TRIGGERBOT ===
task.spawn(function()
    while State.triggerbot and getgenv().excluseHubRunning do
        local target = getTarget()
        if target then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton1(Vector2.new(0, 0))
            end)
        end
        task.wait(State.triggerDelay)
    end
end)

-- === KNIFE AURA ===
task.spawn(function()
    while State.knifeAura and getgenv().excluseHubRunning do
        local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if myRoot then
            for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
                if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (p.Character.HumanoidRootPart.Position - myRoot.Position).Magnitude
                    if dist <= State.auraRange then
                        pcall(function()
                            VirtualUser:CaptureController()
                            VirtualUser:ClickButton1(Vector2.new(0, 0))
                        end)
                    end
                end
            end
        end
        task.wait(0.1)
    end
end)

-- === AUTO THROW ===
task.spawn(function()
    while State.autoThrow and getgenv().excluseHubRunning do
        local target = getTarget()
        if target then
            local targetVel = target.AssemblyLinearVelocity
            local predictedPos = target.Position + (targetVel * State.throwPrediction)
            -- Aim at predicted position and throw
            local cam = Workspace.CurrentCamera
            local screenPos, onScreen = cam:WorldToViewportPoint(predictedPos)
            if onScreen then
                pcall(function()
                    mousemoverel(screenPos.X - cam.ViewportSize.X / 2, screenPos.Y - cam.ViewportSize.Y / 2)
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton1(Vector2.new(0, 0)) -- or the throw key
                end)
            end
        end
        task.wait(0.5)
    end
end)

-- === HITBOX EXPANDER ===
local function applyHitboxExpander()
    for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
        if p ~= player and p.Character then
            local head = p.Character:FindFirstChild("Head")
            if head then
                if State.hitboxExpander then
                    head.Size = Vector3.new(State.hitboxSize, State.hitboxSize, State.hitboxSize)
                    head.Transparency = 0.5
                    head.CanCollide = false
                else
                    head.Size = Vector3.new(1, 1, 1) -- Reset (approximate)
                    head.Transparency = 0
                    head.CanCollide = true
                end
            end
        end
    end
end

RunService.Heartbeat:Connect(function()
    if State.hitboxExpander then
        applyHitboxExpander()
    end
end)

-- === ESP ===
RunService.Heartbeat:Connect(function()
    if not getgenv().excluseHubRunning then return end
    for char, h in pairs(State.highlights) do
        if not char.Parent or not char:FindFirstChild("Humanoid") then
            h:Destroy(); State.highlights[char] = nil
        end
    end
    if State.espEnabled then
        local cam = Workspace.CurrentCamera
        for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (p.Character.HumanoidRootPart.Position - cam.CFrame.Position).Magnitude
                if dist <= State.espMaxDistance then
                    if not State.highlights[p.Character] then
                        local h = Instance.new("Highlight")
                        h.OutlineColor = Color3.fromRGB(255, 255, 255)
                        h.FillTransparency = 0.5
                        h.Parent = p.Character
                        State.highlights[p.Character] = h
                    end
                    if State.espRainbow then
                        State.highlights[p.Character].FillColor = Color3.fromHSV((tick() % 1), 1, 1)
                    else
                        State.highlights[p.Character].FillColor = Color3.fromRGB(255, 50, 50)
                    end
                else
                    if State.highlights[p.Character] then
                        State.highlights[p.Character]:Destroy()
                        State.highlights[p.Character] = nil
                    end
                end
            end
        end
    end
end)

-- === MOVEMENT (Infinite Slide) ===
RunService.Heartbeat:Connect(function()
    if State.infiniteSlide then
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            -- Simulate sliding by boosting velocity when sliding
            if hum:GetState() == Enum.HumanoidStateType.Running then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Velocity = hrp.Velocity + (hrp.CFrame.LookVector * State.slideSpeed)
                end
            end
        end
    end
end)

-- === UI CONSTRUCTION ===
local mainTab = Window:CreateTab("⚔️ Combat")
local visualTab = Window:CreateTab("👁️ Visuals")
local playerTab = Window:CreateTab("🏃 Player")
local settingsTab = Window:CreateTab("⚙️ Settings")

-- Combat Tab
mainTab:CreateSection("Silent Aim")
mainTab:CreateToggle({ Name = "Enable Silent Aim", CurrentValue = false, Callback = function(v) State.silentAim = v end })
mainTab:CreateSlider({ Name = "Aimbot FOV", Range = {30, 360}, Increment = 10, CurrentValue = 150, Callback = function(v) State.silentAimFOV = v end })
mainTab:CreateDropdown({ Name = "Target Part", Options = {"Head", "HumanoidRootPart"}, CurrentAction = "Head", Callback = function(v) State.silentAimPart = v end })

mainTab:CreateSection("Triggerbot")
mainTab:CreateToggle({ Name = "Enable Triggerbot", CurrentValue = false, Callback = function(v) State.triggerbot = v end })
mainTab:CreateSlider({ Name = "Trigger Delay", Range = {0.01, 0.5}, Increment = 0.01, CurrentValue = 0.1, Callback = function(v) State.triggerDelay = v end })

mainTab:CreateSection("Knife Aura")
mainTab:CreateToggle({ Name = "Enable Knife Aura", CurrentValue = false, Callback = function(v) State.knifeAura = v end })
mainTab:CreateSlider({ Name = "Aura Range", Range = {5, 50}, Increment = 1, CurrentValue = 15, Callback = function(v) State.auraRange = v end })

mainTab:CreateSection("Auto Throw")
mainTab:CreateToggle({ Name = "Enable Auto Throw", CurrentValue = false, Callback = function(v) State.autoThrow = v end })
mainTab:CreateSlider({ Name = "Throw Prediction (s)", Range = {0.1, 1.0}, Increment = 0.05, CurrentValue = 0.15, Callback = function(v) State.throwPrediction = v end })

mainTab:CreateSection("Hitbox")
mainTab:CreateToggle({ Name = "Enable Hitbox Expander", CurrentValue = false, Callback = function(v) State.hitboxExpander = v end })
mainTab:CreateSlider({ Name = "Hitbox Size", Range = {1, 20}, Increment = 1, CurrentValue = 5, Callback = function(v) State.hitboxSize = v end })

-- Visuals Tab
visualTab:CreateSection("ESP")
visualTab:CreateToggle({ Name = "Enable ESP", CurrentValue = false, Callback = function(v) State.espEnabled = v end })
visualTab:CreateToggle({ Name = "Rainbow ESP", CurrentValue = false, Callback = function(v) State.espRainbow = v end })
visualTab:CreateSlider({ Name = "Max Distance", Range = {50, 2000}, Increment = 50, CurrentValue = 500, Callback = function(v) State.espMaxDistance = v end })

-- Player Tab
playerTab:CreateSection("Movement")
playerTab:CreateToggle({ Name = "Infinite Slide", CurrentValue = false, Callback = function(v) State.infiniteSlide = v end })
playerTab:CreateSlider({ Name = "Slide Speed", Range = {50, 300}, Increment = 10, CurrentValue = 100, Callback = function(v) State.slideSpeed = v end })
playerTab:CreateSlider({ Name = "WalkSpeed", Range = {16, 500}, Increment = 1, CurrentValue = 16, Callback = function(v) State.walkspeed = v end })
playerTab:CreateSlider({ Name = "JumpPower", Range = {50, 500}, Increment = 5, CurrentValue = 50, Callback = function(v) State.jumpPower = v end })

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
    State.silentAim = false; State.triggerbot = false; State.knifeAura = false; State.autoThrow = false
    State.hitboxExpander = false; State.espEnabled = false; State.infiniteSlide = false
    for _, h in pairs(State.highlights) do if h and h.Parent then h:Destroy() end end
    State.highlights = {}
    task.wait(0.3)
    pcall(function() Window:Destroy() end)
    local pg = player:FindFirstChild("PlayerGui")
    if pg then
        if pg:FindFirstChild("Rayfield") then pg.Rayfield:Destroy() end
        if pg:FindFirstChild("RayfieldToggleScreen") then pg.RayfieldToggleScreen:Destroy() end
    end
end })

Rayfield:Notify({ Title = "KNIFE DUELS Loaded", Content = "Advanced combat features ready.", Duration = 5 })
