local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "GalllaxyHub",
    Icon = "eclipse", -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
    LoadingTitle = "GalllaxyHub loads...",
    LoadingSubtitle = "by Galllaxy",
    Theme = "Dark Blue", -- Check https://docs.sirius.menu/rayfield/configuration/themes    --Serenity Bad, Bloom Bad, 
    
    DisableRayfieldPrompts = true,
    DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

    ConfigurationSaving = {
    Enabled = true,
    FolderName = "Ghoul://Re", -- Create a custom folder for your hub/game
    FileName = "Ghoul://Re"
    },

    Discord = {
    Enabled = true, -- Prompt the user to join your Discord server if their executor supports it
    Invite = "https://discord.gg/vSf9hSJG", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
    RememberJoins = true -- Set this to false to make them join the discord every time they load it up
    },
    
    KeySystem = true, -- Set this to true to use our key system
    KeySettings = {
    Title = "GalllaxyHub",
    Subtitle = "Key System",
    Note = "Go to discord to obtain your key", -- Use this to tell the user how to get a key
    FileName = "KeyGalllaxy", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
    SaveKey = false, -- The user's key will be saved, but if you change the key, they will be unable to use your script
    GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
    Key = {"Galllaxy", "Dev", "dev", "test"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
}
}) 


Players = cloneref(game:GetService("Players"))
local tweenInf = TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
TweenService = cloneref(game:GetService("TweenService"))
RunService = cloneref(game:GetService("RunService"))
ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
CmdrClient = require(ReplicatedStorage:WaitForChild("CmdrClient"))
CmdrLocal = require(Players.LocalPlayer:WaitForChild("CmdrSetup"))


function execCmd(cmdStr,speaker,store)
    cmdStr = cmdStr:gsub("%s+$","")
    task.spawn(function()
        local rawCmdStr = cmdStr
        cmdStr = string.gsub(cmdStr,"\\\\","%%BackSlash%%")
        local commandsToRun = splitString(cmdStr,"\\")
        for i,v in pairs(commandsToRun) do
            v = string.gsub(v,"%%BackSlash%%","\\")
            local x,y,num = v:find("^(%d+)%^")
            local cmdDelay = 0
            local infTimes = false
            if num then
                v = v:sub(y+1)
                local x,y,del = v:find("^([%d%.]+)%^")
                if del then
                    v = v:sub(y+1)
                    cmdDelay = tonumber(del) or 0
                end
            else
                local x,y = v:find("^inf%^")
                if x then
                    infTimes = true
                    v = v:sub(y+1)
                    local x,y,del = v:find("^([%d%.]+)%^")
                    if del then
                        v = v:sub(y+1)
                        del = tonumber(del) or 1
                        cmdDelay = (del > 0 and del or 1)
                    else
                        cmdDelay = 1
                    end
                end
            end
            num = tonumber(num or 1)

            if v:sub(1,1) == "!" then
                local chunks = splitString(v:sub(2),split)
                if chunks[1] and lastCmds[chunks[1]] then v = lastCmds[chunks[1]] end
            end

            local args = splitString(v,split)
            local cmdName = args[1]
            local cmd = findCmd(cmdName)
            if cmd then
                table.remove(args,1)
                cargs = args
                if not speaker then speaker = Players.LocalPlayer end
                if store then
                    if speaker == Players.LocalPlayer then
                        if cmdHistory[1] ~= rawCmdStr and rawCmdStr:sub(1,11) ~= 'lastcommand' and rawCmdStr:sub(1,7) ~= 'lastcmd' then
                            table.insert(cmdHistory,1,rawCmdStr)
                        end
                    end
                    if #cmdHistory > 30 then table.remove(cmdHistory) end

                    lastCmds[cmdName] = v
                end
                local cmdStartTime = tick()
                if infTimes then
                    while lastBreakTime < cmdStartTime do
                        local success,err = pcall(cmd.FUNC,args, speaker)
                        if not success and _G.IY_DEBUG then
                            warn("Command Error:", cmdName, err)
                        end
                        wait(cmdDelay)
                    end
                else
                    for rep = 1,num do
                        if lastBreakTime > cmdStartTime then break end
                        local success,err = pcall(function()
                            cmd.FUNC(args, speaker)
                        end)
                        if not success and _G.IY_DEBUG then
                            warn("Command Error:", cmdName, err)
                        end
                        if cmdDelay ~= 0 then wait(cmdDelay) end
                    end
                end
            end
        end
    end)
end	


