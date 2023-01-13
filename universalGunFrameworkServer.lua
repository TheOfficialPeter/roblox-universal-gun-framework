local reloadRemote = nil
local checkShootRemote = nil

local reloadRemoteName = "" -- change this to the remote name that will reload
local checkShootRemoteName = "" -- change this to the remote name that will validate shots

for i,v in pairs(game.ReplicatedStorage:GetDescendants()) do
	if v.Name == checkShootRemoteName then
		checkShootRemote = v
	end
end

for i,v in pairs(game.ReplicatedStorage:GetDescendants()) do
	if v.Name == reloadRemoteName then
		reloadRemote = v
	end
end

if checkShootRemote == nil then
	print("Gun Framework - Could not find the remote that checks for shots fired with the name: "..checkShootRemoteName..". Creating remote...")
	checkShootRemoteName = "checkShoot"
	checkShootRemote = Instance.new("RemoteEvent", game.ReplicatedStorage)
	checkShootRemote.Name = checkShootRemoteName
end

if reloadRemote == nil then
	print("Gun Framework - Could not find the remote that reloads with the name: "..reloadRemoteName..". Creating remote...")
	reloadRemoteName = "reload"
	reloadRemote = Instance.new("RemoteEvent", game.ReplicatedStorage)
	reloadRemote.Name = reloadRemoteName
end

-- Use shots fired list and check for suspicious activity. Might change this check to something else in future
function checkShoot(player, shoots)

end

-- check ammo and give/revoke permission to reload
function checkReload(player, shots)

end

reloadRemote.OnServerEvent(checkReload) -- listen to remote event
checkShootRemote.OnServerEvent(checkShoot) -- listen to remote event

function giveGun(player, gunName, handleName, gunFolderName)

	-- all the guns that are equipped will be place inside of a folder
	local gunFolder = nil
	local playerFolder = nil
	local gun = nil

	-- search for gun
	for i,v in pairs(workspace:GetDescendants()) do
		if v.Name == gunName then
			gun = v
		end
	end

	-- search for gun folder
	for i,v in pairs(workspace:GetDescendants()) do
		if v.Name == gunFolderName then
			gunFolder = v
		end
	end

	if gun == nil then print("Gun Framework - Could not find gun with the name: "..gunName) end
	if gunFolder == nil then 
		print("Gun Framework - Could not find gun folder with the name: "..gunFolderName..". Creating new gun folder...") 
		gunFolder = Instance.new("Folder", workspace) -- Don't change the parent location here. This is the backup folder.
		gunFolder.Name = gunFolderName
	end

	-- create folder for all player's guns
	playerFolder = Instance.new("Folder", gunFolder)
	playerFolder.Name = player

	local clonedGun = gun:Clone()
	clonedGun.Parent = playerFolder -- store gun in player's folder

	-- TODO: Attach gun to player's hand
end

task.wait(5)
giveGun("foxwire121", "Gun", "gripHandle", "Guns")