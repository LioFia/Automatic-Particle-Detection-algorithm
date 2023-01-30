%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% -------------------- Resuspension Algorithm --------------------- %%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; 
clc; 
close all;
ecrit = {'interpreter','latex','fontsize',20}; % name, value pairs
movRMS = dsp.MovingRMS(100);

file_bckg = 'Z:\Expe\RES\V_10.0\a_1.0\22_02_02\fond.6vqg0z3r.000001.bmp';
file_RES.folder = 'E:\Corentin\RES\V_9.0\a_2.1\mes_05';
file_RES.name   = '02_01.6vp7up2u.00*.bmp';

% Parameters for the image processing algorithm
para.step = 50;                 % step between images     
para.granu = 'Y';               % compute the granulometry
para.size = 'Y';                % consider only some particles regarding their size
para.sz = 10;	% size of particle to consider

% Run
[t, Num, cluster, deposit] = ParticleCount(file_RES, file_bckg, para);

figure()
plot(t, Num, 'o')
grid on

