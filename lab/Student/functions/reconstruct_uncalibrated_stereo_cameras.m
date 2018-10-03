% function [cams, cam_centers] = reconstruct_uncalibrated_stereo_cameras(F); 
%
% Method: Calculate the first and second uncalibrated camera matrix
%         from the F-matrix. 
% 
% Input:  F - Fundamental matrix with the last singular value 0 
%
% Output:   cams is a 3x4x2 array, where cams(:,:,1) is the first and 
%           cams(:,:,2) is the second camera matrix.
%
%           cam_centers is a 4x2 array, where (:,1) is the first and (:,2) 
%           the second camera center.

function [cams, cam_centers] = reconstruct_uncalibrated_stereo_cameras( F )


%------------------------------
% TODO: FILL IN THIS PART
    % Ma = (I|0)
    Ma = [eye(3),[0;0;0]];
    % Mb = (SF|h)
    % use F to calculate the h by using F^T h = 0
    [Utemp, Stemp, Vtemp] = svd(F');
    h = Vtemp(:,end);
    S = [0,-1,1;1,0,-1;-1,1,0];
    Mb = [S*F, h];
    
    % to calculate ta and tb for both two cameras, using SVD again
    % for ta
    [a,b,c] = svd(Ma);
    ta = c(:,end);
    % for tb
    [a,b,c] = svd(Mb);
    tb = c(:,end);
    
    cams = zeros(3,4,2); cams(:,:,1) = Ma; cams(:,:,2) = Mb; 
    cam_centers = zeros(4,2); cam_centers(:,1) = ta; cam_centers(:,2) = tb;
    

