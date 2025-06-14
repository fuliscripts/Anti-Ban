
-- FULI HUB v5 FIXED + RASTRILLO KILL

-- Aquí va tu GUI original (se asumirá que ya está hecho con botones y toggles)
-- Solo agregaremos el nuevo botón de Kill Rastrillo
local killRastrillo = {active = false}
addToggle("Kill Rastrillo", killRastrillo,
function()
    killRastrillo.loop = game:GetService("RunService").RenderStepped:Connect(function()
        for _, model in pairs(workspace:GetDescendants()) do
            if model:IsA("Model") and model.Name:lower():find("rastrillo") then
                local humanoid = model:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    humanoid:TakeDamage(9999)
                end
            end
        end
    end)
end,
function()
    if killRastrillo.loop then killRastrillo.loop:Disconnect() end
end)
