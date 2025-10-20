local names = {"T", "Bottom", "F", "B", "L", "R"}

game:GetService("ReplicatedFirst").MetaBlocks.GrassBlock.T.Texture = "rbxassetid://82130822566092"
game:GetService("ReplicatedFirst").MetaBlocks.GrassBlock.Bottom.Texture = "rbxassetid://95972312598754"
game:GetService("ReplicatedFirst").MetaBlocks.GrassBlock.F.Texture = "rbxassetid://95968044461562"
game:GetService("ReplicatedFirst").MetaBlocks.GrassBlock.B.Texture = "rbxassetid://95968044461562"
game:GetService("ReplicatedFirst").MetaBlocks.GrassBlock.L.Texture = "rbxassetid://95968044461562"
game:GetService("ReplicatedFirst").MetaBlocks.GrassBlock.R.Texture = "rbxassetid://95968044461562"

for _, dirt in pairs(game.ReplicatedFirst.MetaBlocks.Dirt:GetChildren()) do
    dirt.Texture = "rbxassetid://95972312598754"
end

game:GetService("ReplicatedFirst").Blocks.OakLog.TextureID = ""

for i = 1, 6 do
  local oakLogTexture = Instance.new("Texture", game:GetService("ReplicatedFirst").Blocks.OakLog)
  oakLogTexture.Name = names[i]
end

game:GetService("ReplicatedFirst").MetaBlocks.OakLog.T.Texture = "rbxassetid://9359130096"
game:GetService("ReplicatedFirst").MetaBlocks.OakLog.Bottom.Texture = "rbxassetid://9359130096"
game:GetService("ReplicatedFirst").MetaBlocks.OakLog.F.Texture = "rbxassetid://9359131807"
game:GetService("ReplicatedFirst").MetaBlocks.OakLog.B.Texture = "rbxassetid://9359131807"
game:GetService("ReplicatedFirst").MetaBlocks.OakLog.L.Texture = "rbxassetid://9359131807"
game:GetService("ReplicatedFirst").MetaBlocks.OakLog.R.Texture = "rbxassetid://9359131807"
