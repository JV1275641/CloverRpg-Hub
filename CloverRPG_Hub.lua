-- Clover RPG Inspired Hub | Original implementation
-- Client-side UI for environments that permit local scripts.
-- Does not reverse engineer Cerberus, call private remotes, or bypass protections.

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")

local previous = pg:FindFirstChild("CloverOriginalHub")
if previous then previous:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "CloverOriginalHub"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = pg

local function make(class, props, parent)
    local inst = Instance.new(class)
    for k, v in pairs(props) do inst[k] = v end
    inst.Parent = parent
    return inst
end
local function round(obj, r)
    make("UICorner", {CornerRadius = UDim.new(0, r)}, obj)
end
local COLORS = {
    bg = Color3.fromRGB(15, 17, 24),
    side = Color3.fromRGB(21, 24, 34),
    panel = Color3.fromRGB(28, 32, 44),
    accent = Color3.fromRGB(139, 96, 255),
    fg = Color3.fromRGB(238, 239, 247),
    muted = Color3.fromRGB(158, 163, 180),
}
local window = make("Frame", {
    Name="Window", Size=UDim2.fromOffset(640, 410),
    Position=UDim2.new(0.5, -320, 0.5, -205),
    BackgroundColor3=COLORS.bg, BorderSizePixel=0
}, gui)
round(window, 12)
make("UIStroke", {Color=Color3.fromRGB(59, 51, 86), Thickness=1}, window)

local top = make("Frame", {Size=UDim2.new(1, 0, 0, 52), BackgroundTransparency=1}, window)
make("TextLabel", {Text="✦  CLOVER HUB", TextColor3=COLORS.fg, Font=Enum.Font.GothamBold,
    TextSize=18, TextXAlignment=Enum.TextXAlignment.Left,
    BackgroundTransparency=1, Position=UDim2.fromOffset(20, 0), Size=UDim2.new(1, -105, 1, 0)}, top)
local close = make("TextButton", {Text="×", TextSize=26, Font=Enum.Font.Gotham,
    TextColor3=COLORS.fg, BackgroundTransparency=1,
    Position=UDim2.new(1, -44, 0, 4), Size=UDim2.fromOffset(38, 38)}, top)
close.MouseButton1Click:Connect(function() gui:Destroy() end)
make("Frame", {BackgroundColor3=COLORS.panel, BorderSizePixel=0,
    Position=UDim2.fromOffset(0, 51), Size=UDim2.new(1, 0, 0, 1)}, window)

local side = make("Frame", {Position=UDim2.fromOffset(0, 52), Size=UDim2.new(0, 166, 1, -52),
    BackgroundColor3=COLORS.side, BorderSizePixel=0}, window)
local sidePadding = make("UIPadding", {PaddingTop=UDim.new(0, 15), PaddingLeft=UDim.new(0, 10), PaddingRight=UDim.new(0, 10)}, side)
make("UIListLayout", {Padding=UDim.new(0, 7), SortOrder=Enum.SortOrder.LayoutOrder}, side)
local content = make("Frame", {Position=UDim2.fromOffset(180, 66), Size=UDim2.new(1, -194, 1, -80),
    BackgroundTransparency=1}, window)
local pages = {}
local tabButtons = {}
local function title(parent, text)
    make("TextLabel", {Text=text, Font=Enum.Font.GothamBold, TextSize=19,
        TextXAlignment=Enum.TextXAlignment.Left, TextColor3=COLORS.fg,
        BackgroundTransparency=1, Size=UDim2.new(1,0,0,30)}, parent)
end
local function note(parent, text)
    local l=make("TextLabel", {Text=text, Font=Enum.Font.Gotham, TextSize=12,
        TextWrapped=true, TextXAlignment=Enum.TextXAlignment.Left, TextYAlignment=Enum.TextYAlignment.Top,
        TextColor3=COLORS.muted, BackgroundTransparency=1,
        Size=UDim2.new(1, -12, 0, 51)}, parent)
    return l
end
local function button(parent, text, onClick)
    local b=make("TextButton", {Text=text, Font=Enum.Font.GothamMedium, TextSize=13,
        TextColor3=COLORS.fg, BackgroundColor3=COLORS.panel, BorderSizePixel=0,
        Size=UDim2.new(1, -8, 0, 40)}, parent)
    round(b, 7)
    b.MouseButton1Click:Connect(onClick)
    return b
end
local function row(parent, text, initial, callback)
    local on=initial
    local b
    b=button(parent, "", function()
        on=not on
        callback(on)
        b.Text=text .. (on and "   [ON]" or "   [OFF]")
        b.BackgroundColor3=on and Color3.fromRGB(65, 48, 107) or COLORS.panel
    end)
    b.Text=text .. (on and "   [ON]" or "   [OFF]")
    return b
