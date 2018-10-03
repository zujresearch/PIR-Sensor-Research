%% PIR_Snsr_Trgt_Lcl.m
% This is a top-level file to simulate the localization of a target via a
% PIR sensor.

%% Clean up
clc
clearvars
close all
dbstop if error

%% Add function directory to path
addpath('./Functions')

%% Target parameters
% The sign of the velocity determines the direction of movement. 
% v > 0 is left to right movement.
% v < 0 is right to left movement.
Target = struct('T',   37, ...  % target's temprature (C)
                'v',   20, ...  % target's velocity (km/h)
                'R',   10, ...  % target's smallest distance from sensor
                'psi', 90  ...  % angle between target trajectory with sensor axis (degree)
                );
            
%% PIR sensor parameters
% Physical
Sensor = struct('T',       25    , ... % sensor's temprature (C)
                'A',       20e-6 , ... % sensor's area
                'K',       1000  , ... % sensor's gain
                'Gain',    10000 , ... % analogue crt gain
                'f_thrml', 20   , ... % thermal frequency (lower cut-off)
                'f_elec',  0.1    , ... % electrical frequency (upper cut-off)
                'NoisStd', 1e-4    ... % noise standard deviation
                );

% Frensel lens based on the IML0635 
LensType = 'IML0635';

%% Find the target tajectory throught the sensor FOVs
FOV = cmptLnsFOV(LensType); 

%% Compute peak target heat flux
% The flux is computed at the nearest point to the sensor
Phi_pk = cmptTrgtFlx(Target, Sensor);

%% Compute heat flux signal
% The heat flux signal at the sensor
[Phi_t, t, Traj] = cmptFlxSig(FOV, Phi_pk, Target);

%% Compute the sensor voltage signal
SnsrOutput = cmptSnsrSig(Sensor, Phi_t, t);

%% Plotting

close all

figure('rend','painters','pos',[220 50 900 600])

subplot(1,2,1)
% Main sensor axis
line([0,0],[Target.R,0],'LineStyle','--')
hold on, grid on

% FOVs
plotFOVs(FOV, Traj)

% Plot target's heat flux signature 
subplot(1,2,2)
plot(t, Phi_t.Mod)
hold on, grid on
plot(t, Phi_t.Unmod,'--r')
plot(t, -Phi_t.Unmod,'--r')

% figure
% yyaxis left
% plot(t,SnsrOutput.PureSig)
% grid on, hold on
% yyaxis right
% plot(t,SnsrOutput.NoisySig)

% Comments added to test GitHub!
