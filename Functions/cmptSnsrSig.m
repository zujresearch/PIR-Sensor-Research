function SnsrOutput = cmptSnsrSig( Sensor, Phi_t, t )
%CMPTSNSRSIG computes the PIR sensor output to the heat flux input signal.
% Inputs:
%   Sensor - structure of the PIR sensor.
%   Phi_t  - input heat flux signal.
%   t      - time vector.

% Transfer function
K       = Sensor.K;        % gain of the PIR sensor
G       = Sensor.Gain;     % gain of the analogue conditioning circuit
NoisStd = Sensor.NoisStd;  % noise standard deviation of the sensor
f_thrml = Sensor.f_thrml;  % thermal lower frequency
f_elec  = Sensor.f_elec;   % electrical upper frequency

tau_th = 1/(2*pi*f_thrml); % thermal time constant
tau_e  = 1/(2*pi*f_elec);  % electrical time constant

% Poles of the transfer function
pole_1 = [tau_th 1];
pole_2 = [tau_e  1];

% Numerator
num = K * [tau_th 0];

% Denomerator
den = conv(pole_1, pole_2);

% Transfer function
Hs = tf(num, den);

% PIR sensor voltage
S_t = G*lsim(Hs, Phi_t.Mod, t);

% Noise
w_t = NoisStd * randn(size(S_t));

% PIR sensor
X_t = S_t + w_t;

% Output structure
SnsrOutput = struct('PureSig' , S_t, ...
                    'NoisySig', X_t  ...
                    );

end

