-- Services
local RunService = game:GetService("RunService")

-- Modules
local Remotes = {}

Remotes._folder = nil
Remotes._lookup = {}

if RunService:IsServer() then
	
	function getFolder()
		if Remotes._folder then
			return Remotes._folder
		end
		
		Remotes._folder = Instance.new("Folder")
		Remotes._folder.Name = "Remotes"
		Remotes._folder.Parent = game.ReplicatedStorage
		
		return Remotes._folder
	end
	
	function createRemote(instanceType, name)
		if Remotes._lookup[name] then
			return Remotes._lookup[name]
		end
		
		local remote = Instance.new(instanceType)
		remote.Name = name
		remote.Parent = getFolder()
		
		Remotes._lookup[name] = remote
		
		return remote
	end
	
	function Remotes:GetEvent(name)
		return createRemote("RemoteEvent", name)
	end
	
	function Remotes:GetFunction(name)
		return createRemote("RemoteFunction", name)
	end
	
elseif RunService:IsClient() then
	
	function getFolder()
		if Remotes._folder then
			return Remotes._folder
		end
		
		Remotes._folder = game.ReplicatedStorage:WaitForChild("Remotes")
		
		return Remotes._folder
	end	

	function Remotes:GetFunc(name)
		return getFolder():FindFirstChild(name)
	end
	
	function Remotes:GetEvent(name)
		return getFolder():FindFirstChild(name)
	end
	
end



return Remotes