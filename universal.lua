--[[
    excluse universal hub (Optimized Overkill)
    Credits: Infinite Yield (Open Source)
--]]

local player = game:GetService("Players").LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Mouse = player:GetMouse()
local Camera = Workspace.CurrentCamera

-- === MINIMAL INTRO ===
local introGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
introGui.IgnoreGuiInset = true
introGui.DisplayOrder = 9999
local bg = Instance.new("Frame", introGui); bg.Size = UDim2.new(1,0,1,0); bg.BackgroundColor3 = Color3.fromRGB(5,5,8); bg.BorderSizePixel = 0
local txt = Instance.new("TextLabel", bg); txt.Size = UDim2.new(0,200,0,100); txt.Position = UDim2.new(0.5,-100,0.5,-50); txt.BackgroundTransparency = 1; txt.Text = "EXC"; txt.TextColor3 = Color3.new(1,1,1); txt.TextScaled = true; txt.Font = Enum.Font.GothamBlack; txt.TextTransparency = 1
local stroke = Instance.new("UIStroke", txt); stroke.Thickness = 2; stroke.Color = Color3.fromRGB(150, 200, 255); stroke.Transparency = 1
TweenService:Create(txt, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 0}):Play()
task.wait(0.5)
TweenService:Create(bg, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
TweenService:Create(txt, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
task.wait(0.3)
introGui:Destroy()

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
    Name = "excluse universal hub", LoadingTitle = "Compiling...", LoadingSubtitle = "Overkill Edition",
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
            local galaxy = Instance.new("ImageLabel")
            galaxy.Size = UDim2.new(1.5, 0, 1.5, 0); galaxy.Position = UDim2.new(-0.25, 0, -0.25, 0)
            galaxy.BackgroundTransparency = 1; galaxy.Image = "rbxassetid://7148785474"; galaxy.ImageTransparency = 0.2; galaxy.ZIndex = 0
            galaxy.Parent = bg
        end
        for _, desc in ipairs(mainFrame:GetDescendants()) do
            if desc:IsA("Frame") and desc.Name ~= "Background" then
                desc.BackgroundTransparency = 0.3
                if not desc:FindFirstChildOfClass("UICorner") then
                    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 8); c.Parent = desc
                end
            end
            if desc:IsA("ImageLabel") and desc.Name ~= "ImageLabel" then desc.Visible = false end
            if desc:IsA("TextButton") then
                local scale = Instance.new("UIScale", desc)
                desc.MouseEnter:Connect(function() TweenService:Create(scale, TweenInfo.new(0.2), {Scale = 1.05}):Play() end)
                desc.MouseLeave:Connect(function() TweenService:Create(scale, TweenInfo.new(0.2), {Scale = 1}):Play() end)
            end
        end
    end
end)

-- === STATE & HELPERS ===
local Connections = {}
local State = { Noclip = false, Fly = false, CarFly = false, Fling = false, ESP = false, InfJump = false, Aimbot = false, Hitbox = false, FlySpeed = 50, AimbotFOV = 120, HitboxSize = 10, OriginalSizes = {}, ESPObjects = {} }
local function getRoot(char) return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")) end
local function getHum(char) return char and char:FindFirstChildOfClass("Humanoid") end

-- === NOCLIP ===
local noclipLoop
local function toggleNoclip(enabled)
    State.Noclip = enabled
    if enabled then
        noclipLoop = RunService.Stepped:Connect(function()
            if player.Character then
                for _, c in pairs(player.Character:GetDescendants()) do if c:IsA("BasePart") then c.CanCollide = false end end
            end
        end)
        table.insert(Connections, noclipLoop)
    else
        if noclipLoop then noclipLoop:Disconnect() end
        if player.Character then
            for _, c in pairs(player.Character:GetDescendants()) do if c:IsA("BasePart") then c.CanCollide = true end end
        end
    end
end

-- === CFrame Fly ===
local cflyLoop
local function toggleCFly(enabled)
    State.Fly = enabled
    local char = player.Character; if not char then return end
    local head, hum = char:FindFirstChild("Head"), getHum(char); if not head or not hum then return end
    if enabled then
        hum.PlatformStand = true; head.Anchored = true
        cflyLoop = RunService.Heartbeat:Connect(function(dt)
            local moveDir = hum.MoveDirection * (State.FlySpeed * dt)
            local headCF, camCF = head.CFrame, Camera.CFrame
            local camOffset = headCF:ToObjectSpace(camCF).Position
            camCF = camCF * CFrame.new(-camOffset.X, -camOffset.Y, -camOffset.Z + 1)
            local camPos, headPos = camCF.Position, headCF.Position
            local objSpaceVel = CFrame.new(camPos, Vector3.new(headPos.X, camPos.Y, headPos.Z)):VectorToObjectSpace(moveDir)
            head.CFrame = CFrame.new(headPos) * (camCF - camPos) * CFrame.new(objSpaceVel)
        end)
        table.insert(Connections, cflyLoop)
    else
        if cflyLoop then cflyLoop:Disconnect() end
        hum.PlatformStand = false; head.Anchored = false
    end
