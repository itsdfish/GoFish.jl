using SafeTestsets

@safetestset "remove!" begin 
    using GoFish
    using Test
    using GoFish: remove!

    id = 1
    player = Player(;id)
    push!(player.cards, Card(:heart, 1))
    push!(player.cards, Card(:heart, 2))
    push!(player.cards, Card(:clubs, 2))
    
    removed_cards = remove!(player, 2)
    @test length(removed_cards) == 2
    @test Card(:heart, 2) ∈ removed_cards
    @test Card(:clubs, 2) ∈ removed_cards
    @test length(player.cards) == 1
    @test Card(:heart, 1) ∈ player.cards
end 

@safetestset "has_card" begin 
    using GoFish
    using Test
    using GoFish: has_card

    id = 1
    player = Player(;id)
    push!(player.cards, Card(:heart, 1))
    push!(player.cards, Card(:heart, 2))
    push!(player.cards, Card(:clubs, 2))
    
    @test has_card(player, 1)
    @test has_card(player, 2)
    @test !has_card(player, 11)
end 

@safetestset "go_fish" begin
    using GoFish
    using Test
    using GoFish: go_fish

    id = 1
    player = Player(;id)
    game = Game([id])
    test_card = game.deck[1]
    
    @test length(game.deck) == 52
    card = go_fish(game)
    @test length(game.deck) == 51
    @test card == test_card
end


@safetestset "update_books!" begin
    using GoFish
    using Test
    using GoFish: update_books!

    id = 1
    player = Player(;id)
    game = Game([id])

    push!(player.cards, Card(:heart, 1))
    push!(player.cards, Card(:heart, 2))
    push!(player.cards, Card(:diamond, 2))
    push!(player.cards, Card(:club, 2))
    push!(player.cards, Card(:spade, 2))
    update_books!(game, player)

    @test game.books[id][1] == 2
    @test length(game.books) == 1
    @test length(game.books[id]) == 1
    @test length(player.cards) == 1
    @test player.cards[1] == Card(:heart, 1)
end

@safetestset "correct_completion" begin
    using GoFish
    using Test
    using Random
    using GoFish: deal!
    using DataStructures: SortedDict
    Random.seed!(8574)

    for i in 1:100
        players = SortedDict{Int,Player}(id => Player(;id) for id in 1:3)
        ids = keys(players)
        game = Game(ids)
        deal!(game, players)
        simulate(game, players)
        @test mapreduce(x -> length(x), +, values(game.books)) == 13
    end
end
