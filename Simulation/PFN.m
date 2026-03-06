% --------------- Characteristics of pulse
T = 0.6e-3;          % pulse length in seconds
ZLoad = 50;         % load impedance in ohms

% --------------- Marx-PFN setup
PFNStages = 6;      % number of stages in each PFN
MarxStages = 1;     % number of marx stages, basically just number of PFNs

% --------------- Calculated values
ZStage = ZLoad / MarxStages;

C0 = T / (2 * ZStage * PFNStages)   % C = T/(2ZN)
L = (ZStage * T) / (2 * PFNStages)  % L = ZT/2N
L0 = L/2;
LTerm = L0 * 1.3                    % +30% inductance helps to prevent overshoot

RCharge = 100e-9 / (C0 * PFNStages);
LIso = 100 * L;
