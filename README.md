# GoFish

# Creating a new player

You can create a new player type with custom behavior by creating a sub-type of `AbstractPlayer` and 
defining three methods. 

At minimum the custom sub-type requires a field `id` and `card`. Additional fields can be included as needed.
```julia
mutable struct MyPlayer <: AbstractPlayer
    id::Int
    cards::Vector{Card}
end
```
The function called decide contains the decision logic and turns an interger representing the player id and card value. 
```julia 
function decide(player::MyPlayer, ids)
    return player_id,card_value
end
```

```julia 
function process_go_fish!(player::MyPlayer, inquirer_id)

end
```
```julia 
function process_go_fish!(player::MyPlayer, inquirer_id)

end
```
