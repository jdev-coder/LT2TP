--//This is the old LT2TP. Use the new UI as it is the only one to get new features.\\--

--//Credits\\--
--[[
	@Pepsi for the awesome UI library! (https://v3rmillion.net/showthread.php?tid=1139856)
	@DinosaurXxX for the Max Land function. (I ONLY cleaned up the code a little bit.) (https://gist.github.com/DinosaurXxX/93f5d5df959cf20f7665991be5e3c9b3)
	@Ataias for the anti-exploit bypass. (https://v3rmillion.net/showthread.php?tid=1141592)
	
	Me (@JSK, jdev-coder) and other contributors (@noobiii) for the rest.
]]

--//Changelog Info\\--
--[[
    Changelog template (/ lists different options or examples.):
    {
        Type = 'Change/Add/Remove',
        Name = 'noobiii/JSK',
        Value = 'Fixed tree dismemberer/Fixed gravity slider',
    }
]]

local ChangelogTable = {
    {
        Type = 'Change',
        Name = 'JSK',
        Value = 'Fixed tree dismemberer.',
    },
    {
        Type = 'Change',
        Name = 'noobiii',
        Value = 'Made the sliders on the Players tab show what you are changing.',
    },
    {
        Type = 'Add',
        Name = 'noobiii',
        Value = 'Increased the Gravity Slider\'s range to 0-500.',
    },
    {
        Type = 'Add',
        Name = 'JSK',
        Value = 'Disable the AutoFarm and stop cutting any trees when Safe Reset is clicked.',
    },
    {
        Type = 'Add',
        Name = 'JSK',
        Value = 'Add AntiLog so the Anti-Cheat cannot tell the server you exploited.',
    },
    {
        Type = 'Change',
        Name = 'JSK',
        Value = 'Fix AntiLog problem where it tried to hook FS.',
    },
    {
        Type = 'Change',
        Name = 'JSK',
        Value = 'Whoops. AntiLog used HookFunction which may not have done anything.',
    },
    {
        Type = 'Add',
        Name = 'JSK',
        Value = 'Added built-in long wire ban protection.',
    },
    {
        Type = 'Change',
        Name = 'JSK',
        Value = 'Safe Reset now stops cutting trees.',
    },
}

local UI = loadstring(game:HttpGet('https://raw.githubusercontent.com/noobiii/modified-pepsilib/main/source'))()
local Window = UI:CreateWindow({Name = 'LT2TP', Theme = {Backdrop = nil, Info = 'LT2TP v1.6 by JSK'}})
local Land = Window:CreateTab({Name = 'Land'})
local Player = Window:CreateTab({Name = 'Player'})
local World = Window:CreateTab({Name = 'World'})
local Buy = Window:CreateTab({Name = 'AutoBuy'})
local Trees = Window:CreateTab({Name = 'Trees'})
local Teleports = Window:CreateTab({Name = 'Teleports'})
local Trolling = Window:CreateTab({Name = 'Trolling'})
local Planks = Window:CreateTab({Name = 'Planks'})
local Water = Window:CreateTab({Name = 'Water'})
local Vehicle = Window:CreateTab({Name = 'Vehicle'})
local Changelog = Window:CreateTab({Name = 'Changelog'})
local Credits = Window:CreateTab({Name = 'Credits'})

local VehicleSpeedSection = Vehicle:CreateSection({Name = 'Speed'})
local WaterModSection = Water:CreateSection({Name = 'Water Modification'})
local WoodSellSectionPlanks = Planks:CreateSection({Name = 'Wood Seller'})
local TrollingBase = Trolling:CreateSection({Name = 'Base'})
local TeleportsSection = Teleports:CreateSection({Name = 'All Teleports'})
local TreesTeleportSection = Trees:CreateSection({Name = 'Wood Teleportation'})
local TreeBringSection = Trees:CreateSection({Name = 'Tree Bringer'})
local TreesSawmillSection = Trees:CreateSection({Name = 'Sawmill'})
local TreeMisc = Trees:CreateSection({Name = 'Miscellaneous'})
local TreeSeller = Trees:CreateSection({Name = 'Tree Seller'})
local AutoBuySection = Buy:CreateSection({Name = 'Automatic Buyer'})
local WorldMisc = World:CreateSection({Name = 'Miscellaneous'})
local WorldBridge = World:CreateSection({Name = 'Bridge'})
local PlayerMovement = Player:CreateSection({Name = 'Movement'})
local PlayerMisc = Player:CreateSection({Name = 'Miscellaneous'})
local FreeLandSect = Land:CreateSection({Name = 'Free Land'})
local ChangelogSect = Changelog:CreateSection({Name = 'Changelog'})
local CreditsSect = Credits:CreateSection({Name = 'Credits'})

local NoticeClient = getsenv(game:GetService('Players').LocalPlayer.PlayerGui.NoticeGUI.NoticeClient)
local NoticeFunc = NoticeClient.doNotice

local WalkSpeed = 16
local JumpPower = 50

local Gravity = workspace.Gravity

local TreeTable = {}
local Regions = {}

local FlingToggled = false

local CF = nil

local AutoFarm = false
local AntiBL = false

local ShopNamesTable = {}

--//This garbage code is so inefficient.\\--
for i,v in pairs(game:GetService('ReplicatedStorage').ClientItemInfo:GetChildren()) do
    for i2,v2 in pairs(workspace.Stores:GetChildren()) do
        if v2.Name == 'ShopItems' then
            for i3,v3 in pairs(v2:GetChildren()) do
                if v3:FindFirstChild('BoxItemName') then
                    if v:FindFirstChild('ItemName') and v.Name == v3.BoxItemName.Value and not table.find(ShopNamesTable, v.ItemName.Value) then
                        table.insert(ShopNamesTable, v.ItemName.Value)
                    end
                end
            end
        end
    end
end

for i,v in pairs(ChangelogTable) do
    if v.Type == 'Add' then
        local ToSplitAt = #v.Value / 2
        local Value = string.sub(v.Value, 1, ToSplitAt)
        local Value2 = string.sub(v.Value, ToSplitAt + 1, #v.Value)
        
        if i > 1 then
            ChangelogSect:AddLabel({Name = '\n'})
        end
        
        ChangelogSect:AddLabel({
            Name = '[+] ' .. Value .. '\n' .. Value2 .. ' [' .. v.Name .. ']',
        })
    end
    if v.Type == 'Change' then
        local ToSplitAt = #v.Value / 2
        local Value = string.sub(v.Value, 1, ToSplitAt)
        local Value2 = string.sub(v.Value, ToSplitAt + 1, #v.Value)
        
        if i > 1 then
            ChangelogSect:AddLabel({Name = '\n'})
        end
        
        ChangelogSect:AddLabel({
            Name = '\n[*] ' .. Value .. '\n' .. Value2 .. ' [' .. v.Name .. ']',
        })
    end
    if v.Type == 'Remove' then
        local ToSplitAt = #v.Value / 2
        local Value = string.sub(v.Value, 1, ToSplitAt)
        local Value2 = string.sub(v.Value, ToSplitAt + 1, #v.Value)
        
        if i > 1 then
            ChangelogSect:AddLabel({Name = '\n'})
        end
        
        ChangelogSect:AddLabel({
            Name = '[-] ' .. Value .. Value2 .. ' [' .. v.Name .. ']',
        })
    end
end

ChangelogSect:AddLabel({Name = '\n'})

--//If the old loop exists, stop it. It will prevent lag if the script is executed multiple times.\\--
if _G.Conn then
    _G.Conn:Disconnect()
end

--//Anti-AFK\\--
game:GetService('Players').LocalPlayer.Idled:connect(function()
   game:GetService('VirtualUser'):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
   wait(1)
   game:GetService('VirtualUser'):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

--//Credits Items\\--

--I hate this code.
CreditsSect:AddLabel('@Pepsi for the awesome UI library!')
CreditsSect:AddLabel('\n')
CreditsSect:AddLabel('(https://v3rmillion.net/showthread.php?tid=1139856)')
CreditsSect:AddLabel('\n@DinosaurXxX for the Max Land function.')
CreditsSect:AddLabel('\n')
CreditsSect:AddLabel('(I ONLY cleaned up the code a little bit.)')
CreditsSect:AddLabel('\n')
CreditsSect:AddLabel('(https://gist.github.com/DinosaurXxX/93f5d5df959cf20f\n7665991be5e3c9b3)')
CreditsSect:AddLabel('\n@Ataias for the anti-exploit bypass.')
CreditsSect:AddLabel('\n')
CreditsSect:AddLabel('(https://v3rmillion.net/showthread.php?tid=1141592)')
CreditsSect:AddLabel('\n')
CreditsSect:AddLabel('Me (@JSK, jdev-coder)\nand other contributors (@noobiii) for the rest.\n')

--//Anti-Exploit bypass\\--
if not _G.Bypassed then
    local NC 
	
    --ALERT: CODE BELOW NOT WRITTEN BY ME, NEEDS TO BE REPLACED. (SKIDDED)
    local Anticheat_Env = getsenv(game:GetService('Players').LocalPlayer.PlayerGui.LoadSaveGUI.LoadSaveClient.LocalScript)
    
    if game:GetService('ReplicatedStorage').Interaction:FindFirstChild('Ban') then
        for _, v in next, getconnections(game:GetService('ReplicatedStorage').Interaction.Ban.AncestryChanged) do
            pcall(function()
                v:Disable()
            end)
        end
    end
    
    pcall(function()
        game:GetService('ReplicatedStorage').Interaction.Ban:Destroy()
    end)
    
    hookfunction(Anticheat_Env.ban, function(...)
        wait(9e9)
    end)
    
    NC = hookmetamethod(game, '__namecall', newcclosure(function(Self, ...)
        local Args = {...}
        
        if tostring(Self) == 'ClientPlacedWire' and getnamecallmethod() == 'FireServer' and Args[2] and Args[2][1] and Args[2][2] and Args[2][1].X and (Args[1] - Args[2]).Magnitude > 7 then
            Notify('Whoops! You have triggered the long wire ban! Luckily, LT2TP saved ya. If you are sure you want to place this wire, please rejoin and do not run LT2TP.')
            wait(9e9)
        end
    
        --//Other protections, not written by me. Needs rewrite. (SKIDDED :O).\\--
        if tostring(Self) == 'AddLog' then
            Notify('Whoops! You have triggered the anti-cheat! Luckily, LT2TP saved ya.')
            wait(9e9)
        end
        if tostring(Self) == 'ArchiveLog' then
            Notify('Whoops! You have triggered the anti-cheat! Luckily, LT2TP saved ya.')
            wait(9e9)
        end
        if getnamecallmethod() == 'Kick' then
            Notify('Whoops! You have triggered the anti-cheat! Luckily, LT2TP saved ya.')
            wait(9e9)
        end
        if tostring(Self) == 'Ban' then
            Notify('Whoops! You have triggered the anti-cheat! Luckily, LT2TP saved ya.')
            wait(9e9)
        end
        
        return NC(Self, ...)
    end))
 
    _G.Bypassed = true
end

--//Functions, exposed via getgenv\\--
function AddLand(Pos)
    game:GetService('ReplicatedStorage').PropertyPurchasing.ClientExpandedProperty:FireServer(Base, Pos)
end

--//Modify game credits\\--
local Module = require(game:GetService('ReplicatedStorage').Credits)
Module[8] = {
    heading = '\nLT2TP UI Library',
    credits = {'Pepsi'},
}
Module[9] = {
    heading = 'LT2TP AC Bypass',
    credits = {'Ataias', 'JSK (@jdev-coder)'},
}
Module[10] = {
    heading = '\nLT2TP',
    credits = {'JSK (@jdev-coder)', 'noobiii'},
}

pcall(function() game:GetService('Players').LocalPlayer.PlayerGui.CreditsGUI:Destroy() end)

game:GetService('StarterGui').CreditsGUI:Clone().Parent = game:GetService('Players').LocalPlayer.PlayerGui

--//Fix Menu button when Credits GUI is closed.\\--
game:GetService('Players').LocalPlayer.PlayerGui.CreditsGUI.Credits.Quit.Activated:Connect(function()
    game:GetService('Players').LocalPlayer.PlayerGui.MenuGUI.Open.Visible = true
end)

--//Functions\\--
function Notify(Message)
    if syn_context_set then
        syn_context_set(2)
        NoticeFunc(Message)
        syn_context_set(7)
    else
        game:GetService('StarterGui'):SetCore('SendNotification', {Title = Message})
    end
end

--//Show Anti-Cheat bypass notification\\--
Notify('LT2TP has bypassed the anti-cheat. You will be protected from certain bans, too.')

--//Load the tree types\\--
for i,v in pairs(workspace:GetChildren()) do
    if v.Name == 'TreeRegion' then
        table.insert(Regions, v)
    end
end

for i,v in pairs(Regions) do
    for i2,v2 in pairs(v:GetChildren()) do
        if v2:FindFirstChild('TreeClass') and not table.find(TreeTable, v2.TreeClass.Value) then
            table.insert(TreeTable, v2.TreeClass.Value)
        end
    end
end

--//Land Items\\--
FreeLandSect:AddButton({
    Name = 'Max Land',
    Callback = function()
	    --ALERT: CODE BELOW NOT WRITTEN BY ME, NEEDS TO BE REPLACED. (SKIDDED)
			
        for i,v in pairs(game:GetService('Workspace').Properties:GetChildren()) do
        	if v:FindFirstChild('Owner') and v.Owner.Value == game.Players.LocalPlayer then
        		Base = v
        		Square = v.OriginSquare
        	end
        end
    
        if not Square then return Notify('You do not have any land to expand!') end
    
        SquarePosition = Square.Position
    	
        AddLand(CFrame.new(SquarePos.X + 40, SquarePos.Y, SquarePos.Z))
        AddLand(CFrame.new(SquarePos.X - 40, SquarePos.Y, SquarePos.Z))
        AddLand(CFrame.new(SquarePos.X, SquarePos.Y, SquarePos.Z + 40))
        AddLand(CFrame.new(SquarePos.X, SquarePos.Y, SquarePos.Z - 40))
        AddLand(CFrame.new(SquarePos.X + 40, SquarePos.Y, SquarePos.Z + 40))
        AddLand(CFrame.new(SquarePos.X + 40, SquarePos.Y, SquarePos.Z - 40))
        AddLand(CFrame.new(SquarePos.X - 40, SquarePos.Y, SquarePos.Z + 40))
        AddLand(CFrame.new(SquarePos.X - 40, SquarePos.Y, SquarePos.Z - 40))
        AddLand(CFrame.new(SquarePos.X + 80, SquarePos.Y, SquarePos.Z))
        AddLand(CFrame.new(SquarePos.X - 80, SquarePos.Y, SquarePos.Z))
        AddLand(CFrame.new(SquarePos.X, SquarePos.Y, SquarePos.Z + 80))
        AddLand(CFrame.new(SquarePos.X, SquarePos.Y, SquarePos.Z - 80))
        AddLand(CFrame.new(SquarePos.X + 80, SquarePos.Y, SquarePos.Z + 80))
        AddLand(CFrame.new(SquarePos.X + 80, SquarePos.Y, SquarePos.Z - 80))
        AddLand(CFrame.new(SquarePos.X - 80, SquarePos.Y, SquarePos.Z + 80))
        AddLand(CFrame.new(SquarePos.X - 80, SquarePos.Y, SquarePos.Z - 80))
        AddLand(CFrame.new(SquarePos.X + 40, SquarePos.Y, SquarePos.Z + 80))
        AddLand(CFrame.new(SquarePos.X - 40, SquarePos.Y, SquarePos.Z + 80))
        AddLand(CFrame.new(SquarePos.X + 80, SquarePos.Y, SquarePos.Z + 40))
        AddLand(CFrame.new(SquarePos.X + 80, SquarePos.Y, SquarePos.Z - 40))
        AddLand(CFrame.new(SquarePos.X - 80, SquarePos.Y, SquarePos.Z + 40))
        AddLand(CFrame.new(SquarePos.X - 80, SquarePos.Y, SquarePos.Z - 40))
        AddLand(CFrame.new(SquarePos.X + 40, SquarePos.Y, SquarePos.Z - 80))
        AddLand(CFrame.new(SquarePos.X - 40, SquarePos.Y, SquarePos.Z - 80))
    end
})

--//Player Items\\--
PlayerMovement:AddLabel({
    Name = 'Gravity',
})

PlayerMovement:AddSlider({
    Name = 'Gravity',
    Value = 196.2,
    Min = 0,
    Max = 500,
    Format = function(Val)
        Gravity = Val
        
        return Val
    end
})

PlayerMovement:AddLabel({
    Name = 'WalkSpeed',
})

PlayerMovement:AddSlider({
    Name = 'WalkSpeed',
    Value = 16,
    Min = 1,
    Max = 400,
    Format = function(Val)
        WalkSpeed = Val
        
        return Val
    end
})

PlayerMovement:AddLabel({
    Name = 'JumpPower',
})

PlayerMovement:AddSlider({
    Name = 'JumpPower',
    Value = 50,
    Min = 1,
    Max = 400,
    Format = function(Val)
        JumpPower = Val
        
        return Val
    end
})

PlayerMisc:AddButton({
    Name = 'Safe Reset',
    Callback = function()
        game:GetService('Players').LocalPlayer.Character.Humanoid:UnequipTools()
        
        wait()
        
        game:GetService('Players').LocalPlayer.Character.Head:Destroy()
        game:GetService('Players').LocalPlayer.Character.HumanoidRootPart:Destroy()
        
        AutoFarm = false
        
        _G.DevBreak = true
        wait(3)
        _G.DevBreak = false
    end
})

--//AutoBuy Items\\--
AutoBuySection:AddDropdown({
    Name = 'Buy Item',
    List = ShopNamesTable,
    Callback = function(Item)
        local ItemToPurchase = nil
        
        if Item == 'None' then return end
        
        for i,v in pairs(game:GetService('ReplicatedStorage').ClientItemInfo:GetChildren()) do
            if v:FindFirstChild('ItemName') and v.ItemName.Value == Item then
                ItemToPurchase = v.Name
            end
        end
        
        if not ItemToPurchase then
            return Notify('No item found. It is likely the store does not have the item.')
        end
        
        for i,v in pairs(workspace.Stores:GetDescendants()) do
            if v.Name == 'BoxItemName' and v.Parent.Name == 'Box' and v.Value == ItemToPurchase and v.Parent:FindFirstChild('Main', true) then
                local Store = nil
                local OldPos = game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame
                
                if not v.Parent:FindFirstChild('Main', true) then
                    return Notify('Unable to find the Main part of the box.')
                end
                
                for i,v in pairs(workspace.Stores:GetChildren()) do
                    if v:FindFirstChild('Counter') and (v.Counter.Position - v.Parent:FindFirstChild('Main', true).Position) then
                        Store = v
                        break
                    end
                end
                
                if not Store then
                    return Notify('Unable to find the store where the item is located.')
                end
                
                if not Store:FindFirstChild('HumanoidRootPart', true) then
                    return Notify('Unable to find the store\'s NPC.')
                end
                
                game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame = v.Parent:FindFirstChild('Main', true).CFrame
                
                game:GetService('ReplicatedStorage').Interaction.ClientIsDragging:FireServer(v.Parent)
                v.Parent:FindFirstChild('Main', true).CFrame = Store.Counter.CFrame
                game:GetService('ReplicatedStorage').Interaction.ClientIsDragging:FireServer(v.Parent)
                
                game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame = Store.Counter.CFrame
                
                wait(.2)
                
                for i = 1, 30 do
                    pcall(function()
                        game:GetService('ReplicatedStorage').NPCDialog.PlayerChatted:InvokeServer({ID = i, Name = Store:FindFirstChild('HumanoidRootPart', true).Parent.Name, Dialog = Store:FindFirstChild('Dialog', true), Character = Store:FindFirstChild('HumanoidRootPart', true).Parent}, 'ConfirmPurchase')
                    end)
                end
                
                wait(.2)
                
                game:GetService('ReplicatedStorage').Interaction.ClientIsDragging:FireServer(v.Parent)
                v.Parent:FindFirstChild('Main', true).CFrame = OldPos
                game:GetService('ReplicatedStorage').Interaction.ClientIsDragging:FireServer(v.Parent)
                
                game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame = OldPos
                break
            end
        end
        
        return Item
    end
})

--//World Items\\--
WorldMisc:AddButton({
    Name = 'BTools',
    Callback = function()
        loadstring(game:HttpGet('https://gist.githubusercontent.com/jdev-coder/dcbfdb678973d37fe0d6b7159d2ad45e/raw/afdc99e016074d7f25bebf22e367b5003a72bbec/lt2btools.lua'))()
    end
})

WorldMisc:AddButton({
    Name = 'Super Drag',
    Callback = function()
        hookfunction(getsenv(game:GetService('Players').LocalPlayer.PlayerGui.ItemDraggingGUI.Dragger).canDrag, function()
            return true
        end)
        
        for i,v in pairs(getnilinstances()) do
            if v.Name == 'Dragger' and v:IsA('Part') then
                v.BodyPosition.MaxForce = Vector3.new(1, 1, 1) * 2000000
                v.BodyGyro.MaxTorque = Vector3.new(1, 1, 1) * 2000000
            end 
        end
        
        if game:GetService('Players').LocalPlayer.ItemDraggingGUI.Dragger:FindFirstChild('Dragger') then
            game:GetService('Players').LocalPlayer.ItemDraggingGUI.Dragger:FindFirstChild('Dragger').BodyPosition.MaxForce = Vector3.new(1, 1, 1) * 2000000
            game:GetService('Players').LocalPlayer.ItemDraggingGUI.Dragger:FindFirstChild('Dragger').BodyGyro.MaxTorque = Vector3.new(1, 1, 1) * 2000000
        end
    end
})

WorldMisc:AddButton({
    Name = 'Lower Bridge',
    Callback = function()
        game:GetService('ReplicatedStorage').NPCDialog.PlayerChatted:InvokeServer({ID = 14, Name = 'Seranok', Dialog = Instance.new('Dialog'), Character = workspace.Bridge.TollBooth0.Seranok}, 'ConfirmPurchase')
    end
})

--//Water Items\\--
WaterModSection:AddButton({
    Name = 'Walk On Water',
    Callback = function()
        for i,v in pairs(workspace.Water:GetChildren()) do
            v.CanCollide = true
        end
    end
})

--//Vehicle Items\\--
VehicleSpeedSection:AddSlider({
    Name = 'Speed',
    Value = 1,
    Min = 1,
    Max = 8,
    Format = function(Speed)
        local DefaultSpeed = 1.15
        local DefaultSteer = 0.015
        
        for i,v in pairs(workspace.PlayerModels:GetChildren()) do
            if v:FindFirstChild('DriveSeat') and v:FindFirstChild('Owner') and v.Owner.Value == game:GetService('Players').LocalPlayer then
                v.Configuration.SteerVelocity.Value = DefaultSteer * (Speed / 2.5)
                v.Configuration.MaxSpeed.Value = DefaultSpeed * Speed
            end
        end
        
        return Speed
    end
})

--//Trees Items\\--
TreesTeleportSection:AddDropdown({
    Name = 'Teleport To Tree',
    List = TreeTable,
    Callback = function(TreeType)
        for i,v in pairs(Regions) do
            for i2,v2 in pairs(v:GetChildren()) do
                if v2:FindFirstChild('TreeClass') and v2.TreeClass.Value == TreeType and not v2:FindFirstChild('RootCut') then
                    game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame = v2:FindFirstChild('WoodSection', true).CFrame
                    return
                end
            end
        end
    end
})

TreeBringSection:AddDropdown({
    Name = 'Bring Tree',
    List = TreeTable,
    Callback = function(TreeType)
        local Axe = game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Tool')
        
        if not Axe then
            return Notify('No axe was found in your inventory.')
        end
        
        for i,v in pairs(Regions) do
            for i2,v2 in pairs(v:GetChildren()) do
                if v2:FindFirstChild('TreeClass') and v2.TreeClass.Value == TreeType and not v2:FindFirstChild('RootCut') then
                    local AxeName = Axe.ToolName.Value
                    local Class = require(game:GetService('ReplicatedStorage').AxeClasses:FindFirstChild('AxeClass_'..AxeName)).new()
                    local Break = false
                    local Count = 0
                    local Height = 0.3
                    local Count = 0
                    local OldPos = game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame
                    
                    for i = 1, 10 do
                        wait()
                        
                        game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                        game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame = v2:FindFirstChild('WoodSection', true).CFrame
                    end 
                    
                    Axe.Parent = game:GetService('Players').LocalPlayer.Backpack
                        
                    for i,v in pairs(v2:GetChildren()) do
                        if v.Name == 'WoodSection' then
                            Count += 1
                        end
                    end
                        
                    repeat 
                        local NewCount = 0
                        
                        wait(Class.SwingCooldown + .08)
                        pcall(function() game:GetService('ReplicatedStorage').Interaction.RemoteProxy:FireServer(v2.CutEvent, {tool = Axe, faceVector = Vector3.new(1,0,0), height = Height, sectionId = 1, hitPoints = Class.Damage, cooldown = Class.SwingCooldown, cuttingClass = 'Axe'}) end)
                        
                        for i,v in pairs(v2:GetChildren()) do
                            if v.Name == 'WoodSection' then
                                NewCount += 1
                            end
                        end
                        
                        if TreeType == 'LoneCave' then
                            local OldPos = game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame
    
                            game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 0/0, 0)
                            wait()
                            game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame = OldPos
                        end
                        
                        if Count ~= NewCount then
                            Break = true
                        end
                    until Break or _G.DevBreak
                    
                    for i3,v3 in pairs(workspace.LogModels:GetChildren()) do
                        if v3:FindFirstChild('Owner') and v3.Owner.Value == game:GetService('Players').LocalPlayer then 
                            v3.PrimaryPart = v3.WoodSection
                            
                            for i = 1, 10 do
                                wait(.08)
                                game:GetService('ReplicatedStorage').Interaction.ClientIsDragging:FireServer(v3)
                                v3:PivotTo(OldPos)
                                v3.PrimaryPart.Velocity = Vector3.new(0,0,0)
                                game:GetService('ReplicatedStorage').Interaction.ClientIsDragging:FireServer(v3)
                            end
                        end
                    end
                    
                    if TreeType == 'LoneCave' then
                        game:GetService('Players').LocalPlayer.Character.Humanoid:UnequipTools()
                        wait()
                        game:GetService('Players').LocalPlayer.Character.Head:Destroy()
                        game:GetService('Players').LocalPlayer.CharacterAdded:Wait()
                        wait(1.5)
                    end
                    
                    game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame = OldPos
                    
                    return
                end
            end
        end
    end
})

TreeMisc:AddButton({
    Name = 'Bring All Trees',
    Callback = function()
        local OldPos = game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame
        
        for i,v in pairs(workspace.LogModels:GetChildren()) do
            if v:FindFirstChild('Owner') and v.Owner.Value == game:GetService('Players').LocalPlayer then
                local _, Size = v:GetBoundingBox()
                
                game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(v:GetModelCFrame().Position.X, v:GetModelCFrame().Position.Y - Size.Y / 2, v:GetModelCFrame().Position.Z))
                
                v.PrimaryPart = v.WoodSection
                
                for i = 1, 10 do
                    wait(.06)
                    game:GetService('ReplicatedStorage').Interaction.ClientIsDragging:FireServer(v)
                    v:PivotTo(OldPos)
                    v.PrimaryPart.Velocity = Vector3.new(0,0,0)
                    game:GetService('ReplicatedStorage').Interaction.ClientIsDragging:FireServer(v)
                end
            end
        end
        
        game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame = OldPos
    end
})

TreeSeller:AddButton({
    Name = 'Sell All Trees',
    Callback = function()
        local OldPos = CFrame.new(325, -0.5, 86)
        
        for i,v in pairs(workspace.LogModels:GetChildren()) do
            if v:FindFirstChild('Owner') and v.Owner.Value == game:GetService('Players').LocalPlayer then
                local _, Size = v:GetBoundingBox()
                
                game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(v:GetModelCFrame().Position.X, v:GetModelCFrame().Position.Y - Size.Y / 2, v:GetModelCFrame().Position.Z))
                
                v.PrimaryPart = v.WoodSection
                
                for i = 1, 10 do
                    wait(.06)
                    game:GetService('ReplicatedStorage').Interaction.ClientIsDragging:FireServer(v)
                    v:PivotTo(OldPos)
                    v.PrimaryPart.Velocity = Vector3.new(0,0,0)
                    game:GetService('ReplicatedStorage').Interaction.ClientIsDragging:FireServer(v)
                end
            end
        end
        
        game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame = OldPos
    end
})

TreeMisc:AddButton({
    Name = 'Shrink All Trees',
    Callback = function()
        for i,v in pairs(workspace.LogModels:GetChildren()) do
            if v:FindFirstChild('Owner') and v.Owner.Value == game:GetService('Players').LocalPlayer then
                for i,v in pairs(v:GetChildren()) do
                    if v.Name == 'WoodSection' then
                        v.Size /= 2
                    end
                end
            end
        end
    end
})

TreesSawmillSection:AddButton({
    Name = 'Sawmill All Trees',
    Callback = function()
        local OldPos = nil
        
        for i,v in pairs(workspace.PlayerModels:GetChildren()) do
            if v:FindFirstChild('Owner') and v.Owner.Value == game:GetService('Players').LocalPlayer and v:FindFirstChild('Conveyor') and v.Conveyor:FindFirstChild('ApplyVelocity') then
                OldPos = v.Conveyor.Conveyor.CFrame + Vector3.new(0,2,0)
            end
        end
        
        if not OldPos then
            return Notify('You do not have a sawmill!')
        end
        
        for i,v in pairs(workspace.LogModels:GetChildren()) do
            if v:FindFirstChild('Owner') and v.Owner.Value == game:GetService('Players').LocalPlayer then
                local _, Size = v:GetBoundingBox()
                
                game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(v:GetModelCFrame().Position.X, v:GetModelCFrame().Position.Y - Size.Y / 2, v:GetModelCFrame().Position.Z))
                
                v.PrimaryPart = v.WoodSection
                
                for i = 1, 10 do
                    wait(.06)
                    game:GetService('ReplicatedStorage').Interaction.ClientIsDragging:FireServer(v)
                    v:PivotTo(OldPos)
                    v.PrimaryPart.Velocity = Vector3.new(0,0,0)
                    game:GetService('ReplicatedStorage').Interaction.ClientIsDragging:FireServer(v)
                end
            end
        end
        
        game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame = OldPos
    end
})

TreeMisc:AddButton({
    Name = 'Dismember All Trees',
    Callback = function()
        local Axe = game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Tool')
        
        if not Axe then
            return Notify('No axe was found in your inventory.')
        end
        
        for i,v in pairs(workspace.LogModels:GetChildren()) do
            if v:FindFirstChild('Owner') and v.Owner.Value == game:GetService('Players').LocalPlayer then
                for i2,v2 in pairs(v:GetChildren()) do
                    if v2.Name == 'WoodSection' and v2:FindFirstChild('ID') and v2:FindFirstChild('Tree Weld') then
                        local AxeName = Axe.ToolName.Value
                        local Class = require(game:GetService('ReplicatedStorage').AxeClasses:FindFirstChild('AxeClass_'..AxeName)).new()
                        local Break = false
                        local Count = 0
                        local TreeLimbCount = 0
                        local Height = CFrame.new(v2.CFrame.X, v2.CFrame.Y - v2.Size.Y / 2, v2.CFrame.Z):pointToObjectSpace(v2.Position).Y + v2.Size.Y / 2 / 1.01

                        for i,v in pairs(v:GetChildren()) do
                            if v.Name == 'WoodSection' then
                                TreeLimbCount += 1
                            end
                        end
                        
                        Axe.Parent = game:GetService('Players').LocalPlayer.Backpack
                        
                        game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame = v2.CFrame
                        
                        repeat 
                            local LimbCount = 0
                            
                            for i,v in pairs(v:GetChildren()) do
                                if v.Name == 'WoodSection' then
                                    LimbCount += 1
                                end
                            end
                            
                            if Count > 30 then
                                Break = true
                            end
                            
                            if LimbCount ~= TreeLimbCount then
                                Break = true
                            end
                            
                            Count += 1
                            
                            wait(Class.SwingCooldown + .08)
                            game:GetService('ReplicatedStorage').Interaction.RemoteProxy:FireServer(v.CutEvent, {tool = Axe, faceVector = Vector3.new(1,0,0), height = Height, sectionId = v2.ID.Value, hitPoints = Class.Damage, cooldown = Class.SwingCooldown, cuttingClass = 'Axe'})
                        until Break or _G.DevBreak
                    end
                end
            end
        end
end
})

--//Teleports Items\\--
TeleportsSection:AddDropdown({
    Name = 'Teleport',
    List = {'Volcano', 'Spawn', 'Wood R US', 'Link\'s Logic'},
    Callback = function(Location)
        if Location == 'Volcano' then
            game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1593, 630, 1101)
        elseif Location == 'Spawn' then
            game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Region_Main.SpawnLocation.CFrame
        elseif Location == 'Wood R US' then
            game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(270, 3, 56)
        elseif Location == 'Link\'s Logic' then
            game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(4609, 7, -800)
        end
    end
})

--//Trolling Items\\--
--[[
Trolling.AddButton('Steal Cars', function()
    for i,v in pairs(workspace.PlayerModels:GetChildren()) do
        if v:FindFirstChild('RunSounds') then
            print(v)
            v.Owner.Value = game:GetService('Players').LocalPlayer
            v.Owner.OwnerString.Value = game:GetService('Players').LocalPlayer.Name
        end
    end
end)
]]

TrollingBase:AddToggle({
    Name = 'Item Flinger',
    Callback = function(Val)
        FlingToggled = Val
    end
})

TrollingBase:AddButton({
    Name = 'Anti Blacklist',
    Callback = function()
        return Notify('Anti-Blacklist does not work yet.')
        
        --[[
        local Joint = game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.RootJoint
        local OldPos = game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame
        Joint:Clone().Parent = Joint.Parent
        Joint:Destroy()
            
        task.wait()
        
        for i = 1, 30 do
            task.wait()
            
            game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame = OldPos
        end
        ]]
    end
})

--[[
TrollingBase:AddButton({
    Name = 'Build Anywhere', 
    Callback = function()
        local DragItem = game:GetService('Players').LocalPlayer.PlayerGui.StructureDraggingGUI.DragItem
        local OldDrag = nil
        
        OldDrag = hookfunction(DragItem.Invoke, function(...)
            local Args = {...}
            
            print(Args[1])
            
            if tostring(Args[1]) == 'Model' or tostring(Args[1]) == 'PlacingModel' then
                return true, true
            end
            
            return OldDrag(...)
        end)
    end
})
]]

--//Logs Items\\--
WoodSellSectionPlanks:AddButton({
    Name = 'Sell All Planks',
    Callback = function()
        local OldPos = CFrame.new(325, -0.5, 86)
        
        for i,v in pairs(workspace.PlayerModels:GetChildren()) do
            if v.Name == 'Plank' and v:FindFirstChild('Owner') and v.Owner.Value == game:GetService('Players').LocalPlayer then
                local _, Size = v:GetBoundingBox()
                
                game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(v:GetModelCFrame().Position.X, v:GetModelCFrame().Position.Y - Size.Y / 2, v:GetModelCFrame().Position.Z))
                
                v.PrimaryPart = v.WoodSection
                
                for i = 1, 10 do
                    wait(.06)
                    game:GetService('ReplicatedStorage').Interaction.ClientIsDragging:FireServer(v)
                    v:PivotTo(OldPos)
                    v.PrimaryPart.Velocity = Vector3.new(0,0,0)
                    game:GetService('ReplicatedStorage').Interaction.ClientIsDragging:FireServer(v)
                end
            end
        end
        game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame = OldPos
    end
})

--//AutoFarm Items\\--
TreeMisc:AddButton({
    Name = 'Collect and Sell All Trees',
    Callback = function()
        AutoFarm = true
        
        local Axe = game:GetService('Players').LocalPlayer.Backpack:FindFirstChild('Tool')
        
        if not Axe then
            AutoFarm = false
            
            return Notify('No axe was found in your inventory.')
        end
        
        for i,v in pairs(Regions) do
            for i2,v2 in pairs(v:GetChildren()) do
                if v2:FindFirstChild('TreeClass') and v2.TreeClass.Value ~= 'LoneCave' and not v2:FindFirstChild('RootCut') then
                    pcall(function()
                        local AxeName = Axe.ToolName.Value
                        local Class = require(game:GetService('ReplicatedStorage').AxeClasses:FindFirstChild('AxeClass_'..AxeName)).new()
                        local Break = false
                        local Count = 0
                        local Height = 0.3
                        local Count = 0
                        local OldPos = game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame
                        local TimesRan = 0 
                        local Quit = false
                        
                        for i = 1, 10 do
                            wait()
                            
                            game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                            wait()
                            game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame = v2:FindFirstChild('WoodSection', true).CFrame
                        end 
                        
                        Axe.Parent = game:GetService('Players').LocalPlayer.Backpack
                        
                        game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                        wait()
                        game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.Anchored = true
                            
                        wait(.8)
                            
                        for i,v in pairs(v2:GetChildren()) do
                            if v.Name == 'WoodSection' then
                                Count += 1
                            end
                        end
                            
                        repeat 
                            local NewCount = 0
                            
                            if TimesRan > 45 then
                                Quit = true
                                Break = true
                            end
                            
                            TimesRan += 1
                            
                            wait(Class.SwingCooldown + .08)
                            pcall(function() game:GetService('ReplicatedStorage').Interaction.RemoteProxy:FireServer(v2.CutEvent, {tool = Axe, faceVector = Vector3.new(1,0,0), height = Height, sectionId = 1, hitPoints = Class.Damage, cooldown = Class.SwingCooldown, cuttingClass = 'Axe'}) end)
                            
                            for i,v in pairs(v2:GetChildren()) do
                                if v.Name == 'WoodSection' then
                                    NewCount += 1
                                end
                            end
                            
                            if TreeType == 'LoneCave' then
                                local OldPos = game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame
        
                                game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 0/0, 0)
                                wait()
                                game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame = OldPos
                            end
                            
                            if Count ~= NewCount then
                                Break = true
                            end
                        until Break or _G.DevBreak
                    
                        game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                        wait()
                        game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.Anchored = false
                        
                        wait()
                        
                        if not Quit then
                            for i3,v3 in pairs(workspace.LogModels:GetChildren()) do
                                if v3:FindFirstChild('Owner') and v3.Owner.Value == game:GetService('Players').LocalPlayer and v:FindFirstChild('WoodSection') then 
                                    v3.PrimaryPart = v3.WoodSection
                                    
                                    pcall(function()
                                        for i = 1, 10 do
                                            wait(.08)
                                            game:GetService('ReplicatedStorage').Interaction.ClientIsDragging:FireServer(v3)
                                            v3:PivotTo(OldPos)
                                            v3.PrimaryPart.Velocity = Vector3.new(0,0,0)
                                            game:GetService('ReplicatedStorage').Interaction.ClientIsDragging:FireServer(v3)
                                        end
                                    end)
                                end
                            end
                            
                            if TreeType == 'LoneCave' then
                                game:GetService('Players').LocalPlayer.Character.Humanoid:UnequipTools()
                                wait()
                                game:GetService('Players').LocalPlayer.Character.Head:Destroy()
                                game:GetService('Players').LocalPlayer.CharacterAdded:Wait()
                                wait(1.5)
                            end
                        end
                        
                        for i = 1, 5 do
                            if Quit then break end
                            
                            OldPos = CFrame.new(325, -0.5, 86)
                
                            local _, Size = v2:GetBoundingBox()
                                    
                            game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(v2:GetModelCFrame().Position.X, v2:GetModelCFrame().Position.Y - Size.Y / 2, v2:GetModelCFrame().Position.Z))
                                    
                            v2.PrimaryPart = v2.WoodSection
                                    
                            for i,v in pairs(workspace.LogModels:GetChildren()) do
                                if v:FindFirstChild('Owner') and v.Owner.Value == game:GetService('Players').LocalPlayer then
                                    for i,v in pairs(v:GetChildren()) do
                                        if v.Name == 'WoodSection' then
                                            v.Size /= 2
                                        end
                                    end
                                end
                            end
                                    
                            for i,v in pairs(workspace.LogModels:GetChildren()) do
                                if v:FindFirstChild('Owner') and v.Owner.Value == game:GetService('Players').LocalPlayer and v:FindFirstChild('WoodSection') then
                                    local _, Size = v:GetBoundingBox()
                                    
                                    game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(v:GetModelCFrame().Position.X, v:GetModelCFrame().Position.Y - Size.Y / 2, v:GetModelCFrame().Position.Z))
                                    
                                    v.PrimaryPart = v.WoodSection
                                    
                                    for i = 1, 10 do
                                        pcall(function()
                                            wait(.06)
                                            game:GetService('ReplicatedStorage').Interaction.ClientIsDragging:FireServer(v)
                                            v:PivotTo(OldPos)
                                            v.PrimaryPart.Velocity = Vector3.new(0,0,0)
                                            game:GetService('ReplicatedStorage').Interaction.ClientIsDragging:FireServer(v)
                                        end)
                                    end
                                end
                            end
                            
                            game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame = OldPos
                        end
                        
                        wait(.4)
                    end)
                end
            end
        end
	    AutoFarm = false
    end
})