end
local function page(name, heading)
    local p=make("ScrollingFrame", {Name=name, Size=UDim2.fromScale(1,1), BackgroundTransparency=1,
        BorderSizePixel=0, ScrollBarThickness=3, ScrollBarImageColor3=COLORS.accent,
        AutomaticCanvasSize=Enum.AutomaticSize.Y, CanvasSize=UDim2.new()}, content)
    make("UIPadding", {PaddingTop=UDim.new(0, 2), PaddingRight=UDim.new(0, 5)}, p)
    make("UIListLayout", {Padding=UDim.new(0, 9), SortOrder=Enum.SortOrder.LayoutOrder}, p)
    p.Visible=false
    title(p, heading)
    pages[name]=p
    local b=make("TextButton", {Text=name, Font=Enum.Font.GothamMedium, TextSize=14,
        TextXAlignment=Enum.TextXAlignment.Left, TextColor3=COLORS.muted,
        BackgroundColor3=COLORS.side, BorderSizePixel=0,
        Size=UDim2.new(1,0,0,40)}, side)
    round(b, 7)
    tabButtons[name]=b
    b.MouseButton1Click:Connect(function()
        for n, frame in pairs(pages) do frame.Visible = n == name end
        for n, tb in pairs(tabButtons) do
            tb.BackgroundColor3=n==name and Color3.fromRGB(50, 41, 79) or COLORS.side
            tb.TextColor3=n==name and COLORS.fg or COLORS.muted
        end
    end)
    return p
end

local home=page("Home", "Welcome")
note(home, "Original Clover-inspired UI. Client-side features are functional where permitted. No private game endpoints or Cerberus code are included.")
button(home, "Copy game PlaceId", function()
    if setclipboard then pcall(setclipboard, tostring(game.PlaceId)) end
end)
button(home, "Recenter window", function()
    window.Position=UDim2.new(0.5,-320,0.5,-205)
end)

local farming=page("Farming", "Farming & Events")
note(farming, "Auto EXP, quest, boss and Derby event farming require authorized, game-specific server mechanics. This hub does not falsely claim to automate them.")
button(farming, "Auto EXP  •  Not connected", function() end)
button(farming, "Auto Quest  •  Not connected", function() end)
button(farming, "Dewfall Derby  •  Not connected", function() end)

local visuals=page("Visuals", "Visual Tools")
local espEnabled=false
local highlights={}
local function updateESP()
    for pl, obj in pairs(highlights) do
        if not espEnabled or pl.Parent~=Players or not pl.Character or obj.Parent~=pl.Character then
            obj:Destroy()
            highlights[pl]=nil
        end
    end
    if espEnabled then
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl~=player and pl.Character and not highlights[pl] then
                local h=Instance.new("Highlight")
                h.Name="CloverLocalHighlight"
                h.FillColor=COLORS.accent
                h.FillTransparency=0.75
                h.OutlineColor=COLORS.fg
                h.DepthMode=Enum.HighlightDepthMode.Occluded
                h.Parent=pl.Character
                highlights[pl]=h
            end
        end
    end
end
row(visuals, "Player highlights", false, function(v) espEnabled=v; updateESP() end)
note(visuals, "Highlights only appear on visible character models and don't reveal hidden map content.")
local conn=RunService.Heartbeat:Connect(function() if espEnabled then updateESP() end end)

local movement=page("Movement", "Movement")
note(movement, "Local camera and movement aids only. Teleport destinations are intentionally not fabricated.")
button(movement, "Reset camera", function()
    if workspace.CurrentCamera and player.Character then
        workspace.CurrentCamera.CameraSubject=player.Character:FindFirstChildOfClass("Humanoid")
        workspace.CurrentCamera.CameraType=Enum.CameraType.Custom
    end
end)

local settings=page("Settings", "Settings")
note(settings, "Drag the top bar to move the window. Press RightShift to show/hide it. The close button cleans up the hub.")
button(settings, "Hide / Show (RightShift)", function() window.Visible=not window.Visible end)

local dragging=false
local dragStart, startPos
local dragInput
 top.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        dragging=true; dragStart=input.Position; startPos=window.Position
        input.Changed:Connect(function()
            if input.UserInputState==Enum.UserInputState.End then dragging=false end
        end)
    end
end)
top.InputChanged:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then dragInput=input end
end)
local dragConn=UIS.InputChanged:Connect(function(input)
    if dragging and input==dragInput then
        local delta=input.Position-dragStart
        window.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
    end
end)
local keyConn=UIS.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode==Enum.KeyCode.RightShift then window.Visible=not window.Visible end
end)
local originalDestroy=gui.Destroying:Connect(function()
    conn:Disconnect(); keyConn:Disconnect(); dragConn:Disconnect()
    for _, h in pairs(highlights) do h:Destroy() end
end)
-- Initial view
 tabButtons.Home.BackgroundColor3=Color3.fromRGB(50,41,79)
 tabButtons.Home.TextColor3=COLORS.fg
 home.Visible=true
