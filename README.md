# ChemicalEquations.jl

[![CI Status](https://github.com/ProfLeao/ChemicalEquations.jl/workflows/CI/badge.svg)](https://github.com/ProfLeao/ChemicalEquations.jl/actions)
[![Docs Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://profleao.github.io/ChemicalEquations.jl/stable/)
[![Docs Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://profleao.github.io/ChemicalEquations.jl/dev/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE.md)
[![Version](https://img.shields.io/badge/version-0.2.0-blue.svg)](#)

*Write and balance chemical equations elegantly and efficiently.*

## Overview

**ChemicalEquations.jl** is a Julia package for parsing, manipulating, and balancing chemical equations. It uses a robust mathematical approach based on **linear algebra (nullspace method)** to compute stoichiometric coefficients for any chemical reaction, including complex redox reactions and multi-phase systems.

### ✨ Key Features

- ✅ **Elegant API**: String macros `cc"..."` and `ce"..."` for intuitive notation
- ✅ **Unicode Support**: Greek letters and special symbols as element names
- ✅ **Flexible Types**: Integer, Rational, and Float64 coefficients
- ✅ **Redox Reactions**: Automatic handling of electrons and ionic charges
- ✅ **Robust Parsing**: Handles parentheses, hydrates, and state symbols
- ✅ **Mathematical Precision**: Nullspace-based balancing for exact solutions
- ✅ **LaTeX Export**: Generate `\ce{...}` (mhchem) strings for publications
- ✅ **Visualization**: Heatmap of the stoichiometric matrix (Plots.jl)
- ✅ **Comprehensive Tests**: 80+ test cases covering edge cases

---

## Installation

Install the package directly from the Julia REPL:

```julia
using Pkg
Pkg.add("ChemicalEquations")
```

Or using the `add` command in the Pkg REPL:

```julia
]add ChemicalEquations
```

---

## Quick Start

### Basic Usage

```julia
using ChemicalEquations

# Create compounds
water = cc"H2O"
oxygen = cc"O2"
hydrogen = cc"H2"

# Create an unbalanced equation
eq = ce"H2 + O2 → H2O"

# Balance it
balanced = balance(eq)
println(balanced)  # Output: 2 H2 + O2 = 2 H2O
```

### Working with Compounds

```julia
using ChemicalEquations

# Parse a compound
compound = cc"Ca(OH)2"
println(string(compound))  # Output: CaH2O2

# Check properties
println(compound.charge)   # Output: 0
println(compound.tuples)   # Output: [("Ca", 1), ("H", 2), ("O", 2)]

# Create charged species
hydroxide = cc"OH{-}"
hydronium = cc"H3O{+}"
```

---

## Examples

### Example 1: Combustion Reaction

```julia
using ChemicalEquations

# Combustion of ethylene
eq = ce"C2H4 + O2 = CO2 + H2O"
balanced = balance(eq)
println(balanced)  # Output: C2H4 + 3 O2 = 2 CO2 + 2 H2O
```

### Example 2: Complex Redox Reaction

```julia
using ChemicalEquations

# Dichromate reduction with electrons
eq = ce"Cr2O7{-2} + H{+} + e = Cr{+3} + H2O"
balanced = balance(eq)
println(balanced)  
# Output: Cr2O7{-2} + 14 H{+} + 6 e = 2 Cr{+3} + 7 H2O
```

### Example 3: Hydrate Decomposition

```julia
using ChemicalEquations

# Copper sulfate hydrate
eq = ce"CuSO4*5H2O = CuSO4 + H2O"
balanced = balance(eq)
println(balanced)  # Output: CuSO4*5H2O = CuSO4 + 5 H2O
```

### Example 4: Rational Coefficients

```julia
using ChemicalEquations

# Use fractions for non-integer coefficients
eq = ce"Fe + Cl2 = FeCl3"
balanced = balance(eq, fractions=true)
println(balanced)  # Output: 2//3 Fe + Cl2 = FeCl3
```

### Example 5: Ionic Reactions

```julia
using ChemicalEquations

# Precipitation reaction
eq = ce"Na{+} + Cl{-} = NaCl"
balanced = balance(eq)
println(balanced)  # Output: Na{+} + Cl{-} = NaCl
```

### Example 6: LaTeX Export

```julia
using ChemicalEquations

# Gerar código LaTeX (mhchem) para publicações
eq = ce"CH4 + O2 = CO2 + H2O"
println(latex(balance(eq)))
# Output: \ce{CH4 + 2 O2 -> CO2 + 2 H2O}

println(latex(Compound("H{+}")))
# Output: \ce{H+}
```

### Example 7: Visualization

```julia
using Plots              # DEVE ser carregado antes
using ChemicalEquations

eq = balance(ce"CH4 + O2 = CO2 + H2O")
plot_stoichiometry(eq; title="Combustão de Metano")
```

---

## API Reference

### Compound API

#### Construction

```julia
cc"formula"         # Create compound from string
Compound(str)       # Direct constructor
```

#### Properties

```julia
compound.tuples     # Vector of (element, count) tuples
compound.charge     # Integer net charge
```

#### Methods

```julia
string(compound)    # Human-readable representation
show(compound)      # REPL display
elements(compound)  # List of elements present
hascharge(compound) # Check if charged
==(c1, c2)          # Equality (order-independent)
```

### ChemEquation API

#### Construction

```julia
ce"equation"                    # Create equation from string
ChemEquation(str)               # Direct constructor
ChemEquation{Rational}(str)     # Rational coefficients
ChemEquation{Float64}(str)      # Float coefficients
```

#### Properties

```julia
equation.tuples                 # Vector of (compound, coefficient) tuples
```

#### Methods

```julia
balance(eq)                     # Balance with integer coefficients
balance(eq, fractions=true)     # Balance with rational coefficients
string(equation)                # Human-readable representation
show(equation)                  # REPL display
compounds(equation)             # Extract unique compounds
elements(equation)              # Extract unique elements
hascharge(equation)             # Check if contains charged species
equationmatrix(equation)        # Get stoichiometric matrix
balancematrix(equation)         # Get balance matrix (nullspace)
```

---

## Advanced Topics

### Custom Element Names

The parser supports any Unicode letter as an element symbol:

```julia
using ChemicalEquations

# Greek letters
eq = ce"Γ + Θ2 → Γ Θ2"

# Custom elements
compound = cc"⬡Cl"
```

### Multiple Arrow Types

All common chemical equation notations are supported:

```julia
ce"H2 + O2 = H2O"      # Equals sign
ce"H2 + O2 → H2O"      # Forward arrow
ce"H2 + O2 ⇌ H2O"      # Equilibrium arrow
ce"H2 + O2 ↔ H2O"      # Reversible arrow
```

### Accessing Stoichiometric Data

```julia
using ChemicalEquations

eq = ce"H2 + Cl2 = HCl"
balanced = balance(eq)

# Get the stoichiometric matrix
mat = equationmatrix(balanced)
println(mat)
# Output: 2×3 Matrix{Int64}:
#         2  0  1
#         0  2  1
```

---

## Roadmap

- [x] **Visualization**: Heatmap of stoichiometric matrix (Plots.jl integration)
- [x] **LaTeX Export**: Generate `\ce{...}` (mhchem) formatted strings for publications
- [ ] **Kinetics**: Integration with reaction rate constants
- [ ] **Thermodynamics**: ΔH, ΔG calculations
- [ ] **Catalyst.jl Integration**: Direct compatibility with SciML workflows

---

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## References

- **Nullspace Method**: [Thorne (2009) - Balancing Chemical Equations](https://arxiv.org/ftp/arxiv/papers/1110/1110.4321.pdf)
- **Catalyst.jl**: [SciML Reaction Networks](https://github.com/SciML/Catalyst.jl)
- **Julia Docs**: [Official Julia Language Documentation](https://docs.julialang.org)

---

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

---

## Author

**Reginaldo Gonçalves Leão Junior** ([prof.reginaldo.leao@gmail.com](mailto:prof.reginaldo.leao@gmail.com))

Department of Chemical Engineering  
*Expertise in chemical kinetics, combustion, and reaction engineering*