# This script fits a hidden markov chain model to the crime data from the
# Vancouver Police Department
#
# Authors: Tim Jaschek, Cody Griffith, Ziming Yin

using JLD

#load data
include("crime_matrix.jl")
crime_matrix= convert(Array{Int64},crime_matrix)

#suffel and use just a subcollection (otherwise computation time would be too long)
crime_matrix = crime_matrix[shuffle(1:end), :,:]
crime_matrix_short=crime_matrix[1:50,:,:]

#set the hyper parameter k
k = 5

# fit HMC model
include("baumWelch.jl")
(Pi,A,B) = baumWelch(crime_matrix_short,k)

include("hmcSample.jl")
# Take a whole months full hours samples from the MC and the obs
(MC,obs) = sampleHMM(Pi,A,B,672)
obs = reshape(obs,28,24)


print("Pi is\n")
display(Pi)
print("Transition matrix A\n")
display(A)
print("Emission matrix B\n")
display(B)
print("Markov chain sample\n")
display(MC)
print("Observation sample\n")
display(obs)
print("Which sees ", sum(obs), " crime happening")
