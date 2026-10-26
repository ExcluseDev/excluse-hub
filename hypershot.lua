--[[
    excluse hub | Hypershot (Advanced Galaxy Edition)
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
    Name = "excluse hub | Hypershot", LoadingTitle = "Loading Hypershot...", LoadingSubtitle = "v1.0",
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
    aimbot = false, aimbotFOV = 120, aimbotSmoothness = 0.2, aimbotPart = "Head", aimbotTeamCheck = true,
    silentAim = false, silentAimPart = "Head",
    triggerbot = false, triggerDelay = 0.1,
    espEnabled = false, espMaxDistance = 500,
    noRecoil = false, noSpread = false, rapidFire = false,
    hitboxExpander = false, hitboxSize = 5,
    walkspeed = 16, jumpPower = 50, fly = false, flySpeed = 50,
    infiniteJump = false,
    autoRespawn = false,
    highlights = {}
}

-- === HELPER: Get Target ===
local function getTarget(partName, fov)
    local closest, dist = nil, fov
    local cam = Workspace.CurrentCamera
    for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if State.aimbotTeamCheck and p.Team and player.Team and p.Team == player.Team then continue end
            local part = p.Character:FindFirstChild(partName) or p.Character:FindFirstChild("Head")
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

-- === AIMBOT ===
RunService.RenderStepped:Connect(function()
    if not State.aimbot then return end
    local target = getTarget(State.aimbotPart, State.aimbotFOV)
    if target then
        local cam = Workspace.CurrentCamera
        local targetCFrame = CFrame.new(cam.CFrame.Position, target.Position)
        cam.CFrame = cam.CFrame:Lerp(targetCFrame, State.aimbotSmoothness)
    end
end)

-- === SILENT AIM ===
RunService.RenderStepped:Connect(function()
    if not State.silentAim then return end
    local target = getTarget(State.silentAimPart, 360)
    if target then
        local cam = Workspace.CurrentCamera
        local screenPos, onScreen = cam:WorldToViewportPoint(target.Position)
        if onScreen then
            pcall(function()
                mousemoverel(screenPos.X - cam.ViewportSize.X / 2, screenPos.Y - cam.ViewportSize.Y / 2)
            end)
        end
    end
end)

-- === TRIGGERBOT ===
task.spawn(function()
    while State.triggerbot and getgenv().excluseHubRunning do
        local target = getTarget(State.aimbotPart, State.aimbotFOV)
        if target then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton1(Vector2.new(0, 0))
            end)
        end
        task.wait(State.triggerDelay)
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

-- === WEAPON MODS (PLACEHOLDERS) ===
-- These require hooking specific remotes or modifying weapon stats.
-- Currently just toggles state; actual implementation depends on game structure.
RunService.Heartbeat:Connect(function()
    if State.noRecoil then
        -- Placeholder: Hook camera recoil or weapon kickback
    end
    if State.noSpread then
        -- Placeholder: Hook weapon spread
    end
    if State.rapidFire then
        -- Placeholder: Hook fire rate remote
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
                    head.Size = Vector3.new(1, 1, 1)
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
            if UserInputService:IsKeyDown(Enum.KeyCode.Left
