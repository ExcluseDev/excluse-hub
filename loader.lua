-- Prevent Xeno CoreGui Reset Button crash
pcall(function()
    if game:GetService("CoreGui"):FindFirstChild("RobloxGui") then
        local resetBindable = game:GetService("CoreGui").RobloxGui:FindFirstChild("ResetButton")
        if resetBindable then
            resetBindable:Destroy()
        end
    end
end)

print("LOADER EXECUTION STARTED!")
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
print("RAYFIELD LOADED!")
local Window = Rayfield:CreateWindow({
    Name = "Test Hub",
    KeySystem = false
})
print("WINDOW CREATED!")
