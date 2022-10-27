import Base: == 

# ==(c1::Card, c2::Card) = (c1.value == c2.value) && (c1.suit == c2.suit)

# function create_deck()
#     return [Card(s, v) for s ∈ (:heart,:diamond,:club,:spade) for v ∈ 1:13]
# end

"""
    deal!(game, players)

Randomizes and deals cards to each player. Each player recieves 7 cards if the number of cards 
is 1-3; otherwise, each player recieves 5 cards.

# Argument
- `game`: a game object 
- `players`: a dictionary of players 
"""
function deal!(game, players)
    shuffle!(game.deck)
    n = length(players) > 3 ? 5 : 7
    for (k,p) in players 
        cards = splice!(game.deck, 1:n)
        p.cards = cards
    end
    return nothing
end

function has_card(player, value)
    return any(c -> c.rnk == value, player.cards)
end

function remove!(player, value)
    idx = findall(c -> c.rnk == value, player.cards)
    return splice!(player.cards, idx)
end

function add!(player, cards::Vector{Card})
    push!(player.cards, cards...)
end

function add!(player, card::Card)
    push!(player.cards, card)
end

function go_fish(game)
    return popfirst!(game.deck)
end

function inquire!(game, player, players)
    inquiring = true 
    while inquiring 
        id,value = decide(player, keys(players))
        opponent = players[id]
        if has_card(opponent, value)
            cards = remove!(opponent, value)
            add!(player, cards)
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
            if !isempty(game.deck)
                card = go_fish(game)
                add!(player, card)
                process_go_fish!(players, player)
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

function attempt_replinish!(game, player)
    if isempty(player.cards) && !isempty(game.deck)
        card = go_fish(game)
        push!(player.cards, card)
    end
    return nothing
end

function process_exchange!(players, inquirer, id, value, cards=Card[])
    for (k, p) ∈ players 
        process_result!(p, inquirer.id, id, value, cards)
    end
end

function process_result!(player::AbstractPlayer, inquirer_id, opponent_id, value, cards)
    # intentionally blank
end

function process_go_fish!(players, inquirer)
    for (k, p) ∈ players 
        process_go_fish!(p, inquirer.id)
    end
end

function process_go_fish!(player::AbstractPlayer, inquirer_id)
    # intentionally blank
end

function play_round(game, players)
    for (id,player) ∈ players
        inquire!(game, player, players) 
        is_over(game, players) ? break : nothing
    end
end

function simulate(game, players)
    _players = SortedDict(players)
    while !is_over(game, _players)
        play_round(game, _players)
    end
end

function is_over(game, players)
    return length(players) == 0
end

function update_books!(game, player)
    u_cards = unique(player.cards)
    n_cards = length(u_cards)
    for i ∈ 1:n_cards
        value = u_cards[i].rnk
        idx = findall(c -> c.rnk == value, player.cards)
        if length(idx) == 4
            add_book!(game, player.id, value)
            deleteat!(player.cards, idx)
        end
    end
end

function add_book!(game, id, value)
    push!(game.books[id], value)
end

function decide(player, ids)
    id = rand(setdiff(ids, player.id))
    card = rand(player.cards)
    return id,card.rnk
end