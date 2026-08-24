# ═══════════════════════════════════════════════════════════════════
#  ChemicalEquations.jl — Visualização da Matriz Estequiométrica
#  Requer Plots.jl:  Pkg.add("Plots")
#  Uso: julia examples/visualization.jl
# ═══════════════════════════════════════════════════════════════════

using Plots            # DEVE ser carregado ANTES
using ChemicalEquations

# ────────────────────────────────────────────────────────────────
# 1. Combustão de Metano — matriz 3×3
# ────────────────────────────────────────────────────────────────
println("═"^60)
println("1. Combustão de Metano")
println("═"^60)

eq1 = balance(ce"CH4 + O2 = CO2 + H2O")
println("Equação balanceada: ", eq1)
println()
println("Matriz estequiométrica:")
display(equationmatrix(eq1))
println()

p1 = plot_stoichiometry(eq1; title="Combustão de Metano")
savefig(p1, "metano.png")
println("Salvo: metano.png")
println()

# ────────────────────────────────────────────────────────────────
# 2. Reação Redox — matriz 4×4 (inclui linha de carga)
# ────────────────────────────────────────────────────────────────
println("═"^60)
println("2. Reação Redox (Dicromato + HCl)")
println("═"^60)

eq2 = balance(ce"Cr2O7{-2} + H{+} + e = Cr{+3} + H2O")
println("Equação balanceada: ", eq2)
println("Compostos: ", [string(c) for (c, _) in eq2.tuples])
println("Elementos: ", elements(eq2))
println()

p2 = plot_stoichiometry(eq2; title="Redox: Dicromato")
savefig(p2, "redox.png")
println("Salvo: redox.png")
println()

# ────────────────────────────────────────────────────────────────
# 3. Combustão de Glicose — matriz maior (5×3)
# ────────────────────────────────────────────────────────────────
println("═"^60)
println("3. Respiração Celular (Glicose)")
println("═"^60)

eq3 = balance(ce"C6H12O6 + O2 = CO2 + H2O")
println("Equação balanceada: ", eq3)
println()

p3 = plot_stoichiometry(eq3; title="Respiração Celular")
savefig(p3, "glicose.png")
println("Salvo: glicose.png")
println()

println("✔ Visualização concluída! Abra os PNGs gerados para ver os heatmaps.")
