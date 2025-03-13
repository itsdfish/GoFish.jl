using Documenter
using GoFish

makedocs(
    warnonly = true,
    sitename = "GoFish",
    format = Documenter.HTML(
        assets = [
            asset(
            "https://fonts.googleapis.com/css?family=Montserrat|Source+Code+Pro&display=swap",
            class = :css
        )
        ],
        collapselevel = 1
    ),
    modules = [
        GoFish
        # Base.get_extension(GoFish, :TuringExt),
        # Base.get_extension(GoFish, :NamedArraysExt)
    ],
    pages = [
        "Home" => "index.md",
        "Playing Go Fish" => "play.md",
        "Simulating Go Fish" => "example.md",
        "API" => "api.md"
    ]
)

deploydocs(repo = "github.com/itsdfish/GoFish.jl.git")
