function D = cmptDistPlr(R1, theta1, R2, theta2)
% CMPTDISTPLR computes the distance between two points in polar coordinates.
% It is in fact the cosine law.

if( (length(R1) ~= length(R2)) && (length(R1)==1) )
   R1 = R1 * ones(size(R2)); 
end
    
D = sqrt( R1.^2 + R2.^2 -2*R1.*R2.*cos(theta1 - theta2) );

end

