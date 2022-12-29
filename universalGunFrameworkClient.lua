local userInputService = game:GetService("UserInputService")

local function reload(currentAmmo, requestedAmmo)
    if requestedAmmo < 1000 then
        -- overwrite ammo
    end
end

local function input(input, processed)
    if input.KeyCode == Enum.KeyCode.R then
        reload(0, 20)
    end
end

userInputService.InputBegan:Connect(input)