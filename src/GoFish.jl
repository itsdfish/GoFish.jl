module GoFish
    using Random
    using DataStructures: SortedDict
    export Card, Game, Player
    export simulate 

    include("structs.jl")
    include("game.jl")

end
