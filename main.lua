repeat wait() until game:GetService('Players').LocalPlayer
repeat wait() until game:GetService('Players').LocalPlayer.Character

local ModList = loadstring(game:HttpGet(('https://raw.githubusercontent.com/kanenr/rogue-script/master/modlist.lua'),true))()
local PerfPing = game:GetService'Stats':WaitForChild'PerformanceStats':WaitForChild'Ping'
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService('UserInputService')
local TweenService = game:GetService('TweenService')
local VIM = game:GetService('VirtualInputManager')
local RunService = game:GetService('RunService')
local Lighting = game:GetService('Lighting')
local Players = game:GetService('Players')
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local ProtGui = Instance.new("ScreenGui")

if syn then
	syn.protect_gui(ProtGui)
	syn.protect_gui(CoreGui.RobloxGui.NotificationFrame)
	ProtGui.Parent = CoreGui
elseif gethui then
	ProtGui.Parent = gethui()
else
	ChatlogsBracket.Parent = CoreGui
end
local Typing = false
local Config = {
	WindowName = "kanner's rogue cheat",
	Color = Color3.fromRGB(255, 128, 64),
	Keybind = Enum.KeyCode.RightShift
}

local AlertGui = function(text)
	local TextLabel = Instance.new("TextLabel")
	TextLabel.Parent = ProtGui
	TextLabel.AnchorPoint = Vector2.new(0.5, 0.55)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Position = UDim2.new(0.5, 0, 0.55, 0)
	TextLabel.Font = Enum.Font.SourceSans
	TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.Text = text
	TextLabel.TextSize = 25
	TextLabel.TextStrokeTransparency = 0.7
	TextLabel.Visible = true
	wait(3)
	TextLabel:Destroy()
end

local Alert = function(title, text)
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = title,
		Text = text,
		Duration = 9e9,
		Button1 = "Ignore"
	})
	AlertGui(text)
end

local deepsearchset;
deepsearchset = function(tbl, ret, value)
    if (type(tbl) == 'table') then
        local new = {}
        for i, v in next, tbl do
            new[i] = v
            if (type(v) == 'table') then
                new[i] = deepsearchset(v, ret, value);
            end
            if (ret(i, v)) then
                new[i] = value(i, v);
            end
        end
        return new
    end
end

UserInputService.TextBoxFocused:Connect(function(textBox)
	if textBox.Name == 'ChatBar' then
		Typing = true
	end
end)
	
UserInputService.TextBoxFocusReleased:Connect(function(textBox)
	if textBox.Name == 'ChatBar' then
		Typing = false
	end
end)


local Library = {
	Toggle = true,
	FirstTab = nil,
	TabCount = 0,
	ColorTable = {}
}

local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local function MakeDraggable(ClickObject, Object)
	local Dragging = nil
	local DragInput = nil
	local DragStart = nil
	local StartPosition = nil
	
	ClickObject.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			DragStart = Input.Position
			StartPosition = Object.Position
			
			Input.Changed:Connect(function()
				if Input.UserInputState == Enum.UserInputState.End then
					Dragging = false
				end
			end)
		end
	end)
	
	ClickObject.InputChanged:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
			DragInput = Input
		end
	end)
	
	UserInputService.InputChanged:Connect(function(Input)
		if Input == DragInput and Dragging then
			local Delta = Input.Position - DragStart
			Object.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
		end
	end)
end

