function RMSSD = find_RMSSD(QRS_array_i)

difference=[];
for j=1:length(QRS_array_i)-1
    difference =[QRS_array_i(j+1)-QRS_array_i(j)];
end
RMSSD = rms(difference);