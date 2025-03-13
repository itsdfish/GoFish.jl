import GoFish: process_books!
import GoFish: process_exchange!
import GoFish: process_go_fish!
import GoFish: setup!

mutable struct TestPlayer{T} <: AbstractPlayer
    id::T
    cards::Vector{Card}
    process_go_fish!::Dict{Symbol, Any}
    process_books!::Dict{Symbol, Any}
    setup!::Dict{Symbol, Any}
    process_exchange!::Dict{Symbol, Any}
end

function TestPlayer(; id)
    process_go_fish! = Dict{Symbol, Any}()
    process_books! = Dict{Symbol, Any}()
    setup! = Dict{Symbol, Any}()
    process_exchange! = Dict{Symbol, Any}()
    return TestPlayer(id, Card[], process_go_fish!,
        process_books!, setup!, process_exchange!)
end

function process_go_fish!(player::TestPlayer, inquirer_id, n_cards)
    player.process_go_fish![:inquirer_id] = inquirer_id
    player.process_go_fish![:n_cards] = n_cards
end

function process_books!(player::TestPlayer, book_map)
    player.process_books![:book_map] = book_map
end

function setup!(player::TestPlayer, ids)
    player.setup![:ids] = ids
end

function process_exchange!(player::TestPlayer, inquirer_id, opponent_id, value, cards)
    player.process_exchange![:inquirer_id] = inquirer_id
    player.process_exchange![:opponent_id] = opponent_id
    player.process_exchange![:value] = value
    player.process_exchange![:cards] = cards
end
