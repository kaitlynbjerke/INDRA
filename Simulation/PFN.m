T = 200e-9; % pulse duration
Z = 50; % load impedance
N = 6; % number of stages

C0 = (Z * T) / (2 * N)
L0 = T / (2 * Z * N)