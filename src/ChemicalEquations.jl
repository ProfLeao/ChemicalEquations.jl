"""
Write and balance chemical equations elegantly and efficiently.
"""
module ChemicalEquations

using LinearAlgebraX: I, nullspacex, IntegerX
using DocStringExtensions
using Requires
@template TYPES =
    """
    $TYPEDEF
    $TYPEDFIELDS
    $DOCSTRING
    """
@template (FUNCTIONS, METHODS) =
    """
    $TYPEDSIGNATURES
    $DOCSTRING
    """

export Compound, ChemEquation,
    @ce_str, @cc_str, ==, string, show,
    compounds, elements, hascharge,
    equationmatrix, balancematrix, balance, latex,
    RateLaw, GAS_CONSTANT, reaction_order, reactant_orders, rate,
    half_life, arrhenius, rate_constant

include("compound.jl")
include("chemequation.jl")
include("balance.jl")
include("latex.jl")
include("kinetics.jl")

"""
Loads optional functionality that depends on external packages.

- `Plots.jl`: enables [`plot_stoichiometry`](@ref).
- `Glenn.jl`: enables thermochemistry functions (`reaction_enthalpy`, …).
- `Catalyst.jl`: enables reaction-network conversion (`reaction_system`, …).
"""
function __init__()
    @require Plots="91a5bcdd-55d7-5caf-9e0b-520d859cae80" begin
        include("visualization.jl")
        export plot_stoichiometry
    end
    @require Glenn="d531567c-0c1c-43c6-9163-287e3bec9c15" begin
        include("thermo.jl")
        export reaction_enthalpy, reaction_entropy, gibbs_free_energy,
            equilibrium_constant, is_spontaneous, van_t_hoff
    end
    @require Catalyst="479239e8-5488-4da2-87a7-35f2df7eef83" begin
        include("catalyst.jl")
        export reaction_system, reaction_network
    end
end

end # module
