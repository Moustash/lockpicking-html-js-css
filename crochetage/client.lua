RegisterNetEvent('chatCommandEntered')

local guiEnabled = false

function DisplayNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function PrintChatMessage(text)
    TriggerEvent('chatMessage', "system", { 255, 0, 0 }, text)
end

function EnableGui(enable)
    SetNuiFocus(enable)
    guiEnabled = enable

    SendNUIMessage({
        type = "enableui",
        enable = enable
    })
end

AddEventHandler('chatCommandEntered', function(commands, player)
    PrintChatMessage(json.encode(commands))
    
    if commands[1] == "/test" then
        EnableGui(true)
    end
end)

RegisterCommand('test', function() 
    local commands = {'/test'}
    local player = PlayerPedId()
    TriggerEvent('chatCommandEntered', commands, player)
end,false)

RegisterNUICallback('escape', function(data, cb)
    EnableGui(false)

    cb('ok')
end)
    
Citizen.CreateThread(function()
    while true do
        if guiEnabled then
            DisableControlAction(0, 1, guiEnabled) -- LookLeftRight
            DisableControlAction(0, 2, guiEnabled) -- LookUpDown

            DisableControlAction(0, 142, guiEnabled) -- MeleeAttackAlternate

            DisableControlAction(0, 106, guiEnabled) -- VehicleMouseControlOverride

            if IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
                SendNUIMessage({
                    type = "click"
                })
            end
            if IsControlJustPressed(1, 51) then
                guiEnabled = false
            end
        end
        Citizen.Wait(0)
    end
end)