function Library:CreateWindow(Config, Parent)
	local WindowInit = {}
	local Folder = game:GetObjects("rbxassetid://7902159539")[1]
	local Screen = Folder.Bracket:Clone()
	local Main = Screen.Main
	local Holder = Main.Holder
	local Topbar = Main.Topbar
	local TContainer = Holder.TContainer
	local TBContainer = Holder.TBContainer.Holder
	Holder.TileSize = UDim2.new(0.5, 0, 0.5, 0)
	Holder.Image = "rbxassetid://2151741365"
	Holder.ImageTransparency = 0
	if syn then
		syn.protect_gui(Screen)
		Screen.Parent = Parent
	elseif gethui then
		Screen.Parent = gethui()
	else
		Screen.Parent = Parent
	end
	
	Screen.Name =  HttpService:GenerateGUID(false)
	Screen.Parent = Parent
	Topbar.WindowName.Text = Config.WindowName

	MakeDraggable(Topbar, Main)
	local function CloseAll()
		for _, Tab in pairs(TContainer:GetChildren()) do
			if Tab:IsA("ScrollingFrame") then
				Tab.Visible = false
			end
		end
	end
	local function ResetAll()
		for _, TabButton in pairs(TBContainer:GetChildren()) do
			if TabButton:IsA("TextButton") then
				TabButton.BackgroundTransparency = 1
			end
		end
		for _, TabButton in pairs(TBContainer:GetChildren()) do
			if TabButton:IsA("TextButton") then
				TabButton.Size = UDim2.new(0, 480 / Library.TabCount, 1, 0)
			end
		end
		for _, Pallete in pairs(Screen:GetChildren()) do
			if Pallete:IsA("Frame") and Pallete.Name ~= "Main" then
				Pallete.Visible = false
			end
		end
	end
	local function KeepFirst()
		for _, Tab in pairs(TContainer:GetChildren()) do
			if Tab:IsA("ScrollingFrame") then
				if Tab.Name == Library.FirstTab .. " T" then
					Tab.Visible = true
				else
					Tab.Visible = false
				end
			end
		end
		for _, TabButton in pairs(TBContainer:GetChildren()) do
			if TabButton:IsA("TextButton") then
				if TabButton.Name == Library.FirstTab .. " TB" then
					TabButton.BackgroundTransparency = 0
				else
					TabButton.BackgroundTransparency = 1
				end
			end
		end
	end
	local function Toggle(State)
		if State then
			Main.Visible = true
		elseif not State then
			for _, Pallete in pairs(Screen:GetChildren()) do
				if Pallete:IsA("Frame") and Pallete.Name ~= "Main" then
					Pallete.Visible = false
				end
			end
			Screen.ToolTip.Visible = false
			Main.Visible = false
		end
		Library.Toggle = State
	end
	local function ChangeColor(Color)
		Config.Color = Color
		for i, v in pairs(Library.ColorTable) do
			if v.BackgroundColor3 ~= Color3.fromRGB(50, 50, 50) then
				v.BackgroundColor3 = Color
			end
		end
	end

	function WindowInit:Toggle(State)
		Toggle(State)
	end

	function WindowInit:ChangeColor(Color)
		ChangeColor(Color)
	end

	function WindowInit:SetBackground(ImageId)
		Holder.Image = "rbxassetid://" .. ImageId
	end

	function WindowInit:SetBackgroundColor(Color)
		Holder.ImageColor3 = Color
	end
	function WindowInit:SetBackgroundTransparency(Transparency)
		Holder.ImageTransparency = Transparency
	end

	function WindowInit:SetTileOffset(Offset)
		Holder.TileSize = UDim2.new(0, Offset, 0, Offset)
	end
	function WindowInit:SetTileScale(Scale)
		Holder.TileSize = UDim2.new(Scale, 0, Scale, 0)
	end

	RunService.RenderStepped:Connect(function()
		if Library.Toggle then
			Screen.ToolTip.Position = UDim2.new(0, UserInputService:GetMouseLocation().X + 10, 0, UserInputService:GetMouseLocation().Y - 5)
		end
	end)

	function WindowInit:CreateTab(Name)
		local TabInit = {}
		local Tab = Folder.Tab:Clone()
		local TabButton = Folder.TabButton:Clone()

		Tab.Name = Name .. " T"
		Tab.Parent = TContainer

		TabButton.Name = Name .. " TB"
		TabButton.Parent = TBContainer
		TabButton.Title.Text = Name
		TabButton.BackgroundColor3 = Config.Color

		table.insert(Library.ColorTable, TabButton)
		Library.TabCount = Library.TabCount + 1
		if Library.TabCount == 1 then
			Library.FirstTab = Name
		end

		CloseAll()
		ResetAll()
		KeepFirst()

		local function GetSide(Longest)
			if Longest then
				if Tab.LeftSide.ListLayout.AbsoluteContentSize.Y > Tab.RightSide.ListLayout.AbsoluteContentSize.Y then
					return Tab.LeftSide
				else
					return Tab.RightSide
				end
			else
				if Tab.LeftSide.ListLayout.AbsoluteContentSize.Y > Tab.RightSide.ListLayout.AbsoluteContentSize.Y then
					return Tab.RightSide
				else
					return Tab.LeftSide
				end
			end
		end

		TabButton.MouseButton1Click:Connect(function()
			CloseAll()
			ResetAll()
			Tab.Visible = true
			TabButton.BackgroundTransparency = 0
		end)

		Tab.LeftSide.ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			if GetSide(true).Name == Tab.LeftSide.Name then
				Tab.CanvasSize = UDim2.new(0, 0, 0, Tab.LeftSide.ListLayout.AbsoluteContentSize.Y + 15)
			else
				Tab.CanvasSize = UDim2.new(0, 0, 0, Tab.RightSide.ListLayout.AbsoluteContentSize.Y + 15)
			end
		end)
		Tab.RightSide.ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			if GetSide(true).Name == Tab.LeftSide.Name then
				Tab.CanvasSize = UDim2.new(0, 0, 0, Tab.LeftSide.ListLayout.AbsoluteContentSize.Y + 15)
			else
				Tab.CanvasSize = UDim2.new(0, 0, 0, Tab.RightSide.ListLayout.AbsoluteContentSize.Y + 15)
			end
		end)

		function TabInit:CreateSection(Name)
			local SectionInit = {}
			local Section = Folder.Section:Clone()
			Section.Name = Name .. " S"
			Section.Parent = GetSide(false)

			Section.Title.Text = Name
			Section.Title.Size = UDim2.new(0, Section.Title.TextBounds.X + 10, 0, 2)

			Section.Container.ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				Section.Size = UDim2.new(1, 0, 0, Section.Container.ListLayout.AbsoluteContentSize.Y + 15)
			end)
			
			function SectionInit:CreateLabel(Name)
				local LabelInit = {}
				local Label = Folder.Label:Clone()
				Label.Name = Name .. " L"
				Label.Parent = Section.Container
				Label.Text = Name
				Label.Size = UDim2.new(1, -10, 0, Label.TextBounds.Y)
				function LabelInit:UpdateText(Text)
					Label.Text = Text
					Label.Size = UDim2.new(1, -10, 0, Label.TextBounds.Y)
				end
				return LabelInit
			end
			function SectionInit:CreateButton(Name, Callback)
				local ButtonInit = {}
				local Button = Folder.Button:Clone()
				Button.Name = Name .. " B"
				Button.Parent = Section.Container
				Button.Title.Text = Name
				Button.Size = UDim2.new(1, -10, 0, Button.Title.TextBounds.Y + 5)
				table.insert(Library.ColorTable, Button)

				Button.MouseButton1Down:Connect(function()
					Button.BackgroundColor3 = Config.Color
				end)

				Button.MouseButton1Up:Connect(function()
					Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
				end)

				Button.MouseLeave:Connect(function()
					Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
				end)

				Button.MouseButton1Click:Connect(function()
					Callback()
				end)

				function ButtonInit:AddToolTip(Name)
					if tostring(Name):gsub(" ", "") ~= "" then
						Button.MouseEnter:Connect(function()
							Screen.ToolTip.Text = Name
							Screen.ToolTip.Size = UDim2.new(0, Screen.ToolTip.TextBounds.X + 5, 0, Screen.ToolTip.TextBounds.Y + 5)
							Screen.ToolTip.Visible = true
						end)

						Button.MouseLeave:Connect(function()
							Screen.ToolTip.Visible = false
						end)
					end
				end

				return ButtonInit
			end
			function SectionInit:CreateTextBox(Name, PlaceHolder, NumbersOnly, Callback)
				local TextBoxInit = {}
				local TextBox = Folder.TextBox:Clone()
				TextBox.Name = Name .. " T"
				TextBox.Parent = Section.Container
				TextBox.Title.Text = Name
				TextBox.Background.Input.PlaceholderText = PlaceHolder
				TextBox.Title.Size = UDim2.new(1, 0, 0, TextBox.Title.TextBounds.Y + 5)
				TextBox.Size = UDim2.new(1, -10, 0, TextBox.Title.TextBounds.Y + 25)

				TextBox.Background.Input.FocusLost:Connect(function()
					if NumbersOnly and not tonumber(TextBox.Background.Input.Text) then
						Callback(tonumber(TextBox.Background.Input.Text))
						--TextBox.Background.Input.Text = ""
					else
						Callback(TextBox.Background.Input.Text)
						--TextBox.Background.Input.Text = ""
					end
				end)
				function TextBoxInit:GetValue()
					return TextBox.Background.Input.Text
				end
				function TextBoxInit:SetState(String)
					Callback(String)
					TextBox.Background.Input.Text = String
				end
				function TextBoxInit:AddToolTip(Name)
					if tostring(Name):gsub(" ", "") ~= "" then
						TextBox.MouseEnter:Connect(function()
							Screen.ToolTip.Text = Name
							Screen.ToolTip.Size = UDim2.new(0, Screen.ToolTip.TextBounds.X + 5, 0, Screen.ToolTip.TextBounds.Y + 5)
							Screen.ToolTip.Visible = true
						end)

						TextBox.MouseLeave:Connect(function()
							Screen.ToolTip.Visible = false
						end)
					end
				end
				return TextBoxInit
			end
			function SectionInit:CreateToggle(Name, Default, Callback)
				local DefaultLocal = Default or false
				local ToggleInit = {}
				local Toggle = Folder.Toggle:Clone()
				Toggle.Name = Name .. " T"
				Toggle.Parent = Section.Container
				Toggle.Title.Text = Name
				Toggle.Size = UDim2.new(1, -10, 0, Toggle.Title.TextBounds.Y + 5)
				
				table.insert(Library.ColorTable, Toggle.Toggle)
				local ToggleState = false

				function ToggleInit:SetState(State)
					if State then
						Toggle.Toggle.BackgroundColor3 = Config.Color
					elseif not State then
						Toggle.Toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
					end
					ToggleState = State
					Callback(State)
				end

				Toggle.MouseButton1Click:Connect(function()
					ToggleState = not ToggleState
					ToggleInit:SetState(ToggleState)
				end)

				function ToggleInit:AddToolTip(Name)
					if tostring(Name):gsub(" ", "") ~= "" then
						Toggle.MouseEnter:Connect(function()
							Screen.ToolTip.Text = Name
							Screen.ToolTip.Size = UDim2.new(0, Screen.ToolTip.TextBounds.X + 5, 0, Screen.ToolTip.TextBounds.Y + 5)
							Screen.ToolTip.Visible = true
						end)

						Toggle.MouseLeave:Connect(function()
							Screen.ToolTip.Visible = false
						end)
					end
				end

				ToggleInit:SetState(DefaultLocal)

				function ToggleInit:GetValue(State)
					return ToggleState
				end

				function ToggleInit:CreateKeybind(Bind, Callback)
					local KeybindInit = {}
					Bind = Bind or "NONE"

					local WaitingForBind = false
					local Selected = Bind
					local Blacklist = {
						"W",
						"A",
						"S",
						"D",
						"Slash",
						"Tab",
						"Backspace",
						"Escape",
						"Space",
						"Delete",
						"Unknown",
						"Backquote"
					}

					Toggle.Keybind.Visible = true
					Toggle.Keybind.Text = "[ " .. Bind .. " ]"

					Toggle.Keybind.MouseButton1Click:Connect(function()
						Toggle.Keybind.Text = "[ ... ]"
						WaitingForBind = true
					end)

					Toggle.Keybind:GetPropertyChangedSignal("TextBounds"):Connect(function()
						Toggle.Keybind.Size = UDim2.new(0, Toggle.Keybind.TextBounds.X, 1, 0)
						Toggle.Title.Size = UDim2.new(1, -Toggle.Keybind.Size.X.Offset - 15, 1, 0)
					end)

					UserInputService.InputBegan:Connect(function(Input)
						if WaitingForBind and Input.UserInputType == Enum.UserInputType.Keyboard and not Typing then
							local Key = tostring(Input.KeyCode):gsub("Enum.KeyCode.", "")
							if not table.find(Blacklist, Key) then
								Toggle.Keybind.Text = "[ " .. Key .. " ]"
								Selected = Key
							else
								Toggle.Keybind.Text = "[ NONE ]"
								Selected = "NONE"
							end
							WaitingForBind = false
						elseif Input.UserInputType == Enum.UserInputType.Keyboard then
							local Key = tostring(Input.KeyCode):gsub("Enum.KeyCode.", "")
							if Key == Selected then
								ToggleState = not ToggleState
								ToggleInit:SetState(ToggleState)
								if Callback then
									Callback(Key)
								end
							end
						end
					end)

					function KeybindInit:SetBind(Key)
						Toggle.Keybind.Text = "[ " .. Key .. " ]"
						Selected = Key
					end

					function KeybindInit:GetBind()
						return Selected
					end

					return KeybindInit
				end
				return ToggleInit
			end
			function SectionInit:CreateSlider(Name, Min, Max, Default, Precise, Callback)
				local DefaultLocal = Default or 50
				local SliderInit = {}
				local Slider = Folder.Slider:Clone()
				Slider.Name = Name .. " S"
				Slider.Parent = Section.Container
				
				Slider.Title.Text = Name
				Slider.Slider.Bar.Size = UDim2.new(Min / Max, 0, 1, 0)
				Slider.Slider.Bar.BackgroundColor3 = Config.Color
				Slider.Value.PlaceholderText = tostring(Min / Max)
				Slider.Title.Size = UDim2.new(1, 0, 0, Slider.Title.TextBounds.Y + 5)
				Slider.Size = UDim2.new(1, -10, 0, Slider.Title.TextBounds.Y + 15)
				table.insert(Library.ColorTable, Slider.Slider.Bar)

				local GlobalSliderValue = 0
				local Dragging = false
				local function Sliding(Input)
					local Position = UDim2.new(math.clamp((Input.Position.X - Slider.Slider.AbsolutePosition.X) / Slider.Slider.AbsoluteSize.X, 0, 1), 0, 1, 0)
					Slider.Slider.Bar.Size = Position
					local SliderPrecise = ((Position.X.Scale * Max) / Max) * (Max - Min) + Min
					local SliderNonPrecise = math.floor(((Position.X.Scale * Max) / Max) * (Max - Min) + Min)
					local SliderValue = Precise and SliderNonPrecise or SliderPrecise
					SliderValue = tonumber(string.format("%.2f", SliderValue))
					GlobalSliderValue = SliderValue
					Slider.Value.PlaceholderText = tostring(SliderValue)
					Callback(GlobalSliderValue)
				end
				local function SetState(Value)
					GlobalSliderValue = Value
					Slider.Slider.Bar.Size = UDim2.new(Value / Max, 0, 1, 0)
					Slider.Value.PlaceholderText = Value
					Callback(Value)
				end
				Slider.Value.FocusLost:Connect(function()
					if not tonumber(Slider.Value.Text) then
						Slider.Value.Text = GlobalSliderValue
					elseif Slider.Value.Text == "" or tonumber(Slider.Value.Text) <= Min then
						Slider.Value.Text = Min
					elseif Slider.Value.Text == "" or tonumber(Slider.Value.Text) >= Max then
						Slider.Value.Text = Max
					end
		
					GlobalSliderValue = Slider.Value.Text
					Slider.Slider.Bar.Size = UDim2.new(Slider.Value.Text / Max, 0, 1, 0)
					Slider.Value.PlaceholderText = Slider.Value.Text
					Callback(tonumber(Slider.Value.Text))
					Slider.Value.Text = ""
				end)

				Slider.InputBegan:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 then
						Sliding(Input)
						Dragging = true
					end
				end)

				Slider.InputEnded:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 then
						Dragging = false
					end
				end)

				UserInputService.InputBegan:Connect(function(Input)
					if Input.KeyCode == Enum.KeyCode.LeftControl then
						Slider.Value.ZIndex = 4
					end
				end)

				UserInputService.InputEnded:Connect(function(Input)
					if Input.KeyCode == Enum.KeyCode.LeftControl then
						Slider.Value.ZIndex = 3
					end
				end)

				UserInputService.InputChanged:Connect(function(Input)
					if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
						Sliding(Input)
					end
				end)

				function SliderInit:AddToolTip(Name)
					if tostring(Name):gsub(" ", "") ~= "" then
						Slider.MouseEnter:Connect(function()
							Screen.ToolTip.Text = Name
							Screen.ToolTip.Size = UDim2.new(0, Screen.ToolTip.TextBounds.X + 5, 0, Screen.ToolTip.TextBounds.Y + 5)
							Screen.ToolTip.Visible = true
						end)

						Slider.MouseLeave:Connect(function()
							Screen.ToolTip.Visible = false
						end)
					end
				end

				if Default == nil then
					function SliderInit:SetState(Value)
						GlobalSliderValue = Value
						Slider.Slider.Bar.Size = UDim2.new(Value / Max, 0, 1, 0)
						Slider.Value.PlaceholderText = Value
						Callback(Value)
					end
				else
					SetState(DefaultLocal)
				end

				function SliderInit:GetValue(Value)
					return GlobalSliderValue
				end

				return SliderInit
			end
			function SectionInit:CreateDropdown(Name, OptionTable, Callback, InitialValue)
				local DropdownInit = {}
				local Dropdown = Folder.Dropdown:Clone()
				Dropdown.Name = Name .. " D"
				Dropdown.Parent = Section.Container

				Dropdown.Title.Text = Name
				Dropdown.Title.Size = UDim2.new(1, 0, 0, Dropdown.Title.TextBounds.Y + 5)
				Dropdown.Container.Position = UDim2.new(0, 0, 0, Dropdown.Title.TextBounds.Y + 5)
				Dropdown.Size = UDim2.new(1, -10, 0, Dropdown.Title.TextBounds.Y + 25)

				local DropdownToggle = false

				Dropdown.MouseButton1Click:Connect(function()
					DropdownToggle = not DropdownToggle
					if DropdownToggle then
						Dropdown.Size = UDim2.new(1, -10, 0, Dropdown.Container.Holder.Container.ListLayout.AbsoluteContentSize.Y + Dropdown.Title.TextBounds.Y + 30)
						Dropdown.Container.Holder.Visible = true
					else
						Dropdown.Size = UDim2.new(1, -10, 0, Dropdown.Title.TextBounds.Y + 25)
						Dropdown.Container.Holder.Visible = false
					end
				end)

				for _, OptionName in pairs(OptionTable) do
					local Option = Folder.Option:Clone()
					Option.Name = OptionName
					Option.Parent = Dropdown.Container.Holder.Container

					Option.Title.Text = OptionName
					Option.BackgroundColor3 = Config.Color
					Option.Size = UDim2.new(1, 0, 0, Option.Title.TextBounds.Y + 5)
					Dropdown.Container.Holder.Size = UDim2.new(1, -5, 0, Dropdown.Container.Holder.Container.ListLayout.AbsoluteContentSize.Y)
					table.insert(Library.ColorTable, Option)

					Option.MouseButton1Down:Connect(function()
						Option.BackgroundTransparency = 0
					end)

					Option.MouseButton1Up:Connect(function()
						Option.BackgroundTransparency = 1
					end)

					Option.MouseLeave:Connect(function()
						Option.BackgroundTransparency = 1
					end)

					Option.MouseButton1Click:Connect(function()
						Dropdown.Container.Value.Text = OptionName
						Callback(OptionName)
					end)
				end
				function DropdownInit:AddToolTip(Name)
					if tostring(Name):gsub(" ", "") ~= "" then
						Dropdown.MouseEnter:Connect(function()
							Screen.ToolTip.Text = Name
							Screen.ToolTip.Size = UDim2.new(0, Screen.ToolTip.TextBounds.X + 5, 0, Screen.ToolTip.TextBounds.Y + 5)
							Screen.ToolTip.Visible = true
						end)

						Dropdown.MouseLeave:Connect(function()
							Screen.ToolTip.Visible = false
						end)
					end
				end

				function DropdownInit:GetOption()
					return Dropdown.Container.Value.Text
				end
				function DropdownInit:SetOption(Name)
					for _, Option in pairs(Dropdown.Container.Holder.Container:GetChildren()) do
						if Option:IsA("TextButton") and string.find(Option.Name, Name) then
							Dropdown.Container.Value.Text = Option.Name
							Callback(Name)
						end
					end
				end
				function DropdownInit:RemoveOption(Name)
					for _, Option in pairs(Dropdown.Container.Holder.Container:GetChildren()) do
						if Option:IsA("TextButton") and string.find(Option.Name, Name) then
							Option:Destroy()
						end
					end
					Dropdown.Container.Holder.Size = UDim2.new(1, -5, 0, Dropdown.Container.Holder.Container.ListLayout.AbsoluteContentSize.Y)
					Dropdown.Size = UDim2.new(1, -10, 0, Dropdown.Container.Holder.Container.ListLayout.AbsoluteContentSize.Y + Dropdown.Title.TextBounds.Y + 30)
				end
				function DropdownInit:ClearOptions()
					for _, Option in pairs(Dropdown.Container.Holder.Container:GetChildren()) do
						if Option:IsA("TextButton") then
							Option:Destroy()
						end
					end
					Dropdown.Container.Holder.Size = UDim2.new(1, -5, 0, Dropdown.Container.Holder.Container.ListLayout.AbsoluteContentSize.Y)
					Dropdown.Size = UDim2.new(1, -10, 0, Dropdown.Container.Holder.Container.ListLayout.AbsoluteContentSize.Y + Dropdown.Title.TextBounds.Y + 30)
				end
				if InitialValue then
					DropdownInit:SetOption(InitialValue)
				end
				return DropdownInit
			end
			function SectionInit:CreateColorpicker(Name, Callback)
				local ColorpickerInit = {}
				local Colorpicker = Folder.Colorpicker:Clone()
				local Pallete = Folder.Pallete:Clone()

				Colorpicker.Name = Name .. " CP"
				Colorpicker.Parent = Section.Container
				Colorpicker.Title.Text = Name
				Colorpicker.Size = UDim2.new(1, -10, 0, Colorpicker.Title.TextBounds.Y + 5)

				Pallete.Name = Name .. " P"
				Pallete.Parent = Screen

				local ColorTable = {
					Hue = 1,
					Saturation = 0,
					Value = 0
				}
				local ColorRender = nil
				local HueRender = nil
				local ColorpickerRender = nil
				local function UpdateColor()
					Colorpicker.Color.BackgroundColor3 = Color3.fromHSV(ColorTable.Hue, ColorTable.Saturation, ColorTable.Value)
					Pallete.GradientPallete.BackgroundColor3 = Color3.fromHSV(ColorTable.Hue, 1, 1)
					Pallete.Input.InputBox.PlaceholderText = "RGB: " .. math.round(Colorpicker.Color.BackgroundColor3.R * 255) .. "," .. math.round(Colorpicker.Color.BackgroundColor3.G * 255) .. "," .. math.round(Colorpicker.Color.BackgroundColor3.B * 255)
					if Colorpicker.Color.BackgroundColor3 then
						Callback(Colorpicker.Color.BackgroundColor3)
					end
				end
				function ColorpickerInit:GetValue()
					return Colorpicker.Color.BackgroundColor3
				end

				Colorpicker.MouseButton1Click:Connect(function()
					if not Pallete.Visible then
						ColorpickerRender = RunService.RenderStepped:Connect(function()
							Pallete.Position = UDim2.new(0, Colorpicker.Color.AbsolutePosition.X - 129, 0, Colorpicker.Color.AbsolutePosition.Y + 52)
						end)
						Pallete.Visible = true
					else
						Pallete.Visible = false
						ColorpickerRender:Disconnect()
					end
				end)

				Pallete.GradientPallete.InputBegan:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 then
						if ColorRender then
							ColorRender:Disconnect()
						end
						ColorRender = RunService.RenderStepped:Connect(function()
							local Mouse = UserInputService:GetMouseLocation()
							local ColorX = math.clamp(Mouse.X - Pallete.GradientPallete.AbsolutePosition.X, 0, Pallete.GradientPallete.AbsoluteSize.X) / Pallete.GradientPallete.AbsoluteSize.X
							local ColorY = math.clamp((Mouse.Y - 37) - Pallete.GradientPallete.AbsolutePosition.Y, 0, Pallete.GradientPallete.AbsoluteSize.Y) / Pallete.GradientPallete.AbsoluteSize.Y
							Pallete.GradientPallete.Dot.Position = UDim2.new(ColorX, 0, ColorY, 0)
							ColorTable.Saturation = ColorX
							ColorTable.Value = 1 - ColorY
							UpdateColor()
						end)
					end
				end)

				Pallete.GradientPallete.InputEnded:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 then
						if ColorRender then
							ColorRender:Disconnect()
						end
					end
				end)

				Pallete.ColorSlider.InputBegan:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 then
						if HueRender then
							HueRender:Disconnect()
						end
						HueRender = RunService.RenderStepped:Connect(function()
							local Mouse = UserInputService:GetMouseLocation()
							local HueX = math.clamp(Mouse.X - Pallete.ColorSlider.AbsolutePosition.X, 0, Pallete.ColorSlider.AbsoluteSize.X) / Pallete.ColorSlider.AbsoluteSize.X
							ColorTable.Hue = 1 - HueX
							UpdateColor()
						end)
					end
				end)

				Pallete.ColorSlider.InputEnded:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 then
						if HueRender then
							HueRender:Disconnect()
						end
					end
				end)

				function ColorpickerInit:UpdateColor(Color)
					local Hue, Saturation, Value = Color:ToHSV()
					Colorpicker.Color.BackgroundColor3 = Color3.fromHSV(Hue, Saturation, Value)
					Pallete.GradientPallete.BackgroundColor3 = Color3.fromHSV(Hue, 1, 1)
					Pallete.Input.InputBox.PlaceholderText = "RGB: " .. math.round(Colorpicker.Color.BackgroundColor3.R * 255) .. "," .. math.round(Colorpicker.Color.BackgroundColor3.G * 255) .. "," .. math.round(Colorpicker.Color.BackgroundColor3.B * 255)
					ColorTable = {
						Hue = Hue,
						Saturation = Saturation,
						Value = Value
					}
					if Color then
						Callback(Color)
					end
				end

				Pallete.Input.InputBox.FocusLost:Connect(function(Enter)
					if Enter then
						local ColorString = string.split(string.gsub(Pallete.Input.InputBox.Text, " ", ""), ",")
						ColorpickerInit:UpdateColor(Color3.fromRGB(ColorString[1], ColorString[2], ColorString[3]))
						Pallete.Input.InputBox.Text = ""
					end
				end)

				function ColorpickerInit:AddToolTip(Name)
					if tostring(Name):gsub(" ", "") ~= "" then
						Colorpicker.MouseEnter:Connect(function()
							Screen.ToolTip.Text = Name
							Screen.ToolTip.Size = UDim2.new(0, Screen.ToolTip.TextBounds.X + 5, 0, Screen.ToolTip.TextBounds.Y + 5)
							Screen.ToolTip.Visible = true
						end)
						Colorpicker.MouseLeave:Connect(function()
							Screen.ToolTip.Visible = false
						end)
					end
				end
				return ColorpickerInit
			end
			return SectionInit
		end
		return TabInit
	end
	return WindowInit
