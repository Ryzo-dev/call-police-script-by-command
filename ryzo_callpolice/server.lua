ESX = exports['es_extended']:getSharedObject()

local cooldowns = {}

RegisterCommand('callpolice', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    if xPlayer.job.name ~= 'ambulance' then
        TriggerClientEvent('esx:showNotification', source, 'אין לך הרשאה להשתמש בפקודה זו')
        return
    end

    local now = os.time()
    if cooldowns[source] and now < cooldowns[source] then
        TriggerClientEvent(
            'esx:showNotification',
            source,
            'עליך להמתין ' .. (cooldowns[source] - now) .. ' שניות לפני קריאה נוספת'
        )
        return
    end

    cooldowns[source] = now + 60

    TriggerClientEvent('ryzo_callpolice:doMe', source)

    local ped = GetPlayerPed(source)
    local coords = GetEntityCoords(ped)

    for _, id in ipairs(ESX.GetPlayers()) do
        local target = ESX.GetPlayerFromId(id)
        if target and target.job.name == 'police' then
            TriggerClientEvent('ryzo_callpolice:alertPolice', id, coords)
        end
    end
end)

AddEventHandler('playerDropped', function()
    cooldowns[source] = nil
end)
