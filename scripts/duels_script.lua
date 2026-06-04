local KetamineUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/GuysModz/GuyzModzScheduleITrainer/refs/heads/main/KetamineUI.lua"))()

local Window = KetamineUI:CreateWindow({
    Name = "DUELS Script",
    Subtitle = "v1.0 | Ketamine"
})

local AimbotTab = Window:CreateTab("Aimbot")
local ESPTab = Window:CreateTab("ESP")
local MiscTab = Window:CreateTab("Misc")

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Teams = game:GetService("Teams")
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

----------------------------------------------------------------------
-- Config
----------------------------------------------------------------------
local config = {
    aimbot = {
        enabled = false,
        fov_enabled = true,
        fov_range = 250,
        smoothing = 2,
        aim_part = "Head",
        keybind = Enum.KeyCode.LeftAlt,
        visible_check = true,
        team_check = false,
    },
    triggerbot = {
        enabled = false,
        delay = 0.02,
    },
    esp = {
        boxes = false,
        names = false,
        tracers = false,
        distance = false,
        skeleton = false,
        healthbar = false,
        highlight = false,
    },
    misc = {
        crosshair = false,
        crosshair_size = 10,
        crosshair_color = Color3.fromRGB(0, 255, 0),
        crosshair_gap = 3,
        spinbot = false,
        spin_speed = 15,
        fly = false,
        fly_speed = 50,
        noclip = false,
        fov_changer = false,
        fov_value = 70,
        third_person = false,
        tp_distance = 8,
        speed_changer = false,
        speed_value = 16,
        jump_changer = false,
        jump_value = 50,
        anti_afk = true,
    },
}

----------------------------------------------------------------------
-- Settings Save/Load
----------------------------------------------------------------------
local HttpService = game:GetService("HttpService")
local SETTINGS_FILE = "KetamineDuels.json"

local function saveConfig()
    pcall(function()
        local data = {
            aimbot_enabled = config.aimbot.enabled,
            aimbot_fov_enabled = config.aimbot.fov_enabled,
            aimbot_fov_range = config.aimbot.fov_range,
            aimbot_smoothing = config.aimbot.smoothing,
            aimbot_aim_part = config.aimbot.aim_part,
            aimbot_keybind = config.aimbot.keybind and config.aimbot.keybind.Name or "MouseButton2",
            aimbot_visible_check = config.aimbot.visible_check,
            aimbot_team_check = config.aimbot.team_check,

            triggerbot_enabled = config.triggerbot.enabled,
            triggerbot_delay = config.triggerbot.delay,

            esp_boxes = config.esp.boxes,
            esp_names = config.esp.names,
            esp_tracers = config.esp.tracers,
            esp_distance = config.esp.distance,
            esp_skeleton = config.esp.skeleton,
            esp_healthbar = config.esp.healthbar,
            esp_highlight = config.esp.highlight,

            misc_crosshair = config.misc.crosshair,
            misc_crosshair_size = config.misc.crosshair_size,
            misc_crosshair_color = {config.misc.crosshair_color.R, config.misc.crosshair_color.G, config.misc.crosshair_color.B},
            misc_crosshair_gap = config.misc.crosshair_gap,
            misc_spinbot = config.misc.spinbot,
            misc_spin_speed = config.misc.spin_speed,
            misc_fly = config.misc.fly,
            misc_fly_speed = config.misc.fly_speed,
            misc_noclip = config.misc.noclip,
            misc_fov_changer = config.misc.fov_changer,
            misc_fov_value = config.misc.fov_value,
            misc_third_person = config.misc.third_person,
            misc_tp_distance = config.misc.tp_distance,
            misc_speed_changer = config.misc.speed_changer,
            misc_speed_value = config.misc.speed_value,
            misc_jump_changer = config.misc.jump_changer,
            misc_jump_value = config.misc.jump_value,
            misc_anti_afk = config.misc.anti_afk,
        }
        writefile(SETTINGS_FILE, HttpService:JSONEncode(data))
    end)
end

pcall(function()
    if isfile(SETTINGS_FILE) then
        local data = HttpService:JSONDecode(readfile(SETTINGS_FILE))
        if data.aimbot_enabled ~= nil then config.aimbot.enabled = data.aimbot_enabled end
        if data.aimbot_fov_enabled ~= nil then config.aimbot.fov_enabled = data.aimbot_fov_enabled end
        if data.aimbot_fov_range then config.aimbot.fov_range = data.aimbot_fov_range end
        if data.aimbot_smoothing then config.aimbot.smoothing = data.aimbot_smoothing end
        if data.aimbot_aim_part then config.aimbot.aim_part = data.aimbot_aim_part end
        if data.aimbot_keybind then
            if data.aimbot_keybind == "MouseButton2" then
                config.aimbot.keybind = nil
            else
                pcall(function() config.aimbot.keybind = Enum.KeyCode[data.aimbot_keybind] end)
            end
        end
        if data.aimbot_visible_check ~= nil then config.aimbot.visible_check = data.aimbot_visible_check end
        if data.aimbot_team_check ~= nil then config.aimbot.team_check = data.aimbot_team_check end

        if data.triggerbot_enabled ~= nil then config.triggerbot.enabled = data.triggerbot_enabled end
        if data.triggerbot_delay then config.triggerbot.delay = data.triggerbot_delay end

        if data.esp_boxes ~= nil then config.esp.boxes = data.esp_boxes end
        if data.esp_names ~= nil then config.esp.names = data.esp_names end
        if data.esp_tracers ~= nil then config.esp.tracers = data.esp_tracers end
        if data.esp_distance ~= nil then config.esp.distance = data.esp_distance end
        if data.esp_skeleton ~= nil then config.esp.skeleton = data.esp_skeleton end
        if data.esp_healthbar ~= nil then config.esp.healthbar = data.esp_healthbar end
        if data.esp_highlight ~= nil then config.esp.highlight = data.esp_highlight end

        if data.misc_crosshair ~= nil then config.misc.crosshair = data.misc_crosshair end
        if data.misc_crosshair_size then config.misc.crosshair_size = data.misc_crosshair_size end
        if data.misc_crosshair_color then
            config.misc.crosshair_color = Color3.new(data.misc_crosshair_color[1], data.misc_crosshair_color[2], data.misc_crosshair_color[3])
        end
        if data.misc_crosshair_gap then config.misc.crosshair_gap = data.misc_crosshair_gap end
        if data.misc_spinbot ~= nil then config.misc.spinbot = data.misc.spinbot end
        if data.misc_spin_speed then config.misc.spin_speed = data.misc_spin_speed end
        if data.misc_fly ~= nil then config.misc.fly = data.misc_fly end
        if data.misc_fly_speed then config.misc.fly_speed = data.misc_fly_speed end
        if data.misc_noclip ~= nil then config.misc.noclip = data.misc_noclip end
        if data.misc_fov_changer ~= nil then config.misc.fov_changer = data.misc_fov_changer end
        if data.misc_fov_value then config.misc.fov_value = data.misc_fov_value end
        if data.misc_third_person ~= nil then config.misc.third_person = data.misc_third_person end
        if data.misc_tp_distance then config.misc.tp_distance = data.misc_tp_distance end
        if data.misc_speed_changer ~= nil then config.misc.speed_changer = data.misc_speed_changer end
        if data.misc_speed_value then config.misc.speed_value = data.misc_speed_value end
        if data.misc_jump_changer ~= nil then config.misc.jump_changer = data.misc_jump_changer end
        if data.misc_jump_value then config.misc.jump_value = data.misc_jump_value end
        if data.misc_anti_afk ~= nil then config.misc.anti_afk = data.misc_anti_afk end
    end
end)

