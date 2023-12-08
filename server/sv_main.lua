QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('ss-jobcenter:server:openJobCenter', function()
    local source = source
    TriggerClientEvent('ss-jobcenter:client:openJobCenter', source, Config)
end)

RegisterNetEvent('ss-jobcenter:server:setup', function()
    TriggerClientEvent('ss-jobcenter:client:setup', source, Config.Main)
end)

RegisterNetEvent('ss-jobcenter:server:startJob', function(job)
    local source = source
    local Player = QBCore.Functions.GetPlayer(source)

    local jobExists = false
    for k, v in pairs(Config.Jobs) do
        if v.rank == job then
            jobExists = true
        end
    end

    for k,v in pairs(Config.Main.Locations) do
        if #(GetEntityCoords(GetPlayerPed(source)) - vector3(v.coords.x, v.coords.y, v.coords.z)) < 1.5 then
            if jobExists then
                Player.Functions.SetJob(job, 0)
                TriggerClientEvent('QBCore:Notify', source, 'You are now a ' .. job .. '!', 'success')
            else
                TriggerClientEvent('QBCore:Notify', source, 'This job does not exist!', 'error')
            end
        else
            TriggerClientEvent('QBCore:Notify', source, 'You are not at the job center!', 'error')
        end
    end
end)