# examples/quickstart.jl
# Quick start examples for ChemicalEquations.jl

using ChemicalEquations

println("=" ^ 60)
println("ChemicalEquations.jl — Quick Start Examples")
println("=" ^ 60)

# Example 1: Simple Water Formation
println("\n1️⃣  Water Formation")
println("-" ^ 60)
eq1 = ce"H2 + O2 = H2O"
println("Unbalanced:  $eq1")
balanced1 = balance(eq1)
println("Balanced:    $balanced1")

# Example 2: Methane Combustion
println("\n2️⃣  Methane Combustion")
println("-" ^ 60)
eq2 = ce"CH4 + O2 = CO2 + H2O"
println("Unbalanced:  $eq2")
balanced2 = balance(eq2)
println("Balanced:    $balanced2")

# Example 3: Ethylene Combustion
println("\n3️⃣  Ethylene Combustion")
println("-" ^ 60)
eq3 = ce"C2H4 + O2 = CO2 + H2O"
println("Unbalanced:  $eq3")
balanced3 = balance(eq3)
println("Balanced:    $balanced3")

# Example 4: Iron and Chlorine Redox
println("\n4️⃣  Iron-Chlorine Redox Reaction")
println("-" ^ 60)
eq4 = ce"Fe + Cl2 = FeCl3"
println("Unbalanced:  $eq4")
balanced4 = balance(eq4)
println("Balanced:    $balanced4")

# Example 5: Working with Compounds
println("\n5️⃣  Compound Information")
println("-" ^ 60)
compound = cc"Ca(OH)2"
println("Compound:    $compound")
println("Elements:    $(elements(compound))")
println("Charge:      $(compound.charge)")

# Example 6: Ionic Compound
println("\n6️⃣  Ionic Compound")
println("-" ^ 60)
ion = cc"SO4{-2}"
println("Ion:         $ion")
println("Charge:      $(ion.charge)")
println("Has charge:  $(hascharge(ion))")

# Example 7: Equation Information
println("\n7️⃣  Equation Information")
println("-" ^ 60)
eq7 = ce"H2 + Cl2 = HCl"
balanced7 = balance(eq7)
println("Balanced:    $balanced7")
println("Compounds:   $(compounds(balanced7))")
println("Elements:    $(elements(balanced7))")
println("Has charges: $(hascharge(balanced7))")

# Example 8: Stoichiometric Matrix
println("\n8️⃣  Stoichiometric Matrix")
println("-" ^ 60)
eq8 = ce"H2 + O2 = H2O"
balanced8 = balance(eq8)
println("Equation:    $balanced8")
mat = equationmatrix(balanced8)
println("Matrix (rows=elements, cols=compounds):")
println(mat)

# Example 9: Rational Coefficients
println("\n9️⃣  Rational Coefficients")
println("-" ^ 60)
eq9 = ce"H2 + O2 = H2O"
balanced9 = balance(eq9, fractions=true)
println("Balanced (fractions): $balanced9")

# Example 10: Copper Sulfate Hydrate
println("\n🔟 Hydrate Decomposition")
println("-" ^ 60)
eq10 = ce"CuSO4*5H2O = CuSO4 + H2O"
println("Unbalanced:  $eq10")
balanced10 = balance(eq10)
println("Balanced:    $balanced10")

println("\n" * "=" ^ 60)
println("✅ All examples completed successfully!")
println("=" ^ 60)
