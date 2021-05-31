%Test-Propiedades Distribucionales y Estimación-Validación

%% Montar el Excel y darle valor a la variable
clc
clear all

file1 = "C:\Users\USER-PC\Desktop\2021-1\Procesos Estocasticos\Trabajo Final\Parcial3.xlsx";
sheet = 2;
xlRange = 'A1:IS1';
X = xlsread(file1,sheet,xlRange);
dt=1/252;
[M,N] = size(X);

figure
plot(0:1:N-1,X) %Gráfica del activo


%Descripción estadística del activo
EstadX=[min(X) max(X) mean(X) median(X) mode(X) var(X) std(X) kurtosis(X) skewness(X)];
% 
% histogram(X)%Histograma de frecuencias para el activo
figure
parcorr(X)% Función de autocorrelación parcial

% 
% 
for j=1:N-1
    R(j)=(X(j+1)-X(j))/X(j);%Retornos instantáneos
end
% 
figure
plot(0:1:N-2,R)%%Gráfica de los retornos instantáneos del activo
 
% %Descripción estadística del activo
% 
EstadX=[min(R) max(R) mean(R) median(R) mode(R) var(R) std(R) kurtosis(R) skewness(R)];
% figure
% histogram(R) %Histograma de los retornos
% figure
% histfit(R)%Histograma de los retornos con una densidad normal de comparación
figure
parcorr(R)%Función de autocorrelación parcial
% figure
%  
% % Pruebas de normalidad
% 
m=mean(R);%Media muestral de los retornos
des=std(R);%Desviación estándar de los retornos 
Z=(R-m)/des;%Retornos normalizados para la prueba kstest
 
PNor=[jbtest(R) kstest(Z) adtest(R) lillietest(R)];
% 
% 
% %Prueba varianza constante
% 
for j=1:N-1
    R2(j)=R(j)^2;%Retornos instantáneos al cuadrado
end
% 
figure
plot(0:1:N-2,R2)
axis([0 N -0.1 0.1])%Calibración de los ejes
% 
% 
for j=1:N-1
    VR(j)=var(R(1:j));%Varianza dinámica (comienza con el primer dato y termina con todos los datos de la muestra)
    VE(j)=std(R(1:j)/sqrt(dt));%Volatilidad dinámica (comienza con el primer dato y termina con todos los datos de la muestra)
end

figure
plot(0:1:N-2,VR) 
axis([0 N -0.01 0.01])
figure
plot(0:1:N-2,VE)

%  
VE(end);% Valor estimado de la volatilidad constante
% 

%Dimensión Fractal y Exponente de Hurst
% 
DF=fractalvol(X);%Cálculo de la dimensión Fractal (el script debe estar en esta misma carpeta)
EH=genhurst(X);%Cálculo del Exponente de Hurst (el script debe estar en esta misma carpeta)
S=DF+EH;
% 
% %Estimación y validación
%__________________________

%Estimación

muE=mean(R)/dt;%Estimación sencilla del parámetro mu
sigmaE=std(R)/sqrt(dt)%Estimación sencilla del parámetro sigma (volatilidad)