--[[
    EXC Hub: Shadow Edition v4.0 (Premium Universal)
    Game: Universal
    Features: Combat, Visuals, Movement, Misc, Game-Specific, Settings.
--]]

-- ===================================================================
-- === SERVICES & VARIABLES ===
-- ===================================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

local Connections = {}
local ESPObjects = {}
local DrawingObjects = {}
local OriginalProperties = {}
local CurrentTarget = nil
local FlyConnection = nil
local AimbotConnection = nil
local ESPConnection = nil
local LastChatMessage = ""

local State = {
    -- Combat
    AimbotEnabled = false,
    AimbotSmoothness = 0.15,
    AimbotFOV = 120,
    AimbotTargetPart = "Head",
    AimbotTeamCheck = true,
    AimbotWallCheck = false,
    AimbotHoldKey = Enum.KeyCode.E,
    AimbotToggleKey = Enum.KeyCode.Q,
    AimbotSticky = false,
    AimbotPriority = "Distance",
    SilentAimEnabled = false,
    TriggerbotEnabled = false,
    TriggerbotDelay = 0.1,
    HitboxExpanderEnabled = false,
    HitboxSize = 5,
    
    -- Visuals
    ESPEnabled = false,
    ESPBox = true,
    ESPName = true,
    ESPHealth = true,
    ESPDistance = true,
    ESPTracer = true,
    ESPSkeleton = false,
    ESPChams = false,
    ESPTeamColor = false,
    ESPMaxDistance = 500,
    ESPRainbow = false,
    Fullbright = false,
    NoFog = false,
    FOVChanger = false,
    FOVValue = 70,
    CrosshairEnabled = false,
    CrosshairColor = Color3.fromRGB(0, 255, 255),
    
    -- Movement
    WalkSpeed = 16,
    JumpPower = 50,
    InfiniteJump = false,
    FlyEnabled = false,
    FlySpeed = 50,
    NoclipEnabled = false,
    BunnyHop = false,
    Spinbot = false,
    
    -- Misc
    Godmode = false,
    AntiAFK = false,
    AntiFling = false,
    AntiVoid = false,
    ChatSpy = false,
    FPSBooster = false,
    
    -- Settings
    Theme = "Dark",
    KeybindToggle = Enum.KeyCode.RightShift,
    ConfigLoaded = false
}

-- ===================================================================
-- === FALLBACK / COMPATIBILITY FUNCTIONS ===
-- ===================================================================
local function safeHttpGet(url)
    local ok, res = pcall(function()
        if httpget then return httpget(url) end
        if game.HttpGet then return game:HttpGet(url) end
        if request then return request({Url = url, Method = "GET"}).Body end
    end)
    return ok and res or nil
end

local function safeQueueOnTeleport(code)
    local ok, err = pcall(function()
        if queue_on_teleport then queue_on_teleport(code); return true end
        if syn and syn.queue_on_teleport then syn.queue_on_teleport(code); return true end
        if fluxus and fluxus.queue_on_teleport then fluxus.queue_on_teleport(code); return true end
        return false
    end)
    return ok, err
end

local function safeWriteFile(path, content)
    local ok, err = pcall(function()
        if writefile then writefile(path, content); return true end
        if syn and syn.write_file then syn.write_file(path, content); return true end
        return false
    end)
    return ok, err
end

local function safeReadFile(path)
    local ok, res = pcall(function()
        if readfile then return readfile(path) end
        if syn and syn.read_file then return syn.read_file(path) end
        return nil
    end)
    return ok and res or nil
end

local function safeGetCustomAsset(path)
    local ok, res = pcall(function()
        if getcustomasset then return getcustomasset(path) end
        if getsynasset then return getsynasset(path) end
        return "rbxasset://" .. path
    end)
    return ok and res or "rbxasset://" .. path
end

local function safeDrawingNew(type)
    local ok, obj = pcall(function()
        if Drawing and Drawing.new then return Drawing.new(type) end
        if drawing and drawing.new then return drawing.new(type) end
        return nil
    end)
    return ok and obj or nil
end

