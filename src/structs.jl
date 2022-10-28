abstract type AbstractGame end

"""
    Game 

# Fields 
- `deck`: deck of cards 
- `book`: a dictionary containing player id and card value:  `id => value`
"""
mutable struct Game <: AbstractGame
    deck::Vector{Card}
    books::Dict{Int,Vector{Card}}
end

"""
    Game(ids)

A constructor function for simulation game 

# Argument 
- `ids`: a vector of player ids for book dictionary
"""
function Game(ids)
    books = Dict(id => Card[] for id ∈ ids)
    return Game(deck(), books)
end

"""
    PlayGame(ids)

A constructor function to play Go Fish

# Argument 
- `ids`: a vector of player ids for book dictionary
"""
mutable struct PlayGame <: AbstractGame
    deck::Vector{Card}
    books::Dict{Int,Vector{Card}}
    delay::Float64
    num_2_str::Dict{Int,String}
    str_2_num::Dict{String,Int}
end

"""
    PlayGame(ids)

A constructor function for simulation game 

# Keywords 
- `n_players`: the number of player
- `delay`: delay between actions
"""
function PlayGame(; n_players, delay=1.0)
    s = ("A","2","3","4","5","6","7","8","9","T","J","Q","K")
    v = 1:13
    num_2_str = Dict(v => s for (v, s) ∈ zip(v, s))
    str_2_num = Dict(s => v for (s, v) ∈ zip(s, v))
    books = Dict(id => Card[] for id ∈ 1:n_players)
    return PlayGame(deck(), books, delay, num_2_str, str_2_num)
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

"""
    Human <: AbstractPlayer 

# Fields 
- `id::Int`: suit of card 
- `cards::Vector{Card}`: player's cards
"""
mutable struct Human <: AbstractPlayer
    id::Int
    cards::Vector{Card}
end

"""
    Human(;id)

Creates a `Human` object

# Keyword
- `id`: integer representing unique id
"""
function Human(;id)
    return Human(id, Card[])
end
