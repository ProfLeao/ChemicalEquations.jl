# ═══════════════════════════════════════════════════════════════════
#  ChemicalEquations.jl — Reaction Thermochemistry (Glenn.jl)
#  Requires Glenn.jl:  Pkg.develop(path=".../Glenn.jl") or Pkg.add("Glenn")
#  Usage: julia --project examples/thermo.jl
# ═══════════════════════════════════════════════════════════════════

using Glenn              # MUST be loaded BEFORE ChemicalEquations
using ChemicalEquations

println("═"^60)
println("1. Methane Combustion")
println("═"^60)

eq1 = balance(ce"CH4 + O2 = CO2 + H2O")
println("Equation: ", eq1)
println("ΔH°rxn  = ", reaction_enthalpy(eq1), " J/mol")
println("ΔS°rxn  = ", reaction_entropy(eq1), " J/(mol·K)")
println("ΔG°rxn  = ", gibbs_free_energy(eq1), " J/mol")
println("Spontaneous? ", is_spontaneous(eq1))
println()

println("═"^60)
println("2. Ammonia Synthesis (Haber-Bosch)")
println("═"^60)

eq2 = balance(ce"N2 + H2 = NH3")
println("Equation: ", eq2)
println("ΔH°rxn = ", reaction_enthalpy(eq2), " J/mol")
println("ΔG°rxn = ", gibbs_free_energy(eq2), " J/mol")
K = equilibrium_constant(eq2)
println("K_eq(298 K) = ", K)
println("Spontaneous? ", is_spontaneous(eq2))
println()

println("═"^60)
println("3. Effect of Temperature on Spontaneity")
println("═"^60)

# Water decomposition: 2 H2O -> 2 H2 + O2
eq3 = balance(ce"H2O = H2 + O2")
for T in (298.15, 1000.0, 1500.0, 2000.0)
    dg = gibbs_free_energy(eq3; T = T)
    println("T = $(T) K:  ΔG = ", round(dg, digits=1), " J/mol  spontaneous = ", is_spontaneous(eq3; T=T))
end
println()

println("═"^60)
println("4. van 't Hoff")
println("═"^60)

dH = van_t_hoff(1.0e-3, 5.0e-3, 300.0, 350.0)
println("ΔH° estimated from K(300K)=1e-3, K(350K)=5e-3: ", dH, " J/mol")

println("✔ Thermochemistry complete!")