-- State
local Holding = false
local scriptActive = true
local Connections = {}
local ESPObjects = {}
local BotESPObjects = {}
local HighlightInstances = {}
local Flying = false
local FlyBody = nil
local FlyGyro = nil
local spinAngle = 0
local cachedBots = {}
local lastBotScan = 0
local cachedAimTarget = nil

----------------------------------------------------------------------
-- Drawing Objects
----------------------------------------------------------------------
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.fromRGB(170, 85, 255)
FOVCircle.Filled = false
FOVCircle.Transparency = 0.7
FOVCircle.Visible = false

local CrosshairLines = {}
for i = 1, 4 do
    CrosshairLines[i] = Drawing.new("Line")
    CrosshairLines[i].Thickness = 1.5
    CrosshairLines[i].Color = config.misc.crosshair_color
    CrosshairLines[i].Visible = false
end

----------------------------------------------------------------------
-- Character Helpers
----------------------------------------------------------------------
local function getCharacter(player)
    local char = player.Character
    if char and char.Parent then return char end
    for _, model in ipairs(Workspace:GetChildren()) do
        if model:IsA("Model") and model.Name == player.Name then
            local hum = model:FindFirstChildOfClass("Humanoid")
            local root = model:FindFirstChild("HumanoidRootPart")
            if hum and root then return model end
        end
    end
    for _, folder in ipairs(Workspace:GetChildren()) do
        if folder:IsA("Folder") or folder:IsA("Model") then
            for _, model in ipairs(folder:GetChildren()) do
                if model:IsA("Model") and model.Name == player.Name then
                    local hum = model:FindFirstChildOfClass("Humanoid")
                    local root = model:FindFirstChild("HumanoidRootPart")
                    if hum and root then return model end
                end
            end
        end
    end
    return nil
end

local function getHumanoid(char)
    if not char then return nil end
    return char:FindFirstChildOfClass("Humanoid")
end

local function getRoot(char)
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
end

local function getHead(char)
    if not char then return nil end
    return char:FindFirstChild("Head")
end

local function isAlive(player)
    local char = getCharacter(player)
    if not char then return false end
    if not char.Parent then return false end
    local hum = getHumanoid(char)
    if not hum then return false end
    if hum.Health <= 0 then return false end
    if hum:GetState() == Enum.HumanoidStateType.Dead then return false end
    local root = getRoot(char)
    if not root then return false end
    if root.Position.Y < -500 then return false end
    return true
end

----------------------------------------------------------------------
-- Team Check
----------------------------------------------------------------------
local function isSameTeam(player)
    if not config.aimbot.team_check then return false end
    if not player then return false end
    if player == LocalPlayer then return true end
    local myTeam = LocalPlayer.Team
    local theirTeam = player.Team
    if myTeam and theirTeam then
        return myTeam == theirTeam
    end
    return false
end

local function isEnemy(player)
    if player == LocalPlayer then return false end
    if not isAlive(player) then return false end
    if isSameTeam(player) then return false end
    return true
end

----------------------------------------------------------------------
-- Bot Scanner
----------------------------------------------------------------------
local function scanBots()
    local now = tick()
    if now - lastBotScan < 0.5 then return cachedBots end
    lastBotScan = now
    cachedBots = {}

    local playerNames = {}
    for _, p in pairs(Players:GetPlayers()) do
        playerNames[p.Name] = true
    end

    local function tryAdd(model)
        if not model:IsA("Model") then return end
        if playerNames[model.Name] then return end
        -- Filter out map objects, mannequins, target dummies
        local lowerName = string.lower(model.Name)
        if string.find(lowerName, "mannequin") or string.find(lowerName, "dummy") or string.find(lowerName, "target") or string.find(lowerName, "practice") then
            return
        end
        local head = model:FindFirstChild("Head")
        local hum = model:FindFirstChildOfClass("Humanoid")
        if head and head:IsA("BasePart") and hum and hum.Health > 0 then
            if hum:GetState() ~= Enum.HumanoidStateType.Dead then
                local root = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso")
                if root and root.Position.Y > -500 then
                    table.insert(cachedBots, model)
                end
            end
        end
    end

    local function scanRecursive(parent, depth)
        if depth > 5 then return end
        for _, child in pairs(parent:GetChildren()) do
            tryAdd(child)
            if child:IsA("Folder") or child:IsA("Model") or child:IsA("WorldModel") then
                scanRecursive(child, depth + 1)
            end
        end
    end
    scanRecursive(Workspace, 0)

    return cachedBots
