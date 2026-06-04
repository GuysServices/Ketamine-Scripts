local KetamineUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/GuysModz/GuyzModzScheduleITrainer/refs/heads/main/KetamineUI.lua"))()

local Window = KetamineUI:CreateWindow({
    Name = "Murder Duels",
    Subtitle = "v1.0 | Ketamine"
})

local AimTab = Window:CreateTab("Aimbot")
local ESPTab = Window:CreateTab("ESP")
local MiscTab = Window:CreateTab("Misc")

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

----------------------------------------------------------------------
-- Config Setup
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
    combat = {
        hitbox_enabled = false,
        hitbox_size = 10,
        hitbox_transparency = 0.6,
        hitbox_part = "Head",
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
local SETTINGS_FILE = "KetamineMurderDuels.json"

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
            
            combat_hitbox_enabled = config.combat.hitbox_enabled,
            combat_hitbox_size = config.combat.hitbox_size,
            combat_hitbox_transparency = config.combat.hitbox_transparency,
            combat_hitbox_part = config.combat.hitbox_part,

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
        
        if data.combat_hitbox_enabled ~= nil then config.combat.hitbox_enabled = data.combat_hitbox_enabled end
        if data.combat_hitbox_size then config.combat.hitbox_size = data.combat_hitbox_size end
        if data.combat_hitbox_transparency then config.combat.hitbox_transparency = data.combat_hitbox_transparency end
        if data.combat_hitbox_part then config.combat.hitbox_part = data.combat_hitbox_part end

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
        if data.misc_spinbot ~= nil then config.misc.spinbot = data.misc_spinbot end
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
local HighlightInstances = {}
local OriginalSizes = {}
local Flying = false
local FlyBody = nil
local FlyGyro = nil
local spinAngle = 0

----------------------------------------------------------------------
-- Drawing Objects Setup
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
    -- Check workspaces recursively for names just in case
    for _, model in ipairs(Workspace:GetChildren()) do
        if model:IsA("Model") and model.Name == player.Name then
            local hum = model:FindFirstChildOfClass("Humanoid")
            local root = model:FindFirstChild("HumanoidRootPart")
            if hum and root then return model end
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
    local hum = getHumanoid(char)
    if not hum then return false end
    if hum.Health <= 0 then return false end
    if hum:GetState() == Enum.HumanoidStateType.Dead then return false end
    local root = getRoot(char)
    if not root then return false end
    if root.Position.Y < -500 then return false end
    return true
end

local function isEnemy(player)
    if player == LocalPlayer then return false end
    if not isAlive(player) then return false end
    if config.aimbot.team_check then
        if player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then
            return false
        end
    end
    return true
end

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
-- Aimbot Target Finder
----------------------------------------------------------------------
local function getClosestTarget()
    Camera = Workspace.CurrentCamera
    local closest = nil
    local closestDist = math.huge
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, player in ipairs(Players:GetPlayers()) do
        if isEnemy(player) then
            local char = getCharacter(player)
            if char then
                local targetPart = config.aimbot.aim_part == "Head" and getHead(char) or getRoot(char)
                if targetPart then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                    if onScreen then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                        if dist < config.aimbot.fov_range and dist < closestDist then
                            if isVisible(Camera.CFrame.Position, targetPart) then
                                closest = targetPart
                                closestDist = dist
                            end
                        end
                    end
                end
            end
        end
    end
    return closest
end

----------------------------------------------------------------------
-- Custom Hitbox Expander
----------------------------------------------------------------------
local function resetHitboxes()
    for player, data in pairs(OriginalSizes) do
        local char = getCharacter(player)
        if char then
            for partName, original in pairs(data) do
                local part = char:FindFirstChild(partName)
                if part and part:IsA("BasePart") then
                    part.Size = original.Size
                    part.Transparency = original.Transparency
                    part.CanCollide = original.CanCollide
                end
            end
        end
    end
    table.clear(OriginalSizes)
end

local function applyHitboxExpander()
    if not config.combat.hitbox_enabled then
        resetHitboxes()
        return
    end
    for _, player in ipairs(Players:GetPlayers()) do
        if isEnemy(player) then
            local char = getCharacter(player)
            if char then
                local partName = config.combat.hitbox_part
                local part = char:FindFirstChild(partName)
                if part and part:IsA("BasePart") then
                    if not OriginalSizes[player] then
                        OriginalSizes[player] = {}
                    end
                    if not OriginalSizes[player][partName] then
                        OriginalSizes[player][partName] = {
                            Size = part.Size,
                            Transparency = part.Transparency,
                            CanCollide = part.CanCollide
                        }
                    end
                    part.Size = Vector3.new(config.combat.hitbox_size, config.combat.hitbox_size, config.combat.hitbox_size)
                    part.Transparency = config.combat.hitbox_transparency
                    part.CanCollide = false
                end
            end
        end
    end
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
-- Skeleton Structure Definition
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

local function drawESP(esp, player, color)
    local char = getCharacter(player)
    if not char or not char.Parent then
        hideESP(esp)
        return
    end

    local root = getRoot(char)
    local head = getHead(char)
    local hum = getHumanoid(char)

    if not root or not head or not hum or hum.Health <= 0 or hum:GetState() == Enum.HumanoidStateType.Dead then
        hideESP(esp)
        if HighlightInstances[player] then
            pcall(function() HighlightInstances[player]:Destroy() end)
            HighlightInstances[player] = nil
        end
        return
    end

    Camera = Workspace.CurrentCamera
    local rootPos, onScreen = Camera:WorldToViewportPoint(root.Position)
    if not onScreen then
        hideESP(esp)
        return
    end

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
    esp.Name.Text = player.DisplayName
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

    -- Skeleton joints
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

    -- Highlights / Chams
    if config.esp.highlight then
        if not HighlightInstances[player] then
            local hl = Instance.new("Highlight")
            hl.FillColor = color
            hl.FillTransparency = 0.5
            hl.OutlineColor = Color3.new(1, 1, 1)
            hl.OutlineTransparency = 0
            hl.Adornee = char
            hl.Parent = char
            HighlightInstances[player] = hl
        else
            HighlightInstances[player].Adornee = char
        end
    else
        if HighlightInstances[player] then
            pcall(function() HighlightInstances[player]:Destroy() end)
            HighlightInstances[player] = nil
        end
    end
end

----------------------------------------------------------------------
-- ESP Management
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

for _, player in ipairs(Players:GetPlayers()) do
    createESP(player)
end

table.insert(Connections, Players.PlayerAdded:Connect(createESP))
table.insert(Connections, Players.PlayerRemoving:Connect(removeESP))

----------------------------------------------------------------------
-- Inputs handler (Holding aimbot keys)
----------------------------------------------------------------------
table.insert(Connections, UserInputService.InputBegan:Connect(function(input, gpe)
    if config.aimbot.keybind and input.KeyCode == config.aimbot.keybind then
        Holding = true
    end
    if not config.aimbot.keybind and input.UserInputType == Enum.UserInputType.MouseButton2 then
        Holding = true
    end
end))

table.insert(Connections, UserInputService.InputEnded:Connect(function(input)
    if config.aimbot.keybind and input.KeyCode == config.aimbot.keybind then
        Holding = false
    end
    if not config.aimbot.keybind and input.UserInputType == Enum.UserInputType.MouseButton2 then
        Holding = false
    end
end))

----------------------------------------------------------------------
-- Fly / Noclip Actions
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

table.insert(Connections, UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if config.misc.fly and input.KeyCode == Enum.KeyCode.F then
        toggleFly()
    end
end))

