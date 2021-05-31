%Valoración De Una Opción Call Europea Utilizando el Método de Diferencias finitas explicitas 
 
clc
clear all

T=8/12;%Tiempo de expiración
S0=120;%Condición inicial
K=135;%Precio de ejerecicio
r=0.0005;%Tasa de interés libre de riesgo
sigma=0.2081;%Volatilidad
SMax=2*S0;%Precio máximo 
ds=1/2;%Incremento en el precio
M=SMax/ds;%Número de subdivisiones del precio
dtp=(ds/(sigma*SMax))^2;%Incremento del tiempo de prueba
Np=T/dtp;%Número de subdivisiones del tiempo de prueba
N=ceil(Np);%Número de subdivisiones del tiempo
dt=T/N;%Incremento en el tiempo
S(1)=0;%Condición inicial vector de precios

for j=2:M+1
    S(j)=S(j-1)+ds;%Vector de precios
end

%S

MO=zeros(N+1,M+1);%Matriz inicial de opciones

MO(:,1)=K-S(1); %Frontera izquierda 
 
for j=1:M
    MO(N+1,j)= max(K-S(j),0);%Frontera inferior
end

MO(:,M+1)=0; %Frontera derecha

%Coeficientes de la ecuacion en Diferencias Finitas
 
for j=1:M+1
    a(j)=(dt/(1+r*dt))*((1/2)*sigma^2*(j-1)^2-(1/2)*r*(j-1));
    b(j)=(dt/(1+r*dt))*((1/dt)-sigma^2*(j-1)^2);
    c(j)=(dt/(1+r*dt))*((1/2)*sigma^2*(j-1)^2+(1/2)*r*(j-1));
    suma(j)=a(j)+b(j)+c(j);
end

%plot(a)

%Nodos internos de la malla de opciones

for i=N:-1:1
    for j=2:M
        MO(i,j)=a(j)*MO(i+1,j-1)+b(j)*MO(i+1,j)+c(j)*MO(i+1,j+1);
    end
end 

MO;

pos=S0/ds+1; %Posición de S0 en la primera fila
f=MO(1,pos)%Valor de la opción
surf(MO);%Superficie de opciones
%figure;
mesh(MO);%Superficie de opciones

 
 