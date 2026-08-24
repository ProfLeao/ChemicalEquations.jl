# Catalyst integration tests. Requires Catalyst.jl to be loaded
# (guarded in runtests.jl via Base.find_package("Catalyst")).
using Catalyst

@testset "reaction_system" begin
    rs = reaction_system(balance(ce"2 H2 + O2 = 2 H2O"); name = :combustion)
    @test rs isa Catalyst.ReactionSystem
    # Deve haver exatamente 1 reação
    @test length(Catalyst.reactions(rs)) == 1
end

@testset "reaction_network" begin
    eqs = [balance(ce"H2 + Cl2 = HCl"), balance(ce"N2 + H2 = NH3")]
    rn = reaction_network(eqs; name = :chain)
    @test rn isa Catalyst.ReactionSystem
    @test length(Catalyst.reactions(rn)) == 2
end

@testset "ChemEquation(ReactionSystem)" begin
    rs = reaction_system(balance(ce"2 H2 + O2 = 2 H2O"); name = :combustion)
    eq = ChemEquation(rs)
    @test eq isa ChemEquation
    # Deve reconstruir os mesmos compostos
    @test Set(string(c) for c in compounds(eq)) == Set(["H2", "O2", "H2O"])
end
