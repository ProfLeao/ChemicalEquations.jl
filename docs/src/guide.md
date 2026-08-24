# Getting Started Guide

This guide will walk you through the basics of using ChemicalEquations.jl.

## Installation

First, install the package:

```julia
using Pkg
Pkg.add("ChemicalEquations")
```

## Basic Setup

Import the package:

```jldoctest
julia> using ChemicalEquations
```

## Creating Compounds

### Simple Compounds

Create compounds using the `cc""` string macro:

```jldoctest
julia> water = cc"H2O"
H2O

julia> oxygen = cc"O2"
O2

julia> salt = cc"NaCl"
NaCl
```

### Compounds with Charges

Add charges using curly braces:

```jldoctest
julia> hydroxide = cc"OH{-}"
OH{-}

julia> hydronium = cc"H3O{+}"
H3O{+}

julia> carbonate = cc"CO3{-2}"
CO3{-2}
```

### Complex Compounds

Handle parentheses and coefficients:

```jldoctest
julia> calcium_hydroxide = cc"Ca(OH)2"
CaH2O2

julia> magnesium_nitrate = cc"Mg(NO3)2"
MgN2O6
```

### Hydrated Compounds

Represent hydrated salts:

```jldoctest
julia> copper_sulfate = cc"CuSO4*5H2O"
CuSO9H10
```

## Creating Equations

### Basic Equations

Create equations using the `ce""` string macro:

```jldoctest
julia> eq = ce"H2 + O2 = H2O"
H2 + O2 = H2O
```

### Unbalanced vs Balanced

Note that the equation doesn't need to be balanced when you create it:

```jldoctest
julia> unbalanced = ce"CH4 + O2 = CO2 + H2O"
CH4 + O2 = CO2 + H2O

julia> balanced = balance(unbalanced)
CH4 + 2 O2 = CO2 + 2 H2O
```

## Balancing Equations

### Integer Coefficients

Balance an equation with integer coefficients (default):

```jldoctest
julia> eq = ce"Fe + Cl2 = FeCl3"
Fe + Cl2 = FeCl3

julia> balance(eq)
2 Fe + 3 Cl2 = 2 FeCl3
```

### Rational Coefficients

For reactions that don't have integer solutions, use fractions:

```jldoctest
julia> eq = ce"Fe + Cl2 = FeCl3"
Fe + Cl2 = FeCl3

julia> balance(eq, fractions=true)
2//3 Fe + Cl2 = FeCl3
```

### Float Coefficients

Create equations with float coefficients directly:

```jldoctest
julia> eq = ChemEquation{Float64}("0.5 H2 + 0.5 O2 = H2O")
0.5 H2 + 0.5 O2 = H2O
```

## Working with Ionic Equations

### Creating Ionic Compounds

Ions are represented with charges:

```jldoctest
julia> na_plus = cc"Na{+}"
Na{+}

julia> cl_minus = cc"Cl{-}"
Cl{-}

julia> eq = ce"Na{+} + Cl{-} = NaCl"
Na{+} + Cl{-} = NaCl
```

### Balancing Ionic Reactions

The package automatically handles charge balance:

```jldoctest
julia> eq = ce"Cr2O7{-2} + H{+} + e = Cr{+3} + H2O"
Cr2O7{-2} + H{+} + e = Cr{+3} + H2O

julia> balance(eq)
Cr2O7{-2} + 14 H{+} + 6 e = 2 Cr{+3} + 7 H2O
```

## Extracting Information

### Get Compounds

Extract unique compounds from an equation:

```jldoctest
julia> eq = ce"H2 + Cl2 = HCl"
H2 + Cl2 = HCl

julia> compounds(eq)
3-element Vector{Compound}:
 H2
 Cl2
 HCl
```

### Get Elements

Extract unique elements:

```jldoctest
julia> elements(eq)
2-element Vector{String}:
 "H"
 "Cl"
```

### Check for Charges

Determine if the equation contains charged species:

```jldoctest
julia> hascharge(eq)
false

julia> ionic_eq = ce"Na{+} + Cl{-} = NaCl"
Na{+} + Cl{-} = NaCl

julia> hascharge(ionic_eq)
true
```

## Advanced: Stoichiometric Matrices

### Get the Equation Matrix

The stoichiometric matrix represents the composition:

```jldoctest
julia> eq = ce"H2 + Cl2 = HCl"
H2 + Cl2 = HCl

julia> equationmatrix(eq)
2×3 Matrix{Int64}:
 2  0  1
 0  2  1
```

Each row is an element, each column is a compound.

### Get the Balance Matrix

The balance matrix is the nullspace of the equation matrix:

```jldoctest
julia> balancematrix(eq)
3×1 Matrix{Rational{Int64}}:
 1//1
 1//1
 -2//1
```

The negative sign indicates a product.

## Arrow Types

All standard chemical notation arrows are supported:

```jldoctest
julia> ce"H2 + O2 = H2O"
H2 + O2 = H2O

julia> ce"H2 + O2 → H2O"
H2 + O2 = H2O

julia> ce"H2 + O2 ⇌ H2O"
H2 + O2 = H2O

julia> ce"H2 + O2 ↔ H2O"
H2 + O2 = H2O
```

All are equivalent; the output always uses `=`.

## Tips and Tricks

### Whitespace Handling

Whitespace is ignored:

```jldoctest
julia> ce"H2  +  O2  =  H2O"
H2 + O2 = H2O
```

### State Symbols

State symbols are automatically removed:

```jldoctest
julia> cc"H2O(l)"
H2O

julia> cc"H2O(g)"
H2O
```

### Unicode Elements

You can use Greek letters as element names:

```jldoctest
julia> compound = cc"Γ(Θ2Π)5"
Γ Θ10 Π5

julia> ce"Γ + Θ2 = Γ Θ2"
Γ + Θ2 = Γ Θ2
```

### Normalization

The package automatically normalizes and sorts compounds:

```jldoctest
julia> cc"MgOHOH" == cc"Mg(OH)2"
true

julia> string(cc"H(OH)")
"H2O"
```

---

**Next**: Check out the [Examples](examples.md) for more practical use cases!
