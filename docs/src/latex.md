# LaTeX Export

ChemicalEquations.jl can convert compounds and balanced equations to
[LaTeX](https://www.latex-project.org/) strings in
[mhchem](https://mhchem.github.io/MathJax-mhchem/) syntax.
This is ideal for writing reports, papers, and presentations.

## Compilando o resultado

Para usar o código gerado, inclua o pacote `mhchem` no seu documento LaTeX:

```latex
\documentclass{article}
\usepackage[version=4]{mhchem}
\begin{document}
\ce{CH4 + 2 O2 -> CO2 + 2 H2O}
\end{document}
```

No Jupyter/Colab com MathJax, basta escrever `$\ce{...}$`.

## `latex(compound::Compound)`

Converte um composto para a notação `\ce{...}`.

```julia
julia> latex(Compound("H2O"))
"\\ce{H2O}"

julia> latex(Compound("H{+}"))
"\\ce{H+}"

julia> latex(Compound("Ca{2+}"))
"\\ce{Ca^{2+}}"

julia> latex(Compound("SO4{-2}"))
"\\ce{SO4^{2-}}"

julia> latex(Compound("e"))
"\\ce{e-}"
```

Cargas são renderizadas corretamente:
- Carga `±1` → `H+` ou `OH-`
- Carga múltipla → `Ca^{2+}`, `Fe^{3+}`, `SO4^{2-}`

## `latex(equation::ChemEquation)`

Converte uma equação química balanceada para a notação `\ce{...}`,
usando `->` para separar reagentes de produtos.

```julia
julia> latex(ce"H2 + Cl2 = 2 HCl")
"\\ce{H2 + Cl2 -> 2 HCl}"

julia> latex(balance(ce"CH4 + O2 = CO2 + H2O"))
"\\ce{CH4 + 2 O2 -> CO2 + 2 H2O}"
```

O resultado pode ser embutido diretamente em documentos LaTeX:

```latex
A combustão do metano é dada por $\ce{CH4 + 2 O2 -> CO2 + 2 H2O}$.
```

## Combinação com `balance()`

A função `latex` é frequentemente combinada com `balance()` para
exportar a equação já balanceada:

```julia
eq = ce"Fe + Cl2 = FeCl3"
balanced = balance(eq)
s = latex(balanced)   # "\\ce{Fe + 3//2 Cl2 -> FeCl3}"
```

## Exemplos adicionais

| Entrada                          | Saída LaTeX                        |
|----------------------------------|------------------------------------|
| `ce"H2 + O2 = H2O"`             | `\ce{H2 + O2 -> H2O}`             |
| `ce"N2 + H2 = NH3"`             | `\ce{N2 + H2 -> NH3}`             |
| `ce"CuSO4 * 5H2O = CuSO4 + H2O"` | `\ce{CuSO9H10 -> CuSO4 + H2O}`    |
| `balance(ce"KMnO4 + HCl = MnCl2 + Cl2 + KCl + H2O")` | `\ce{...}` |

!!! tip "Dica"
    Para obter o resultado balanceado com coeficientes inteiros
    (mais bonito para publicações), chame `latex(balance(eq))`.
