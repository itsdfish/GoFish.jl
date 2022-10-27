############################################################################################################
#                                         load packages
############################################################################################################
cd(@__DIR__)
using Pkg 
Pkg.activate("..")
using Revise, GoFish, DataStructures 
using GoFish: deal!
using GoFish: ==
using GoFish: inquire!, play_round, update_books!, has_card, simulate

players = SortedDict{Int,Player}(id => Player(;id) for id in 1:3)

ids = keys(players)
game = Game(ids)

deal!(game, players)

simulate(game, players)


using GoFish: Human, inquire!, is_valid, clear_repl, play_round 

players = SortedDict{Int,Union{Human,Player}}(id => Player(;id) for id in 2:3)
players[1] = Human(id=1)

game = PlayGame(keys(players))
deal!(game, players)
clear_repl()
play(game, players)