function giveGun(player, gunName, handleName, armTemplateName, customArmColor)
	local armsFolder = Instance.new("Folder", workspace.arms)
	armsFolder.Name = player
	
	local Player = game.Players[player] or game.Players[player.name]
	local gun = nil
	local grip = nil
	local found = false
	
	for i,v in pairs(game.Workspace:GetDescendants()) do
		if v.Name == gunName then
			gun = v:Clone()
			gun.Parent = workspace.arms[player]
			found = true
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
	local armsFound = false
	
	for i,v in pairs(workspace:GetDescendants()) do
		if v.Name == armTemplateName then
			armsFound = true
			armRight = v:Clone()
			armLeft = v:Clone()	
		end
	end
	
	
	if not armsFound then
		warn("Gun Framework - Could not find the custom arms template part. Are you sure it exists and that it's named correctly?")
	end
	
	local changed, err = pcall(function()
		armLeft.Color = customArmColor or Color3.fromRGB(255,255,255)
		armRight.Color = customArmColor or Color3.fromRGB(255,255,255)
	end)
	
	if not changed then
		warn("Gun Framework - Could not change custom arms color.")
	end
	
	armRight.Parent = armsFolder
	armLeft.Parent = armsFolder
	
	armRight.Anchored = false
	armLeft.Anchored = false
	
	armRight.Name = "armRight"
	armLeft.Name = "armLeft"
	
	for i,v in pairs(gun:GetDescendants()) do
		if v:IsA("Part") or v:IsA("BasePart") then
			v.CanCollide = false
		end
		if v.Name == handleName then
			grip = v
		end
	end
	
	local weldRight = Instance.new("Weld", armRight)
	weldRight.Part0 = armRight
	weldRight.Part1 = Player.Character["HumanoidRootPart"]
	weldRight.C1 = armRight.CFrame:ToObjectSpace(armRight.CFrame * CFrame.Angles(math.rad(80),math.rad(10),math.rad(-10)) + Vector3.new(-.5,.5,0) + armRight.CFrame.RightVector * 1.2)
	
	local weldLeft = Instance.new("Weld", armLeft)
	weldLeft.Part0 = armLeft
	weldLeft.Part1 = Player.Character["HumanoidRootPart"]
	weldLeft.C1 = armLeft.CFrame:ToObjectSpace(armLeft.CFrame * CFrame.Angles(math.rad(90), math.rad(-10), math.rad(50)) + Vector3.new(-1.5,.2,0) + armLeft.CFrame.RightVector * -.3)
	
	local weld = Instance.new("Weld", grip)
	weld.Part0 = grip
	local _,err = pcall(function()
		weld.Part1 = workspace.arms[player]["armRight"]
		weld.C1 = CFrame.new(workspace.arms[player]["armRight"].CFrame.LookVector * -1) * CFrame.Angles(math.rad(-90),0,0)
	end)
	
	if err then
		warn("Gun Framework - Custom arms did not load correctly or the gun could not be equipped.")
		warn(err)
	end
end

task.wait(10)