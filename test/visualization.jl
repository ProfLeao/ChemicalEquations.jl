using Plots

@testset "plot_stoichiometry" begin
    eq = balance(ce"H2 + O2 = H2O")
    p = plot_stoichiometry(eq)
    @test p isa Plots.Plot
    @test length(p.series_list) == 1  # one heatmap series

    # Charged species should produce a valid plot too
    eq2 = ce"Cr2O7{-2} + H{+} = Cr{+3} + H2O"
    p2 = plot_stoichiometry(eq2)
    @test p2 isa Plots.Plot
    @test length(p2.series_list) == 1
end
