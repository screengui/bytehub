-- For texture setup
local names = {"T", "Bottom", "F", "B", "L", "R"}
local faces = {
	Enum.NormalId.Top,
	Enum.NormalId.Bottom,
	Enum.NormalId.Front,
	Enum.NormalId.Back,
	Enum.NormalId.Left,
	Enum.NormalId.Right
}

-- Define blocks
local log = game:GetService("ReplicatedFirst").Blocks.OakLog
local jlog = game:GetService("ReplicatedFirst").Blocks.JungleLog
local blog = game:GetService("ReplicatedFirst").Blocks.BirchLog
local plank = game:GetService("ReplicatedFirst").Blocks.OakPlanks

-- Clear default textures
game:GetService("ReplicatedFirst").Blocks.OakLog.TextureID = ""
game:GetService("ReplicatedFirst").Blocks.JungleLog.TextureID = ""
game:GetService("ReplicatedFirst").Blocks.BirchLog.TextureID = ""
game:GetService("ReplicatedFirst").Blocks.OakPlanks.TextureID = ""

-- Create Textures
for i = 1, 6 do
	local tex = Instance.new("Texture", log)
	tex.Name = names[i]
	tex.Face = faces[i]
	tex.OffsetStudsU = 1.5
	tex.OffsetStudsV = 1.5
	tex.StudsPerTileU = 3
	tex.StudsPerTileV = 3
end

for i = 1, 6 do
	local tex = Instance.new("Texture", jlog)
	tex.Name = names[i]
	tex.Face = faces[i]
	tex.OffsetStudsU = 1.5
	tex.OffsetStudsV = 1.5
	tex.StudsPerTileU = 3
	tex.StudsPerTileV = 3
end

for i = 1, 6 do
	local tex = Instance.new("Texture", blog)
	tex.Name = names[i]
	tex.Face = faces[i]
	tex.OffsetStudsU = 1.5
	tex.OffsetStudsV = 1.5
	tex.StudsPerTileU = 3
	tex.StudsPerTileV = 3
end

for i = 1, 6 do
	local tex = Instance.new("Texture", plank)
	tex.Name = names[i]
	tex.Face = faces[i]
	tex.OffsetStudsU = 1.5
	tex.OffsetStudsV = 1.5
	tex.StudsPerTileU = 3
	tex.StudsPerTileV = 3
end
--Grass Blocks--
game:GetService("ReplicatedFirst").MetaBlocks.GrassBlock.T.Texture = "rbxassetid://82130822566092"
game:GetService("ReplicatedFirst").MetaBlocks.GrassBlock.Bottom.Texture = "rbxassetid://95972312598754"
game:GetService("ReplicatedFirst").MetaBlocks.GrassBlock.F.Texture = "rbxassetid://95968044461562"
game:GetService("ReplicatedFirst").MetaBlocks.GrassBlock.B.Texture = "rbxassetid://95968044461562"
game:GetService("ReplicatedFirst").MetaBlocks.GrassBlock.L.Texture = "rbxassetid://95968044461562"
game:GetService("ReplicatedFirst").MetaBlocks.GrassBlock.R.Texture = "rbxassetid://95968044461562"

game:GetService("ReplicatedFirst").MetaBlocks.JungleBlock.T.Texture = "rbxassetid://74701054061922"
game:GetService("ReplicatedFirst").MetaBlocks.JungleBlock.Bottom.Texture = "rbxassetid://95972312598754"
game:GetService("ReplicatedFirst").MetaBlocks.JungleBlock.F.Texture = "rbxassetid://107460718741342"
game:GetService("ReplicatedFirst").MetaBlocks.JungleBlock.B.Texture = "rbxassetid://107460718741342"
game:GetService("ReplicatedFirst").MetaBlocks.JungleBlock.L.Texture = "rbxassetid://107460718741342"
game:GetService("ReplicatedFirst").MetaBlocks.JungleBlock.R.Texture = "rbxassetid://107460718741342"

