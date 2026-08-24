# Thermochemistry with Glenn.jl

ChemicalEquations.jl can compute **reaction thermodynamics** — ΔH°, ΔS°, ΔG°
and equilibrium constants — using the NASA Glenn coefficients provided by
[**Glenn.jl**](https://github.com/ProfLeao/Glenn.jl) (same author).

!!! note
    Carregue `Glenn` **antes** de usar as funções de termodinâmica:
    ```julia
    using Glenn
    using ChemicalEquations
    ```

## Conceitos

Para uma reação balanceada com coeficientes estequiométricos νᵢ:

| Grandeza | Fórmula |
|----------|---------|
| Entalpia de reação | `ΔH°rxn = Σᵢ νᵢ·ΔH°f,i` |
| Entropia de reação | `ΔS°rxn = Σᵢ νᵢ·S°ᵢ(T)` |
| Energia livre de Gibbs | `ΔG°rxn = ΔH°rxn − T·ΔS°rxn` |
| Constante de equilíbrio | `K = exp(−ΔG°rxn/(R·T))` |

Todas as funções retornam valores em **SI**: J/mol e J/(mol·K).

## Combustão do Metano

```julia
using Glenn, ChemicalEquations

eq = balance(ce"CH4 + O2 = CO2 + H2O")

reaction_enthalpy(eq)     # -802562.0 J/mol
reaction_entropy(eq)      # -5.22 J/(mol·K)
gibbs_free_energy(eq)     # -801004.0 J/mol
is_spontaneous(eq)        # true
```

A combustão do metano é altamente exotérmica e espontânea a 298 K.

## Síntese de Amônia (Haber-Bosch)

```julia
using Glenn, ChemicalEquations

eq = balance(ce"N2 + H2 = NH3")

reaction_enthalpy(eq)     # -91880.0 J/mol
gibbs_free_energy(eq)     # -32812.9 J/mol
equilibrium_constant(eq)  # ~5.6e5
is_spontaneous(eq)        # true
```

## Temperatura

Por padrão, `T = 298.15 K`. As funções que dependem da temperatura aceitam
o argumento `T`:

```julia
ΔS = reaction_entropy(eq; T = 500.0)
ΔG = gibbs_free_energy(eq; T = 500.0)
K  = equilibrium_constant(eq; T = 500.0)
```

!!! info
    `reaction_enthalpy` usa as entalpias de formação a 298.15 K
    (convenção padrão de "entalpia de reação").

## van 't Hoff

A equação de van 't Hoff estima `ΔH°` a partir de duas constantes de
equilíbrio em duas temperaturas:

$$\ln\frac{K_2}{K_1} = -\frac{\Delta H^\circ}{R}\left(\frac{1}{T_2}-\frac{1}{T_1}\right)$$

```julia
julia> van_t_hoff(1.0e-3, 5.0e-3, 300.0, 350.0)
28101.38
```

## Espontaneidade

```julia
is_spontaneous(eq)              # ΔG° < 0 ?
is_spontaneous(eq; T = 800.0)   # em outra temperatura
```

## Limitações

- **Espécies iônicas**: Glenn.jl cobre espécies neutras. Equações com íons
  (por ex. `Na{+}`, `Cl{-}`) não podem ser processadas.
- **Estados físicos**: Glenn.jl distingue por fase (gas/condensed). O
  mapeamento usa o nome da fórmula, priorizando a espécie gasosa.
- **Cobertura**: ~2030 espécies NASA Glenn. Espécies fora do banco lançam
  um erro.