end

local function getBotRoot(bot)
    return bot:FindFirstChild("HumanoidRootPart") or bot:FindFirstChild("Torso")
end

local function getBotHead(bot)
    return bot:FindFirstChild("Head")
end

----------------------------------------------------------------------
-- Visibility Check
----------------------------------------------------------------------
local function isVisible(origin, targetPart)
    if not config.aimbot.visible_check then return true end
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    local myChar = getCharacter(LocalPlayer)
    rayParams.FilterDescendantsInstances = myChar and {myChar} or {}
    rayParams.IgnoreWater = true
    local dir = (targetPart.Position - origin)
    local result = Workspace:Raycast(origin, dir, rayParams)
    if not result then return true end
    local hit = result.Instance
    if hit:IsDescendantOf(targetPart.Parent) then return true end
    if hit.Transparency >= 0.5 then return true end
    if not hit.CanCollide then return true end
    local model = hit:FindFirstAncestorOfClass("Model")
    if model and model == targetPart.Parent then return true end
    return false
end

----------------------------------------------------------------------
-- Aimbot Target
----------------------------------------------------------------------
local function getClosestTarget()
    Camera = Workspace.CurrentCamera
    local closest = nil
    local closestDist = math.huge
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    local function checkPart(part)
        if not part then return end
        local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
        if onScreen then
            local dist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
            if config.aimbot.fov_enabled and dist > config.aimbot.fov_range then return end
            if dist < closestDist then
                if isVisible(Camera.CFrame.Position, part) then
                    closest = part
                    closestDist = dist
                end
            end
        end
    end

    for _, player in pairs(Players:GetPlayers()) do
        if isEnemy(player) then
            local char = getCharacter(player)
            if char then
                checkPart(config.aimbot.aim_part == "Head" and getHead(char) or getRoot(char))
            end
        end
    end

    for _, bot in pairs(scanBots()) do
        checkPart(config.aimbot.aim_part == "Head" and getBotHead(bot) or getBotRoot(bot))
    end

    return closest
end


----------------------------------------------------------------------
-- Custom Crosshair
----------------------------------------------------------------------
local function updateCrosshair()
    local cx = Camera.ViewportSize.X / 2
    local cy = Camera.ViewportSize.Y / 2
    local gap = config.misc.crosshair_gap
    local size = config.misc.crosshair_size

    CrosshairLines[1].From = Vector2.new(cx - gap - size, cy)
    CrosshairLines[1].To = Vector2.new(cx - gap, cy)
    CrosshairLines[2].From = Vector2.new(cx + gap, cy)
    CrosshairLines[2].To = Vector2.new(cx + gap + size, cy)
    CrosshairLines[3].From = Vector2.new(cx, cy - gap - size)
    CrosshairLines[3].To = Vector2.new(cx, cy - gap)
    CrosshairLines[4].From = Vector2.new(cx, cy + gap)
    CrosshairLines[4].To = Vector2.new(cx, cy + gap + size)

    for _, line in ipairs(CrosshairLines) do
        line.Color = config.misc.crosshair_color
        line.Visible = config.misc.crosshair
    end
end

----------------------------------------------------------------------
-- Skeleton Bones
----------------------------------------------------------------------
local R6_BONES = {
    {"Head", "Torso"},
    {"Torso", "Left Arm"},
    {"Torso", "Right Arm"},
    {"Torso", "Left Leg"},
    {"Torso", "Right Leg"},
}

local R15_BONES = {
    {"Head", "UpperTorso"},
    {"UpperTorso", "LowerTorso"},
    {"UpperTorso", "LeftUpperArm"},
    {"UpperTorso", "RightUpperArm"},
    {"LeftUpperArm", "LeftLowerArm"},
    {"RightUpperArm", "RightLowerArm"},
    {"LeftLowerArm", "LeftHand"},
    {"RightLowerArm", "RightHand"},
    {"LowerTorso", "LeftUpperLeg"},
    {"LowerTorso", "RightUpperLeg"},
    {"LeftUpperLeg", "LeftLowerLeg"},
    {"RightUpperLeg", "RightLowerLeg"},
    {"LeftLowerLeg", "LeftFoot"},
    {"RightLowerLeg", "RightFoot"},
}

local function getBoneList(char)
    if char:FindFirstChild("UpperTorso") then return R15_BONES end
    return R6_BONES
end

----------------------------------------------------------------------
-- ESP Drawing
----------------------------------------------------------------------
local function makeESPSet(color)
    local box = Drawing.new("Square")
    box.Thickness = 1.5; box.Filled = false; box.Visible = false

    local name = Drawing.new("Text")
    name.Size = 13; name.Font = 2; name.Color = Color3.new(1, 1, 1)
    name.OutlineColor = Color3.new(0, 0, 0); name.Outline = true; name.Center = true; name.Visible = false

    local dist = Drawing.new("Text")
    dist.Size = 12; dist.Font = 2; dist.Color = Color3.new(1, 1, 1)
    dist.OutlineColor = Color3.new(0, 0, 0); dist.Outline = true; dist.Center = true; dist.Visible = false

    local tracer = Drawing.new("Line")
    tracer.Thickness = 1.5; tracer.Visible = false

    local healthBar = Drawing.new("Square")
    healthBar.Thickness = 1; healthBar.Filled = true; healthBar.Visible = false

    local healthBarBg = Drawing.new("Square")
    healthBarBg.Thickness = 1; healthBarBg.Filled = true; healthBarBg.Color = Color3.fromRGB(0, 0, 0); healthBarBg.Visible = false

    local skeleton = {}
    for i = 1, 14 do
        local line = Drawing.new("Line")
        line.Thickness = 1.5; line.Color = color; line.Visible = false
        skeleton[i] = line
    end

    return {
        Box = box, Name = name, Distance = dist, Tracer = tracer,
        HealthBar = healthBar, HealthBarBg = healthBarBg, Skeleton = skeleton
    }
