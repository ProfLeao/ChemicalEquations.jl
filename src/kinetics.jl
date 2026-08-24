"""
Gas constant in J/(mol·K) (CODATA 2018).
"""
const GAS_CONSTANT = 8.31446261815324

"""
    RateLaw{T<:Real}

Stores the rate constant and the reaction order of each reactant for a
chemical equation.

# Fields
- `k::T`: the rate constant (units depend on the reaction order).
- `orders::Dict{String,Int}`: reaction order per reactant, keyed by formula.

# Examples
```jldoctest
julia> eq = ce"H2 + O2 = H2O"
H2 + O2 = H2O

julia> law = RateLaw(0.05, eq);

julia> law.k
0.05

julia> law.orders["H2"]
1
```
"""
struct RateLaw{T<:Real}
    k::T
    orders::Dict{String,Int}
end

"""
    RateLaw(k::Real, eq::ChemEquation) -> RateLaw

Constructs a [`RateLaw`](@ref) from a rate constant and an equation,
using the stoichiometric coefficients of the reactants as the reaction orders
(**elementary reaction assumption**).
"""
RateLaw(k::Real, eq::ChemEquation) = RateLaw(k, reactant_orders(eq))

"""
    reaction_order(eq::ChemEquation) -> Int

Returns the *total reaction order* of an equation, assuming it represents an
elementary reaction: the sum of the stoichiometric coefficients of the
reactants.

!!! info
    For non-elementary reactions the true order must be determined
    experimentally and is generally *not* equal to the coefficients.

# Examples
```jldoctest
julia> reaction_order(ce"2 NO + O2 = 2 NO2")
3

julia> reaction_order(ce"H2 + O2 = H2O")
2
```
"""
function reaction_order(eq::ChemEquation)
    order = 0
    for (_, c) in eq.tuples
        c > 0 && (order += c)
    end
    return order
end

"""
    reactant_orders(eq::ChemEquation) -> Dict{String,Int}

Returns the reaction order of each reactant, keyed by formula
(elementary reaction assumption).

# Examples
```jldoctest
julia> orders = reactant_orders(ce"2 NO + O2 = 2 NO2");

julia> orders["NO"]
2

julia> orders["O2"]
1
```
"""
function reactant_orders(eq::ChemEquation)
    orders = Dict{String,Int}()
    for (compound, c) in eq.tuples
        if c > 0
            orders[string(compound)] = c
        end
    end
    return orders
end

"""
    rate(eq::ChemEquation, concentrations::Dict{String,<:Real}; k::Real=1.0) -> Float64

Returns the rate of an elementary reaction:
`v = k · ∏ᵢ [Aᵢ]^νᵢ`, where `νᵢ` are the stoichiometric coefficients of the
reactants.

`concentrations` maps each reactant formula to its concentration.
Throws an error if the concentration of a reactant is not provided.

# Examples
```jldoctest
julia> eq = ce"H2 + O2 = H2O"
H2 + O2 = H2O

julia> rate(eq, Dict("H2" => 2.0, "O2" => 1.0); k = 0.05)
0.1
```
"""
function rate(eq::ChemEquation, concentrations::Dict{String,<:Real}; k::Real=1.0)
    v = float(k)
    for (compound, c) in eq.tuples
        c > 0 || continue
        conc = get(concentrations, string(compound), nothing)
        conc === nothing && error("No concentration provided for $(compound)")
        v *= conc^c
    end
    return v
end

"""
    rate(eq::ChemEquation, concentrations::Pair...; k::Real=1.0) -> Float64

Pair-based variant of [`rate`](@ref):
`rate(eq, "H2" => 2.0, "O2" => 1.0; k = 0.05)`.

# Examples
```jldoctest
julia> rate(ce"H2 + O2 = H2O", "H2" => 2.0, "O2" => 1.0; k = 0.05)
0.1
```
"""
function rate(eq::ChemEquation, concentrations::Pair...; k::Real=1.0)
    dict = Dict{String,Float64}(string(p.first) => Float64(p.second) for p in concentrations)
    return rate(eq, dict; k=k)
end

"""
    rate(law::RateLaw, concentrations::Dict{String,<:Real}) -> Float64

Rate of an elementary reaction using a [`RateLaw`](@ref):
`v = law.k · ∏ᵢ [Aᵢ]^(law.orders[Aᵢ])`.

The concentrations of all species listed in `law.orders` must be provided.

# Examples
```jldoctest
julia> law = RateLaw(0.05, ce"H2 + O2 = H2O");

julia> rate(law, Dict("H2" => 2.0, "O2" => 1.0))
0.1
```
"""
function rate(law::RateLaw, concentrations::Dict{String,<:Real})
    v = float(law.k)
    for (formula, order) in law.orders
        conc = get(concentrations, formula, nothing)
        conc === nothing && error("No concentration provided for $formula")
        v *= conc^order
    end
    return v
end

"""
    half_life(k::Real, order::Int; initial::Real=1.0) -> Float64

Returns the half-life `t½` of a reaction of the given order:

| order | half-life |
|-------|-----------|
| 0     | `[A]₀ / (2k)` |
| 1     | `ln(2) / k` |
| 2     | `1 / (k·[A]₀)` |
| 3     | `3 / (2k·[A]₀²)` |

For orders 0, 2 and 3 the initial concentration `initial` must be provided
(or defaults to `1.0`).

# Examples
```jldoctest
julia> half_life(0.1, 1)
6.931471805599452

julia> half_life(0.5, 2, initial=2.0)
1.0
```
"""
function half_life(k::Real, order::Int; initial::Real=1.0)
    k == 0 && error("rate constant cannot be zero")
    if order == 0
        return initial / (2k)
    elseif order == 1
        return log(2) / k
    elseif order == 2
        return 1 / (k * initial)
    elseif order == 3
        return 3 / (2k * initial^2)
    else
        error("half-life formula not implemented for order $order")
    end
end

"""
    arrhenius(A::Real, Ea::Real, T::Real) -> Float64

Arrhenius equation:
`k(T) = A · exp(−Ea / (R·T))`.

# Arguments
- `A`: pre-exponential (frequency) factor, in the same units as `k`.
- `Ea`: activation energy, in **J/mol**.
- `T`: absolute temperature, in **K**.

# Examples
```jldoctest
julia> arrhenius(2.0e12, 50000.0, 298.15)
3478.635937472466
```
"""
function arrhenius(A::Real, Ea::Real, T::Real)
    return A * exp(-Ea / (GAS_CONSTANT * T))
end

"""
    rate_constant(T::Real; A::Real, Ea::Real) -> Float64

Alias for the Arrhenius equation — returns the rate constant at temperature
`T` (K) from the pre-exponential factor `A` and the activation energy
`Ea` (J/mol).

# Examples
```jldoctest
julia> rate_constant(298.15; A = 2.0e12, Ea = 50000.0)
3478.635937472466
```
"""
rate_constant(T::Real; A::Real, Ea::Real) = arrhenius(A, Ea, T)
