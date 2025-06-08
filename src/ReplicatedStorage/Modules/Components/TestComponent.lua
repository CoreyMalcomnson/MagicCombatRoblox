local Component = require(game.ReplicatedStorage.Source.Modules.Packages.Component)

local TestComponent = Component.new({Tag = "Test"})

function TestComponent:Construct()
    print("TestComponent Construct")
end

return TestComponent