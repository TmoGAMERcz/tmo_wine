ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent('tmo_wine:GetHrozno')
AddEventHandler('tmo_wine:GetHrozno', function(itemName, amount)
	local source = source
	amount = amount
	local xPlayer = ESX.GetPlayerFromId(source)
	
    

	if xPlayer.canCarryItem(itemName, amount) then
		xPlayer.addInventoryItem(itemName, amount)
	end
end)

RegisterServerEvent("tmo_wine:MakeWine")
AddEventHandler("tmo_wine:MakeWine", function(removeName, addName, removeAmount, addAmount)
	local source = source
	amount = amount
	local xPlayer = ESX.GetPlayerFromId(source)
	
    

	if xPlayer.canCarryItem(addName, addAmount) then
		xPlayer.removeInventoryItem(removeName, removeAmount)
		xPlayer.addInventoryItem(addName, addAmount)
		
	end
end)


