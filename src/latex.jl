"""
Returns a LaTeX string in [mhchem](https://mhchem.github.io/MathJax-mhchem/)
syntax for the given `compound`.

Charges are rendered in mhchem notation:
- `H{+}` → `\\ce{H+}`
- `Ca{2+}` → `\\ce{Ca^{2+}}`
- `SO4{-2}` → `\\ce{SO4^{2-}}`

# Examples
```jldoctest
julia> latex(Compound("H2O"))
"\\\\ce{H2O}"

julia> latex(Compound("H{+}"))
"\\\\ce{H+}"

julia> latex(Compound("Ca{2+}"))
"\\\\ce{Ca^{2+}}"
```
"""
function latex(compound::Compound)
    "\\ce{" * _latexcompound(compound) * "}"
end

"Returns the mhchem body of a compound (without `\\ce{...}` wrapper)."
function _latexcompound(c::Compound)
    s = ""
    for (element, n) ∈ c.tuples
        s *= element
        n > 1 && (s *= string(n))
    end
    return _latexcharge(s, c.charge)
end

"Appends the mhchem charge notation to a compound string."
function _latexcharge(s::String, charge::Int)
    charge == 0 && return s
    q = abs(charge)
    sign = charge > 0 ? "+" : "-"
    if q == 1
        s *= sign
    else
        s *= "^{" * string(q) * sign * "}"
    end
    return s
end

"""
Returns a LaTeX string in [mhchem](https://mhchem.github.io/MathJax-mhchem/)
syntax for the given `equation`.

The forward arrow `->` is used to separate reactants from products,
and integer coefficients are rendered in front of each compound.

# Examples
```jldoctest
julia> latex(ce"H2 + Cl2 = 2 HCl")
"\\\\ce{H2 + Cl2 -> 2 HCl}"

julia> latex(balance(ce"CH4 + O2 = CO2 + H2O"))
"\\\\ce{CH4 + 2 O2 -> CO2 + 2 H2O}"

julia> latex(ce"Cr2O7{-2} + H{+} = Cr{+3} + H2O")
"\\\\ce{Cr2O7^{2-} + H+ -> Cr^{3+} + H2O}"
```
"""
function latex(equation::ChemEquation)
    left = _latexside(equation.tuples, >(0))
    right = _latexside(equation.tuples, <(0))
    "\\ce{" * left * " -> " * right * "}"
end

"Builds one side of the equation in mhchem syntax."
function _latexside(tuples, pred)
    parts = String[]
    for (compound, k) ∈ tuples
        if pred(k)
            coeff = abs(k)
            body = _latexcompound(compound)
            push!(parts, coeff == 1 ? body : "$(coeff) " * body)
        end
    end
    join(parts, " + ")
end
