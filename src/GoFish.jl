module GoFish
using Random
using PlayingCards52

export AbstractPlayer
export Card
export Game
export Human
export PlayGame
export Player

export deal!
export get_winners
export play
export rank
export simulate!

include("structs.jl")
include("game.jl")
include("gui.jl")
end
