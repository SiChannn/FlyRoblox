local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Settings = {
    Speed = 100,
    FlightBind = Enum.KeyCode.F,
    GUIBind = Enum.KeyCode.RightControl
}

local Flight = {
    Active = false,
    BodyVelocity = nil,
    BodyGyro = nil,
    OriginalGravity = nil
}

local rebindingFlight = false
local rebindingGUI = false

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local SpeedLabel = Instance.new("TextLabel")
local SpeedBox = Instance.new("TextBox")
local ToggleText = Instance.new("TextLabel")
local FlightBindButton = Instance.new("TextButton")
local FlightBindStatus = Instance.new("TextLabel")
local GUIBindButton = Instance.new("TextButton")
local GUIBindStatus = Instance.new("TextLabel")

ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Name = "FlightGUI"
ScreenGui.ResetOnSpawn = false

MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BackgroundTransparency = 0.3
MainFrame.BorderColor3 = Color3.fromRGB(0, 255, 100)
MainFrame.BorderSizePixel = 2
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -90)
MainFrame.Size = UDim2.new(0, 200, 0, 180)
MainFrame.ClipsDescendants = false

local corner = Instance.new("UICorner")
corner.Parent = MainFrame
corner.CornerRadius = UDim.new(0, 12)

Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
Title.BackgroundTransparency = 0.4
Title.BorderSizePixel = 0
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.GothamBold
Title.Text = "Fly - by SiChan"
Title.TextColor3 = Color3.fromRGB(0, 255, 100)
Title.TextSize = 14

local titleCorner = Instance.new("UICorner")
titleCorner.Parent = Title
titleCorner.CornerRadius = UDim.new(0, 12)

local dragEnabled = false
local dragStartPos
local dragStartMouse

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragEnabled = true
        dragStartPos = MainFrame.Position
        dragStartMouse = input.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragEnabled and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStartMouse
        MainFrame.Position = UDim2.new(dragStartPos.X.Scale, dragStartPos.X.Offset + delta.X, dragStartPos.Y.Scale, dragStartPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragEnabled = false
    end
end)

SpeedLabel.Parent = MainFrame
SpeedLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Position = UDim2.new(0.1, 0, 0.32, 0)
SpeedLabel.Size = UDim2.new(0.3, 0, 0, 22)
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.Text = "SPEED"
SpeedLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
SpeedLabel.TextSize = 12
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left

SpeedBox.Parent = MainFrame
SpeedBox.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
SpeedBox.BackgroundTransparency = 0.3
SpeedBox.BorderSizePixel = 0
SpeedBox.Position = UDim2.new(0.6, 0, 0.32, 0)
SpeedBox.Size = UDim2.new(0.3, 0, 0, 22)
SpeedBox.Font = Enum.Font.GothamBold
SpeedBox.Text = "100"
SpeedBox.TextColor3 = Color3.fromRGB(0, 255, 100)
SpeedBox.TextSize = 12
SpeedBox.TextXAlignment = Enum.TextXAlignment.Center

local speedCorner = Instance.new("UICorner")
speedCorner.Parent = SpeedBox
speedCorner.CornerRadius = UDim.new(0, 6)

SpeedBox.FocusLost:Connect(function(enterPressed)
    local newSpeed = tonumber(SpeedBox.Text)
    if newSpeed then
        newSpeed = math.clamp(newSpeed, 10, 1000)
        Settings.Speed = newSpeed
        SpeedBox.Text = tostring(newSpeed)
    else
        SpeedBox.Text = tostring(Settings.Speed)
    end
end)

ToggleText.Parent = MainFrame
ToggleText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleText.BackgroundTransparency = 1
ToggleText.Position = UDim2.new(0.1, 0, 0.52, 0)
ToggleText.Size = UDim2.new(0.8, 0, 0, 18)
ToggleText.Font = Enum.Font.GothamBold
ToggleText.Text = "FLIGHT CONTROLS"
ToggleText.TextColor3 = Color3.fromRGB(0, 255, 100)
ToggleText.TextSize = 10

