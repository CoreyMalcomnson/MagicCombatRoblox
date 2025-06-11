local Component = require(game.ReplicatedStorage.Source.Packages.Component)

local TestComponent = Component.new({Tag = "Test"})

function TestComponent:Construct()
    print("TestComponent Construct")
end

return TestComponent