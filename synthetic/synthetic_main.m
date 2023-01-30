%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% ----------------------- Synthetic Image ------------------------- %%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   10/11/2021
%   corentincazes
%
% Validation of the algorithm : creation of a synthetic image with known
% parameters, processed it into the algorithm and comparision with the
% returning parameters.
%
clear; clc; close all;
ecrit = {'interpreter','latex','fontsize',20}; % name, value pairs

M = 10;
N = 250;
mu = 25;
sigma = [3 5];
bckg = zeros(1728, 2320, 'uint8');
[yp_true, yp_algo, yc_true, yc_algo, nb, conv, conv_std] = synth_comp(M, N, mu, sigma, 1, bckg);
ypt = mean(yp_true,2); ypa = mean(yp_algo,2); 
yct = mean(yc_true,2); yca = mean(yc_algo,2);
BC = sum(sqrt(mean(yp_true,2).*mean(yp_algo,2)));
DB = -log(BC)*100;

figure()
axes('FontSize', 15);
hold on
plot(0:50, ypa, 'bs--', 'MarkerFaceColor', 'b')
plot(0:50, ypt, 'ro-', 'MarkerFaceColor', 'r')
grid on
xlabel('Particle diameter $d_p$ [$\mu$m]', ecrit{:})
ylabel('Particle size distribution', ecrit{:})
legend('Initial distribution', 'Results distribution', 'Location', 'best',...
    'Interpreter', 'latex', 'FontSize', 15)
text(5, 0.1, ['$D_B=$',num2str(DB,'%4.2f'),'$\%$'],...
    'Interpreter', 'latex', 'FontSize', 16)
hold off

figure()
axes('FontSize', 15);
hold on
plot(1:1000, conv*100, 'LineWidth', 2)
plot(1:1000, conv_std*100, 'LineWidth', 2)
set(gca, 'Xscale', 'log')
grid on
xlabel('Image number', ecrit{:})
ylabel('Relative difference $N_\epsilon$ [\%]', ecrit{:})
legend('Mean', 'Variance', 'Location', 'best', 'Interpreter', 'latex',...
    'FontSize', 15)
hold off

xx = 220:260;
pd = fitdist(nb, 'Normal');
yy = pdf(pd, xx);

figure()
axes('FontSize', 15);
hold on
plot(xx, yy, 'bs-', 'Color', 'b')
grid on
xline(N, 'k--', 'LineWidth', 2.5)
xline(pd.mu, 'r-.', 'LineWidth', 2.5)
xlabel('Particle number', ecrit{:})
ylabel('PDF', ecrit{:})
hold off

    
