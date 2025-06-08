-- #region Modules
local RextFramework = require(game.ReplicatedStorage.Source.Modules.Framework.RextFramework)
-- #endregion

local modulesToLoad = {
	table.unpack(game.Players.LocalPlayer.PlayerScripts.Source.Modules.Controllers:GetDescendants())
}

local componentsToLoad = {
	table.unpack(game.Players.LocalPlayer.PlayerScripts.Source.Modules:FindFirstChild("Components"):GetDescendants()),
	table.unpack(game.ReplicatedStorage.Source.Modules:FindFirstChild("Components"):GetDescendants())
}

RextFramework:Start(
	modulesToLoad,
	function(moduleFile)  
		return moduleFile.Name:match("Controller$")
	end,
	componentsToLoad,
	nil
)
-- #endregion
