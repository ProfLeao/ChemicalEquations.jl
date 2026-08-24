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
    equationmatrix, balancematrix, balance, latex

include("compound.jl")
include("chemequation.jl")
include("balance.jl")
include("latex.jl")

"""
Loads optional functionality that depends on external packages.

- `Plots.jl`: enables [`plot_stoichiometry`](@ref).
"""
function __init__()
    @require Plots="91a5bcdd-55d7-5caf-9e0b-520d859cae80" begin
        include("visualization.jl")
        export plot_stoichiometry
    end
end

end # module