----------------------------------------------------------------------
-- Triggerbot Mouse Simulator
----------------------------------------------------------------------
local function runTriggerbot()
    if not config.triggerbot.enabled then return end
    local target = Mouse.Target
    if target and target.Parent then
        local player = Players:GetPlayerFromCharacter(target.Parent)
        if player and isEnemy(player) then
            task.wait(config.triggerbot.delay)
            pcall(function()
                if mouse1click then
                    mouse1click()
                elseif mouse1press and mouse1release then
                    mouse1press()
                    task.wait(0.01)
                    mouse1release()
                end
            end)
        end
    end
end

----------------------------------------------------------------------
-- Anti-AFK Setup
----------------------------------------------------------------------
if config.misc.anti_afk then
    pcall(function()
        local VirtualUser = game:GetService("VirtualUser")
        LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0, 0))
        end)
    end)
end

----------------------------------------------------------------------
-- Main Program Loop
----------------------------------------------------------------------
table.insert(Connections, RunService.RenderStepped:Connect(function()
    Camera = Workspace.CurrentCamera
    local target = getClosestTarget()

    -- 1. Aimbot Logic
    if config.aimbot.enabled and Holding and target then
        local targetPos = Camera:WorldToViewportPoint(target.Position)
        local mousePos = UserInputService:GetMouseLocation()
        local diff = (Vector2.new(targetPos.X, targetPos.Y) - mousePos)
        
        pcall(function()
            if mousemoverel then
                mousemoverel(diff.X / config.aimbot.smoothing, diff.Y / config.aimbot.smoothing)
            else
                local aimCoord = Camera.CFrame.Position + (target.Position - Camera.CFrame.Position).Unit
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, aimCoord)
            end
        end)
    end

    -- 2. FOV Circle Update
    FOVCircle.Position = UserInputService:GetMouseLocation()
    FOVCircle.Radius = config.aimbot.fov_range
    FOVCircle.Visible = config.aimbot.fov_enabled and config.aimbot.enabled

    -- 3. Custom Crosshair Update
    updateCrosshair()

    -- 4. Spinbot Logic
    if config.misc.spinbot then
        local char = getCharacter(LocalPlayer)
        local root = char and getRoot(char)
        if root then
            spinAngle = (spinAngle + config.misc.spin_speed) % 360
            root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(config.misc.spin_speed), 0)
        end
    end

    -- 5. Camera Hacks
    if config.misc.fov_changer then
        Camera.FieldOfView = config.misc.fov_value
    end
    if config.misc.third_person then
        LocalPlayer.CameraMaxZoomDistance = config.misc.tp_distance
        LocalPlayer.CameraMinZoomDistance = config.misc.tp_distance
    else
        LocalPlayer.CameraMaxZoomDistance = 400
        LocalPlayer.CameraMinZoomDistance = 0.5
    end

    -- 6. Speed & Jump Modifier Loop
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

    -- 7. Noclip Action Loop
    if config.misc.noclip and myChar then
        for _, part in ipairs(myChar:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end

    -- 8. Hitbox Expander Action
    applyHitboxExpander()

    -- 9. Triggerbot Action
    runTriggerbot()

    -- 10. Update ESP Elements
    for player, esp in pairs(ESPObjects) do
        drawESP(esp, player, Color3.fromRGB(170, 85, 255))
    end
end))

