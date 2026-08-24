# Catalyst.jl Integration

ChemicalEquations.jl can convert balanced equations into
[**Catalyst.jl**](https://docs.sciml.ai/Catalyst/stable/) `ReactionSystem`s,
opening the door to ODE, SDE, and stochastic jump simulations through the
SciML ecosystem.

!!! note
    Load `Catalyst` **before** using the integration functions:
    ```julia
    using Catalyst
    using ChemicalEquations
    ```

## Converting an Equation

```julia
using Catalyst
using ChemicalEquations

eq = balance(ce"2 H2 + O2 = 2 H2O")
rs = reaction_system(eq; name = :combustion)
```

The result is a `Catalyst.ReactionSystem` with a single reaction
(assumed **directed** and **elementary**):

```
k, 2 H2 + O2 --> 2 H2O
```

## Simulating with ODEs

```julia
using Catalyst, ChemicalEquations
using OrdinaryDiffEqDefault   # or DifferentialEquations

rs = reaction_system(balance(ce"2 H2 + O2 = 2 H2O"); name = :combustion)

u0 = [:H2 => 2.0, :O2 => 1.0, :H2O => 0.0]
ps = [:k => 0.05]
tspan = (0.0, 100.0)

prob = ODEProblem(rs, u0, tspan, ps)
sol  = solve(prob)
```

## Reaction Networks

Multiple equations can be combined into a single network:

```julia
using Catalyst, ChemicalEquations

eqs = [balance(ce"H2 + Cl2 = HCl"), balance(ce"N2 + H2 = NH3")]
rn = reaction_network(eqs; name = :chain)
```

## Reverse Conversion

A `ReactionSystem` can be converted back to a `ChemEquation`:

```julia
using Catalyst, ChemicalEquations

rs = reaction_system(balance(ce"2 H2 + O2 = 2 H2O"))
eq = ChemEquation(rs)
```

!!! warning
    The reverse conversion works for species whose symbols are valid
    chemical formulas. Abstract Catalyst species (e.g. `SE`) that do not
    correspond to real formulas are skipped with a warning.

## Limitations

- The conversion assumes **directed** (left → right) and **elementary**
  reactions, with a single rate constant `k`.
- Compound names that are not valid Catalyst identifiers (e.g. `Γ`, `⬡`)
  or charged compounds cannot be converted.
