-- #region Modules
local RextFramework = require(game.ReplicatedStorage.Source.Framework.RextFramework)
-- #endregion

local modulesToLoad = {
	table.unpack(game.Players.LocalPlayer.PlayerScripts.Source.Controllers:GetDescendants())
}

local componentsToLoad = {
	table.unpack(game.Players.LocalPlayer.PlayerScripts.Source.Components:GetDescendants()),
	table.unpack(game.ReplicatedStorage.Source.Components:GetDescendants())
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
