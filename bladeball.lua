--[[
    excluse hub | Blade Ball (Galaxy Glass Edition)
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
    Name = "excluse hub | Blade Ball", LoadingTitle = "Loading Blade Ball...", LoadingSubtitle = "v1.0",
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
    autoParry = false, parryAccuracy = 95, parryMode = "Humanized", parryRange = 15,
    autoAbility = false, abilityKey = Enum.KeyCode.Q, abilityCooldown = 5,
    espEnabled = false, espMaxDistance = 500,
    ballEsp = false,
    walkspeed = 16, jumpPower = 50, infiniteJump = false,
    highlights = {}, ballHighlight = nil
}

-- === HELPER: Get Ball ===
local function getBall()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj.Name == "Ball" and obj:IsA("BasePart") then
            return obj
        end
    end
    return nil
end

-- === AUTO PARRY (Humanized) ===
task.spawn(function()
    while State.autoParry and getgenv().excluseHubRunning do
        local ball = getBall()
        local myChar = player.Character
        if ball and myChar and myChar:FindFirstChild("HumanoidRootPart") then
            local myPos = myChar.HumanoidRootPart.Position
            local ballPos = ball.Position
            local dist = (ballPos - myPos).Magnitude
            
            if dist <= State.parryRange then
                -- Accuracy check
                if math.random(1, 100) <= State.parryAccuracy then
                    -- Humanized mode adds a tiny random delay
                    if State.parryMode == "Humanized" then
                        task.wait(math.random(5, 15) / 100) -- 50-150ms delay
                    end
                    
                    pcall(function()
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton1(Vector2.new(0, 0))
                    end)
                    
                    -- Visual feedback (optional)
                    -- Rayfield:Notify({ Title = "Auto Parry", Content = "Parried!", Duration = 1 })
                end
            end
        end
        task.wait(0.05) -- Fast loop but not too fast
    end
end)

-- === AUTO ABILITY ===
task.spawn(function()
    while State.autoAbility and getgenv().excluseHubRunning do
        pcall(function()
            local virt = game:GetService("VirtualInputManager")
            virt:SendKeyEvent(true, State.abilityKey, false, game)
            virt:SendKeyEvent(false, State.abilityKey, false, game)
        end)
        task.wait(State.abilityCooldown)
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
                        h.FillTransparency = 0.6
                        h.Parent = p.Character
                        State.highlights[p.Character] = h
                    end
                    State.highlights[p.Character].FillColor = Color3.fromRGB(255, 50, 50)
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

-- === BALL ESP ===
RunService.Heartbeat:Connect(function()
    if State.ballEsp then
        local ball = getBall()
        if ball then
            if not State.ballHighlight then
                local h = Instance.new("Highlight")
                h.FillColor = Color3.fromRGB(0, 255, 255)
                h.OutlineColor = Color3.fromRGB(255, 255, 255)
                h.FillTransparency = 0.3
                h.Parent = ball
                State.ballHighlight = h
            end
            State.ballHighlight.Parent = ball
        else
            if State.ballHighlight then
                State.ballHighlight:Destroy()
                State.ballHighlight = nil
            end
        end
    else
        if State.ballHighlight then
            State.ballHighlight:Destroy()
            State.ballHighlight = nil
        end
    end
end)

-- === INFINITE JUMP ===
UserInputService.JumpRequest:Connect(function()
    if State.infiniteJump and getgenv().excluseHubRunning then
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- === UI CONSTRUCTION ===
local mainTab = Window:CreateTab("⚔️ Combat")
local visualTab = Window:CreateTab("👁️ Visuals")
local playerTab = Window:CreateTab("🏃 Player")
local settingsTab = Window:CreateTab("⚙️ Settings")

-- Combat Tab
mainTab:CreateSection("Auto Parry")
mainTab:CreateToggle({ Name = "Enable Auto Parry", CurrentValue = false, Callback = function(v) State.autoParry = v end })
mainTab:CreateSlider({ Name = "Parry Accuracy (%)", Range = {50, 100}, Increment = 5, CurrentValue = 95, Callback = function(v) State.parryAccuracy = v end })
mainTab:CreateDropdown({ Name = "Parry Mode", Options = {"Humanized", "Instant"}, CurrentOption = "Humanized", Callback = function(v) State.parryMode = v end })
mainTab:CreateSlider({ Name = "Parry Range (studs)", Range = {5, 30}, Increment = 1, CurrentValue = 15, Callback = function(v) State.parryRange = v end })

mainTab:CreateSection("Auto Ability")
mainTab:CreateToggle({ Name = "Enable Auto Ability", CurrentValue = false, Callback = function(v) State.autoAbility = v end })
mainTab:CreateSlider({ Name = "Ability Cooldown (s)", Range = {1, 15}, Increment = 1, CurrentValue = 5, Callback = function(v) State.abilityCooldown = v end })

-- Visuals Tab
visualTab:CreateSection("ESP")
visualTab:CreateToggle({ Name = "Enable Player ESP", CurrentValue = false, Callback = function(v) State.espEnabled = v end })
visualTab:CreateSlider({ Name = "Max Distance", Range = {50, 2000}, Increment = 50, CurrentValue = 500, Callback = function(v) State.espMaxDistance = v end })
visualTab:CreateToggle({ Name = "Ball ESP (Cyan Highlight)", CurrentValue = false, Callback = function(v) State.ballEsp = v end })

-- Player Tab
playerTab:CreateSection("Movement")
playerTab:CreateSlider({ Name = "WalkSpeed", Range = {16, 500}, Increment = 1, CurrentValue = 16, Callback = function(v) State.walkspeed = v end })
playerTab:CreateSlider({ Name = "JumpPower", Range = {50, 500}, Increment = 5, CurrentValue = 50, Callback = function(v) State.jumpPower = v end })
playerTab:CreateToggle({ Name = "Infinite Jump", CurrentValue = false, Callback = function(v) State.infiniteJump = v end })

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
    State.autoParry = false; State.autoAbility = false; State.espEnabled = false; State.ballEsp = false; State.infiniteJump = false
    for _, h in pairs(State.highlights) do if h and h.Parent then h:Destroy() end end
    State.highlights = {}
    if State.ballHighlight then State.ballHighlight:Destroy() end
    task.wait(0.3)
    pcall(function() Window:Destroy() end)
    local pg = player:FindFirstChild("PlayerGui")
    if pg then
        if pg:FindFirstChild("Rayfield") then pg.Rayfield:Destroy() end
        if pg:FindFirstChild("RayfieldToggleScreen") then pg.RayfieldToggleScreen:Destroy() end
    end
end })

Rayfield:Notify({ Title = "Blade Ball Loaded", Content = "Auto Parry & Combat features ready.", Duration = 5 })