FlightBindButton.Parent = MainFrame
FlightBindButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
FlightBindButton.BackgroundTransparency = 0.3
FlightBindButton.BorderSizePixel = 0
FlightBindButton.Position = UDim2.new(0.1, 0, 0.65, 0)
FlightBindButton.Size = UDim2.new(0.35, 0, 0, 24)
FlightBindButton.Font = Enum.Font.Gotham
FlightBindButton.Text = "FLIGHT"
FlightBindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlightBindButton.TextSize = 11

local flightCorner = Instance.new("UICorner")
flightCorner.Parent = FlightBindButton
flightCorner.CornerRadius = UDim.new(0, 6)

FlightBindStatus.Parent = MainFrame
FlightBindStatus.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
FlightBindStatus.BackgroundTransparency = 0.3
FlightBindStatus.BorderSizePixel = 0
FlightBindStatus.Position = UDim2.new(0.55, 0, 0.65, 0)
FlightBindStatus.Size = UDim2.new(0.35, 0, 0, 24)
FlightBindStatus.Font = Enum.Font.Gotham
FlightBindStatus.Text = "F"
FlightBindStatus.TextColor3 = Color3.fromRGB(0, 255, 100)
FlightBindStatus.TextSize = 11

local flightStatusCorner = Instance.new("UICorner")
flightStatusCorner.Parent = FlightBindStatus
flightStatusCorner.CornerRadius = UDim.new(0, 6)

GUIBindButton.Parent = MainFrame
GUIBindButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
GUIBindButton.BackgroundTransparency = 0.3
GUIBindButton.BorderSizePixel = 0
GUIBindButton.Position = UDim2.new(0.1, 0, 0.82, 0)
GUIBindButton.Size = UDim2.new(0.35, 0, 0, 24)
GUIBindButton.Font = Enum.Font.Gotham
GUIBindButton.Text = "GUI"
GUIBindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
GUIBindButton.TextSize = 11

local guiCorner = Instance.new("UICorner")
guiCorner.Parent = GUIBindButton
guiCorner.CornerRadius = UDim.new(0, 6)

GUIBindStatus.Parent = MainFrame
GUIBindStatus.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
GUIBindStatus.BackgroundTransparency = 0.3
GUIBindStatus.BorderSizePixel = 0
GUIBindStatus.Position = UDim2.new(0.55, 0, 0.82, 0)
GUIBindStatus.Size = UDim2.new(0.35, 0, 0, 24)
GUIBindStatus.Font = Enum.Font.Gotham
GUIBindStatus.Text = "RCTRL"
GUIBindStatus.TextColor3 = Color3.fromRGB(0, 255, 100)
GUIBindStatus.TextSize = 10

local guiStatusCorner = Instance.new("UICorner")
guiStatusCorner.Parent = GUIBindStatus
guiStatusCorner.CornerRadius = UDim.new(0, 6)

local function updateBindDisplays()
    local flightName = tostring(Settings.FlightBind):gsub("Enum.KeyCode.", "")
    local guiName = tostring(Settings.GUIBind):gsub("Enum.KeyCode.", "")
    if flightName == "F" then flightName = "F" end
    if guiName == "RightControl" then guiName = "RCTRL" end
    FlightBindStatus.Text = flightName
    GUIBindStatus.Text = guiName
end

local function enableFlight()
    if not LocalPlayer.Character then return end
    local char = LocalPlayer.Character
    local humanoid = char:FindFirstChild("Humanoid")
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end
    
    if Flight.Active then
        if Flight.BodyVelocity then Flight.BodyVelocity:Destroy() end
        if Flight.BodyGyro then Flight.BodyGyro:Destroy() end
        
        humanoid.PlatformStand = false
        humanoid.AutoRotate = true
        if Flight.OriginalGravity then
            workspace.Gravity = Flight.OriginalGravity
        end
        
        Flight.Active = false
    else
        Flight.OriginalGravity = workspace.Gravity
        workspace.Gravity = 0
        
        Flight.BodyVelocity = Instance.new("BodyVelocity")
        Flight.BodyVelocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        Flight.BodyVelocity.P = 1e5
        Flight.BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        Flight.BodyVelocity.Parent = rootPart
        
        Flight.BodyGyro = Instance.new("BodyGyro")
        Flight.BodyGyro.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
        Flight.BodyGyro.P = 1e5
        Flight.BodyGyro.D = 500
        Flight.BodyGyro.CFrame = rootPart.CFrame
        Flight.BodyGyro.Parent = rootPart
        
        humanoid.AutoRotate = false
        humanoid.PlatformStand = true
        
        Flight.Active = true
    end
