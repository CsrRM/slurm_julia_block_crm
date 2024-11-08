function pldos(ρ, Φrng, ωrng, Zs; kw...)
    pts = Iterators.product(Φrng, ωrng, Zs)
    LDOS = @showprogress pmap(pts) do pt
        Φ, ω, Z = pt
        ld = ρ(ω; ω, Φ, Z, kw...) 
        return ld
    end
    LDOSarray = reshape(LDOS, size(pts)...)
    LDOSarray = sum.(LDOSarray)
    return Dict([Z => LDOSarray[:, :, i] for (i, Z) in enumerate(Zs)])
end