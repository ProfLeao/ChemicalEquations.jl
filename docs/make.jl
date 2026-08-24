push!(LOAD_PATH,"../src/")

using Documenter
using ChemicalEquations

# Set up DocMeta for doctests
DocMeta.setdocmeta!(ChemicalEquations, :DocTestSetup, :(using ChemicalEquations); recursive=true)

makedocs(;
    modules=[ChemicalEquations],
    authors="Reginaldo Gonçalves Leão Junior <prof.reginaldo.leao@gmail.com>",
    repo="https://github.com/ProfLeao/ChemicalEquations.jl/blob/{commit}{path}#{line}",
    sitename="ChemicalEquations.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", nothing) == "true",
        canonical="https://profleao.github.io/ChemicalEquations.jl",
    ),
    pages=[
        "Home" => "index.md",
        "Guide" => "guide.md",
        "Examples" => "examples.md",
        "API Reference" => "api.md",
    ],
)

deploydocs(;
    repo="github.com/ProfLeao/ChemicalEquations.jl",
    devbranch="main",
)