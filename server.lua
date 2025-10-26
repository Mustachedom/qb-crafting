local tablesOutside = {}
local drops = {}
-- Functions

local function failDistance(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if drops[Player.PlayerData.citizenid] then
        drops[Player.PlayerData.citizenid] = drops[Player.PlayerData.citizenid] + 1
        print(Lang:t('failedDist.warn', {citizenid = Player.PlayerData.citizenid, current = drops[Player.PlayerData.citizenid]}))
        if drops[Player.PlayerData.citizenid] >= 3 then
            DropPlayer(src, Lang:t('failedDist.kicked'))
        end
    else
        print(Lang:t('failedDist.warn', {citizenid = Player.PlayerData.citizenid, current = 1}))
        drops[Player.PlayerData.citizenid] = 1
    end
end

local function checkDistance(source, location, distance)
    local playerCoords = GetEntityCoords(GetPlayerPed(source))
    local dist = #(playerCoords - vector3(location.x, location.y, location.z))
    if dist <= distance then
        return true
    else
        failDistance(source)
        return false
    end
end

local function IncreasePlayerXP(source, xpGain, xpType)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        Player.Functions.AddRep(xpType, xpGain)
        TriggerClientEvent('QBCore:Notify', source, Lang:t('xpGain', {xp = xpGain, xpType = xpType}), 'success')
    end
end

QBCore.Functions.CreateCallback('crafting:getPlayerInventory', function(source, cb)
    local player = QBCore.Functions.GetPlayer(source)
    if player then
        cb(player.PlayerData.items)
    else
        cb({})
    end
end)
RegisterServerEvent('qb-crafting:server:removeMaterials', function(id)
    local src = source
    if not tablesOutside[src] then return end
    local benchType = tablesOutside[src].benchType
    local configBench = Config[benchType].recipes[id]
    local item = math.random(1, #configBench.requiredItems)
    local reqItem = configBench.requiredItems[item].item
    local removeAmount = math.random(1, configBench.requiredItems[item].amount)

    if exports['qb-inventory']:RemoveItem(src, reqItem, removeAmount, false, 'qb-crafting:server:removeMaterials') then
        TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items[reqItem], 'remove', removeAmount)
    end
end)

RegisterNetEvent('qb-crafting:server:addCraftingTable', function()
    local src = source
    if not tablesOutside[src] then
        QBCore.Functions.Notify(src, Lang:t('failedChecks.failedNoTable'), 'error')
        return
    end
    if not checkDistance(src, tablesOutside[src].coords, 4.0) then
        QBCore.Functions.Notify(src, Lang:t('failedChecks.tooFar'), 'error')
        return
    end
    if not exports['qb-inventory']:AddItem(src, tablesOutside[src].benchType, 1, false, false, 'qb-crafting:server:addCraftingTable') then return end
    TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items[tablesOutside[src].benchType], 'add')
    tablesOutside[src] = nil
end)

QBCore.Functions.CreateCallback('qb-crafting:server:craftItem', function(source, cb, id)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then cb(false) return end
    if not tablesOutside[src] then cb(false) return end
    local benchType = tablesOutside[src].benchType
    local configBench = Config[benchType].recipes[id]

    if not checkDistance(src, tablesOutside[src].coords, 5.0) then
        cb(false)
        return
    end

    local need, have = 0, 0
    for _, reqItem in ipairs(configBench.requiredItems) do
        need = need + 1
        if exports['qb-inventory']:HasItem(src, reqItem.item, reqItem.amount) then
            have = have + 1
        end
    end
    if need ~= have then
        QBCore.Functions.Notify(src, Lang:t('failedChecks.noItems'), 'error')
        cb(false)
        return
    end

    for _, reqItem in ipairs(configBench.requiredItems) do
        if not exports['qb-inventory']:RemoveItem(src, reqItem.item, reqItem.amount, false, 'qb-crafting:server:craftItem') then
            cb(false)
            return
        end
        TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items[reqItem.item], 'remove')
    end

    if exports['qb-inventory']:AddItem(src, configBench.item, 1, false, false, 'qb-crafting:server:craftItem') then
        IncreasePlayerXP(src, configBench.xpGain, Config[benchType].xpType)
        cb(true)
    else
        cb(false)
    end
end)

for benchType, v in pairs(Config) do
    if type(v) == 'table' then
        QBCore.Functions.CreateUseableItem(benchType, function(source)
            local src = source
            local Player = QBCore.Functions.GetPlayer(src)
            if not Player then return end

            if tablesOutside[src] then
                QBCore.Functions.Notify(src, Lang:t('failedChecks.inUse'), 'error')
                return
            end

            local test = QBCore.Functions.TriggerClientCallback('qb-crafting:client:useCraftingTable', src, benchType)
            if not checkDistance(src, test, 4.0) then
                QBCore.Functions.Notify(src, Lang:t('failedChecks.notclose'), 'error')
                return
            end

            tablesOutside[src] = {
                benchType = benchType,
                coords = test,
                src = src
            }
            exports['qb-inventory']:RemoveItem(src, benchType, 1, false, 'qb-crafting:server:removeCraftingTable')
        end)
    end
end

AddEventHandler('playerDropped', function()
    local src = source
    if tablesOutside[src] then
        exports['qb-inventory']:AddItem(src, tablesOutside[src].benchType, 1, false, false, 'qb-crafting:server:playerDropped')
        TriggerClientEvent('qb-crafting:removeCraftingTable', src)
        tablesOutside[src] = nil
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    for src, v in pairs(tablesOutside) do
        exports['qb-inventory']:AddItem(v.src, v.benchType, 1, false, false, 'qb-crafting:server:onResourceStop')
        tablesOutside[src] = nil
    end
end)