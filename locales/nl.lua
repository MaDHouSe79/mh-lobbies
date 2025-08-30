local Translations = {
    ['lobbie_menu'] = "Lobbie Menu %{id}",
    ['open_lobbie_menu'] = "~w~[~g~E~w~] - Open Lobbie Menu",
    ['load_lobbie_menu'] = "Laad Lobbie Menu",
    ['travel_price'] = "Reis Prijs",
    ['total_players'] = "Totaal Spelers",
    ['players'] = "spelers",
    ['player'] = "speler",
    ['close'] = "sluit",
    ['price'] = "prijs",
    ['now_in_lobbie'] = "Je bent nu in %{lobbie}",
    ['can_not_join_lobbie'] = "Je kunt niet deelnemen in %{lobby}",
    ['not_enough_money'] = "Je hebt niet genoeg geld op zak, je hebt %{moneysign}%{price} nodig.",
    ['already_in_lobbie'] = "Je bent al in %{lobbie}...",
    ['you_are_in_lobbie'] = "ID: %{id} Je bent in %{label}",
    ['file_already_exist'] = "Er bestaad al een bestand %{filename}.lua",
    ['file_created'] = "Het bestand %{filename} is aangemaakt!",
    ['file_deleted'] = "Het bestand %{filename} is verwijderd!",
    ['lobbie_already_exsist'] = "%{lobbie} already exsist, try a other lobbie name.",
    ['not_enter_a_filename'] = "U hebt geen bestandsnaam ingevoerd toen u een lobby aanmaakte",
    ['create_new_lobbie_error'] = "kan geen nieuwe lobby aanmaken, data type is geen tabel...",
    ['delete_default_file_error'] = "Je kunt het standaardbestand %{filename}.lua niet verwijderen...",
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true,
    fallbackLang = Lang,
})