end

local function removeESPSet(esp)
    if not esp then return end
    pcall(function()
        for _, line in ipairs(esp.Skeleton) do line:Remove() end
        esp.Box:Remove(); esp.Name:Remove(); esp.Distance:Remove()
        esp.Tracer:Remove(); esp.HealthBar:Remove(); esp.HealthBarBg:Remove()
    end)
end

local function hideESP(esp)
    esp.Box.Visible = false; esp.Name.Visible = false; esp.Distance.Visible = false
    esp.Tracer.Visible = false; esp.HealthBar.Visible = false; esp.HealthBarBg.Visible = false
    for _, line in ipairs(esp.Skeleton) do line.Visible = false end
end

local function drawESP(esp, char, displayName, color)
    if not char or not char.Parent then
        hideESP(esp)
        return
    end

    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
    local head = char:FindFirstChild("Head")
    local hum = char:FindFirstChildOfClass("Humanoid")

    if not root or not head or not hum or hum.Health <= 0 or hum:GetState() == Enum.HumanoidStateType.Dead then
        hideESP(esp)
        if HighlightInstances[char] then
            pcall(function() HighlightInstances[char]:Destroy() end)
            HighlightInstances[char] = nil
        end
        return
    end

    Camera = Workspace.CurrentCamera
    local rootPos, onScreen = Camera:WorldToViewportPoint(root.Position)
    if not onScreen then hideESP(esp) return end

    local headTop = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.6, 0))
    local feetPos = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
    local height = math.abs(headTop.Y - feetPos.Y)
    local width = height * 0.55

    -- Bounding Box
    esp.Box.Size = Vector2.new(width, height)
    esp.Box.Position = Vector2.new(rootPos.X - width / 2, headTop.Y)
    esp.Box.Color = color
    esp.Box.Visible = config.esp.boxes

    -- Name
    esp.Name.Text = displayName
    esp.Name.Position = Vector2.new(rootPos.X, headTop.Y - 16)
    esp.Name.Visible = config.esp.names

    -- Distance
    local myChar = getCharacter(LocalPlayer)
    local myRoot = myChar and getRoot(myChar)
    if myRoot and config.esp.distance then
        local distVal = math.floor((myRoot.Position - root.Position).Magnitude)
        esp.Distance.Text = "[" .. distVal .. "m]"
        esp.Distance.Position = Vector2.new(rootPos.X, feetPos.Y + 2)
        esp.Distance.Visible = true
    else
        esp.Distance.Visible = false
    end

    -- Health Bar
    if config.esp.healthbar then
        local pct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
        local barH = height
        local barX = rootPos.X - width / 2 - 6
        esp.HealthBarBg.Size = Vector2.new(3, barH)
        esp.HealthBarBg.Position = Vector2.new(barX, headTop.Y)
        esp.HealthBarBg.Visible = true
        esp.HealthBar.Size = Vector2.new(3, barH * pct)
        esp.HealthBar.Position = Vector2.new(barX, headTop.Y + barH * (1 - pct))
        esp.HealthBar.Color = Color3.fromRGB(255 * (1 - pct), 255 * pct, 0)
        esp.HealthBar.Visible = true
    else
        esp.HealthBar.Visible = false
        esp.HealthBarBg.Visible = false
    end

    -- Tracer
    esp.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
    esp.Tracer.To = Vector2.new(rootPos.X, rootPos.Y)
    esp.Tracer.Color = color
    esp.Tracer.Visible = config.esp.tracers

    -- Skeleton
    if config.esp.skeleton then
        local bones = getBoneList(char)
        for i, bone in ipairs(bones) do
            local line = esp.Skeleton[i]
            if line then
                local p1 = char:FindFirstChild(bone[1])
                local p2 = char:FindFirstChild(bone[2])
                if p1 and p2 then
                    local s1, on1 = Camera:WorldToViewportPoint(p1.Position)
                    local s2, on2 = Camera:WorldToViewportPoint(p2.Position)
                    if on1 and on2 then
                        line.From = Vector2.new(s1.X, s1.Y)
                        line.To = Vector2.new(s2.X, s2.Y)
                        line.Color = color
                        line.Visible = true
                    else
                        line.Visible = false
                    end
                else
                    line.Visible = false
                end
            end
        end
        for i = #bones + 1, 14 do
            if esp.Skeleton[i] then esp.Skeleton[i].Visible = false end
        end
    else
        for _, line in ipairs(esp.Skeleton) do line.Visible = false end
    end

    -- Highlight / Chams
    if config.esp.highlight then
        if not HighlightInstances[char] then
            local hl = Instance.new("Highlight")
            hl.FillColor = color
            hl.FillTransparency = 0.5
            hl.OutlineColor = Color3.new(1, 1, 1)
            hl.OutlineTransparency = 0
            hl.Adornee = char
            hl.Parent = char
            HighlightInstances[char] = hl
        else
            HighlightInstances[char].Adornee = char
        end
    else
        if HighlightInstances[char] then
            pcall(function() HighlightInstances[char]:Destroy() end)
            HighlightInstances[char] = nil
        end
    end
end

----------------------------------------------------------------------
-- ESP Wrappers
----------------------------------------------------------------------
local function createESP(player)
    if player == LocalPlayer then return end
    if ESPObjects[player] then return end
    ESPObjects[player] = makeESPSet(Color3.fromRGB(170, 85, 255))
end

local function removeESP(player)
    removeESPSet(ESPObjects[player])
    ESPObjects[player] = nil
    if HighlightInstances[player] then
        pcall(function() HighlightInstances[player]:Destroy() end)
        HighlightInstances[player] = nil
    end
end

local function createBotESP(bot)
    if BotESPObjects[bot] then return end
    BotESPObjects[bot] = makeESPSet(Color3.fromRGB(255, 165, 0))
