local GetPoint = vector3(-1862.32, 2098.642, 138.0792)
local StartEndWork = vector3(-1893.746, 2079.508, 140.9942)
local MakePoint = vector3(-1928.676, 2059.898, 140.8256)
local HaveJob = false
local CanWork = false
local BlipCoords = vector3(-1892.546, 2039.538, 140.8762)
local WeinBlip = 0
local CanMakeWine = false
local DisableMove = false
local CarSpawn = vector3(-1899.68, 2054.914, 140.8426)
local CarCoords
local CanSell = false
local SellCoords = {
	{x = -657.2704, y = -914.4132, z = 23.97216},
    {x = -584.4396, y = -900.0264, z = 25.6908},
	{x = 280.7078, y = -1517.868, z = 29.2799}

}


ESX              = nil
local PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end
	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  ESX.PlayerData = xPlayer   
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  ESX.PlayerData.job = job
end)

--Blip
Citizen.CreateThread(function()
	while true do
		Wait(2000)
		if ESX.PlayerData.job and ESX.PlayerData.job.name == "wine" then
			HaveJob = true
			if WeinBlip == nil or WeinBlip == 0 then
				WeinBlip = AddBlipForCoord(BlipCoords)
				SetBlipSprite(WeinBlip, 85)
				SetBlipDisplay(WeinBlip, 6)
				SetBlipScale(WeinBlip, 1.0)
				SetBlipColour(WeinBlip, 7)
				SetBlipAsShortRange(WeinBlip, false)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString("Vinice")
				EndTextCommandSetBlipName(WeinBlip)
			end
				
		else
			HaveJob = false
			if WeinBlip ~= nil or WeinBlip ~= 0 then
                RemoveBlip(WeinBlip)
                WeinBlip = 0
            end
		end
	end


end)

--Get VinoBalls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if ESX.PlayerData.job and ESX.PlayerData.job.name == "wine" then
			if HaveJob then
				local playerPed = GetPlayerPed(-1)	
				local plyCoords = GetEntityCoords(playerPed)
				local distance = GetDistanceBetweenCoords(plyCoords, GetPoint, true)
				if distance < 20 then
					DrawMarker(2, GetPoint, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 128, 0, 128, 150, false, true, 2, false, false, false, false)
					if distance < 2 then 
						ESX.ShowHelpNotification("Press ~INPUT_CONTEXT~ to collect kulicky vina", true, true, 5000)
						if IsControlJustReleased(1,46) then
							DisableMove = true
							exports['progressBars']:startUI(5000, "Collecting Kulicky vina")
							Citizen.Wait(5000)
							TriggerServerEvent("tmo_wine:GetHrozno", "hrozno", 1)
							DisableMove = false
						end
					end
				end
			end
		end
	end
end)
   



-- Make VINO

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		if ESX.PlayerData.job and ESX.PlayerData.job.name == "wine" then
			if HaveJob then
				local inventory = ESX.GetPlayerData().inventory
				local count = 0
				for i = 1, #inventory, 1 do
					if inventory[i].name == "hrozno" then
						count = inventory[i].count
						if count >= 5 then
							CanMakeWine = true
						else 
							CanMakeWine = false
						end
					
					end
				end
			end 
		end
	end

end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		if ESX.PlayerData.job and ESX.PlayerData.job.name == "wine" then
			if HaveJob then
				local inventory = ESX.GetPlayerData().inventory
				local count = 0
				for i = 1, #inventory, 1 do
					if inventory[i].name == "vino" then
						count = inventory[i].count
						if count >= 1 then
							CanSell = true
						else 
							CanSell = false
						end
					
					end
				end
			end 
		end
	end

