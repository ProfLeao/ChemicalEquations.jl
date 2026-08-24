using ChemicalEquations
using Test

for str in ("compound", "chemequation", "balance", "latex")
    @testset "$str.jl" begin
        include("$str.jl")
    end
end

# Visualization tests only run when Plots.jl is available (optional dependency).
if Base.find_package("Plots") !== nothing
    @testset "visualization" begin
        include("visualization.jl")
    end
end