end

function Library:CreateChatLogs()
	local ChatInit = {}
	local ChatlogsFolder = game:GetObjects("rbxassetid://7902600790")[1]
	local ChatlogsBracket = ChatlogsFolder.Bracket:Clone()
	local ChatlogsScrollingFrame = ChatlogsBracket.Main.Holder:FindFirstChild('ScrollingFrame')
	local ExampleText = ChatlogsFolder.ExampleChat
	local Main = ChatlogsBracket.Main
	Main.AnchorPoint = Vector2.new(0.05, 0.95)
	Main.Position =  UDim2.new(0.05, 0, 0.95, 0)
	local Holder = Main.Holder
	local Topbar = Main.Topbar

	if syn then
		syn.protect_gui(ChatlogsBracket)
		ChatlogsBracket.Parent = CoreGui
	elseif gethui then
		ChatlogsBracket.Parent = gethui()
	else
		ChatlogsBracket.Parent = CoreGui
	end

	ChatlogsBracket.Name =  HttpService:GenerateGUID(false)

	MakeDraggable(Topbar, Main)

	function ChatInit:AddChat(player, text)
		local funnyText = tostring(text)
		local ExTextClone = ExampleText:Clone()
		ExTextClone.TextColor3 = Color3.fromRGB(200, 200, 200)
		if player.Character and (player.Backpack:FindFirstChild('Observe') or player.Character:FindFirstChild('Observe')) then
			ExTextClone.TextColor3 = Color3.fromRGB(90, 149, 200)
		end
		username = tostring(player.Name)
		ExTextClone.Parent = ChatlogsScrollingFrame

		if string.len(funnyText) > 45 then -- bad implementation, but im lazy
			ExTextClone.Size = UDim2.new(1, 0, 0, 40)
			funnyText = string.sub(funnyText, 1, 40) .. "\n" .. string.sub(funnyText, 40, #funnyText)
		else
			ExTextClone.Size = UDim2.new(1, 0, 0, 20)
		end
		ExTextClone.Text = "   [" .. tostring(username) .. "] " .. funnyText
		ChatlogsScrollingFrame.CanvasPosition = Vector2.new(0, 10000)

		ExTextClone.MouseButton1Click:Connect(function()
			if player and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
				workspace.CurrentCamera.CameraSubject = player.Character:FindFirstChildOfClass("Humanoid")
			end
		end)
		spawn(function()
			wait(360)
			ExTextClone:Destroy()
			ChatlogsScrollingFrame.CanvasPosition = Vector2.new(0, 10000)
		end)
	end
	return ChatInit
end

local Window = Library:CreateWindow(Config, game:GetService("CoreGui"))
local PChatlogs = Library:CreateChatLogs()

local General = Window:CreateTab("General")
local Visuals = Window:CreateTab("Visuals")
local Movement = Window:CreateTab("Movement")
local Settings = Window:CreateTab("Settings")

-- General
local Generic = General:CreateSection("Generic")
local Training = General:CreateSection("Training")
local GeneralOther = General:CreateSection("Other")

-- Visuals
local PlayerESP = Visuals:CreateSection("Player ESP")
local TrinketESP = Visuals:CreateSection("Trinket ESP")
local SensoryVisuals = Visuals:CreateSection("Helping Visuals")
local OtherVisuals = Visuals:CreateSection("Visual Effects")

-- Movement
local FlightSection = Movement:CreateSection("Flight")
local OtherMovement = Movement:CreateSection("Other")

-- Settings
local ScriptSettings = Settings:CreateSection("Menu")
local UISettings = Settings:CreateSection("UI Settings")

local menusettings = {
	-- Generic
	AntiStun = false,
	AntiFire = false,
	AutoBard = false,
	AutoTrainClimb = false,
	AutoTrainMana = false,
	AntiDebuff = false,
	PickUpIngredients = false,
	IngredientDelay = 7,

	-- Visuals
	PlayerESPToggle = false,
	PlayerESPColor = Color3.fromRGB(0, 255, 0),
	PlayerESPSize = 12,
	PlayerESPDelay = 13,
	ShowDistance = false,
	ShowHealth = false,
	UseRogueName = false,
	ShowClass = false,
	ShowItems = false,
	TrinketESPToggle = false,
	TrinketESPSize = 12,
	TrinketESPDelay = 20,
	ShowTrinketDistance = false,
	CommonTrinkets = false,
	RareTrinkets = false,
	Artifacts = false,

	--Sensory
	SigmaMan = false,
	Brightness = false,
	BrightValue = 1,
	AntiFog = false,
	WorldAmbience = false,
	InteriorAmbience = Color3.fromRGB(255, 0, 0),
	OutdoorAmbience = Color3.fromRGB(255, 0, 0),
	BetterLighting = false,

	-- Movement
	Flight = false,
	KnockedOwnership = false,
	FlightFollowMouse = false,
	DisableFlyFall = false,
	FlightBypassOne = false,
	FlightBypassTwo = false,
	FlightSpeed = 3,
	WalkspeedToggle = false,
	WalkspeedValue = false,
	SpiderMode = false,
	AntiFall = false,
	AutoSprint = false,

	-- Settings
	CustomUIColor = Color3.fromRGB(255, 128, 64),
	CustomBG = "2151741365",
	CustomBGColor = Color3.fromRGB(255, 255, 255),
	CustomBGScale = 1,
}
 -- General
 -- Generic
local ignoreNames = {
	["LeftClick"] = true,
	["LeftClickRelease"] = true,
	["RightClick"] = true,
	["RightClickRelease"] = true
}
local dodgeremote

local firehook;
firehook = hookfunction(Instance.new("RemoteEvent").FireServer, function(self, ...)
	local args = {...}
	pcall(function()
		if self and not ignoreNames[self.Name] and self.Parent == LocalPlayer.Character.CharacterHandler.Remotes and not dodgeremote and #args == 1 and type(args[1]) == "table" and unpack(args[1], 2) < 1 and unpack(args[1], 2) > 0.2 and unpack(args[1]) == 4 then
			dodgeremote = self;
		end
	end)
	return firehook(self, ...)
end)

local Stuns = {
	["Action"] = true,
	["NoJump"] = true ,
	["Knocked"] = true,
	["NoDash"] = true, 
	["Unconscious"] = true,
	["ClimbCoolDown"] = true,
	["Sprinting"] = true,
	["Grabbed"] = true,
	["Stun"] = true,
	["ManaStop"] = true,
	["NoDam"] = true,
}

local AntiStun = Generic:CreateToggle("Anti Stun", nil, function(x)
	menusettings.AntiStun = x
end)
local AntiFire = Generic:CreateToggle("Anti Fire", nil, function(x)
	menusettings.AntiFire = x
end)
local AutoBard = Generic:CreateToggle("Auto Bard", nil, function(x)
	menusettings.AutoBard = x
end)
repeat wait() until LocalPlayer.PlayerGui:FindFirstChild('BardGui')
local BardGui = LocalPlayer.PlayerGui:FindFirstChild('BardGui')
BardGui.ChildAdded:Connect(function(Note)
	if AutoBard:GetValue() and Note:IsA("ImageButton") then
		wait(.9 + ((math.random(3, 11) / 100)))
		firesignal(Note.MouseButton1Click)
	end
end)
 -- Training
local AutoTrainClimb = Training:CreateToggle("Train Climb", nil, function(x)
	menusettings.AutoTrainClimb = x
end)
coroutine.wrap(function()
	while wait(.1) do
		if AutoTrainClimb:GetValue() and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Mana") then
			VIM:SendKeyEvent(true, "G", false, game)
			wait(.1 + (PerfPing:GetValue() / 900))
			repeat wait() until not LocalPlayer.Character:FindFirstChild("Charge")
			VIM:SendKeyEvent(false, "G", false, game)
			repeat
				VIM:SendKeyEvent(true, "Space", false, game) 
				wait() 
				VIM:SendKeyEvent(false, "Space", false, game)
			until LocalPlayer.Character.Mana.Value == 0 or not AutoTrainClimb:GetValue()
		end
	end
end)()
local AutoTrainMana = Training:CreateToggle("Train Mana", nil, function(x)
	menusettings.AutoTrainMana = x
end)
coroutine.wrap(function()
	while wait(.1) do
		if AutoTrainMana:GetValue() and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Mana") then
			VIM:SendKeyEvent(true, "G", false, game)
			wait(.1 + (PerfPing:GetValue() / 900))
			repeat wait() until not LocalPlayer.Character:FindFirstChild("Charge")
			VIM:SendKeyEvent(false, "G", false, game)
		end
	end
end)()

local IngredientFolder = nil
coroutine.wrap(function()
	for i, v in pairs(workspace:GetChildren()) do
		if v:IsA('Folder') then
			for o, b in pairs(v:GetChildren()) do
				if b:IsA('UnionOperation') and b:FindFirstChild('ClickDetector') and b:FindFirstChild('Blacklist') and b.Color == Color3.fromRGB(33, 84, 185) then
					IngredientFolder = v
				end
			end
		end
	end
end)()
local AntiDebuff = GeneralOther:CreateToggle("Anti Debuff", nil, function(x) 
	menusettings.AntiDebuff = x 
	if x and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Boosts") then
		for i, v in pairs(LocalPlayer.Character.Boosts:GetChildren()) do
			if v.Name == "SpeedBoost" and v.Value < 0 then
				v.Value = 0
			end
		end
	end
end)

local PickUpIngredients = GeneralOther:CreateToggle("Auto Grab Ingredients", nil, function(x) menusettings.PickUpIngredients = x end)

local IngredientDelay = GeneralOther:CreateSlider("Ingredient Delay", 1, 15, nil, true, function(x)
	menusettings.IngredientDelay = x
end)
IngredientDelay:SetState(7)

coroutine.wrap(function()
	while wait((IngredientDelay:GetValue()) / 10) do
		if IngredientFolder then
			for i, v in pairs(IngredientFolder:GetChildren()) do
				if PickUpIngredients:GetValue() and LocalPlayer.Character and LocalPlayer.Character.PrimaryPart and v:IsA('UnionOperation') and v:FindFirstChild('ClickDetector') and v.Color ~= Color3.fromRGB(100, 255, 100) and v.Transparency == 0 then
					if (LocalPlayer.Character.PrimaryPart.Position - v.Position).Magnitude < 9 then
						fireclickdetector(v:FindFirstChild("ClickDetector"));
					end
				end
			end
		end
	end
end)()
 -- Visuals
 -- Player ESP
local Illushot = Instance.new("Sound")
Illushot.SoundId = "rbxassetid://4642718673"
Illushot.Volume = 10
Illushot.Parent = ProtGui
Illushot.Loaded:wait()
local PlayerESPToggle = PlayerESP:CreateToggle("Player ESP", nil, function(x)
	menusettings.PlayerESPToggle = x
end)
PlayerESPToggle:CreateKeybind("NONE", function()
end)
local PlayerESPColor = PlayerESP:CreateColorpicker("Player ESP Color", function(x)
	menusettings.PlayerESPColor = x
end)
local PlayerESPSize = PlayerESP:CreateSlider("Player ESP Size", 8, 25, nil, true, function(x)
	menusettings.PlayerESPSize = x
end)
PlayerESPSize:SetState(12)
local PlayerESPDelay = PlayerESP:CreateSlider("Player ESP Delay", 1, 50, nil, true, function(x)
	menusettings.PlayerESPDelay = x
end)
PlayerESPDelay:SetState(13)
local ShowDistance = PlayerESP:CreateToggle("Show Distance", nil, function(x)
	menusettings.ShowDistance = x
end)
local ShowHealth = PlayerESP:CreateToggle("Show Health", nil, function(x)
	menusettings.ShowHealth = x
end)
local UseRogueName = PlayerESP:CreateToggle("Rogue Name", nil, function(x)
	menusettings.UseRogueName = x
end)
local ShowClass = PlayerESP:CreateToggle("Show Class", nil, function(x)
	menusettings.ShowClass = x
end)
local ShowItems = PlayerESP:CreateToggle("Show Items", nil, function(x)
	menusettings.ShowItems = x
end)
local classIdentify = {
    ["DRUID"] = {"Perflora","Floresco","Fons Vitae","Verdien"
    },
    ["SPY"] = {"Rapier","Silver Guard","Elegant Slash","Interrogation"
    },
    ["WRAITH"] = {"Dark Eruption","Dark Flame Burst","Mirror","MercenaryCarry"
    },
    ["SHNOBI"] = {"Grapple","Resurrection","FeatherFall","UpgradedAgility"
    },
    ["FACE"] = {"Ethereal Strike","Shadow Fan","Chain Lethality","UpgradedBane"
    },
    ["NECRO"] = {"Secare","Furantur","Inferi","Command Monsters"
    },
    ["DEEP"] = {"Chain Pull","Leviathan Plunge","Deep Sacrifice","PrinceBlessing"
    },
    ["ABYSS"] = {"Abyssal Scream","Wrathful Leap","Abysswalker","MercenaryCarry"
    },
    ["ONI"] = {"Axe Kick","Demon Step","Misogi","Demon Flip"
    },
    ["HAMMER"] = {"Ruby Shard","Sapphire Shard","Sharpener","Gemcutter"
    },
    ["BARD"] = {"Sweet Soothing","Joyous Dance","MusiciansResolve","BlastMeter"
    },
    ["ILLU"] = {"Observe","Globus","Intermissum","Dominus"
    },
    ["SIGIL"] = {"Charged Blow","Hyper Body","ChargeMastery","PlateTraining","Flame Charge"
    },
    ["DSAGE"] = {"Lightning Drop","Lightning Elbow","MonasteryShield","Monastic Stance"
    },
    ["SLAYER"] = {"Thunder Spear Crash","Dragon Blood","Wing Soar","Dragon Awakening"
    }
}
local CreateESP = function(Player)
	if Player.Character and Player.Character.PrimaryPart then
		local RogueName = "Unknown"
		local Class = "FRESH"
		local billboard = Instance.new("BillboardGui")
		for x, y in pairs(classIdentify) do
			if Player.Backpack:FindFirstChild(y[1]) or Player.Backpack:FindFirstChild(y[2]) or Player.Backpack:FindFirstChild(y[3]) and Player.Backpack:FindFirstChild(y[4]) then
				Class = x
				break
			end
		end
		for i, part in pairs(Player.Character:GetChildren()) do
			if part:IsA("Model") and part:FindFirstChild("FakeHumanoid") then
				if part.Name ~= "" then
					RogueName = part.Name
				else
					RogueName = "Unknown"
				end
			end
		end
		billboard.StudsOffset = Vector3.new(0, 4, 0)
		billboard.Size = UDim2.new(0, 200, 0, 50)
		billboard.AlwaysOnTop = true
		billboard.Parent = ProtGui
		billboard.Adornee = Player.Character.PrimaryPart
		local textlabel = Instance.new("TextLabel")
		textlabel.TextColor3 = PlayerESPColor:GetValue()
		textlabel.Size = UDim2.new(0, 200, 0, 50)
		textlabel.TextStrokeTransparency = 0.6
		textlabel.BackgroundTransparency = 1
		textlabel.Name = "UpperLabel"
		textlabel.Text = Player.Name
		textlabel.Parent = billboard
		textlabel.TextScaled = false
		textlabel.TextSize = PlayerESPSize:GetValue()
		if UseRogueName:GetValue() then
			textlabel.Text = RogueName
		end
		local colorlabel = Instance.new("TextLabel")
		colorlabel.TextColor3 = Color3.new(152, 152, 152)
		colorlabel.Size = UDim2.new(0, 200, 0, 50)
		colorlabel.TextStrokeTransparency = 0.6
		colorlabel.BackgroundTransparency = 1
		colorlabel.Name = "ColorLabel"
		colorlabel.TextScaled = false
		colorlabel.Parent = billboard
		colorlabel.TextSize = (PlayerESPSize:GetValue() - 2)
		if not PlayerESPToggle:GetValue() then
			billboard.Enabled = false
		end
		local PlayerChar = Player.Character
		local PrimaryPart = Player.Character.PrimaryPart
		coroutine.wrap(function()
			while wait(5) do
				if billboard and UseRogueName:GetValue() then
					textlabel.Text = RogueName
				elseif billboard and not UseRogueName:GetValue() then
					textlabel.Text = Player.Name
				elseif not billboard then
					break
				end
			end
		end)()
		coroutine.wrap(function() -- why am i even putting this in a coroutine? i forgot,
			while wait(PlayerESPDelay:GetValue() / 75) do -- all of this is unoptimized as shit
				if billboard and PlayerChar and PrimaryPart then -- i can reduce this
					textlabel.TextColor3 = PlayerESPColor:GetValue()
					textlabel.TextSize = PlayerESPSize:GetValue()
					colorlabel.TextSize = (PlayerESPSize:GetValue() - 2)
					billboard.Enabled = PlayerESPToggle:GetValue()
					colorlabel.Text = "\n \n \n "
					if ShowDistance:GetValue() then
						local distance = math.floor((Camera.CFrame.p - PrimaryPart.CFrame.p).Magnitude)
						colorlabel.Text = colorlabel.Text .. "[" .. tonumber(distance) .. "]" -- new line new line new line bs (i could adjust position but no)
					end
					if ShowHealth:GetValue() and PlayerChar:FindFirstChildOfClass("Humanoid") then
						local humanoid = PlayerChar:FindFirstChildOfClass("Humanoid")
						colorlabel.Text = colorlabel.Text .. "[" .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth) .. "]"
					end
					colorlabel.Text = colorlabel.Text .. "\n"
					if ShowClass:GetValue() then
						colorlabel.Text = colorlabel.Text .. "[" .. Class .. "]"
					end
					if ShowItems:GetValue() then
						local Tool = PlayerChar:FindFirstChildOfClass("Tool")
						local ToolName = "FIST"
						if Tool then
							ToolName = Tool.Name
						end
						colorlabel.Text = colorlabel.Text .. "[" .. ToolName .. "] "
					end
				else
					if billboard then
						billboard:Destroy()
					end
					break
				end
			end
		end)()
	end
