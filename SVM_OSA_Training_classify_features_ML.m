clear all;
close all;
A1 = xlsread('a1.xlsx');
A2 = xlsread('a2.xlsx');
A3 = xlsread('a3.xlsx');
A4 = xlsread('a4.xlsx');
A5 = xlsread('a5.xlsx');
A6 = xlsread('a6.xlsx');
A7 = xlsread('a7.xlsx');
A8 = xlsread('a8.xlsx');
A9 = xlsread('a9.xlsx');
A10 = xlsread('a10.xlsx');
N1 = xlsread('n1.xlsx');
N2 = xlsread('n2.xlsx');
N3 = xlsread('n3.xlsx');
N4 = xlsread('n4.xlsx');
N5 = xlsread('n5.xlsx');
N6 = xlsread('n6.xlsx');
N7 = xlsread('n7.xlsx');
N8 = xlsread('n8.xlsx');
N9 = xlsread('n9.xlsx');
N10 = xlsread('n10.xlsx');
A11 = xlsread('a11.xlsx');
A13 = xlsread('a13.xlsx');
A14 = xlsread('a14.xlsx');
A15 = xlsread('a15.xlsx');
A16 = xlsread('a16.xlsx');
A17 = xlsread('a17.xlsx');
A18 = xlsread('a18.xlsx');
A19 = xlsread('a19.xlsx');
A20 = xlsread('a20.xlsx');
Training=[A1;A2;A3;A4;A5;A6;A7;A8;A9;A10;N1;N2;N3;N4;N5;N6;N7;N8;N9;N10];

Group = zeros(1200,1);  % gives you a matrix of zeros with 1051 rows and 1 column
Group(1:600) = 1;       % set first 600 entries to +1(Apnea)
Group(601:end) = 0;    % set the rest to 0(Normal)
SVMStruct = svmtrain(Training,Group);
Sample=[A11;A13;A14;A15;A16;A17;A18;A19;A20];
Predict = svmclassify(SVMStruct,Sample,'Showplot',true);

Apnea_No=length(find(Predict==1));
disp('The no. of Apnea detected ');
disp(Apnea_No);