-- ===================================================================
-- === INTRO ANIMATION ===
-- ===================================================================
local function playIntro()
    local introGui = Instance.new("ScreenGui")
    introGui.Name = "EXC_Intro"
    introGui.IgnoreGuiInset = true
    introGui.DisplayOrder = 9999
    introGui.Parent = player:WaitForChild("PlayerGui")

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(5, 3, 10)
    bg.BorderSizePixel = 0
    bg.Parent = introGui

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(0, 300, 0, 150)
    text.Position = UDim2.new(0.5, -150, 0.5, -75)
    text.BackgroundTransparency = 1
    text.Text = "EXC"
    text.TextColor3 = Color3.fromRGB(0, 255, 255)
    text.TextScaled = true
    text.Font = Enum.Font.GothamBlack
    text.TextTransparency = 1
    text.Parent = bg

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 3
    stroke.Color = Color3.fromRGB(0, 255, 255)
    stroke.Transparency = 1
    stroke.Parent = text

    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(0, 300, 0, 2)
    barBg.Position = UDim2.new(0.5, -150, 0.5, 100)
    barBg.BackgroundColor3 = Color3.fromRGB(30, 20, 40)
    barBg.BorderSizePixel = 0
    barBg.Parent = bg

    local barFill = Instance.new("Frame")
    barFill.Size = UDim2.new(0, 0, 1, 0)
    barFill.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
    barFill.BorderSizePixel = 0
    barFill.Parent = barBg

    local loadingMessages = {
        "Initializing EXC Core...",
        "Loading Universal Modules...",
        "Detecting Game Environment...",
        "Preparing UI...",
        "Ready."
    }
    local msgLabel = Instance.new("TextLabel")
    msgLabel.Size = UDim2.new(1, 0, 0, 30)
    msgLabel.Position = UDim2.new(0, 0, 1, -40)
    msgLabel.BackgroundTransparency = 1
    msgLabel.Text = ""
    msgLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    msgLabel.TextSize = 14
    msgLabel.Font = Enum.Font.Gotham
    msgLabel.Parent = bg

    local TweenService = game:GetService("TweenService")

    -- Animate in
    TweenService:Create(text, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
    TweenService:Create(stroke, TweenInfo.new(0.8), {Transparency = 0}):Play()

    task.spawn(function()
        for i, msg in ipairs(loadingMessages) do
            msgLabel.Text = msg
            task.wait(0.6)
        end
    end)

    TweenService:Create(barFill, TweenInfo.new(3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)}):Play()
    task.wait(3.5)

    -- Fade out
    local fadeInfo = TweenInfo.new(0.5)
    TweenService:Create(bg, fadeInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(text, fadeInfo, {TextTransparency = 1}):Play()
    TweenService:Create(stroke, fadeInfo, {Transparency = 1}):Play()
    TweenService:Create(barBg, fadeInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(barFill, fadeInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(msgLabel, fadeInfo, {TextTransparency = 1}):Play()
    task.wait(0.5)
    introGui:Destroy()
end

playIntro()

-- ===================================================================
-- === RAYFIELD UI SETUP ===
-- ===================================================================
local Rayfield = loadstring(safeHttpGet('https://sirius.menu/rayfield'))()
if not Rayfield then
    Rayfield = loadstring(safeHttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
end
if not Rayfield then
    warn("[EXC Hub] Failed to load Rayfield UI.")
    return
end

-- Custom Theme (Shadow Ocean)
local ShadowOceanTheme = {
    TextColor = Color3.fromRGB(220, 230, 240),
    Background = Color3.fromRGB(15, 20, 30),
    Topbar = Color3.fromRGB(20, 25, 40),
    Shadow = Color3.fromRGB(5, 8, 15),
    NotificationBackground = Color3.fromRGB(25, 30, 45),
    NotificationActionsBackground = Color3.fromRGB(35, 45, 60),
    TabBackground = Color3.fromRGB(30, 40, 55),
    TabStroke = Color3.fromRGB(45, 60, 80),
    TabBackgroundSelected = Color3.fromRGB(0, 120, 180),
    TabTextColor = Color3.fromRGB(180, 200, 220),
    SelectedTabTextColor = Color3.fromRGB(255, 255, 255),
    ElementBackground = Color3.fromRGB(25, 35, 50),
    ElementBackgroundHover = Color3.fromRGB(35, 45, 65),
    SecondaryElementBackground = Color3.fromRGB(20, 28, 40),
    ElementStroke = Color3.fromRGB(50, 70, 90),
    SecondaryElementStroke = Color3.fromRGB(40, 55, 75),
    SliderBackground = Color3.fromRGB(0, 150, 200),
    SliderProgress = Color3.fromRGB(0, 200, 255),
    SliderStroke = Color3.fromRGB(0, 170, 230),
    ToggleBackground = Color3.fromRGB(35, 45, 60),
    ToggleEnabled = Color3.fromRGB(0, 200, 255),
    ToggleDisabled = Color3.fromRGB(80, 80, 80),
    ToggleEnabledStroke = Color3.fromRGB(0, 220, 255),
    ToggleDisabledStroke = Color3.fromRGB(100, 100, 100),
    ToggleEnabledOuterStroke = Color3.fromRGB(120, 120, 120),
    ToggleDisabledOuterStroke = Color3.fromRGB(70, 70, 70),
    DropdownSelected = Color3.fromRGB(0, 120, 180),
    DropdownUnselected = Color3.fromRGB(25, 35, 50),
    InputBackground = Color3.fromRGB(20, 28, 40),
    InputStroke = Color3.fromRGB(60, 80, 100),
    PlaceholderColor = Color3.fromRGB(150, 170, 190)
}

local Window = Rayfield:CreateWindow({
    Name = "EXC Hub | Shadow Edition",
    Icon = 0,
    LoadingTitle = "Loading EXC Hub...",
    LoadingSubtitle = "by excluse | Universal",
    Theme = ShadowOceanTheme,
    DisableRayfieldPrompts = true,
    DisableBuildWarnings = true,
    ConfigurationSaving = {
       Enabled = true,
       FolderName = "EXCconfig",
       FileName = "EXC Hub Shadow"
    },
    KeySystem = false
})

-- ===================================================================
-- === UNIVERSAL TABS ===
-- ===================================================================
local CombatTab = Window:CreateTab("⚔️ Combat")
local VisualsTab = Window:CreateTab("👁️ Visuals")
local MovementTab = Window:CreateTab("🏃 Movement")
local MiscTab = Window:CreateTab("🔧 Misc")
local SettingsTab = Window:CreateTab("⚙️ Settings")

-- ===================================================================
-- === FEATURE IMPLEMENTATIONS (Combat) ===
-- ===================================================================
local function getTarget()
    local closest = nil
    local closestDist = State.AimbotFOV
    local cam = Workspace.CurrentCamera
    local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if State.AimbotTeamCheck and p.Team == player.Team then continue end
            local hrp = p.Character.HumanoidRootPart
            local screenPos, onScreen = cam:WorldToViewportPoint(hrp.Position)
            if onScreen then
                local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                if dist < closestDist then
                    if State.AimbotWallCheck then
                        local ray = Ray.new(cam.CFrame.Position, (hrp.Position - cam.CFrame.Position).Unit * 500)
                        local hit = Workspace:FindPartOnRay(ray, player.Character)
                        if hit and not hit:IsDescendantOf(p.Character) then
                            continue
                        end
                    end
                    closestDist = dist
                    closest = p.Character
                end
            end
        end
    end
    return closest
end

local function updateAimbot()
    if not State.AimbotEnabled then return end
    local target = getTarget()
    if target then
        local targetPart = target:FindFirstChild(State.AimbotTargetPart) or target:FindFirstChild("Head")
        if targetPart then
            local cam = Workspace.CurrentCamera
            cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, targetPart.Position), State.AimbotSmoothness)
        end
    end
end

AimbotConnection = RunService.RenderStepped:Connect(function()
    if State.AimbotEnabled then
        if State.AimbotHoldKey and not UserInputService:IsKeyDown(State.AimbotHoldKey) then
            return
        end
        updateAimbot()
    end
end)
table.insert(Connections, AimbotConnection)

-- Silent Aim
local function updateSilentAim()
    if not State.SilentAimEnabled then return end
    local target = getTarget()
    if target then
        local targetPart = target:FindFirstChild(State.AimbotTargetPart) or target:FindFirstChild("Head")
        if targetPart then
            local cam = Workspace.CurrentCamera
            local screenPos, onScreen = cam:WorldToViewportPoint(targetPart.Position)
            if onScreen then
                pcall(function()
                    mousemoverel(screenPos.X - cam.ViewportSize.X / 2, screenPos.Y - cam.ViewportSize.Y / 2)
                end)
            end
        end
    end
end

RunService.RenderStepped:Connect(function()
    if State.SilentAimEnabled then
        updateSilentAim()
    end
end)

-- Triggerbot
task.spawn(function()
    while task.wait(State.TriggerbotDelay) do
        if State.TriggerbotEnabled then
            local target = getTarget()
            if target then
                local targetPart = target:FindFirstChild(State.AimbotTargetPart)
                if targetPart then
                    local cam = Workspace.CurrentCamera
                    local screenPos, onScreen = cam:WorldToViewportPoint(targetPart.Position)
                    if onScreen then
                        pcall(function()
                            VirtualUser:CaptureController()
                            VirtualUser:ClickButton1(Vector2.new(0, 0))
                        end)
                    end
                end
            end
        end
    end
end)

-- Hitbox Expander
local function applyHitboxExpander()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                if State.HitboxExpanderEnabled then
                    if not OriginalProperties[p.Character] then
                        OriginalProperties[p.Character] = {
                            Head = p.Character:FindFirstChild("Head") and p.Character.Head.Size,
                            HRP = hrp.Size
                        }
                    end
                    if p.Character:FindFirstChild("Head") then
                        p.Character.Head.Size = Vector3.new(State.HitboxSize, State.HitboxSize, State.HitboxSize)
                        p.Character.Head.Transparency = 0.5
                        p.Character.Head.CanCollide = false
                    end
                    hrp.Size = Vector3.new(State.HitboxSize, State.HitboxSize, State.HitboxSize)
                    hrp.Transparency = 0.5
                    hrp.CanCollide = false
                else
                    if OriginalProperties[p.Character] then
                        if p.Character:FindFirstChild("Head") and OriginalProperties[p.Character].Head then
                            p.Character.Head.Size = OriginalProperties[p.Character].Head
                            p.Character.Head.Transparency = 0
                            p.Character.Head.CanCollide = true
                        end
                        hrp.Size = OriginalProperties[p.Character].HRP
                        hrp.Transparency = 1
                        hrp.CanCollide = true
                        OriginalProperties[p.Character] = nil
                    end
                end
            end
        end
    end
end

RunService.Heartbeat:Connect(function()
    if State.HitboxExpanderEnabled then
        applyHitboxExpander()
    end
end)

-- ===================================================================
-- === FEATURE IMPLEMENTATIONS (Visuals) ===
-- ===================================================================
local function createDrawing(type, props)
    local obj = safeDrawingNew(type)
    if not obj then return nil end
    for k, v in pairs(props) do
        pcall(function() obj[k] = v end)
    end
    table.insert(DrawingObjects, obj)
    return obj
end

local function updateESP()
    if not State.ESPEnabled then
        for _, obj in pairs(ESPObjects) do
            if obj.Box then obj.Box.Visible = false end
            if obj.Name then obj.Name.Visible = false end
            if obj.Health then obj.Health.Visible = false end
            if obj.Distance then obj.Distance.Visible = false end
            if obj.Tracer then obj.Tracer.Visible = false end
        end
        return
    end

    local cam = Workspace.CurrentCamera
    local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local char = p.Character
            local hrp = char.HumanoidRootPart
            local head = char:FindFirstChild("Head")
            if not head then continue end

            local dist = myRoot and (hrp.Position - myRoot.Position).Magnitude or 0
            if dist > State.ESPMaxDistance then continue end

            local screenPos, onScreen = cam:WorldToViewportPoint(hrp.Position)
            if onScreen then
                if not ESPObjects[p] then
                    ESPObjects[p] = {
                        Box = createDrawing("Square", {Thickness = 1, Filled = false, Color = Color3.fromRGB(255, 255, 255)}),
                        Name = createDrawing("Text", {Size = 14, Center = true, Outline = true, Color = Color3.fromRGB(255, 255, 255)}),
                        Health = createDrawing("Line", {Thickness = 2, Color = Color3.fromRGB(0, 255, 0)}),
                        Distance = createDrawing("Text", {Size = 12, Center = true, Outline = true, Color = Color3.fromRGB(200, 200, 200)}),
                        Tracer = createDrawing("Line", {Thickness = 1, Color = Color3.fromRGB(255, 255, 255)})
                    }
                end

                local data = ESPObjects[p]
                local boxSize = Vector2.new(2000 / dist, 3000 / dist)
                local boxPos = Vector2.new(screenPos.X - boxSize.X / 2, screenPos.Y - boxSize.Y / 2)

                if data.Box then
                    data.Box.Visible = State.ESPBox
                    data.Box.Size = boxSize
                    data.Box.Position = boxPos
                    data.Box.Color = State.ESPTeamColor and (p.Team and p.Team.TeamColor.Color or Color3.fromRGB(255, 255, 255)) or Color3.fromRGB(255, 255, 255)
                    if State.ESPRainbow then
                        data.Box.Color = Color3.fromHSV((tick() % 1), 1, 1)
                    end
                end

                if data.Name then
                    data.Name.Visible = State.ESPName
                    data.Name.Text = p.Name
                    data.Name.Position = Vector2.new(screenPos.X, boxPos.Y - 15)
                    data.Name.Color = State.ESPTeamColor and (p.Team and p.Team.TeamColor.Color or Color3.fromRGB(255, 255, 255)) or Color3.fromRGB(255, 255, 255)
                end

                if data.Health then
                    data.Health.Visible = State.ESPHealth
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then
                        local healthPct = hum.Health / hum.MaxHealth
                        data.Health.From = Vector2.new(boxPos.X - 5, boxPos.Y + boxSize.Y)
                        data.Health.To = Vector2.new(boxPos.X - 5, boxPos.Y + boxSize.Y * (1 - healthPct))
                        data.Health.Color = Color3.fromRGB(255 * (1 - healthPct), 255 * healthPct, 0)
                    end
                end

                if data.Distance then
                    data.Distance.Visible = State.ESPDistance
                    data.Distance.Text = math.floor(dist) .. "m"
                    data.Distance.Position = Vector2.new(screenPos.X, boxPos.Y + boxSize.Y + 5)
                end

                if data.Tracer then
                    data.Tracer.Visible = State.ESPTracer
                    data.Tracer.From = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y)
                    data.Tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                end
            else
                if ESPObjects[p] then
                    for _, obj in pairs(ESPObjects[p]) do
                        if obj then obj.Visible = false end
                    end
                end
            end
        end
    end
end

ESPConnection = RunService.RenderStepped:Connect(function()
    updateESP()
end)
table.insert(Connections, ESPConnection)

-- Fullbright, NoFog, FOV Changer
local function applyVisualSettings()
    if State.Fullbright then
        Lighting.Ambient = Color3.fromRGB(200, 200, 200)
        Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
        Lighting.Brightness = 2
    else
        Lighting.Ambient = Color3.fromRGB(70, 70, 70)
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        Lighting.Brightness = 1
    end

    if State.NoFog then
        Lighting.FogEnd = 100000
        Lighting.FogStart = 100000
    else
        Lighting.FogEnd = 1000
        Lighting.FogStart = 0
    end

    if State.FOVChanger then
        Workspace.CurrentCamera.FieldOfView = State.FOVValue
    else
        Workspace.CurrentCamera.FieldOfView = 70
    end
end

RunService.Heartbeat:Connect(applyVisualSettings)

-- ===================================================================
-- === FEATURE IMPLEMENTATIONS (Movement) ===
-- ===================================================================
local function updateMovement()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = State.WalkSpeed
        hum.JumpPower = State.JumpPower
        hum.UseJumpPower = true
    end
end

RunService.Heartbeat:Connect(updateMovement)

-- Fly
local function toggleFly(enabled)
    State.FlyEnabled = enabled
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if enabled then
        local bg = Instance.new("BodyGyro")
        bg.P = 9e4
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.CFrame = hrp.CFrame
        bg.Parent = hrp

        local bv = Instance.new("BodyVelocity")
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Parent = hrp

        FlyConnection = RunService.RenderStepped:Connect(function()
            if not State.FlyEnabled or not hrp.Parent then
                if FlyConnection then FlyConnection:Disconnect() end
                return
            end
            local cam = Workspace.CurrentCamera
            local moveDir = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir -= Vector3.new(0, 1, 0) end
            bv.Velocity = moveDir * State.FlySpeed
            bg.CFrame = cam.CFrame
        end)
        table.insert(Connections, FlyConnection)
    else
        if FlyConnection then FlyConnection:Disconnect() end
        for _, v in pairs(hrp:GetChildren()) do
            if v:IsA("BodyGyro") or v:IsA("BodyVelocity") then v:Destroy() end
        end
    end
end

-- Noclip
local NoclipConnection
local function toggleNoclip(enabled)
    State.NoclipEnabled = enabled
    if enabled then
        NoclipConnection = RunService.Stepped:Connect(function()
            if not State.NoclipEnabled then return end
            local char = player.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
        table.insert(Connections, NoclipConnection)
    else
        if NoclipConnection then NoclipConnection:Disconnect() end
        local char = player.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if State.InfiniteJump then
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Bunny Hop & Spinbot (Simple Implementation)
RunService.Heartbeat:Connect(function()
    if State.BunnyHop then
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum and hum.MoveDirection.Magnitude > 0 then
            if hum:GetState() == Enum.HumanoidStateType.Landed then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end

    if State.Spinbot then
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(45), 0)
        end
    end
end)

-- ===================================================================
-- === FEATURE IMPLEMENTATIONS (Misc) ===
-- ===================================================================
-- Godmode (Basic)
task.spawn(function()
    while task.wait(1) do
        if State.Godmode then
            local char = player.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.MaxHealth = math.huge
                    hum.Health = math.huge
                end
            end
        end
    end
end)

-- Anti-AFK
player.Idled:Connect(function()
    if State.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- Anti-Fling
RunService.Heartbeat:Connect(function()
    if State.AntiFling then
        local char = player.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.Velocity = Vector3.new(0, 0, 0)
                hrp.RotVelocity = Vector3.new(0, 0, 0)
            end
        end
    end
end)

-- Anti-Void
task.spawn(function()
    while task.wait(1) do
        if State.AntiVoid then
            local char = player.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp and hrp.Position.Y < -50 then
                    hrp.CFrame = CFrame.new(0, 50, 0)
                end
            end
        end
    end
end)

-- FPS Booster (Disable Post-Processing)
local function applyFPSBooster()
    if State.FPSBooster then
        for _, effect in ipairs(Lighting:GetChildren()) do
            if effect:IsA("PostEffect") then
                effect.Enabled = false
            end
        end
    else
        for _, effect in ipairs(Lighting:GetChildren()) do
            if effect:IsA("PostEffect") then
                effect.Enabled = true
            end
        end
    end
end

RunService.Heartbeat:Connect(applyFPSBooster)

-- Chat Spy
local function setupChatSpy()
    local oldChat = player.Chatted
    player.Chatted:Connect(function(msg)
        LastChatMessage = msg
        if State.ChatSpy then
            print("[ChatSpy] " .. player.Name .. ": " .. msg)
        end
    end)
end
setupChatSpy()

-- ===================================================================
-- === GAME-SPECIFIC TABS ===
-- ===================================================================
local PlaceId = game.PlaceId
local GameName = "Unknown"
pcall(function()
    GameName = game:GetService("MarketplaceService"):GetProductInfo(PlaceId).Name
end)

if PlaceId == 15899178400 then
    -- Call of Mini: Zombies 2
    local GameTab = Window:CreateTab("🧟 COM:Z 2")
    GameTab:CreateSection("Combat")
    GameTab:CreateToggle({
        Name = "Boss Insta-Kill",
        CurrentValue = false,
        Flag = "BossKill",
        Callback = function(v)
            State.BossKill = v
        end
    })
    -- ... (Add other game-specific features)
elseif PlaceId == 6447798030 then
    -- Funky Friday
    local GameTab = Window:CreateTab("🎵 Funky Friday")
    GameTab:CreateSection("Auto Player")
    GameTab:CreateToggle({
        Name = "Enable Auto Player",
        CurrentValue = false,
        Flag = "FFAuto",
        Callback = function(v)
            State.FFAuto = v
        end
    })
    -- ... (Add other game-specific features)
elseif PlaceId == 142823291 then
    -- Murder Mystery 2
    local GameTab = Window:CreateTab("🔪 MM2")
    GameTab:CreateSection("Role ESP")
    GameTab:CreateToggle({
        Name = "Murderer ESP (Red)",
        CurrentValue = false,
        Flag = "MM2Murderer",
        Callback = function(v)
            State.MM2MurdererESP = v
        end
    })
    GameTab:CreateToggle({
        Name = "Sheriff ESP (Blue)",
        CurrentValue = false,
        Flag = "MM2Sheriff",
        Callback = function(v)
            State.MM2SheriffESP = v
        end
    })
    -- ... (Add other game-specific features)
elseif PlaceId == 4588604953 then
    -- Criminality
    local GameTab = Window:CreateTab("🔫 Criminality")
    GameTab:CreateSection("Combat")
    GameTab:CreateToggle({
        Name = "Enable Aimbot",
        CurrentValue = false,
        Flag = "CrimAimbot",
        Callback = function(v)
            State.AimbotEnabled = v
        end
    })
    -- ... (Add other game-specific features)
elseif PlaceId == 1537690962 then
    -- Bee Swarm Simulator
    local GameTab = Window:CreateTab("🐝 BSS")
    GameTab:CreateSection("Farming")
    GameTab:CreateToggle({
        Name = "Auto Farm",
        CurrentValue = false,
        Flag = "BSSFarm",
        Callback = function(v)
            State.BSSAutoFarm = v
        end
    })
    -- ... (Add other game-specific features)
end

-- ===================================================================
-- === UI CONSTRUCTION (Combat Tab) ===
-- ===================================================================
CombatTab:CreateSection("Aimbot")
CombatTab:CreateToggle({
    Name = "Enable Aimbot",
    CurrentValue = State.AimbotEnabled,
    Flag = "AimbotEnabled",
    Callback = function(v)
        State.AimbotEnabled = v
    end
})
CombatTab:CreateKeybind({
    Name = "Aimbot Hold Key",
    CurrentKeybind = "E",
    HoldToInteract = true,
    Flag = "AimbotHoldKey",
    Callback = function(key)
        State.AimbotHoldKey = key
    end
})
CombatTab:CreateSlider({
    Name = "Aimbot Smoothness",
    Range = {0.05, 1},
    Increment = 0.05,
    CurrentValue = State.AimbotSmoothness,
    Flag = "AimbotSmoothness",
    Callback = function(v)
        State.AimbotSmoothness = v
    end
})
CombatTab:CreateSlider({
    Name = "Aimbot FOV",
    Range = {30, 360},
    Increment = 10,
    Suffix = "°",
    CurrentValue = State.AimbotFOV,
    Flag = "AimbotFOV",
    Callback = function(v)
        State.AimbotFOV = v
    end
})
CombatTab:CreateDropdown({
    Name = "Aimbot Target Part",
    Options = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"},
    CurrentOption = State.AimbotTargetPart,
    Flag = "AimbotTargetPart",
    Callback = function(v)
        State.AimbotTargetPart = v
    end
})
CombatTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = State.AimbotTeamCheck,
    Flag = "AimbotTeamCheck",
    Callback = function(v)
        State.AimbotTeamCheck = v
    end
})
CombatTab:CreateToggle({
    Name = "Wall Check",
    CurrentValue = State.AimbotWallCheck,
    Flag = "AimbotWallCheck",
    Callback = function(v)
        State.AimbotWallCheck = v
    end
})
CombatTab:CreateToggle({
    Name = "Sticky Aim",
    CurrentValue = State.AimbotSticky,
    Flag = "AimbotSticky",
    Callback = function(v)
        State.AimbotSticky = v
    end
})
CombatTab:CreateDropdown({
    Name = "Target Priority",
    Options = {"Distance", "Health", "Cursor"},
    CurrentOption = State.AimbotPriority,
    Flag = "AimbotPriority",
    Callback = function(v)
        State.AimbotPriority = v
    end
})

