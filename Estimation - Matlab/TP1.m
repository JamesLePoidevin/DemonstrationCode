close all hidden

load('data_MC.mat')

%Question1
N = 10000; 
%A modifier, Plus la valeur de N est grand plus l'histogramme 
%resemble a une gaussien
X = randn ([N, 1]);
[counts , centers] = hist(X ,100);
bar(centers , counts/N/( centers (2)-centers (1)));

%Question2
sigma = 1; %variance (= ecart - type)
meanx = 0;
rangex = (min(X):0.1: max(X));
px = (1/( sqrt (2*pi)*sigma))*exp(-(rangex - meanx).*( rangex - meanx)/(2* sigma*sigma));
hold on
plot(rangex , px , 'r' )
hold off

%question3
Y = 10 + sqrt (2)*X;
mean_Y = mean2(Y)
variance = var(Y)
sigma = sqrt(variance)
gy = mean_Y + sigma*randn ([N, 1]);

%Question4
figure
[counts , centers] = hist(Y,100);
bar(centers , counts/N/( centers (2)-centers (1)));
rangey = (min(Y):0.1: max(Y));
py = (1/( sqrt (2*pi)*sigma))*exp(-(rangey - mean_Y).*( rangey -mean_Y)/(2* sigma*sigma));
hold on
plot(rangey , py , 'r' )
hold off

%Question5
N = 100000;
x11 = randn ([1, N]);
x12 = randn ([1, N]);
X1 = [x11; x12];

%Question6
plot(X1(1,:),X1(2,:), '.b' );

%Question7 %figure3
var21 = 2;
var22 = 0.2;
moy21 = 10;
moy22 = 2;

x21 = 10 + sqrt(var21)*randn ([1, N]);
x22 = 2 + sqrt(var22)*randn ([1, N]);
X2 = [x21; x22];
figure;
plot(X2(1,:),X2(2,:), '.b' );

%Question8
x31 = x11;
x321 = x12 + 1*x11;
x325 = x12 + 5*x11;
X31 = [x31; x321 ];
X35 = [x31; x325 ];

%Question9
figure;
plot(X31(1,:),X31 (2,:), '.b' );
figure;
plot(X35(1,:),X35 (2,:), '.b' );

%%
close all hidden

%question11
N = 10000;
K3 = 3;
X3 = randn ([K3 , N]);
Y3 = sum(X3);

K6 = 6;
X6 = randn ([K6 , N]);
Y6 = sum(X6);

%Question12
[counts , centers] = hist(Y3 ,100);
bar(centers , counts/N/( centers (2)-centers (1)));

%Question 13
sigma = sqrt(((1/N)*sum(Y3*Y3')))
meanx3 = 0;
rangey3 = (min(Y3):0.1: max(Y3));
py3 = (1/( sqrt (2*pi)*sigma))*exp(-(rangey3 - meanx3).*(rangey3 - meanx3)/(2* sigma*sigma));
hold on;
plot(rangey3 , py3 , 'r' )
hold off

%Question 14
X_chi2 =X3 .* X3;
z= sum ( X_chi2 );
[ counts , centers ] = hist (z ,100) ;
bar ( centers , counts /N/( centers (2) -centers (1) ));

%Question 15
hold on
range_z =( min(z) :0.1: max(z));
pz =( range_z .^(( K3 /2) -1) .* exp(- range_z /2) ) /(2^( K3 /2) * gamma (K3 /2));
plot ( range_z ,pz ,'r');

%Question 16
var_z = var (z)
mean_z = mean (z)





