"""
    deal!(game, players)

Randomizes and deals cards to each player. Each player recieves 7 cards if the number of cards 
is 1-3; otherwise, each player recieves 5 cards.

# Arguments
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

"""
    has_card(player, value)

Check whether a player has a card with a specified value

# Arguments
- `player`: a player object
- `value`: value or rank of a card
"""
function has_card(player, value)
    return any(c -> c.rnk == value, player.cards)
end

"""
    remove!(player, value)

Remove and return cards of a specified value from a player.

# Arguments
- `player`: a player object
- `value`: value or rank of a card
"""
function remove!(player, value)
    idx = findall(c -> c.rnk == value, player.cards)
    return splice!(player.cards, idx)
end

"""
    add!(player, cards::Vector{Card})

Add a vector of cards to a player's hand. 

# Arguments
- `player`: a player object
- `cards`: a vector of card objects
"""
function add!(player, cards::Vector{Card})
    push!(player.cards, cards...)
end

"""
    add!(player, card::Card)

Add a card to a player's hand. 

# Arguments
- `player`: a player object
- `card`: a card objects
"""
function add!(player, card::Card)
    push!(player.cards, card)
end

"""
    go_fish(game)

Draw a single card from the deck.

# Arguments
- `game`: game object 
"""
function go_fish(game)
    return popfirst!(game.deck)
end

"""
    inquire!(game, player, players)

The primary inquiry loop in which a player asks other plays for cards. 
This procedure will handle the exchange of cards, update the books, and go fish. 

# Arguments
- `game`: game object 
- `inquirer`: the player who asks for cards
- `players`: a dictionary of players. Keys are integers representing player ids
"""
function inquire!(game, inquirer, players)
    inquiring = true 
    while inquiring 
        ids = get_ids(players)
        id,value = decide(inquirer, ids)
        opponent = players[id]
        if has_card(opponent, value)
            cards = remove!(opponent, value)
            add!(inquirer, cards)
            book_map = update_books!(game, inquirer)
            observe_books!(players, book_map)
            observe_exchange!(players, inquirer, id, value, cards)
            attempt_replinish!(game, inquirer) ? observe_go_fish!(players, inquirer) : nothing
            attempt_replinish!(game, opponent) ? observe_go_fish!(players, opponent) : nothing
            # remove players if empty after attempting to replinish
            if isempty(inquirer.cards)
                inquiring = false
                delete!(players, inquirer.id)
            end
            if isempty(opponent.cards)
                delete!(players, opponent.id)
            end
        else 
            observe_exchange!(players, inquirer, id, value) 
            if !isempty(game.deck)
                card = go_fish(game)
                add!(inquirer, card)
                observe_go_fish!(players, inquirer)
                book_map = update_books!(game, inquirer)
                observe_books!(players, book_map)
                attempt_replinish!(game, inquirer) ? observe_go_fish!(players, inquirer) : nothing
                if isempty(inquirer.cards)
                    inquiring = false
                    delete!(players, inquirer.id)
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
       return true
    end
    return false
end

"""
    observe_exchange!(players, inquirer, opponent_id, value, cards=Card[])

Loop through all players and process the exchange of cards

# Arguments
- `players`: a dictionary of players. Keys are integers representing player ids
- `inquirer`: the player who asks for cards
- `opponent_id`: player id of player who was queried
- `value`: value of the card in the query 
- `cards=Card[]`: a vector of cards exchanged between the inquirer and the opponent player
"""
function observe_exchange!(players, inquirer, opponent_id, value, cards=Card[])
    for (k, p) ∈ players 
        process_exchange!(p, inquirer.id, opponent_id, value, cards)
    end
end

"""
    process_exchange!(player::AbstractPlayer, inquirer_id, opponent_id, value, cards)

Default function which allows a player to observe the exchange of cards between two players.
This function must be extended for custom player types.

# Arguments
- `players`: a dictionary of players. Keys are integers representing player ids
- `inquirer_id`: id of the player who asks for cards
- `opponent_id`: player id of player who was queried
- `value`: value of the card in the query 
- `cards=Card[]`: a vector of cards exchanged between the inquirer and the opponent player
"""
function process_exchange!(player::AbstractPlayer, inquirer_id, opponent_id, value, cards)
    # intentionally blank
end

function observe_go_fish!(players, inquirer)
    for (k, p) ∈ players 
        process_go_fish!(p, inquirer.id)
    end
end

"""
    process_go_fish!(player::AbstractPlayer, inquirer_id)

Process the result of a go fish. 

This function must be extended for custom player types.
# Arguments
- `player`: the player which is updated
- `inquirer_id`: id of the player who asks for cards
"""
function process_go_fish!(player::AbstractPlayer, inquirer_id)
    # intentionally blank
end

function observe_books!(players, book_map)
    for (k, p) ∈ players 
        process_books!(p, book_map)
    end
end

"""
    process_books!(player::AbstractPlayer, book_map)

Allow the player to track the cards that are no longer in play.

# Arguments
- `player`: the player which is updated
- `book_map`: a dictionary with player id as key and new book as vector of cards
"""
function process_books!(player::AbstractPlayer, book_map)
    # intentionally blank
end

function play_round(game, players, ids)
    for id ∈ ids
        inquire!(game, players[id], players) 
        is_over(game, players) ? break : nothing
    end
end

function simulate(game, players)
    _players = Dict(players)
    ids = shuffle!(collect(keys(players)))
    while !is_over(game, _players)
        play_round(game, _players, ids)
    end
end

function is_over(game, players)
    return length(players) == 0
end

function update_books!(game::AbstractGame{T}, player) where {T}
    u_cards = unique(player.cards)
    n_cards = length(u_cards)
    book_map = Dict{T,Vector{Card}}()
    for i ∈ 1:n_cards
        card = u_cards[i]
        idx = findall(c -> c.rnk == card.rnk, player.cards)
        if length(idx) == 4
            add_book!(game, player.id, card)
            book = splice!(player.cards, idx)
            push!(book_map, player.id => book)
        end
    end
end

function add_book!(game, id, value)
    push!(game.books[id], value)
end

function decide(player, ids)
    id = rand(setdiff(ids, [player.id]))
    card = rand(player.cards)
    return id,card.rnk
end

get_ids(players) = keys(players) |> collect