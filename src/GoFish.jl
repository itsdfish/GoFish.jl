module GoFish
    using Random
    using DataStructures: SortedDict
    using PlayingCards52
    export Card, Game, PlayGame, Player, Human
    export simulate 
    export play
    export deal!

    include("structs.jl")
    include("game.jl")
    include("gui.jl")

end
