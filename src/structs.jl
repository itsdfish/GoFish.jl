abstract type AbstractGame{T} end

"""
    Game 

# Fields 
- `deck`: deck of cards 
- `book`: a dictionary containing player id and card value:  `id => value`
- `hand_size`: maximum number of cards in each player's hand
"""
mutable struct Game{T} <: AbstractGame{T}
    deck::Vector{Card}
    books::Dict{T, Vector{Card}}
    hand_size::Int
end

"""
    Game(ids)

A constructor function for simulation game 

# Argument 
- `ids`: a vector of player ids for book dictionary
"""
function Game(ids)
    books = Dict(id => Card[] for id ∈ ids)
    hand_size = length(ids) > 3 ? 5 : 7
    return Game(deck(), books, hand_size)
end

"""
    PlayGame(ids)

A constructor function to play Go Fish

# Argument 
- `ids`: a vector of player ids for book dictionary
"""
mutable struct PlayGame{T} <: AbstractGame{T}
    deck::Vector{Card}
    books::Dict{T, Vector{Card}}
    delay::Float64
    num_2_str::Dict{Int, String}
    str_2_num::Dict{String, Int}
end

"""
    PlayGame(ids)

A constructor function for simulation game 

# Keywords 
- `n_players`: the number of player
- `delay`: delay between actions
"""
function PlayGame(; ids, delay = 1.0)
    s = ("A", "2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K")
    v = 1:13
    num_2_str = Dict(v => s for (v, s) ∈ zip(v, s))
    str_2_num = Dict(s => v for (s, v) ∈ zip(s, v))
    books = Dict(id => Card[] for id ∈ ids)
    return PlayGame(deck(), books, delay, num_2_str, str_2_num)
end

abstract type AbstractPlayer end

"""
    Player <: AbstractPlayer 

# Fields 
- `id::Int`: suit of card 
- `cards::Vector{Card}`: player's cards
"""
mutable struct Player{T} <: AbstractPlayer
    id::T
    cards::Vector{Card}
end

"""
    Player(;id)

Creates a `Player` object

# Keyword
- `id`: integer representing unique id
"""
function Player(; id)
    return Player(id, Card[])
end

"""
    Human <: AbstractPlayer 

# Fields 
- `id::Int`: suit of card 
- `cards::Vector{Card}`: player's cards
"""
mutable struct Human{T} <: AbstractPlayer
    id::T
    cards::Vector{Card}
end

"""
    Human(;id)

Creates a `Human` object

# Keyword
- `id`: integer representing unique id
"""
function Human(; id)
    return Human(id, Card[])
end
