RegisterNetEvent('ss-jobcenter:server:openJobCenter', function()
    local src = source

    TriggerClientEvent('ss-jobcenter:client:openJobCenter', src, Config)
end)