end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if ESX.PlayerData.job and ESX.PlayerData.job.name == "wine" then
			if HaveJob then
				local playerPed = GetPlayerPed(-1)
				
				local plyCoords = GetEntityCoords(playerPed)
				local distance = GetDistanceBetweenCoords(plyCoords, MakePoint, true)
				if distance < 20 then
					DrawMarker(2, MakePoint, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 128, 0, 128, 150, false, true, 2, false, false, false, false)
					if distance < 2 then 
						ESX.ShowHelpNotification("Press ~INPUT_CONTEXT~ to make vino", true, true, 5000)
						if IsControlJustReleased(1,46) then
							DisableMove = true
							while CanMakeWine == true do
								exports['progressBars']:startUI(5000, "Making Vino")
								Citizen.Wait(5500)
								print("U GOT VINO")
								TriggerServerEvent("tmo_wine:MakeWine", "hrozno", "vino", 5, 1)
								Citizen.Wait(2000)
								
							end
							if CanMakeWine == false then
								DisableMove = false
								exports["k5_notify"]:notify('Notifikace', 'Nemáš dostatek hrozen!', 'error')
							end
						end
					end
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if DisableMove==true then
			DisableControlAction(0, 1,   true) -- LookLeftRight
			DisableControlAction(0, 2,   true) -- LookUpDown
			DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
			DisableControlAction(0, 142, true) -- MeleeAttackAlternate
			DisableControlAction(0, 30,  true) -- MoveLeftRight
			DisableControlAction(0, 31,  true) -- MoveUpDown
			DisableControlAction(0, 21,  true) -- disable sprint
			DisableControlAction(0, 24,  true) -- disable attack
			DisableControlAction(0, 25,  true) -- disable aim
			DisableControlAction(0, 47,  true) -- disable weapon
			DisableControlAction(0, 58,  true) -- disable weapon
			DisableControlAction(0, 263, true) -- disable melee
			DisableControlAction(0, 264, true) -- disable melee
			DisableControlAction(0, 257, true) -- disable melee
			DisableControlAction(0, 140, true) -- disable melee
			DisableControlAction(0, 141, true) -- disable melee
			DisableControlAction(0, 143, true) -- disable melee
			DisableControlAction(0, 75,  true) -- disable exit vehicle
			DisableControlAction(27, 75, true) -- disable exit vehicle

		end
		if DisableMove == false then
			EnableControlAction(0, 1,   true) -- LookLeftRight
			EnableControlAction(0, 2,   true) -- LookUpDown
			EnableControlAction(0, 106, true) -- VehicleMouseControlOverride
			EnableControlAction(0, 142, true) -- MeleeAttackAlternate
			EnableControlAction(0, 30,  true) -- MoveLeftRight
			EnableControlAction(0, 31,  true) -- MoveUpDown
			EnableControlAction(0, 21,  true) -- Enable sprint
			EnableControlAction(0, 24,  true) -- Enable attack
			EnableControlAction(0, 25,  true) -- Enable aim
			EnableControlAction(0, 47,  true) -- Enable weapon
			EnableControlAction(0, 58,  true) -- Enable weapon
			EnableControlAction(0, 263, true) -- Enable melee
			EnableControlAction(0, 264, true) -- Enable melee
			EnableControlAction(0, 257, true) -- Enable melee
			EnableControlAction(0, 140, true) -- Enable melee
			EnableControlAction(0, 141, true) -- Enable melee
			EnableControlAction(0, 143, true) -- Enable melee
			EnableControlAction(0, 75,  true) -- Enable exit vehicle
			EnableControlAction(27, 75, true) -- Enable exit vehicle

		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if ESX.PlayerData.job and ESX.PlayerData.job.name == "wine" then
				
			if HaveJob then
					local playerPed = GetPlayerPed(-1)
					local CS = false
					local plyCoords = GetEntityCoords(playerPed)
					local distance = GetDistanceBetweenCoords(plyCoords, CarSpawn, true)
					if distance < 20 and CanSell == true then
						DrawMarker(36, CarSpawn, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 128, 0, 128, 150, false, true, 2, false, false, false, false)
						if distance < 2 then 
							ESX.ShowHelpNotification("Press ~INPUT_CONTEXT~ to spawn car", true, true, 5000)
						
							if IsControlJustReleased(1,46) then
								print("car spawned")
							end

						end
					end
			end
			
		end
	end
end)