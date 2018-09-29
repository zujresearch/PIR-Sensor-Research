function Phi = cmptTrgtFlx( Target, Sensor)
% CMPTTRGTFLX Computes the approximate heat flux produced by a target and 
% received by the PIR sensor.
% Inputs:
%   Target - structure contains target parameters.
%   Sensor - structure contains sensor parameters.
%
% Output:
%   Phi - Scalar value representing the heat flux of the target.

%% Physical parameters
sigma = 5.67e-8;   % Stephan-Boltzman constant
K     = 274.15;    % Kelvin

%% Computation
T_trgt_K = Target.T+K; % (K) temprature of source
T_snsr_K = Sensor.T+K; % (K) temprature of sensor
A_snsr = Sensor.A;     % (m^2) sensor area
R = Target.R;          % (m) distance from sensor axis to target

% Approximate projected solid angle
Omega_hat = A_snsr/(4*R^2);

% Black Body Exitance
M_BB  = sigma*(T_trgt_K^4 - T_snsr_K^4);

% Black body radiance
Rdnc_BB = M_BB/pi;

% Approximate heat flux
Phi = Rdnc_BB * Omega_hat;
