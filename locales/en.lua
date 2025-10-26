local Translations = {
    progressbar = 'Crafting %{item}',
    failedMinigame = 'Crafting failed! You did not pass the minigame.',
    cancelledCrafting = 'Crafting cancelled.',
    menus = {
        input = {
            Header = 'Amount To Craft',
            submit = 'Confirm',
            amountLabel = 'Amount',
            text = 'Enter Amount',
        },
        context = {
            has = '🟢 X %{amount} %{item} <br>',
            doesnt = '❌ X %{amount} %{item} <br>',
            header = 'Crafting',
        },
    },
    pickedUp = 'You Have Picked Up Your Bench!',
    interacts = {
        startCrafting = 'Use Bench',
        removeBench = 'Pick Up Bench',
    },
    failedDist = {
        warn = '^3 [WARNING] ^7 Player ^7 (%{citizenid}) failed a distance check. ^1 (%{current}/3)',
        kicked = 'You were kicked for failing distance checks multiple times, Staff have been notified.',
    },
    xpGain = 'You have gained %{xp} %{xpType} reputation!',
    failedChecks = {
        failedNoTable = 'You Dont Have A Table To Pick Up',
        tooFar = 'You Are Too Far From The Crafting Table',
        noItems = 'You Do Not Have The Required Items To Craft This',
        inUse = 'You Already Have A Crafting Table Outside',
        notclose = 'You Are Not Close Enough To Place The Table',
    },
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
