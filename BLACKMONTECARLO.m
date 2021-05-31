%%Valoración Usando Black Sholes
%% Condiciones iniciales
clc
clear all


%file1 = 'Open Excel File';
sheet = 2;
xlRange = 'A1:IS1';
SW = xlsread(file1,sheet,xlRange)

[M,N] = size(SW)

T= 8/12; %Tiempo de Expiración
r=0.0005; %Tasa de interés libre de riesgo
sigma=0.2081; % Volatilidad anualizada del activo
K=135; %Precio de Ejercicio
S0=119.94; %precio Spot o inicial
% 
% %% Codigo para estimar la call y put mediante Black & Sholes
R=(r+((sigma)^2)/2);

Y=log(S0/K);

d1=(1/(sigma*sqrt(T)))*(Y+R*T);
d2=d1-(sigma*sqrt(T));
N1=normcdf(d1);
N2=normcdf(d2);

Call=S0*N1-exp(-r*T)*K*N2

Put=K*(1-N2)*exp(-r*T)-S0*(1-N1)

Paridadcall=Call+K*exp(-r*T)
Paridadput=Put+S0

%% Codigo para estimar el valor medio de la call y la put con montecarlo


N = 168; %Numero de observaciones
dt = T/N; %frecuencia de ocurrencia de los datos
k = 10000; %Numero de trayectorias

for i=1:k
    B(i,1)=0; %Condicion inicial Movimiento Browniano
    SG(i,1)=S0;
for j=2:N+1
    B(i,j)=B(i,j-1)+sqrt(dt)*randn; %Simulacion MBE
    SG(i,j)=SG(1,1)*exp((r-0.5*sigma^2)*dt*(j-1)+sigma*B(i,j));%Simulacion MBG
end
end

figure

ZG=SG(:,N);
mg=mean(ZG);
SGP=mg*exp(-r*T);%Demostracion que los valores futuros de S convergen a S0



%Payoffs
for i=1:k
   SG(i)=SG(i,end);
   payoffc(i)=max(SG(i)-K,0);%payoff de la call para todas las trayectorias en el ultimo sub
   payoffp(i)=max(K-SG(i),0);%payoff de la put para todas las trayectorias en el ultimo sub
end

mc=mean(payoffc);%Calculo de la media de todos de los payoffs para la call
mp=mean(payoffp);%Calculo de la media de todos de los payoffs para la put



call=mc*exp(-r*T)%Valor de la prima call
put=mp*exp(-r*T)%Valor de la prima put
