############################################################################################################
#                                         load packages
############################################################################################################
cd(@__DIR__)
using Pkg 
Pkg.activate("..")
using Revise, GoFish 
using GoFish: deal!
using GoFish: inquire!, play_round, update_books!, has_card, simulate

ids = (:Penelope,:Manuel,:Beelzebub)
players = Dict(id => Player(;id) for id in ids)
game = Game(ids)
deal!(game, players)
simulate(game, players)

using GoFish
using GoFish: is_valid
T = Union{Human,Player}
players = Dict{Symbol,T}(id => Player(;id) for id in (:Joy,:Bernice))
players[:you] = Human(;id=:you)
ids = keys(players)
game = PlayGame(;ids = ids)
play(game, players)



using GoFish
ids = (:you, :Joy,:Bernice)
types = (Human,Player,Player)
players = Dict(id => t(;id) for (t,id) in zip(types,ids))
game = PlayGame(;ids = ids)
GoFish.clear_repl()
play(game, players)
