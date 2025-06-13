local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Assets = ReplicatedStorage.Assets

local Remotes = require(game.ReplicatedStorage.Source.Utils.Remotes)

local WeaponEquipService = {}

WeaponEquipService.PlayAnimationRemote = Remotes:GetEvent("PlayAnimation")
WeaponEquipService.StopAnimationRemote = Remotes:GetEvent("StopAnimation")
WeaponEquipService.ToggleWeapon = Remotes:GetEvent("ToggleWeapon")

WeaponEquipService.Weapons = {}

function WeaponEquipService:Awake()
end

function WeaponEquipService:Start()
    WeaponEquipService.ToggleWeapon.OnServerEvent:Connect(function(player)
        self:_toggleWeapon(player)
    end)
end

-- function TestService:OnPlayerAdded(player: Player)
--     print("Player joined: "..player.Name)
-- end

function WeaponEquipService:OnPlayerCharacterAdded(player: Player, character: Model)
    print("Player joined: "..player.Name)
    print("Player character join. "..character:GetFullName())
    self:_toggleWeapon(player, "Sheathed")
end

function WeaponEquipService:OnPlayerRemoving(player: Player)
    self:_clearWeapon(player)
end

function WeaponEquipService:OnPlayerCharacterDied(player: Player)
    self:_clearWeapon(player)
end

function WeaponEquipService:_clearWeapon(player: Player)
    if WeaponEquipService.Weapons[player] then
        WeaponEquipService.Weapons[player]:Destroy()
        WeaponEquipService.Weapons[player] = nil
    end
end

function WeaponEquipService:_setupWeapon(player: Player, weaponName: string, weldName: string, characterPartName: string)
    self:_clearWeapon(player)
    
    --
    local character = player.Character
    if not character then
        warn("No character")
        return
    end

    --

    local weaponModelPrefab = Assets.Weapons.Models:FindFirstChild(weaponName)
    local weaponWeldPrefab = Assets.Weapons.Welds:FindFirstChild(weldName)
    
    if not weaponModelPrefab then
        warn("Failed to get weaponModel "..tostring(weaponName))
        return
    end
    if not weaponWeldPrefab then
        warn("Failed to get weaponWeld "..tostring(weldName))
        return
    end

    local weaponModel = weaponModelPrefab:Clone()
    local weaponWeld = weaponWeldPrefab:Clone()
    local characterPart = character:FindFirstChild(characterPartName)

    
    if not characterPart then
        warn("Failed to get characterPart")
        return
    end

    weaponModel.Parent = character
    weaponWeld.Parent = weaponModel
    weaponWeld.Part0 = characterPart
    weaponWeld.Part1 = weaponModel.PrimaryPart

    WeaponEquipService.Weapons[player] = weaponModel
end

function WeaponEquipService:_toggleWeapon(player, setup)
    local character = player.Character
    if not character then
        warn("No character")
        return
    end

    if setup then
        self:_setupWeapon(player, "Lightsaber", "WaistWeld", "UpperTorso")
        character:SetAttribute("Equipped", false)
    elseif character:GetAttribute("Equipped") then
        self.StopAnimationRemote:FireClient(player, "Lightsaber/Idle")
        task.wait()
        self.PlayAnimationRemote:FireClient(player, "Lightsaber/Unequip")
        task.wait(0.25)
        self:_setupWeapon(player, "Lightsaber", "WaistWeld", "UpperTorso")
        character:SetAttribute("Equipped", false)
    else
        self.PlayAnimationRemote:FireClient(player, "Lightsaber/Idle")
        task.wait()
        self.PlayAnimationRemote:FireClient(player, "Lightsaber/Equip")
        task.wait(0.5)
        self:_setupWeapon(player, "Lightsaber", "RightHandWeld", "RightHand")
        character:SetAttribute("Equipped", true)
    end
end

return WeaponEquipService