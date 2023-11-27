-------- ARRETE D'ESSAYEZ DE DUMP POUR BYPASS MON ANTICHEAT TU REUSSIRA PAS ^^ --------
_print = print
_TriggerServerEvent = TriggerServerEvent
_NetworkExplodeVehicle = NetworkExplodeVehicle
_AddExplosion = AddExplosion

local uiFaded = false
local hunger, thirst = 0, 0

RegisterNetEvent("esx_status:onTick")
AddEventHandler("esx_status:onTick", function(status)
    TriggerEvent('esx_status:getStatus', 'hunger', function(status)
        hunger = status.val / 10000
    end)
    TriggerEvent('esx_status:getStatus', 'thirst', function(status)
        thirst = status.val / 10000
    end)
end)

AddEventHandler('tempui:toggleUi', function(value)
	uiFaded = value

	if uiFaded then
		SendNUIMessage({action = 'fadeUi', value = true})
	else
		SendNUIMessage({action = 'fadeUi', value = false})
	end
end)

AddEventHandler('korioz:switchFinished', function()
	local uiComponents = exports['serverdata']:GetData('uiComponents')
	local inFrontend = false

	SendNUIMessage({action = 'hideUi', value = false})

	for i = 1, #uiComponents, 1 do
		SendNUIMessage({action = 'hideComponent', component = uiComponents[i], value = false})
	end

	while true do
		Citizen.Wait(0)

		HideHudComponentThisFrame(1) -- Wanted Stars
		HideHudComponentThisFrame(2) -- Weapon Icon
		HideHudComponentThisFrame(3) -- Cash
		HideHudComponentThisFrame(4) -- MP Cash
		HideHudComponentThisFrame(6) -- Vehicle Name
		HideHudComponentThisFrame(7) -- Area Name
		HideHudComponentThisFrame(8) -- Vehicle Class
		HideHudComponentThisFrame(9) -- Street Name
		HideHudComponentThisFrame(13) -- Cash Change
		HideHudComponentThisFrame(17) -- Save Game
		HideHudComponentThisFrame(20) -- Weapon Stats

		if not uiFaded then
			if IsPauseMenuActive() or IsPlayerSwitchInProgress() then
				if not inFrontend then
					inFrontend = true
					SendNUIMessage({action = 'hideUi', value = true})
				end
			else
				if inFrontend then
					inFrontend = false
					SendNUIMessage({action = 'hideUi', value = false})
				end
			end
		end
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
			action = 'setStatuts',
			statuts = {
				{
					name = 'health',
					value = (GetEntityHealth(plyPed) - 100) * (100 / (GetEntityMaxHealth(plyPed) - 100))
				},
				{
					name = 'armor',
					value = GetPedArmour(plyPed) * (100 / GetPlayerMaxArmour(ply))
				},
				{
					name = 'hunger',
					value = hunger
				},
				{
					name = 'thirst',
					value = thirst
				}
			}
		})
	end
end)