CombatTab:CreateSection("Silent Aim")
CombatTab:CreateToggle({
    Name = "Enable Silent Aim",
    CurrentValue = State.SilentAimEnabled,
    Flag = "SilentAimEnabled",
    Callback = function(v)
        State.SilentAimEnabled = v
    end
})

CombatTab:CreateSection("Triggerbot")
CombatTab:CreateToggle({
    Name = "Enable Triggerbot",
    CurrentValue = State.TriggerbotEnabled,
    Flag = "TriggerbotEnabled",
    Callback = function(v)
        State.TriggerbotEnabled = v
    end
})
CombatTab:CreateSlider({
    Name = "Trigger Delay",
    Range = {0.01, 0.5},
    Increment = 0.01,
    CurrentValue = State.TriggerbotDelay,
    Flag = "TriggerbotDelay",
    Callback = function(v)
        State.TriggerbotDelay = v
    end
})

CombatTab:CreateSection("Hitbox Expander")
CombatTab:CreateToggle({
    Name = "Enable Hitbox Expander",
    CurrentValue = State.HitboxExpanderEnabled,
    Flag = "HitboxExpanderEnabled",
    Callback = function(v)
        State.HitboxExpanderEnabled = v
        if not v then
            applyHitboxExpander() -- Reset
        end
    end
})
CombatTab:CreateSlider({
    Name = "Hitbox Size",
    Range = {1, 20},
    Increment = 1,
    CurrentValue = State.HitboxSize,
    Flag = "HitboxSize",
    Callback = function(v)
        State.HitboxSize = v
    end
})

