clc
close all
clear all

load('MatrizEof5.mat')

video = VideoWriter('EOF5_animacao4.mp5','MPEG-4');
video.FrameRate = 2;   % velocidade do filme
open(video);
t0 = datetime(2011,8,1,0,0,0);   % 01/08/2011 00:00


for i=1:length(C_all)

z_global = [];


[X,Y,Zc] = C2xyz_matrix(C_all{i});

z_global = [z_global; Zc(:)];

zmin = min(z_global);
zmax = max(z_global);

fig=figure(1)
hold on


    for k = 1:length(Zc)

        xk = X(:,k);
        yk = Y(:,k);

        mask = ~isnan(xk);
        xk = xk(mask);
        yk = yk(mask);

        %zk = Zc(k) * ones(size(xk));

        % ? NORMALIZAÇÃO
        z_norm = (Zc(k) - zmin) / (zmax - zmin);

         patch(xk, yk, z_norm, ...
          'EdgeColor','none');


        
    end

colormap(jet)
colorbar
axis equal
view(2)

colorbar;
    
     % ---- ESCALA PADRONIZADA ----
    %cmax = max(abs(eof_all));
    caxis([-1 1]);

 hold on
 
  scatter(lon, lat, 30, 'k', 'filled');

hold on

   brasil = shaperead('BR_UF_2019.shp','UseGeoCoords',true);
             for k = 1:length(brasil)
                    plot(brasil(k).Lon, brasil(k).Lat, ...
                        'k', 'LineWidth', 1.5);
             end


        tempo_atual = t0 + 6*hours(i-1);
        title(sprintf('EOF modo 1 | %s', datestr(tempo_atual,'dd/mm/yyyy HH:MM')));
        
        drawnow;                     % força o desenho
        frame = getframe(gcf);       % captura a figura
        writeVideo(video, frame);    % grava no vídeo
        
        close(fig);

end

close(video);