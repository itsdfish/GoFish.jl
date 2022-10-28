# GoFish

GoFish.jl is a Julia package for playing and simulating the card game Go Fish. 

# Installing GoFish.jl

To install GoFish.jl, enter the following into the REPL:

```julia
] add https://github.com/itsdfish/GoFish.jl
```

# Playing Go Fish

To play Go Fish, create a sorted dictionary of opponents, where keys are integer ids, and pass the keys
```julia 
using GoFish, DataStructures
T = Union{Human,Player}
# create computer opponents, reserve id = 1 for human player
players = SortedDict{Int,T}(id => Player(;id) for id in 2:3)
# play game
game = PlayGame(;n_players=3)
```
# Running a Simulation
The following code is a minimum working example of a simulation. 

```julia
using GoFish, DataStructures 

players = SortedDict{Int,Player}(id => Player(;id) for id in 1:3)

ids = keys(players)
game = Game(ids)

deal!(game, players)
simulate(game, players)
```

# Creating a Custom Player

GoFish.jl allows you to create a player with custom behavior. The process involves creating a new subtype of `AbstractPlayer` and defining the four methods listed below. 

At minimum the custom subtype requires a field `id` and `cards`. Additional fields can be included as needed.
```julia
mutable struct MyPlayer <: AbstractPlayer
    id::Int
    cards::Vector{Card}
end
```

The decision logic of the player is written in the method `decide`. This method receive the player object, a set of player ids. The result of the decision process is a player id and a card value.  
```julia 
function decide(player::MyPlayer, ids)
    # awesomeness goes here
    return player_id,card_value
end
```
The player's representation of the game is updated through the methods `process_exchange!` and `process_go_fish!`, and `process_books!`. `process_exchange!` allows the player to observe and process an exchange of cards between the inquirer and the opponent.
```julia 
function process_exchange!(player::MyPlayer, inquirer_id, opponent_id, value, cards)
    # awesomeness goes here
end
```
`process_go_fish!` allows the player to observe and that a player received an unknown card after going fish. `process_go_fish!` is also called when a player runs replinishes an empty hand. 
```julia 
function process_go_fish!(player::MyPlayer, inquirer_id)
    # awesomeness goes here
end
```
Finally, `process_books!` allows the player to track which cards are no longer in play.
```julia
function process_books!(player::AbstractPlayer, book_map)
    # awesomeness goes here
end
```