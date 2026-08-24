# API Reference

```@meta
CurrentModule = ChemicalEquations
DocTestSetup  = quote
    using ChemicalEquations
end
```

Complete documentation of all public functions and types in ChemicalEquations.jl.

## Types

### Compound

```julia
struct Compound
    tuples::Vector{Tuple{String, Int}}
    charge::Int
end
```

Represents a chemical compound with elements and optional charge.

#### Constructor

```julia
Compound(str::AbstractString) -> Compound
```

Constructs a compound from a string representation.

**Arguments:**
- `str`: String representation of the compound (e.g., `"H2O"`, `"Na{+}"`, `"Ca(OH)2"`)

**Example:**
```jldoctest
julia> Compound("H2O")
H2O

julia> Compound("H3O{+1}")
H3O{+}
```

#### Properties

- `.tuples::Vector{Tuple{String, Int}}` — Vector of (element, count) pairs
- `.charge::Int` — Net charge on the compound

#### Methods

```julia
Base.string(compound::Compound) -> String
Base.show(io::IO, compound::Compound)
elements(compound::Compound) -> Vector{String}
hascharge(compound::Compound) -> Bool
==(c1::Compound, c2::Compound) -> Bool
```

---

### ChemEquation

```julia
struct ChemEquation{T<:Real}
    tuples::Vector{Tuple{Compound, T}}
end
```

Represents a chemical equation with compounds and coefficients.

#### Constructors

```julia
ChemEquation(str::AbstractString) -> ChemEquation{Int}
ChemEquation{T}(str::AbstractString) where T<:Real -> ChemEquation{T}
ChemEquation(tuples::Vector{Tuple{Compound, T}}) -> ChemEquation{T}
```

Creates a chemical equation from various representations.

**Arguments:**
- `str`: String representation (e.g., `"H2 + O2 = H2O"`)
- `tuples`: Vector of (compound, coefficient) pairs

**Type Parameters:**
- `T`: Numeric type for coefficients (Int, Rational, Float64)

**Example:**
```jldoctest
julia> ce"H2 + O2 = H2O"
H2 + O2 = H2O

julia> ChemEquation{Rational}("1//2 H2 + 1//2 O2 = H2O")
1//2 H2 + 1//2 O2 = H2O

julia> ChemEquation{Float64}("0.5 H2 + 0.5 O2 = H2O")
0.5 H2 + 0.5 O2 = H2O
```

#### Properties

- `.tuples::Vector{Tuple{Compound, T}}` — Vector of (compound, coefficient) pairs

#### Methods

```julia
Base.string(equation::ChemEquation) -> String
Base.show(io::IO, equation::ChemEquation)
compounds(equation::ChemEquation) -> Vector{Compound}
elements(equation::ChemEquation) -> Vector{String}
hascharge(equation::ChemEquation) -> Bool
equationmatrix(equation::ChemEquation) -> Matrix
balancematrix(equation::ChemEquation; fractions=false) -> Matrix
balance(equation::ChemEquation; fractions=false) -> ChemEquation
==(eq1::ChemEquation, eq2::ChemEquation) -> Bool
```

---

## Macros

### @cc_str

```julia
macro cc_str(str)
```

String macro for creating compounds.

**Syntax:**
```julia
cc"formula"
```

**Example:**
```jldoctest
julia> cc"H2O"
H2O

julia> cc"Ca(OH)2"
CaO2H2
```

---

### @ce_str

```julia
macro ce_str(str)
```

String macro for creating chemical equations.

**Syntax:**
```julia
ce"equation"
```

**Example:**
```jldoctest
julia> ce"H2 + O2 = H2O"
H2 + O2 = H2O
```

---

## Functions

### Compound Functions

#### elements(compound::Compound)

```julia
elements(compound::Compound) -> Vector{String}
```

Returns the unique elements in a compound.

**Example:**
```jldoctest
julia> elements(cc"Ca(OH)2")
3-element Vector{String}:
 "Ca"
 "O"
 "H"
```

---

#### hascharge(compound::Compound)

```julia
hascharge(compound::Compound) -> Bool
```

Checks if a compound has a non-zero charge.

**Example:**
```jldoctest
julia> hascharge(cc"H2O")
false

julia> hascharge(cc"H{+}")
true
```

---

### ChemEquation Functions

#### balance

```julia
balance(equation::ChemEquation; fractions::Bool=false) -> ChemEquation
```

Balances a chemical equation using the nullspace method.

**Arguments:**
- `equation`: The equation to balance
- `fractions`: If `true`, returns rational coefficients; if `false` (default), returns integers

**Returns:**
- A balanced equation of the same type as the input

**Throws:**
- `ErrorException` if the equation has no solution or infinite solutions

**Example:**
```jldoctest
julia> eq = ce"H2 + O2 = H2O"
H2 + O2 = H2O

julia> balance(eq)
2 H2 + O2 = 2 H2O

julia> balance(eq, fractions=true)
H2 + 1//2 O2 = H2O
```

---

#### balancematrix

```julia
balancematrix(equation::ChemEquation) -> Matrix
balancematrix(equation::ChemEquation{T}; fractions::Bool=false) where T<:IntegerX -> Matrix{T}
```

Computes the balance matrix (nullspace) of an equation.

**Returns:**
- Matrix where each column is a solution to the balance equation

