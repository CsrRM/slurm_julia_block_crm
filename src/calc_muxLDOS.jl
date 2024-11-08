function calc_muxLDOS(input)
    #Detail params of the finite μ(x) wire (left, L, wire)
    wireL = (; 
        R = 50, w = 0, d = 0,
        a0 = 5,
        μ = 0.00, α = 60, g = 0,
        Δ0 = 0.23, ξd = 70,
        #Parameters for μ(x)
        Vmax = -0.75, 
        Vshift = input, Lstep = 1000, ς = 100
    )
    #Detail params of the infinite μ(cst) wire (right, R, wire)
    wireR = (; 
        R = 50, w = 0, d = 0,
        a0 = 5,
        μ = 0.75 + wireL[end-2], α = 60, g = 0,
        Δ0 = 0.23, ξd = 70,
    )
    #Build both wires
    hSML, hSCL, paramsL = build_cyl(; wireL...)
    hSMR, hSCR, paramsR = build_cyl(; wireR...)

    #Build the Hamiltonian for the finite L wire
    hSCL_f = hSCL |> supercell(region = r -> 0 <= r[1] <= wireL[end-1])

    #End position of wireL
    rend = hSCL_f.h.lattice.unitcell.sites[end];

    #Green's functionof the infinite wireR
    gR = hSCR |> greenfunction(GS.Schur(boundary = 0))

    #Total Green's function, after attaching wireR's self-energy to the finite wireL Hamiltonian in rend (their coupling is the natural hopping)
    g = hSCL_f |> attach(gR; reverse = false, region = r -> r == rend) |> greenfunction()

    # Set calculation parameters
    Φrng = range(0.0, 2.5, length = 110)
    ωrng = range(-.26, 0, length = 111)         # WARNING: code for superconductor is only valid for NEGATIVE ω. However, all quantities must be symmetric in ω.
    Zs = 0                                     # Angular momentum modes included. These calculatiosn are independent and can be de-parallelized.    

    # Compute LDOS 
    LDOS_dict = pldos(ldos(g[cells = 0]), Φrng, ωrng, Zs)
    LDOS = Dict([Z => hcat(LDOS_dict[Z], reverse(LDOS_dict[Z], dims = 2)[:, 2:end]) for Z in keys(LDOS_dict)]) # Symmetrize LDOS
    
    # Save results
    filename = "data/mu($input).jld2"
    mkpath(dirname(filename))
    save(filename, Dict(
        "Φrng" => Φrng,
        "ωrng" => vcat(ωrng, -reverse(ωrng)[2:end]),
        "Zs" => Zs,
        "LDOS" => LDOS,
        "paramsL" => paramsL,
        "paramsR" => paramsR,
        ))
    return #LDOS_dict #, paramsL, paramsR
end