local PlayerTab = Window:CreateTab("Player", "sigma") -- Players TAB
local ESPTab = Window:CreateTab("ESP", "eye") -- ESP TAB
local Section = PlayerTab:CreateSection("Basic Settings")
Section:Set("Valuable Settings")
local ToggleWalkspeed = PlayerTab:CreateToggle({
    Name = "Toggle Walkspeed",
    CurrentValue = false,
    Flag = "WalkSpeed", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        if Value then
            ChangeWalkspeed(_G.WalkSpeedSlider.CurrentValue) -- Берём значение даже если слайдер не трогали
        else
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end 
    end,
})
local SliderWalk = PlayerTab:CreateSlider({
    Name = "Walkspeed",
    Range = {0, 500},
    Increment = 10,
    Suffix = "WalkspeedSL",
    CurrentValue = 16,
    Flag = "Slider1",
    Callback = function(Value)
        ChangeWalkspeed(Value)
    end,
})

_G.WalkSpeedSlider = SliderWalk -- Глобавльная переменная

local ToggleJumppower = PlayerTab:CreateToggle({
    Name = "Toggle JumpPower",
    CurrentValue = false,
    Flag = "JumpPower", 
    Callback = function(Value)
        if Value then
            ChangeJumppower(_G.JumpPowerSlider.CurrentValue)
        else
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50	
        end
    end,
})
local SliderJump = PlayerTab:CreateSlider({
    Name = "JumpPower",
    Range = {0, 500},
    Increment = 10,
    Suffix = "Jump Power",
    CurrentValue = 50,
    Flag = "JumpPowerSL",
    Callback = function(Value)
        ChangeJumppower(Value)
    end,
})

_G.JumpPowerSlider = SliderJump

local FovSlider = PlayerTab:CreateSlider({
    Name = "FOV",
    Range = {70, 120},
    Increment = 1,
    Suffix = "FOV",
    CurrentValue = 70,
    Flag = "FovSlider",
    Callback = function(Value)
        local camera = game.Workspace.CurrentCamera
        camera.FieldOfView = Value
    end,
})

local CFrameFlyToggle = PlayerTab:CreateToggle({
    Name = "CFrame Fly",
    CurrentValue = false,
    Flag = "CFrameFly",
    Callback = function(Value)
        if Value then
            CFrameFly({game.Players.LocalPlayer.Name}, game.Players.LocalPlayer)
        elseif not Value then
            unCFrameFly({game.Players.LocalPlayer.Name}, game.Players.LocalPlayer)
        end
    end,
})

local CFrameFlySlider = PlayerTab:CreateSlider({
    Name = "CFrame Fly Speed",
    Range = {0, 200},
    Increment = 1,
    Suffix = "CFrameFlySpeed",
    CurrentValue = 50,
    Flag = "CFrameFlySpeed",
    Callback = function(Value)
        CFspeed = Value
    end,
})

CFspeed = 50

function CFrameFly(args, speaker)
speaker.Character:FindFirstChildOfClass('Humanoid').PlatformStand = true
    local Head = speaker.Character:WaitForChild("Head")
    Head.Anchored = true
    if CFloop then CFloop:Disconnect() end
    CFloop = RunService.Heartbeat:Connect(function(deltaTime)
        local moveDirection = speaker.Character:FindFirstChildOfClass('Humanoid').MoveDirection * (CFspeed * deltaTime)
        local headCFrame = Head.CFrame
        local cameraCFrame = workspace.CurrentCamera.CFrame
        local cameraOffset = headCFrame:ToObjectSpace(cameraCFrame).Position
        cameraCFrame = cameraCFrame * CFrame.new(-cameraOffset.X, -cameraOffset.Y, -cameraOffset.Z + 1)
        local cameraPosition = cameraCFrame.Position
        local headPosition = headCFrame.Position

        local objectSpaceVelocity = CFrame.new(cameraPosition, Vector3.new(headPosition.X, cameraPosition.Y, headPosition.Z)):VectorToObjectSpace(moveDirection)
        Head.CFrame = CFrame.new(headPosition) * (cameraCFrame - cameraPosition) * CFrame.new(objectSpaceVelocity)
    end)
end

function unCFrameFly(args, speaker)
    if CFloop then
        CFloop:Disconnect()
        speaker.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
        local Head = speaker.Character:WaitForChild("Head")
        Head.Anchored = false
    end
end

function ChangeWalkspeed(Value)
    local humanoid = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid and ToggleWalkspeed.CurrentValue then
        humanoid.WalkSpeed = Value
    end
