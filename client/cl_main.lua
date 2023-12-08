Config = {}

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    TriggerServerEvent('ss-jobcenter:server:setup')
end)

RegisterNetEvent('ss-jobcenter:client:setup', function(cfg)
    Config = cfg
    for k, v in pairs(Config.Locations) do
        RequestModel(v.model)
        while not HasModelLoaded(v.model) do
            Wait(10)
        end
        local ped = CreatePed(4, v.model, v.coords.x, v.coords.y, v.coords.z-1, v.coords.w, false, true)
        PlaceObjectOnGroundProperly(ped)
        SetEntityHeading(ped, v.coords.w)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        SetModelAsNoLongerNeeded(v.model)
        FreezeEntityPosition(ped, true)
        if Config.useTarget then
            exports['qb-target']:AddTargetEntity(ped, {
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
        else
            local zones = {}
            for k,v in pairs(Config.Locations) do
                local zone = CircleZone:Create(v.coords, 3.0, {
                    name = 'jobcenter_' .. k,
                    debugPoly = false,
                })
                zones[#zones + 1] = zone
            end

            local combo = ComboZone:Create(zones, {
                name = 'jobcenter_combo',
                debugPoly = false,
            })
    
            combo:onPlayerInOut(function(isPointInside)
                if isPointInside then
                    exports['qb-core']:DrawText('Open Jobcenter')
                    CreateThread(function()
                        while isPointInside do
                            Wait(0)
                            if IsControlJustPressed(0, 38) then
                                TriggerServerEvent('ss-jobcenter:server:openJobCenter')
                                break
                            end
                        end
                    end)
                else
                    exports['qb-core']:HideText()
                end
            end)
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

RegisterNUICallback('startJob', function(data, cb)
    TriggerServerEvent('ss-jobcenter:server:startJob', data.rank)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)