
-- SERVICIOS Y VARIABLES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- GUI BASE
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FuliHub"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 400)
frame.Position = UDim2.new(0, 50, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = ScreenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
title.TextColor3 = Color3.new(1,1,1)
title.Text = "🌀 FULI HUB"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.Parent = frame

local uiList = Instance.new("UIListLayout", frame)
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Padding = UDim.new(0, 5)

local dragging, dragInput, dragStart, startPos
frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)
frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

UserInputService.InputBegan:Connect(function(input, gpe)
	if input.KeyCode == Enum.KeyCode.RightShift and not gpe then
		frame.Visible = not frame.Visible
	end
end)

-- FUNCION ADDTOGGLE
local function addToggle(name, stateRef, onEnable, onDisable)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -10, 0, 30)
	button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	button.TextColor3 = Color3.new(1,1,1)
	button.Text = "⏹️ " .. name
	button.Font = Enum.Font.SourceSans
	button.TextSize = 16
	button.Parent = frame

	button.MouseButton1Click:Connect(function()
		stateRef.active = not stateRef.active
		if stateRef.active then
			button.Text = "▶️ " .. name
			onEnable()
		else
			button.Text = "⏹️ " .. name
			if onDisable then onDisable() end
		end
	end)
end

-- TOGGLES
-- WalkSpeed 40
local ws40State = {active = false}
addToggle("WalkSpeed 40", ws40State,
function()
	spawn(function()
		while ws40State.active do
			local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			if hum then hum.WalkSpeed = 40 end
			wait(0.2)
		end
	end)
end,
function()
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if hum then hum.WalkSpeed = 16 end
end)

-- WalkSpeed 100
local ws100State = {active = false}
addToggle("WalkSpeed 100", ws100State,
function()
	spawn(function()
		while ws100State.active do
			local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			if hum then hum.WalkSpeed = 100 end
			wait(0.2)
		end
	end)
end,
function()
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if hum then hum.WalkSpeed = 16 end
end)

-- Kill Rake
local killRake = {active = false}
addToggle("Kill Rake", killRake,
function()
	killRake.loop = RunService.RenderStepped:Connect(function()
		for _, m in pairs(workspace:GetDescendants()) do
			if m:IsA("Model") and m.Name:lower():find("rake") then
				local h = m:FindFirstChildOfClass("Humanoid")
				if h and h.Health > 0 then
					h:TakeDamage(9999)
				end
			end
		end
	end)
end,
function()
	if killRake.loop then killRake.loop:Disconnect() end
end)

-- Stun Stick Aura (ejemplo básico, puede fallar si requiere raycasting específico)
local stunAura = {active = false}
addToggle("Stun Stick Aura", stunAura,
function()
	stunAura.loop = RunService.RenderStepped:Connect(function()
		local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("StunStick")
		if tool and tool:FindFirstChild("RemoteEvent") then
			tool.RemoteEvent:FireServer()
		end
	end)
end,
function()
	if stunAura.loop then stunAura.loop:Disconnect() end
end)

-- FullBright
local brightState = {active = false}
addToggle("FullBright", brightState,
function()
	Lighting = game:GetService("Lighting")
	Lighting.Ambient = Color3.new(1, 1, 1)
	Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
end,
function()
	Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
	Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
end)

-- ESP Players + Rake
local espState = {active = false}
addToggle("ESP Rake/Players", espState,
function()
	espState.loop = RunService.RenderStepped:Connect(function()
		local myChar = LocalPlayer.Character
		if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
		for _, model in pairs(workspace:GetDescendants()) do
			if model:IsA("Model") and model:FindFirstChild("HumanoidRootPart") and model:FindFirstChildOfClass("Humanoid") then
				local isPlayer = Players:FindFirstChild(model.Name)
				local tag = isPlayer and "👤" or model.Name:lower():find("rake") and "👹 Rake" or nil
				if tag and not model:FindFirstChild("ESPName") then
					local billboard = Instance.new("BillboardGui", model)
					billboard.Name = "ESPName"
					billboard.Size = UDim2.new(0, 200, 0, 50)
					billboard.Adornee = model.HumanoidRootPart
					billboard.AlwaysOnTop = true
					local label = Instance.new("TextLabel", billboard)
					label.Name = "ESPText"
					label.Size = UDim2.new(1, 0, 1, 0)
					label.BackgroundTransparency = 1
					label.TextColor3 = isPlayer and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(255, 0, 0)
					label.TextScaled = true
					label.Text = "..."
				end
				local gui = model:FindFirstChild("ESPName")
				if gui then
					local label = gui:FindFirstChild("ESPText")
					if label and myChar then
						local dist = math.floor((model.HumanoidRootPart.Position - myChar.HumanoidRootPart.Position).Magnitude)
						local hp = math.floor(model:FindFirstChildOfClass("Humanoid").Health)
						label.Text = tag .. " | HP: " .. hp .. " | " .. dist .. "m"
					end
				end
			end
		end
	end)
end,
function()
	if espState.loop then espState.loop:Disconnect() end
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("BillboardGui") and obj.Name == "ESPName" then
			obj:Destroy()
		end
	end
end)
