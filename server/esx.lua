if Config.Main.Framework == 'esx' then

    ESX = exports['es_extended']:getSharedObject()

    RegisterNetEvent('ss-jobcenter:server:select', function(data)
        local source = source
        local Player = ESX.GetPlayerFromId(source)
        local playerCoords = GetEntityCoords(GetPlayerPed(source))

        for _, location in pairs(Config.Main.Locations) do
            local distance = #(playerCoords - vector3(location.coords.x, location.coords.y, location.coords.z))

            if distance < 3.5 then
                if data.type == 'job' then
                    local jobExists = false

                    for _, job in pairs(Config.Jobs) do
                        if job.rank == data.job then
                            jobExists = true
                            break
                        end
                    end

                    if jobExists then
                        if ESX.DoesJobExist(data.job, 0) then 
                            Player.setJob(data.job, 0)
                            Player.showNotification('You have been hired as a '..data.job..'!')
                        else
                            Player.showNotification('Job or Grade does not exsist in database!')
                        end
                    else
                        Player.showNotification('Job or Grade does not exsist in database!')
                    end
                elseif data.type == 'license' then
                    local licenseExists = false
                    local license = nil

                    for _, l in pairs(Config.Licenses[Config.Main.Framework]) do
                        if l.name == data.license.name then
                            licenseExists = true
                            license = l
                            break
                        end
                    end

                    if licenseExists and license.item == data.license.item and license.price == data.license.price then
                        if Player.getMoney() >= license.price then
                            Player.removeMoney(license.price)
                            TriggerEvent('esx_license:addLicense', source, license.item, function()
                                Player.showNotification('You have been granted a '..license.name..' license!')
                            end)
                        else
                            Player.showNotification('You do not have enough money!')
                        end
                    else
                        Player.showNotification('WRONG? CONTACT ADMIN')
                    end
                end
            else
                Player.showNotification('You are not at the job center!')
            end
        end
    end)

    RegisterNetEvent('esx:playerLoaded', function(player, xPlayer, isNew)
        TriggerClientEvent('ss-jobcenter:client:setup', player, Config.Main)
    end)

    AddEventHandler('onResourceStart', function(Resource)
        if Resource == GetCurrentResourceName() then
            Wait(1000)
            TriggerClientEvent('ss-jobcenter:client:setup', -1, Config.Main)
        end
    end)
end