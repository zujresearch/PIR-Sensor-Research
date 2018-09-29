function plotFOVs(FOV, Traj)
%PLOTFOVS Plots the PIR sensor lens field of views in addition to the
%trajectory of the target.


for m = 1:length(FOV)
   % Plot each FOV
   polar([0,FOV(m).RightLwrAng],[0,Traj(m).RightLwrRay],'b')
   polar([0,FOV(m).RightCntAng],[0,Traj(m).RightCntRay],'k--')
   polar([0,FOV(m).RightUprAng],[0,Traj(m).RightUprRay],'b')  
   polar([0,FOV(m).LeftLwrAng],[0,Traj(m).LeftLwrRay],'b')
   polar([0,FOV(m).LeftCntAng],[0,Traj(m).LeftCntRay],'k--')
   polar([0,FOV(m).LeftUprAng],[0,Traj(m).LeftUprRay],'b')
   
   % Trajectory
%    polar([FOV(m).RightLwrAng, FOV(m).RightUprAng], ...
%          [Traj(m).RightLwrRay, Traj(m).RightUprRay],'k')
%      
%    polar([FOV(m).LeftLwrAng, FOV(m).LeftUprAng], ...
%          [Traj(m).LeftLwrRay, Traj(m).LeftUprRay])
   
end

% Trajectory
polar([FOV(1).RightUprAng, FOV(end).LeftLwrAng], ...
      [Traj(1).RightUprRay, Traj(end).LeftLwrRay] ,'r')
     


end

