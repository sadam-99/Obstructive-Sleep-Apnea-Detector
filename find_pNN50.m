function pNN50= find_pNN50(QRS_array_i, criterion_ms,fs)

pNN50=0;
for i=1:length(QRS_array_i)-2
    difference=QRS_array_i(i+2)-2*QRS_array_i(i+1)+QRS_array_i(i);
    if difference >(criterion_ms /1000 * fs)
        pNN50=pNN50+1;
    end
end