**Example:**
```jldoctest
julia> eq = ce"H2 + Cl2 = HCl"
H2 + Cl2 = HCl

julia> balancematrix(eq)
3×1 Matrix{Rational{BigInt}}:
  1
  1
 -2
```

---

#### compounds

```julia
compounds(equation::ChemEquation) -> Vector{Compound}
```

Extracts unique compounds from an equation.

**Example:**
```jldoctest
julia> eq = ce"H2 + O2 = H2O"
H2 + O2 = H2O

julia> compounds(eq)
3-element Vector{Compound}:
 H2
 O2
 H2O
```

---

#### elements

```julia
elements(equation::ChemEquation) -> Vector{String}
```

Extracts unique elements from an equation.

**Example:**
```jldoctest
julia> eq = ce"H2 + O2 = H2O"
H2 + O2 = H2O

julia> elements(eq)
2-element Vector{String}:
 "H"
 "O"
```

---

#### equationmatrix

```julia
equationmatrix(equation::ChemEquation) -> Matrix
```

Constructs the stoichiometric matrix of an equation.

**Returns:**
- Matrix where rows are elements, columns are compounds, entries are element counts

**Example:**
```jldoctest
julia> eq = ce"H2 + Cl2 = HCl"
H2 + Cl2 = HCl

julia> equationmatrix(eq)
2×3 Matrix{Int64}:
 2  0  1
 0  2  1
```

---

#### hascharge

```julia
hascharge(equation::ChemEquation) -> Bool
```

Checks if any compound in the equation has a non-zero charge.

**Example:**
```jldoctest
julia> hascharge(ce"H2 + O2 = H2O")
false

julia> hascharge(ce"H{+} + OH{-} = H2O")
true
```

---

#### latex

```julia
latex(compound::Compound) -> String
latex(equation::ChemEquation) -> String
```

Converts a compound or equation to a LaTeX string in
[mhchem](https://mhchem.github.io/MathJax-mhchem/) syntax.

**Example (compound):**
```jldoctest
julia> latex(Compound("H2O"))
"\\ce{H2O}"

julia> latex(Compound("Ca{2+}"))
"\\ce{Ca^{2+}}"
```

**Example (equation):**
```jldoctest
julia> latex(balance(ce"CH4 + O2 = CO2 + H2O"))
"\\ce{CH4 + 2 O2 -> CO2 + 2 H2O}"
```

---

## Visualization

!!! note
    A visualização requer `Plots.jl` carregado *antes* de
    `ChemicalEquations`:
    ```julia
    using Plots
    using ChemicalEquations
    ```

### plot_stoichiometry

```julia
plot_stoichiometry(eq::ChemEquation; title, ylabel, xlabel, kwargs...) -> Plots.Plot
```

Plots the stoichiometric matrix as a heatmap. Rows are elements,
columns are compounds, and cell colors represent atom counts.

**Example:**
```julia
using Plots
using ChemicalEquations

eq = balance(ce"CH4 + O2 = CO2 + H2O")
plot_stoichiometry(eq; title="Combustão de Metano")
```

---

## Constants

### CHARGEREGEX

```julia
const CHARGEREGEX = r"{(.*)}"
```

Regular expression to match charge notation `{...}`.

---

### PLUSREGEX

```julia
const PLUSREGEX = r"(?<!{)\+(?!})"
```

Regular expression to split compounds by `+`, excluding plus signs inside charges.

---

### EQUALCHARS

```julia
const EQUALCHARS = [
    '>', '→', '↣', '↦', '⇾', '⟶', '⟼', '⥟', '⇀', '⇁', '⇒', '⟾',  # forward
    '<', '←', '↢', '↤', '⇽', '⟵', '⟻', '⥚', '↼', '↽', '⇐', '⟽',  # backward
    '↔', '⟷', '⇄', '⇆', '⇌', '⇋', '⇔', '⟺',                          # double
    '=', '≔', '⩴', '≕'                                                # equals
]
```

Characters recognized as equation separators.

---

## Type Aliases

### ElementTuple

```julia
const ElementTuple = Tuple{String, Int}
```

Tuple type for (element, count) pairs.

---

### CompoundTuple

```julia
const CompoundTuple{T} = Tuple{Compound, T}
```

Tuple type for (compound, coefficient) pairs.

---

## Base Method Overloads

### Equality Operators

```julia
==(c1::Compound, c2::Compound) -> Bool
```

Compounds are equal if they have the same elements/counts and charge (order-independent).

```julia
==(eq1::ChemEquation, eq2::ChemEquation) -> Bool
```

Equations are equal if they have the same compounds with same coefficients (order-independent).

---

## Error Handling

### Common Errors

**`ErrorException: "Indeterminate system" or "No solution"`**

Raised by `balance()` when:
- The equation has multiple solutions (indeterminate)
- The equation has no solution (impossible)

**Example triggering error:**
```julia
julia> balance(ce"H2 + O = H + O")
ERROR: ErrorException: ...

julia> balance(ce"H2 + CO = H2O")
ERROR: ErrorException: ...
```

---

## Performance Notes

- **String parsing**: O(n) where n is string length
- **Matrix operations**: O(m³) where m is number of unique elements
- **Typical cases**: < 1 ms for equations with ≤ 20 elements/compounds

---

## See Also

- [Guide](guide.md) — Step-by-step tutorial
- [Examples](examples.md) — Practical use cases
- [Nullspace Method Paper](https://arxiv.org/ftp/arxiv/papers/1110/1110.4321.pdf)
