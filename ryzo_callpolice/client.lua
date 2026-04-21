ESX = exports['es_extended']:getSharedObject()

RegisterNetEvent('ryzo_callpolice:doMe')
AddEventHandler('ryzo_callpolice:doMe', function()
    local ped = PlayerPedId()

    local animDict = "random@arrests"
    local animName = "generic_radio_chatter"

    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(10)
    end

    PlaySoundFrontend(-1, "Radio_On", "Police_Radio_Soundset", true)
    Wait(250)
    PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", true)

    TaskPlayAnim(
        ped,
        animDict,
        animName,
        8.0,
        -8.0,
        4000,
        49,
        0,
        false,
        false,
        false
    )

    ExecuteCommand('me Calling the Police')

    CreateThread(function()
        Wait(4000)
        ClearPedTasks(ped)
        PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", true)
        Wait(200)
        PlaySoundFrontend(-1, "Radio_Off", "Police_Radio_Soundset", true)
    end)
end)

RegisterNetEvent('ryzo_callpolice:alertPolice')
AddEventHandler('ryzo_callpolice:alertPolice', function(coords)
    ESX.ShowNotification('EMS needs a police officer at the location marked on the map')

    PlaySoundFrontend(-1, '5_Second_Timer', 'DLC_HEISTS_GENERAL_FRONTEND_SOUNDS', true)

    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    setBlipSprite(blip, 153)
    SetBlipColour(blip, 1)
    SetBlipScale(blip, 1.2)
    SetBlipAsShortRange(blip, false)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('EMS Call')
    EndTextCommandSetBlipName(blip)

    CreateThread(function()
        Wait(60000)
        RemoveBlip(blip)
    end)
end)

RegisterCommand('callpolice_keybind', function()
    ExecuteCommand('callpolice')
end, false)

RegisterKeyMapping(
    'callpolice_keybind',
    'call_police',
    'keyboard',
    'F10'
)
