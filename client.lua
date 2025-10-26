local p = nil
local bench = nil

-- Functions
local function getLabel(item)
    return QBCore.Shared.Items[item] and QBCore.Shared.Items[item].label or item
end

local function getImage(item)
    return QBCore.Shared.Items[item] and Config.ImageBasePath .. QBCore.Shared.Items[item].image or 'default.png'
end

local function progressbar(name, time)
    p = promise:new()
    QBCore.Functions.Progressbar('crafting_item', Lang:t('progressbar', {item = getLabel(name)}), time, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = 'mini@repair',
        anim = 'fixing_a_player',
        flags = 16,
    }, {}, {}, function()
        p:resolve(true)
        p = nil
    end, function()
        p:resolve(false)
        p = nil
    end)
    return Citizen.Await(p)
end

local function CraftItem(craftedItem, amountToCraft, id)
    local success = true
    local count = amountToCraft
    repeat
        if Config[bench].recipes[id].minigame then
            local pass = exports['qb-minigames']:Skillbar(Config[bench].recipes[id].minigame, '12345')
            if not pass then
                TriggerServerEvent('qb-crafting:server:removeMaterials', id)
                QBCore.Functions.Notify(Lang:t('failedMinigame'), 'error')
                success = false
                return false
            end
        end

        if not progressbar(craftedItem, (math.random(2000, 5000))) then
            QBCore.Functions.Notify(Lang:t('cancelledCrafting'), 'error')
            return false
        end

        local pass = QBCore.Functions.TriggerCallback('qb-crafting:server:craftItem', id)
        if not pass then
            success = false
            return false
        end

        count = count - 1
        Wait(10)
    until not success or count == 0
    return true
end

local function getMaxAmount(items, maxCreate)
    local max = 0
    for i = 1, tonumber(maxCreate) do
        local need, have = 0, 0
        for _, reqItem in ipairs(items) do
            need = need + 1
            if exports['qb-inventory']:HasItem(reqItem.item, reqItem.amount * i) then
                have = have + 1
            end
        end
        if need == have then
            max = i
        else
            break
        end
    end
    return max
end

local function CraftAmount(item, maxAmount)
    local dialog = exports['qb-input']:ShowInput({
        header = Lang:t('menus.input.Header'),
        submitText = Lang:t('menus.input.submit'),
        inputs = {
            {
                type = 'number',
                name = 'amount',
                label = Lang:t('menus.input.amountLabel'),
                text = Lang:t('menus.input.text'),
                isRequired = true,
                max = maxAmount,
            },
        },
    })
    if dialog and dialog.amount then
        local amount = tonumber(dialog.amount)
        local getMax = getMaxAmount(item, maxAmount)
        if amount > getMax then
            amount = getMax
        end
        return amount or false
    else
        return false
    end
end

local function canCraft(recipe, id)
    local need, have, text = 0, 0, ''
    for k, v in pairs (recipe[id].requiredItems) do
        need = need + 1
        if exports['qb-inventory']:HasItem(v.item, v.amount) then
            have = have + 1
            text = text .. Lang:t('menus.context.has', {amount = v.amount, item = getLabel(v.item)})
        else
            text = text .. Lang:t('menus.context.doesnt', {amount = v.amount, item = getLabel(v.item)})
        end
    end
    return need == have, text
end

local function OpenCraftingMenu()
    local PlayerData = QBCore.Functions.GetPlayerData()
    local currentXP = PlayerData.metadata[Config[bench].xpType] or 0
    local menu = {}
    menu[#menu + 1] = {
        header = Lang:t('menus.context.header'),
        icon = 'fas fa-drafting-compass',
        isMenuHeader = true,
        list = 'a'
    }
    for id, recipe in pairs(Config[bench].recipes) do
        if currentXP >= recipe.xpRequired then
            local canCraft, itemsText = canCraft(Config[bench].recipes, id)
            menu[#menu + 1] = {
                header = getLabel(recipe.item),
                list = getLabel(recipe.item),
                txt = itemsText,
                icon = getImage(recipe.item),
                action = function()
                    local amount = CraftAmount(recipe.requiredItems, recipe.maxCreate)
                    if not amount then return end
                    if not CraftItem(recipe.item, amount, id) then
                        return
                    end
                    if not Config.UseTarget then
                        exports['qb-interact']:showInteract()
                    end
                end,
                disabled = not canCraft
            }
        end
    end
    table.sort(menu, function(a, b)
        return a.header < b.header
    end)
    exports['qb-menu']:openMenu(menu)
end

local craftingBench = nil
local function PickupBench()
    if DoesEntityExist(craftingBench) then
        DeleteEntity(craftingBench)
        TriggerServerEvent('qb-crafting:server:addCraftingTable', bench)
        QBCore.Functions.Notify(Lang:t('pickedUp'), 'success')
        if not Config.UseTarget then
            exports['qb-interact']:removeInteractZones(craftingBench)
        else
            exports['qb-target']:RemoveTargetEntity(craftingBench)
        end
        craftingBench = nil
        bench = nil
    end
end


QBCore.Functions.CreateClientCallback('qb-crafting:client:useCraftingTable', function(cb, benchType)
    local playerPed = PlayerPedId()
    local coordsP = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 1.0, 1.0)
    local playerHeading = GetEntityHeading(PlayerPedId())
    local itemHeading = playerHeading - 90
    bench = benchType
    craftingBench = CreateObject(Config[benchType].object, coordsP, true, true, true)
    if itemHeading < 0 then itemHeading = 360 + itemHeading end
    SetEntityHeading(craftingBench, itemHeading)
    PlaceObjectOnGroundProperly(craftingBench)
    local options = {
        {
            icon = 'fas fa-tools',
            label = Lang:t('interacts.startCrafting'),
            action = function()
                OpenCraftingMenu()
            end
        },
        {
            event = 'crafting:pickupWorkbench',
            icon = 'fas fa-hand-rock',
            label = Lang:t('interacts.removeBench'),
            action = function()
                PickupBench()
            end,
        }
    }
    if Config.UseTarget then
        exports['qb-target']:AddTargetEntity(craftingBench, {
            options = options,
            distance = 2.5
        })
    else
        exports['qb-interact']:addEntityZone(craftingBench, {
            length = 3,
            width = 3,
            height = 4.0,
            debugPoly = true,
            options = options,
        })
    end
    cb(GetEntityCoords(craftingBench))
end)

RegisterNetEvent('qb-crafting:removeCraftingTable', function()
    if DoesEntityExist(craftingBench) then
        DeleteEntity(craftingBench)
        craftingBench = nil
        bench = nil
    end
end)