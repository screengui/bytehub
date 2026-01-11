if _G.NoFall then
    if game.ReplicatedStorage.GameRemotes.Demo.Parent == game.ReplicatedStorage.GameRemotes then
        game.ReplicatedStorage.GameRemotes.Demo.Parent = game.Workspace
    end
else
    if game.ReplicatedStorage.GameRemotes.Demo.Parent == game.Workspace then
        game.ReplicatedStorage.GameRemotes.Demo.Parent = game.ReplicatedStorage.GameRemotes
    end
end
