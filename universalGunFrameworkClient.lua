function shoot()
	
end

function reload()
	
end

local mouse = game.Players.LocalPlayer:GetMouse()
local UIS = game:GetService("UserInputService")
local gunName = "Gun"
local bodyTemplate = "bodyTemplate"

local gunLoaded = function()
	if game.Workspace.template:FindFirstChild(game.Players.LocalPlayer.Name) then
		if game.Workspace.template:FindFirstChild(game.Players.LocalPlayer.Name):FindFirstChild(gunName) then
			return true
		else
			return false
		end
	else
		return false
	end
end

UIS.InputBegan:Connect(function(input, _process)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		if gunLoaded() then
			local enemy = mouse.Target
			
		end
	end
end)

game:GetService("RunService").RenderStepped:Connect(function()
	if gunLoaded() then
		local root = game.Players.LocalPlayer.Character["UpperTorso"]
		local direction = (game.Workspace.CurrentCamera.CFrame.p - root.CFrame.Position).unit
		root["Waist"].C0 = CFrame.new(root["Waist"].C0.Position, game.Workspace.CurrentCamera.CFrame.LookVector * -100)
		
		local leftArm = game.Workspace.template[game.Players.LocalPlayer.Name]["armTemplateLeft"]
		local rightArm = game.Workspace.template[game.Players.LocalPlayer.Name]["armTemplateRight"]	
		local body = game.Workspace.template[game.Players.LocalPlayer.Name]["bodyTemplate"]
		
		body["ManualWeld"].Part1 = root
		leftArm["ManualWeld"].Part1 = body
		rightArm["ManualWeld"].Part1 = body
	end
end)