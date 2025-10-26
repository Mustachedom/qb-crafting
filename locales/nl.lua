local Translations = {
    progressbar = 'Bezig met het maken van %{item}',
    failedMinigame = 'Maken mislukt! Je hebt de minigame niet gehaald.',
    cancelledCrafting = 'Maken geannuleerd.',
    menus = {
        input = {
            Header = 'Aantal te maken',
            submit = 'Bevestigen',
            amountLabel = 'Aantal',
            text = 'Voer aantal in',
        },
        context = {
            has = '🟢 X %{amount} %{item} <br>',
            doesnt = '❌ X %{amount} %{item} <br>',
            header = 'Maken',
        },
    },
    pickedUp = 'Je hebt je werkbank opgepakt!',
    interacts = {
        startCrafting = 'Gebruik werkbank',
        removeBench = 'Pak werkbank op',
    },
    failedDist = {
        warn = '^3 [WAARSCHUWING] ^7 Speler ^7 (%{citizenid}) faalde een afstandscontrole. ^1 (%{current}/3)',
        kicked = 'Je bent gekickt wegens meerdere afstandsfouten. Staf is op de hoogte gebracht.',
    },
    xpGain = 'Je hebt %{xp} %{xpType} reputatie verdiend!',
    failedChecks = {
        failedNoTable = 'Je hebt geen tafel om op te pakken',
        tooFar = 'Je bent te ver van de werkbank',
        noItems = 'Je hebt niet de vereiste items',
        inUse = 'Je hebt al een werkbank buiten',
        notclose = 'Je staat niet dicht genoeg om de tafel te plaatsen',
    },
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
