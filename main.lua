if script_key == 'galllaxy' then
	local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

	local Window = Rayfield:CreateWindow({
		Name = "GalllaxyHub",
		Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
		LoadingTitle = "GalllaxyHub loads...",
		LoadingSubtitle = "by Galllaxy",
		Theme = "Amethyst", -- Check https://docs.sirius.menu/rayfield/configuration/themes
	
		DisableRayfieldPrompts = false,
		DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface
	
		ConfigurationSaving = {
		Enabled = true,
		FolderName = nil, -- Create a custom folder for your hub/game
		FileName = "Big Hub"
		},
	
		Discord = {
		Enabled = true, -- Prompt the user to join your Discord server if their executor supports it
		Invite = "https://discord.gg/vSf9hSJG", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
		RememberJoins = true -- Set this to false to make them join the discord every time they load it up
		},
	})

	local Tab = Window:CreateTab("Player", "sigma") -- Title, Image
	local Section = Tab:CreateSection("Section Example")
	Section:Set("Section Example")
	local Divider = Tab:CreateDivider()
	Divider:Set(true) -- Whether the divider's visibility is to be set to true or false.
	local Button = Tab:CreateButton({
		Name = "Unload Script",
		Callback = function()
		-- The function that takes place when the button is pressed
			Rayfield:Destroy()
		end,
	})
	local Toggle = Tab:CreateToggle({
		Name = "Toggle Swag?",
		CurrentValue = false,
		Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
		Callback = function(Value)
		-- The function that takes place when the toggle is pressed
		-- The variable (Value) is a boolean on whether the toggle is true or false
		end,
	})
	local ColorPicker = Tab:CreateColorPicker({
		Name = "Color Picker | Pick your gender",
		Color = Color3.fromRGB(255,255,255),
		Flag = "ColorPicker1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
		Callback = function(Value)
			-- The function that takes place every time the color picker is moved/changed
			-- The variable (Value) is a Color3fromRGB value based on which color is selected
		end
	})
	local Slider = Tab:CreateSlider({
		Name = "Slider your ego",
		Range = {0, 100},
		Increment = 1,
		Suffix = "Huesos",
		CurrentValue = 10,
		Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
		Callback = function(Value)
		-- The function that takes place when the slider changes
		-- The variable (Value) is a number which correlates to the value the slider is currently at
		end,
	})
	local Input = Tab:CreateInput({
		Name = "Your name?",
		CurrentValue = "",
		PlaceholderText = "KYS NIGGA",
		RemoveTextAfterFocusLost = false,
		Flag = "Input1",
		Callback = function(Text)
		-- The function that takes place when the input is changed
		-- The variable (Text) is a string for the value in the text box
		end,
	})
	local Dropdown = Tab:CreateDropdown({
		Name = "Dropdown Example",
		Options = {"Option 1","Option 2"},
		CurrentOption = {"Option 1"},
		MultipleOptions = false,
		Flag = "Dropdown1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
		Callback = function(Options)
		-- The function that takes place when the selected option is changed
		-- The variable (Options) is a table of strings for the current selected options
		end,
	})
	local KeybindTab = Window:CreateTab("Keybinds", "command")
	local Keybind1 = Tab:CreateKeybind({
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
end