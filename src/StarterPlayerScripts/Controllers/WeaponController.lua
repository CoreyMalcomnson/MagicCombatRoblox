local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = require(ReplicatedStorage.Source.Utils.Remotes)

local WeaponController = {}

WeaponController.ToggleWeapon = Remotes:GetEvent("ToggleWeapon")

function WeaponController:Start()
    UserInputService.InputBegan:Connect(function(inputObject, processed)
        if processed then return end

        if inputObject.KeyCode == Enum.KeyCode.One then
           WeaponController.ToggleWeapon:FireServer() 
        end
    end)
end

return WeaponController