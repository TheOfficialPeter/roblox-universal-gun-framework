task.wait(10)

local char = game.Players.LocalPlayer.Character
local root = char:WaitForChild("HumanoidRootPart")
local mouse = game.Players.LocalPlayer:GetMouse()
local isHolding1 = false -- holding mouse button1
local isHolding2 = false -- holding mouse button2
local gunFolderName = "Guns" -- change this to the gunFolder's name
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

if gunFolder == nil or playerFolder == nil then print("Gun Framework (Client) - Could not find the gun folder with name "..gunFolderName.." or player folder is missing. Check server script errors") end

-- Locks your camera in first person. remove if your game uses Third Person mechanics
function setFirstPersonLock()
	game.Players.LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
end

function checkShoot()
	local shootRemote = game.ReplicatedStorage:FindFirstChild("checkShoot", 120) -- wait 2 mins max for remotes to load

	-- send list of previous shots fired
	shootRemote:FireServer(shoots)
end

function reload()
	local reloadRemote = game.ReplicatedStorage:WaitForChild("reload", 120) -- wait 2 mins max for remotes to load

	-- send list of previous shots fired
	reloadRemote:FireServer(shoots)
end

local UIS = game:GetService("UserInputService")

UIS.InputBegan:Connect(function(input, _process)
	-- TODO: add gun effects when click
	if input.UserInputType == Enum.UserInputType.MouseButton1 and isHolding1 == false then
		if #playerFolder:GetChildren() > 0 then -- check if gun equipped
			isHolding1 = true
			while isHolding1 do -- check for mouse button1 hold
				task.wait()
				local visualRay = Instance.new("Part", workspace) -- NOTICE: This is ray visualising. remove this when done.
				visualRay.Name = "visualRay"
				local distance = (playerFolder["Gun"]["gripHandle"].CFrame.Position - game.Players.LocalPlayer:GetMouse().Hit.Position).Magnitude
				visualRay.Size = Vector3.new(.1,.1,distance)
				visualRay.Material = Enum.Material.Neon
				visualRay.CanCollide = false
				visualRay.Color = Color3.fromRGB(255, 255, 255)
				visualRay.Anchored = true
				visualRay.CFrame = CFrame.new(playerFolder["Gun"]["gripHandle"].CFrame.Position, game.Players.LocalPlayer:GetMouse().Hit.Position)
				visualRay.CFrame = visualRay.CFrame + visualRay.CFrame.LookVector * distance/2

				task.spawn(function()
					task.wait(1)
					visualRay:Destroy()
				end)

				local raycastParams = RaycastParams.new()
				raycastParams.FilterDescendantsInstances = {visualRay, game.Players.LocalPlayer.Character, playerFolder[game.Players.LocalPlayer.Name]}
				raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
				raycastParams.IgnoreWater = true

				local direction = (game.Players.LocalPlayer:GetMouse().Hit.Position - playerFolder["Gun"]["gripHandle"].CFrame.Position).Unit
				local rayResult = workspace:Raycast(playerFolder["Gun"]["gripHandle"].CFrame.Position, direction, raycastParams)
				local hit = rayResult.Instance

				-- you can also change this to a custom players folder if you are using custom characters. This is client-sided raycast validation
				if game.Players[hit.Parent.Name] then
					local enemy = game.Players[hit.Parent.Name]
				elseif game.Players[hit.Parent.Parent.Name] then
					local enemy = game.Players[hit.Parent.Parent.Name]
				end

				table.insert(shoots, rayResult) -- add shots fired to the list
			end
		end
	elseif input.UserInputType == Enum.UserInputType.MouseButton2 and isHolding2 == false then
		-- TODO: Add aim down sight (ads)
		if #playerFolder:GetChildren() > 0 then -- check if gun equipped
			isHolding2 = true
			while isHolding2 do
				task.wait()
			end

			if isHolding2 == false then
				-- remove ADS
			end
		end
	end
end)

UIS.InputEnded:Connect(function(input, gameProcessedEvent)
	if input.UserInputType == Enum.UserInputType.MouseButton1 and isHolding1 == true then
		isHolding1 = false
	elseif input.UserInputType == Enum.UserInputType.MouseButton2 and isHolding2 == true then
		isHolding2 = false
	end
end)

function getArms()
	local rightS = nil
	local leftS = nil

	for i,v in pairs(char:GetDescendants()) do
		if v.Name == "RightShoulder" then
			rightS = v
		elseif v.Name == "LeftShoulder" then
			leftS = v
		end
	end

	if rightS ~= nil and leftS ~= nil then
		return rightS, leftS
	end
end

local rightS, leftS = getArms()

game:GetService("RunService").RenderStepped:Connect(function()
	if #playerFolder:GetChildren() > 0 then
		-- change arm positions
		-- TODO: change arm position with camera
		local hit = (root.Position.Y - mouse.Hit.Position.Y)/100
		local mag = (root.Position - mouse.Hit.Position).Magnitude/100
		local offset = hit/mag

		rightS.C0 = rightS.C0:Lerp(CFrame.new(1, 0.5, 0, 0, 0, 1, 0, 1, 0, -1, -0, -0) * CFrame.fromEulerAnglesXYZ(0, 0, -offset),0.3)
		leftS.C0 = leftS.C0:Lerp(CFrame.new(-1, 0.5, 0, -0, -0, -1, 0, 1, 0, 1, 0, 0) * CFrame.fromEulerAnglesXYZ(0, 0, offset),0.3)
	end
end)