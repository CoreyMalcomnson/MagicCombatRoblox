local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Assets = ReplicatedStorage.Assets

local WeaponDirectory = {}

WeaponDirectory.BasicLightsaber = {
    Model = Assets.Weapons.Models.Lightsaber,
    Welds = {
        EquipWeld = Assets.Weapons.Welds.RightHandWeld,
        UnequipWeld = Assets.Weapons.Welds.WaistWeld,
        IdleAnimation = Assets.Animations.Weapons.Lightsaber.Idle,
    },
    Animations = {
        EquipAnimation = Assets.Animations.Weapons.Lightsaber.Equip,
        UnequipAnimation = Assets.Animations.Weapons.Lightsaber.Unequip,
        ComboAnimations = {
            Assets.Animations.Weapons.Lightsaber.Equip,
            Assets.Animations.Weapons.Lightsaber.Unequip,
            Assets.Animations.Weapons.Lightsaber.Equip,
        },
    },
    Attack = {
        BaseDamage = 5,
        ComboDamageMultiplier = {
            1,1.1,1.2
        },
        Cooldown = 0.3,
    },
    Movement = {
        CharacterWalkSpeed = 16, -- -1 for unchanged
        CharacterGravity = 7 -- -1 for unchanged
    }
}

return WeaponDirectory