end

local function updateFlight()
    if not Flight.Active then return end
    if not LocalPlayer.Character then 
        enableFlight()
        return 
    end
    
    local char = LocalPlayer.Character
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChild("Humanoid")
    if not rootPart or not humanoid then return end
    
    local moveDirection = Vector3.new(0, 0, 0)
    
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + Vector3.new(0, 0, -1) end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection + Vector3.new(0, 0, 1) end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection + Vector3.new(-1, 0, 0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + Vector3.new(1, 0, 0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0, 1, 0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDirection = moveDirection + Vector3.new(0, -1, 0) end
    
    local cameraCFrame = workspace.CurrentCamera.CFrame
    local forward = cameraCFrame.LookVector
    local right = cameraCFrame.RightVector
    local up = cameraCFrame.UpVector
    
    local targetVelocity = Vector3.new(0, 0, 0)
    
    if moveDirection.Magnitude > 0 then
        moveDirection = moveDirection.Unit
        targetVelocity = (right * moveDirection.X + up * moveDirection.Y + forward * -moveDirection.Z) * Settings.Speed
    end
    
    Flight.BodyVelocity.Velocity = targetVelocity
    
    local targetCFrame = CFrame.new(rootPart.Position, rootPart.Position + forward) * CFrame.Angles(0, 0, 0)
    Flight.BodyGyro.CFrame = targetCFrame
    
    humanoid.AutoRotate = false
end

local function startRebind(bindType)
    if bindType == "flight" then
        rebindingFlight = true
        FlightBindButton.Text = "..."
        FlightBindButton.BackgroundColor3 = Color3.fromRGB(150, 100, 50)
    elseif bindType == "gui" then
        rebindingGUI = true
        GUIBindButton.Text = "..."
        GUIBindButton.BackgroundColor3 = Color3.fromRGB(150, 100, 50)
    end
end

local function finishRebind(bindType, keyCode)
    if bindType == "flight" then
        rebindingFlight = false
        if keyCode then
            Settings.FlightBind = keyCode
        end
        FlightBindButton.Text = "FLIGHT"
        FlightBindButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    elseif bindType == "gui" then
        rebindingGUI = false
        if keyCode then
            Settings.GUIBind = keyCode
        end
        GUIBindButton.Text = "GUI"
        GUIBindButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    end
    updateBindDisplays()
end

FlightBindButton.MouseButton1Click:Connect(function()
    if rebindingFlight then
        finishRebind("flight", nil)
    else
        startRebind("flight")
    end
end)

GUIBindButton.MouseButton1Click:Connect(function()
    if rebindingGUI then
        finishRebind("gui", nil)
    else
        startRebind("gui")
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if rebindingFlight and input.KeyCode ~= Enum.KeyCode.Unknown then
        finishRebind("flight", input.KeyCode)
    end
    if rebindingGUI and input.KeyCode ~= Enum.KeyCode.Unknown then
        finishRebind("gui", input.KeyCode)
    end
    
    if gameProcessed then return end
    if not rebindingFlight and not rebindingGUI then
        if input.KeyCode == Settings.FlightBind then
            enableFlight()
        end
        if input.KeyCode == Settings.GUIBind then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end
end)

RunService.RenderStepped:Connect(updateFlight)

LocalPlayer.CharacterAdded:Connect(function()
    if Flight.Active then
        if Flight.BodyVelocity then Flight.BodyVelocity:Destroy() end
        if Flight.BodyGyro then Flight.BodyGyro:Destroy() end
        Flight.Active = false
        if Flight.OriginalGravity then
            workspace.Gravity = Flight.OriginalGravity
        end
    end
    Flight.BodyVelocity = nil
    Flight.BodyGyro = nil
end)

updateBindDisplays()
