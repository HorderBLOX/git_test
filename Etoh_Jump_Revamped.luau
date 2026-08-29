local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local Checkpoints = workspace:FindFirstChild("checkpoints")

if Checkpoints then
    for i = 200, 210 do
        local targetName = tostring(i)
        local targetPart = Checkpoints:FindFirstChild(targetName, true)
        
        if targetPart and targetPart:IsA("BasePart") then
            -- Refresh character data each loop iteration in case of respawns
            local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
            local rootPart = character:WaitForChild("HumanoidRootPart", 5)
            local limb = character:FindFirstChild("LeftFoot") or character:FindFirstChild("Left Leg") or rootPart
            
            if rootPart and limb then
                print("Executing executor touch on part: " .. targetName)
                
                -- 1. Teleport to the checkpoint
                rootPart.CFrame = targetPart.CFrame + Vector3.new(0, 2, 0)
                task.wait(0.1) -- Brief pause to allow the position to register
                
                -- 2. Use executor environment functions to force-fire the touch
                if firetouchinterest then
                    firetouchinterest(targetPart, limb, 0) -- 0 = Touch Begin
                    task.wait(0.05)
                    firetouchinterest(targetPart, limb, 1) -- 1 = Touch End
                end
                
                -- 3. Yield to prevent network traffic overload/kicks
                task.wait(1.5) 
            else
                warn("Character components missing for stage: " .. targetName)
            end
        else
            warn("Checkpoint part not found: " .. targetName)
        end
    end
else
    warn("Checkpoints folder not found.")
end
