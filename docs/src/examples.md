# Practical Examples

This page demonstrates practical applications of ChemicalEquations.jl across various chemical domains.

## Combustion Reactions

### Simple Combustion

Balance the combustion of methane:

```jldoctest
julia> using ChemicalEquations

julia> eq = ce"CH4 + O2 = CO2 + H2O"
CH4 + O2 = CO2 + H2O

julia> balanced = balance(eq)
CH4 + 2 O2 = CO2 + 2 H2O
```

### Hydrocarbon Combustion

Balance combustion of ethane:

```jldoctest
julia> eq = ce"C2H6 + O2 = CO2 + H2O"
C2H6 + O2 = CO2 + H2O

julia> balance(eq)
2 C2H6 + 7 O2 = 4 CO2 + 6 H2O
```

### Incomplete Combustion

Combustion with carbon monoxide formation:

```jldoctest
julia> eq = ce"C2H4 + O2 = CO + H2O"
C2H4 + O2 = CO + H2O

julia> balance(eq)
C2H4 + 3//2 O2 = 2 CO + 2 H2O
```

## Redox Reactions

### Dichromate Reduction

Balance a redox reaction with electrons:

```jldoctest
julia> eq = ce"Cr2O7{-2} + H{+} + e = Cr{+3} + H2O"
Cr2O7{-2} + H{+} + e = Cr{+3} + H2O

julia> balance(eq)
Cr2O7{-2} + 14 H{+} + 6 e = 2 Cr{+3} + 7 H2O
```

### Iron and Chlorine

Redox between iron and chlorine:

```jldoctest
julia> eq = ce"Fe + Cl2 = FeCl3"
Fe + Cl2 = FeCl3

julia> balance(eq)
2 Fe + 3 Cl2 = 2 FeCl3
```

### Permanganate Redox

Complex redox with permanganate:

```jldoctest
julia> eq = ce"KMnO4 + HCl = KCl + MnCl2 + H2O + Cl2"
KMnO4 + HCl = KCl + MnCl2 + H2O + Cl2

julia> balance(eq)
2 KMnO4 + 16 HCl = 2 KCl + 2 MnCl2 + 8 H2O + 5 Cl2
```

## Ionic and Precipitation Reactions

### Simple Ionic Reaction

Precipitation of sodium chloride:

```jldoctest
julia> eq = ce"Na{+} + Cl{-} = NaCl"
Na{+} + Cl{-} = NaCl

julia> balance(eq)
Na{+} + Cl{-} = NaCl
```

### Acid-Base Neutralization

Neutralization reaction:

```jldoctest
julia> eq = ce"H{+} + OH{-} = H2O"
H{+} + OH{-} = H2O

julia> balance(eq)
H{+} + OH{-} = H2O
```

### Complex Ionic Equation

Balancing with multiple charges:

```jldoctest
julia> eq = ce"Fe{+3} + OH{-} = Fe(OH)3"
Fe{+3} + OH{-} = Fe(OH)3

julia> balance(eq)
Fe{+3} + 3 OH{-} = Fe(OH)3
```

## Hydrate Decomposition

### Copper Sulfate Hydrate

Decomposition of hydrated salt:

```jldoctest
julia> eq = ce"CuSO4*5H2O = CuSO4 + H2O"
CuSO4*5H2O = CuSO4 + H2O

julia> balance(eq)
CuSO4*5H2O = CuSO4 + 5 H2O
```

### Calcium Hydroxide Hydrate

Another hydrate example:

```jldoctest
julia> eq = ce"Ca(OH)2*8H2O = Ca(OH)2 + H2O"
CaH2O2 + H2O = CaH2O2 + H2O

julia> balance(eq)
CaH10O10 = CaH2O2 + 8 H2O
```

## Complex Polyatomic Systems

### Ferrocyanide Oxidation

Balancing with complex polyatomic ions:

```jldoctest
julia> eq = ce"K4Fe(CN)6 + H2SO4 + H2O = K2SO4 + FeSO4 + (NH4)2SO4 + CO"
K4Fe(CN)6 + H2SO4 + H2O = K2SO4 + FeSO4 + (NH4)2SO4 + CO

julia> balance(eq)
K4Fe(CN)6 + 6 H2SO4 + 6 H2O = 2 K2SO4 + FeSO4 + 3 (NH4)2SO4 + 6 CO
```

### Benzoic Acid Combustion

Aromatic compound combustion:

```jldoctest
julia> eq = ce"C6H5COOH + O2 = CO2 + H2O"
C6H5COOH + O2 = CO2 + H2O

julia> balance(eq)
2 C6H5COOH + 15 O2 = 14 CO2 + 6 H2O
```

## Using Different Coefficient Types

### Rational Coefficients

When you need exact fractional coefficients:

```jldoctest
julia> eq = ce"H2 + Cl2 = HCl"
H2 + Cl2 = HCl

julia> balanced = balance(eq, fractions=true)
H2 + Cl2 = 2 HCl
```

### Float Coefficients

For reactions requiring decimal coefficients:

```jldoctest
julia> eq = ChemEquation{Float64}("0.5 N2 + 1.5 H2 = NH3")
0.5 N2 + 1.5 H2 = NH3

julia> balance(eq)
0.5 N2 + 1.5 H2 = 1.0 NH3
```

## Programmatic Access

### Extracting Stoichiometric Information

Get detailed information about balanced reactions:

```jldoctest
julia> eq = ce"H2 + O2 = H2O"
H2 + O2 = H2O

julia> balanced = balance(eq)
2 H2 + O2 = 2 H2O

julia> compounds(balanced)
3-element Vector{Compound}:
 H2
 O2
 H2O

julia> elements(balanced)
2-element Vector{String}:
 "H"
 "O"

julia> equationmatrix(balanced)
2×3 Matrix{Int64}:
 2  0  2
 0  2  1
```

### Accessing Matrix Data

Get the stoichiometric matrix for further analysis:

```jldoctest
julia> eq = ce"CH4 + O2 = CO2 + H2O"
CH4 + O2 = CO2 + H2O

julia> balanced = balance(eq)
CH4 + 2 O2 = CO2 + 2 H2O

julia> mat = equationmatrix(balanced)
3×4 Matrix{Int64}:
 1  0  1  0
 4  0  2  2
 0  2  2  1
```

Each row represents an element (C, H, O) and each column a compound.

## Greek Letter Elements

### Unicode Support

The parser supports Greek letters and special symbols:

```jldoctest
julia> eq = ce"Γ(Θ2Π)5"
Γ Θ10 Π5

julia> compound = cc"⬡Cl"
⬡Cl
```

## Tips for Complex Reactions

### Handling Electrons

Always represent electrons as `{-}` or `e`:

```jldoctest
julia> eq = ce"S{-2} + I2 = I{-} + S"
S{-2} + I2 = I{-} + S

julia> balance(eq)
S{-2} + I2 = 2 I{-} + S
```

### Multiple Arrow Types

All these notations work identically:

```jldoctest
julia> ce"H2 + O2 = H2O" == ce"H2 + O2 → H2O"
true

julia> ce"H2 + O2 ⇌ H2O" == ce"H2 + O2 ↔ H2O"
true
```

### State Symbol Handling

State symbols are automatically removed during parsing:

```jldoctest
julia> cc"H2O(l)" == cc"H2O(aq)"
true

julia> cc"N2(g)" == cc"N2"
true
```

---

**Next**: See the [API Reference](api.md) for complete documentation of all functions!
