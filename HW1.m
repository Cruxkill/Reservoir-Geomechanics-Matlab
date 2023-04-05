close all; clear all; clc
%%Carga de datos
barnett_data=load('barnettSh.dat');
GulfMexico_data=load('GulfMexico.dat');
%%Organizacion de los datos en dos registros
depth1=barnett_data(:,1);dens1=barnett_data(:,2);depth2=GulfMexico_data(:,1);dens2=GulfMexico_data(:,2);
%delimitacion de los datos
sample_size1=depth1(2)-depth1(1);
sample_size2=depth2(2)-depth2(1);
%construccion de set hasta profundidad 0 ya que la herramienta no comienza a medir alli
depth1c=0:sample_size1:min(depth1)-sample_size1;
depth2c=0:sample_size2:min(depth2)-sample_size2;
%asignación de la densidad conocida
for i=1:length(depth1c)
    dens1c(i)=1.9;
end
%en este caso hay dos capas conocidas
for i=1:length(depth2c)
    if depth2c(i)<=1000
        dens2c(i)=1.0;
    else
        dens2c(i)=1.8;
    end
end
%construccion de los vectores completados
depth1=[depth1c';depth1];
dens1=[dens1c';dens1];

depth2=[depth2c';depth2];
dens2=[dens2c';dens2];

limdens1=[min(dens1) max(dens1)];
limdens2=[min(dens2) max(dens2)];
%%Graficos
figure(1)
set(gcf,'units','normalized','position',[0 0 1 1],'name','Registros','NumberTitle','off');
%TRACK 1
ax1c='k';%Color eje 1
ax2c='r';%Color eje 2
ax3c='b';%Color eje 3
axespos=[0.04 0.025 0.20 0.90]; %Posici�n de los ejes, normalizada
ylimt=[min(depth1) max(depth1)];
%Crear los ejes:
Track1_1=axes('Units','normalized','XAxisLocation','top','Position',axespos,...
          'Color','w','YColor','k','XColor',ax1c,'Ydir','reverse',...
          'YLim',ylimt,'XLim',limdens1,'NextPlot','add');
grid on
xlabel(Track1_1,'Densidad[g/cm^3]');
ylabel(Track1_1,'Profundidad[ft]');
%Graficar curvas:
plot(Track1_1,dens1,depth1,ax1c);
axes(Track1_1)
interpreted_density1 = dens_interpret(depth1,dens1)
axespos2=[0.28 0.025 0.20 0.90];
Track2_1=axes('Units','normalized','XAxisLocation','top','Position',axespos2,...
          'Color','w','YColor','k','XColor',ax1c,'Ydir','reverse',...
          'YLim',ylimt,'XLim',limdens1,'NextPlot','add');
grid on
xlabel(Track2_1,'Densidad[g/cm^3]');
%Graficar curvas:
plot(Track2_1,interpreted_density1,depth1,ax1c);
axespos3=[0.52 0.025 0.20 0.90];%Posici�n de los ejes, normalizada
ylimt2=[min(depth2) max(depth2)];
%Crear los ejes:
Track3_1=axes('Units','normalized','XAxisLocation','top','Position',axespos3,...
          'Color','w','YColor','k','XColor',ax1c,'Ydir','reverse',...
          'YLim',ylimt2,'XLim',limdens2,'NextPlot','add');
grid on
xlabel(Track3_1,'Densidad[g/cm^3]');
%Graficar curvas:
plot(Track3_1,dens2,depth2,ax1c);
axes(Track3_1)
interpreted_density2 = dens_interpret(depth2,dens2)
axespos4=[0.76 0.025 0.20 0.90];%Posici�n de los ejes, normalizada
%Crear los ejes:
Track4_1=axes('Units','normalized','XAxisLocation','top','Position',axespos4,...
          'Color','w','YColor','k','XColor',ax1c,'Ydir','reverse',...
          'YLim',ylimt2,'XLim',limdens2,'NextPlot','add');
grid on
xlabel(Track4_1,'Densidad[g/cm^3]');
%Graficar curvas:
plot(Track4_1,interpreted_density2,depth2,ax1c);
%Overburden
figure(2)
set(gcf,'units','normalized','position',[0 0 1 1],'name','Carga litost�tica','NumberTitle','off');
%Barnett depth1,dens1,interpreted_density1
%GOM depth2,dens2,interpreted_density2
%g=9.8 m/s^2
%kg/m^3*m/s^2*m
for i=1:length(depth1)
    pp1(i)=((1*1000*9.80*depth1(i)*0.3048)+101325)*0.000145038;%pascales a psi
    if i==1
        OBC11(i)=(((dens1(i)*1000*9.8*(depth1(i))*0.3048)+101325)*0.000145038);%pascales a psi
        OB12(i)=((interpreted_density1(i)*1000*9.8*depth1(i)*0.3048)+101325)*0.000145038;
        OBCG1(i)=OBC11(i)/(depth1(i));
    else
        OBC11(i)=(((dens1(i)*1000*9.8*(depth1(i)-depth1(i-1))*0.3048))*0.000145038)+OBC11(i-1);%pascales a psi
        OB12(i)=((interpreted_density1(i)*1000*9.8*(depth1(i)-depth1(i-1))*0.3048))*0.000145038+OB12(i-1);
        OBCG1(i)=OBC11(i)/(depth1(i));
    end
end
for i=1:length(depth2)
    pp2(i)=((1*1000*9.80*depth2(i)*0.3048)+101325)*0.000145038;%pascales a psi
    if i==1
        OBC21(i)=(((dens2(i)*1000*9.8*(depth2(i))*0.3048)+101325)*0.000145038);%pascales a psi
        OB22(i)=((interpreted_density2(i)*1000*9.8*depth2(i)*0.3048)+101325)*0.000145038;
        OBCG2(i)=OBC21(i)/(depth2(i));
    else
        OBC21(i)=(((dens2(i)*1000*9.8*(depth2(i)-depth2(i-1))*0.3048))*0.000145038)+OBC21(i-1);%pascales a psi
        OB22(i)=((interpreted_density2(i)*1000*9.8*(depth2(i)-depth2(i-1))*0.3048))*0.000145038+OB22(i-1);
        OBCG2(i)=OBC21(i)/(depth2(i));
    end
end
OBC11lim=[min(OBC11) max(OBC11)];
OBCG1lim=[min(OBCG1) 1.5];
OBC21lim=[min(OBC21) max(OBC21)];
OBCG2lim=[min(OBCG2) 1.5];
axespos5=[0.04 0.040 0.20 0.90];
Track5_1=axes('Units','normalized','XAxisLocation','top','Position',axespos5,...
          'Color','w','YColor','k','XColor',ax1c,'Ydir','reverse',...
          'YLim',ylimt,'XLim',OBC11lim,'NextPlot','add');
grid on
xlabel(Track5_1,'Carga litost�tica[Psi]');
ylabel(Track5_1,'Profundidad[ft]');
%Graficar curvas:
plot(Track5_1,pp1,depth1,ax2c,OBC11,depth1,ax3c);
axespos6=[0.28 0.040 0.20 0.90];
Track6_1=axes('Units','normalized','XAxisLocation','top','Position',axespos6,...
          'Color','w','YColor','k','XColor',ax1c,'Ydir','reverse',...
          'YLim',ylimt,'XLim',OBC11lim,'NextPlot','add');
grid on
xlabel(Track6_1,'Carga litost�tica (bloques)[Psi]');
%Graficar curvas:
plot(Track6_1,OB12,depth1,ax1c);
axespos7=[0.52 0.040 0.20 0.90];
Track7_1=axes('Units','normalized','XAxisLocation','top','Position',axespos7,...
          'Color','w','YColor','k','XColor',ax1c,'Ydir','reverse',...
          'YLim',ylimt2,'XLim',OBC21lim,'NextPlot','add');
grid on
xlabel(Track7_1,'Carga litost�tica (continuo)[Psi]')
%Graficar curvas:
plot(Track7_1,pp2,depth2,ax2c,OBC21,depth2,ax3c);
axespos8=[0.76 0.040 0.20 0.90];
Track8_1=axes('Units','normalized','XAxisLocation','top','Position',axespos8,...
          'Color','w','YColor','k','XColor',ax1c,'Ydir','reverse',...
          'YLim',ylimt2,'XLim',OBC21lim,'NextPlot','add');
grid on
xlabel(Track8_1,'Carga litost�tica (bloques)[Psi]');
%Graficar curvas:
plot(Track8_1,OB22,depth2,ax1c);
figure(3)
set(gcf,'units','normalized','position',[0 0 1 1],'name','Gradiente de carga litost�tica','NumberTitle','off');
axespos9=[0.04 0.040 0.20 0.90];
Track9_1=axes('Units','normalized','XAxisLocation','top','Position',axespos9,...
          'Color','w','YColor','k','XColor',ax1c,'Ydir','reverse',...
          'YLim',ylimt,'XLim',OBCG1lim,'NextPlot','add');
grid on
xlabel(Track9_1,'Gradiente de carga litost�tica[Psi/ft]');
ylabel(Track9_1,'Profundidad[ft]');
%Graficar curvas:
plot(Track9_1,OBCG1,depth1,ax1c)
axespos10=[0.28 0.040 0.20 0.90];
Track10_1=axes('Units','normalized','XAxisLocation','top','Position',axespos10,...
          'Color','w','YColor','k','XColor',ax1c,'Ydir','reverse',...
          'YLim',ylimt2,'XLim',OBCG2lim,'NextPlot','add');
grid on
xlabel(Track10_1,'Gradiente de carga litost�tica[Psi/ft]');
%Graficar curvas:
plot(Track10_1,OBCG2,depth2,ax1c)

for i=1:length(depth1)
    DPHI1(i)=(dens1(i)-2.7)/(1-2.7);
    if DPHI1(i)<0
        DPHI1(i)=nan;
    end
    DPHI12(i)=(interpreted_density1(i)-2.7)/(1-2.7);
    if DPHI12(i)<0
        DPHI12(i)=nan;
    end
    TPHI1(i)=0.4*exp(-0.0002*(OBC11(i)-pp1(i)));
    if depth1(i)==5800
        DPHI15800=DPHI1(i)
    elseif depth1(i)==6100
        dens16100=dens1(i)
        pp16100=pp1(i)
        OBC116100=OBC11(i)
        OBCG16100=OBCG1(i)
    end
end
for i=1:length(depth2)
    DPHI2(i)=(dens2(i)-2.7)/(1-2.7);
    if DPHI2(i)<0
        DPHI2(i)=nan;
    end
    DPHI22(i)=(interpreted_density2(i)-2.7)/(1-2.7);
    if DPHI22(i)<0
        DPHI22(i)=nan;
    end
    TPHI2(i)=0.4*exp(-0.0002*(OBC21(i)-pp2(i)));
    if depth2(i)==5800
        DPHI25800=DPHI2(i)
    elseif depth2(i)==6100
        dens26100=dens2(i)
        pp26100=pp2(i)
        OBC216100=OBC21(i)
        OBCG26100=OBCG2(i)
    end
end

figure(4)
set(gcf,'units','normalized','position',[0 0 1 1],'name','Porosidad','NumberTitle','off');
axespos5=[0.04 0.040 0.20 0.90];
Track5_1=axes('Units','normalized','XAxisLocation','top','Position',axespos5,...
          'Color','w','YColor','k','XColor',ax1c,'Ydir','reverse',...
          'YLim',ylimt,'NextPlot','add');
grid on
xlabel(Track5_1,'Porosidad');
ylabel(Track5_1,'Profundidad[ft]');
%Graficar curvas:
plot(Track5_1,DPHI1,depth1,ax1c,TPHI1,depth1,ax2c);
axespos6=[0.28 0.040 0.20 0.90];
Track6_1=axes('Units','normalized','XAxisLocation','top','Position',axespos6,...
          'Color','w','YColor','k','XColor',ax1c,'Ydir','reverse',...
          'YLim',ylimt,'NextPlot','add');
grid on
xlabel(Track6_1,'Porosidad');
%Graficar curvas:
plot(Track6_1,DPHI12,depth1,ax1c);
axespos7=[0.52 0.040 0.20 0.90];
Track7_1=axes('Units','normalized','XAxisLocation','top','Position',axespos7,...
          'Color','w','YColor','k','XColor',ax1c,'Ydir','reverse',...
          'YLim',ylimt2,'NextPlot','add');
grid on
xlabel(Track7_1,'Porosidad')
%Graficar curvas:
plot(Track7_1,DPHI2,depth2,ax1c,TPHI2,depth2,ax2c);
axespos8=[0.76 0.040 0.20 0.90];
Track8_1=axes('Units','normalized','XAxisLocation','top','Position',axespos8,...
          'Color','w','YColor','k','XColor',ax1c,'Ydir','reverse',...
          'YLim',ylimt2,'NextPlot','add');
grid on
xlabel(Track8_1,'Porosidad');
%Graficar curvas:
plot(Track8_1,DPHI22,depth2,ax1c);
axes(Track7_1)
[porosity,onset]=ginput(1);
onset
lineonsx=[min(DPHI2);max(DPHI2)];
lineonsy=[onset;onset];
plot(lineonsx,lineonsy,ax3c)

for i=1:length(depth2)
    if depth2(i)<3515
        PPcrop(i)=nan;
        ppcrop(i)=nan;
    else
        PPcrop(i)=OBC21(i)-((log(0.4)-log(DPHI2(i)))/0.0002);
        ppcrop(i)=pp2(i);
    end
end
figure(5)
set(gcf,'units','normalized','position',[0 0 1 1],'name','Sobrepresi�n','NumberTitle','off');
axespos5=[0.04 0.040 0.20 0.90];
Track5_1=axes('Units','normalized','XAxisLocation','top','Position',axespos5,...
          'Color','w','YColor','k','XColor',ax1c,'Ydir','reverse',...
          'YLim',ylimt2,'NextPlot','add');
grid on
xlabel(Track5_1,'Presi�n de poros[Psi]');
ylabel(Track5_1,'Profundidad[ft]');
%Graficar curvas:
plot(Track5_1,PPcrop,depth2,ax1c,ppcrop,depth2,ax2c);
for i=1:length(depth2)
    OP(i)=PPcrop(i)-ppcrop(i);
    if depth2(i)==11000
        OP11000=OP(i)
    end
end
axespos6=[0.28 0.040 0.20 0.90];
Track6_1=axes('Units','normalized','XAxisLocation','top','Position',axespos6,...
          'Color','w','YColor','k','XColor',ax1c,'Ydir','reverse',...
          'YLim',ylimt2,'NextPlot','add');
grid on
xlabel(Track6_1,'Sobrepresi�n[Psi]');
%Graficar curvas:
plot(Track6_1,OP,depth2,ax1c);
for i=1:length(depth2)
    PPG(i)=PPcrop(i)/depth2(i);
    if depth2(i)==5700
        PPG5700=PPG(i)
    elseif depth2(i)==8000
        PPG8000=PPG(i)
    end
end
MDppg5700=PPG5700/0.052
MDsg5700=PPG5700/0.43
MDppg8000=PPG8000/0.052
MDsg8000=PPG8000/0.43

axespos7=[0.52 0.040 0.20 0.90];
Track7_1=axes('Units','normalized','XAxisLocation','top','Position',axespos7,...
          'Color','w','YColor','k','XColor',ax1c,'Ydir','reverse',...
          'YLim',ylimt2,'NextPlot','add');
grid on
xlabel(Track7_1,'Gradiente de presi�n de poros[Psi/ft]')
%Graficar curvas:
plot(Track7_1,PPG,depth2,ax1c);
