# Thermochemistry tests. Requires Glenn.jl to be loaded
# (guarded in runtests.jl via Base.find_package("Glenn")).
using Glenn

@testset "reaction_enthalpy" begin
    # CH4 + 2 O2 -> CO2 + 2 H2O  (combustão do metano)
    eq = balance(ce"CH4 + O2 = CO2 + H2O")
    @test reaction_enthalpy(eq) ≈ -802562.0 atol=1.0

    # N2 + 3 H2 -> 2 NH3  (síntese de Haber-Bosch)
    eq2 = balance(ce"N2 + H2 = NH3")
    @test reaction_enthalpy(eq2) ≈ -91880.0 atol=1.0

    # H2 + 1/2 O2 -> H2O (gás)
    eq3 = balance(ce"H2 + O2 = H2O", fractions=true)
    @test reaction_enthalpy(eq3) ≈ -241826.0 atol=1.0
end

@testset "reaction_entropy" begin
    eq = balance(ce"CH4 + O2 = CO2 + H2O")
    @test reaction_entropy(eq) ≈ -5.224375 atol=0.01
    eq2 = balance(ce"N2 + H2 = NH3")
    @test reaction_entropy(eq2) ≈ -198.11 atol=0.5
end

@testset "gibbs_free_energy" begin
    eq = balance(ce"CH4 + O2 = CO2 + H2O")
    @test gibbs_free_energy(eq) ≈ -801004.35 atol=5.0
    eq2 = balance(ce"N2 + H2 = NH3")
    @test gibbs_free_energy(eq2) ≈ -32812.85 atol=5.0
end

@testset "is_spontaneous" begin
    @test is_spontaneous(balance(ce"CH4 + O2 = CO2 + H2O"))
    @test is_spontaneous(balance(ce"N2 + H2 = NH3"))
    # A reação inversa (decomposição do NH3) NÃO é espontânea
    @test !is_spontaneous(balance(ce"NH3 = N2 + H2"))
end

@testset "equilibrium_constant" begin
    # Haber-Bosch a 298.15 K
    K = equilibrium_constant(balance(ce"N2 + H2 = NH3"))
    @test K ≈ 560484.3 rtol=0.01
    @test K > 1.0
    # Combustão tem K astronomicamente grande
    @test equilibrium_constant(balance(ce"CH4 + O2 = CO2 + H2O")) > 1e100
end

@testset "van_t_hoff" begin
    @test van_t_hoff(1.0e-3, 5.0e-3, 300.0, 350.0) ≈ 28101.38 rtol=1e-4
    # K aumentando com T (T2 > T1) => reação endotérmica => ΔH > 0
    @test van_t_hoff(1.0, 2.0, 300.0, 320.0) > 0
    # K diminuindo com T => reação exotérmica => ΔH < 0
    @test van_t_hoff(2.0, 1.0, 300.0, 320.0) < 0
end

@testset "species mapping" begin
    # Espécie inexistente deve lançar erro
    eq = balance(ce"Xx + O2 = XxO2")
    @test_throws ErrorException reaction_enthalpy(eq)
end
