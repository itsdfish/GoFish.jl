"""
    Card 

# Fields 
- `suit`: suit of card 
- `value`: value of card 
"""
struct Card 
    suit::Symbol 
    value::Int 
end

Broadcast.broadcastable(x::Card) = Ref(x)

abstract type AbstractGame end

"""
    Game 

# Fields 
- `deck`: deck of cards 
"""
mutable struct Game <: AbstractGame
    deck::Vector{Card}
    books::Dict{Int,Vector{Int}}
end

function Game(ids)
    books = Dict(id => Int[] for id ∈ ids)
    return Game(create_deck(), books)
end

abstract type AbstractPlayer end

"""
    Player <: AbstractPlayer 

# Fields 
- `id::Int`: suit of card 
- `cards::Vector{Card}`: player's cards
"""
mutable struct Player <: AbstractPlayer
    id::Int
    cards::Vector{Card}
end

"""
    Player(;id)

Creates a `Player` object

# Keyword
- `id`: integer representing unique id
"""
function Player(;id)
    return Player(id, Card[])
end