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

"""
    process_go_fish!(player::AbstractPlayer, inquirer_id)

Process the result of a go fish. 

This function must be extended for custom player types.

# Arguments

- `player`: the player which is updated
- `inquirer_id`: id of the player who asks for cards
"""
function process_go_fish!(player::AbstractPlayer, inquirer_id, n_cards)
    # intentionally blank
end

"""
    process_exchange!(player::AbstractPlayer, inquirer_id, opponent_id, value, cards)

Default function which allows a player to observe the exchange of cards between two players.
This function must be extended for custom player types.

# Arguments

- `players`: a dictionary of players. 
- `inquirer_id`: id of the player who asks for cards
- `opponent_id`: player id of player who was queried
- `value`: value of the card in the query 
- `cards=Card[]`: a vector of cards exchanged between the inquirer and the opponent player
"""
function process_exchange!(player::AbstractPlayer, inquirer_id, opponent_id, value, cards)
    # intentionally blank
end

"""
    setup!(player::AbstractPlayer, ids)

Perform initial setup after cards are delt, but before the game begins.

# Arguments

- `player`: a player object
- `ids`: all player ids
"""
function setup!(player::AbstractPlayer, ids)
    # intentionally blank
end