end

-- === Car Fly ===
local carLoop
local function toggleCarFly(enabled)
    State.CarFly = enabled
    local char = player.Character; if not char then return end
    local hum = getHum(char); if not hum or not hum.SeatPart then return end
    local vehicle = hum.SeatPart:FindFirstAncestorOfClass("Model"); if not vehicle then return end
    local root = vehicle.PrimaryPart or vehicle:FindFirstChildWhichIsA("BasePart")
    if enabled then
        local bg = Instance.new("BodyGyro", root); bg.P = 9e4; bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
        local bv = Instance.new("BodyVelocity", root); bv.MaxForce = Vector3.new(9e9,9e9,9e9)
        carLoop = RunService.Heartbeat:Connect(function()
            local move = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move -= Vector3.new(0,1,0) end
            bv.Velocity = move * State.FlySpeed; bg.CFrame = Camera.CFrame
        end)
        table.insert(Connections, carLoop)
    else
        if carLoop then carLoop:Disconnect() end
        for _, v in pairs(root:GetChildren()) do if v:IsA("BodyGyro") or v:IsA("BodyVelocity") then v:Destroy() end end
    end
end

-- === VOID TP ===
local function voidTP()
    local root = getRoot(player.Character)
    if root then
        root.CFrame = CFrame.new(root.Position.X, -1000, root.Position.Z)
        Rayfield:Notify({Title="Void TP", Content="Sent to the shadow realm.", Duration=3})
    end
end

-- === FLING ===
local flingDied
local function toggleFling(enabled)
    State.Fling = enabled
    local char = player.Character; if not char then return end
    if enabled then
        for _, c in pairs(char:GetDescendants()) do if c:IsA("BasePart") then c.CustomPhysicalProperties = PhysicalProperties.new(math.huge, 0.3, 0.5) end end
        toggleNoclip(true); task.wait(0.1)
        local bambam = Instance.new("BodyAngularVelocity", char.HumanoidRootPart)
        bambam.Name = "EXCFling"; bambam.AngularVelocity = Vector3.new(0, 99999, 0); bambam.MaxTorque = Vector3.new(0, math.huge, 0); bambam.P = math.huge
        for _, v in pairs(char:GetChildren()) do if v:IsA("BasePart") then v.CanCollide = false; v.Massless = true end end
        flingDied = char:FindFirstChildOfClass("Humanoid").Died:Connect(function() toggleFling(false) end)
        task.spawn(function()
            while State.Fling and bambam.Parent do
                bambam.AngularVelocity = Vector3.new(0, 99999, 0); task.wait(0.2)
                bambam.AngularVelocity = Vector3.new(0, 0, 0); task.wait(0.1)
            end
        end)
    else
        toggleNoclip(false)
        if flingDied then flingDied:Disconnect() end
        if char and char:FindFirstChild("HumanoidRootPart") then
            local bambam = char.HumanoidRootPart:FindFirstChild("EXCFling")
            if bambam then bambam:Destroy() end
            for _, c in pairs(char:GetDescendants()) do if c:IsA("BasePart") then c.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5); c.Massless = false end end
        end
    end
end

-- === COMBAT (Aimbot & Hitbox) ===
RunService.RenderStepped:Connect(function()
    if not State.Aimbot then return end
    local closest, dist = nil, State.AimbotFOV
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local screenPos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if onScreen then
                local d = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                if d < dist then dist = d; closest = p.Character.HumanoidRootPart end
            end
        end
    end
    if closest then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, closest.Position), 0.2) end
end)

RunService.Heartbeat:Connect(function()
    if not State.Hitbox then return end
    for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
        if p ~= player and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                if not State.OriginalSizes[p.Character] then State.OriginalSizes[p.Character] = hrp.Size end
                hrp.Size = Vector3.new(State.HitboxSize, State.HitboxSize, State.HitboxSize)
                hrp.Transparency = 0.5
            end
        end
    end
end)

