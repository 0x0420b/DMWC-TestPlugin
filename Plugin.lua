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

local Route = {}
local Timer = GetTime()

local function TestNavigation()
    if UnitIsVisible("target") then
        local StartX, StartY, StartZ = ObjectPosition("player")
        local EndX, EndY, EndZ = ObjectPosition("target")
        SendHTTPRequest(
            "http://localhost/?startx=" .. StartX .. "&starty=" .. StartY .. "&startz=" .. StartZ .. "&endx=" .. EndX .. "&endy=" .. EndY .. "&endz=" .. EndZ,
            nil,
            function(body, code, req, res, err)
                if code == "200" then
                    wipe(Route)
                    local tempstr
                    for k, v in pairs({strsplit("|", body)}) do
                        if v and v ~= "" then
                            local tempxyz = {}
                            tempstr = {strsplit(",", v)}
                            tempxyz.x, tempxyz.y, tempxyz.z = tonumber(tempstr[1]), tonumber(tempstr[2]), tonumber(tempstr[3])
                            tinsert(Route, tempxyz)
                        end
                    end
                end
            end,
            nil
        )
    end
end

local function MyPlugin()
    if not Initialized then
        Initialize()
    end
    if Active then
        if (GetTime() - Timer) > 0.5 then
            --TestNavigation()
            Timer = GetTime()
        end
        LibDraw.SetColor(102, 210, 202)
        for _, Object in pairs(DMW.GameObjects) do
            if Object.ObjectID then
                LibDraw.Text(Object.Name .. " (" .. Object.ObjectID .. ") - " .. math.floor(Object.Distance) .. " Yards", "GameFontNormalSmall", Object.PosX, Object.PosY, Object.PosZ + 2)
            else
                LibDraw.Text(Object.Name .. " - " .. math.floor(Object.Distance) .. " Yards", "GameFontNormalSmall", Object.PosX, Object.PosY, Object.PosZ + 2)
            end
        end
        for i, v in ipairs(Route) do
            if Route[i + 1] then
                LibDraw.Line(Route[i].x, Route[i].y, Route[i].z, Route[i + 1].x, Route[i + 1].y, Route[i + 1].z)
            end
        end
    end
end

DMW.Plugins.TestPlugin = MyPlugin
