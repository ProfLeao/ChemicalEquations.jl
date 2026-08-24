using ChemicalEquations
using Test

for str in ("compound", "chemequation", "balance", "latex", "kinetics")
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

# Thermochemistry tests only run when Glenn.jl is available (optional dependency).
if Base.find_package("Glenn") !== nothing
    @testset "thermo" begin
        include("thermo.jl")
    end
end

# Catalyst integration tests only run when Catalyst.jl is available.
if Base.find_package("Catalyst") !== nothing
    @testset "catalyst" begin
        include("catalyst.jl")
    end
end
