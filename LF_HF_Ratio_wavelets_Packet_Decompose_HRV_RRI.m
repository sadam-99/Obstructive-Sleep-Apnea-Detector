close all;
clear all;
[hdr, record] = edfread('a6.edf');
%le=input('Enter No. of samples ');
%tb=input('Enter sampling time');
le=120000;
%le=3000;
Fs=100;
tb=1/Fs;
time=tb:tb:le/Fs;
%main=cell2mat(raw(1:le,1));
figure(1);
plot(time,record);
xlabel('Time in seconds');
ylabel('Magnitude in volts.');
xlim([0 le/Fs]);
title('ECG signal')
grid;
max=[];              % Empty matrices
pos=[];
distance=[];    % Empty matrices
c=1;
%Thresh=1.07;
Thresh=input('Enter threshold point (check Graph)'); % Input the threshold value from the ecg signal
max(c)=record(c);
pos(c)=time(c);
for i=1:le-1             %% Adaptive thresholding technique
if record(i)>=Thresh
if max(c)< record(i)
max(c)=record(i);
pos(c)=time(i);
end
if (record(i+1)<=Thresh);
c=c+1;
max(c)=-1000;
pos(c)=-1000;
end
end
end
%d=le+1;
max(c)=0;
pos(c)=0;
c=c-1;
for i=1:c-1
distance(i)=pos(i+1)-pos(i);
end
RR_Interval=distance;                  % Stores the RR intervals
t0=1200/length(RR_Interval):1200/length(RR_Interval):1200;
figure();
plot(t0,RR_Interval);
title('RR Interval');
ylabel('RR intervak in sec');
xlabel('time in sec');

z= fft(RR_Interval);
RR_FFT = fftshift(z);            % FFT of RR intervals
magnitude_RR_FFT= abs(RR_FFT);
N = length(RR_FFT);
fs=N/1200;

f = fs/(N):fs/(N):fs;
figure();
subplot(2,1,1);
plot(f,abs(z));
xlim([0 fs]);
title('FFT of RR Interval');
ylabel('FFT');
xlabel('freq in Hz');
ylim([0 100]);
subplot(2,1,2);
plot(f,magnitude_RR_FFT);
xlim([0 fs]);
title('FFTshift  ofRR Interval');
ylabel('FFT shift');
xlabel('freq in Hz');
ylim([0 100]);

LF_Reconstruct=[];
magnitude_HF_FFT=[];
%LF_HF_Ratio=[];
 %%% Wavelet packet Decomposition
 y=RR_Interval;
 wname = 'db20'; lev = 5;
 tree = wpdec(y,lev,wname);  % wavelet packet tree
 plot(tree);
 det1 = wpcoef(tree,[1, 0]);
 sigma = median(abs(det1))/0.6745;
 alpha = 2;
 thr = wpbmpen(tree,sigma,alpha);%returns a global threshold THR for de-noising
 keepapp = 1;
 XD1 = wpdencmp(tree,'s','nobest',thr,keepapp); %Denoising of signal
 %% Well this denoising is just for analyzation it is not at all required for the LF/HF ratio
 %{
figure();
 plot(t0,XD1);                
 title('Denoised RR Interval');
 ylabel('Denoised RR Interval in sec');
 xlabel('time in sec');
 %}
 
 
 %% Reconstruction of the LF RR interval in time domain
 LF_lo = 0.04;
 LF_hi = 0.15;
 HF_lo = 0.15; 
 HF_hi = 0.4;
 fs=N/1200;
 LF1=wprcoef(tree,[5 3]);      
 LF2=wprcoef(tree,[4 4]);      %% Reconstruction of the nodes
 LF3=wprcoef(tree,[5 5]);
 LF4=wprcoef(tree,[5 6]);
 LF5=wprcoef(tree,[5 7]);
 LF6=wprcoef(tree,[5 8]);
 LF7=wprcoef(tree,[5 9]);
 LF_Reconstruct=abs(LF1)+abs(LF2)+abs(LF3)+abs(LF4)+abs(LF5)+abs(LF6)+abs(LF7);
 LF_Reconstructnew=LF1+LF2+LF3+LF4+LF5+LF6+LF7;
 
 figure();
 plot(t0,LF_Reconstruct);
 title('LF Reconstructed RR interval');
 ylabel('LF component Reconstructed');
 xlabel('time in sec');
 HF_Reconstruct=zeros(1,N,'double');
 %HF_Reconstruct=[];
 
  %% Reconstruction of the HF RR interval in time domain
 for q=10:25;
 HF1 = wprcoef(tree,[5 q]);
 
 HF_Reconstruct= abs(HF1) + HF_Reconstruct ;
 end
 figure();
 plot(t0,HF_Reconstruct);
 title('HF Reconstructed RR interval');
  ylabel('HF component Reconstructed');
  xlabel('time in sec');
 %{
  
 figure();
 spectrogram(LF_Reconstruct,[],[],[],fs,'yaxis');
 title('Frequency time plot of LF Reconstructed RR interval');
  %}
  %{
 figure();
 spectrogram(HF_Reconstruct,[],[],[],fs,'yaxis');
 title('Frequency time plot of HF Reconstructed RR interval');
 %}
 
