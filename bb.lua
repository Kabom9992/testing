-- TSB Multi Tool Executor GUI Script

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VirtualInput = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Root = Character:WaitForChild("HumanoidRootPart")

local isFlying = false
local isInvisible = false
local autoFollow = false
local skillSpam = false
local dashBoost = false
local speedBoost = false
local followTarget = nil

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "TSB_GUI"

local openBtn = Instance.new("TextButton", ScreenGui)
openBtn.Size = UDim2.new(0, 60, 0, 60)
openBtn.Position = UDim2.new(0, 20, 0.5, -30)
openBtn.Text = "⚙️"
openBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
openBtn.TextColor3 = Color3.new(1, 1, 1)
openBtn.Draggable = true
openBtn.Active = true
openBtn.Visible = true

local mainFrame = Instance.new("Frame", ScreenGui)
mainFrame.Size = UDim2.new(0, 300, 0, 300)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Draggable = true

local function createToggle(name, order, callback)
    local btn = Instance.new("TextButton", mainFrame)
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, 10 + (order * 35))
    btn.Text = name .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.new(1, 1, 1)
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name .. ": " .. (state and "ON" or "OFF")
        callback(state)
    end)
end

createToggle("Uçma", 0, function(on)
    isFlying = on
    if not on then
        Humanoid.PlatformStand = false
    end
end)

createToggle("Görünmezlik", 1, function(on)
    isInvisible = on
    for _,v in pairs(Character:GetDescendants()) do
        if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
            v.Transparency = on and 1 or 0
        end
    end
end)

createToggle("AutoFollow", 2, function(on)
    autoFollow = on
end)

createToggle("Skill Spam", 3, function(on)
    skillSpam = on
end)

createToggle("Speed Boost", 4, function(on)
    speedBoost = on
    Humanoid.WalkSpeed = on and 50 or 16
end)

createToggle("Dash Boost", 5, function(on)
    dashBoost = on
end)

createToggle("Kapat (Script OFF)", 6, function(on)
    if on then
        ScreenGui:Destroy()
    end
end)


openBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)


RunService.RenderStepped:Connect(function()
    if isFlying then
        Humanoid.PlatformStand = true
        local direction = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then direction = direction + workspace.CurrentCamera.CFrame.LookVector end
        Root.Velocity = direction * 50
    end

    if autoFollow then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                followTarget = player.Character.HumanoidRootPart
                break
            end
        end
        if followTarget then
            Root.CFrame = CFrame.new(Root.Position, followTarget.Position)
            Root.Velocity = (followTarget.Position - Root.Position).Unit * 30
        end
    end

    if dashBoost then
        pcall(function()
            Humanoid:SetAttribute("DashCooldown", 0)
        end)
    end
end)

task.spawn(function()
    while true do
        if skillSpam then
            for _, key in ipairs({"Z", "X", "C", "V", "G"}) do
                VirtualInput:SendKeyEvent(true, key, false, game)
                task.wait(0.1)
                VirtualInput:SendKeyEvent(false, key, false, game)
            end
        end
        task.wait(1)
    end
end)
