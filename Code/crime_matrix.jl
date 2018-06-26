
using JLD

# map are partitioned into rw rows and cn columns boxes
## input
rw = 13
cn = 15

data = load("alldata.jld","alldata")

# kick out day 29,30,31
data = data[data[:,4] .< 29, :]
# replace 0 am to 24 am
data[data[:,5] .== 0,5] = 24
# kick out March ang April in 2018
m4 = find( (data[:,2] .==2018 ) & ( data[:,3] .==4))
data = data[setdiff(1:end, m4), :]
m3 = find( (data[:,2] .==2018 ) & ( data[:,3] .==3))
data = data[setdiff(1:end, m3), :]



max_x = maximum(data[:,6])
min_x = minimum(data[:,6])
max_y = maximum(data[:,7])
min_y = minimum(data[:,7])

# box size
long = (max_x - min_x)/cn
wide = (max_y - min_y)/rw

# from Jan 2003 to March 2018
# choose a box, choose a type of crime.
# output matrix is 28(day) x 24(hour) x 183(total months over these years)

## input
box_rw = 6
box_cn = 6
crime_type = 2


box_l =  (box_cn-1) * long + min_x
box_r =  box_cn*long + min_x
box_t =  max_y - (box_rw-1) * wide
box_b =  max_y - box_rw * wide

s1 = data[data[:,1] .== crime_type, :]
s1 = s1[ s1[:,6].> box_l ,:]
s1 = s1[ s1[:,6].< box_r ,:]
s1 = s1[ s1[:,7].> box_b ,:]
s1 = s1[ s1[:,7].< box_t ,:]
crime_data = s1
(m,n) = size(crime_data)

crime_matrix = zeros(182,28,24)
for i in 1:m
    y = Int(crime_data[i,2]-2003)
    m = Int(crime_data[i,3])
    d = Int(crime_data[i,4])
    h = Int(crime_data[i,5])
    z = y*12+m
    crime_matrix[z,d,h] = crime_matrix[z,d,h]+1
end