end
for i, Player in pairs(Players:GetPlayers()) do
	if Player ~= LocalPlayer then
		if Player.Character and Player.Character.PrimaryPart then
			CreateESP(Player)
			if Player.Backpack:FindFirstChild('Observe') or (Player.Character and Player.Character:FindFirstChild('Observe')) then
				Illushot:Play()
				Alert('Illusionist', Player.Name .. ' is a illusionist!')
			end
		end
		Player.CharacterAdded:Connect(function(char)
			repeat wait() until Player.Character:FindFirstChild("HumanoidRootPart")
			repeat wait() until Player.Character:FindFirstChild("Humanoid")
			wait(3)
			CreateESP(Player)
			if Player.Backpack:FindFirstChild('Observe') or (Player.Character and Player.Character:FindFirstChild('Observe')) then
				Illushot:Play()
				Alert('Illusionist', Player.Name .. ' is a illusionist!')
			end
		end)
	end
end
Players.PlayerAdded:Connect(function(Player)
	Player.CharacterAdded:Connect(function(char)
		repeat wait() until Player.Character:FindFirstChild("HumanoidRootPart")
		repeat wait() until Player.Character:FindFirstChild("Humanoid")
		wait(4)
		CreateESP(Player)
		if Player.Backpack:FindFirstChild('Observe') or (Player.Character and Player.Character:FindFirstChild('Observe')) then
			Illushot:Play()
			Alert('Illusionist', Player.Name .. ' is a illusionist!')
		end
	end)
end)
Players.PlayerRemoving:Connect(function(player)
	for i, v in next, CoreGui.RobloxGui.NotificationFrame:GetDescendants() do
		if v and player and v.Name == "NotificationText" and string.match(v.Text, player.Name) and v.Parent:FindFirstChild('Button1') then
			firesignal(v.Parent.Button1.MouseButton1Down)
			wait()
			firesignal(v.Parent.Button1.MouseButton1Up)
			firesignal(v.Parent.Button1.MouseButton1Click)
		end
	end
end)