-- ===================================================================
-- === UI CONSTRUCTION (Visuals Tab) ===
-- ===================================================================
VisualsTab:CreateSection("ESP")
VisualsTab:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = State.ESPEnabled,
    Flag = "ESPEnabled",
    Callback = function(v)
        State.ESPEnabled = v
    end
})
VisualsTab:CreateToggle({
    Name = "Box ESP",
    CurrentValue = State.ESPBox,
    Flag = "ESPBox",
    Callback = function(v)
        State.ESPBox = v
    end
})
VisualsTab:CreateToggle({
    Name = "Name Tags",
    CurrentValue = State.ESPName,
    Flag = "ESPName",
    Callback = function(v)
        State.ESPName = v
    end
})
VisualsTab:CreateToggle({
    Name = "Health Bars",
    CurrentValue = State.ESPHealth,
    Flag = "ESPHealth",
    Callback = function(v)
        State.ESPHealth = v
    end
})
VisualsTab:CreateToggle({
    Name = "Distance",
    CurrentValue = State.ESPDistance,
    Flag = "ESPDistance",
    Callback = function(v)
        State.ESPDistance = v
    end
})
VisualsTab:CreateToggle({
    Name = "Tracers",
    CurrentValue = State.ESPTracer,
    Flag = "ESPTracer",
    Callback = function(v)
        State.ESPTracer = v
    end
})
VisualsTab:CreateToggle({
    Name = "Skeleton ESP",
    CurrentValue = State.ESPSkeleton,
    Flag = "ESPSkeleton",
    Callback = function(v)
        State.ESPSkeleton = v
    end
})
VisualsTab:CreateToggle({
    Name = "Chams",
    CurrentValue = State.ESPChams,
    Flag = "ESPChams",
    Callback = function(v)
        State.ESPChams = v
    end
})
VisualsTab:CreateToggle({
    Name = "Team Color",
    CurrentValue = State.ESPTeamColor,
    Flag = "ESPTeamColor",
    Callback = function(v)
        State.ESPTeamColor = v
    end
})
VisualsTab:CreateToggle({
    Name = "Rainbow Mode",
    CurrentValue = State.ESPRainbow,
    Flag = "ESPRainbow",
    Callback = function(v)
        State.ESPRainbow = v
    end
})
VisualsTab:CreateSlider({
    Name = "Max Distance",
    Range = {50, 2000},
    Increment = 50,
    Suffix = "m",
    CurrentValue = State.ESPMaxDistance,
    Flag = "ESPMaxDistance",
    Callback = function(v)
        State.ESPMaxDistance = v
    end
})

