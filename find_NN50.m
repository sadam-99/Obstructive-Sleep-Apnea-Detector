function NN50= find_NN50(QRS_array_i, criterion_ms,fs)

NN50=0;
for i=1:length(QRS_array_i)-2
    difference=QRS_array_i(i+2)-2*QRS_array_i(i+1)+QRS_array_i(i);
    if difference < -(criterion_ms /1000 * fs)
        NN50=NN50+1;
    end
end