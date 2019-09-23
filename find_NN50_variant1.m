function [NN50_v1,PNN50_v1]= find_NN50_variant1(QRS_array_i, criterion_ms)

NN50_v1=0;
for i=1:length(QRS_array_i)-1
    difference=QRS_array_i(i)-QRS_array_i(i+1);
    if difference >(criterion_ms /1000)
        NN50_v1=NN50_v1+1;
    end
    
end
PNN50_v1=NN50_v1/length(QRS_array_i);