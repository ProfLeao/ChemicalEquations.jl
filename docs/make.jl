using ChemEquations
using Documenter

DocMeta.setdocmeta!(ChemEquations, :DocTestSetup, :(using ChemEquations))

makedocs(;
    modules=[ChemEquations],
    authors="zlatanvasovic <zlatanvasovic@gmail.com> and contributors",
    repo="https://github.com/zlatanvasovic/ChemEquations.jl/blob/{commit}{path}#L{line}",
    sitename="ChemEquations.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://zlatanvasovic.github.io/ChemEquations.jl",
        assets=String[],
        analytics="UA-33643623-2",
        mathengine = MathJax3(Dict(
                :loader => Dict("load" => ["[tex]/physics"]),
                :tex => Dict(
                "inlineMath" => [["\$","\$"], ["\\(","\\)"]],
                "tags" => "ams",
                "packages" => ["base", "ams", "autoload", "physics"],
            ),
        ))
    ),
    pages=[
        "Home" => "index.md",
        "Examples" => "examples.md",
        "Library" => [
            "lib/public.md",
            "lib/internals.md",
        ]
    ]
)

deploydocs(;
    repo="github.com/zlatanvasovic/ChemEquations.jl",
)
