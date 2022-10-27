module GoFish
    using Random
    using DataStructures: SortedDict
    using PlayingCards52
    export Card, Game, PlayGame, Player
    export simulate 
    export play

    include("structs.jl")
    include("game.jl")
    include("gui.jl")

end