----------------------------------------------------------------------
-- AIMBOT TAB UI
----------------------------------------------------------------------
AimTab:CreateSection("AIMBOT")

AimTab:CreateToggle({
    Name = "Enable Aimbot",
    Default = config.aimbot.enabled,
    Callback = function(value)
        config.aimbot.enabled = value
        saveConfig()
        KetamineUI:Notify({Title = "Aimbot", Text = value and "Enabled" or "Disabled", Duration = 2})
    end
})

AimTab:CreateSlider({
    Name = "FOV Radius",
    Min = 50,
    Max = 600,
    Default = config.aimbot.fov_range,
    Callback = function(value)
        config.aimbot.fov_range = value
        saveConfig()
    end
})

AimTab:CreateSlider({
    Name = "Smoothing",
    Min = 1,
    Max = 20,
    Default = config.aimbot.smoothing,
    Callback = function(value)
        config.aimbot.smoothing = value
        saveConfig()
    end
})

AimTab:CreateToggle({
    Name = "Show FOV Circle",
    Default = config.aimbot.fov_enabled,
    Callback = function(value)
        config.aimbot.fov_enabled = value
        saveConfig()
    end
})

AimTab:CreateToggle({
    Name = "Visibility Check",
    Default = config.aimbot.visible_check,
    Callback = function(value)
        config.aimbot.visible_check = value
        saveConfig()
    end
})

