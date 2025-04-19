if not getrenv().script_key or getrenv().script_key ~= "galllaxy" then
    warn("🔒 Invalid or missing script key! Access denied.")
    return -- Stop execution if key is wrong
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
	Name = "GalllaxyHub",
	Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
	LoadingTitle = "GalllaxyHub loads...",
	LoadingSubtitle = "by Galllaxy",
	Theme = "Serenity", -- Check https://docs.sirius.menu/rayfield/configuration/themes

	DisableRayfieldPrompts = false,
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
})

local PlayerTab = Window:CreateTab("Player", "sigma") -- Title, Image
local Section = PlayerTab:CreateSection("Section Example")
Section:Set("Valuable Settings")
local ToggleWalkspeed = PlayerTab:CreateToggle({
	Name = "Toggle Walkspeed",
	CurrentValue = false,
	Flag = "WalkSpeed", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Value)
	-- The function that takes place when the toggle is pressed
	-- The variable (Value) is a boolean on whether the toggle is true or false
	end,
})
local Slider = PlayerTab:CreateSlider({
	Name = "Walkspeed",
	Range = {0, 500},
	Increment = 1,
	Suffix = "Walkspeed",
	CurrentValue = 16,
	Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Value)
		ChangeWalkspeed(Value)
	-- The function that takes place when the slider changes
	-- The variable (Value) is a number which correlates to the value the slider is currently at
	end,
})
local ToggleJumppower = PlayerTab:CreateToggle({
	Name = "Toggle JumpPower",
	CurrentValue = false,
	Flag = "JumpPower", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Value)

	-- The function that takes place when the toggle is pressed
	-- The variable (Value) is a boolean on whether the toggle is true or false
	end,
})
local Slider = PlayerTab:CreateSlider({
	Name = "JumpPower",
	Range = {0, 500},
	Increment = 1,
	Suffix = "JumpPowerslider"
	CurrentValue = 15,
	Flag = "JumpPowerSlider",
	Callback = function(Value)
		ChangeJumppower(Value)
		-- Something
	end
})
local Button = PlayerTab:CreateButton({
	Name = "Unload Script",
	Callback = function()
	-- The function that takes place when the button is pressed
		Rayfield:Destroy()
	end,
})
local KeybindTab = Window:CreateTab("Keybinds", "command")
local Keybind1 = KeybindTab:CreateKeybind({
	Name = "Walkspeed",
	CurrentKeybind = "Q",
	HoldToInteract = false,
	Flag = "Keybind1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Keybind)
	-- The function that takes place when the keybind is pressed
	-- The variable (Keybind) is a boolean for whether the keybind is being held or not (HoldToInteract needs to be true)
	end,
})

Rayfield:Notify({
	Title = "GalllaxyHub Loaded!",
	Content = "The script loaded successfully!",
	Duration = 6.5,
	Image = "rewind",
})

Rayfield:LoadConfiguration()

local function ChangeWalkspeed(Value)
	--[[local player = game.Players.LocalPlayer
	local char = player.Character
	local humanoid = char.WaitForChild("Humanoid")
	humanoid.Walkspeed = Value]]--
	if ToggleWalkspeed.CurrentValue == True then
		game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = Value
	else
		game.Player.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = 16
	end
end

local function ChangeJumppower(Value)
	--[[local player = game.Players.LocalPlayer
	local char = player.Character
	local humanoid = char.WaitForChild("Humanoid")
	humanoid.JumpPower = Value]]--
	if ToggleJumppower.CurrentValue == True then
		game.Players.LocalPlayer.Character:WaitForChild("Humanoid").JumpPower = Value
	else
		game.Players.LocalPlayer.Character:WaitForChild("Humanoid").JumpPower = 50
end