end

local function removeBotESP(bot)
    removeESPSet(BotESPObjects[bot])
    BotESPObjects[bot] = nil
end

----------------------------------------------------------------------
-- Initialize ESP for existing players
----------------------------------------------------------------------
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then createESP(player) end
end

Connections.PlayerAdded = Players.PlayerAdded:Connect(function(player)
    createESP(player)
end)

Connections.PlayerRemoving = Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

----------------------------------------------------------------------
-- Input
----------------------------------------------------------------------
Connections.InputBegan = UserInputService.InputBegan:Connect(function(input, gpe)
    if config.aimbot.keybind and input.KeyCode == config.aimbot.keybind then
        Holding = true
    end
    if not config.aimbot.keybind and input.UserInputType == Enum.UserInputType.MouseButton2 then
        Holding = true
    end
end)

Connections.InputEnded = UserInputService.InputEnded:Connect(function(input)
    if config.aimbot.keybind and input.KeyCode == config.aimbot.keybind then
        Holding = false
    end
    if not config.aimbot.keybind and input.UserInputType == Enum.UserInputType.MouseButton2 then
        Holding = false
    end
end)

----------------------------------------------------------------------
-- Fly
----------------------------------------------------------------------
local function toggleFly()
    if not config.misc.fly then return end
    Flying = not Flying
    local char = getCharacter(LocalPlayer)
    local root = char and getRoot(char)
    if not root then return end

    if Flying then
        FlyGyro = Instance.new("BodyGyro")
        FlyGyro.P = 9e4
        FlyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        FlyGyro.cframe = root.CFrame
        FlyGyro.Name = "KetamineFlyGyro"
        FlyGyro.Parent = root

        FlyBody = Instance.new("BodyVelocity")
        FlyBody.velocity = Vector3.new(0, 0.1, 0)
        FlyBody.maxForce = Vector3.new(9e9, 9e9, 9e9)
        FlyBody.Name = "KetamineFlyVelocity"
        FlyBody.Parent = root

        task.spawn(function()
            while Flying and config.misc.fly and isAlive(LocalPlayer) do
                local camera = Workspace.CurrentCamera
                local movement = Vector3.new(0, 0, 0)

                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    movement = movement + camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    movement = movement - camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    movement = movement - camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    movement = movement + camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    movement = movement + Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    movement = movement - Vector3.new(0, 1, 0)
                end

                if movement.Magnitude > 0 then
                    FlyBody.velocity = movement.Unit * config.misc.fly_speed
                else
                    FlyBody.velocity = Vector3.new(0, 0, 0)
                end

                FlyGyro.cframe = camera.CFrame
                task.wait()
            end
            pcall(function()
                if FlyGyro then FlyGyro:Destroy() FlyGyro = nil end
                if FlyBody then FlyBody:Destroy() FlyBody = nil end
            end)
            Flying = false
        end)
    else
        pcall(function()
            if FlyGyro then FlyGyro:Destroy() FlyGyro = nil end
            if FlyBody then FlyBody:Destroy() FlyBody = nil end
        end)
    end
end

Connections.FlyToggle = UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if config.misc.fly and input.KeyCode == Enum.KeyCode.F then
        toggleFly()
    end
end)

----------------------------------------------------------------------
-- Triggerbot
----------------------------------------------------------------------
task.spawn(function()
    while scriptActive do
        task.wait(0.02)
        if config.triggerbot.enabled then
            pcall(function()
                local target = Mouse.Target
                if target and target.Parent then
                    local model = target.Parent
                    local p = Players:GetPlayerFromCharacter(model)
                    if not p and model.Parent then
                        p = Players:GetPlayerFromCharacter(model.Parent)
                        if p then model = model.Parent end
                    end
                    if not p and model.Parent and model.Parent.Parent then
                        p = Players:GetPlayerFromCharacter(model.Parent.Parent)
                        if p then model = model.Parent.Parent end
                    end
                    local isBot = false
                    if not p then
                        local check = target.Parent
                        for i = 1, 3 do
                            if not check then break end
                            local hum = check:FindFirstChildOfClass("Humanoid")
                            if hum and hum.Health > 0 then
                                isBot = true
                                break
                            end
                            check = check.Parent
                        end
                    end
                    if (p and isEnemy(p)) or isBot then
                        if mouse1press and mouse1release then
                            mouse1press()
                            task.wait(config.triggerbot.delay)
                            mouse1release()
                        elseif mouse1click then
                            task.wait(config.triggerbot.delay)
                            mouse1click()
                        end
                    end
                end
            end)
        end
    end
end)

----------------------------------------------------------------------
-- Anti AFK
----------------------------------------------------------------------
task.spawn(function()
    while scriptActive do
        task.wait(30)
        if config.misc.anti_afk then
            pcall(function()
                local vim = game:GetService("VirtualInputManager")
                vim:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                task.wait(0.1)
                vim:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
            end)
        end
    end
end)

