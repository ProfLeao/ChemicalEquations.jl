# ChemicalEquations.jl

```@meta
CurrentModule = ChemicalEquations
DocTestSetup  = quote
    using ChemicalEquations
end
```

Welcome to **ChemicalEquations.jl** — a Julia package for writing, parsing, and balancing chemical equations with elegance and mathematical precision.

## Overview

This package provides a robust toolkit for chemical equation manipulation using:
- **Elegant API**: String macros `cc"..."` and `ce"..."` for intuitive notation
- **Mathematical Precision**: Nullspace-based balancing for exact stoichiometric solutions
- **Unicode Support**: Full support for Greek letters and special symbols
- **Flexible Types**: Integer, Rational, and Float64 coefficients
- **Redox Chemistry**: Automatic handling of electrons and ionic charges

## Quick Example

Writing a chemical equation should be simple:

```jldoctest
julia> using ChemicalEquations

julia> eq = ce"CH4 + O2 = CO2 + H2O"
CH4 + O2 = CO2 + H2O
```

And balancing it should be even easier:

```jldoctest
julia> eq = ce"CH4 + O2 = CO2 + H2O"
CH4 + O2 = CO2 + H2O

julia> balance(eq)
CH4 + 2 O2 = CO2 + 2 H2O
```

## Installation

Install the package using the Julia package manager:

```julia
using Pkg
Pkg.add("ChemicalEquations")
```

Or directly from the Pkg REPL:

```
]add ChemicalEquations
```

## Features at a Glance

| Feature | Description |
|---------|-------------|
| **String Macros** | `cc"H2O"` and `ce"H2 + O2 = H2O"` for readable code |
| **Redox Reactions** | Full support for electrons: `Cr2O7{-2} + e = Cr{+3}` |
| **Hydrates** | Handle hydrated salts: `CuSO4*5H2O` |
| **Unicode Elements** | Greek letters as element symbols: `Γ`, `Θ`, `Π` |
| **Flexible Coefficients** | Integer, Rational (`1//2`), or Float64 (`0.5`) |
| **Comprehensive Tests** | 76+ test cases covering edge cases |

## Next Steps

- **[Guide](guide.md)** — Step-by-step tutorial for getting started
- **[Examples](examples.md)** — Practical examples from basic to advanced
- **[API Reference](api.md)** — Complete API documentation

## Key Concepts

### Compounds

A **compound** represents a chemical species with elements and optional charge:

```jldoctest
julia> water = cc"H2O"
H2O

julia> ion = cc"H3O{+}"
H3O{+}
```

### Chemical Equations

A **chemical equation** represents a reaction with reactants and products:

```jldoctest
julia> reaction = ce"H2 + Cl2 = HCl"
H2 + Cl2 = HCl

julia> balanced = balance(reaction)
H2 + Cl2 = 2 HCl
```

## References

- [Nullspace Method for Balancing](https://arxiv.org/ftp/arxiv/papers/1110/1110.4321.pdf) by Thorne (2009)
- [Catalyst.jl](https://github.com/SciML/Catalyst.jl) — Reaction network modeling
- [Julia Documentation](https://docs.julialang.org) — Official language docs

---

**Version**: 0.2.0  
**Author**: Reginaldo Gonçalves Leão Junior  
**License**: MIT