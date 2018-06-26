using JLD

crime_type = 2
include("box_data2.jl")

data = load("alldata.jld","alldata")
# kick out day 29,30,31
data = data[data[:,4] .< 29, :]
# replace 0 am to 24 am
data[data[:,5] .== 0,5] = 24
# kick out March ang April in 2018
data = data[data[:,2] .==2018,:]
data = data[data[:,3] .==3,:]

crime_predict = load("crime_2predict.jld","March_Predictions")

# Grid size
rows = 13
columns = 15

prdct = zeros(rows,columns)

for i in 1:rows
    for j in 1:columns
        nmb = i*columns+j-columns
        box = crime_predict[nmb][2]
        prdct[i,j] = sum(sum(box))
    end
end

realdta = zeros(rows,columns)

for i in 1:rows
    for j in 1:columns
        box_rw = i
        box_cn = j
        crime_matrix = box_data2(data,rows,columns,i,j,crime_type)
        realdta[i,j] = sum(sum(sum(crime_matrix)))
    end
end
writecsv("prdct.csv",prdct)
writecsv("realdta.csv",realdta)

using PyPlot
figure()
pcolormesh(realdta)
colorbar()
figure()
pcolormesh(prdct)
colorbar()
