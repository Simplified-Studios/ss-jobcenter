Config = {}
local zones = {}

RegisterNetEvent('ss-jobcenter:client:setup', function(cfg)
    Config = cfg
    for k, v in pairs(Config.Locations) do
        RequestModel(v.model)
        while not HasModelLoaded(v.model) do
            Wait(1)
        end
        local ped = CreatePed(4, v.model, v.coords.x, v.coords.y, v.coords.z - 1, v.coords.w, false, true)
        PlaceObjectOnGroundProperly(ped)
        SetEntityHeading(ped, v.coords.w)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        SetModelAsNoLongerNeeded(v.model)
        FreezeEntityPosition(ped, true)
        if Config.useTarget == 'qb' then
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
        elseif Config.useTarget == 'ox' then
            local params = {
                label = "Job Center",
                name = "jobcenter",
                icon = "fas fa-briefcase",
                iconColor = "#ffffff",
                distance = 3.0,
                serverEvent = "ss-jobcenter:server:openJobCenter",
            }
            exports.ox_target:addLocalEntity(ped, params)
        elseif Config.useTarget == 'lib' then
            local params = {
                coords = vec3(v.coords.x, v.coords.y, v.coords.z),
                size = vec3(3.0, 3.0, 1.0),
                rotation = v.coords.w,
                onEnter = function()
                    lib.showTextUI('[E] City Hall')
                end,
                inside = function()
                    if IsControlJustPressed(0, 38) then
                        lib.hideTextUI()
                        TriggerServerEvent('ss-jobcenter:server:openJobCenter')
                    end
                end,
                onExit = function()
                    lib.hideTextUI()
                end,
                debug = Config.Debug,
            }
            local zone = lib.zones.box(params)
            zones[#zones + 1] = zone
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

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    TriggerServerEvent('ss-jobcenter:server:setup')
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        TriggerServerEvent('ss-jobcenter:server:setup')
    end
end)