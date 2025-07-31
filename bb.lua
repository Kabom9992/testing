-- TSB Mobile Executor (Delta Uyumlu)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Root = Character:WaitForChild("HumanoidRootPart")

-- Değişkenler
local isFlying = false
local speedBoost = false

-- UI
local gui = Instance.new("ScreenGui")
gui.Name = "TSB_GUI"
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.new(0, 60, 0, 60)
openBtn.Position = UDim2.new(0, 20, 0.5, -30)
openBtn.Text = "⚙️"
openBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
openBtn.TextColor3 = Color3.new(1, 1, 1)
openBtn.Draggable = true
openBtn.Active = true

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 250, 0, 250)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -125)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Draggable = true

local function createToggle(name, order, callback)
	local btn = Instance.new("TextButton", mainFrame)
	btn.Size = UDim2.new(1, -20, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, 10 + order * 35)
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

-- Özellikler
createToggle("Uçma", 0, function(on)
	isFlying = on
	if not on then
		Humanoid.PlatformStand = false
	end
end)

createToggle("Hız Artışı", 1, function(on)
	speedBoost = on
	Humanoid.WalkSpeed = on and 50 or 16
end)

createToggle("Kapat", 2, function(on)
	if on then gui:Destroy() end
end)

-- UI Toggle
openBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

-- Ana Döngü
RunService.RenderStepped:Connect(function()
	if isFlying then
		Humanoid.PlatformStand = true
		local direction = Vector3.zero
		if UIS:IsKeyDown(Enum.KeyCode.W) then
			direction = direction + workspace.CurrentCamera.CFrame.LookVector
		end
		Root.Velocity = direction * 50
	end
end)
