% function [error_average, error_max] = check_reprojection_error(data, cam, model)
%
% Method:   Evaluates average and maximum error 
%           between the reprojected image points (cam*model) and the 
%           given image points (data), i.e. data = cam * model 
%
%           We define the error as the Euclidean distance in 2D.
%
%           Requires that the number of cameras is C=2.
%           Let N be the number of points.
%
% Input:    points2d is a 3xNxC array, storing all image points.
%
%           cameras is a 3x4xC array, where cams(:,:,1) is the first and 
%           cameras(:,:,2) is the second camera matrix.
%
%           point3d 4xN matrix of all 3d points.
%       
% Output:   
%           The average error (error_average) and maximum error (error_max)
%      

function [error_average, error_max] = check_reprojection_error( points2d, cameras, point3d )

%------------------------------
% TODO: FILL IN THIS PART

[~,N,C] = size(points2d);

error_total = zeros(N,2);

% calculate the reconstructed point2d and the error
points2d_recon = zeros(size(points2d));
for i = 1:C
    points2d_recon(:,:,i) = cameras(:,:,i) * point3d;
    points2d_recon(:,:,i) = points2d_recon(:,:,i)./points2d_recon(3,:,i);
%     calculate the distance and the error
    error_temp = points2d(:,:,i)-points2d_recon(:,:,i);
    error_total(:,i) = sqrt(sum(error_temp .^2,1));
end

error_average = sum(sum(error_total))/ (size(error_total,1)*size(error_total,2));
error_max = max(max(error_total));
end



    