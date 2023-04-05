function [interpreted_density] = dens_interpret(depth,dens)
    %convertir en funcion para reutilizar en la siguiente parte
    %parametros entrada: depth, dens
    %parametro salida: interpreted_density
    [densc1,depthc1]=ginput(4);%4 puntos de cambio de densidad de capas/formaciones
    for i=1:length(depth)
        if depth(i)<=depthc1(1)
            densfm1(i)=dens(i);densfm2(i)=nan;densfm3(i)=nan;densfm4(i)=nan;
            densfm5(i)=nan;
        elseif depth(i)<=depthc1(2)
            densfm2(i)=dens(i);densfm1(i)=nan;densfm3(i)=nan;densfm4(i)=nan;
            densfm5(i)=nan;
        elseif depth(i)<=depthc1(3)
            densfm3(i)=dens(i);densfm1(i)=nan;densfm2(i)=nan;densfm4(i)=nan;
            densfm5(i)=nan;
        elseif depth(i)<=depthc1(4)
            densfm4(i)=dens(i);densfm1(i)=nan;densfm2(i)=nan;densfm3(i)=nan;
            densfm5(i)=nan;
        elseif depth(i)>depthc1(4)
            densfm5(i)=dens(i);densfm1(i)=nan;densfm2(i)=nan;densfm3(i)=nan;
            densfm4(i)=nan;
        end
    end
    %Limpieza de los valores no numericos que se añadieron en las zonas que no correspondian a cada formacion
    densfm1(isnan(densfm1))=[];
    densfm2(isnan(densfm2))=[];
    densfm3(isnan(densfm3))=[];
    densfm4(isnan(densfm4))=[];
    densfm5(isnan(densfm5))=[];
    %Promedio de densidades para tomarlo como el valor de la capa
    densb1=mean(densfm1);
    densb2=mean(densfm2);
    densb3=mean(densfm3);
    densb4=mean(densfm4);
    densb5=mean(densfm5);

    for i=1:length(depth)
        if depth(i)<=depthc1(1)
            interpreted_density(i)=densb1;
        elseif depth(i)<=depthc1(2)
            interpreted_density(i)=densb2;
        elseif depth(i)<=depthc1(3)
            interpreted_density(i)=densb3;
        elseif depth(i)<=depthc1(4)
            interpreted_density(i)=densb4;
        elseif depth(i)>depthc1(4)
            interpreted_density(i)=densb5;
        end
    end
    interpreted_density=interpreted_density';
end