----------------------------------------------------------------------
-- Main Render Loop
----------------------------------------------------------------------
RunService:BindToRenderStep("DuelsMain", 2147483647, function()
    if not scriptActive then return end
    Camera = Workspace.CurrentCamera
    if not Camera then return end

    -- Aimbot
    if config.aimbot.enabled and Holding then
        local target = cachedAimTarget
        if not target or not target.Parent then
            target = nil
        else
            local hum = target.Parent:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health <= 0 then
                target = nil
            end
        end

        if not target then
            target = getClosestTarget()
        end
        cachedAimTarget = target

        if target and target.Parent then
            local targetPos = Camera:WorldToViewportPoint(target.Position)
            local mousePos = UserInputService:GetMouseLocation()
            local diff = (Vector2.new(targetPos.X, targetPos.Y) - mousePos)

            pcall(function()
                if config.aimbot.smoothing <= 1 then
                    if mousemoverel then
                        mousemoverel(diff.X, diff.Y)
                    else
                        Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, target.Position)
                    end
                else
                    if mousemoverel then
                        mousemoverel(diff.X / config.aimbot.smoothing, diff.Y / config.aimbot.smoothing)
                    else
                        local camPos = Camera.CFrame.Position
                        local desiredCF = CFrame.lookAt(camPos, target.Position, Vector3.new(0, 1, 0))
                        Camera.CFrame = Camera.CFrame:Lerp(desiredCF, 1 / config.aimbot.smoothing)
                    end
                end
            end)
        end
    else
        cachedAimTarget = nil
    end

    -- FOV Circle
    FOVCircle.Position = UserInputService:GetMouseLocation()
    FOVCircle.Radius = config.aimbot.fov_range
    FOVCircle.Visible = config.aimbot.fov_enabled and config.aimbot.enabled

    -- Crosshair
    updateCrosshair()

    -- Spinbot
    if config.misc.spinbot then
        pcall(function()
            local char = getCharacter(LocalPlayer)
            local root = char and getRoot(char)
            if root then
                spinAngle = (spinAngle + config.misc.spin_speed) % 360
                root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(config.misc.spin_speed), 0)
            end
        end)
    end

    -- FOV Changer
    if config.misc.fov_changer then
        Camera.FieldOfView = config.misc.fov_value
    end

    -- Third Person
    if config.misc.third_person then
        LocalPlayer.CameraMaxZoomDistance = config.misc.tp_distance
        LocalPlayer.CameraMinZoomDistance = config.misc.tp_distance
    else
        LocalPlayer.CameraMaxZoomDistance = 400
        LocalPlayer.CameraMinZoomDistance = 0.5
    end

    -- Speed & Jump
    local myChar = getCharacter(LocalPlayer)
    local hum = myChar and getHumanoid(myChar)
    if hum then
        if config.misc.speed_changer then
            hum.WalkSpeed = config.misc.speed_value
        end
        if config.misc.jump_changer then
            hum.JumpPower = config.misc.jump_value
            hum.UseJumpPower = true
        end
    end

    -- Noclip
    if config.misc.noclip and myChar then
        for _, part in ipairs(myChar:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end


    -- Player ESP
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if not ESPObjects[player] then createESP(player) end
            local char = getCharacter(player)
            local espColor = Color3.fromRGB(170, 85, 255)
            if isSameTeam(player) then
                espColor = Color3.fromRGB(50, 255, 50)
            end
            drawESP(ESPObjects[player], char, player.DisplayName, espColor)
        end
    end

    -- Bot ESP
    local botColor = Color3.fromRGB(255, 165, 0)
    for bot, _ in pairs(BotESPObjects) do
        local remove = false
        if not bot or not bot.Parent then
            remove = true
        else
            local botHum = bot:FindFirstChildOfClass("Humanoid")
            if not botHum or botHum.Health <= 0 or botHum:GetState() == Enum.HumanoidStateType.Dead then
                remove = true
            end
        end
        if remove then removeBotESP(bot) end
    end
    local bots = scanBots()
    for _, bot in pairs(bots) do
        if not BotESPObjects[bot] then createBotESP(bot) end
        drawESP(BotESPObjects[bot], bot, bot.Name .. " [BOT]", botColor)
    end
end)

----------------------------------------------------------------------
-- FOV Lock (backup)
----------------------------------------------------------------------
Connections.Heartbeat = RunService.Heartbeat:Connect(function()
    if not scriptActive then return end
    Camera = Workspace.CurrentCamera
    if not Camera then return end
    if config.misc.fov_changer then
        Camera.FieldOfView = config.misc.fov_value
    end
end)

Connections.FOVChanged = Camera:GetPropertyChangedSignal("FieldOfView"):Connect(function()
    if not scriptActive then return end
    if config.misc.fov_changer then
        Camera.FieldOfView = config.misc.fov_value
    end
end)

----------------------------------------------------------------------
-- AIMBOT TAB
----------------------------------------------------------------------
AimbotTab:CreateSection("AIMBOT")

AimbotTab:CreateToggle({
    Name = "Enable Aimbot",
    Default = config.aimbot.enabled,
    Callback = function(value)
        config.aimbot.enabled = value
        saveConfig()
        KetamineUI:Notify({Title = "Aimbot", Text = value and "Enabled" or "Disabled", Duration = 2})
    end
})

AimbotTab:CreateSlider({
    Name = "FOV Radius",
    Min = 50,
    Max = 600,
    Default = config.aimbot.fov_range,
    Callback = function(value)
        config.aimbot.fov_range = value
        saveConfig()
    end
})

AimbotTab:CreateSlider({
    Name = "Smoothing",
    Min = 1,
    Max = 20,
    Default = config.aimbot.smoothing,
    Callback = function(value)
        config.aimbot.smoothing = value
        saveConfig()
    end
})

AimbotTab:CreateToggle({
    Name = "Show FOV Circle",
    Default = config.aimbot.fov_enabled,
    Callback = function(value)
        config.aimbot.fov_enabled = value
        saveConfig()
    end
})

AimbotTab:CreateToggle({
    Name = "Visibility Check",
    Default = config.aimbot.visible_check,
    Callback = function(value)
        config.aimbot.visible_check = value
        saveConfig()
    end
})

AimbotTab:CreateToggle({
    Name = "Team Check",
    Default = config.aimbot.team_check,
    Callback = function(value)
        config.aimbot.team_check = value
        saveConfig()
        KetamineUI:Notify({Title = "Team Check", Text = value and "ON" or "OFF", Duration = 2})
    end
})

AimbotTab:CreateDropdown({
    Name = "Aim Part",
    Options = {"Head", "Torso"},
    Default = config.aimbot.aim_part,
    Callback = function(value)
        config.aimbot.aim_part = value
        saveConfig()
    end
})

