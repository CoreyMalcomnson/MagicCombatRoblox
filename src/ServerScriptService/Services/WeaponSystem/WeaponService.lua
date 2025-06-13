
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = require(ReplicatedStorage.Source.Utils.Remotes)

local WeaponService = {}

WeaponService.ToggleWeapon = Remotes:GetEvent("ToggleWeapon")
WeaponService.PlayAnimation = Remotes:GetEvent("PlayAnimation")
WeaponService.StopAnimation = Remotes:GetEvent("StopAnimation")

WeaponService.Weapons = {}
WeaponService.IdleAnims = {}

function WeaponService:Awake()
end

function WeaponService:Start()
    WeaponService.ToggleWeapon.OnServerEvent:Connect(function(player)
        self:_toggleWeapon(player)
    end)
end

return WeaponService