%{ 
lf_FFT= fft(abs(LF_Reconstruct));
l= fftshift(lf_FFT);
fft_LF_Reconstruct= abs(lf_FFT);
figure();
%subplot(2,1,1);
plot(f,LF_Reconstruct);

xlim([0 fs/2]);
title('FFT of LF Reconstructed RR interval');
ylabel('FFT LF component Reconstructed');
xlabel('freq in Hz');
%ylim([0 10]);
%{

subplot(2,1,2);
plot(f,abs(l));
xlim([0 fs/2]);
title('FFTshift of LF Reconstructed RR interval');
ylabel('FFT shift LF component Reconstructed');
xlabel('freq in hz');
%ylim([0 100]);
%}

hf_FFT = fft(abs(HF_Reconstruct));
h= fftshift(hf_FFT);
magnitude_HF_FFT= abs(hf_FFT);
figure();
%subplot(2,1,1);
plot(f,magnitude_HF_FFT);

xlim([0 fs/2]);
title('FFT of HF Reconstructed RR interval');
ylabel('FFT HF component Reconstructed');
xlabel('freq in hz');
%}

%{
ylim([0 10]);
subplot(2,1,2);
plot(f,abs(h));
xlim([0 fs/2]);
title('FFTshift of LF Reconstructed RR interval');
ylabel('FFT shift HF component Reconstructed');
xlabel('freq in hz');
%ylim([0 100]);
%}
nwin = 63;
wind = kaiser(nwin,17);
nlap = nwin-10;
nfft = 256;
figure();
spectrogram(y,wind,nlap,nfft,fs,'yaxis');
title('frequency time plot')


N_LF = length(LF_Reconstruct);
fs=N_LF/1200;
%freq = fs/(2*N_LF):fs/(2*N_LF):fs/2;
%RR_interval=QRS_array_i;    

LF_RR_mean = mean(LF_Reconstruct);
normalized_LF_RR =(LF_Reconstruct-LF_RR_mean)./LF_RR_mean;
%nfft = 2^(nextpow2(length(normalizedRR)));

Pxx_LF = abs(fft(normalized_LF_RR)).^2/(fs*N_LF);
%psd=dspdata.psd(Pxx(1:length(Pxx)/2),'Fs',1/RR_mean)
%figure
%plot(psd)
PSD_LF=Pxx_LF(1:length(Pxx_LF));
%PSD=Pxx(1:32);

%%FFT Of HF_Reconstructed RR interval for PSD calculation of LF RR interval
    

lF_xdft = fft(LF_Reconstruct);
LF_xdft = lF_xdft(1:N_LF/2+1);
LF_psdx = (1/(fs*N_LF)) * abs(LF_xdft).^2;
LF_psdx(2:end-1) = 2*LF_psdx(2:end-1);
%freq = fs/(2*N_LF):fs/(2*N_LF):fs/2;
freq = 0:fs/(N_LF):fs/2;

figure();
plot(freq,LF_psdx);
title('PSD of LF Reconstructed Using FFT')
xlabel('Frequency (Hz)')
xlim([0 fs/2]);
ylabel('Power/Frequency (sec square/Hz)') 
ylim([0 0.1]);

figure();
plot(freq,10*log10(LF_psdx));
title('PSD of LF Reconstructed Using FFT in decibels')
xlabel('Frequency (Hz)');
xlim([0 fs/2]);
ylabel('Power/Frequency (dB/Hz)')

%%%%%FFT Of HF_Reconstructed RR interval for PSD calculation of LF RR interval
N_HF = length(HF_Reconstruct);
hF_xdft = fft(HF_Reconstruct);
HF_xdft = hF_xdft(1:N_HF/2+1);
HF_psdx = (1/(fs*N_HF)) * abs(HF_xdft).^2;
HF_psdx(2:end-1) = 2*HF_psdx(2:end-1);
%freq = fs/(2*N_HF):fs/(2*N_HF):fs/2;
freq = 0:fs/(N_HF):fs/2;

figure();
plot(freq,HF_psdx);
title('PSD of HF Reconstructed Using FFT ')
xlabel('Frequency (Hz)')
xlim([0 fs/2]);
ylabel('Power/Frequency (sec square/Hz)') 
ylim([0 0.1]);

figure();
plot(freq,10*log10(HF_psdx));
title('PSD of HF Reconstructed Using FFT in decibels')
xlabel('Frequency (Hz)');
xlim([0 fs/2]);
ylabel('Power/Frequency (dB/Hz)')
% [lfhf] =  calc_lfhf(Fx,Px);
% [lfhf] =  calc_lfhf(Fx,Px);
% Calculates a the LF/HF-ratio for a given (linear) PSD Px over 
% a given linear frequency range Fx
% Also:
% [lfhf lf hf] =  calc_lfhf(Fx,Px);



% bin size of the PSD so that we can calculate the LF and HF metrics
binsize=fs/(N);  %%frequency interval



%% Area Under the curves.

% calculate metrics area under the curves
LF   = binsize*abs(sum(LF_psdx));
HF   = binsize*abs(sum(HF_psdx));
LFHF_Ratio =LF/HF;  % the LF/HF ratio





%{
PSD = find_PSD(RR_Interval,fs);
freq = 0:fs/length(PSD):fs/2;
[lfhf_Ratio, lf, hf] =  calc_lfhf(freq,PSD);


[fn,pn]=uiputfile('*.xls','Give a Name');
fileID = fopen([pn,fn],'w');
fprintf(fileID,'%5f\t\n ',distance);
fclose(fileID);
%}





%{


for k=1:1:N;
LF_HF_R=LF_psdx(k)/HF_psdx(k);
LF_HF_Ratio=[LF_HF_Ratio,LF_HF_R];
end
%}


%figure();
%plot(t0,LF_HF_Ratio);
%title('LF HF Ratio of RR interval');
%ylabel('LF HF Ratio of RR interval');
%xlabel('time in sec');



%{
[fn,pn]=uiputfile('*.xls','Give a Name');
fileID = fopen([pn,fn],'w');
fprintf(fileID,'%5f\t\n ',distance);
fclose(fileID);
%}

%}