AimbotTab:CreateDropdown({
    Name = "Keybind",
    Options = {"LeftAlt", "CapsLock", "LeftControl", "LeftShift", "Q", "E", "F", "X", "C", "MouseButton2"},
    Default = config.aimbot.keybind and config.aimbot.keybind.Name or "LeftAlt",
    Callback = function(value)
        if value == "MouseButton2" then
            config.aimbot.keybind = nil
        else
            config.aimbot.keybind = Enum.KeyCode[value]
        end
        saveConfig()
        KetamineUI:Notify({Title = "Keybind", Text = "Set to " .. value, Duration = 2})
    end
})

AimbotTab:CreateSection("TRIGGERBOT")

AimbotTab:CreateToggle({
    Name = "Triggerbot",
    Default = config.triggerbot.enabled,
    Callback = function(value)
        config.triggerbot.enabled = value
        saveConfig()
        KetamineUI:Notify({Title = "Triggerbot", Text = value and "ON" or "OFF", Duration = 2})
    end
})

AimbotTab:CreateSlider({
    Name = "Trigger Delay (ms)",
    Min = 0,
    Max = 200,
    Default = config.triggerbot.delay * 1000,
    Callback = function(value)
        config.triggerbot.delay = value / 1000
        saveConfig()
    end
})


----------------------------------------------------------------------
-- ESP TAB
----------------------------------------------------------------------
ESPTab:CreateSection("PLAYER ESP")

ESPTab:CreateToggle({
    Name = "Highlight (Chams)",
    Default = config.esp.highlight,
    Callback = function(value)
        config.esp.highlight = value
        saveConfig()
        if not value then
            for k, hl in pairs(HighlightInstances) do
                pcall(function() hl:Destroy() end)
            end
            HighlightInstances = {}
        end
        KetamineUI:Notify({Title = "ESP", Text = "Highlights " .. (value and "ON" or "OFF"), Duration = 2})
    end
})

ESPTab:CreateToggle({
    Name = "Boxes",
    Default = config.esp.boxes,
    Callback = function(value)
        config.esp.boxes = value
        saveConfig()
        if not value then
            for _, esp in pairs(ESPObjects) do esp.Box.Visible = false end
            for _, esp in pairs(BotESPObjects) do esp.Box.Visible = false end
        end
    end
})

ESPTab:CreateToggle({
    Name = "Names",
    Default = config.esp.names,
    Callback = function(value)
        config.esp.names = value
        saveConfig()
        if not value then
            for _, esp in pairs(ESPObjects) do esp.Name.Visible = false end
            for _, esp in pairs(BotESPObjects) do esp.Name.Visible = false end
        end
    end
})

ESPTab:CreateToggle({
    Name = "Distance",
    Default = config.esp.distance,
    Callback = function(value)
        config.esp.distance = value
        saveConfig()
        if not value then
            for _, esp in pairs(ESPObjects) do esp.Distance.Visible = false end
            for _, esp in pairs(BotESPObjects) do esp.Distance.Visible = false end
        end
    end
})

ESPTab:CreateToggle({
    Name = "Health Bars",
    Default = config.esp.healthbar,
    Callback = function(value)
        config.esp.healthbar = value
        saveConfig()
        if not value then
            for _, esp in pairs(ESPObjects) do
                esp.HealthBar.Visible = false
                esp.HealthBarBg.Visible = false
            end
            for _, esp in pairs(BotESPObjects) do
                esp.HealthBar.Visible = false
                esp.HealthBarBg.Visible = false
            end
        end
    end
})

ESPTab:CreateToggle({
    Name = "Tracers",
    Default = config.esp.tracers,
    Callback = function(value)
        config.esp.tracers = value
        saveConfig()
        if not value then
            for _, esp in pairs(ESPObjects) do esp.Tracer.Visible = false end
            for _, esp in pairs(BotESPObjects) do esp.Tracer.Visible = false end
        end
    end
})

ESPTab:CreateToggle({
    Name = "Skeleton",
    Default = config.esp.skeleton,
    Callback = function(value)
        config.esp.skeleton = value
        saveConfig()
        if not value then
            for _, esp in pairs(ESPObjects) do
                for _, line in ipairs(esp.Skeleton) do line.Visible = false end
            end
            for _, esp in pairs(BotESPObjects) do
                for _, line in ipairs(esp.Skeleton) do line.Visible = false end
            end
        end
    end
})

----------------------------------------------------------------------
-- MISC TAB
----------------------------------------------------------------------
MiscTab:CreateSection("MOVEMENT")

MiscTab:CreateToggle({
    Name = "Enable Speed Hack",
    Default = config.misc.speed_changer,
    Callback = function(value)
        config.misc.speed_changer = value
        saveConfig()
        if not value then
            pcall(function()
                local char = getCharacter(LocalPlayer)
                if char then
                    local h = getHumanoid(char)
                    if h then h.WalkSpeed = 16 end
                end
            end)
        end
        KetamineUI:Notify({Title = "Speed", Text = value and "ON" or "OFF", Duration = 2})
    end
})

MiscTab:CreateSlider({
    Name = "Speed Value",
    Min = 16,
    Max = 300,
    Default = config.misc.speed_value,
    Callback = function(value)
        config.misc.speed_value = value
        saveConfig()
    end
})

MiscTab:CreateToggle({
    Name = "Enable Jump Hack",
    Default = config.misc.jump_changer,
    Callback = function(value)
        config.misc.jump_changer = value
        saveConfig()
        if not value then
            pcall(function()
                local char = getCharacter(LocalPlayer)
                if char then
                    local h = getHumanoid(char)
                    if h then h.JumpPower = 50 end
                end
            end)
        end
    end
})

MiscTab:CreateSlider({
    Name = "Jump Value",
    Min = 50,
    Max = 300,
    Default = config.misc.jump_value,
    Callback = function(value)
        config.misc.jump_value = value
        saveConfig()
    end
})