-- === ESP ===
local function updateESP()
    for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
        if p ~= player and p.Character and not State.ESPObjects[p] then
            local h = Instance.new("Highlight")
            h.FillColor = Color3.fromRGB(255, 0, 0); h.OutlineColor = Color3.fromRGB(255, 255, 255)
            h.FillTransparency = 0.5; h.Parent = p.Character; State.ESPObjects[p] = h
        end
    end
end
task.spawn(function() while task.wait(1) do if State.ESP then updateESP() end end end)

-- === INFINITE JUMP ===
UserInputService.JumpRequest:Connect(function()
    if State.InfJump and player.Character then
        local hum = getHum(player.Character); if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- === UI TABS ===
local CombatTab = Window:CreateTab("⚔️ Combat")
local MoveTab = Window:CreateTab("🏃 Movement")
local VisualTab = Window:CreateTab("👁️ Visuals")
local TrollTab = Window:CreateTab("😈 Trolling")
local SettingsTab = Window:CreateTab("⚙️ Settings")

-- Combat
CombatTab:CreateSection("Aimbot")
CombatTab:CreateToggle({ Name = "Camera Aimbot", CurrentValue = false, Callback = function(v) State.Aimbot = v end })
CombatTab:CreateSlider({ Name = "Aimbot FOV", Range = {30, 360}, Increment = 10, CurrentValue = 120, Callback = function(v) State.AimbotFOV = v end })
CombatTab:CreateSection("Hitbox")
CombatTab:CreateToggle({ Name = "Hitbox Expander", CurrentValue = false, Callback = function(v) State.Hitbox = v end })
CombatTab:CreateSlider({ Name = "Hitbox Size", Range = {1, 50}, Increment = 1, CurrentValue = 10, Callback = function(v) State.HitboxSize = v end })

-- Movement
MoveTab:CreateSection("Speed")
MoveTab:CreateSlider({ Name = "WalkSpeed", Range = {16, 500}, Increment = 1, CurrentValue = 16, Callback = function(v) if getHum(player.Character) then getHum(player.Character).WalkSpeed = v end end })
MoveTab:CreateToggle({ Name = "Infinite Jump", CurrentValue = false, Callback = function(v) State.InfJump = v end })
MoveTab:CreateSection("Flight")
MoveTab:CreateToggle({ Name = "CFrame Fly", CurrentValue = false, Callback = function(v) toggleCFly(v) end })
MoveTab:CreateSlider({ Name = "Fly Speed", Range = {10, 200}, Increment = 5, CurrentValue = 50, Callback = function(v) State.FlySpeed = v end })
MoveTab:CreateToggle({ Name = "CarFly (Vehicle)", CurrentValue = false, Callback = function(v) toggleCarFly(v) end })
MoveTab:CreateToggle({ Name = "Noclip", CurrentValue = false, Callback = function(v) toggleNoclip(v) end })

-- Visuals
VisualTab:CreateSection("ESP")
VisualTab:CreateToggle({ Name = "Highlight ESP", CurrentValue = false, Callback = function(v) State.ESP = v end })
VisualTab:CreateSection("Environment")
VisualTab:CreateToggle({ Name = "Fullbright", CurrentValue = false, Callback = function(v)
    if v then Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.FogEnd = 100000; Lighting.GlobalShadows = false; Lighting.OutdoorAmbient = Color3.fromRGB(128,128,128)
    else Lighting.Brightness = 1; Lighting.GlobalShadows = true end
end })

-- Trolling
TrollTab:CreateSection("Devastation")
TrollTab:CreateToggle({ Name = "Fling (Touch Player)", CurrentValue = false, Callback = function(v) toggleFling(v) end })
TrollTab:CreateButton({ Name = "☠️ VOID TP (Fall Through Floor)", Callback = function() voidTP() end })

-- Settings
SettingsTab:CreateSection("Script")
SettingsTab:CreateButton({ Name = "🛑 Unload Script", Callback = function()
    getgenv().excluseHubRunning = false
    toggleCFly(false); toggleCarFly(false); toggleFling(false); toggleNoclip(false)
    for _, conn in ipairs(Connections) do pcall(function() conn:Disconnect() end) end
    for _, h in pairs(State.ESPObjects) do pcall(function() h:Destroy() end) end
    pcall(function() Window:Destroy() end)
    local pg = player:FindFirstChild("PlayerGui")
    if pg then
        if pg:FindFirstChild("Rayfield") then pg.Rayfield:Destroy() end
        if pg:FindFirstChild("RayfieldToggleScreen") then pg.RayfieldToggleScreen:Destroy() end
    end
end })

Rayfield:Notify({ Title = "Overkill Loaded", Content = "Optimized for Xeno. Enjoy.", Duration = 6 })
