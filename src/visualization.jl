"""
    plot_stoichiometry(eq::ChemEquation; kwargs...)

Plots the stoichiometric matrix of a chemical equation as a heatmap.

Each **row** corresponds to an element and each **column** corresponds to a
compound. The color intensity of cell `(i, j)` represents how many atoms of
element `i` are present in compound `j`.

!!! note
    Requires `Plots.jl` to be loaded *before* `ChemicalEquations`:
    ```julia
    using Plots
    using ChemicalEquations
    ```

# Arguments
- `eq::ChemEquation`: the equation whose matrix should be plotted.

# Keywords
- `title::String`: plot title (default: `"Stoichiometric Matrix"`).
- `ylabel::String`: label for the y axis (default: `"Elements"`).
- `xlabel::String`: label for the x axis (default: `"Compounds"`).
- Any other keyword is forwarded to `Plots.heatmap`.

# Returns
A `Plots.Plot` object.

# Examples
```julia
using Plots
using ChemicalEquations

eq = ce"CH4 + O2 = CO2 + H2O"
plot_stoichiometry(balance(eq))
```
"""
function plot_stoichiometry(eq::ChemEquation; title="Stoichiometric Matrix",
                            ylabel="Elements", xlabel="Compounds", kwargs...)
    mat = equationmatrix(eq)
    elems = elements(eq)
    comps = [string(c) for (c, _) in eq.tuples]
    hascharge(eq) && push!(elems, "charge")

    Plots.heatmap(1:size(mat, 2), 1:size(mat, 1), mat;
        title=title, ylabel=ylabel, xlabel=xlabel,
        xticks=(1:size(mat, 2), comps),
        yticks=(1:size(mat, 1), elems),
        color=:viridis, xrotation=45,
        kwargs...)
end
