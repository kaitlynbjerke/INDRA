%% Horn antenna simulation in MATLAB (Antenna Toolbox)
clear; clc; close all;

%% 1) Create a pyramidal horn (built-in object)

% Design for 20 MHz
f0 = 20e6;
lambda0 = physconst('LightSpeed')/f0;   % 15 m

ant = horn;

% Flared section (horn)
ant.FlareLength = 4.0*lambda0;          % 60.0 m
ant.FlareWidth  = 2.25*lambda0;         % 33.75 m
ant.FlareHeight = 2.25*lambda0;         % 33.75 m

% Straight waveguide section (feed)
ant.Length      = 1.25*lambda0;         % 18.75 m

% Waveguide feed
ant.Width       = 7.50;                 % m
ant.Height      = 3.75;                 % m

ant.FeedOffset  = [0 0];

%% 2) View geometry
figure;
show(ant);
title("Horn Antenna Geometry");
axis equal;

%% 3) Mesh it
figure;
mesh(ant, "MaxEdgeLength", lambda0/15);
title("Horn Antenna Mesh");

%% 4) Impedance / S11 over frequency
f = linspace(10e6, 30e6, 201);

Zin = impedance(ant, f);

figure;
plot(f/1e6, real(Zin), f/1e6, imag(Zin));
grid on;
xlabel("Frequency (MHz)");
ylabel("Impedance (Ohms)");
legend("Re{Z_{in}}", "Im{Z_{in}}", "Location","best");
title("Input Impedance vs Frequency");

Z0 = 50;
Gamma = (Zin - Z0)./(Zin + Z0);
S11_dB = 20*log10(abs(Gamma));

figure;
plot(f/1e6, S11_dB);
grid on;
xlabel("Frequency (MHz)");
ylabel("|S11| (dB)");
title("Return Loss (S11) vs Frequency");
yline(-10,"--");

%% 5) Radiation pattern
az = 0:2:360;
el = -90:1:90;

figure;
pattern(ant, f0, az, el);
title("Radiation Pattern at 20 MHz");

%% 6) 3D pattern
figure;
pattern(ant, f0);
title("3D Radiation Pattern at 20 MHz");