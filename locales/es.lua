local Translations = {
    progressbar = 'Creando %{item}',
    failedMinigame = '¡Fallo en la creación! No superaste el minijuego.',
    cancelledCrafting = 'Creación cancelada.',
    menus = {
        input = {
            Header = 'Cantidad a crear',
            submit = 'Confirmar',
            amountLabel = 'Cantidad',
            text = 'Introduce cantidad',
        },
        context = {
            has = '🟢 X %{amount} %{item} <br>',
            doesnt = '❌ X %{amount} %{item} <br>',
            header = 'Creación',
        },
    },
    pickedUp = '¡Has recogido tu mesa de trabajo!',
    interacts = {
        startCrafting = 'Usar mesa',
        removeBench = 'Recoger mesa',
    },
    failedDist = {
        warn = '^3 [ADVERTENCIA] ^7 Jugador ^7 (%{citizenid}) falló la verificación de distancia. ^1 (%{current}/3)',
        kicked = 'Fuiste expulsado por fallar múltiples verificaciones de distancia. El personal ha sido notificado.',
    },
    xpGain = '¡Has ganado %{xp} de reputación %{xpType}!',
    failedChecks = {
        failedNoTable = 'No tienes una mesa para recoger',
        tooFar = 'Estás demasiado lejos de la mesa de trabajo',
        noItems = 'No tienes los materiales necesarios',
        inUse = 'Ya tienes una mesa colocada',
        notclose = 'No estás lo suficientemente cerca para colocar la mesa',
    },
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
