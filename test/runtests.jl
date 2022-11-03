using SafeTestsets
using Test

@safetestset "remove!" begin 
    using GoFish
    using Test
    using GoFish: remove!

    id = 1
    player = Player(;id)
    push!(player.cards, Card(:hearts, 1))
    push!(player.cards, Card(:hearts, 2))
    push!(player.cards, Card(:clubs, 2))
    
    removed_cards = remove!(player, 2)
    @test length(removed_cards) == 2
    @test Card(:hearts, 2) ∈ removed_cards
    @test Card(:clubs, 2) ∈ removed_cards
    @test length(player.cards) == 1
    @test Card(:hearts, 1) ∈ player.cards
end 

@safetestset "has_card" begin 
    using GoFish
    using Test
    using GoFish: has_card

    id = 1
    player = Player(;id)
    push!(player.cards, Card(:hearts, 1))
    push!(player.cards, Card(:hearts, 2))
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

    push!(player.cards, Card(:hearts, 1))
    push!(player.cards, Card(:hearts, 2))
    push!(player.cards, Card(:diamonds, 2))
    push!(player.cards, Card(:clubs, 2))
    push!(player.cards, Card(:spades, 2))
    update_books!(game, player)

    @test game.books[id][1].rnk == 2
    @test length(game.books) == 1
    @test length(game.books[id]) == 1
    @test length(player.cards) == 1
    @test player.cards[1] == Card(:hearts, 1)
end

@testset verbose = true "inquire!" begin
    @safetestset "1" begin 
        using GoFish
        using Test
        using GoFish: inquire!
    
        id = 1
        player1 = Player(;id)
    
        push!(player1.cards, Card(:hearts, 2))
        push!(player1.cards, Card(:clubs, 2))
        push!(player1.cards, Card(:diamonds, 2))
    
        id = 2
        player2 = Player(;id)
        push!(player2.cards, Card(:spades, 2))
    
        game = Game([1,2])
        game.deck = [Card(:clubs, 3), Card(:clubs, 4)]
    
        players = Dict(1 => player1, 2 => player2)
        inquire!(game, player1, players)
        @test length(game.books[1]) == 1
        @test game.books[1][1].rnk == 2
        @test isempty(game.deck)
        @test length(player1.cards) == 1
        @test length(player2.cards) == 1
        @test player1.cards[1] == Card(:clubs, 3)
        @test player2.cards[1] == Card(:clubs, 4)
    end

    @safetestset "2" begin 
        using GoFish
        using Test
        using GoFish: inquire!
    
        id = 1
        player1 = Player(;id)
    
        push!(player1.cards, Card(:hearts, 2))
        push!(player1.cards, Card(:clubs, 2))
        push!(player1.cards, Card(:diamonds, 2))
    
        id = 2
        player2 = Player(;id)
        push!(player2.cards, Card(:spades, 2))
    
        game = Game([1,2])
        empty!(game.deck)
    
        players = Dict(1 => player1, 2 => player2)
        inquire!(game, player1, players)
        @test length(game.books[1]) == 1
        @test game.books[1][1].rnk == 2
        @test length(player1.cards) == 0
        @test length(player2.cards) == 0
    end

    @safetestset "3" begin 
        using GoFish
        using Test
        using GoFish: inquire!
    
        id = 1
        player1 = Player(;id)
    
        push!(player1.cards, Card(:hearts, 2))
        push!(player1.cards, Card(:clubs, 2))
        push!(player1.cards, Card(:diamonds, 2))
    
        id = 2
        player2 = Player(;id)
        push!(player2.cards, Card(:spades, 3))
    
        game = Game([1,2])
        game.deck = [Card(:diamonds, 10),Card(:diamonds, 11)]
    
        players = Dict(1 => player1, 2 => player2)
        inquire!(game, player1, players)

        @test length(game.deck) == 1
        @test length(game.books[1]) == 0
        @test length(player1.cards) == 4
        @test length(player2.cards) == 1
    end
end

@safetestset "correct_completion" begin
    using GoFish
    using Test
    using Random
    using GoFish: deal!
    Random.seed!(8574)

    players = Dict{Int,Player}(id => Player(;id) for id in 1:3)
    ids = keys(players)
    game = Game(ids)
    deal!(game, players)

    @test length(game.deck) == (52 - 3 * 7)
    for (k,p) ∈ players 
        @test length(p.cards) == 7
    end

    players = Dict{Int,Player}(id => Player(;id) for id in 1:5)
    ids = keys(players)
    game = Game(ids)
    deal!(game, players)

    @test length(game.deck) == (52 - 5 * 5)
    for (k,p) ∈ players 
        @test length(p.cards) == 5
    end
end

@safetestset "correct_completion" begin
    using GoFish
    using Test
    using Random
    using GoFish: deal!
    Random.seed!(8574)

    for i in 1:100
        players = Dict{Int,Player}(id => Player(;id) for id in 1:3)
        ids = keys(players)
        game = Game(ids)
        deal!(game, players)
        simulate!(game, players)
        @test isempty(game.deck)
        @test mapreduce(x -> length(x), +, values(game.books)) == 13
    end
end

@safetestset "is_valid" begin 
    @safetestset "1" begin
        using GoFish
        using Test
        using Random
        using GoFish: is_valid

        ids = [1,2,3]
        input = ""
        @test !is_valid(input, ids)

        input = "   "
        @test !is_valid(input, ids)

        input = "1 2 3"
        @test !is_valid(input, ids)

        input = "j 1"
        @test !is_valid(input, ids)

        input = "2 k"
        @test is_valid(input, ids)

        input = "2 2"
        @test is_valid(input, ids)
    end

    @safetestset "2" begin
        using GoFish
        using Test
        using Random
        using GoFish: is_valid

        ids = [:a,:b]
        input = ""
        @test !is_valid(input, ids)

        input = "   "
        @test !is_valid(input, ids)

        input = "1 2 3"
        @test !is_valid(input, ids)

        input = "j 1"
        @test !is_valid(input, ids)

        input = "a k"
        @test is_valid(input, ids)

        input = "b 2"
        @test is_valid(input, ids)
    end
end

@testset "parse_input" begin 
    @safetestset "1" begin
        using GoFish
        using Test
        using Random
        using GoFish: parse_input

        ids = [1,2,3]
        input = "1 3"
        id,value = parse_input(input, ids)
        @test id == 1
        @test value == 3 

        ids = [1,2,3]
        input = "1 a"
        id,value = parse_input(input, ids)
        @test id == 1
        @test value == 1 
    end

    @safetestset "2" begin
        using GoFish
        using Test
        using Random
        using GoFish: parse_input

        ids = [:a,:b]
        input = "a 3"
        id,value = parse_input(input, ids)
        @test id == :a
        @test value == 3 

        ids = [:a,:b]
        input = "a a"
        id,value = parse_input(input, ids)
        @test id == :a
        @test value == 1 
    end
end