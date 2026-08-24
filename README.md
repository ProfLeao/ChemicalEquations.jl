# ChemicalEquations.jl

[![CI Status](https://github.com/ProfLeao/ChemicalEquations.jl/workflows/CI/badge.svg)](https://github.com/ProfLeao/ChemicalEquations.jl/actions)
[![Docs Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://profleao.github.io/ChemicalEquations.jl/stable/)
[![Docs Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://profleao.github.io/ChemicalEquations.jl/dev/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE.md)
[![Version](https://img.shields.io/badge/version-0.2.0-blue.svg)](#)
[![Buy Me a Coffee](https://img.shields.io/badge/Buy_Me_A_Coffee-ffdd00?logo=buymeacoffee&logoColor=000)](https://www.buymeacoffee.com/reginaldoleao)

*Write and balance chemical equations elegantly and efficiently.*

---

## Table of Contents

- [Overview](#overview)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Documentation](#documentation)
- [Examples](#examples)
- [Advanced Topics](#advanced-topics)
- [API Overview](#api-overview)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [Support](#support)
- [References](#references)
- [License](#license)
- [Author](#author)

---

## Overview

**ChemicalEquations.jl** is a Julia package for parsing, manipulating, and
balancing chemical equations. It uses a robust mathematical approach based on
**linear algebra (nullspace method)** to compute stoichiometric coefficients
for any chemical reaction — including complex redox reactions, ionic species,
and multi-phase systems.

### ✨ Key Features

| Feature | Description |
|---------|-------------|
| 🧪 **Elegant API** | String macros `cc"..."` and `ce"..."` for intuitive notation |
| 🔤 **Unicode Support** | Greek letters and special symbols as element names |
| 🔢 **Flexible Types** | Integer, Rational, and Float64 coefficients |
| ⚡ **Redox Reactions** | Automatic electrons and ionic charge handling |
| 📦 **Robust Parsing** | Parentheses, hydrates, and state symbols |
| 🎯 **Mathematical Precision** | Exact nullspace-based balancing |
| 📄 **LaTeX Export** | `\ce{...}` (mhchem) output for publications |
| 📊 **Visualization** | Stoichiometric matrix heatmaps (Plots.jl) |
| ⏱️ **Chemical Kinetics** | Rate laws, half-lives, Arrhenius equation |
| 🔥 **Thermochemistry** | ΔH°, ΔS°, ΔG° and K_eq via [Glenn.jl](https://github.com/ProfLeao/Glenn.jl) |
| 🔗 **Catalyst.jl** | Convert equations to `ReactionSystem`s for SciML |
| ✅ **Comprehensive Tests** | 100+ test cases covering edge cases |

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

Balancing a chemical equation is as simple as:

```julia
using ChemicalEquations

# Create an unbalanced equation
eq = ce"H2 + O2 = H2O"

# Balance it
balanced = balance(eq)
println(balanced)  # Output: 2 H2 + O2 = 2 H2O
```

Compounds are just as easy:

```julia
using ChemicalEquations

water   = cc"H2O"          # Simple compound
sulfate = cc"SO4{-2}"      # Charged ion
salt    = cc"NaCl"
```

---

## Documentation

The full documentation is available at
[profleao.github.io/ChemicalEquations.jl](https://profleao.github.io/ChemicalEquations.jl/stable/):

| Page | Contents |
|------|----------|
| [Guide](https://profleao.github.io/ChemicalEquations.jl/stable/guide/) | Step-by-step tutorial |
| [Examples](https://profleao.github.io/ChemicalEquations.jl/stable/examples/) | Practical use cases |
| [Chemical Kinetics](https://profleao.github.io/ChemicalEquations.jl/stable/kinetics/) | Rate laws, half-lives, Arrhenius |
| [Thermochemistry](https://profleao.github.io/ChemicalEquations.jl/stable/thermo/) | ΔH°, ΔS°, ΔG°, K_eq (Glenn.jl) |
| [Catalyst Integration](https://profleao.github.io/ChemicalEquations.jl/stable/catalyst/) | ReactionSystem conversion |
| [LaTeX Export](https://profleao.github.io/ChemicalEquations.jl/stable/latex/) | mhchem output |
| [API Reference](https://profleao.github.io/ChemicalEquations.jl/stable/api/) | Complete API documentation |

---

## Examples

### Balancing

**Combustion of ethylene:**

```julia
eq = ce"C2H4 + O2 = CO2 + H2O"
balance(eq)
# Output: C2H4 + 3 O2 = 2 CO2 + 2 H2O
```

**Redox with electrons:**

```julia
eq = ce"Cr2O7{-2} + H{+} + e = Cr{+3} + H2O"
balance(eq)
# Output: Cr2O7{-2} + 14 H{+} + 6 e = 2 Cr{+3} + 7 H2O
```

**Ionic precipitation:**

```julia
eq = ce"Na{+} + Cl{-} = NaCl"
balance(eq)
# Output: Na{+} + Cl{-} = NaCl
```

**Hydrate decomposition:**

```julia
eq = ce"CuSO4*5H2O = CuSO4 + H2O"
balance(eq)
# Output: CuSO9H10 = CuSO4 + 5 H2O
```

**Rational coefficients:**

```julia
balance(ce"Fe + Cl2 = FeCl3", fractions = true)
# Output: Fe + 3//2 Cl2 = FeCl3
```

### Chemical Kinetics

```julia
eq = ce"2 NO + O2 = 2 NO2"

rate(eq, "NO" => 0.5, "O2" => 0.25; k = 1.2e-3)  # v = k·[NO]²·[O2]
half_life(0.1, 2, initial = 1.0)                  # second-order half-life
rate_constant(400.0; A = 2.0e12, Ea = 50000.0)    # Arrhenius
```

### Thermochemistry

```julia
using Glenn              # MUST be loaded first
using ChemicalEquations

eq = balance(ce"CH4 + O2 = CO2 + H2O")
reaction_enthalpy(eq)     # -802562.0 J/mol
gibbs_free_energy(eq)     # -801004.0 J/mol
is_spontaneous(eq)        # true
```

### Output Formats

**LaTeX (mhchem):**

```julia
latex(balance(ce"CH4 + O2 = CO2 + H2O"))
# Output: \ce{CH4 + 2 O2 -> CO2 + 2 H2O}
```

**Visualization:**

```julia
using Plots              # MUST be loaded first
using ChemicalEquations

plot_stoichiometry(balance(ce"CH4 + O2 = CO2 + H2O"); title = "Methane Combustion")
```

---

## Advanced Topics

### Custom Element Names

The parser supports any Unicode letter as an element symbol:

```julia
eq = ce"Γ + Θ2 → Γ Θ2"   # Greek letters
compound = cc"⬡Cl"       # Custom elements
```

### Multiple Arrow Types

All common chemical equation notations are supported:

```julia
ce"H2 + O2 = H2O"      # Equals sign
ce"H2 + O2 → H2O"      # Forward arrow
ce"H2 + O2 ⇌ H2O"      # Equilibrium arrow
ce"H2 + O2 ↔ H2O"      # Reversible arrow
```

### Stoichiometric Data

```julia
eq = ce"H2 + Cl2 = HCl"
mat = equationmatrix(balance(eq))
# Output: 2×3 Matrix{Int64}:
#         2  0  1
#         0  2  1
```

---

## API Overview

The main entry points:

| Type / Function | Description |
|-----------------|-------------|
| `cc"..."` / `Compound(str)` | Create a compound |
| `ce"..."` / `ChemEquation(str)` | Create an equation |
| `balance(eq)` | Balance an equation |
| `compounds(eq)`, `elements(eq)` | Extract species / elements |
| `equationmatrix(eq)`, `balancematrix(eq)` | Stoichiometric matrices |
| `rate(eq, concs)`, `half_life(k, n)` | Chemical kinetics |
| `reaction_enthalpy(eq)`, `gibbs_free_energy(eq)` | Thermochemistry |
| `latex(eq)`, `plot_stoichiometry(eq)` | LaTeX and visualization output |
| `reaction_system(eq)` | Catalyst.jl integration |

See the [API Reference](https://profleao.github.io/ChemicalEquations.jl/stable/api/) for the complete documentation.

---

## Roadmap

### ✅ Implemented

- [x] **Visualization**: Heatmap of the stoichiometric matrix (Plots.jl)
- [x] **LaTeX Export**: `\ce{...}` (mhchem) strings for publications
- [x] **Kinetics**: Rate laws, reaction orders, half-lives, Arrhenius equation
- [x] **Thermochemistry**: ΔH°, ΔS°, ΔG° and K_eq via [Glenn.jl](https://github.com/ProfLeao/Glenn.jl)
- [x] **Catalyst.jl Integration**: `ReactionSystem` conversion for SciML workflows

---

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## Support ☕

If you find **ChemicalEquations.jl** useful and would like to support its
continued development, consider buying me a coffee — every little bit helps!

[![Buy Me a Coffee](https://img.shields.io/badge/Buy_Me_A_Coffee-ffdd00?logo=buymeacoffee&logoColor=000)](https://www.buymeacoffee.com/reginaldoleao)

Thank you for using the package! 🙏

---

## References

- **Nullspace Method**: [Thorne (2009) — Balancing Chemical Equations](https://arxiv.org/ftp/arxiv/papers/1110/1110.4321.pdf)
- **Glenn.jl**: [NASA Glenn Coefficients for Thermochemistry](https://github.com/ProfLeao/Glenn.jl)
- **Catalyst.jl**: [SciML Reaction Networks](https://github.com/SciML/Catalyst.jl)
- **mhchem**: [LaTeX Chemistry Notation](https://mhchem.github.io/MathJax-mhchem/)
- **Plots.jl**: [Plotting Library for Julia](https://github.com/JuliaPlots/Plots.jl)
- **Julia Docs**: [Official Julia Language Documentation](https://docs.julialang.org)

---

## License

This project is licensed under the MIT License — see the [LICENSE.md](LICENSE.md) file for details.

---

## Author

**Reginaldo Gonçalves Leão Junior** ([prof.reginaldo.leao@gmail.com](mailto:prof.reginaldo.leao@gmail.com))

*Expertise in chemical kinetics, combustion, and reaction engineering*