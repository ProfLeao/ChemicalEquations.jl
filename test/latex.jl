@testset "latex(compound)" begin
    @test latex(Compound("H2O")) == "\\ce{H2O}"
    @test latex(Compound("O2")) == "\\ce{O2}"
    @test latex(Compound("H{+}")) == "\\ce{H+}"
    @test latex(Compound("OH{-}")) == "\\ce{OH-}"
    @test latex(Compound("Ca{2+}")) == "\\ce{Ca^{2+}}"
    @test latex(Compound("SO4{-2}")) == "\\ce{SO4^{2-}}"
    @test latex(Compound("Fe{3+}")) == "\\ce{Fe^{3+}}"
    @test latex(Compound("e")) == "\\ce{e-}"
    @test latex(Compound("CH3COOH")) == "\\ce{C2H4O2}"
    @test latex(Compound("H3O{+}")) == "\\ce{H3O+}"
end

@testset "latex(equation)" begin
    @test latex(ce"H2 + Cl2 = 2 HCl") == "\\ce{H2 + Cl2 -> 2 HCl}"
    @test latex(ce"H2 + O2 = H2O") == "\\ce{H2 + O2 -> H2O}"
    @test latex(balance(ce"CH4 + O2 = CO2 + H2O")) == "\\ce{CH4 + 2 O2 -> CO2 + 2 H2O}"
    @test latex(balance(ce"Fe + Cl2 = FeCl3")) == "\\ce{2 Fe + 3 Cl2 -> 2 FeCl3}"
    @test latex(balance(ce"Fe + Cl2 = FeCl3", fractions=true)) == "\\ce{Fe + 3//2 Cl2 -> FeCl3}"
    @test latex(ce"Cr2O7{-2} + H{+} = Cr{+3} + H2O") == "\\ce{Cr2O7^{2-} + H+ -> Cr^{3+} + H2O}"
    @test latex(ce"CuSO4 * 5H2O = CuSO4 + H2O") == "\\ce{CuSO9H10 -> CuSO4 + H2O}"
end

@testset "latex reverse arrow" begin
    @test latex(ChemEquation("CO2 + H2O = CH4 + O2")) == "\\ce{CO2 + H2O -> CH4 + O2}"
    @test latex(ChemEquation{Rational}("1//2 H2 + 1//2 Cl2 = HCl")) == "\\ce{1//2 H2 + 1//2 Cl2 -> HCl}"
end
