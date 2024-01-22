QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('ss-jobcenter:server:openJobCenter', function()
    local source = source
    TriggerClientEvent('ss-jobcenter:client:openJobCenter', source, Config)
end)

RegisterNetEvent('ss-jobcenter:server:setup', function()
    TriggerClientEvent('ss-jobcenter:client:setup', source, Config.Main)
end)

RegisterNetEvent('ss-jobcenter:server:select', function(data)
    local source = source
    local Player = QBCore.Functions.GetPlayer(source)
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
                    Player.Functions.SetJob(data.job, 0)
                    TriggerClientEvent('QBCore:Notify', source, 'You are now a ' .. data.job .. '!', 'success')
                else
                    TriggerClientEvent('QBCore:Notify', source, 'This job does not exist!', 'error')
                end
            elseif data.type == 'license' then
                local licenseExists = false
                local license = nil

                for _, l in pairs(Config.Licenses) do
                    if l.name == data.license.name then
                        licenseExists = true
                        license = l
                        break
                    end
                end

                if licenseExists and license.item == data.license.item and license.price == data.license.price then
                    if Player.PlayerData.money.cash >= license.price then
                        Player.Functions.RemoveMoney('cash', license.price)
                        local info = {}

                        if license.item == 'id_card' then
                            info = {
                                citizenid = Player.PlayerData.citizenid,
                                firstname = Player.PlayerData.charinfo.firstname,
                                lastname = Player.PlayerData.charinfo.lastname,
                                birthdate = Player.PlayerData.charinfo.birthdate,
                                gender = Player.PlayerData.charinfo.gender,
                                nationality = Player.PlayerData.charinfo.nationality
                            }
                        elseif license.item == 'driver_license' then
                            info = {
                                firstname = Player.PlayerData.charinfo.firstname,
                                lastname = Player.PlayerData.charinfo.lastname,
                                birthdate = Player.PlayerData.charinfo.birthdate,
                                type = 'Class C Driver License'
                            }
                        elseif license.item == 'weaponlicense' then
                            info = {
                                firstname = Player.PlayerData.charinfo.firstname,
                                lastname = Player.PlayerData.charinfo.lastname,
                                birthdate = Player.PlayerData.charinfo.birthdate
                            }
                        else
                            Player.Functions.AddItem(license.item, 1, nil, info)
                            TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[license.item], 'add')
                        end

                        Player.Functions.AddItem(license.item, 1, nil, info)
                        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[license.item], 'add')
                        TriggerClientEvent('QBCore:Notify', source, 'You have purchased a ' .. license.name .. '!', 'success')
                    else
                        TriggerClientEvent('QBCore:Notify', source, 'You do not have enough money!', 'error')
                    end
                else
                    TriggerClientEvent('QBCore:Notify', source, 'WRONG? CONTACT ADMIN', 'error')
                end
            end
        else
            TriggerClientEvent('QBCore:Notify', source, 'You are not at the job center!', 'error')
        end
    end
end)