-- Trinket ESP
local TrinketESPFolder = Instance.new("Folder")
TrinketESPFolder.Parent = ProtGui
local CreateTrinketESP = function()
end
local TrinketESPToggle = TrinketESP:CreateToggle("Trinket ESP", nil, function(State)
	menusettings.TrinketESPToggle = State
	for i, v in next, TrinketESPFolder:GetChildren() do
		v:Destroy()
	end
	if State then
		for i, Part in next, workspace:GetChildren() do
			if Part and Part.Name == "Part" and Part:FindFirstChild("ID") then
				CreateTrinketESP(Part)
			end
		end
	end
end)
local refresh = function()
	for i, v in next, TrinketESPFolder:GetChildren() do
		v:Destroy()
	end
	if TrinketESPToggle:GetValue() then
		for i, Part in next, workspace:GetChildren() do
			if Part and Part.Name == "Part" and Part:FindFirstChild("ID") then
				CreateTrinketESP(Part)
			end
		end
	end
end
workspace.ChildAdded:Connect(function(Part)
	if Part and Part.Name == "Part" and Part:FindFirstChild("ID") then
		CreateTrinketESP(Part)
	end
end)
TrinketESPToggle:CreateKeybind("NONE", function()
end)
local TrinketESPSize = TrinketESP:CreateSlider("Trinket ESP Size", 8, 25, nil, true, function(x)
	menusettings.TrinketESPSize = x
end)
TrinketESPSize:SetState(12)
local TrinketESPDelay = TrinketESP:CreateSlider("Trinket ESP Delay", 1, 50, nil, true, function(x)
	menusettings.TrinketESPDelay = x
end)
TrinketESPDelay:SetState(20)
local ShowTrinketDistance = TrinketESP:CreateToggle("Show Trinket Distance", nil, function(x)
	refresh()
	menusettings.ShowTrinketDistance = x
end)
local CommonTrinkets = TrinketESP:CreateToggle("Show Common Trinkets", nil, function(x)
	refresh()
	menusettings.CommonTrinkets = x
end)
local RareTrinkets = TrinketESP:CreateToggle("Show Rare Trinkets", nil, function(x)
	refresh()
	menusettings.RareTrinkets = x
end)
local Artifacts = TrinketESP:CreateToggle("Show Artifacts", nil, function(x)
	refresh()
	menusettings.Artifacts = x
end)
local function checkTrinket(v)
	if CommonTrinkets:GetValue() then
		if (v.ClassName == 'UnionOperation' and getspecialinfo(v).AssetId == 'https://www.roblox.com//asset/?id=2765613127') then
			return 'Idol of the Forgotten';
		elseif (v.ClassName == 'MeshPart' and v.MeshId == 'rbxassetid://5196782997') then
			return 'Old Ring';
		elseif (v.ClassName == 'MeshPart' and v.MeshId == 'rbxassetid://5196776695') then
			return 'Ring';
		elseif (v.ClassName == 'MeshPart' and v.MeshId == 'rbxassetid://5204003946') then
			return 'Goblet';
		elseif (v.ClassName == 'MeshPart' and v.MeshId == 'rbxassetid://5196577540') then
			return 'Old Amulet';
		elseif (v.ClassName == 'MeshPart' and v.MeshId == 'rbxassetid://5196551436') then
			return 'Amulet';
		end
	end
	if RareTrinkets:GetValue() then
		if (v.ClassName == 'Part' and tostring(gethiddenproperties(v).size) == '0.40000000596046, 0.5, 0.30000001192093') then
			return 'Opal';
		elseif (v.ClassName == 'MeshPart' and v.MeshId == 'rbxassetid://5204453430') then
			return 'Scroll';
		elseif (v:IsA('MeshPart') and v.MeshId == "rbxassetid://4103271893") then
			return 'Candy';
		elseif (v:FindFirstChild('Mesh') and v.Mesh.MeshId == 'rbxassetid://%202877143560%20' and v:FindFirstChild('ParticleEmitter') and string.match(tostring(v.ParticleEmitter.Color), '0 1 1 1 0 1 1 1 1 0') and v.ClassName == 'Part' and tostring(v.Color) == '0.643137, 0.733333, 0.745098') then
			return 'Diamond';
		elseif (v:FindFirstChild('Mesh') and v.Mesh.MeshId == 'rbxassetid://%202877143560%20' and v:FindFirstChild('ParticleEmitter') and string.match(tostring(v.ParticleEmitter.Color), '0 1 1 1 0 1 1 1 1 0') and v.ClassName == 'Part' and v.Color.G > v.Color.R and v.Color.G > v.Color.B) then
			return 'Emerald';
		elseif (v:FindFirstChild('Mesh') and v.Mesh.MeshId == 'rbxassetid://%202877143560%20' and v:FindFirstChild('ParticleEmitter') and string.match(tostring(v.ParticleEmitter.Color), '0 1 1 1 0 1 1 1 1 0') and v.ClassName == 'Part' and v.Color.R > v.Color.G and v.Color.R > v.Color.B) then
			return 'Ruby';
		elseif (v:FindFirstChild('Mesh') and v.Mesh.MeshId == 'rbxassetid://%202877143560%20' and v:FindFirstChild('ParticleEmitter') and string.match(tostring(v.ParticleEmitter.Color), '0 1 1 1 0 1 1 1 1 0') and v.ClassName == 'Part' and v.Color.B > v.Color.G and v.Color.B > v.Color.R) then
			return 'Sapphire';
		end
	end
	if Artifacts:GetValue() then
		if (v.ClassName == 'Part' and v:FindFirstChild('ParticleEmitter') and not string.match(tostring(v.ParticleEmitter.Color), '0 1 1 1 0 1 1 1 1 0')) then
			return 'Rift Gem';
		elseif (v.ClassName == 'UnionOperation' and getspecialinfo(v).AssetId == 'https://www.roblox.com//asset/?id=3158350180') then
			return 'Amulet of the White King'
		elseif (v.ClassName == 'UnionOperation' and getspecialinfo(v).AssetId == 'https://www.roblox.com//asset/?id=2998499856') then
			return 'Lannis Amulet';
		elseif (string.match(tostring(v.Size), '0.69999998807907, 0.69999998807907, 0.69999998807907') and v:FindFirstChild('Attachment') and v.Attachment:FindFirstChildOfClass('ParticleEmitter') and string.match(tostring(v.Attachment.ParticleEmitter.Color), '0 0.45098 1 0 0 1 0.482353 1 0 0 ')) then
			return 'Mysterious Artifact';
		elseif (v.ClassName == 'UnionOperation' and v.BrickColor.Name == 'Black') then
			return 'Night Stone';
		elseif (v.ClassName == 'MeshPart' and v.MeshId == 'rbxassetid://%202520762076%20') then
			return 'Howler Friend';
		elseif (string.match(tostring(v.Size), '0.69999998807907, 0.69999998807907, 0.69999998807907') and v:FindFirstChild('Attachment') and v.Attachment:FindFirstChildOfClass('ParticleEmitter') and string.match(tostring(v.Attachment.ParticleEmitter.Color), '0 1 0.8 0 0 1 1 0.501961 0 0 ')) then
			return 'Phoenix Down';
		elseif (v.ClassName == 'Part' and v:FindFirstChild('OrbParticle') and string.match(tostring(v.OrbParticle.Color), '0 0.105882 0.596078 0.596078 0 1 0.105882 0.596078 0.596078 0 ')) then
			return 'Ice Essence';
		elseif (v.ClassName == 'Part' and v:FindFirstChild('OrbParticle') and string.match(tostring(v.OrbParticle.Color), '0 0.596078 0 0.207843 0 1 0.596078 0 0.207843 0 ')) then
			return '???';
		end;
	end
	return nil;
