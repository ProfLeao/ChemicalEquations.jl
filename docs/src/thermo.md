# Thermochemistry with Glenn.jl

ChemicalEquations.jl can compute **reaction thermodynamics** — ΔH°, ΔS°, ΔG°
and equilibrium constants — using the NASA Glenn coefficients provided by
[**Glenn.jl**](https://github.com/ProfLeao/Glenn.jl) (same author).

!!! note
    Load `Glenn` **before** using the thermochemistry functions:
    ```julia
    using Glenn
    using ChemicalEquations
    ```

## Concepts

For a balanced reaction with stoichiometric coefficients νᵢ:

| Quantity | Formula |
|----------|---------|
| Enthalpy of reaction | `ΔH°rxn = Σᵢ νᵢ·ΔH°f,i` |
| Entropy of reaction | `ΔS°rxn = Σᵢ νᵢ·S°ᵢ(T)` |
| Gibbs free energy | `ΔG°rxn = ΔH°rxn − T·ΔS°rxn` |
| Equilibrium constant | `K = exp(−ΔG°rxn/(R·T))` |

All functions return values in **SI** units: J/mol and J/(mol·K).

## Methane Combustion

```julia
using Glenn, ChemicalEquations

eq = balance(ce"CH4 + O2 = CO2 + H2O")

reaction_enthalpy(eq)     # -802562.0 J/mol
reaction_entropy(eq)      # -5.22 J/(mol·K)
gibbs_free_energy(eq)     # -801004.0 J/mol
is_spontaneous(eq)        # true
```

Methane combustion is highly exothermic and spontaneous at 298 K.

## Ammonia Synthesis (Haber-Bosch)

```julia
using Glenn, ChemicalEquations

eq = balance(ce"N2 + H2 = NH3")

reaction_enthalpy(eq)     # -91880.0 J/mol
gibbs_free_energy(eq)     # -32812.9 J/mol
equilibrium_constant(eq)  # ~5.6e5
is_spontaneous(eq)        # true
```

## Temperature

By default, `T = 298.15 K`. Functions that depend on temperature accept the
`T` argument:

```julia
ΔS = reaction_entropy(eq; T = 500.0)
ΔG = gibbs_free_energy(eq; T = 500.0)
K  = equilibrium_constant(eq; T = 500.0)
```

!!! info
    `reaction_enthalpy` uses formation enthalpies at 298.15 K
    (standard "enthalpy of reaction" convention).

## van 't Hoff

The van 't Hoff equation estimates `ΔH°` from two equilibrium constants at
two temperatures:

$$\ln\frac{K_2}{K_1} = -\frac{\Delta H^\circ}{R}\left(\frac{1}{T_2}-\frac{1}{T_1}\right)$$

```julia
julia> van_t_hoff(1.0e-3, 5.0e-3, 300.0, 350.0)
28101.38
```

## Spontaneity

```julia
is_spontaneous(eq)              # ΔG° < 0 ?
is_spontaneous(eq; T = 800.0)   # at another temperature
```

## Limitations

- **Ionic species**: Glenn.jl covers neutral species. Equations with ions
  (e.g. `Na{+}`, `Cl{-}`) cannot be processed.
- **Physical states**: Glenn.jl distinguishes by phase (gas/condensed).
  The mapping uses the formula name, prioritizing the gas species.
- **Coverage**: ~2030 NASA Glenn species. Species outside the database
  raise an error.
