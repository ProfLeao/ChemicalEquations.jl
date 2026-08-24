# ═══════════════════════════════════════════════════════════════════
#  ChemicalEquations.jl — Chemical Kinetics
#  Usage: julia examples/kinetics.jl
# ═══════════════════════════════════════════════════════════════════

using ChemicalEquations

println("═"^60)
println("1. Rate Law (elementary reaction)")
println("═"^60)

eq = ce"2 NO + O2 = 2 NO2"
println("Equation: ", eq)
println("Total order: ", reaction_order(eq))
println("Orders per reactant: ", reactant_orders(eq))

v = rate(eq, "NO" => 0.5, "O2" => 0.25; k = 1.2e-3)
println("v = k·[NO]²·[O2] = ", v)
println()

println("═"^60)
println("2. RateLaw")
println("═"^60)

law = RateLaw(1.2e-3, eq)
println("RateLaw: ", law)
println("rate(law, ...) = ", rate(law, Dict("NO" => 0.5, "O2" => 0.25)))
println()

println("═"^60)
println("3. Half-Life")
println("═"^60)

for order in (0, 1, 2, 3)
    t12 = half_life(0.1, order; initial = 1.0)
    println("Order $order: t½ = ", t12)
end
println()

println("═"^60)
println("4. Arrhenius: effect of temperature")
println("═"^60)

A  = 2.0e12   # pre-exponential factor
Ea = 50000.0  # J/mol
for T in (298.15, 350.0, 400.0, 500.0)
    k = rate_constant(T; A = A, Ea = Ea)
    println("k($(T) K) = ", k)
end
