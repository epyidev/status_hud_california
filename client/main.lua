local uiFaded = false
local hunger, thirst = 0, 0

RegisterNetEvent("esx_status:onTick")
AddEventHandler("esx_status:onTick", function(status)
	TriggerEvent("esx_status:getStatus", "hunger", function(status)
		hunger = status.val / 10000
	end)
	TriggerEvent("esx_status:getStatus", "thirst", function(status)
		thirst = status.val / 10000
	end)
end)

AddEventHandler("tempui:toggleUi", function(value)
	uiFaded = value

	if uiFaded then
		SendNUIMessage({ action = "fadeUi", value = true })
	else
		SendNUIMessage({ action = "fadeUi", value = false })
	end
end)

Citizen.CreateThread(function()
	while true do
		TriggerEvent("esx_status:onTick")
		Citizen.Wait(2000)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		local ply = PlayerId()
		local plyPed = PlayerPedId()

		SendNUIMessage({
			action = "setStatuts",
			statuts = {
				{
					name = "health",
					value = (GetEntityHealth(plyPed) - 100) * (100 / (GetEntityMaxHealth(plyPed) - 100)),
				},
				{
					name = "armor",
					value = GetPedArmour(plyPed) * (100 / GetPlayerMaxArmour(ply)),
				},
				{
					name = "hunger",
					value = hunger,
				},
				{
					name = "thirst",
					value = thirst,
				},
			},
		})
	end
end)
