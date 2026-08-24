# Catalyst.jl Integration

ChemicalEquations.jl can convert balanced equations into
[**Catalyst.jl**](https://docs.sciml.ai/Catalyst/stable/) `ReactionSystem`s,
opening the door to ODE, SDE, and stochastic jump simulations through the
SciML ecosystem.

!!! note
    Carregue `Catalyst` **antes** de usar as funções de integração:
    ```julia
    using Catalyst
    using ChemicalEquations
    ```

## Convertendo uma Equação

```julia
using Catalyst
using ChemicalEquations

eq = balance(ce"2 H2 + O2 = 2 H2O")
rs = reaction_system(eq; name = :combustion)
```

O resultado é um `Catalyst.ReactionSystem` com uma única reação
(assumida **direta** e **elementar**):

```
k, 2 H2 + O2 --> 2 H2O
```

## Simulando com ODEs

```julia
using Catalyst, ChemicalEquations
using OrdinaryDiffEqDefault   # ou DifferentialEquations

rs = reaction_system(balance(ce"2 H2 + O2 = 2 H2O"); name = :combustion)

u0 = [:H2 => 2.0, :O2 => 1.0, :H2O => 0.0]
ps = [:k => 0.05]
tspan = (0.0, 100.0)

prob = ODEProblem(rs, u0, tspan, ps)
sol  = solve(prob)
```

## Redes de Reações

Várias equações podem ser combinadas em uma única rede:

```julia
using Catalyst, ChemicalEquations

eqs = [balance(ce"A = B"), balance(ce"B = C")]
rn = reaction_network(eqs; name = :chain)
```

## Reconversão

Um `ReactionSystem` pode ser reconvertido para `ChemEquation`:

```julia
using Catalyst, ChemicalEquations

rs = reaction_system(balance(ce"2 H2 + O2 = 2 H2O"))
eq = ChemEquation(rs)
```

!!! warning
    A reconversão funciona para espécies cujos símbolos são fórmulas
    químicas válidas. Espécies abstratas do Catalyst (ex.: `SE`) que não
    correspondem a fórmulas reais são ignoradas com um aviso.

## Limitações

- A conversão assume reações **direcionadas** (esquerda → direita) e
  **elementares**, com uma única constante de velocidade `k`.
- Nomes de compostos que não são identificadores válidos do Catalyst
  (ex.: `Γ`, `⬡`) ou compostos carregados não podem ser convertidos.
