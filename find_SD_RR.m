function SD_RR = find_SD_RR(QRS_array_i)
%%Derive standard deviation of RR intervals

RR_interval=[];
for j=1:length(QRS_array_i)-1
    RR_interval=[RR_interval QRS_array_i(j+1)-QRS_array_i(j)];    
end
SD_RR = std(RR_interval,1);