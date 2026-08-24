# Thermochemistry using Glenn.jl (NASA Glenn coefficients).
#
# This file is loaded lazily via Requires.jl when `Glenn` is available.
# All functions return values in SI units: J/mol and J/(mol·K).

"""
    _glenn_species(calc, compound::Compound)

Maps a `Compound` to its `Glenn.SpeciesInfo` entry using an exact,
case-insensitive name match on the compound formula.

Throws an error if no species is found.
"""
function _glenn_species(calc, compound::Compound)
    formula = string(compound)
    species = Glenn.get_available_species(calc, formula; exact_match=true)
    isempty(species) && error("No Glenn species found for formula \"$formula\"")
    return only(species)
end

"""
    reaction_enthalpy(eq::ChemEquation) -> Float64

Returns the **standard enthalpy of reaction** `ΔH°rxn` at 298.15 K, in **J/mol**,
computed from the enthalpies of formation of each species:

`ΔH°rxn = Σᵢ νᵢ·ΔH°f,i`

where `νᵢ` are the stoichiometric coefficients of the (balanced) equation.
The equation does not need to be pre-balanced — if it is not, use
[`balance`](@ref) first.

!!! note
    Requires `Glenn.jl` to be loaded: `using Glenn, ChemicalEquations`.

# Examples
```julia
julia> using Glenn, ChemicalEquations

julia> reaction_enthalpy(balance(ce"CH4 + 2 O2 = CO2 + 2 H2O"))
-802315.0
```
"""
function reaction_enthalpy(eq::ChemEquation)
    Glenn.Calculator() do calc
        dh = 0.0
        for (compound, c) in eq.tuples
            sp = _glenn_species(calc, compound)
            hf = Glenn.calculate_formation_enthalpy(calc, sp.id)
            hf === nothing && error("No formation enthalpy for $(string(compound))")
            dh -= c * hf   # reactants (+c) subtract, products (−c) add
        end
        return dh
    end
end

"""
    reaction_entropy(eq::ChemEquation; T::Real=298.15) -> Float64

Returns the **entropy of reaction** `ΔS°rxn` at temperature `T` (K),
in **J/(mol·K)**:

`ΔS°rxn = Σᵢ νᵢ·S°ᵢ(T)`

!!! note
    Requires `Glenn.jl` to be loaded: `using Glenn, ChemicalEquations`.

# Examples
```julia
julia> using Glenn, ChemicalEquations

julia> reaction_entropy(balance(ce"CH4 + 2 O2 = CO2 + 2 H2O"))
-1.623
```
"""
function reaction_entropy(eq::ChemEquation; T::Real=298.15)
    Glenn.Calculator() do calc
        ds = 0.0
        for (compound, c) in eq.tuples
            sp = _glenn_species(calc, compound)
            props = Glenn.calculate_properties(calc, sp.id, Float64(T))
            ds -= c * props.s
        end
        return ds
    end
end

"""
    gibbs_free_energy(eq::ChemEquation; T::Real=298.15) -> Float64

Returns the **Gibbs free energy of reaction** `ΔG°rxn` at temperature `T` (K),
in **J/mol**:

`ΔG°rxn = ΔH°rxn − T·ΔS°rxn`

!!! note
    Requires `Glenn.jl` to be loaded: `using Glenn, ChemicalEquations`.

# Examples
```julia
julia> using Glenn, ChemicalEquations

julia> gibbs_free_energy(balance(ce"CH4 + 2 O2 = CO2 + 2 H2O"))
-800830.0
```
"""
function gibbs_free_energy(eq::ChemEquation; T::Real=298.15)
    return reaction_enthalpy(eq) - T * reaction_entropy(eq; T=T)
end

"""
    equilibrium_constant(eq::ChemEquation; T::Real=298.15) -> Float64

Returns the thermodynamic **equilibrium constant** `K_eq` at temperature
`T` (K):

`K_eq = exp(−ΔG°rxn / (R·T))`

!!! note
    Requires `Glenn.jl` to be loaded: `using Glenn, ChemicalEquations`.

# Examples
```julia
julia> using Glenn, ChemicalEquations

julia> equilibrium_constant(balance(ce"N2 + 3 H2 = 2 NH3"))
6.1e4
```
"""
function equilibrium_constant(eq::ChemEquation; T::Real=298.15)
    dg = gibbs_free_energy(eq; T=T)
    return exp(-dg / (GAS_CONSTANT * T))
end

"""
    is_spontaneous(eq::ChemEquation; T::Real=298.15) -> Bool

Returns `true` if the reaction is spontaneous at temperature `T` (K),
i.e. `ΔG°rxn < 0`.

!!! note
    Requires `Glenn.jl` to be loaded: `using Glenn, ChemicalEquations`.
"""
function is_spontaneous(eq::ChemEquation; T::Real=298.15)
    return gibbs_free_energy(eq; T=T) < 0
end

"""
    van_t_hoff(K1::Real, K2::Real, T1::Real, T2::Real) -> Float64

Estimates the **standard enthalpy of reaction** `ΔH°rxn` (J/mol) from two
equilibrium constants at two temperatures using the van 't Hoff equation:

`ln(K2/K1) = −ΔH°rxn/R · (1/T2 − 1/T1)`

# Examples
```julia
julia> van_t_hoff(1.0e-3, 5.0e-3, 300.0, 350.0)
28101.383854261003
```
"""
function van_t_hoff(K1::Real, K2::Real, T1::Real, T2::Real)
    return -GAS_CONSTANT * log(K2 / K1) / (1 / T2 - 1 / T1)
end
