Config = {}
peds = {}

RegisterNetEvent('ss-jobcenter:client:setup', function(cfg)
    Config = cfg
    for k, v in pairs(Config.Locations) do
        print(k)
        RequestModel(v.model)
        while not HasModelLoaded(v.model) do
            Wait(1)
        end
        peds[k] = CreatePed(4, v.model, v.coords.x, v.coords.y, v.coords.z - 1, v.coords.w, false, true)
        PlaceObjectOnGroundProperly(peds[k])
        SetEntityHeading(peds[k], v.coords.w)
        SetEntityInvincible(peds[k], true)
        SetBlockingOfNonTemporaryEvents(peds[k], true)
        SetModelAsNoLongerNeeded(v.model)
        FreezeEntityPosition(peds[k], true)
        if Config.target == 'qb' then
            exports['qb-target']:AddTargetEntity(peds[k], {
                options = {
                    {
                        type = 'server',
                        event = 'ss-jobcenter:server:openJobCenter',
                        icon = "fas fa-briefcase",
                        label = "Job Center",
                    },
                },
                distance = 1.5,
            })
        elseif Config.target == 'ox' then
            local params = {
                label = "Job Center",
                name = "jobcenter",
                icon = "fas fa-briefcase",
                iconColor = "#ffffff",
                distance = 3.0,
                serverEvent = "ss-jobcenter:server:openJobCenter",
            }
            exports.ox_target:addLocalEntity(peds[k], params)
        end

        local blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
        SetBlipSprite(blip, 407)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.7)
        SetBlipColour(blip, 0)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Job Center")
        EndTextCommandSetBlipName(blip)
    end
end)

RegisterNetEvent('ss-jobcenter:client:openJobCenter', function(config)
    SendNUIMessage({
        type = 'open',
        config = config,
    })
    SetNuiFocus(true, true)
end)

RegisterNUICallback('select', function(data, cb)
    TriggerServerEvent('ss-jobcenter:server:select', data)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)