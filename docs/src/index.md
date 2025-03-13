# GoFish.jl

GoFish.jl is a Julia package for playing and simulating the card game Go Fish. 


# Installation 

1. [Download](https://julialang.org/downloads/) the most recent version of Julia.

You can optionally use [VsCode](https://code.visualstudio.com/) with the Julia VsCode [plugin](https://code.visualstudio.com/docs/languages/julia)

2. Add itsdfish's private package registry by pasting the following into the Julia REPL:

```julia
using Pkg
pkg"registry add https://github.com/itsdfish/Registry.jl"
```

3. Enter the package mode by hitting `]` and type the following:

```julia
add GoFish
```
If you prefer to install to a project specific Julia environment, cd to your project directory (use `;` to access the terminal within Julia), and hit `]` to enter package model and type

```julia
activate your_package_name
```

followed by 

```julia
add GoFish
```