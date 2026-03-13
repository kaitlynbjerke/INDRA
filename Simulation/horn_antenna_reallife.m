%% Horn antenna simulation in MATLAB (Antenna Toolbox)
% Reference: MathWorks horn antennas doc page you linked
% Make sure Antenna Toolbox is installed.

clear; clc; close all;

%% 1) Create a pyramidal horn (built-in object)

% f0 = 20e6;
% lambda0 = physconst('LightSpeed')/f0;   % 15 m (not used for sizing here)

ant = horn;

% Total length limited to 0.5 m
ant.Length      = 0.10;   % straight section (m)
ant.FlareLength = 0.40;   % flare section (m)

% Aperture (mouth)
ant.FlareWidth  = 0.30;   % (m)
ant.FlareHeight = 0.30;   % (m)

% Throat (feed rectangle — NOT a real 20 MHz waveguide)
ant.Width       = 0.10;   % (m)
ant.Height      = 0.05;   % (m)

ant.FeedOffset  = [0 0];

%% 2) View geometry
figure;
show(ant);
title("Horn Antenna Geometry");
axis equal;

%% 3) Mesh it (important for accurate results)
% Rule of thumb: smaller MaxEdgeLength = more accurate but slower.
f0 = 1.5e9; % center frequency for meshing & analysis
lambda0 = physconst("LightSpeed")/f0;

figure;
mesh(ant, "MaxEdgeLength", lambda0/15);
title("Horn Antenna Mesh");

%% 4) S-parameters / impedance over frequency
f = linspace(0.75e9, 2.25e9, 201);  % your sweep band

Zin = impedance(ant, f);

figure;
plot(f/1e9, real(Zin), f/1e9, imag(Zin));
grid on;
xlabel("Frequency (GHz)");
ylabel("Impedance (Ohms)");
legend("Re\{Z_{in}\}", "Im\{Z_{in}\}", "Location","best");
title("Input Impedance vs Frequency");

% Reflection coefficient (assume 50 ohms)
Z0 = 50;
Gamma = (Zin - Z0)./(Zin + Z0);
S11_dB = 20*log10(abs(Gamma));

figure;
plot(f/1e9, S11_dB);
grid on;
xlabel("Frequency (GHz)");
ylabel("|S11| (dB)");
title("Return Loss (S11) vs Frequency");
yline(-10,"--");

%% 5) Radiation pattern at a single frequency
az = 0:2:360;
el = -90:1:90;

figure;
pattern(ant, f0, az, el);
title("Radiation Pattern (Az-El Cut) at 10 GHz");

%% 6) 3D pattern at a single frequency
figure;
pattern(ant, f0);
title("3D Radiation Pattern at 10 GHz");
