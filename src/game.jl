"""
    deal!(game::AbstractGame, players)

Randomizes and deals cards to each player. Each player recieves 7 cards if the number of cards 
is 1-3; otherwise, each player recieves 5 cards.

# Arguments

- `game`: a game object 
- `players`: a dictionary of players 
"""
function deal!(game::AbstractGame, players)
    shuffle!(game.deck)
    n = length(players) > 3 ? 5 : 7
    for (_, p) in players
        cards = splice!(game.deck, 1:n)
        p.cards = cards
    end
    return nothing
end

"""
    has_card(player::AbstractPlayer, value)

Check whether a player has a card with a specified value

# Arguments
- `player`: a player object
- `value`: value or rank of a card
"""
function has_card(player::AbstractPlayer, value)
    return any(c -> c.rnk == value, player.cards)
end

"""
    remove!(player::AbstractPlayer, value)

Remove and return cards of a specified value from a player.

# Arguments

- `player`: a player object
- `value`: value or rank of a card
"""
function remove!(player::AbstractPlayer, value)
    idx = findall(c -> c.rnk == value, player.cards)
    return splice!(player.cards, idx)
end

"""
    add!(player::AbstractPlayer, cards::Vector{Card})

Add a vector of cards to a player's hand. 

# Arguments

- `player`: a player object
- `cards`: a vector of card objects
"""
function add!(player::AbstractPlayer, cards::Vector{Card})
    push!(player.cards, cards...)
end

"""
    add!(player::AbstractPlayer, card::Card)

Add a card to a player's hand. 

# Arguments

- `player`: a player object
- `card`: a card objects
"""
function add!(player::AbstractPlayer, card::Card)
    push!(player.cards, card)
end

"""
    go_fish(game::AbstractGame)

Draw a single card from the deck.

# Arguments

- `game`: game object 
"""
function go_fish(game::AbstractGame)
    return popfirst!(game.deck)
end

"""
    inquire!(game::AbstractGame, player::AbstractPlayer, players)

The primary inquiry loop in which a player asks other plays for cards. 
This procedure will handle the exchange of cards, update the books, and go fish. 

# Arguments

- `game`: game object 
- `inquirer`: the player who asks for cards
- `players`: a dictionary of players.
"""
function inquire!(game::AbstractGame, inquirer, players)
    inquiring = true
    while inquiring
        ids = get_ids(players)
        id, value = decide(inquirer, ids)
        has_card(inquirer, value) ? nothing : break
        opponent = players[id]
        if has_card(opponent, value)
            cards = remove!(opponent, value)
            add!(inquirer, cards)
            observe_exchange!(players, inquirer, id, value, cards)
            book_map = update_books!(game, inquirer)
            observe_books!(players, book_map)
            attempt_replinish!(game, players, inquirer)
            attempt_replinish!(game, players, opponent)
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
                attempt_replinish!(game, players, inquirer)
                if isempty(inquirer.cards)
                    delete!(players, inquirer.id)
                end
            end
            inquiring = false
        end
    end
end

function attempt_replinish!(game::AbstractGame, players, player)
    if isempty(player.cards) && !isempty(game.deck)
        n_cards = min(game.hand_size, length(game.deck))
        cards = splice!(game.deck, 1:n_cards)
        push!(player.cards, cards...)
        observe_go_fish!(players, player, n_cards)
        book_map = update_books!(game, player)
        observe_books!(players, book_map)
        return true
    end
    return false
end

"""
    observe_exchange!(players, inquirer, opponent_id, value, cards=Card[])

Loop through all players and process the exchange of cards

# Arguments

- `players`: a dictionary of players.
- `inquirer`: the player who asks for cards
- `opponent_id`: player id of player who was queried
- `value`: value of the card in the query 
- `cards=Card[]`: a vector of cards exchanged between the inquirer and the opponent player
"""
function observe_exchange!(players, inquirer, opponent_id, value, cards = Card[])
    for (_, p) ∈ players
        process_exchange!(p, inquirer.id, opponent_id, value, cards)
    end
end

function observe_go_fish!(players, inquirer, n_cards = 1)
    for (_, p) ∈ players
        process_go_fish!(p, inquirer.id, n_cards)
    end
end

function observe_books!(players, book_map)
    for (_, p) ∈ players
        process_books!(p, book_map)
    end
end

function play_round(game::AbstractGame, players, ids)
    for id ∈ ids
        id ∈ keys(players) ? nothing : continue
        inquire!(game, players[id], players)
        is_over(game, players) ? break : nothing
    end
end

"""
    simulate!(game::AbstractGame, players)

Performs a single simulation of GoFish. 

# Arguments

- `game`: game object 
- `inquirer`: the player who asks for cards
- `players`: a dictionary of players.
"""
function simulate!(game::AbstractGame, players)
    deal!(game, players)
    ids = shuffle!(collect(keys(players)))
    _players = Dict(players)
    map(p -> setup!(p, ids), values(players))
    while !is_over(game, _players)
        play_round(game, _players, ids)
    end
end

function is_over(::AbstractGame, players)
    return length(players) == 0
end

function update_books!(game::AbstractGame{T}, player) where {T}
    u_cards = unique(player.cards)
    n_cards = length(u_cards)
    book_map = Dict{T, Vector{Card}}()
    for i ∈ 1:n_cards
        card = u_cards[i]
        idx = findall(c -> c.rnk == card.rnk, player.cards)
        if length(idx) == 4
            add_book!(game, player.id, card)
            book = splice!(player.cards, idx)
            push!(book_map, player.id => book)
        end
    end
    return book_map
end

function add_book!(game::AbstractGame, id, value)
    push!(game.books[id], value)
end

"""
    decide(player::AbstractPlayer, ids)

A default method impliments the player's decision logic and returns a tuple containing
the id of the player who is queried and the rank of the card.

# Arguments

- `player`: the player who makes a decision
- `ids`: a vector of player ids 
"""
function decide(player::AbstractPlayer, ids)
    id = rand(setdiff(ids, [player.id]))
    card = rand(player.cards)
    return id, card.rnk
end

get_ids(players) = keys(players) |> collect

"""
    get_winners(game::AbstractGame{T})

Returns a vector of winners. In the event of a tie, there will not be a unique winner. 

# Arguments

- `game`: game object 
"""
function get_winners(game::AbstractGame{T}) where {T}
    max_books, _ = findmax(x -> length(x), game.books)
    winners = T[]
    for (k, v) ∈ game.books
        length(v) == max_books ? push!(winners, k) : nothing
    end
    return winners
end
