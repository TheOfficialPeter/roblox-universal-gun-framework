local shoots = {}

function shoot()
	local shootRemote = game.ReplicatedStorage:FindFirstChild("shoot")

	shootRemote:FireServer(shoots)
end

function reload()
	local reloadRemote = game.ReplicatedStorage:FindFirstChild("reload")

	reloadRemote:FireServer(shoots)
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
			local visualRay = Instance.new("Part", workspace)
			visualRay.Name = "visualRay"
			local distance = (game.Workspace.template[game.Players.LocalPlayer.Name]["Gun"]["gripHandle"].CFrame.Position - game.Players.LocalPlayer:GetMouse().Hit.Position).Magnitude
			visualRay.Size = Vector3.new(.1,.1,distance)
			visualRay.Material = Enum.Material.Neon
			visualRay.CanCollide = false
			visualRay.Color = Color3.fromRGB(44, 255, 20)
			visualRay.Anchored = true
			visualRay.CFrame = CFrame.new(game.Workspace.template[game.Players.LocalPlayer.Name]["Gun"]["gripHandle"].CFrame.Position, game.Players.LocalPlayer:GetMouse().Hit.Position)
			visualRay.CFrame = visualRay.CFrame + visualRay.CFrame.LookVector * distance/2
			
			spawn(function()
				task.wait(3)
				visualRay:Destroy()
			end)
			
			local raycastParams = RaycastParams.new()
			raycastParams.FilterDescendantsInstances = {visualRay, game.Players.LocalPlayer.Character, game.Workspace.template[game.Players.LocalPlayer.Name]}
			raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
			raycastParams.IgnoreWater = true
			
			local direction = (game.Players.LocalPlayer:GetMouse().Hit.Position - game.Workspace.template[game.Players.LocalPlayer.Name]["Gun"]["gripHandle"].CFrame.Position).Unit
			local rayResult = workspace:Raycast(game.Workspace.template[game.Players.LocalPlayer.Name]["Gun"]["gripHandle"].CFrame.Position, direction, raycastParams)
			local hit = rayResult.Instance
			
			if hit then
				print(hit.Name)
			end

			if game.Players[hit.Parent.Name] then
				local enemy = game.Players[hit.Parent.Name]
			elseif game.Players[hit.Parent.Parent.Name] then
				local enemy = game.Players[hit.Parent.Parent.Name]
			end
			
			table.insert(shoots, rayResult)
		end
	end
end)

game:GetService("RunService").RenderStepped:Connect(function()
	if gunLoaded() then
		--local root = game.Players.LocalPlayer.Character["HumanoidRootPart"]
		--root["Waist"].C0 = CFrame.new(root["Waist"].C0.Position, game.Workspace.lookat.CFrame.Position)
		--workspace.lookat2.CFrame = CFrame.lookAt(workspace.lookat2.CFrame.Position, workspace.lookat.CFrame.Position)
		
		local leftArm = game.Workspace.template[game.Players.LocalPlayer.Name]["armTemplateLeft"]
		local rightArm = game.Workspace.template[game.Players.LocalPlayer.Name]["armTemplateRight"]	
		local body = game.Workspace.template[game.Players.LocalPlayer.Name]["bodyTemplate"]
		
		--leftArm["ManualWeld"].Part1 = root
		--rightArm["ManualWeld"].Part1 = root
		--local camX, camY, camZ = workspace.CurrentCamera.CFrame:ToEulerAnglesXYZ()
		
		-- THIS IS NOT WORKING
		body["ManualWeld"].C0 = CFrame.new(body["ManualWeld"].C0.Position, workspace.lookat.CFrame.Position)
		
		--local pitch = math.atan2(game.Players.LocalPlayer:GetMouse().Hit.lookVector.y, game.Players.LocalPlayer:GetMouse().Hit.lookVector.z)
		--local yaw = math.atan2(game.Players.LocalPlayer:GetMouse().Hit.LookVector.x, game.Players.LocalPlayer:GetMouse().Hit.lookVector.z)

		-- Set the orientation of the part using CFrame.Angles
		--body.CFrame = CFrame.Angles(0, yaw, pitch)
		
		leftArm["ManualWeld"].Part1 = body
		rightArm["ManualWeld"].Part1 = body
	end
end)