--//Expose functions\\--
getgenv().AddLand = AddLand
getgenv().Notify = Notify

--//Loops\\--
_G.Conn = game:GetService('RunService').Stepped:Connect(function()
    game:GetService('Players').LocalPlayer.Character.Humanoid.WalkSpeed = WalkSpeed
    game:GetService('Players').LocalPlayer.Character.Humanoid.JumpPower = JumpPower
    
    workspace.Gravity = Gravity
    
    if FlingToggled and game:GetService('UserInputService'):IsKeyDown(Enum.KeyCode.X) and not game:GetService('UserInputService'):GetFocusedTextBox() then
        game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(250,250,250)
        game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService('Players').LocalPlayer:GetMouse().Hit
        
        workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
    end
    
    if not game:GetService('UserInputService'):IsKeyDown(Enum.KeyCode.X) and FlingToggled then
        if workspace.CurrentCamera.CameraType == Enum.CameraType.Scriptable then
            game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
        end
        
        workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
    end
    
    if AutoFarm then
        game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
    end
    
    if game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame.Y < -65 and AutoFarm then
	    game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 120, 0)
    end

    pcall(function()
        if AntiBL and (game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame.Position - CF.Position).Magnitude > 15 then
            --game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame = CF
        end
        
        --CF = game:GetService('Players').LocalPlayer.Character.HumanoidRootPart.CFrame
    end)
end)