end

function ChangeJumppower(Value)
    local humanoid = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid and ToggleJumppower.CurrentValue then
        humanoid.UseJumpPower = true
        humanoid.JumpPower = Value
    end
end

local CheckKakujaBtn = PlayerTab:CreateButton({
    Name = "Check Kakuja",
    Callback = function()
        player = game.Players.LocalPlayer
        local check = player:GetAttribute("KakujaUnlocked")
        Rayfield:Notify({
            Title = "Kakuja Status",
            Content = "Your current kakuja status: " .. tostring(check),
            Duration = 5,
            Image = "shield-plus",
        })
    end,
})

local UnlockKakujaBtn = PlayerTab:CreateButton({
    Name = "Unlock Kakuja",
    Callback = function()
        player = game.Players.LocalPlayer
        local check = player:GetAttribute("KakujaUnlocked")
        player:SetAttribute("KakujaUnlocked", true)
        Rayfield:Notify({
            Title = "Kakuja Status",
            Content = "Your current kakuja status: " .. tostring(check),
            Duration = 5,
            Image = "shield-plus",
        })
    end,
})

local UnloadScriptButton = PlayerTab:CreateButton({
    Name = "Unload Script",
    Callback = function()
        Rayfield:Destroy()
    end,
})

local ESPToggle = ESPTab:CreateToggle({
    Name = "ESP Toggle",
    CurrentValue = false,
    Flag = "EspToggle",
    Callback = function()
        --ESP Func
    end
})

local X = 1
local Y = 2
local Z = 3
local tpargs = {
    [X] = -561,
    [Y] = 5,
    [Z] = -3489,
}

tweenSpeed = 30

tagetSpeed = 50


local FarmTab = Window:CreateTab("Farm", "chevrons-up")
local FarmSection = FarmTab:CreateSection("Farm Settings")
local TpButton = FarmTab:CreateButton({
    Name = "Teleport to Farm Place",
    Callback = function()
        TpToFarm(tpargs, game.Players.LocalPlayer)
    end,
})

local TpInput = FarmTab:CreateInput({
    Name = "Tween Position",
    CurrentValue = "-561, 5, -3489",
    PlaceholderText = "X Y Z",
    RemoveTextAfterFocusLost = false,
    Flag = "TpInput",
    Callback = function(Text)
        local pos = string.split(Text, ",")
        if #pos == 3 then
            tpargs[X] = tonumber(pos[1])
            tpargs[Y] = tonumber(pos[2])
            tpargs[Z] = tonumber(pos[3])
        end
    end,
})

local TpSpeedInput = FarmTab:CreateInput({
    Name = "Tween Speed",
    CurrentValue = "1",
    PlaceholderText = "Tween Speed",
    RemoveTextAfterFocusLost = false,
    Flag = "TpSpeedInput",
    Callback = function(Text)
        local speed = tonumber(Text)
        if speed then
            targetSpeed = speed
        end
    end,
})

function TpToFarm(args, speaker)
    if #args < 3 then return end
    local tpX,tpY,tpZ = tonumber((tostring(args[X]):gsub(",", ""))),tonumber((tostring(args[Y]):gsub(",", ""))),tonumber((tostring(args[Z]):gsub(",", "")))
    local char = speaker.Character
    if char and getRoot(char) then
        local currentPos = getRoot(char).Position
        local targetPos = Vector3.new(tpX,tpY,tpZ)

        local distance = (targetPos - currentPos).Magnitude
        local tweenSpeed = math.clamp(distance / tagetSpeed, 5, 100) -- Clamp the tween speed to a reasonable range
        TweenService:Create(getRoot(speaker.Character), TweenInfo.new(tweenSpeed, Enum.EasingStyle.Linear), {CFrame = CFrame.new(tpX,tpY,tpZ)}):Play()
    end
end


local KeybindTab = Window:CreateTab("Keybinds", "command")
local Keybind1 = KeybindTab:CreateKeybind({
    Name = "Walkspeed",
    CurrentKeybind = "Q",
    HoldToInteract = false,
    Flag = "Keybind1",
    Callback = function(Keybind)
        if Keybind then
            _G.ToggleWalkspeed.CurrentValue = true
        elseif not Keybind then
            _G.ToggleWalkspeed.CurrentValue = false
        end
    end,
})


local DevTab = Window:CreateTab("DevTools", "app-window-mac")
local CopyPositionBtn = DevTab:CreateButton({
    Name = "Copy Position",
    Callback = function()
        CopyPosition("me", game.Players.LocalPlayer)
    end,
})

