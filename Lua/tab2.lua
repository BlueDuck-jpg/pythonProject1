local lib = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CloseBind = Enum.KeyCode.Equals

local function MakeDraggable(topbarobject, object)
	local Dragging = nil
	local DragInput = nil
	local DragStart = nil
	local StartPosition = nil

	local function Update(input)
		local Delta = input.Position - DragStart
		local pos =
			UDim2.new(
				StartPosition.X.Scale,
				StartPosition.X.Offset + Delta.X,
				StartPosition.Y.Scale,
				StartPosition.Y.Offset + Delta.Y
			)
		object.Position = pos
	end

	topbarobject.InputBegan:Connect(
		function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				Dragging = true
				DragStart = input.Position
				StartPosition = object.Position

				input.Changed:Connect(
					function()
						if input.UserInputState == Enum.UserInputState.End then
							Dragging = false
						end
					end
				)
			end
		end
	)

	topbarobject.InputChanged:Connect(
		function(input)
			if
				input.UserInputType == Enum.UserInputType.MouseMovement or
					input.UserInputType == Enum.UserInputType.Touch
			then
				DragInput = input
			end
		end
	)

	UserInputService.InputChanged:Connect(
		function(input)
			if input == DragInput and Dragging then
				Update(input)
			end
		end
	)
end