end;
CreateTrinketESP = function(Part)
	local TrinketName = checkTrinket(Part)
	if Part and Part:FindFirstChild("ID") and TrinketName and TrinketESPToggle:GetValue() then
		local billboard = Instance.new("BillboardGui")
		billboard.StudsOffset = Vector3.new(0, 0.75, 0)
		billboard.Size = UDim2.new(0, 200, 0, 50)
		billboard.AlwaysOnTop = true
		billboard.Parent = TrinketESPFolder
		billboard.Adornee = Part
		local textlabel = Instance.new("TextLabel")
		textlabel.TextColor3 = Part.Color
		textlabel.Size = UDim2.new(0, 200, 0, 50)
		textlabel.TextStrokeTransparency = 0.6
		textlabel.BackgroundTransparency = 1
		textlabel.Text = TrinketName
		textlabel.Parent = billboard
		textlabel.TextScaled = false
		textlabel.TextSize = TrinketESPSize:GetValue()
		local colorlabel = Instance.new("TextLabel")
		colorlabel.TextColor3 = Color3.new(152, 152, 152)
		colorlabel.Size = UDim2.new(0, 200, 0, 50)
		colorlabel.TextStrokeTransparency = 0.6
		colorlabel.BackgroundTransparency = 1
		colorlabel.TextScaled = false
		colorlabel.Parent = billboard
		colorlabel.TextSize = (TrinketESPSize:GetValue() - 2)
		coroutine.wrap(function()
			while wait(TrinketESPDelay:GetValue() / 75) do
				if billboard and Part and Part.Parent == workspace then
					textlabel.TextSize = TrinketESPSize:GetValue()
					colorlabel.TextSize = (TrinketESPSize:GetValue() - 2)
					colorlabel.Text = "\n \n \n "
					if ShowTrinketDistance:GetValue() then
						local distance = math.floor((Camera.CFrame.p - Part.CFrame.p).Magnitude)
						colorlabel.Text = colorlabel.Text .. "[" .. tonumber(distance) .. "]"
					end
				else
					if billboard then
						billboard:Destroy()
					end
					break
				end
			end
		end)()
	end
end

 -- Sensory Visuals
local SigmaMusic = Instance.new("Sound")
SigmaMusic.SoundId = "rbxassetid://7153559056"
SigmaMusic.Volume = 1
SigmaMusic.Looped = true
SigmaMusic.Parent = ProtGui
SigmaMusic.Loaded:wait()
local SigmaMan = SensoryVisuals:CreateToggle("Sigma Music", nil, function(x)
	menusettings.SigmaMan = x
	if x then
		SigmaMusic:Play()
	else
		SigmaMusic:Stop()
	end
end)
local Brightness = SensoryVisuals:CreateToggle("Brightness", nil, function(x)
	menusettings.Brightness = x
end)
local BrightValue = SensoryVisuals:CreateSlider("Brightness Level", 0, 2, nil, true, function(x)
	menusettings.BrightValue = x
	if Brightness:GetValue() then
		Lighting.Brightness = x
	end
end)
BrightValue:SetState(1)
Lighting:GetPropertyChangedSignal("Brightness"):Connect(function()
	if Brightness:GetValue() then
		Lighting.Brightness = BrightValue:GetValue()
	end
end)
local AntiFog = SensoryVisuals:CreateToggle("Anti-Fog", nil, function(x)
	menusettings.AntiFog = x
	if x then
		Lighting.FogColor = Color3.fromRGB(254, 254, 254)
		Lighting.FogEnd = 100000
		Lighting.FogStart = 50
	end
end)
Lighting:GetPropertyChangedSignal("FogEnd"):Connect(function()
	if AntiFog:GetValue() then
		wait(1.1)
		Lighting.FogColor = Color3.fromRGB(254, 254, 254)
		Lighting.FogEnd = 100000
		Lighting.FogStart = 50
	end
end)


 -- Visual Effects
local HIGHFPS = true
local WorldAmbience = OtherVisuals:CreateToggle("World Ambience", nil, function(x)
	menusettings.WorldAmbience = x
end)
local InteriorAmbience = OtherVisuals:CreateColorpicker("Interior Ambience", function(x)
	menusettings.InteriorAmbience = x
	if WorldAmbience:GetValue() then
		Lighting.Ambient = x
	end
end)
local OutdoorAmbience = OtherVisuals:CreateColorpicker("Outdoor Ambience", function(x)
	menusettings.OutdoorAmbience = x
	if WorldAmbience:GetValue() then
		Lighting.OutdoorAmbient = x
	end
end)
local BetterLighting = OtherVisuals:CreateToggle("Better Lighting", nil, function(Value)
	menusettings.BetterLighting = Value
	if HIGHFPS then
		if Value then
			sethiddenproperty(Lighting, "Technology", 4)
		else
			sethiddenproperty(Lighting, "Technology", 3)
		end
	end
end)
Lighting:GetPropertyChangedSignal("Ambient"):Connect(function()
	if WorldAmbience:GetValue() then
		Lighting.Ambient = InteriorAmbience:GetValue()
	end
end)
Lighting:GetPropertyChangedSignal("OutdoorAmbient"):Connect(function()
	if WorldAmbience:GetValue() then
		Lighting.OutdoorAmbient = OutdoorAmbience:GetValue()
	end
end)
local sfps = 0
local fpsevent = RunService.RenderStepped:Connect(function(fstep)
	sfps = 1 / fstep
end)
wait(1)
fpsevent:Disconnect()
if sfps < 70 then
	local dumbfunc = Instance.new("BindableFunction")
	dumbfunc.OnInvoke = function(args)
		if args == "Yes" then
			HIGHFPS = false
			sethiddenproperty(Lighting, "Technology", 2)
			sethiddenproperty(workspace.Terrain, "Decoration", false)
			BetterLighting:AddToolTip("Disabled due to Optimization")
		end
	end
	game:GetService("StarterGui"):SetCore("SendNotification", { -- this shit prob barely works LOL
		Title = "LOW FPS ALERT",
		Text = "would you like to enable low fps mode, this may get you banned in the future",
		Duration = 9e9,
		Callback = dumbfunc,
		Button1 = "Yes",
		Button2 = "No"
	})
