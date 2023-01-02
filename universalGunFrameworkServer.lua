function giveGun(player, gunName, handleName, customArmColor)
	local templateFolder = Instance.new("Folder", workspace.template)
	templateFolder.Name = player
	
	local Player = game.Players[player] or game.Players[player.name]
	local gun = nil
	local grip = nil
	local found = false
	
	for i,v in pairs(game.Workspace:GetDescendants()) do
		if v.Name == gunName then
			gun = v:Clone()
			gun.Parent = workspace.template[player]
			found = true
			grip = gun["gripHandle"]
		end
	end
	
	if not found then
		warn("Gun Framework - Could not find the specified gun: "..gunName..". Are you sure you named it correctly?")
	end
	
	for i,v in pairs(Player.Character:GetChildren()) do
		if string.find(v.Name, "Arm") or string.find(v.Name, "Hand") then
			v.Transparency = 1
		end
	end
	
	local armRight = nil
	local armLeft = nil
	local body = nil
	local templateFound = 0
	
	for i,v in pairs(workspace:GetDescendants()) do
		if v.Name == "armTemplateLeft" then
			templateFound = templateFound + 1
			armLeft = v:Clone()
			armLeft.Anchored = false
		elseif v.Name == "armTemplateRight" then
			templateFound = templateFound + 1
			armRight = v:Clone()
			armRight.Anchored = false
		elseif v.Name == "bodyTemplate" then
			templateFound = templateFound + 1
			body = v:Clone()
			body.Anchored = false
		end
	end
	
	if templateFound < 3 then
		warn("Gun Framework - Could not find the custom arms template part. Are you sure it exists and that it's named correctly?")
	end
	
	local changed, err = pcall(function()
		armLeft.Color = customArmColor or Color3.fromRGB(255,255,255)
		armRight.Color = customArmColor or Color3.fromRGB(255,255,255)
	end)
	
	if not changed then
		warn("Gun Framework - Could not change custom arms color.")
	end
	
	armRight.Parent = templateFolder
	armLeft.Parent = templateFolder
	body.Parent = templateFolder
	
	armRight["ManualWeld"].Part1 = body
	armLeft["ManualWeld"].Part1 = body
	
	local weldBody = Instance.new("Weld", body)
	weldBody.Part0 = body
	weldBody.Part1 = Player.Character["HumanoidRootPart"]
	
	local weld = Instance.new("Weld", grip)
	weld.Part0 = grip
	local _,err = pcall(function()
		weld.Part1 = workspace.template[player]["armTemplateRight"]
		weld.C1 = CFrame.new(workspace.template[player]["armTemplateRight"].CFrame.LookVector * -1) * CFrame.Angles(math.rad(-90),0,0)
	end)
	
	for i,v in pairs(gun:GetDescendants()) do
		if v:IsA("Part") or v:IsA("BasePart") then
			v.CanCollide = false
		end
		if v.Name == handleName then
			grip = v
		end
	end
	
	if err then
		warn("Gun Framework - Custom arms did not load correctly or the gun is not equipped.")
		warn(err)
	end
end

task.wait(10)
giveGun("foxwire121", "Gun", "gripHandle")