function PSD = find_PSD(QRS_array_i,fs)



RR_interval=QRS_array_i;    

RR_mean = mean(RR_interval);
normalizedRR =(RR_interval-RR_mean)./RR_mean;
nfft = 2^(nextpow2(length(normalizedRR)));

Pxx = abs(fft(normalizedRR,nfft)).^2/length(normalizedRR)/(1/RR_mean);
%psd=dspdata.psd(Pxx(1:length(Pxx)/2),'Fs',1/RR_mean)
%figure
%plot(psd)
PSD=Pxx(1:length(Pxx));
%PSD=Pxx(1:32);



N = length(RR_interval);
xdft = fft(RR_interval);
xdft = xdft(1:N/2+1);
psdx = (1/(fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = 0:fs/length(RR_interval):fs/2;

figure();
plot(freq,psdx);
title('Periodogram Using FFT')
xlabel('Frequency (Hz)')
ylabel('Power/Frequency (dB/Hz)') 
ylim([0 20]);

figure();
plot(freq,10*log10(psdx));
title('Periodogram Using FFT')
xlabel('Frequency (Hz)')
ylabel('Power/Frequency (dB/Hz)')

