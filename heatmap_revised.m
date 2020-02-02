 function [ totalerror ] = heatmap_revised(T_B_input, T_L_input,range,confidence_interval)
% EXAMPLE USAGE: plot_heatmap(40,25,10,95);
 if nargin == 0 %use defaults
    T_B_input = 40;
    T_L_input = 25;
    range = 15;
    confidence_interval = 95;
end


%convert input T-guesses to kelvin
T_Bguess = T_B_input+273;
T_Lguess = T_L_input+273;
tolerance = (100-confidence_interval)/100; %percent

%measured spectral intensities for each filter    
B_target1 = 0.1354;
B_target2 = 0.074;
B_target3 = 0.1079;

%filter wavenumbers
filter1 = 833;
filter2 = 1176;
filter3 = 944.1;

%ambient temperatures at the time of each filter measurement
T_S1 = 21.6+273;
T_S2 = 21.6+273;
T_S3 = 21.6+273;

%coefficient values for each filter (hardcoded)
alpha1=0.011;
beta1=0.967;
gamma1=0.021;

alpha2=0.69;
beta2=0.15;
gamma2=0.03;

alpha3=0.211;
beta3=0.767;
gamma3=0.022;

%set up spacing vectors
n = 100; %number of samples to take in between range (granularity)
TLvector = linspace(T_Lguess-range,T_Lguess+range,n);
TBvector = linspace(T_Bguess-range,T_Bguess+range,n);

errorvector1=[];
errorvector2=[];
errorvector3=[];

for i = 1:n
    %loop over TB
    T_B = TBvector(i);
    for j = 1:n
        %loop over TL
        T_L = TLvector(j);
        result1 = alpha1*get_B(T_B,filter1) + beta1*get_B(T_L,filter1)+gamma1*get_B(T_S1,filter1);
        error1 = (result1 - B_target1)/B_target1;
        errorvector1(i,j) = error1;
        
        result2 = alpha2*get_B(T_B,filter2) + beta2*get_B(T_L,filter2)+gamma2*get_B(T_S2,filter2);
        error2 = (result2 - B_target2)/B_target2;
        errorvector2(i,j) = error2;
        
        result3 = alpha3*get_B(T_B,filter3) + beta3*get_B(T_L,filter3)+gamma3*get_B(T_S3,filter3);
        error3 = (result3 - B_target3)/B_target3;
        errorvector3(i,j) = error3;
        
        %index matrix, debug purposes only:
        %indexmatrix(i,j) = string(T_B-273)+", "+string(T_L-273);
    end
end

%quadrature of errors
totalerror = errorvector1.^2+errorvector2.^2+errorvector3.^2;
%heatmap formatting
clims = [min(min(totalerror)),(1+tolerance)*min(min(totalerror))];
testclims=[0.1456e-04,0.1531e-04];
imagesc(TBvector-273,TLvector-273,totalerror, clims)
xlabel("Hot Plate Temperature")
ylabel("CaF2 Layer Temperature")
grid on

[I,J] = find(totalerror == min(min(totalerror)));
min(min(totalerror));
%print best result to console
finalTB = TBvector(I)-273
finalTL = TLvector(J)-273
 end
