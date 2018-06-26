# This requires Pi to be an initial distribution and A to be a stacked transition matrix kxpxd
function viterbi(Pi,A)
    # Generate sample from MC
    k = length(Pi) #Should be a vector of length k
    (~,p,d) = size(A)
    d = d+1
    backtrack = zeros(1,d)
    M = zeros(k,k)
    M[:,1] = Pi
    state = zeros(k,k-1)
    for i in 2:d
        for u in 1:p # later state
            comparematrix = zeros(1,k)
            for v in 1:k #previous state
                comparematrix[1,v] = A[v,u,i-1]'*M[v,i-1]
            end
            (M[u,i], state[u,i-1]) = findmax(comparematrix)
        end
    end
    (~,backtrack[1,d]) = findmax(M[:,d])
    #backtrack
    for j in 1:d-1
        previous = Int(backtrack[1,d-j+1])
        backtrack[1,d-j] = state[previous,d-j]
    end
    backtrack = convert(Array{Int64,2},backtrack)
    return backtrack
end

function sampleHMM(Pi,A,B,n)
    MC =zeros(Int64,1,n)
    obs = zeros(Int64,1,n)
    MC[1] = sampleDiscrete(Pi)
    obs[1] = sampleDiscrete(B[MC[1],:])
    for i in 2:n
        MC[i] = sampleDiscrete(A[MC[i-1],:])
        obs[i] = sampleDiscrete(B[MC[i],:])
    end
    # Return values of crimes
    obs = obs-1
    return (MC, obs)
end

function sampleDiscrete(Pi)
    #just to avoid rounding errors renormalize (this shouldn't really do something).
    Pi ./= sum(Pi)
    samp = minimum(find(cumsum(Pi[:]).> rand()))
    samp = convert(Int64,samp)
    return samp
end
