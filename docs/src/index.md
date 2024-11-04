# ChemEquations

This is a Julia package for writing and balancing chemical equations.
Its goal is to be both elegant and efficient.

Writing a chemical equation like this:

$\ce{CH4 + O_2 -> CO2 + H2O}$

should be as simple as this:
```jldoctest label_1
julia> using ChemEquations

julia> equation = ce"CH4 + O2 = CO2 + H2O"
CH4 + O2 = CO2 + H2O
```

and balancing it should be even easier:
```jldoctest label_1
julia> balance(equation)
CH4 + 2 O2 = CO2 + 2 H2O
```

## Installation

You can install the package by pressing `]` in Julia REPL and typing:

```
add ChemEquations
```