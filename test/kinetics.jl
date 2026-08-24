@testset "GAS_CONSTANT" begin
    @test GAS_CONSTANT ≈ 8.31446261815324
end

@testset "reaction_order" begin
    @test reaction_order(ce"H2 + O2 = H2O") == 2
    @test reaction_order(ce"2 NO + O2 = 2 NO2") == 3
    @test reaction_order(ce"2 H2 + O2 = 2 H2O") == 3
    @test reaction_order(ce"N2 + 3 H2 = 2 NH3") == 4
end

@testset "reactant_orders" begin
    orders = reactant_orders(ce"2 NO + O2 = 2 NO2")
    @test orders["NO"] == 2
    @test orders["O2"] == 1
    @test length(orders) == 2
end

@testset "rate (Dict)" begin
    eq = ce"H2 + O2 = H2O"
    @test rate(eq, Dict("H2" => 2.0, "O2" => 1.0); k = 0.05) ≈ 0.1
    @test rate(eq, Dict("H2" => 3.0, "O2" => 2.0); k = 0.1) ≈ 0.6
    # no concentration -> error
    @test_throws ErrorException rate(eq, Dict("H2" => 2.0); k = 0.05)
end

@testset "rate (pairs)" begin
    @test rate(ce"H2 + O2 = H2O", "H2" => 2.0, "O2" => 1.0; k = 0.05) ≈ 0.1
    eq = ce"2 NO + O2 = 2 NO2"
    @test rate(eq, "NO" => 1.0, "O2" => 1.0; k = 2.0) ≈ 2.0
end

@testset "RateLaw" begin
    eq = ce"H2 + O2 = H2O"
    law = RateLaw(0.05, eq)
    @test law.k == 0.05
    @test law.orders == Dict("H2" => 1, "O2" => 1)
    @test rate(law, Dict("H2" => 2.0, "O2" => 1.0)) ≈ 0.1
    @test_throws ErrorException rate(law, Dict("H2" => 2.0))
end

@testset "half_life" begin
    @test half_life(0.1, 1) ≈ log(2) / 0.1
    @test half_life(0.5, 2, initial = 2.0) ≈ 1.0
    @test half_life(0.25, 0, initial = 4.0) ≈ 8.0
    @test half_life(2.0, 3, initial = 1.0) ≈ 0.75
    @test_throws ErrorException half_life(0.0, 1)
    @test_throws ErrorException half_life(1.0, 5)
end

@testset "arrhenius / rate_constant" begin
    k1 = arrhenius(2.0e12, 50000.0, 298.15)
    @test k1 ≈ 3478.635937472466
    @test rate_constant(298.15; A = 2.0e12, Ea = 50000.0) ≈ k1
    # Higher temperature => larger k
    @test arrhenius(2.0e12, 50000.0, 500.0) > k1
end
