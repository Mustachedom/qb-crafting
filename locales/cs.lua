local Translations = {
    progressbar = 'Vyrábíš %{item}',
    failedMinigame = 'Výroba selhala! Nepodařilo se ti minihru dokončit.',
    cancelledCrafting = 'Výroba zrušena.',
    menus = {
        input = {
            Header = 'Množství k výrobě',
            submit = 'Potvrdit',
            amountLabel = 'Množství',
            text = 'Zadej množství',
        },
        context = {
            has = '🟢 X %{amount} %{item} <br>',
            doesnt = '❌ X %{amount} %{item} <br>',
            header = 'Výroba',
        },
    },
    pickedUp = 'Sebral jsi svůj pracovní stůl!',
    interacts = {
        startCrafting = 'Použij stůl',
        removeBench = 'Sebrat stůl',
    },
    failedDist = {
        warn = '^3 [VAROVÁNÍ] ^7 Hráč ^7 (%{citizenid}) selhal při kontrole vzdálenosti. ^1 (%{current}/3)',
        kicked = 'Byl jsi vyhozen za opakované selhání kontrol vzdálenosti, ohlášeno administrátorům.',
    },
    xpGain = 'Získal jsi %{xp} reputace %{xpType}!',
    failedChecks = {
        failedNoTable = 'Nemáš žádný stůl k sebrání',
        tooFar = 'Jsi příliš daleko od pracovního stolu',
        noItems = 'Nemáš potřebné předměty k výrobě',
        inUse = 'Už máš pracovní stůl venku',
        notclose = 'Nejsi dost blízko k umístění stolu',
    },
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
