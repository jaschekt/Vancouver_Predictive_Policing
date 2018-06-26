function baumWelch(X::Array{Int64,3},k::Int64)
    # INPUT:
    # X is a data matrix of the form (samples)x(days)x(hours)=n x d x h
    # k is size of state space of hidden chain

    #get dimensions and reshape X
    (n,d,h) = size(X)
    T = d*h
    X = reshape(X,n,T)
    c = Int(maximum(X))+1
    #make the hole thing a vector
    X = reshape(X,1,n*T)
    
    #shift
    X = X.+1

    #set initial parameters at random (exponential rv)
    Pi = randexp(k,1)[:]
    Pi = Pi./sum(Pi)
    A =  rand(k,k)
    A = A./sum(A,2)
    B =  randexp(k,c)
    B = B./sum(B,2)
    
    ##we don't need the following loop. that was from before. We will keep it just in case

    for i=1:1
        #foreward step
        (alpha,scaling) = foreward(Pi,A,B,X[i,:])
        #backward step
        beta = backward(Pi,A,B,X[i,:],scaling)
        #update
        (Pi,A,B) = update(alpha,beta,Pi,A,B,X[i,:])
    end
    return Pi,A,B
end

function foreward(Pi::Array{Float64,1},A::Array{Float64,2},B::Array{Float64,2},O::Array{Int64,1})
    # INPUT:
    # Pi - k x 1 initial distribution
    # A  - k x k transitions hidden MC
    # B  - k x c transitions from MC to observables
    # O  - 1 x T observation
    # get dimensions
    (k,c) = size(B)
    T = length(O)
    # initialize alpha
    alpha = zeros(k,T)
    alpha[:,1] = Pi.*B[:,Int(O[1])]
    #scaling
    scaling = (Float64)[] # scaling coefficients
    push!(scaling,1./sum(alpha[:,1]))
    alpha[1,:] *= scaling[end] 
    # foreward procedure
    for t=2:T
        alpha[:,t] = B[:,Int(O[T])].*(A'*alpha[:,t-1])
        push!(scaling,1./sum(alpha[:,t]))
        alpha[:,t] *= scaling[end]
    end
    return alpha,scaling
end

function backward(Pi::Array{Float64,1},A::Array{Float64,2},B::Array{Float64,2},O::Array{Int64,1},scaling)
    # INPUT:
    # Pi - k x 1 initial distribution
    # A  - k x k transitions hidden MC
    # B  - k x c transitions from MC to observables
    # O  - 1 x T observation
    # get dimensions
    (k,c) = size(B)
    T = length(O)
    #initialize beta
    beta = zeros(k,T)
    beta[:,T]=scaling[T]
    #backwards procedure
    for i=2:T
        t=1+T-i
        km = (beta[:,t+1].*B[:,Int(O[t+1])])
        beta[:,t] = A*km*scaling[t]
    end
    return beta
end

function update(alpha::Array{Float64,2},beta::Array{Float64,2},Pi::Array{Float64,1},A::Array{Float64,2},B::Array{Float64,2},O::Array{Int64,1})
    # INPUT:
    # alpha - k x T
    # beta  - k x T
    # O     - 1 x T
    # get dimensions
    (k,T) = size(alpha)
    c = size(B,2)
    # initialize dummies
    gamma = zeros(k,T)
    xi = zeros(k,k,T-1)
    # compute dummies
    gamma = alpha.*beta
    gamma ./= sum(gamma,1)
    for t = 1:(T-1)
        for i = 1:k
            for j = 1:k
                xi[i,j,t] = alpha[i,t]*A[i,j]*beta[j,t+1]*B[j,Int(O[t+1])]
            end
        end
        xi[:,:,t] ./= sum(xi[:,:,t])
    end
    # actual update part
    Pi_new = zeros(k,1)
    A_new = zeros(k,k)
    B_new = zeros(k,c)
    Pi_new = gamma[:,1]
    A_new = sum(xi,3)[:,:,1]./sum(gamma,2)
    for j=1:c
        for t=1:(T-1)
            B_new[:,j] = B_new[:,j]+(Int(O[t])==j).*gamma[:,t]
        end
        B_new[:,j] = B_new[:,j]./sum(gamma,2)
        
        # Normalize
        Pi_new = Pi_new./sum(Pi)
        A_new = A_new./sum(A_new,2)
        B_new = B_new./sum(B_new,2)
    end
    return Pi_new,A_new,B_new
end