local CurrentXYZButton = DevTab:CreateButton({
    Name = "Print Current XYZ",
    Callback = function()

        Rayfield:Notify({
            Title = "Current Position",
            Content = "" .. PrintPosLol("me", game.Players.LocalPlayer),
            Duration = 5,
            Image = "box",
        })
    end,
})

local ShowDevConsoleBtn = DevTab:CreateButton({
    Name = "Show Dev Console",
    Callback = function()
        local player = game.Players.LocalPlayer
        local commandsFolder = ReplicatedStorage.CmdrClient:WaitForChild("Commands")
        --CmdrLocal.
        --CmdrClient.Registry:RegisterCommandsIn(commandsFolder)

        --CmdrClient:echo("Hacked ily")
        CmdrClient:SetActivationKeys({ Enum.KeyCode.F2 })
        CmdrClient:SetEnabled(true)
        CmdrClient:Toggle()
    end,
})

local SetCreatorIdBtn = DevTab:CreateButton({
    Name = "Set Creator ID",
    Callback = function()
        SetCreatorID("me", game.Players.LocalPlayer)
    end,
})

function SetCreatorID(args, speaker)
    if game.CreatorType == Enum.CreatorType.User then
        speaker.UserId = game.CreatorId
        Rayfield:Notify({
            Title = "Set ID",
            Content = "Set UserId to " .. game.CreatorId,
            Duration = 5,
            Image = "user-check",
        })
    elseif game.CreatorType == Enum.CreatorType.Group then
        local OwnerID = GroupService:GetGroupInfoAsync(game.CreatorId).Owner.Id
        speaker.UserId = OwnerID
        Rayfield:Notify({
            Title = "Set ID",
            Content = "Set UserId to " .. OwnerID,
            Duration = 5,
            Image = "user-check",
        })
    end
end

function CopyPosition(args, speaker)
    local players = getPlayer(args[1], speaker)
    for i,v in pairs(players) do
        local char = Players[v].Character
        --local char = game.Players.LocalPlayer.Character
        local pos = char and (getRoot(char) or char:FindFirstChildWhichIsA("BasePart"))
        pos = pos and pos.Position
        if not pos then
            Rayfield:Notify({
                Title = "Error!",
                Content = "An error occured while trying to copy position: Missing character",
                Duration = 2,
                Image = "circle-x",
            })
        end
        --pos = nil ???
        local roundedPos = math.round(pos.X) .. ", " .. math.round(pos.Y) .. ", " .. math.round(pos.Z)
        toClipboard(roundedPos)       
    end
end

function PrintPosLol(args, speaker)
    local players = getPlayer(args[1], speaker)
    for i,v in pairs(players) do
        local char = Players[v].Character
        --local char = game.Players.LocalPlayer.Character
        local pos = char and (getRoot(char) or char:FindFirstChildWhichIsA("BasePart"))
        pos = pos and pos.Position
        if not pos then
            Rayfield:Notify({
                Title = "Error!",
                Content = "An error occured while trying to copy position: Missing character",
                Duration = 2,
                Image = "circle-x",
            })
        end
        --pos = nil ???
        local roundedPos = math.round(pos.X) .. ", " .. math.round(pos.Y) .. ", " .. math.round(pos.Z)
        return roundedPos
    end
end

function getPlayer(list, speaker)
    if list == nil then return {speaker.Name} end
    local nameList = splitString(list,",")

    local foundList = {}

    for _,name in pairs(nameList) do
        if string.sub(name,1,1) ~= "+" and string.sub(name,1,1) ~= "-" then name = "+"..name end
        local tokens = toTokens(name)
        local initialPlayers = Players:GetPlayers()

        for i,v in pairs(tokens) do
            if v.Operator == "+" then
                local tokenContent = v.Name
                local foundCase = false
                for regex,case in pairs(SpecialPlayerCases) do
                    local matches = {string.match(tokenContent,"^"..regex.."$")}
                    if #matches > 0 then
                        foundCase = true
                        initialPlayers = onlyIncludeInTable(initialPlayers,case(speaker,matches,initialPlayers))
                    end
                end
                if not foundCase then
                    initialPlayers = onlyIncludeInTable(initialPlayers,getPlayersByName(tokenContent))
                end
            else
                local tokenContent = v.Name
                local foundCase = false
                for regex,case in pairs(SpecialPlayerCases) do
                    local matches = {string.match(tokenContent,"^"..regex.."$")}
                    if #matches > 0 then
                        foundCase = true
                        initialPlayers = removeTableMatches(initialPlayers,case(speaker,matches,initialPlayers))
                    end
                end
                if not foundCase then
                    initialPlayers = removeTableMatches(initialPlayers,getPlayersByName(tokenContent))
                end
            end
        end

        for i,v in pairs(initialPlayers) do table.insert(foundList,v) end
    end

    local foundNames = {}
    for i,v in pairs(foundList) do table.insert(foundNames,v.Name) end

    return foundNames