MiscTab:CreateToggle({
    Name = "Fly (Press F)",
    Default = config.misc.fly,
    Callback = function(value)
        config.misc.fly = value
        saveConfig()
        if not value and Flying then
            Flying = false
            pcall(function()
                if FlyBody then FlyBody:Destroy() FlyBody = nil end
                if FlyGyro then FlyGyro:Destroy() FlyGyro = nil end
            end)
        end
        KetamineUI:Notify({Title = "Fly", Text = value and "Press F to fly" or "OFF", Duration = 2})
    end
})

MiscTab:CreateSlider({
    Name = "Fly Speed",
    Min = 10,
    Max = 200,
    Default = config.misc.fly_speed,
    Callback = function(value)
        config.misc.fly_speed = value
        saveConfig()
    end
})

MiscTab:CreateToggle({
    Name = "Noclip",
    Default = config.misc.noclip,
    Callback = function(value)
        config.misc.noclip = value
        saveConfig()
        KetamineUI:Notify({Title = "Noclip", Text = value and "ON" or "OFF", Duration = 2})
    end
})

MiscTab:CreateSection("COMBAT")

MiscTab:CreateToggle({
    Name = "Spinbot",
    Default = config.misc.spinbot,
    Callback = function(value)
        config.misc.spinbot = value
        saveConfig()
        KetamineUI:Notify({Title = "Spinbot", Text = value and "ON" or "OFF", Duration = 2})
    end
})

MiscTab:CreateSlider({
    Name = "Spin Speed",
    Min = 5,
    Max = 60,
    Default = config.misc.spin_speed,
    Callback = function(value)
        config.misc.spin_speed = value
        saveConfig()
    end
})

MiscTab:CreateSection("CAMERA / UTILITIES")

MiscTab:CreateToggle({
    Name = "Custom Crosshair",
    Default = config.misc.crosshair,
    Callback = function(value)
        config.misc.crosshair = value
        saveConfig()
        if not value then
            for _, line in ipairs(CrosshairLines) do line.Visible = false end
        end
    end
})

MiscTab:CreateSlider({
    Name = "Crosshair Size",
    Min = 4,
    Max = 30,
    Default = config.misc.crosshair_size,
    Callback = function(value)
        config.misc.crosshair_size = value
        saveConfig()
    end
})

MiscTab:CreateSlider({
    Name = "Crosshair Gap",
    Min = 0,
    Max = 15,
    Default = config.misc.crosshair_gap,
    Callback = function(value)
        config.misc.crosshair_gap = value
        saveConfig()
    end
})

MiscTab:CreateToggle({
    Name = "FOV Changer",
    Default = config.misc.fov_changer,
    Callback = function(value)
        config.misc.fov_changer = value
        saveConfig()
        if not value then
            pcall(function() Camera.FieldOfView = 70 end)
        end
        KetamineUI:Notify({Title = "FOV Changer", Text = value and "ON" or "OFF", Duration = 2})
    end
})

MiscTab:CreateSlider({
    Name = "Camera FOV",
    Min = 40,
    Max = 130,
    Default = config.misc.fov_value,
    Callback = function(value)
        config.misc.fov_value = value
        saveConfig()
    end
})

MiscTab:CreateToggle({
    Name = "Third Person",
    Default = config.misc.third_person,
    Callback = function(value)
        config.misc.third_person = value
        saveConfig()
        if not value then
            LocalPlayer.CameraMaxZoomDistance = 400
            LocalPlayer.CameraMinZoomDistance = 0.5
        end
    end
})

MiscTab:CreateSlider({
    Name = "Third Person Distance",
    Min = 4,
    Max = 30,
    Default = config.misc.tp_distance,
    Callback = function(value)
        config.misc.tp_distance = value
        saveConfig()
    end
})

MiscTab:CreateToggle({
    Name = "Anti-AFK",
    Default = config.misc.anti_afk,
    Callback = function(value)
        config.misc.anti_afk = value
        saveConfig()
        KetamineUI:Notify({Title = "Anti-AFK", Text = value and "ON" or "OFF", Duration = 2})
    end
})

MiscTab:CreateSection("SCRIPT")

MiscTab:CreateButton({
    Name = "Destroy Script",
    Callback = function()
        scriptActive = false
        for _, conn in pairs(Connections) do
            if typeof(conn) == "RBXScriptConnection" and conn.Connected then
                conn:Disconnect()
            end
        end
        for p, _ in pairs(ESPObjects) do removeESP(p) end
        for b, _ in pairs(BotESPObjects) do removeBotESP(b) end
        for k, hl in pairs(HighlightInstances) do
            pcall(function() hl:Destroy() end)
        end
        FOVCircle:Remove()
        for _, line in ipairs(CrosshairLines) do line:Remove() end
        pcall(function() RunService:UnbindFromRenderStep("DuelsMain") end)
        pcall(function()
            if FlyBody then FlyBody:Destroy() end
            if FlyGyro then FlyGyro:Destroy() end
        end)
        if Watermark then Watermark:Remove() end
        pcall(function()
            local char = getCharacter(LocalPlayer)
            if char then
                local h = getHumanoid(char)
                if h then
                    h.WalkSpeed = 16
                    h.JumpPower = 50
                end
            end
        end)
        LocalPlayer.CameraMaxZoomDistance = 400
        LocalPlayer.CameraMinZoomDistance = 0.5
        pcall(function() Camera.FieldOfView = 70 end)
        KetamineUI:Destroy()
    end
})

----------------------------------------------------------------------
-- Done
----------------------------------------------------------------------
KetamineUI:Notify({Title = "DUELS", Text = "Loaded! Hold Left Alt for aimbot.", Duration = 4})
print("[DUELS] Script loaded. Aimbot + ESP + Triggerbot + Fly ready.")

local Watermark = Drawing.new("Text")
Watermark.Size = 20
Watermark.Font = 2
Watermark.Color = Color3.fromRGB(170, 85, 255)
Watermark.OutlineColor = Color3.fromRGB(0, 0, 0)
Watermark.Outline = true
Watermark.Position = Vector2.new(10, 10)
Watermark.Text = "Ketamine | DUELS"
Watermark.Visible = true
