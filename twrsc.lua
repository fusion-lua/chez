local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'twr 😎',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local Tabs = {
    Main = Window:AddTab('Main'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

local AmmoGroup = Tabs.Main:AddLeftGroupbox('Ammo')

AmmoGroup:AddSlider('SpawnInterval', {
    Text = 'Spawn interval (s)',
    Default = 2,
    Min = 1,
    Max = 15,
    Rounding = 1,
    Compact = false,
    Callback = function() end
})

AmmoGroup:AddToggle('AmmoToggle', {
    Text = 'Auto Spawn Ammo',
    Default = false,
    Tooltip = 'Toggle auto-spawn of ammo'
})

AmmoGroup:AddLabel('Keybind'):AddKeyPicker('AmmoKey', {
    Default = 'None',
    SyncToggleState = true,
    Mode = 'Toggle',
    Text = 'Ammo Toggle Keybind'
})

task.spawn(function()
    while true do
        if Options.AmmoToggle and Options.AmmoToggle.Value then
            local player = game:GetService("Players").LocalPlayer
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local ammoPart = workspace:WaitForChild("Ignore"):WaitForChild("Items"):WaitForChild("Ammo"):WaitForChild("AmmoBoxes")
                local clone = ammoPart:Clone()
                clone.Parent = workspace
                clone.Position = hrp.Position + Vector3.new(0,5,0)
                print("cloneeattempt")
            end
            task.wait(Options.SpawnInterval.Value)
        else
            task.wait(0.1)
        end
    end
end)

local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })
Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })
ThemeManager:SetFolder('MyScriptHub')
SaveManager:SetFolder('MyScriptHub/specific-game')

SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyToTab(Tabs['UI Settings'])

SaveManager:LoadAutoloadConfig()

Library:SetWatermarkVisibility(true)
local FrameTimer = tick()
local FrameCounter = 0
local FPS = 60

local WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(function()
    FrameCounter += 1
    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter
        FrameTimer = tick()
        FrameCounter = 0
    end
    Library:SetWatermark(('cool twr script 😎 | %s fps | %s ms'):format(
        math.floor(FPS),
        math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
    ))
end)

Library:OnUnload(function()
    WatermarkConnection:Disconnect()
    Library.Unloaded = true
end)
