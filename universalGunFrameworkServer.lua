function giveGun(player, gunName, handleName, gunFolderName)

	-- all the guns that are equipped will be place inside of a folder
	local gunFolder = nil
	local playerFolder = nil
	local gun = nil

	for i,v in pairs(workspace:GetDescendants()) do
		if v.Name == gunName then
			gun = v
		end
	end

	for i,v in pairs(workspace:GetDescendants()) do
		if v.Name == gunFolderName then
			gunFolder = v
		end
	end

	if gun == nil then print("Gun Framework - Could not find gun with the name: " + gunName) end
	if gunFolder == nil then print("Gun Framework - Could not find gun folder with the name: " + gunFolderName) end

	-- create folder for every player's guns
	playerFolder = Instance.new("Folder", gunFolder)
	playerFolder.Name = player

	local clonedGun = gun:Clone()
	clonedGun.Parent = playerFolder -- store gun in player's folder

end

task.wait(10)
giveGun("foxwire121", "Gun", "gripHandle", "Template")