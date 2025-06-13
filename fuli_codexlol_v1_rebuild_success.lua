
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- GUI Setup
local gui = Instance.new("ScreenGui", PlayerGui)
gui.Name = "FULI_HUB_Rebuild"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 300)
frame.Position = UDim2.new(0, 100, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.Active = true
frame.Draggable = true

local layout = Instance.new("UIListLayout", frame)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 5)

local function addToggle(name, state, onEnable, onDisable)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1, -10, 0, 30)
	btn.Position = UDim2.new(0, 5, 0, 0)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 16
	btn.Text = "▶️ " .. name
	state.active = false

	btn.MouseButton1Click:Connect(function()
		state.active = not state.active
		btn.Text = (state.active and "⏹️ " or "▶️ ") .. name
		if state.active then
			onEnable()
		else
			onDisable()
		end
	end)
end

-- RightShift hide
UserInputService.InputBegan:Connect(function(input, gpe)
	if input.KeyCode == Enum.KeyCode.RightShift and not gpe then
		frame.Visible = not frame.Visible
	end
end)


-- Walkspeed 40
local ws40 = {active = false}
addToggle("Walkspeed 40", ws40,
function()
	ws40.loop = RunService.RenderStepped:Connect(function()
		local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if h then h.WalkSpeed = 40 end
	end)
end,
function()
	if ws40.loop then ws40.loop:Disconnect() end
end)

-- Walkspeed 100
local ws100 = {active = false}
addToggle("Walkspeed 100", ws100,
function()
	ws100.loop = RunService.RenderStepped:Connect(function()
		local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if h then h.WalkSpeed = 100 end
	end)
end,
function()
	if ws100.loop then ws100.loop:Disconnect() end
end)

-- Kill Rake
local killRake = {active = false}
addToggle("Kill Rake", killRake,
function()
	killRake.loop = RunService.RenderStepped:Connect(function()
		for _, model in pairs(workspace:GetDescendants()) do
			if model:IsA("Model") and model.Name:lower():find("rake") and model:FindFirstChildOfClass("Humanoid") then
				model:FindFirstChildOfClass("Humanoid"):TakeDamage(9999)
			end
		end
	end)
end,
function()
	if killRake.loop then killRake.loop:Disconnect() end
end)

-- FullBright
local bright = {active = false}
addToggle("FullBright", bright,
function()
	bright.old = game.Lighting.Ambient
	game.Lighting.Ambient = Color3.new(1, 1, 1)
end,
function()
	game.Lighting.Ambient = bright.old or Color3.new(0.5, 0.5, 0.5)
end)

-- StunStick Aura (no crash)
local aura = {active = false}
addToggle("Stun Stick Aura", aura,
function()
	aura.loop = RunService.RenderStepped:Connect(function()
		local char = LocalPlayer.Character
		local stick = char and char:FindFirstChild("StunStick")
		if stick then
			for _, v in pairs(workspace:GetDescendants()) do
				if v:IsA("Model") and v ~= char and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
					firetouchinterest(stick, v:FindFirstChild("HumanoidRootPart"), 0)
					firetouchinterest(stick, v:FindFirstChild("HumanoidRootPart"), 1)
				end
			end
		end
	end)
end,
function()
	if aura.loop then aura.loop:Disconnect() end
end)

-- ESP
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
