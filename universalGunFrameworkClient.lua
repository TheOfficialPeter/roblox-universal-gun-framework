local char = game.Players.LocalPlayer.Character
local gunFolderName = "" -- change this to the gunFolder's name
local gunFolder = nil
local playerFolder = nil
local shoots = {} -- all the times you started shooting

-- Load folders
for i,v in pairs(workspace:GetDescendants()) do
	if v.Name == gunFolderName then
		gunFolder = v
		playerFolder = gunFolder[char.Name]
	end
end

if gunFolder == nil or playerFolder == nil then print("Gun Framework (Client) - Could not find the gun folder with name " + gunFolderName + " or player folder is missing") end

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

UIS.InputBegan:Connect(function(input, _process)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		if playerFolder ~= nil then -- change this to check if the gun exists
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
			
			-- you can also change this to a custom players folder if you are using custom characters
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
		-- change arms positions
	end
end)