game:GetService("ReplicatedFirst").MetaBlocks.SnowBlock.T.Texture = "rbxassetid://17181784442"
game:GetService("ReplicatedFirst").MetaBlocks.SnowBlock.Bottom.Texture = "rbxassetid://95972312598754"
game:GetService("ReplicatedFirst").MetaBlocks.SnowBlock.F.Texture = "rbxassetid://17181782170"
game:GetService("ReplicatedFirst").MetaBlocks.SnowBlock.B.Texture = "rbxassetid://17181782170"
game:GetService("ReplicatedFirst").MetaBlocks.SnowBlock.L.Texture = "rbxassetid://17181782170"
game:GetService("ReplicatedFirst").MetaBlocks.SnowBlock.R.Texture = "rbxassetid://17181782170"

for _, dirt in pairs(game.ReplicatedFirst.MetaBlocks.Dirt:GetChildren()) do
    dirt.Texture = "rbxassetid://95972312598754"
end

--Logs--
game:GetService("ReplicatedFirst").Blocks.OakLog.T.Texture = "rbxassetid://9359130096"
game:GetService("ReplicatedFirst").Blocks.OakLog.Bottom.Texture = "rbxassetid://9359130096"
game:GetService("ReplicatedFirst").Blocks.OakLog.F.Texture = "rbxassetid://9359131807"
game:GetService("ReplicatedFirst").Blocks.OakLog.B.Texture = "rbxassetid://9359131807"
game:GetService("ReplicatedFirst").Blocks.OakLog.L.Texture = "rbxassetid://9359131807"
game:GetService("ReplicatedFirst").Blocks.OakLog.R.Texture = "rbxassetid://9359131807"

game:GetService("ReplicatedFirst").Blocks.JungleLog.T.Texture = "rbxassetid://17175996147"
game:GetService("ReplicatedFirst").Blocks.JungleLog.Bottom.Texture = "rbxassetid://17175996147"
game:GetService("ReplicatedFirst").Blocks.JungleLog.F.Texture = "rbxassetid://17175994462"
game:GetService("ReplicatedFirst").Blocks.JungleLog.B.Texture = "rbxassetid://17175994462"
game:GetService("ReplicatedFirst").Blocks.JungleLog.L.Texture = "rbxassetid://17175994462"
game:GetService("ReplicatedFirst").Blocks.JungleLog.R.Texture = "rbxassetid://17175994462"

game:GetService("ReplicatedFirst").Blocks.BirchLog.T.Texture = "rbxassetid://17151681352"
game:GetService("ReplicatedFirst").Blocks.BirchLog.Bottom.Texture = "rbxassetid://17151681352"
game:GetService("ReplicatedFirst").Blocks.BirchLog.F.Texture = "rbxassetid://17151684861"
game:GetService("ReplicatedFirst").Blocks.BirchLog.B.Texture = "rbxassetid://17151684861"
game:GetService("ReplicatedFirst").Blocks.BirchLog.L.Texture = "rbxassetid://17151684861"
game:GetService("ReplicatedFirst").Blocks.BirchLog.R.Texture = "rbxassetid://17151684861"
--Leaves--
for _, leaves in pairs(game.ReplicatedFirst.MetaBlocks.Leaves:GetChildren()) do
	leaves.Texture = "rbxassetid://11589055088"
end

for _, jleaves in pairs(game.ReplicatedFirst.MetaBlocks.JungleLeaves:GetChildren()) do
	jleaves.Texture = "rbxassetid://111295347358202"
end

for _, bleaves in pairs(game.ReplicatedFirst.MetaBlocks.BirchLeaves:GetChildren()) do
	bleaves.Texture = "rbxassetid://136504352957570"
end

--Planks--
for _, planks in pairs(plank:GetChildren()) do
	planks.Texture = "rbxassetid://9359126646"
end

--Desert--
for _, sand in pairs(game.ReplicatedFirst.MetaBlocks.Sand:GetChildren()) do
	sand.Texture = "rbxassetid://9277770677"
end

--Underground--
for _, stone in pairs(game.ReplicatedFirst.MetaBlocks.Stone:GetChildren()) do
	ice.Texture = "rbxassetid://17175732807"
end

--Others--
for _, ice in pairs(game.ReplicatedFirst.MetaBlocks.Ice:GetChildren()) do
	ice.Texture = "rbxassetid://75408908999960"
end
