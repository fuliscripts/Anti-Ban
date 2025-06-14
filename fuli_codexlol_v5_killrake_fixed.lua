
loadstring(game:HttpGet("https://raw.githubusercontent.com/fuliscripts/Anti-Ban/refs/heads/main/fuli_codexlol_v5_refresh.lua"))()
-- Aquí va el nuevo Kill Rake corregido
local killRake = {active = false}
addToggle("Kill Rake (Fixed)", killRake,
function()
    killRake.loop = game:GetService("RunService").RenderStepped:Connect(function()
        for _, model in pairs(workspace:GetDescendants()) do
            if model:IsA("Model") and model.Name:lower():find("rake") then
                local humanoid = model:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    humanoid:TakeDamage(9999)
                end
            end
        end
    end)
end,
function()
    if killRake.loop then killRake.loop:Disconnect() end
end)
