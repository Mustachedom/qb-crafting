local Translations = {
    progressbar = 'Stelle %{item} her',
    failedMinigame = 'Herstellung fehlgeschlagen! Du hast das Minispiel nicht bestanden.',
    cancelledCrafting = 'Herstellung abgebrochen.',
    menus = {
        input = {
            Header = 'Menge zum Herstellen',
            submit = 'Bestätigen',
            amountLabel = 'Menge',
            text = 'Menge eingeben',
        },
        context = {
            has = '🟢 X %{amount} %{item} <br>',
            doesnt = '❌ X %{amount} %{item} <br>',
            header = 'Herstellung',
        },
    },
    pickedUp = 'Du hast deine Werkbank aufgehoben!',
    interacts = {
        startCrafting = 'Werkbank benutzen',
        removeBench = 'Werkbank aufheben',
    },
    failedDist = {
        warn = '^3 [WARNUNG] ^7 Spieler ^7 (%{citizenid}) hat die Distanzprüfung nicht bestanden. ^1 (%{current}/3)',
        kicked = 'Du wurdest wegen mehrfacher Distanzfehler gekickt. Das Team wurde informiert.',
    },
    xpGain = 'Du hast %{xp} %{xpType}-Ruf erhalten!',
    failedChecks = {
        failedNoTable = 'Du hast keinen Tisch zum Aufheben',
        tooFar = 'Du bist zu weit vom Arbeitstisch entfernt',
        noItems = 'Du hast nicht die nötigen Materialien',
        inUse = 'Du hast bereits eine Werkbank draußen',
        notclose = 'Du bist nicht nah genug, um den Tisch zu platzieren',
    },
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
