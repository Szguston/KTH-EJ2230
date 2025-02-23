clear all;
close all;
clc;

p = 2; % Pole pairs
Rs = 2.97; % [Ohm] Stator resistance
Rr = 2.66; % [Ohm] Rotor resistance
Lphi = 0.343; % [H] Magnetising inductance
Lsigma = 0.029; % [H] Leakage inductance

Jr = 0.0055; % [Kg*m^2] Mechanical inertia
Br = 1e-3; % [N*m/s] Viscous friction

Jcc = [0, -1; 1, 0];

% Digital control parameters
Ts = 10e-6; % [s] Sample time
Tend = 2; % [s] Simulation time
tau_PWM = 1.5*Ts; % [s] PWM delay
pm_i = 60/180*pi; % [rad] Phase margin of the current regulation
alpha_BW_i = 1/tau_PWM*(pi/2-pm_i); % [rad/s] Bandwidth of the current regulation
Kpid = alpha_BW_i*Lsigma; % [V/A] % Proportional part of the current regulation on the d-axis
Kiid = alpha_BW_i*(Rs+Rr); % [V/(A*s) % Integral part of the current regulation on the d-axis
Kpiq = alpha_BW_i*Lsigma; % [V/A] % Proportional part of the current regulation on the q-axis
Kiiq = alpha_BW_i*(Rs+Rr); % [V/(A*s) % Integral part of the current regulation on the q-axis

pm_w = 70/180*pi; % [rad] Phase margin of the speed regulation
alpha_BW_w = alpha_BW_i*tan(pi/2-pm_w); % [rad/s] Bandwidth of the speed regulation
Kpw = Jr*alpha_BW_w*sqrt(1+alpha_BW_w^2/alpha_BW_i^2);
Kiw = Br*alpha_BW_w*sqrt(1+alpha_BW_w^2/alpha_BW_i^2);
% Kiw = Jm*alpha_BW_w*alpha_BW_w*sqrt(1+alpha_BW_w^2/alpha_BW_i^2);
% Ba = alpha_BW_w*Jm - Bm;

% Limitation
un = 400; % [V] Nominal voltage of the machine
taun = 9.95; % [N*m] Nominal torque of the machine
udc = 560; % [V] DC bus voltage
in = 3.2*sqrt(2); % [A] Nominal current
ulim = 2.34*230/sqrt(3); % [V] Voltage limit (inner circle within the SVM hexagon)
ulim_squared = ulim*ulim; % [V^2] Square of the voltage limit

% open('IM_model_20250221');