VisualsTab:CreateSection("Environment")
VisualsTab:CreateToggle({
    Name = "Fullbright",
    CurrentValue = State.Fullbright,
    Flag = "Fullbright",
    Callback = function(v)
        State.Fullbright = v
    end
})
VisualsTab:CreateToggle({
    Name = "No Fog",
    CurrentValue = State.NoFog,
    Flag = "NoFog",
    Callback = function(v)
        State.NoFog = v
    end
})
VisualsTab:CreateToggle({
    Name = "FOV Changer",
    CurrentValue = State.FOVChanger,
    Flag = "FOVChanger",
    Callback = function(v)
        State.FOVChanger = v
    end
})
VisualsTab:CreateSlider({
    Name = "FOV Value",
    Range = {30, 120},
    Increment = 5,
    CurrentValue = State.FOVValue,
    Flag = "FOVValue",
    Callback = function(v)
        State.FOVValue = v
    end
})

-- ===================================================================
-- === UI CONSTRUCTION (Movement Tab) ===
-- ===================================================================
MovementTab:CreateSection("Speed & Jump")
MovementTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 500},
    Increment = 1,
    Suffix = " studs/s",
    CurrentValue = State.WalkSpeed,
    Flag = "WalkSpeed",
    Callback = function(v)
        State.WalkSpeed = v
    end
})
MovementTab:CreateSlider({
    Name = "JumpPower",
    Range = {50, 500},
    Increment = 5,
    CurrentValue = State.JumpPower,
    Flag = "JumpPower",
    Callback = function(v)
        State.JumpPower = v
    end
})
MovementTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = State.InfiniteJump,
    Flag = "InfiniteJump",
    Callback = function(v)
        State.InfiniteJump = v
    end
})

