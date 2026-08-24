# Catalyst.jl integration.
#
# This file is loaded lazily via Requires.jl when `Catalyst` is available.
# Provides conversion between ChemEquation and Catalyst.ReactionSystem,
# enabling ODE/SDE/jump simulation through the SciML ecosystem.

"""
    _catalyst_side(tuples, pred) -> String

Builds the Catalyst DSL string for one side of a reaction,
e.g. `"2H2 + O2"`.
"""
function _catalyst_side(tuples, pred)
    parts = String[]
    for (compound, c) in tuples
        if pred(c)
            coeff = abs(c)
            formula = string(compound)
            push!(parts, coeff == 1 ? formula : "$coeff$formula")
        end
    end
    return join(parts, " + ")
end

"""
    reaction_system(eq::ChemEquation; name=:reaction, rate=:k) -> Catalyst.ReactionSystem

Converts a `ChemEquation` into a Catalyst `ReactionSystem` using the Catalyst
DSL. The reaction is assumed to be **unimolecular forward** (left → right)
with a single mass-action rate parameter `rate` (default `:k`).

For stoichiometric coefficients, balance the equation first:

```julia
using Catalyst, ChemicalEquations
rs = reaction_system(balance(ce"2 H2 + O2 = 2 H2O"); name = :combustion)
```

!!! note
    Requires `Catalyst.jl` to be loaded: `using Catalyst, ChemicalEquations`.

!!! warning
    Compound names that are not valid Catalyst identifiers (e.g. `Γ`, `⬡`,
    or charged species) cannot be represented and will raise an error.
"""
function reaction_system(eq::ChemEquation; name::Symbol=:reaction, rate::Symbol=:k)
    left = _catalyst_side(eq.tuples, >(0))
    right = _catalyst_side(eq.tuples, <(0))
    dsl = "Catalyst.@reaction_network begin\n    $rate, $left --> $right\nend"
    rs = Core.eval(@__MODULE__, Meta.parse(dsl))
    try
        rs = Catalyst.rename(rs, name)
    catch
        @warn "Could not rename ReactionSystem; using auto-generated name."
    end
    return rs
end

"""
    reaction_network(eqs::Vector{ChemEquation}; name=:network, rate=:k) -> Catalyst.ReactionSystem

Converts a vector of `ChemEquation`s into a single Catalyst `ReactionSystem`
using the Catalyst DSL.

```julia
using Catalyst, ChemicalEquations
eqs = [balance(ce"A = B"), balance(ce"B = C")]
rn = reaction_network(eqs)
```

!!! note
    Requires `Catalyst.jl` to be loaded: `using Catalyst, ChemicalEquations`.
"""
function reaction_network(eqs::AbstractVector{<:ChemEquation}; name::Symbol=:network, rate::Symbol=:k)
    blocks = String[]
    for eq in eqs
        left = _catalyst_side(eq.tuples, >(0))
        right = _catalyst_side(eq.tuples, <(0))
        push!(blocks, "    $rate, $left --> $right")
    end
    dsl = "Catalyst.@reaction_network begin\n" * join(blocks, "\n") * "\nend"
    rn = Core.eval(@__MODULE__, Meta.parse(dsl))
    try
        rn = Catalyst.rename(rn, name)
    catch
        @warn "Could not rename ReactionSystem; using auto-generated name."
    end
    return rn
end

"""
    ChemEquation(rs::Catalyst.ReactionSystem) -> ChemEquation

Reconstructs a `ChemEquation` from the first reaction of a Catalyst
`ReactionSystem`. Species whose symbols are not valid chemical formulas
are skipped.

```julia
using Catalyst, ChemicalEquations
rs = reaction_system(balance(ce"2 H2 + O2 = 2 H2O"))
eq = ChemEquation(rs)
```

!!! note
    Requires `Catalyst.jl` to be loaded: `using Catalyst, ChemicalEquations`.
"""
function ChemEquation(rs)
    rxs = Catalyst.reactions(rs)
    isempty(rxs) && error("ReactionSystem contains no reactions")
    rx = only(rxs)   # single reaction
    tuples = Tuple{Compound,Int}[]
    for (species, stoich) in zip(rx.substrates, rx.substoich)
        _push_compound!(tuples, _species_name(species), stoich)
    end
    for (species, stoich) in zip(rx.products, rx.prodstoich)
        _push_compound!(tuples, _species_name(species), -stoich)
    end
    return ChemEquation(tuples)
end

"Extracts the plain name of a Catalyst species (strips the `(t)` suffix)."
function _species_name(species)
    s = string(species)
    return occursin("(", s) ? split(s, "(")[1] : s
end

"Appends a compound with coefficient `c` (skipping invalid formulas)."
function _push_compound!(tuples, formula::AbstractString, c::Int)
    isempty(formula) && return
    try
        compound = Compound(formula)
        push!(tuples, (compound, c))
    catch
        @warn "Skipping species \"$formula\": not a valid chemical formula."
    end
end
