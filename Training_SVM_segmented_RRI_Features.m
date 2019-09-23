close all;
clear all;
[hdr, origrecord] = edfread('a20.edf');
%le=input('Enter No. of samples ');
%tb=input('Enter sampling time');
le=120000;
tb=0.01;
fs=100;
time=0.01:tb:le/fs;
x = origrecord;                %  input signal
seg=60;% No of segments in one ecg signal.
oneseg_data=120000/seg;
C = num2cell(reshape(x,oneseg_data, seg), 1);

  
R= cell(seg,1); 
RR_mean=[];
RR_median=[];
RR_STD=[];
RR_SD_diff=[];
RR_NN50_v1=[];
RR_NN50_v2=[];
RR_PNN50_v1=[];
RR_PNN50_v2=[];
RR_RMSSD=[];
RR_IQR=[];
RR_MAD=[];
RR_PSD=[];
Features_seg=[];

max=[];              % Empty matrices
pos=[];
distance=[];    % Empty matrices
Rpeak_amp=[];
time_Rpeak=[];
c=1;
bl=input('Enter threshold point (check Graph)');

for p=1:1:seg;
    record= C{p};
    c=1;
    max(c)=record(c);
    pos(c)=time(c);
for i=1:oneseg_data-1;
    
    if record(i)>=bl
    if max(c)< record(i)
    max(c)=record(i);
    pos(c)=time(i);
    tp= i;
    amp=record(tp);
    tp= tp/100;
    time_Rpeak=[time_Rpeak,tp];
    Rpeak_amp=[Rpeak_amp,amp];
    end
    if (record(i+1)<=bl);
    c=c+1;
    max(c)=-1000;
    pos(c)=-1000;
    end
    end
    end
    %d=le+1;
    max(c)=0;
    pos(c)=0;
    c=c-1; % The number of RR Intervals
    for j=1:c-1
    distance(j)=pos(j+1)-pos(j);
    R{p}=[R{p},distance(j)];
    end
end


for r=1:1:seg;
     
     Avg_RR = mean(R{r});
     RR_mean=[RR_mean;Avg_RR];
     
     med_RR=median(R{r});
     RR_median=[RR_median;med_RR];
     
     STD_RR=std(R{r});
     RR_STD=[RR_STD;STD_RR];
     
     
     SD_RRdiff = find_SD_RR(R{r});
     RR_SD_diff =[RR_SD_diff;SD_RRdiff];
     
     [NN50_v1,PNN50_v1]= find_NN50_variant1( R{r}, 50);
     RR_NN50_v1=[RR_NN50_v1;NN50_v1];
     RR_PNN50_v1=[RR_PNN50_v1;PNN50_v1];
     
     [NN50_v2,PNN50_v2]= find_NN50_variant2( R{r}, 50);
     RR_NN50_v2=[RR_NN50_v2;NN50_v2];
     RR_PNN50_v2=[RR_PNN50_v2;PNN50_v2];
     
     RMSSD = find_RMSSD(R{r});
     RR_RMSSD =[RR_RMSSD;RMSSD];
     
     interQR_RR=iqr(R{r});
     RR_IQR=[RR_IQR;interQR_RR];
     
     MAD_RR=mad(R{r});
     RR_MAD =[RR_MAD;MAD_RR];
     
     
     %{
     
     PSD = find_PSD(R{r},100);
     RR_PSD=[RR_PSD, PSD];
     %}
     
   
     
end
Features_seg=[RR_mean,RR_median,RR_STD,RR_SD_diff,RR_NN50_v1,RR_PNN50_v1,RR_NN50_v2,RR_PNN50_v2,RR_RMSSD,RR_IQR,RR_MAD];
filename='a20.xlsx';
xlswrite(filename,Features_seg);
%{


[fn,pn]=uiputfile('*.xls','Give a Name');
fileID = fopen([pn,fn],'w');
fprintf(fileID,'%5f\t\n ',Features_seg);
fclose(fileID);

figure();
plot(RR_mean);
title('RR mean');
figure();
plot(RR_median);
title('RR median');
figure();
plot(RR_STD);
title('RR STD');
figure();
plot(RR_SD_diff);
title('RR SD diff');
figure();
plot(RR_NN50_v1);
title('RR NN50 v1');
figure();
plot(RR_NN50_v2);
title('RR NN50 v2');
figure();
plot(RR_PNN50_v1);
title('RR PNN50 v1');
figure();
plot(RR_PNN50_v2);
title('RR PNN50 v2');
figure();
plot(RR_RMSSD);
title('RR RMSSD');
figure();
plot(RR_IQR);
title('RR IQR');
figure();
plot(RR_MAD);
title('RR MAD');
%}



 
  