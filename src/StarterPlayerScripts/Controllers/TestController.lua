local UserInputService = game:GetService("UserInputService")

local Remote = require(game.ReplicatedStorage.Source.Framework.Remote)

local TestController = {}

TestController.ToggleWeapon = Remote.get("WeaponEquipService/ToggleWeapon")

-- function TestController:Awake()
--     print("Hello")
-- end

function TestController:Start()
    UserInputService.InputBegan:Connect(function(inputObject, processed)
        if processed then return end

        if inputObject.KeyCode == Enum.KeyCode.One then
           TestController.ToggleWeapon:FireServer() 
        end
    end)
end

-- function TestController:OnPlayerAdded(player: Player)
--     print("Player joined: "..player.Name)
-- end

-- function TestController:OnPlayerCharacterAdded(player: Player, character: Model)
--     print("Player joined: "..player.Name)
--     print("Player character join. "..character:GetFullName())
-- end

-- function TestController:OnPlayerRemoving(player: Player)
--     print("Player leaving: "..player.Name)
-- end

-- function TestController:OnHeartbeat(deltaTime: number)
--     print("a "..deltaTime)
-- end

-- function TestController:OnStepped(deltaTime: number)
--     print("b "..deltaTime)
-- end

-- function TestController:OnRenderStepped(deltaTime: number)
--     print("c "..deltaTime)
-- end

return TestController