end

function onlyIncludeInTable(tab,matches)
    local matchTable = {}
    local resultTable = {}
    for i,v in pairs(matches) do matchTable[v.Name] = true end
    for i,v in pairs(tab) do if matchTable[v.Name] then table.insert(resultTable,v) end end
    return resultTable
end

function removeTableMatches(tab,matches)
    local matchTable = {}
    local resultTable = {}
    for i,v in pairs(matches) do matchTable[v.Name] = true end
    for i,v in pairs(tab) do if not matchTable[v.Name] then table.insert(resultTable,v) end end
    return resultTable
end

function toTokens(str)
    local tokens = {}
    for op,name in string.gmatch(str,"([+-])([^+-]+)") do
        table.insert(tokens,{Operator = op,Name = name})
    end
    return tokens
end

function splitString(str,delim)
    local broken = {}
    if delim == nil then delim = "," end
    for w in string.gmatch(str,"[^"..delim.."]+") do
        table.insert(broken,w)
    end
    return broken
end

function getRoot(char)
    local rootPart = char:FindFirstChild('HumanoidRootPart') or char:FindFirstChild('Torso') or char:FindFirstChild('UpperTorso')
    return rootPart
end

everyClipboard = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)

function toClipboard(txt)
    if everyClipboard then
        everyClipboard(tostring(txt))
        Rayfield:Notify({
            Title = "Clipboard", 
            Content = "Copied to clipboard",
            Duration = 2,
            Image = "clipboard-check"})
    else
        Rayfield:Notify({
            Title = "Clipboard", 
            Content = "Your exploit doesn't have the ability to use the clipboard",
            Duration = 2,
            Image = "clipboard-x"})
    end
end

Rayfield:Notify({
    Title = "GalllaxyHub Loaded!",
    Content = "The script loaded successfully!",
    Duration = 6.5,
    Image = "rewind",
})

Rayfield:LoadConfiguration()

--[[
    TO BE DONE:  (BETA v0.1)
    KeyBinds actually work
    More Keybinds 
    Look into ESP 
    Actually tweak some Rayfield or use another gui
    Follow the work on other products (Discord Bot)




    LOCATIONS:
    356, 18, -4465 -- marine next to spawn (456, 57, -4512 -- roof)

    -561, 5, -3489 -- starter island

    -1547, 4, -3350 -- sandora 

    GHOUL://RE LOCATIONS:
    7857, 24, -724 -- CCG HQ



    USEFUL METHODS:
    tweengoto  -- DONE & FIXED
    staffwatch
    copyposition -- DONE & FIXED
    walltp
    esp 
    fov -- DONE & FIXED

    CFrameFly()
    speaker.Character:FindFirstChildOfClass('Humanoid').PlatformStand = true
    local Head = speaker.Character:WaitForChild("Head")
    Head.Anchored = true
    if CFloop then CFloop:Disconnect() end
    CFloop = RunService.Heartbeat:Connect(function(deltaTime)
        local moveDirection = speaker.Character:FindFirstChildOfClass('Humanoid').MoveDirection * (CFspeed * deltaTime)
        local headCFrame = Head.CFrame
        local cameraCFrame = workspace.CurrentCamera.CFrame
        local cameraOffset = headCFrame:ToObjectSpace(cameraCFrame).Position
        cameraCFrame = cameraCFrame * CFrame.new(-cameraOffset.X, -cameraOffset.Y, -cameraOffset.Z + 1)
        local cameraPosition = cameraCFrame.Position
        local headPosition = headCFrame.Position

        local objectSpaceVelocity = CFrame.new(cameraPosition, Vector3.new(headPosition.X, cameraPosition.Y, headPosition.Z)):VectorToObjectSpace(moveDirection)
        Head.CFrame = CFrame.new(headPosition) * (cameraCFrame - cameraPosition) * CFrame.new(objectSpaceVelocity)
    end)


]]--