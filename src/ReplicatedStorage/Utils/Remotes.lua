-- Services
local RunService       = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Module
local Remotes = {
    _folder = nil,
    _lookup = {},   -- maps folder -> { [name] = Instance }
}

local isServer = RunService:IsServer()

-- Internal: get or create the default Remotes folder
local function getDefaultFolder()
    if Remotes._folder then
        return Remotes._folder
    end

    if isServer then
        Remotes._folder = Instance.new("Folder")
        Remotes._folder.Name   = "Remotes"
        Remotes._folder.Parent = ReplicatedStorage
    else
        Remotes._folder = ReplicatedStorage:WaitForChild("Remotes")
    end

    return Remotes._folder
end

-- Internal: create or return cached remote in the given folder
local function createRemote(instanceType, name, folder)
    local parentFolder = folder or getDefaultFolder()
    -- init lookup table for this folder
    Remotes._lookup[parentFolder] = Remotes._lookup[parentFolder] or {}

    -- return cached if exists
    if Remotes._lookup[parentFolder][name] then
        return Remotes._lookup[parentFolder][name]
    end

    -- otherwise create, cache, return
    local remote = Instance.new(instanceType)
    remote.Name   = name
    remote.Parent = parentFolder

    Remotes._lookup[parentFolder][name] = remote
    return remote
end

if isServer then
    -- SERVER

    --- @param name string
    --- @param folder Instance?  -- optional Folder to parent into
    function Remotes:GetEvent(name, folder)
        return createRemote("RemoteEvent", name, folder)
    end

    --- @param name string
    --- @param folder Instance?  -- optional Folder to parent into
    function Remotes:GetFunction(name, folder)
        return createRemote("RemoteFunction", name .. "Func", folder)
    end

else
    -- CLIENT

    --- @param name string
    --- @param folder Instance?  -- optional Folder to lookup in
    function Remotes:GetEvent(name, folder)
        local parentFolder = folder or getDefaultFolder()
        return parentFolder:FindFirstChild(name)
    end

    --- @param name string
    --- @param folder Instance?  -- optional Folder to lookup in
    function Remotes:GetFunction(name, folder)
        local parentFolder = folder or getDefaultFolder()
        return parentFolder:FindFirstChild(name .. "Func")
    end
end

return Remotes
