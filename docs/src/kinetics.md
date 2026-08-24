# Chemical Kinetics

ChemicalEquations.jl provides a small set of tools for working with
**reaction kinetics**: rate laws, reaction orders, half-lives, and the
Arrhenius equation.

## Rate Laws

For an elementary reaction of the form

$$\nu_1 A_1 + \nu_2 A_2 \longrightarrow \text{products}$$

the rate is given by

$$v = k \cdot [A_1]^{\nu_1} \cdot [A_2]^{\nu_2}$$

where `k` is the rate constant and `νᵢ` are the stoichiometric coefficients
of the reactants.

!!! warning "Elementarity"
    The reaction order equals the stoichiometric coefficients only for
    **elementary reactions**. For reactions that proceed through multiple
    steps, the order must be determined experimentally.

### `rate`

```julia
julia> eq = ce"H2 + O2 = H2O"
H2 + O2 = H2O

julia> rate(eq, Dict("H2" => 2.0, "O2" => 1.0); k = 0.05)
0.1
```

Pairs `"formula" => concentration` are also accepted:

```julia
julia> rate(ce"H2 + O2 = H2O", "H2" => 2.0, "O2" => 1.0; k = 0.05)
0.1
```

### `RateLaw`

Groups the rate constant and the reaction orders:

```julia
julia> law = RateLaw(0.05, ce"H2 + O2 = H2O");

julia> law.k
0.05

julia> rate(law, Dict("H2" => 2.0, "O2" => 1.0))
0.1
```

## Reaction Order

### `reaction_order`

```julia
julia> reaction_order(ce"2 NO + O2 = 2 NO2")
3
```

### `reactant_orders`

```julia
julia> orders = reactant_orders(ce"2 NO + O2 = 2 NO2");

julia> orders["NO"]
2

julia> orders["O2"]
1
```

## Half-Life

The half-life `t½` depends on the reaction order:

| Order | Half-life |
|-------|-----------|
| 0     | `[A]₀ / (2k)` |
| 1     | `ln(2) / k` |
| 2     | `1 / (k·[A]₀)` |
| 3     | `3 / (2k·[A]₀²)` |

```julia
julia> half_life(0.1, 1)
6.931471805599452

julia> half_life(0.5, 2, initial = 2.0)
1.0
```

## Arrhenius Equation

The temperature dependence of the rate constant:

$$k(T) = A \cdot \exp\!\left(-\frac{E_a}{R\,T}\right)$$

```julia
julia> arrhenius(2.0e12, 50000.0, 298.15)
3478.635937472466

julia> rate_constant(298.15; A = 2.0e12, Ea = 50000.0)
3478.635937472466
```

- `A`: pre-exponential factor (same units as `k`)
- `Ea`: activation energy in **J/mol**
- `T`: temperature in **K**
- `R` = `GAS_CONSTANT` = 8.31446261815324 J/(mol·K)

## Complete example

```julia
using ChemicalEquations

# Hypothetical elementary reaction: 2 NO + O2 -> 2 NO2
eq = ce"2 NO + O2 = 2 NO2"
k298 = rate_constant(298.15; A = 8.0e9, Ea = 63000.0)

v = rate(eq, Dict("NO" => 0.5, "O2" => 0.25); k = k298)
println("v(298 K) = ", v)

# Heating to 400 K increases the rate
k400 = rate_constant(400.0; A = 8.0e9, Ea = 63000.0)
println("k(400 K) = ", k400)

# Half-life of a second-order reaction
println("t½ = ", half_life(k298, 2, initial = 0.5))
```
