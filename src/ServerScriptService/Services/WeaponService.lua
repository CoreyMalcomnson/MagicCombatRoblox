
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Assets = ReplicatedStorage.Assets 

local Remote = require(game.ReplicatedStorage.Source.Framework.Remote)

local WeaponEquipService = {}

WeaponEquipService.ToggleWeapon = Remote.new("WeaponEquipService/ToggleWeapon")
WeaponEquipService.Weapons = {}

function WeaponEquipService:Awake()
end

function WeaponEquipService:Start()
    WeaponEquipService.ToggleWeapon:OnServerEvent(function(player)
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
    
    local weaponModel = weaponModelPrefab:Clone()
    local weaponWeld = weaponWeldPrefab:Clone()
    local characterPart = character:FindFirstChild(characterPartName)

    if not weaponModel then
        warn("Failed to get weaponModel")
        return
    end
    if not weaponWeld then
        warn("Failed to get weaponWeld")
        return
    end
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

function WeaponEquipService:_toggleWeapon(player, overrideTo)
    local character = player.Character
    if not character then
        warn("No character")
        return
    end

    if character:GetAttribute("Equipped") or overrideTo == "Sheathed" then
        self:_setupWeapon(player, "Lightsaber", "HiltWeld", "UpperTorso")
        character:SetAttribute("Equipped", false)
    else
        self:_setupWeapon(player, "Lightsaber", "RightHandWeld", "RightHand")
        character:SetAttribute("Equipped", true)
    end
end

return WeaponEquipService