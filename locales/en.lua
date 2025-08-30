local Translations = {
    ['lobbie_menu'] = "Lobbie Menu %{id}",
    ['open_lobbie_menu'] = "~w~[~g~E~w~] - Open Lobbie Menu",
    ['load_lobbie_menu'] = "Load Lobbie Menu",
    ['travel_price'] = "Travel Price",
    ['total_players'] = "Total Players",
    ['players'] = "players",
    ['player'] = "player",
    ['close'] = "Close",
    ['price'] = "price",
    ['now_in_lobbie'] = "You are now in %{lobbie}",
    ['can_not_join_lobbie'] = "You can not join %{lobbie}...",
    ['not_enough_money'] = "You don't have enough money with you, you need %{moneysign}%{price}",
    ['already_in_lobbie'] = "You are already in %{lobbie}...",
    ['you_are_in_lobbie'] = "ID: %{id} You are in %{label}",
    ['file_already_exist'] = "You already have a file %{filename}.lua",
    ['file_created'] = "The file %{filename} is now created!",
    ['file_deleted'] = "The file %{filename} is now deleted!",
    ['lobbie_already_exsist'] = "%{lobbie} bestaad alt, probeer een andere lobbie naam...",
    ['not_enter_a_filename'] = "You did not enter a filename when you created a lobbie",
    ['create_new_lobbie_error'] = "can't create a new lobbie, data type is not a table...",
    ['delete_default_file_error'] = "You can't delete the default file %{filename}.lua...",
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true,
    fallbackLang = Lang,
})