local DMW = DMW
local Initialized = false
local Active = false
local LibDraw = LibStub("LibDraw-1.0")

SLASH_objects1 = "/objects"
SlashCmdList["objects"] = function(msg)
    Active = not Active
end

local function Initialize()
    --Do some stuff here for first run?
    Initialized = true
end

local function MyPlugin()
    if not Initialized then
        Initialize()
    end
    if Active then
        LibDraw.SetColor(102, 210, 202)
        for _, Object in pairs(DMW.GameObjects) do
            LibDraw.Text(Object.Name .. " (" .. Object.ObjectID .. ") - " .. math.floor(Object.Distance) .. " Yards", "GameFontNormalSmall", Object.PosX, Object.PosY, Object.PosZ + 2)
        end
    end
end

DMW.Plugins.TestPlugin = MyPlugin