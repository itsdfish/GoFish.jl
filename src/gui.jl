function inquire!(game::PlayGame, player, players)
    inquiring = true 
    human = players[1]
    while inquiring 
        id,value = decide(player, keys(players))
        opponent = players[id]
        sleep(game.delay)
        print_inquiry(game, player, opponent, value)
        if has_card(opponent, value)
            cards = remove!(opponent, value)
            print_exchange(opponent, player, cards)
            process_exchange!(players, player, id, value, cards)
            add!(player, cards)
            show_hand(human)
            wait_for_key()
            clear_repl()
            update_books!(game, player)
            attempt_replinish!(game, player)
            attempt_replinish!(game, opponent)
            # remove players if empty after attempting to replinish
            if isempty(player.cards)
                inquiring = false
                delete!(players, player.id)
            end
            if isempty(opponent.cards)
                delete!(players, opponent.id)
            end
        else
            process_exchange!(players, player, id, value) 
            print_no_card(game, opponent, value)
            show_hand(human)
            wait_for_key()
            clear_repl()
            if !isempty(game.deck)
                card = go_fish(game)
                println("Go fish!")
                sleep(game.delay)
                print_go_fish(player, card)
                add!(player, card)
                process_go_fish!(players, player)
                show_hand(human)
                wait_for_key()
                clear_repl()
                update_books!(game, player)
                attempt_replinish!(game, player)
                if isempty(player.cards)
                    inquiring = false
                    delete!(players, player.id)
                end
            end
            inquiring = false
        end
    end
end

function decide(human::Human, players)
    while true 
        println("Select a player id and card then hit enter.")
        show_hand(human)
        input = readline()
        clear_repl()
        if is_valid(input)
            id,value = parse_input(input)
            if id ≠ human.id
            else 
                println("Cannot ask yourself for a card. Select $(setdiff(keys(players), [human.id]))")
                wait_for_key()
                clear_repl()
                continue
            end
            if has_card(human, value)
                return id,value
            else
                 println("You do not have a card with a $value. Please select a different card.")
                 wait_for_key()
                 clear_repl()
            end
        else
            println("Input error. You must enter a player number and card value. Example: 1 2")
            wait_for_key()
            clear_repl()
        end
    end
end

function is_valid(input)
    !contains(input, " ") ? (return false) : nothing
    str = split(input, " ")
    length(str) ≠ 2 ? (return false) : nothing 
    f(x) = isa(tryparse(Float64, x), Number) 
    g(x) = f(x) || (x ∈ ("t","j","k","q","a"))
    !f(str[1]) || !g(str[2]) ? (return false) : nothing 
    return true 
end

function parse_input(input)
    str = split(input, " ")
    id = parse(Int, str[1])
    dict = Dict("$i" => i for i in 1:9)
    dict["a"] = 1
    dict["t"] = 10
    dict["j"] = 11
    dict["q"] = 12
    dict["k"] = 13
    value = dict[str[2]]
    return id,value
end

function update_books!(game::PlayGame, player)
    u_cards = unique(player.cards)
    n_cards = length(u_cards)
    for i ∈ 1:n_cards
        card = u_cards[i]
        idx = findall(c -> c.rnk == card.rnk, player.cards)
        if length(idx) == 4
            add_book!(game, player.id, card)
            deleteat!(player.cards, idx)
        end
    end
end

function show_hand(player)
    cards = sort!(player.cards)
    str = show_cards(cards)
    println("hand: " * str)
end

function print_exchange(p1::Human, p2, cards)
    println("$(get_name(p1)) give $(get_name(p2)) $(show_cards(cards))")
end

function print_exchange(p1, p2, cards)
    println("$(get_name(p1)) gives $(get_name(p2)) $(show_cards(cards))")
end

get_name(p) = "player $(p.id)"
get_name(p::Human) = "you"

function show_cards(cards)
    return mapreduce(c -> string(c) * "  ", *, cards)
end

function wait_for_key()
    println("Press enter to continue.")
    readline()
end

function print_inquiry(game, player::Human, opponent, value)
    # intentionally blank
end

function print_inquiry(game, p1, p2, value)
    new_value = game.num_2_str[value]
    println("$(get_name(p1)) asks $(get_name(p2)) for a $new_value")
end

function print_no_card(game, p, value)
    new_value = game.num_2_str[value]
    println("$(get_name(p)) does not have any $(new_value)s")
end

function print_no_card(game, p::Human, value)
    new_value = game.num_2_str[value]
    println("You do not have any $(new_value)s")
end

function print_go_fish(p, card)
    println("player $(p.id) received a card")
end

function print_go_fish(p::Human, card)
    println("you received a $card")
end

function clear_repl()
    if Sys.iswindows()
        return read(run(`powershell cls`), String)
    elseif Sys.isunix()
        return read(run(`clear`), String)
    elseif Sys.islinux()
        return read(run(`printf "\033c"`), String)
    end
end

function play(game::PlayGame, players)
    _players = SortedDict(players)
    while !is_over(game, _players)
        play_round(game, _players)
    end
end