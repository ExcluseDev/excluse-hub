--[[
    excluse universal hub (Fallback)
--]]
getgenv().SecureMode = true
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local player = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
getgenv().excluseHubRunning = true

local GalaxyTheme = {
    TextColor = Color3.fromRGB(230, 220, 255), Background = Color3.fromRGB(12, 8, 25),
    Topbar = Color3.fromRGB(20, 12, 40), Shadow = Color3.fromRGB(5, 2, 10),
    NotificationBackground = Color3.fromRGB(25, 15, 45), NotificationActionsBackground = Color3.fromRGB(35, 20, 60),
    TabBackground = Color3.fromRGB(30, 18, 55), TabStroke = Color3.fromRGB(60, 40, 100),
    TabBackgroundSelected = Color3.fromRGB(180, 50, 255), TabTextColor = Color3.fromRGB(180, 160, 220),
    SelectedTabTextColor = Color3.fromRGB(255, 255, 255), ElementBackground = Color3.fromRGB(25, 15, 45),
    ElementBackgroundHover = Color3.fromRGB(40, 25, 70), SecondaryElementBackground = Color3.fromRGB(20, 10, 35),
    ElementStroke = Color3.fromRGB(80, 50, 130), SecondaryElementStroke = Color3.fromRGB(50, 30, 90),
    SliderBackground = Color3.fromRGB(180, 50, 255), SliderProgress = Color3.fromRGB(0, 200, 255),
    SliderStroke = Color3.fromRGB(200, 100, 255), ToggleBackground = Color3.fromRGB(30, 20, 50),
    ToggleEnabled = Color3.fromRGB(0, 200, 255), ToggleDisabled = Color3.fromRGB(80, 70, 90),
    ToggleEnabledStroke = Color3.fromRGB(0, 220, 255), ToggleDisabledStroke = Color3.fromRGB(100, 90, 110),
    ToggleEnabledOuterStroke = Color3.fromRGB(255, 100, 200), ToggleDisabledOuterStroke = Color3.fromRGB(70, 60, 80),
    DropdownSelected = Color3.fromRGB(180, 50, 255), DropdownUnselected = Color3.fromRGB(25, 15, 45),
    InputBackground = Color3.fromRGB(20, 10, 35), InputStroke = Color3.fromRGB(80, 50, 130),
    PlaceholderColor = Color3.fromRGB(150, 130, 180)
}

local Window = Rayfield:CreateWindow({
    Name = "excluse universal hub",
    LoadingTitle = "Loading Universal...",
    LoadingSubtitle = "by excluse",
    Theme = GalaxyTheme,
    KeySystem = false,
    ConfigurationSaving = { Enabled = false }
})

local State = { fly = false, flySpeed = 50 }

local mainTab = Window:CreateTab("🌐 Main")
local visualsTab = Window:CreateTab("👁️ Visuals")

mainTab:CreateSection("Player Movement")
mainTab:CreateSlider({ Name = "WalkSpeed", Range = {16, 500}, Increment = 1, CurrentValue = 16, Callback = function(v) 
    local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if h then h.WalkSpeed = v end 
end })

mainTab:CreateSlider({ Name = "Jump Power", Range = {50, 500}, Increment = 5, CurrentValue = 50, Callback = function(v) 
    local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if h then h.JumpPower = v; h.UseJumpPower = true end 
end })

mainTab:CreateToggle({ Name = "Fly", CurrentValue = false, Callback = function(v)
    State.fly = v
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if v and hrp then
        local bg = Instance.new("BodyGyro", hrp); bg.P = 9e4; bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9); bg.CFrame = hrp.CFrame
        local bv = Instance.new("BodyVelocity", hrp); bv.Velocity = Vector3.new(0,0,0); bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        task.spawn(function()
            while State.fly and getgenv().excluseHubRunning and hrp.Parent do
                local cam = workspace.CurrentCamera; local move = Vector3.new()
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
                bv.Velocity = move * State.flySpeed; bg.CFrame = cam.CFrame
                task.wait()
            end
            if bg then bg:Destroy() end; if bv then bv:Destroy() end
        end)
    end
end })

mainTab:CreateSlider({ Name = "Fly Speed", Range = {10, 200}, Increment = 5, CurrentValue = 50, Callback = function(v) State.flySpeed = v end })

visualsTab:CreateSection("Environment")
visualsTab:CreateToggle({ Name = "Fullbright", CurrentValue = false, Callback = function(v)
    local lighting = game:GetService("Lighting")
    if v then lighting.Ambient = Color3.fromRGB(200, 200, 200); lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200); lighting.Brightness = 2
    else lighting.Ambient = Color3.fromRGB(70, 70, 70); lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128); lighting.Brightness = 1 end
end })

local settingsTab = Window:CreateTab("⚙️ Settings")
settingsTab:CreateButton({ Name = "🛑 Unload Script", Callback = function()
    getgenv().excluseHubRunning = false
    State.fly = false
    task.wait(0.2)
    pcall(function() Window:Destroy() end)
    local pg = player:FindFirstChild("PlayerGui")
    if pg then
        if pg:FindFirstChild("Rayfield") then pg.Rayfield:Destroy() end
        if pg:FindFirstChild("RayfieldToggleScreen") then pg.RayfieldToggleScreen:Destroy() end
    end
end })

Rayfield:Notify({ Title = "Universal Loaded", Content = "Basic movement and visual features ready.", Duration = 5 })
