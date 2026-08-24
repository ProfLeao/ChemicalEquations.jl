# LaTeX Export

ChemicalEquations.jl can convert compounds and balanced equations to
[LaTeX](https://www.latex-project.org/) strings in
[mhchem](https://mhchem.github.io/MathJax-mhchem/) syntax.
This is ideal for writing reports, papers, and presentations.

## Compiling the Output

To use the generated code, include the `mhchem` package in your LaTeX
document:

```latex
\documentclass{article}
\usepackage[version=4]{mhchem}
\begin{document}
\ce{CH4 + 2 O2 -> CO2 + 2 H2O}
\end{document}
```

In Jupyter/Colab with MathJax, just write `$\ce{...}$`.

## `latex(compound::Compound)`

Converts a compound to the `\ce{...}` notation.

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

Charges are rendered correctly:
- Charge `±1` → `H+` or `OH-`
- Multiple charge → `Ca^{2+}`, `Fe^{3+}`, `SO4^{2-}`

## `latex(equation::ChemEquation)`

Converts a balanced chemical equation to the `\ce{...}` notation, using
`->` to separate reactants from products.

```julia
julia> latex(ce"H2 + Cl2 = 2 HCl")
"\\ce{H2 + Cl2 -> 2 HCl}"

julia> latex(balance(ce"CH4 + O2 = CO2 + H2O"))
"\\ce{CH4 + 2 O2 -> CO2 + 2 H2O}"
```

The result can be embedded directly in LaTeX documents:

```latex
Methane combustion is given by $\ce{CH4 + 2 O2 -> CO2 + 2 H2O}$.
```

## Combining with `balance()`

The `latex` function is often combined with `balance()` to export the
already-balanced equation:

```julia
eq = ce"Fe + Cl2 = FeCl3"
balanced = balance(eq)
s = latex(balanced)   # "\\ce{Fe + 3//2 Cl2 -> FeCl3}"
```

## Additional examples

| Input                             | LaTeX output                      |
|-----------------------------------|-----------------------------------|
| `ce"H2 + O2 = H2O"`              | `\ce{H2 + O2 -> H2O}`            |
| `ce"N2 + H2 = NH3"`              | `\ce{N2 + H2 -> NH3}`            |
| `ce"CuSO4 * 5H2O = CuSO4 + H2O"` | `\ce{CuSO9H10 -> CuSO4 + H2O}`   |
| `balance(ce"KMnO4 + HCl = MnCl2 + Cl2 + KCl + H2O")` | `\ce{...}` |

!!! tip "Tip"
    To get the balanced result with integer coefficients (nicer for
    publications), call `latex(balance(eq))`.
