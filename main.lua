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
]]