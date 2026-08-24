# ═══════════════════════════════════════════════════════════════════
#  ChemicalEquations.jl — Stoichiometric Matrix Visualization
#  Requires Plots.jl:  Pkg.add("Plots")
#  Usage: julia examples/visualization.jl
# ═══════════════════════════════════════════════════════════════════

using Plots            # MUST be loaded BEFORE ChemicalEquations
using ChemicalEquations

# ────────────────────────────────────────────────────────────────
# 1. Methane Combustion — 3×4 matrix
# ────────────────────────────────────────────────────────────────
println("═"^60)
println("1. Methane Combustion")
println("═"^60)

eq1 = balance(ce"CH4 + O2 = CO2 + H2O")
println("Balanced equation: ", eq1)
println()
println("Stoichiometric matrix:")
display(equationmatrix(eq1))
println()

p1 = plot_stoichiometry(eq1; title="Methane Combustion")
savefig(p1, "methane.png")
println("Saved: methane.png")
println()

# ────────────────────────────────────────────────────────────────
# 2. Redox Reaction — includes a charge row
# ────────────────────────────────────────────────────────────────
println("═"^60)
println("2. Redox Reaction (Dichromate + HCl)")
println("═"^60)

eq2 = balance(ce"Cr2O7{-2} + H{+} + e = Cr{+3} + H2O")
println("Balanced equation: ", eq2)
println("Compounds: ", [string(c) for (c, _) in eq2.tuples])
println("Elements: ", elements(eq2))
println()

p2 = plot_stoichiometry(eq2; title="Redox: Dichromate")
savefig(p2, "redox.png")
println("Saved: redox.png")
println()

# ────────────────────────────────────────────────────────────────
# 3. Glucose Combustion — larger 3×4 matrix
# ────────────────────────────────────────────────────────────────
println("═"^60)
println("3. Cellular Respiration (Glucose)")
println("═"^60)

eq3 = balance(ce"C6H12O6 + O2 = CO2 + H2O")
println("Balanced equation: ", eq3)
println()

p3 = plot_stoichiometry(eq3; title="Cellular Respiration")
savefig(p3, "glucose.png")
println("Saved: glucose.png")
println()

println("✔ Visualization complete! Open the generated PNGs to see the heatmaps.")
