# examples/redox.jl
# Redox reaction examples for ChemicalEquations.jl

using ChemicalEquations

println("=" ^ 60)
println("Redox Reactions — ChemicalEquations.jl")
println("=" ^ 60)

# Example 1: Dichromate Reduction
println("\n1️⃣  Dichromate Reduction with Electrons")
println("-" ^ 60)
eq1 = ce"Cr2O7{-2} + H{+} + e = Cr{+3} + H2O"
println("Unbalanced:  $eq1")
balanced1 = balance(eq1)
println("Balanced:    $balanced1")

# Example 2: Permanganate Reduction
println("\n2️⃣  Permanganate Redox with HCl")
println("-" ^ 60)
eq2 = ce"KMnO4 + HCl = KCl + MnCl2 + H2O + Cl2"
println("Unbalanced:  $eq2")
balanced2 = balance(eq2)
println("Balanced:    $balanced2")

# Example 3: Sulfide Oxidation
println("\n3️⃣  Sulfide Oxidation")
println("-" ^ 60)
eq3 = ce"S{-2} + I2 = I{-} + S"
println("Unbalanced:  $eq3")
balanced3 = balance(eq3)
println("Balanced:    $balanced3")

# Example 4: Iron Oxidation States
println("\n4️⃣  Iron(II) Oxidation to Iron(III)")
println("-" ^ 60)
eq4 = ce"Fe{+2} + e = Fe{+3}"
println("Note: Already balanced: $eq4")
# This shows how charges are handled

# Example 5: Chromium Oxidation
println("\n5️⃣  Chromium Oxidation to Chromate")
println("-" ^ 60)
eq5 = ce"Cr + H{+} + O2 = Cr{+3} + H2O"
println("Unbalanced:  $eq5")
balanced5 = balance(eq5, fractions=true)
println("Balanced:    $balanced5")

# Example 6: Complex Polyatomic Redox
println("\n6️⃣  Ferrocyanide Complex Oxidation")
println("-" ^ 60)
eq6 = ce"K4Fe(CN)6 + H2SO4 + H2O = K2SO4 + FeSO4 + (NH4)2SO4 + CO"
println("Unbalanced:  $eq6")
balanced6 = balance(eq6)
println("Balanced:    $balanced6")

# Example 7: Benzoic Acid Combustion (oxidation)
println("\n7️⃣  Benzoic Acid Combustion")
println("-" ^ 60)
eq7 = ce"C6H5COOH + O2 = CO2 + H2O"
println("Unbalanced:  $eq7")
balanced7 = balance(eq7)
println("Balanced:    $balanced7")

# Example 8: Nitrate Reduction
println("\n8️⃣  Nitrate Reduction")
println("-" ^ 60)
eq8 = ce"NO3{-} + H{+} + e = NO2 + H2O"
println("Unbalanced:  $eq8")
balanced8 = balance(eq8)
println("Balanced:    $balanced8")

# Example 9: Chlorine Disproportionation
println("\n9️⃣  Chlorine Disproportionation")
println("-" ^ 60)
eq9 = ce"Cl2 + OH{-} = Cl{-} + OCl{-} + H2O"
println("Unbalanced:  $eq9")
balanced9 = balance(eq9)
println("Balanced:    $balanced9")

# Example 10: Complex Redox Network
println("\n🔟 Multi-step Redox System")
println("-" ^ 60)
eq10 = ce"MnO4{-} + C2H5OH + H{+} = Mn{+2} + CO2 + H2O"
println("Unbalanced:  $eq10")
balanced10 = balance(eq10)
println("Balanced:    $balanced10")
println("\nDetails:")
println("  Compounds: $(compounds(balanced10))")
println("  Elements:  $(elements(balanced10))")
println("  Matrix:")
println(equationmatrix(balanced10))

println("\n" * "=" ^ 60)
println("✅ All redox examples completed successfully!")
println("=" ^ 60)