MovementTab:CreateSection("Flight & Noclip")
MovementTab:CreateToggle({
    Name = "Fly",
    CurrentValue = State.FlyEnabled,
    Flag = "FlyEnabled",
    Callback = function(v)
        toggleFly(v)
    end
})
MovementTab:CreateSlider({
    Name = "Fly Speed",
    Range = {10, 200},
    Increment = 5,
    CurrentValue = State.FlySpeed,
    Flag = "FlySpeed",
    Callback = function(v)
        State.FlySpeed = v
    end
})
MovementTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = State.NoclipEnabled,
    Flag = "NoclipEnabled",
    Callback = function(v)
        toggleNoclip(v)
    end
})

MovementTab:CreateSection("Advanced")
MovementTab:CreateToggle({
    Name = "Bunny Hop",
    CurrentValue = State.BunnyHop,
    Flag = "BunnyHop",
    Callback = function(v)
        State.BunnyHop = v
    end
})
MovementTab:CreateToggle({
    Name = "Spinbot",
    CurrentValue = State.Spinbot,
    Flag = "Spinbot",
    Callback = function(v)
        State.Spinbot = v
    end
})

-- ===================================================================
-- === UI CONSTRUCTION (Misc Tab) ===
-- ===================================================================
MiscTab:CreateSection("Player")
MiscTab:CreateToggle({
    Name = "Godmode",
    CurrentValue = State.Godmode,
    Flag = "Godmode",
    Callback = function(v)
        State.Godmode = v
    end
})
MiscTab:CreateToggle({
    Name = "Anti-AFK",
    CurrentValue = State.AntiAFK,
    Flag = "AntiAFK",
    Callback = function(v)
        State.AntiAFK = v
    end
})
MiscTab:CreateToggle({
    Name = "Anti-Fling",
    CurrentValue = State.AntiFling,
    Flag = "AntiFling",
    Callback = function(v)
        State.AntiFling = v
    end
})
MiscTab:CreateToggle({
    Name = "Anti-Void",
    CurrentValue = State.AntiVoid,
    Flag = "AntiVoid",
    Callback = function(v)
        State.AntiVoid = v
    end
})

