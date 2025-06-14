
-- FULI HUB - Detector GUI para identificar al nuevo Rake o NPCs con vida

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- Crear GUI
local gui = Instance.new("ScreenGui")
gui.Name = "FuliDetector"
gui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 300)
frame.Position = UDim2.new(0, 20, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0

local layout = Instance.new("UIListLayout", frame)
layout.Padding = UDim.new(0, 4)

-- Función para añadir texto
local function addLabel(text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 20)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = text
    label.Parent = frame
end

-- Detectar posibles enemigos con vida
for _, m in pairs(Workspace:GetDescendants()) do
    if m:IsA("Model") and (m:FindFirstChildOfClass("Humanoid") or m:FindFirstChild("Health") or m:FindFirstChild("Stats")) then
        addLabel("🔍 Posible: " .. m.Name)
    end
end
