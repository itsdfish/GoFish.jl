# Quick Start

Simulating Go Fish requires a dictionary of players, and a game object. Players must be a subtype of `AbstractPlayer`. If using heterogenous types, use a dictionary of type `Dict{I,Union{T1,..}}` to improve performance. The following code is a minimum working example of a simulation. 

```@example quick_example
using GoFish
ids = (:Penelope,:Manuel,:Beelzebub)
players = Dict(id => Player(; id) for id in ids)
game = Game(ids)
simulate!(game, players)
```

Use `get_winners` to find the winners:

```@example quick_example
get_winners(game)
```
Access the books to show the results: 
```@example quick_example
game.books
```

# Creating a Custom Simulation

## Creating a Custom Player

GoFish.jl allows you to create a player with custom behavior. The process involves creating a new subtype of `AbstractPlayer` and defining a decision method and four optional methods for setup and tracking the exchange of cards. 

At minimum the custom subtype requires a field `id` and `cards`. Additional fields can be included as needed.
```julia
mutable struct MyPlayer{T} <: AbstractPlayer
    id::T
    cards::Vector{Card}
end
```

## Defining Methods

The API includes one required method, and four optional methods. Simply omit an optional method if you do not intend to use it. 

### Required Method

The decision logic of the player is written in the required method `decide`. This method receives the player object, and a set of player ids. `decide` must return a player id and a card value.  
```julia 
function decide(player::MyPlayer, ids)
    # awesomeness goes here
    return player_id,card_value
end
```

### Optional Methods

After the cards are delt, initial setup of the player can be optionally performed in the function `setup!`, which is called once prior to the game begining. The arguments for `setup` are the player and player ids. 
```julia
function setup!(player::MyPlayer, ids)
    # awesomeness goes here
    return nothing
end
```

The player's representation of the game is optionally updated through three methods: `process_exchange!`, `process_go_fish!`, and `process_books!`. The method `process_exchange!` allows the player to observe and process an exchange of cards between the inquirer and the opponent.
```julia 
function process_exchange!(player::MyPlayer, inquirer_id, opponent_id, value, cards)
    # awesomeness goes here
    return nothing
end
```
`process_go_fish!` allows the player to observe and that a player received an unknown card after going fish. `process_go_fish!` is also called when a player runs replinishes an empty hand. 
```julia 
function process_go_fish!(player::MyPlayer, inquirer_id, n_cards)
    # awesomeness goes here
    return nothing
end
```
Finally, `process_books!` allows the player to track which cards are no longer in play. The argument `book_map` is a dictionary that maps player id to a vector of cards 
```julia
function process_books!(player::MyPlayer, book_map)
    # awesomeness goes here
    return nothing
end
```
