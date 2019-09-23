function [NN50_v2,PNN50_v2]= find_NN50_variant2(QRS_array_i, criterion_ms)

NN50_v2=0;
for i=1:length(QRS_array_i)-1
    difference=QRS_array_i(i+1)-QRS_array_i(i);
    if difference >(criterion_ms /1000)
        NN50_v2=NN50_v2+1;
    end
    
end
PNN50_v2=NN50_v2/length(QRS_array_i);