end
local Zap = Instance.new("Sound")
Zap.SoundId = "rbxassetid://7554632797"
Zap.Volume = 10
Zap.Parent = ProtGui
Zap.Loaded:wait()
local Mouse = LocalPlayer:GetMouse()
local Flight = FlightSection:CreateToggle("Flight", nil, function(x)
	menusettings.Flight = x
end)
Flight:CreateKeybind("NONE", function() end)

local KnockedOwnership = FlightSection:CreateToggle("Knocked Ownership", nil, function(x)
	menusettings.KnockedOwnership = x
end)

local FlightFollowMouse = FlightSection:CreateToggle("Flight Follow Mouse", nil, function(x)
	menusettings.FlightFollowMouse = x
end)
local DisableFlyFall = FlightSection:CreateToggle("Disable Fly Fall", nil, function(x)
	menusettings.DisableFlyFall = x
end)
local FlightBypassOne = FlightSection:CreateToggle("Fly Bypass #1", nil, function(x)
	menusettings.FlightBypassOne = x -- no longer works, but 
	if x then
		VIM:SendKeyEvent(true, "S", false, game)
		wait()
		VIM:SendKeyEvent(true, "Q", false, game)
		VIM:SendKeyEvent(false, "S", false, game)
		wait()
		VIM:SendKeyEvent(false, "Q", false, game)
	end
end)
local FlightBypassTwo = FlightSection:CreateToggle("Fly Bypass #2", nil, function(x)
	menusettings.FlightBypassTwo = x -- removed the code for this
end)
local FlightSpeed = FlightSection:CreateSlider("Flight Speed", 1, 5, nil, true, function(x)
	menusettings.FlightSpeed = x
end)
FlightSpeed:SetState(3)

coroutine.wrap(function()
	while true do
		game:GetService("RunService").Stepped:Wait()

		if Flight:GetValue() and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild('HumanoidRootPart') and not Typing then
			local Primary = LocalPlayer.Character.HumanoidRootPart
			local Direction = Vector3.new(0, 0, 0)
			local Ping = PerfPing:GetValue();
			local FPos = Primary.CFrame

			if KnockedOwnership:GetValue() and Primary:FindFirstChild("Bone") then
				Primary.Bone:Destroy()
			end
			
			Direction = Vector3.new(0, 0, 0) +
                    (UserInputService:IsKeyDown'W' and Vector3.new(0, 0, -1) or Vector3.new(0, 0, 0)) +
                    (UserInputService:IsKeyDown'S' and Vector3.new(0, 0, 1)  or Vector3.new(0, 0, 0)) +
                    (UserInputService:IsKeyDown'D' and Vector3.new(1, 0, 0)  or Vector3.new(0, 0, 0)) +
                    (UserInputService:IsKeyDown'A' and Vector3.new(-1, 0, 0) or Vector3.new(0, 0, 0)) +
                    (UserInputService:IsKeyDown'Space' and Vector3.new(0, 1, 0)  or Vector3.new(0, 0, 0)) +
                    (UserInputService:IsKeyDown'LeftControl' and Vector3.new(0, -1, 0) or Vector3.new(0, 0, 0));
			
			if Ping > 200 then
				Direction = Direction * 0.75;
			end
			if Ping > 300 then
				Direction = Direction * 0.75;
			end
			if Ping > 500 then
				Direction = Direction * 0.5;
			end

			Direction = Direction * (FlightSpeed:GetValue() / 5);
			Primary.Velocity = Vector3.new(0,0,0);
			Primary.RotVelocity = Vector3.new(0,0,0);

			if not LocalPlayer.Character:FindFirstChild("Knocked") then
				if not DisableFlyFall:GetValue() and Direction.Y < .1 then
					local Fall = (-70 + math.random(1, 7))
					Primary.Velocity = Vector3.new(0, Fall, 0);
				end
				if FlightBypassOne:GetValue() and dodgeremote then
					local dodgeargs = {[1] = {[1] = 1,[2] = math.random()}}
					dodgeremote:FireServer(unpack(dodgeargs))
				end
			end

			FPos = FPos * CFrame.new(Direction)

			local Direction = FlightFollowMouse:GetValue() and (Mouse.Hit.p - workspace.CurrentCamera.CFrame.p) or workspace.CurrentCamera.CFrame.lookVector;
			Direction = Camera.CFrame.p + (Direction.Unit * 10000);

			if FPos.Y > (1e9) then
				FPos = CFrame.new(FPos.X, math.clamp(FPos.Y, -1000, MaxY), FPos.Z);
			end

			FPos = CFrame.new(FPos.p, Direction);
			Primary.CFrame = FPos;
		end
	end
end)()

local function checkdistance(player)
	if player.Character and LocalPlayer.Character and player.Character.PrimaryPart and LocalPlayer.Character.PrimaryPart then
		local distance = (player.Character.PrimaryPart.CFrame.p - LocalPlayer.Character.PrimaryPart.CFrame.p).Magnitude
		if distance < 200 then
			Flight:SetState(false)
			AlertGui("Player Nearby")
			Zap:Play()
		end
	end
end
for i, Player in pairs(Players:GetPlayers()) do
	if Player ~= LocalPlayer then
		Player.CharacterAdded:Connect(function(char)
			repeat wait() until Player.Character:FindFirstChild("HumanoidRootPart")
			repeat wait() until Player.Character:FindFirstChild("Humanoid")
			wait(1)
			checkdistance(Player)
		end)
	end
end
Players.PlayerAdded:Connect(function(Player)
	Player.CharacterAdded:Connect(function(char)
		repeat wait() until Player.Character:FindFirstChild("HumanoidRootPart")
		repeat wait() until Player.Character:FindFirstChild("Humanoid")
		wait(1)
		checkdistance(Player)
	end)
end)

local AntiFall = OtherMovement:CreateToggle("Anti-Fall", nil, function(x)
	menusettings.AntiFall = x
end)
AntiFall:CreateKeybind("NONE", function()
end)

local oldfall;
oldfall = hookfunction(Instance.new("RemoteEvent").FireServer, function(self, ...)
	local args = {...}
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild'CharacterHandler' and LocalPlayer.Character.CharacterHandler:FindFirstChild('Remotes') and self.Parent == LocalPlayer.Character.CharacterHandler.Remotes and AntiFall:GetValue() then
		if #args == 2 and typeof(args[2]) == "table" then
			return nil
		end
	end
	return oldfall(self, ...)
end)


local spiderParams = RaycastParams.new()
	spiderParams.FilterType = Enum.RaycastFilterType.Blacklist
	spiderParams.FilterDescendantsInstances = {workspace.Live}
	spiderParams.IgnoreWater = true

local SpiderMode = OtherMovement:CreateToggle("Spider Climb", nil, function(x) 
	menusettings.SpiderMode = x
end)

SpiderMode:CreateKeybind("NONE", function() end)

local SpiderSpeed = OtherMovement:CreateSlider("Spider Speed", 1, 8, nil, true, function(x)
	--menusettings.WalkspeedValue = x
end)
SpiderSpeed:SetState(0)

spawn(function()
	while wait() do
		if SpiderMode:GetValue() and not Flight:GetValue() and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local Primary = LocalPlayer.Character.HumanoidRootPart
			local Hit = workspace:Raycast(Primary.Position, Primary.CFrame.LookVector*2, spiderParams)
				
			if Hit then
				Primary.Velocity = Vector3.new(Primary.Velocity.X, (SpiderSpeed:GetValue() * (15 + math.random())), Primary.Velocity.Z)
			end
		end
	end
end)

local SpeedObject = nil
local WalkspeedToggle = OtherMovement:CreateToggle("Walkspeed", nil, function(x) 
	menusettings.WalkspeedToggle = x 
	if x and SpeedObject and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Boosts") then
		SpeedObject.Parent = LocalPlayer.Character.Boosts
	elseif not x and SpeedObject then
		SpeedObject.Parent = nil
	end
end)

local WalkspeedValue = OtherMovement:CreateSlider("Bonus Speed", 0, 50, nil, true, function(x)
	menusettings.WalkspeedValue = x
	if x and SpeedObject and WalkspeedToggle:GetValue() then
		SpeedObject.Value = x
	end
end)
WalkspeedValue:SetState(0)

local AutoSprint = OtherMovement:CreateToggle("Auto-Sprint [EXPERIMENTAL]", nil, function(x)
	menusettings.AutoSprint = x
end)
local AntiWalk = {
	["Knocked"] = true,
	["RecentDash"] = true,
	["Sprinting"] = true,
	["Stun"] = true,
	["LightAttack"] = true
}
local BigStun = {
	["Action"] = true,
	["Knocked"] = true,
	["RecentDash"] = true,
	["LightAttack"] = true,
	["HeavyAttack"] = true,
	["Charge"] = true,
	["NoJump"] = true,
	["NoStun"] = true,
	["Stun"] = true,
	["NoDam"] = true,
	["NoDash"] = true,
	["Carried"] = true,
	["RagingDemonImmune"] = true,
	["CurseMP"] = true,
	["RecentFall"] = true
}
local CheckWalk = function(Character)
	for _, v in pairs(Character:GetChildren()) do
		if AntiWalk[v.Name] then
			return true
		end
	end
end
local CheckStun = function(Character)
	for _, v in pairs(Character:GetChildren()) do
		if BigStun[v.Name] then
			return true
		end
	end
end
local StartRun = function()
	if AutoSprint:GetValue() and LocalPlayer.Character and not UserInputService:IsKeyDown(Enum.KeyCode.G) and not CheckWalk(LocalPlayer.Character) then
		VIM:SendKeyEvent(false, "W", false, game)
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then
			VIM:SendKeyEvent(true, "W", false, game)
		end
	end
end
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.W then
		StartRun()
	end
end)
UserInputService.InputEnded:Connect(function(input, gameProcessed)
	if not gameProcessed then
		wait()
		StartRun()
	end
end)
local PSServerCode = ScriptSettings:CreateTextBox("PS Code", "44ebab86", false, function()
end)
local JoinPS = ScriptSettings:CreateButton("Join PS", function()
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild('Danger') then
		repeat wait() until not LocalPlayer.Character:FindFirstChild('Danger')
	end
	if ReplicatedStorage.Requests:FindFirstChild('JoinPrivateServer') then
		ReplicatedStorage.Requests.JoinPrivateServer:FireServer(PSServerCode:GetValue())
	end
end)

