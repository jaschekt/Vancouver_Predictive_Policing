function box_data(data,rw,cn,box_rw,box_cn,crime_type)

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
    return crime_matrix

end
