function [Phi_t, t, Traj] = cmptFlxSig( FOV, Phi_pk, Target )
% CMPTFLXSIG Computes the heat flux received by the PIR sensor, with the
% Frensel lens installed, in addition to the target's trajectory.
%
% PHI_T is a structure containing the heat flux signal having the
% following fields:
%   Phi_t.Mod - is the heat flux modulated by the sensor lens and elements.
%   Phi_t.Unmod - is the heat flux (unmodulated) received at the sensor.
%
% T is the time vector.
%
% TRAJ is a structure containing the length of the rays from the center of
% the sensor reaching the target's (straight) trajectory.
%   Traj.RightLwrRay is the RHS FOV lower ray length, at the left of the FOV
%   center axis.
%   Traj.RightUprRay - is the RHS FOV upper ray length, at the right of the FOV
%   center axis.
%   Traj.LeftLwrRay - is the LHS FOV lower ray length, at the left of the FOV
%   center axis.
%   Traj.LeftUprRay - is the LHS FOV upper ray length, at the right of the FOV
%   center axis.

R0   = Target.R;
psi0 = Target.psi * pi/180;
v    = abs(Target.v);

Traj = struct('RightLwrRay', num2cell( R0*sin(psi0)./sin(psi0+[FOV.RightLwrAng]) ) , ...
              'RightCntRay', num2cell( R0*sin(psi0)./sin(psi0+[FOV.RightCntAng]) ) , ...
              'RightUprRay', num2cell( R0*sin(psi0)./sin(psi0+[FOV.RightUprAng]) ) , ...
              'LeftLwrRay', num2cell( R0*sin(psi0)./sin(psi0+[FOV.LeftLwrAng]) ) , ...
              'LeftCntRay', num2cell( R0*sin(psi0)./sin(psi0+[FOV.LeftCntAng]) ) , ...
              'LeftUprRay', num2cell( R0*sin(psi0)./sin(psi0+[FOV.LeftUprAng]) )  ...
              );

% Angle of the left-most side of the trinagle containing the target's
% trajectory, left-most FOV side and the distance between the target and
% the main sensor axis (R(t)).
theta = pi - (psi0+ FOV(1).Varphi+2*FOV(1).Gamma+FOV(1).GammaDead);   

% Length of trajectory path
L = cmptDistPlr( Traj(1).RightUprRay, FOV(1).RightUprAng, ...
                 Traj(end).LeftLwrRay, FOV(end).LeftLwrAng  );

% Length of each segment of the trajectory in the corresponding FOV
LuR = cmptDistPlr( Traj(1).RightUprRay, FOV(1).RightUprAng, ...
                 [Traj.RightUprRay], [FOV.RightUprAng]  );
                    
LuL = cmptDistPlr( Traj(1).RightUprRay, FOV(1).RightUprAng, ...
                 [Traj.LeftUprRay], [FOV.LeftUprAng]  );

LcR = cmptDistPlr( Traj(1).RightUprRay, FOV(1).RightUprAng, ...
                 [Traj.RightCntRay], [FOV.RightCntAng]  );

LcL = cmptDistPlr( Traj(1).RightUprRay, FOV(1).RightUprAng, ...
                 [Traj.LeftCntRay], [FOV.LeftCntAng]  );

LlR = cmptDistPlr( Traj(1).RightUprRay, FOV(1).RightUprAng, ...
                 [Traj.RightLwrRay], [FOV.RightLwrAng]  );

LlL = cmptDistPlr( Traj(1).RightUprRay, FOV(1).RightUprAng, ...
                 [Traj.LeftLwrRay], [FOV.LeftLwrAng]  );
             
% Time spent by the target in each FOV
tuR= LuR/v;
tuL = LuL/v;
tlL = LlL/v;
tcR = LcR/v;
tcL = LcL/v;
tlR = LlR/v;

% Construct time vector
t_i = 0;   % initial time
t_f = L/v; % final time
t   = linspace(t_i, t_f);

% Squared distance between the target and  the main sensor axis (R(t))
% The sign of the velocity determines the direction of movement. 
% v > 0 is left to right movement.
% v < 0 is right to left movement.

if ( Target.v >= 0)
    R_t_2 = (v*(t-t_i)).^2 + (R0*sin(psi0)./sin(theta)).^2 ...
          -  2*(v*(t-t_i)) * R0*sin(psi0)./tan(theta);
else
    R_t_2 = (L - v*(t-t_i)).^2 + (R0*sin(psi0)./sin(theta)).^2 ...
          -  2*(L - v*(t-t_i)) * R0*sin(psi0)./tan(theta);
end

% Modulating time mask caused by the +ve and -ve sensor elements
t_mod = zeros(size(t));
  
for m = 1:length(tuR)  
    t_mod( (t>=tuR(m)) & (t<=tcR(m)) ) =  1; 
    t_mod( (t>=tcR(m)) & (t<=tlR(m)) ) = -1;
    t_mod( (t>=tuL(m)) & (t<=tcL(m)) ) =  1; 
    t_mod( (t>=tcL(m)) & (t<=tlL(m)) ) = -1;
end

% Modulated heat flux
Phi_t.Mod = Phi_pk./R_t_2 .* t_mod;

% Unmodulated heat flux
Phi_t.Unmod = Phi_pk./R_t_2;

end

