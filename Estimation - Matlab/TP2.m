load('data_MC.mat')

%Question5
moyB=0;
varB=0.4;

%Dirac

dir = zeros( length(h), 1);
dir(1,1) = 1;
Y=syst(dir,h,varB);
figure;
plot(Y);
title('Simulation de la sortie du syst�me')

legend('Y');
hestime=Y(1 :length(h));

%% R�ponse impulsionnelle estim�e(hestime) et originalev(h)

%Question 6
figure;
subplot 211;
plot(h);
hold on;
plot(hestime,'r');
title('R�ponse impulsionnelle estim�e(hestime) et originale(h)')
legend('h','hestime');
subplot 212;
stem(h);
hold on;
stem(hestime,'r');
title('R�ponse impulsionnelle estim�e(hestime) et originale(h)')
legend('h','hestime');
%Distance quadratique dQN=
dQN=(1/length(h))*norm(hestime-h)^2

%%
%Question 7 : R�alisation impulsionnelle pour 1000 r�alisations
Nr = 1000;
moyE = 0;
varE = 0;
for i = 1 : Nr
Y = syst(dir,h,varB);
hestime=Y(1 :length(h));
moyE = moyE + mean(hestime);
varE = varE + var(hestime);
end
moyE=moyE/Nr
varE=varE/Nr

%% Maximum de vraisemmblance
% Question 8
Y=syst(x,h,varB);
A=toeplitz(x,zeros(1,length(h)));
hmle=inv(A'*inv(varB)*A)*A'*inv(varB)*Y;

%%
%Question 9
figure;
subplot 211;
plot(h);
hold on;
plot(hmle,'r');
title('R�ponse impulsionnelle estim�e(hestime) et originale(h)')
legend('h','hestime');
subplot 212;
stem(h);
hold on;
stem(hmle,'r');
title('R�ponse impulsionnelle estim�e(hestime)) et originale(h)')
legend('h','hestime');
%Distance quadratique dQN=
dQN1=(1/length(h))*norm(hmle-h)^2

%%
% Question 10 : R�alisation impulsionnelle pour 1000 r�alisations
Nr = 1000;
moyE = 0;
varE = 0;
for i = 1 : Nr
Y = syst(x,h,varB);
A=toeplitz(x,zeros(1,length(h)));
hmle=inv(A'*inv(varB)*A)*A'*inv(varB)*Y;
moyE = moyE + mean(hmle);
varE = varE + var(hmle);
end
moyE1=moyE/Nr
varE1=varE/Nr

%% Question 11 : Donn�es aberrantes
Y=syst(x,h,varB);
Yab=Y;
for i=1:5
Yab(randi(length(Yab)))=50;
end
A=toeplitz(x,zeros(1,length(h)));
hab=inv(A'*inv(varB)*A)*A'*inv(varB)*Yab;
figure;
subplot 211;
plot(h);
hold on;
plot(hab,'r');
title('R�ponse impulsionnelle estim�e(hestime avec donnees ab) et originale(h)')
legend('h','hestimeab');
subplot 212;
stem(h);
hold on;
stem(hab,'r');
title('R�ponse impulsionnelle estim�e(hestime avec donnees ab)) et originale(h)')
legend('h','hestimeab');
%Distance quadratique dQN=
dQN2=(1/length(h))*norm(hab-h)^2


%% Question 12
Y = syst(x,h,varB);
A=toeplitz(x,zeros(1,length(h)));
hmle=inv(A'*inv(varB)*A)*A'*inv(varB)*Y;
convN=conv(hmle,x);
convA=conv(hab,x);
figure
subplot 211;
stem(Y-convN(1:length(x)));
title('Erreur sans les donn�es aberrantes');
subplot 212;
stem(Yab-convA(1:length(x)));
title('Erreur avec les donn�es aberrantes');

