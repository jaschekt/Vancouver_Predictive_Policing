using JLD

include("HMC.jl")
include("baumWelch.jl")
# include("crime_matrix.jl")
include("box_data.jl")
include("hmcSample.jl")

data = load("alldata.jld","alldata")
# kick out day 29,30,31
data = data[data[:,4] .< 29, :]
# replace 0 am to 24 am
data[data[:,5] .== 0,5] = 24
# kick out March ang April in 2018
m4 = find( (data[:,2] .==2018 ) .& ( data[:,3] .==4))
data = data[setdiff(1:end, m4), :]
m3 = find( (data[:,2] .==2018 ) .& ( data[:,3] .==3))
data = data[setdiff(1:end, m3), :]

# Grid size
rows = 13
columns = 15
# Crime Type: 1-, 2-, 3-, 4-, 5-
for typeofcrime in 1:5
    crime_type = typeofcrime
    # Hyperparemeter: # of hidden clusters.
    k = 5
    # Number of hours want to sample into the future: 1 month = 28*24 = 672
    n = 672


    crime = Dict()
    predictcrime = Dict()

    for i in 1:rows
        for j in 1:columns
            crime[i*columns+j-columns] = Dict()
            predictcrime[i*cn+j-cn] = Dict()
            box_rw = i
            box_cn = j
            crime_matrix = box_data(data,rows,columns,i,j,crime_type)
            crime_matrix= convert(Array{Int64},crime_matrix)

# I made a mistake before, it turns out we do not need to specify thoes matrix when input is zeros
    #    if sum(sum(crime_matrix))==0
    #        crime[i*cn+j-cn][1] = exprand(k)
    #        crime[i*cn+j-cn][1] = crime[(i-1)*cn+j][1] ./sum(crime[i*cn+j-cn][1])
    #        crime[i*cn+j-cn][2] = rand(k,k)
    #        crime[i*cn+j-cn][2] = crime[(i-1)*cn+j][2] ./sum(crime[i*cn+j-cn][2],2)
    #        c = Int(maximum(crime_matrix))+1
    #        crime[(i-1)*cn+j][3] = ones(k,c)
    #    else
            # Store the models as Pi, A, B in crime
            (Pi,A,B) = baumWelch(crime_matrix,k)
            while ((sum(isnan.(Pi)) > 0 )| (sum(isnan.(A)) > 0 )|( sum(isnan.(B)) > 0))
                (Pi,A,B) = baumWelch(crime_matrix,k)
            end
            (crime[(i-1)*columns+j][1], crime[(i-1)*columns+j][2],crime[(i-1)*columns+j][3]) = (Pi,A,B)
            # Store the samples from model as MC, obs in predictcrime
            (MC,obs) = sampleHMM(Pi,A,B,n)
            obs = reshape(obs,28,24)
            (predictcrime[(i-1)*columns+j][1],predictcrime[(i-1)*columns+j][2]) =(MC,obs)

    #    end
        end
    end
    # Save all models and predictions
    save("crime_$(typeofcrime).jld","Crime_models",crime)
    save("crime_$(typeofcrime)predict.jld","March_Predictions",predictcrime)
end