function lib:Window(text, closebind)
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Parent = game.CoreGui
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.DisplayOrder = 1928310298
	ScreenGui.Name = text 

	CloseBind = closebind or Enum.KeyCode.Equals
	fs = false
	local Main = Instance.new("Frame")
	local TabHolder = Instance.new("Frame")
	local TabFolder = Instance.new("Folder")
	local TabHoldList = Instance.new("UIListLayout")
	local MainHider = Instance.new("Frame")
	local TabHider = Instance.new("Frame")
	local Title = Instance.new("TextLabel")

	Main.Name = "Main"
	Main.Parent = ScreenGui
	Main.BackgroundColor3 = Color3.fromRGB(49, 53, 58)
	Main.BorderSizePixel = 0
	Main.Position = UDim2.new(0.0400000028, 0, 0.112000018, 0)
	Main.Selectable = true
	Main.Size = UDim2.new(0, 704,0, 462)

	TabHolder.Name = "TabHolder"
	TabHolder.Parent = Main
	TabHolder.BackgroundColor3 = Color3.fromRGB(47, 49, 53)
	TabHolder.BorderSizePixel = 0
	TabHolder.Position = UDim2.new(0, 0, 0.186208814, 0)
	TabHolder.Size = UDim2.new(0, 204,0, 376)
	TabHolder.ZIndex = 4

	TabHoldList.Parent = TabHolder
	TabHoldList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	TabHoldList.SortOrder = Enum.SortOrder.LayoutOrder

	MainHider.Name = "MainHider"
	MainHider.Parent = Main
	MainHider.BackgroundColor3 = Color3.fromRGB(49, 53, 58)
	MainHider.BorderSizePixel = 0
	MainHider.Position = UDim2.new(0.289978713, 0, -0.0781737342, 0)
	MainHider.Size = UDim2.new(0, 500,0, 37)
	MainHider.ZIndex = 4

	TabHider.Name = "TabHider"
	TabHider.Parent = Main
	TabHider.BackgroundColor3 = Color3.fromRGB(47, 49, 53)
	TabHider.BorderSizePixel = 0
	TabHider.Position = UDim2.new(0,0,0,-36)
	TabHider.Size = UDim2.new(0, 204,0, 122)
	TabHider.ZIndex = 4

	Title.Parent = TabHider
	Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Title.BackgroundTransparency = 1.000
	Title.Position = UDim2.new(0.0292563029, 0, 0.107317001, 0)
	Title.Size = UDim2.new(0, 186, 0, 99)
	Title.Font = Enum.Font.Gotham
	Title.Text = text
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.TextScaled = true
	Title.TextSize = 14.000
	Title.TextWrapped = true

	TabHoldList.Parent = TabHolder
	TabHoldList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	TabHoldList.SortOrder = Enum.SortOrder.LayoutOrder

	MakeDraggable(MainHider, Main)

	local enabled = true

	UserInputService.InputBegan:Connect(function(input, istyping)
		if input.KeyCode == CloseBind then
			enabled = not enabled
			ScreenGui.Enabled = enabled
		end
	end)

	TabFolder.Name = "TabFolder"
	TabFolder.Parent = Main

	function lib:createNotification(Title, Text, Duration)
		game.StarterGui:SetCore("SendNotification", {
			Title = Title,
			Text = Text,
			Duration = Duration
		}) 
	end

	local tabhold = {}
	function tabhold:Tab(text)
		local TabBtn = Instance.new("TextButton")

		TabBtn.Name = "TabBtn"
		TabBtn.Parent = TabHolder
		TabBtn.BackgroundColor3 = Color3.fromRGB(47, 49, 53)
		TabBtn.BorderSizePixel = 0
		TabBtn.Position = UDim2.new(0.00106390193, 0, 0, 0)
		TabBtn.Size = UDim2.new(0, 204, 0, 50)
		TabBtn.Font = Enum.Font.Gotham
		TabBtn.Text = text
		TabBtn.TextColor3 = Color3.fromRGB(191, 193, 194)
		TabBtn.TextSize = 17.000

		local Tab = Instance.new("ScrollingFrame")
		local TabList = Instance.new("UIListLayout")

		Tab.Name = "Tab"
		Tab.Parent = TabFolder
		Tab.Active = true
		Tab.BackgroundColor3 = Color3.fromRGB(49, 53, 58)
		Tab.BorderSizePixel = 0
		Tab.Position = UDim2.new(0.288968325, 0, -0.0019069314, 0)
		Tab.Selectable = false
		Tab.Size = UDim2.new(0, 500, 0, 462)
		Tab.Visible = false
		Tab.ZIndex = 4
		Tab.ScrollBarThickness = 4

		TabList.Parent = Tab
		TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
		TabList.SortOrder = Enum.SortOrder.LayoutOrder
		TabList.Padding = UDim.new(0, 15)

		TabBtn.MouseButton1Click:Connect(function()
			for i, v in next, TabFolder:GetChildren() do
				if v.Name == "Tab" then
					v.Visible = false
				end
				Tab.Visible = true
			end
			for i, v in next, TabHolder:GetChildren() do
				if v.Name == "TabBtn" then
					TweenService:Create(
						v,
						TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{TextColor3 = Color3.fromRGB(191, 193, 194)}
					):Play()
					TweenService:Create(
						v,
						TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{BackgroundColor3 = Color3.fromRGB(47, 49, 53)}
					):Play()
					TweenService:Create(
						TabBtn,
						TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{TextColor3 = Color3.fromRGB(255,255,255)}
					):Play()
					TweenService:Create(
						TabBtn,
						TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{BackgroundColor3 = Color3.fromRGB(66, 133, 254)}
					):Play()
				end
			end
		end)

		local function Resize()
			Tab.CanvasSize = UDim2.new(0, 0, 0, TabList.AbsoluteContentSize.Y)
		end

		local tabcontent = {}
		function tabcontent:Button(text, callback)
			local Button = Instance.new("TextButton")
			local ButtonConer = Instance.new("UICorner")
			local Circle = Instance.new("ImageLabel")
			local CircleCorner = Instance.new("UICorner")
			local ButtonTitle = Instance.new("TextLabel")

			Button.Name = "Button"
			Button.Parent = Tab
			Button.BackgroundColor3 = Color3.fromRGB(64, 68, 76)
			Button.Position = UDim2.new(0.0305498987, 0, 0.0413223132, 0)
			Button.Size = UDim2.new(0, 466,0, 45)
			Button.Font = Enum.Font.SourceSans
			Button.Text = ""
			Button.TextColor3 = Color3.fromRGB(255, 255, 255)
			Button.TextSize = 14.000

			ButtonConer.CornerRadius = UDim.new(0, 5)
			ButtonConer.Parent = Button

			Circle.Name = "Circle"
			Circle.Parent = Button
			Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Circle.Position = UDim2.new(0, 15,0, 16)
			Circle.Size = UDim2.new(0, 11,0, 11)
			Circle.Image = ""

			CircleCorner.Parent = Circle
			CircleCorner.CornerRadius = UDim.new(100,0)

			ButtonTitle.Parent = Button
			ButtonTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ButtonTitle.BackgroundTransparency = 1.000
			ButtonTitle.Position = UDim2.new(0, 38,0, 0)
			ButtonTitle.Size = UDim2.new(0, 427,0, 45)
			ButtonTitle.Font = Enum.Font.Gotham
			ButtonTitle.Text = text
			ButtonTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
			ButtonTitle.TextSize = 18.000
			ButtonTitle.TextXAlignment = Enum.TextXAlignment.Left

			Button.MouseButton1Click:Connect(function()
				pcall(callback)
			end)

			Resize()
		end
		function tabcontent:DestroyGui()
			local Button = Instance.new("TextButton")
			local ButtonConer = Instance.new("UICorner")
			local Circle = Instance.new("ImageLabel")
			local CircleCorner = Instance.new("UICorner")
			local ButtonTitle = Instance.new("TextLabel")

			Button.Name = "Button"
			Button.Parent = Tab
			Button.BackgroundColor3 = Color3.fromRGB(64, 68, 76)
			Button.Position = UDim2.new(0.0305498987, 0, 0.0413223132, 0)
			Button.Size = UDim2.new(0, 466,0, 45)
			Button.Font = Enum.Font.SourceSans
			Button.Text = ""
			Button.TextColor3 = Color3.fromRGB(255, 255, 255)
			Button.TextSize = 14.000

			ButtonConer.CornerRadius = UDim.new(0, 5)
			ButtonConer.Parent = Button

			Circle.Name = "Circle"
			Circle.Parent = Button
			Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Circle.Position = UDim2.new(0, 15,0, 16)
			Circle.Size = UDim2.new(0, 11,0, 11)
			Circle.Image = ""

			CircleCorner.Parent = Circle
			CircleCorner.CornerRadius = UDim.new(100,0)

			ButtonTitle.Parent = Button
			ButtonTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ButtonTitle.BackgroundTransparency = 1.000
			ButtonTitle.Position = UDim2.new(0, 38,0, 0)
			ButtonTitle.Size = UDim2.new(0, 427,0, 45)
			ButtonTitle.Font = Enum.Font.Gotham
			ButtonTitle.Text = "Destroy GUI"
			ButtonTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
			ButtonTitle.TextSize = 18.000
			ButtonTitle.TextXAlignment = Enum.TextXAlignment.Left

			Button.MouseButton1Click:Connect(function()
				ScreenGui:Destroy()
			end)
		end
		function tabcontent:Toggle(text, callback)
			local toggled = false

			local Toggle = Instance.new("TextButton")
			local ToggleCorner = Instance.new("UICorner")
			local ToggleBase = Instance.new("ImageLabel")
			local ToggleBaseCorner = Instance.new("UICorner")
			local ToggleTitle = Instance.new("TextLabel")
			local Circle = Instance.new("ImageLabel")
			local CircleCorner = Instance.new("UICorner")
			local ToggleImage = Instance.new("ImageLabel")
			local ToggleImageCorner = Instance.new("UICorner")

			Toggle.Name = "Toggle"
			Toggle.Parent = Tab
			Toggle.BackgroundColor3 = Color3.fromRGB(64, 68, 76)
			Toggle.Position = UDim2.new(0.0305498987, 0, 0.0413223132, 0)
			Toggle.Size = UDim2.new(0, 466,0, 45)
			Toggle.Font = Enum.Font.SourceSans
			Toggle.Text = ""
			Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
			Toggle.TextSize = 14.000

			ToggleCorner.CornerRadius = UDim.new(0, 5)
			ToggleCorner.Parent = Toggle

			ToggleBase.Name = "ToggleBase"
			ToggleBase.Parent = Toggle
			ToggleBase.BackgroundColor3 = Color3.fromRGB(221, 221, 221)
			ToggleBase.Position = UDim2.new(0, 371, 0, 13)
			ToggleBase.Size = UDim2.new(0, 60, 0, 20)

			ToggleBaseCorner.CornerRadius = UDim.new(100, 0)
			ToggleBaseCorner.Parent = ToggleBase

			ToggleTitle.Parent = Toggle
			ToggleTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ToggleTitle.BackgroundTransparency = 1.000
			ToggleTitle.Position = UDim2.new(0, 38,0, 0)
			ToggleTitle.Size = UDim2.new(0, 427,0, 45)
			ToggleTitle.Font = Enum.Font.Gotham
			ToggleTitle.Text = text
			ToggleTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
			ToggleTitle.TextSize = 18.000
			ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left

			Circle.Name = "Circle"
			Circle.Parent = Toggle
			Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Circle.Position = UDim2.new(0, 15,0, 16)
			Circle.Size = UDim2.new(0, 11,0, 11)

			CircleCorner.Parent = Circle
			CircleCorner.CornerRadius = UDim.new(100,0)

			ToggleImage.Name = "ToggleCircle"
			ToggleImage.Parent = Toggle
			ToggleImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ToggleImage.Position = UDim2.new(0, 374,0, 15)
			ToggleImage.Size = UDim2.new(0, 15,0, 15)

			ToggleImageCorner.Parent = ToggleImage
			ToggleImageCorner.CornerRadius = UDim.new(100, 0)

			Toggle.MouseButton1Click:Connect(function()
				if toggled == false then
					TweenService:Create(
						ToggleBase,
						TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{BackgroundColor3 = Color3.fromRGB(77, 209, 99)}
					):Play()
					ToggleImage:TweenPosition(UDim2.new(0, 413,0, 15), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.2, true)
				else
					TweenService:Create(
						ToggleBase,
						TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{BackgroundColor3 = Color3.fromRGB(221, 221, 221)}
					):Play()
					ToggleImage:TweenPosition(UDim2.new(0, 374,0, 15), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.2, true)
				end
				toggled = not toggled
				pcall(callback, toggled)
			end)

			Resize()
		end
		function tabcontent:Slider(text, min,max,start, callback)
			local dragging = false
			local Slider = Instance.new("Frame")
			local SliderCorner = Instance.new("UICorner")
			local SliderCircle = Instance.new("ImageButton")
			local SliderCircleCorner = Instance.new("UICorner")
			local Circle = Instance.new("ImageLabel")
			local CircleCornr = Instance.new("UICorner")
			local SliderBase = Instance.new("ImageLabel")
			local SliderTitle = Instance.new("TextLabel")
			local SliderValue = Instance.new("TextLabel")
			local CurrentSliderValue = Instance.new("ImageLabel")
			local UICORNER = Instance.new("UICorner")
			local cornerbase = Instance.new("UICorner")
			local cornerlol = Instance.new("UICorner")

			Slider.Name = "Slider"
			Slider.Parent = Tab
			Slider.BackgroundColor3 = Color3.fromRGB(64, 68, 76)
			Slider.Position = UDim2.new(0.034499988, 0, 0, 0)
			Slider.Size = UDim2.new(0,466,0,45)

			SliderCorner.CornerRadius = UDim.new(0, 5)
			SliderCorner.Parent = Slider

			SliderCircle.Name = "SliderCircle"
			SliderCircle.Parent = SliderBase
			SliderCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SliderCircle.Position = UDim2.new((start or 0)/max, -5,0,-2)
			SliderCircle.Size = UDim2.new(0,23,0,23)
			SliderCircle.ZIndex = 2
			SliderCircle.ImageTransparency = 1.000

			SliderCircleCorner.CornerRadius = UDim.new(10000, 0)
			SliderCircleCorner.Parent = SliderCircle

			Circle.Name = "Circle"
			Circle.Parent = Slider
			Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Circle.Position = UDim2.new(0,15,0,16)
			Circle.Size = UDim2.new(0,11,0,11)

			CircleCornr.Parent = Circle
			CircleCornr.CornerRadius = UDim.new(100,0)

			SliderBase.Name = "SliderBase"
			SliderBase.Parent = Slider
			SliderBase.BackgroundColor3 = Color3.fromRGB(221,221,221)
			SliderBase.Position = UDim2.new(0, 100, 0, 13)
			SliderBase.Size = UDim2.new(0, 290, 0, 20)
			SliderBase.BorderSizePixel = 0

			cornerbase.Parent = SliderBase
			cornerbase.CornerRadius = UDim.new(100,0)

			SliderTitle.Parent = Slider
			SliderTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SliderTitle.BackgroundTransparency = 1.000
			SliderTitle.Position = UDim2.new(0,38,0,0)
			SliderTitle.Size = UDim2.new(0,427,0,45)
			SliderTitle.Font = Enum.Font.Gotham
			SliderTitle.Text = text
			SliderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
			SliderTitle.TextSize = 18.000
			SliderTitle.TextXAlignment = Enum.TextXAlignment.Left

			SliderValue.Name = "SliderValue"
			SliderValue.Parent = Slider
			SliderValue.BackgroundColor3 = Color3.fromRGB(53, 55, 63)
			SliderValue.BorderSizePixel = 0
			SliderValue.Position = UDim2.new(0,418,0,7)
			SliderValue.Size = UDim2.new(0, 39, 0, 31)
			SliderValue.Font = Enum.Font.SourceSans
			SliderValue.Text = tostring(start and math.floor((start / max) * (max - min) + min) or 0)
			SliderValue.TextColor3 = Color3.fromRGB(255, 255, 255)
			SliderValue.TextScaled = true
			SliderValue.TextSize = 14.000
			SliderValue.TextWrapped = true

			UICORNER.Parent = SliderValue
			UICORNER.CornerRadius = UDim.new(0,5)

			CurrentSliderValue.Name = "CurrentSliderValue"
			CurrentSliderValue.Parent = SliderBase
			CurrentSliderValue.BackgroundColor3 = Color3.fromRGB(77, 209, 99)
			CurrentSliderValue.BorderSizePixel = 0
			CurrentSliderValue.Position = UDim2.new(0, 0, 0, 0)
			CurrentSliderValue.Size = UDim2.new((start or 0) / max + 0.04, 0, 0, 20)
			CurrentSliderValue.BorderSizePixel = 0
			
			cornerlol.Parent = CurrentSliderValue
			cornerlol.CornerRadius = UDim.new(100,0)

			local function move(input)
				local pos =
					UDim2.new(
						math.clamp((input.Position.X - SliderBase.AbsolutePosition.X) / SliderBase.AbsoluteSize.X, 0, 1),
						-5,
						0,
						-2
					)
				local pos1 =
					UDim2.new(
						math.clamp((input.Position.X - SliderBase.AbsolutePosition.X) / SliderBase.AbsoluteSize.X + 0.04, 0, 1),
						0,
						0,
						20
					)
				CurrentSliderValue:TweenSize(pos1, "Out", "Sine", 0.1, true)
				SliderCircle:TweenPosition(pos, "Out", "Sine", 0.1, true)
				local value = math.floor(((pos.X.Scale * max) / max) * (max - min) + min)
				SliderValue.Text = tostring(value)
				pcall(callback, value)
			end

			local UserInputService = game:GetService("UserInputService")

			SliderCircle.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = true
				end
			end)
			SliderCircle.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = false
				end
			end)
			game:GetService("UserInputService").InputChanged:Connect(function(input)
				if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					move(input)
				end
			end)

			Resize()
		end
		function tabcontent:Dropdown(text, list, callback)
			local droptog = false
			local framesize = 0
			local itemcount = 0

			local Dropdown = Instance.new("Frame")
			local Arrow = Instance.new("ImageLabel")
			local DropdownCorner = Instance.new("UICorner")
			local Circle = Instance.new("ImageLabel")
			local CircleCorner = Instance.new("UICorner")
			local Title = Instance.new("TextLabel")
			local DropdownHolder = Instance.new("ScrollingFrame")
			local DropdownList = Instance.new("UIListLayout")
			local DropdownButton = Instance.new("TextButton")

			Dropdown.Name = "Dropdown"
			Dropdown.Parent = Tab
			Dropdown.BackgroundColor3 = Color3.fromRGB(64, 68, 76)
			Dropdown.Size = UDim2.new(0, 466,0, 45)

			Arrow.Name = "Arrow"
			Arrow.Parent = Title
			Arrow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Arrow.BackgroundTransparency = 1.000
			Arrow.BorderColor3 = Color3.fromRGB(27, 42, 53)
			Arrow.Position = UDim2.new(0, 375, 0, 6)
			Arrow.Rotation = 270
			Arrow.Size = UDim2.new(0, 32, 0, 30)
			Arrow.Image = "rbxassetid://6034818375"

			DropdownCorner.Parent = Dropdown
			DropdownCorner.CornerRadius = UDim.new(0,5)

			Circle.Name = "Circle"
			Circle.Parent = Dropdown
			Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Circle.Position = UDim2.new(0, 15, 0, 17)
			Circle.Size = UDim2.new(0, 10, 0, 11)

			CircleCorner.Parent = Circle
			CircleCorner.CornerRadius = UDim.new(100,0)

			Title.Parent = Dropdown
			Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Title.BackgroundTransparency = 1.000
			Title.Position = UDim2.new(0, 37, 0, 0)
			Title.Size = UDim2.new(0, 418,0, 46)
			Title.Font = Enum.Font.Gotham
			Title.Text = text
			Title.TextColor3 = Color3.fromRGB(255, 255, 255)
			Title.TextSize = 18.000
			Title.TextXAlignment = Enum.TextXAlignment.Left

			DropdownButton.Name = "DropdownButton"
			DropdownButton.Parent = Dropdown
			DropdownButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			DropdownButton.BackgroundTransparency = 1.000
			DropdownButton.Position = UDim2.new(0, 402, 0, 0)
			DropdownButton.Size = UDim2.new(0, 54, 0, 46)
			DropdownButton.Font = Enum.Font.SourceSans
			DropdownButton.Text = ""
			DropdownButton.TextColor3 = Color3.fromRGB(0, 0, 0)
			DropdownButton.TextSize = 14.000

			DropdownHolder.Name = "DropdownHolder"
			DropdownHolder.Parent = Title
			DropdownHolder.Active = true
			DropdownHolder.BackgroundColor3 = Color3.fromRGB(64, 68, 76)
			DropdownHolder.BorderSizePixel = 0
			DropdownHolder.Position = UDim2.new(0, -35,0, 40)
			DropdownHolder.Size = UDim2.new(0, 464,0, 112)
			DropdownHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
			DropdownHolder.ScrollBarThickness = 3
			DropdownHolder.Visible = false

			DropdownList.Parent = DropdownHolder
			DropdownList.HorizontalAlignment = Enum.HorizontalAlignment.Center
			DropdownList.SortOrder = Enum.SortOrder.LayoutOrder
			DropdownList.Padding = UDim.new(0, 5)

			DropdownButton.MouseButton1Click:Connect(function()
				if droptog == false then
					Dropdown:TweenSize(UDim2.new(0, 466,0, 45 + framesize), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.2, true)
					TweenService:Create(
						Arrow,
						TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{Rotation = 90}
					):Play()
					DropdownHolder.Visible = true
					wait(0.2)
					Resize()
				else
					Dropdown:TweenSize(UDim2.new(0, 466,0, 45), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .2, true)
					TweenService:Create(
						Arrow,
						TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{Rotation = 270}
					):Play()
					DropdownHolder.Visible = false
					wait(0.2)
					Resize()
				end
				droptog = not droptog
			end)

			for i,v in next, list do
				itemcount = itemcount + 1
				if itemcount <= 3 then
					framesize = framesize + 50
					DropdownHolder.Size = UDim2.new(0, 464, 0, framesize)
				end
				local Item = Instance.new("TextButton")
				local ItemCorner = Instance.new("UICorner")

				Item.Name = "Item"
				Item.Parent = DropdownHolder
				Item.BackgroundColor3 = Color3.fromRGB(55, 59, 66)
				Item.ClipsDescendants = true
				Item.Size = UDim2.new(0, 456, 0, 50)
				Item.Font = Enum.Font.Gotham
				Item.Text = v
				Item.TextColor3 = Color3.fromRGB(255, 255, 255)
				Item.TextSize = 20.000

				ItemCorner.CornerRadius = UDim.new(0, 4)
				ItemCorner.Name = "ItemCorner"
				ItemCorner.Parent = Item

				Item.MouseButton1Click:Connect(function()
					droptog = not droptog
					Title.Text = text .. " - " .. v
					pcall(callback, v)
					Dropdown:TweenSize(UDim2.new(0, 466,0, 45), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .2, true)
					TweenService:Create(
						Arrow,
						TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{Rotation = 270}
					):Play()
					DropdownHolder.Visible = false
					wait(0.2)
					Resize()
				end)

				DropdownHolder.CanvasSize = UDim2.new(0, 0, 0, DropdownList.AbsoluteContentSize.Y)
			end

			Resize()
		end
		function tabcontent:Textbox(text, placeholdertext, disappear, callback)
			local TextboxFrame = Instance.new("Frame")
			local TextboxFrameCorner = Instance.new("UICorner")
			local Circle = Instance.new("ImageLabel")
			local CircleCorner = Instance.new("UICorner")
			local Title = Instance.new("TextLabel")
			local TextBox = Instance.new("TextBox")
			local TextboxCorner = Instance.new("UICorner")

			TextboxFrame.Name = "Textbox"
			TextboxFrame.Parent = Tab
			TextboxFrame.BackgroundColor3 = Color3.fromRGB(64, 68, 76)
			TextboxFrame.Position = UDim2.new(0, 17, 0, 0)
			TextboxFrame.Size = UDim2.new(0, 466, 0, 45)

			TextboxFrameCorner.CornerRadius = UDim.new(0, 5)
			TextboxFrameCorner.Parent = TextboxFrame

			Circle.Name = "Circle"
			Circle.Parent = TextboxFrame
			Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Circle.Position = UDim2.new(0, 15, 0, 16)
			Circle.Size = UDim2.new(0, 11, 0, 11)

			CircleCorner.Parent = Circle
			CircleCorner.CornerRadius = UDim.new(100,0)

			Title.Parent = TextboxFrame
			Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Title.BackgroundTransparency = 1.000
			Title.Position = UDim2.new(0, 38, 0, 0)
			Title.Size = UDim2.new(0, 427, 0, 45)
			Title.Font = Enum.Font.Gotham
			Title.Text = text
			Title.TextColor3 = Color3.fromRGB(255, 255, 255)
			Title.TextSize = 18.000
			Title.TextXAlignment = Enum.TextXAlignment.Left

			TextBox.Parent = TextboxFrame
			TextBox.BackgroundColor3 = Color3.fromRGB(53, 56, 63)
			TextBox.Position = UDim2.new(0, 272, 0, 6)
			TextBox.Size = UDim2.new(0, 178, 0, 33)
			TextBox.Font = Enum.Font.Gotham
			TextBox.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
			TextBox.PlaceholderText = placeholdertext or ""
			TextBox.Text = ""
			TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextBox.TextScaled = true
			TextBox.TextSize = 14.000
			TextBox.TextWrapped = true

			TextboxCorner.CornerRadius = UDim.new(0, 5)
			TextboxCorner.Parent = TextBox

			TextBox.FocusLost:Connect(
				function(ep)
					if ep then
						if #TextBox.Text > 0 then
							pcall(callback, TextBox.Text)
							if disappear then
								TextBox.Text = ""
							end
						end
					end
				end
			)

			Resize()
		end
		function tabcontent:Label(text, textscaled)
			local LabelFrame = Instance.new("Frame")
			local FrameCorner = Instance.new("UICorner")
			local Circle = Instance.new("ImageLabel")
			local CircleCorner = Instance.new("UICorner")
			local Text = Instance.new("TextLabel")

			LabelFrame.Name = "Label"
			LabelFrame.Parent = Tab
			LabelFrame.BackgroundColor3 = Color3.fromRGB(64, 68, 76)
			LabelFrame.Position = UDim2.new(0, 17, 0, 0)
			LabelFrame.Size = UDim2.new(0, 466, 0, 45)

			FrameCorner.CornerRadius = UDim.new(0, 5)
			FrameCorner.Parent = LabelFrame

			Circle.Name = "Circle"
			Circle.Parent = LabelFrame
			Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Circle.Position = UDim2.new(0, 15, 0, 16)
			Circle.Size = UDim2.new(0, 11, 0, 11)

			CircleCorner.Parent = Circle
			CircleCorner.CornerRadius = UDim.new(100,0)

			Text.Parent = LabelFrame
			Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Text.BackgroundTransparency = 1.000
			Text.Position = UDim2.new(0, 38, 0, 0)
			Text.Size = UDim2.new(0, 427, 0, 45)
			Text.Font = Enum.Font.Gotham
			Text.Text = text
			Text.TextColor3 = Color3.fromRGB(255, 255, 255)
			Text.TextSize = 18.000
			Text.TextXAlignment = Enum.TextXAlignment.Left
			Text.TextScaled = textscaled

			Resize()
		end
		function tabcontent:Bind(text, keypreset, callback)
			local binding = false
			local Key = keypreset.Name
			local BindFrame = Instance.new("Frame")
			local FrameCorner = Instance.new("UICorner")
			local Circle = Instance.new("ImageLabel")
			local CircleCorner = Instance.new("UICorner")
			local Title = Instance.new("TextLabel")
			local KeyBindBox = Instance.new("TextBox")
			local BindCorner = Instance.new("UICorner")

			BindFrame.Name = "Bind"
			BindFrame.Parent = Tab
			BindFrame.BackgroundColor3 = Color3.fromRGB(64, 68, 76)
			BindFrame.Position = UDim2.new(0, 17, 0, 0)
			BindFrame.Size = UDim2.new(0, 466, 0, 45)

			FrameCorner.CornerRadius = UDim.new(0, 5)
			FrameCorner.Parent = BindFrame

			Circle.Name = "Circle"
			Circle.Parent = BindFrame
			Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Circle.Position = UDim2.new(0, 15, 0, 16)
			Circle.Size = UDim2.new(0, 11, 0, 11)

			CircleCorner.Parent = Circle
			CircleCorner.CornerRadius = UDim.new(100,0)

			Title.Parent = BindFrame
			Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Title.BackgroundTransparency = 1.000
			Title.Position = UDim2.new(0, 38, 0, 0)
			Title.Size = UDim2.new(0, 427, 0, 45)
			Title.Font = Enum.Font.Gotham
			Title.Text = text
			Title.TextColor3 = Color3.fromRGB(255, 255, 255)
			Title.TextSize = 18.000
			Title.TextXAlignment = Enum.TextXAlignment.Left

			KeyBindBox.Name = "KeyBindBox"
			KeyBindBox.Parent = BindFrame
			KeyBindBox.BackgroundColor3 = Color3.fromRGB(53, 56, 63)
			KeyBindBox.Position = UDim2.new(0, 329, 0, 6)
			KeyBindBox.Size = UDim2.new(0, 121, 0, 33)
			KeyBindBox.Font = Enum.Font.Gotham
			KeyBindBox.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
			KeyBindBox.PlaceholderText = Key
			KeyBindBox.Text = ""
			KeyBindBox.TextColor3 = Color3.fromRGB(255, 255, 255)
			KeyBindBox.TextScaled = true
			KeyBindBox.TextSize = 14.000
			KeyBindBox.TextWrapped = true

			BindCorner.CornerRadius = UDim.new(0, 5)
			BindCorner.Parent = KeyBindBox

			Resize()

			KeyBindBox.Focused:Connect(function()
				KeyBindBox.Text = "..."
				binding = true
				local inputwait = game:GetService("UserInputService").InputBegan:wait()
				if inputwait.KeyCode.Name ~= "Unknown" then
					KeyBindBox.Text = inputwait .KeyCode.Name
					Key = inputwait.KeyCode.Name
					binding = false
				else
					binding = false
				end
			end)

			game:GetService("UserInputService").InputBegan:Connect(function(current, pressed)
				if not pressed then
					if current.KeyCode.Name == Key and binding == false then
						pcall(callback)
					end
				end
			end)
		end
		return tabcontent
	end
	return tabhold
end
return lib