MiscTab:CreateSection("Server")
MiscTab:CreateButton({
    Name = "🔄 Rejoin Server",
    Callback = function()
        local jobId = game.JobId
        if jobId and jobId ~= "" then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, player)
        else
            Rayfield:Notify({Title = "Error", Content = "Could not get JobId.", Duration = 3})
        end
    end
})
MiscTab:CreateButton({
    Name = "📋 Copy JobId",
    Callback = function()
        local jobId = game.JobId
        if jobId and jobId ~= "" then
            pcall(function() setclipboard(jobId) end)
            Rayfield:Notify({Title = "Copied", Content = "JobId copied to clipboard.", Duration = 3})
        end
    end
})
MiscTab:CreateButton({
    Name = "🌐 Server Hop",
    Callback = function()
        -- Simple server hop implementation
        local servers = {}
        pcall(function()
            local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
            local response = safeHttpGet(url)
            if response then
                local data = HttpService:JSONDecode(response)
                if data and data.data then
                    for _, server in ipairs(data.data) do
                        if server.playing < server.maxPlayers and server.id ~= game.JobId then
                            table.insert(servers, server.id)
                        end
                    end
                end
            end
        end)
        if #servers > 0 then
            local target = servers[math.random(1, #servers)]
            TeleportService:TeleportToPlaceInstance(game.PlaceId, target, player)
        else
            Rayfield:Notify({Title = "Error", Content = "No available servers found.", Duration = 3})
        end
    end
})

MiscTab:CreateSection("Utility")
MiscTab:CreateToggle({
    Name = "FPS Booster",
    CurrentValue = State.FPSBooster,
    Flag = "FPSBooster",
    Callback = function(v)
        State.FPSBooster = v
    end
})
MiscTab:CreateToggle({
    Name = "Chat Spy",
    CurrentValue = State.ChatSpy,
    Flag = "ChatSpy",
    Callback = function(v)
        State.ChatSpy = v
    end
})
MiscTab:CreateInput({
    Name = "Command Bar",
    PlaceholderText = "Enter command...",
    RemoveTextAfterFocusLost = true,
    Callback = function(text)
        if text and text ~= "" then
            pcall(function()
                loadstring(text)()
            end)
        end
    end
})

-- ===================================================================
-- === UI CONSTRUCTION (Settings Tab) ===
-- ===================================================================
SettingsTab:CreateSection("Theme")
SettingsTab:CreateDropdown({
    Name = "Select Theme",
    Options = {"Dark", "Light", "Ocean", "Amethyst", "Rose", "Mint"},
    CurrentOption = State.Theme,
    Flag = "Theme",
    Callback = function(option)
        State.Theme = option
        -- Rayfield has built-in themes, but for custom ones, we'd need to re-create the window.
        -- For simplicity, we'll just notify the user.
        Rayfield:Notify({Title = "Theme", Content = "Theme set to " .. option .. ". (Restart to fully apply custom themes)", Duration = 5})
    end
})

SettingsTab:CreateSection("Keybinds")
SettingsTab:CreateKeybind({
    Name = "Toggle Hub",
    CurrentKeybind = State.KeybindToggle.Name,
    HoldToInteract = false,
    Flag = "KeybindToggle",
    Callback = function(key)
        State.KeybindToggle = key
    end
})

SettingsTab:CreateSection("Configuration")
SettingsTab:CreateButton({
    Name = "💾 Save Configuration",
    Callback = function()
        -- Rayfield automatically saves if enabled. We'll just force a save.
        pcall(function()
            if Rayfield.SaveConfiguration then
                Rayfield:SaveConfiguration()
            end
        end)
        Rayfield:Notify({Title = "Config", Content = "Configuration saved.", Duration = 3})
    end
})
SettingsTab:CreateButton({
    Name = "📂 Load Configuration",
    Callback = function()
        pcall(function()
            if Rayfield.LoadConfiguration then
                Rayfield:LoadConfiguration()
            end
        end)
        Rayfield:Notify({Title = "Config", Content = "Configuration loaded.", Duration = 3})
    end
})

SettingsTab:CreateSection("Script Management")
SettingsTab:CreateButton({
    Name = "🛑 Unload Script (Panic)",
    Callback = function()
        -- Disconnect all connections
        for _, conn in ipairs(Connections) do
            pcall(function() conn:Disconnect() end)
        end
        -- Remove drawings
        for _, obj in ipairs(DrawingObjects) do
            pcall(function() obj:Remove() end)
        end
        -- Reset properties
        for char, props in pairs(OriginalProperties) do
            if char and char:FindFirstChild("Head") then
                pcall(function()
                    char.Head.Size = props.Head
                    char.HumanoidRootPart.Size = props.HRP
                end)
            end
        end
        -- Destroy UI
        pcall(function() Window:Destroy() end)
        -- Clear globals
        getgenv().EXC_Loaded = false
    end
})

-- ===================================================================
-- === INITIALIZATION ===
-- ===================================================================
Rayfield:Notify({
    Title = "EXC Hub Loaded",
    Content = "Universal features ready. Detected game: " .. GameName,
    Duration = 6
})

-- Load configuration if it exists
pcall(function()
    if Rayfield.LoadConfiguration then
        Rayfield:LoadConfiguration()
    end
end)

getgenv().EXC_Loaded = true

-- ===================================================================
-- === END OF SCRIPT ===
-- ===================================================================