local UIToggle = UISettings:CreateToggle("UI Toggle", nil, function(State)
	Window:Toggle(State)
end)
UIToggle:CreateKeybind(tostring(Config.Keybind):gsub("Enum.KeyCode.", ""), function(Key)
	Config.Keybind = Enum.KeyCode[Key]
end)
UIToggle:SetState(true)
local CustomUIColor = UISettings:CreateColorpicker("UI Color", function(Color)
	menusettings.CustomUIColor = Color
	Window:ChangeColor(Color)
end)
CustomUIColor:UpdateColor(Config.Color)
local CustomBG = UISettings:CreateTextBox("Background Image", "2151741365", false, function(x)
	menusettings.CustomBG = x
end)
CustomBG:AddToolTip("Import a roblox decal ID here")
CustomBG:SetState("2151741365")
local SetCustomBG = UISettings:CreateButton("Set Background", function()
	local MarketPlace = game:GetService("MarketplaceService")
	local decalInfo = MarketPlace:GetProductInfo(tonumber(CustomBG:GetValue()))
	for i = decalInfo.AssetId - 15, decalInfo.AssetId + 1 do
		local info = MarketPlace:GetProductInfo(i)
		if info.Creator.Name == decalInfo.Creator.Name and info.Name == decalInfo.Name and info.AssetTypeId == 1 then
			Window:SetBackground(tostring(i))
		end
	end
end)
local CustomBGColor = UISettings:CreateColorpicker("Background Color", function(Color)
	menusettings.CustomBGColor = Color
	Window:SetBackgroundColor(Color)
end)
CustomBGColor:UpdateColor(Color3.new(1, 1, 1))
local CustomBGScale = UISettings:CreateSlider("Tile Scale", 0, 1, nil, false, function(Value)
	menusettings.CustomBGColor = Value
	Window:SetTileScale(Value)
end)
CustomBGScale:SetState(1)

local SaveSettings = ScriptSettings:CreateButton("Save Settings", function()
	local ToHSV = Color3.new().ToHSV
	local ValuesToEncode = deepsearchset(menusettings, function(i, v)
		return typeof(v) == 'Color3'
	end, function(i, v)
		local H, S, V = ToHSV(v);
		return {H, S, V, "Color3"}
	end)
	local Data = game:service'HttpService'.JSONEncode(game:service'HttpService', ValuesToEncode);
	writefile("kanner.settings", Data);
end)

local LoadSettings = ScriptSettings:CreateButton("Load Settings", function()
	local Success, Data = pcall(game:service'HttpService'.JSONDecode, game:service'HttpService', readfile("kanner.settings"));
	if (not Success or type(Data) ~= 'table') then
		rconsoleprint('a')
		return Values
	end
	local bsettings = deepsearchset(Data, function(i, v)
		return type(v) == 'table' and #v == 4 and v[4] == "Color3"
	end, function(i,v)
		return Color3.fromHSV(v[1], v[2], v[3]);
	end)
	AntiStun:SetState(bsettings.AntiStun)
	AntiFire:SetState(bsettings.AntiFire)
	AutoBard:SetState(bsettings.AutoBard)
	AutoTrainClimb:SetState(bsettings.AutoTrainClimb)
	AutoTrainMana:SetState(bsettings.AutoTrainMana)
	AntiDebuff:SetState(bsettings.AntiDebuff)
	PickUpIngredients:SetState(bsettings.PickUpIngredients)
	IngredientDelay:SetState(bsettings.IngredientDelay)

	PlayerESPToggle:SetState(bsettings.PlayerESPToggle)
	PlayerESPColor:UpdateColor(bsettings.PlayerESPColor)
	PlayerESPSize:SetState(bsettings.PlayerESPSize)
	PlayerESPDelay:SetState(bsettings.PlayerESPDelay)
	ShowDistance:SetState(bsettings.ShowDistance)
	ShowHealth:SetState(bsettings.ShowHealth)
	UseRogueName:SetState(bsettings.UseRogueName)
	ShowClass:SetState(bsettings.ShowClass)
	ShowItems:SetState(bsettings.ShowItems)
	TrinketESPToggle:SetState(bsettings.TrinketESPToggle)
	TrinketESPSize:SetState(bsettings.TrinketESPSize)
	TrinketESPDelay:SetState(bsettings.TrinketESPDelay)
	ShowTrinketDistance:SetState(bsettings.ShowTrinketDistance)
	CommonTrinkets:SetState(bsettings.CommonTrinkets)
	RareTrinkets:SetState(bsettings.RareTrinkets)
	Artifacts:SetState(bsettings.Artifacts)

	--Sensory
	SigmaMan:SetState(bsettings.SigmaMan)
	Brightness:SetState(bsettings.Brightness)
	BrightValue:SetState(bsettings.BrightValue)
	AntiFog:SetState(bsettings.AntiFog)
	WorldAmbience:SetState(bsettings.WorldAmbience)
	InteriorAmbience:UpdateColor(bsettings.InteriorAmbience)
	OutdoorAmbience:UpdateColor(bsettings.OutdoorAmbience)
	BetterLighting:SetState(bsettings.BetterLighting)

	-- Movement
	Flight:SetState(bsettings.Flight)
	KnockedOwnership:SetState(bsettings.KnockedOwnership)
	FlightFollowMouse:SetState(bsettings.FlightFollowMouse)
	DisableFlyFall:SetState(bsettings.DisableFlyFall)
	FlightBypassOne:SetState(bsettings.FlightBypassOne)
	FlightBypassTwo:SetState(bsettings.FlightBypassTwo)
	FlightSpeed:SetState(bsettings.FlightSpeed)

	-- Other
	WalkspeedToggle:SetState(bsettings.WalkspeedToggle)
	--WalkspeedValue:SetState(bsettings.WalkspeedValue)
	SpiderMode:SetState(bsettings.SpiderMode)
	AntiFall:SetState(bsettings.AntiFall)
	AutoSprint:SetState(bsettings.AutoSprint)

	-- Settings
	CustomUIColor:UpdateColor(bsettings.CustomUIColor)
	CustomBG:SetState(bsettings.CustomBG)
	--CustomBGColor:UpdateColor(bsettings.CustomBGColor)
	CustomBGScale:SetState(bsettings.CustomBGScale)
end)

local MakeSpeedObj = function()
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Boosts") then
		SpeedObject = Instance.new("IntValue")
		SpeedObject.Name = "SpeedBoost"
		SpeedObject.Value = 0
		SpeedObject.Parent = game.Players.LocalPlayer.Character.Boosts
	end
end
if LocalPlayer.Character then
	SpeedObject = nil
	MakeSpeedObj()
	LocalPlayer.Character.ChildAdded:Connect(function(v)
		RunService.RenderStepped:Wait()
		if AntiStun:GetValue() and v and Stuns[v.Name] and not LocalPlayer.Character:FindFirstChild("Knocked") then
			v:Destroy()
		end
		if AntiFire:GetValue() and v and v.Name == "Burning" and dodgeremote and not LocalPlayer.Character:FindFirstChild("Knocked") then
			local dodgeargs = {[1] = {[1] = 4,[2] = math.random()}}
			dodgeremote:FireServer(unpack(dodgeargs))
		end
	end)
	repeat wait() until LocalPlayer.Character:FindFirstChild("Boosts")
	LocalPlayer.Character.Boosts.ChildAdded:Connect(function(v)
		wait(4)
		if AntiDebuff:GetValue() and v and v.Name == "SpeedBoost" and v.Value < 0 then
			v.Value = 0
		end
	end)
end

LocalPlayer.CharacterAdded:Connect(function()
	dodgeremote = nil
	SpeedObject = nil
	LocalPlayer.Character.ChildAdded:Connect(function(v)
		RunService.RenderStepped:Wait()
		if AntiStun:GetValue() and v and Stuns[v.Name] and not LocalPlayer.Character:FindFirstChild("Knocked") then
			v:Destroy()
		end
		if AntiFire:GetValue() and v and v.Name == "Burning" and dodgeremote and not LocalPlayer.Character:FindFirstChild("Knocked") then
			local dodgeargs = {[1] = {[1] = 4,[2] = math.random()}}
			dodgeremote:FireServer(unpack(dodgeargs))
		end
	end)
	repeat wait() until LocalPlayer.Character:FindFirstChild("Boosts")
	MakeSpeedObj()
	LocalPlayer.Character.Boosts.ChildAdded:Connect(function(v)
		wait(4)
		if AntiDebuff:GetValue() and v and v.Name == "SpeedBoost" and v.Value < 0 then
			v.Value = 0
		end
	end)
end)

local Serverhop = ScriptSettings:CreateButton("Server Hop", function() -- too lazy to fix
	coroutine.wrap(function()
		if LocalPlayer.Character then
			repeat wait() until not LocalPlayer.Character:FindFirstChild'Danger'
		end
		game:GetService'TeleportService':Teleport(3016661674)
	end)()
end)

local InstantLog = ScriptSettings:CreateButton("Instant Log", function()
	coroutine.wrap(function()
		if LocalPlayer.Character then
			repeat wait() until not LocalPlayer.Character:FindFirstChild'Danger'
		end
		LocalPlayer:Kick('')
	end)()
end)

local selectedLabel
local selectedName
UserInputService.InputBegan:connect(function(Input, proccessed)
	local KeyCode = Input.KeyCode
	local MouseInput = Input.UserInputType
	for i, v in pairs(LocalPlayer.PlayerGui.LeaderboardGui.MainFrame.ScrollingFrame:GetChildren()) do
		if v then
			v.MouseEnter:Connect(function()
				selectedLabel = v
			end)
			v.MouseLeave:Connect(function()
				if selectedLabel == v then
					selectedLabel = nil
				end
			end)
		end
	end
	if MouseInput == Enum.UserInputType.MouseButton1 then
		if selectedLabel then
			local selectedName = ""
			selectedName = string.sub(selectedLabel.Text, 1, 2) .. string.sub(selectedLabel.Text, 6, #selectedLabel.Text)
			if game.Players:FindFirstChild(selectedName) ~= nil and game.Players:FindFirstChild(selectedName).Character ~= nil and game.Players:FindFirstChild(selectedName).Character.Humanoid ~= nil then
				workspace.CurrentCamera.CameraSubject = game.Players:FindFirstChild(selectedName).Character.Humanoid
			end
		else
			if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
				workspace.CurrentCamera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			end
		end
	end
end)

local ModSound = Instance.new("Sound")
ModSound.SoundId = "rbxassetid://7463103082"
ModSound.Volume = 10
ModSound.Parent = ProtGui
ModSound.Loaded:wait()

for i, player in pairs (Players:GetChildren()) do
	if player and player:IsA("Player") then
		if modlist[player.UserId] then
			Alert('MOD DETECTED', player.Name .. ' IS A MOD!')
			Flight:SetState(false)
			ModSound:Play()
        end
		player.Chatted:connect(function(msg)
			PChatlogs:AddChat(player, msg)
		end)
	end
end
Players.PlayerAdded:Connect(function(player)
	if player and player:IsA("Player") then
		if modlist[player.UserId] then
			Alert('MOD DETECTED', player.Name .. ' IS A MOD!')
			Flight:SetState(false)
			ModSound:Play()
        end
		player.Chatted:connect(function(msg)
			PChatlogs:AddChat(player, msg)
		end)
	end
end)