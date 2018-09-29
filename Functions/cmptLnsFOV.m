function FOV = cmptLnsFOV(LensType)
%CMPTLNSFOV Provides the field of views (FOVs) of the Frensel lens that are
% installed on a PIR sensor.
% INPUTS:
% LENSTYPE is a string with the name of the Frensel lens type.
% R0 is the right angle distnace between the sensor center and the target.
% psi0 is the angle between the main sensor axis and the target's
% trajectory.
%
% OUTPUTS:
% FOV is a structure array containing the polar angles and ray lengths of eac FOV
% in the Frensel lens. The FOVs are grouped into pairs each having a right
% side and a left side.
% The fields are:
%   FOV.RightLwrAng is the RHS FOV lower angle, at the left of the FOV
%   center axis.
%   FOV.RightCntAng is the RHS center axis.
%   FOV.RightUprAng is the RHS FOV upper angle, at the right of the FOV
%   center axis.
%   FOV.LeftLwrAng is the LHS FOV lower angle, at the left of the FOV
%   center axis.
%   FOV.LeftCntAng is the LHS center axis.
%   FOV.LeftUprAng is the LHS FOV upper angle, at the right of the FOV
%   center axis.

switch ( upper(LensType) )
    
    % Frensel lens based on the Murata IML-0635 
    case 'IML0635'
        % FOV index
        nFOV = [-1 0 1]; % three indetical FOVs 
        
        % Half FOV angle (radian)
        gamma  = 0.5*(atan(4/5) - atan(3/5));
        
        % Angle between two adjacent FOVs axes (radians)
        varphi = 35 * pi/180;
        
        % Half dead FOV
        gamma_dead =  0.25*(varphi - 4*gamma);
        
    otherwise
        nFOV   = 0;
        gamma  = 0;
        varphi = 0;
        gamma_dead =  0;
        disp('Frensel lens not recoginzed')
end

% Array of main axes
varphi_arry = nFOV * varphi;

% Construct a structure array.
FOV = struct('RightLwrAng', num2cell(varphi_arry-gamma_dead      )  , ...
             'RightCntAng', num2cell(varphi_arry-gamma_dead-gamma)  , ...
             'RightUprAng', num2cell(varphi_arry-gamma_dead-2*gamma), ...
             'LeftLwrAng', num2cell(varphi_arry+gamma_dead+2*gamma ), ...
             'LeftCntAng', num2cell(varphi_arry+gamma_dead+gamma)   , ...
             'LeftUprAng', num2cell(varphi_arry+gamma_dead)         , ...
             'LensType'  , LensType                                 , ...
             'Gamma',      gamma                                    , ...
             'GammaDead',  gamma_dead                               , ...
             'Varphi',     varphi                                     ... 
             );

% Traj = struct('RightLwrRay', num2cell( R0*sin(psi0)./sin(psi0+[FOV.RightLwrAng]) ) , ...
%               'RightUprRay', num2cell( R0*sin(psi0)./sin(psi0+[FOV.RightUprAng]) ) , ...
%               'LeftLwrRay', num2cell( R0*sin(psi0)./sin(psi0+[FOV.LeftLwrAng]) ) , ...
%               'LeftUprRay', num2cell( R0*sin(psi0)./sin(psi0+[FOV.LeftUprAng]) )  ...
%               );
