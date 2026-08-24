# examples/combustion.jl
# Combustion reaction examples for ChemicalEquations.jl

using ChemicalEquations

println("=" ^ 60)
println("Combustion Reactions — ChemicalEquations.jl")
println("=" ^ 60)

# Example 1: Simple Hydrocarbon Combustion
println("\n1️⃣  Methane Combustion")
println("-" ^ 60)
eq1 = ce"CH4 + O2 = CO2 + H2O"
println("Unbalanced:  $eq1")
balanced1 = balance(eq1)
println("Balanced:    $balanced1")
println("Energy release: ~890 kJ/mol")

# Example 2: Ethane Combustion
println("\n2️⃣  Ethane Combustion")
println("-" ^ 60)
eq2 = ce"C2H6 + O2 = CO2 + H2O"
println("Unbalanced:  $eq2")
balanced2 = balance(eq2)
println("Balanced:    $balanced2")

# Example 3: Propane Combustion
println("\n3️⃣  Propane Combustion")
println("-" ^ 60)
eq3 = ce"C3H8 + O2 = CO2 + H2O"
println("Unbalanced:  $eq3")
balanced3 = balance(eq3)
println("Balanced:    $balanced3")

# Example 4: Ethylene Combustion
println("\n4️⃣  Ethylene (Alkene) Combustion")
println("-" ^ 60)
eq4 = ce"C2H4 + O2 = CO2 + H2O"
println("Unbalanced:  $eq4")
balanced4 = balance(eq4)
println("Balanced:    $balanced4")

# Example 5: Acetylene Combustion
println("\n5️⃣  Acetylene (Alkyne) Combustion")
println("-" ^ 60)
eq5 = ce"C2H2 + O2 = CO2 + H2O"
println("Unbalanced:  $eq5")
balanced5 = balance(eq5)
println("Balanced:    $balanced5")

# Example 6: Incomplete Combustion (CO formation)
println("\n6️⃣  Incomplete Combustion (Limited O2)")
println("-" ^ 60)
eq6 = ce"C2H4 + O2 = CO + H2O"
println("Unbalanced:  $eq6")
balanced6 = balance(eq6, fractions=true)
println("Balanced:    $balanced6")

# Example 7: Sulfur Combustion
println("\n7️⃣  Sulfur Combustion")
println("-" ^ 60)
eq7 = ce"S + O2 = SO2"
println("Balanced:    $(balance(eq7))")

# Example 8: Phosphorus Combustion
println("\n8️⃣  Phosphorus Combustion")
println("-" ^ 60)
eq8 = ce"P + O2 = P2O5"
println("Unbalanced:  $eq8")
balanced8 = balance(eq8, fractions=true)
println("Balanced:    $balanced8")

# Example 9: Benzene Combustion
println("\n9️⃣  Benzene Combustion")
println("-" ^ 60)
eq9 = ce"C6H6 + O2 = CO2 + H2O"
println("Unbalanced:  $eq9")
balanced9 = balance(eq9)
println("Balanced:    $balanced9")

# Example 10: Glucose Combustion (cellular respiration)
println("\n🔟 Glucose Combustion (C6H12O6)")
println("-" ^ 60)
eq10 = ce"C6H12O6 + O2 = CO2 + H2O"
println("Unbalanced:  $eq10")
balanced10 = balance(eq10)
println("Balanced:    $balanced10")
println("\nThis is the overall reaction for aerobic respiration!")
println("Energy released: ~2800 kJ/mol (captured in ATP)")

# Analysis of combustion products
println("\n" * "=" ^ 60)
println("COMBUSTION ANALYSIS: Ethane (C2H6)")
println("=" ^ 60)
eq_analysis = ce"C2H6 + O2 = CO2 + H2O"
balanced_analysis = balance(eq_analysis)
println("Balanced: $balanced_analysis")

compounds_list = compounds(balanced_analysis)
elements_list = elements(balanced_analysis)

println("\nCompounds produced:")
for (i, comp) in enumerate(compounds_list)
    println("  $i. $comp")
end

println("\nElements involved:")
for elem in elements_list
    println("  • $elem")
end

mat = equationmatrix(balanced_analysis)
println("\nStoichiometric matrix:")
println(mat)
println("\n  Rows:    Elements (C, H, O)")
println("  Columns: Compounds (C2H6, O2, CO2, H2O)")

println("\n" * "=" ^ 60)
println("✅ All combustion examples completed successfully!")
println("=" ^ 60)
