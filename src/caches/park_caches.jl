@cache struct PaRK2p5Cache{uType,rateType,TabType} <: OrdinaryDiffEqMutableCache
  u::uType
  uprev::uType
  k::rateType
  tmp::uType
  fsalfirst::rateType
  tab::TabType
end

struct PaRK2p5ConstantCache{T,T2} <: OrdinaryDiffEqConstantCache
  α21::T
  α31::T
  α32::T
  α41::T
  α42::T
  α43::T
  α5_6::Array{T,2}
  β1::T
  β3::T
  β5::T
  β6::T
  c2::T2
  c3::T2
  c4::T2
  c5_6::Array{T2,1}

  function PaRK2p5ConstantCache(::Type{T}, ::Type{T2}) where {T,T2}
    α21 = T(1//3)
    α31 = T(4//25)
    α32 = T(6//25)
    α41 = T(1//4)
    α42 = T(-3)
    α43 = T(15//4)

    α5_6 = Array{T}(undef,(2,4))
    α5_6[1,1] = T(6//81)
    α5_6[1,2]= T(90//81)
    α5_6[1,3]= T(-50//81)
    α5_6[1,4]= T(8//81)
    α5_6[2,1]= T(6//75)
    α5_6[2,2]= T(36//75)
    α5_6[2,3]= T(10//75)
    α5_6[2,4]= T(8//75)

    β1 = T(23//192)
    β3 = T(125//192)
    β5 = T(-81//192)
    β6 = T(125//192)
    c2 = T2(1//3)
    c3 = T2(2//5)
    c4 = T2(1)
    c5_6 = Array{T2}(undef,2)
    c5_6[1] = T2(2//3)
    c5_6[2] = T2(4//5)
    new{T,T2}(α21, α31, α32, α41, α42, α43, α5_6, β1, β3, β5, β6, c2, c3, c4,
     c5_6)
  end
end

function alg_cache(alg::PaRK2p5,u,rate_prototype,uEltypeNoUnits,uBottomEltypeNoUnits,tTypeNoUnits,uprev,uprev2,f,t,dt,reltol,p,calck,::Type{Val{true}})
  tmp = similar(u)
  k = zero(rate_prototype)
  fsalfirst = zero(rate_prototype)
  tab = PaRK2p5ConstantCache(real(uBottomEltypeNoUnits), real(tTypeNoUnits))
  PaRK2p5Cache(u,uprev,k,tmp,fsalfirst,tab)
end

function alg_cache(alg::PaRK2p5,u,rate_prototype,uEltypeNoUnits,uBottomEltypeNoUnits,tTypeNoUnits,uprev,uprev2,f,t,dt,reltol,p,calck,::Type{Val{false}})
  PaRK2p5ConstantCache(real(uBottomEltypeNoUnits), real(tTypeNoUnits))
end