AimTab:CreateToggle({
    Name = "Team Check",
    Default = config.aimbot.team_check,
    Callback = function(value)
        config.aimbot.team_check = value
        saveConfig()
    end
})

AimTab:CreateDropdown({
    Name = "Aim Part",
    Options = {"Head", "Torso"},
    Default = config.aimbot.aim_part,
    Callback = function(value)
        config.aimbot.aim_part = value
        saveConfig()
    end
})

AimTab:CreateDropdown({
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

AimTab:CreateSection("TRIGGERBOT")

AimTab:CreateToggle({
    Name = "Triggerbot",
    Default = config.triggerbot.enabled,
    Callback = function(value)
        config.triggerbot.enabled = value
        saveConfig()
        KetamineUI:Notify({Title = "Triggerbot", Text = value and "ON" or "OFF", Duration = 2})
    end
})

AimTab:CreateSlider({
    Name = "Trigger Delay (ms)",
    Min = 0,
    Max = 200,
    Default = config.triggerbot.delay * 1000,
    Callback = function(value)
        config.triggerbot.delay = value / 1000
        saveConfig()
    end
})

AimTab:CreateSection("HITBOX EXPANDER")

AimTab:CreateToggle({
    Name = "Enable Hitbox Expander",
    Default = config.combat.hitbox_enabled,
    Callback = function(value)
        config.combat.hitbox_enabled = value
        saveConfig()
        if not value then
            resetHitboxes()
        end
        KetamineUI:Notify({Title = "Hitbox Expander", Text = value and "ON" or "OFF", Duration = 2})
    end
})

AimTab:CreateSlider({
    Name = "Hitbox Size",
    Min = 2,
    Max = 30,
    Default = config.combat.hitbox_size,
    Callback = function(value)
        config.combat.hitbox_size = value
        saveConfig()
    end
})

AimTab:CreateSlider({
    Name = "Hitbox Transparency (0-10)",
    Min = 0,
    Max = 10,
    Default = config.combat.hitbox_transparency * 10,
    Callback = function(value)
        config.combat.hitbox_transparency = value / 10
        saveConfig()
    end
})

AimTab:CreateDropdown({
    Name = "Expand Part",
    Options = {"Head", "HumanoidRootPart"},
    Default = config.combat.hitbox_part,
    Callback = function(value)
        resetHitboxes()
        config.combat.hitbox_part = value
        saveConfig()
    end
})

----------------------------------------------------------------------
-- ESP TAB UI
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
        end
    end
})

----------------------------------------------------------------------
-- MISC TAB UI
----------------------------------------------------------------------
MiscTab:CreateSection("MOVEMENT")

MiscTab:CreateToggle({
    Name = "Enable Speed Hack",
    Default = config.misc.speed_changer,
    Callback = function(value)
        config.misc.speed_changer = value
        saveConfig()
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
    end
})

MiscTab:CreateSection("COMBAT")

MiscTab:CreateToggle({
    Name = "Spinbot",
    Default = config.misc.spinbot,
    Callback = function(value)
        config.misc.spinbot = value
        saveConfig()
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
    Name = "Anti-AFK Enabled",
    Default = config.misc.anti_afk,
    Callback = function(value)
        config.misc.anti_afk = value
        saveConfig()
    end
})

KetamineUI:Notify({Title = "Murder Duels Loaded", Text = "Loaded successfully!", Duration = 3})
