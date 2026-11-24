local meteorlib = "https://raw.githubusercontent.com/screengui/bytehub/refs/heads/main/Byte%20Hub/assets/ui/meteor-library.lua"

if not shared.GuiLibrary then
    loadstring(game:HttpGet(meteorlib, true))()
end

local GuiLibrary = shared.GuiLibrary
assert(GuiLibrary, "Meteor UI Library failed to load")

GuiLibrary:CreateWindow("Main")
GuiLibrary:CreateWindow("Combat")
GuiLibrary:CreateWindow("Movement")
GuiLibrary:CreateWindow("Player")
GuiLibrary:CreateWindow("Render")
GuiLibrary:CreateWindow("Extra")

GuiLibrary.Windows.Combat:SetVisible(false)
GuiLibrary.Windows.Movement:SetVisible(false)
GuiLibrary.Windows.Player:SetVisible(false)
GuiLibrary.Windows.Render:SetVisible(false)
GuiLibrary.Windows.Extra:SetVisible(false)

local function categoryToggle(windowName)
    return GuiLibrary.Windows.Main:CreateModule({
        Name = windowName,
        Description = "Shows the " .. windowName .. " window.",
        Array = false,
        SkipSearch = true,
        Function = function(state)
            local window = GuiLibrary.Windows[windowName]
            if window then
                window:SetVisible(state)
            end
        end
    })
end

categoryToggle("Combat")
categoryToggle("Movement")
categoryToggle("Player")
categoryToggle("Render")
categoryToggle("Extra")

local KillAura = GuiLibrary.Windows.Combat:CreateModule({
    Name = "KillAura",
    Description = "Attacks entities around you.",
    Function = function(state)

    end
})
