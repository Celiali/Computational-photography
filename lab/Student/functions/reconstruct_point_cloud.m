% function model = reconstruct_point_cloud(cam, data)
%
% Method:   Determines the 3D model points by triangulation
%           of a stereo camera system. We assume that the data 
%           is already normalized 
% 
%           Requires that the number of cameras is C=2.
%           Let N be the number of points.
%
% Input:    points2d is a 3xNxC array, storing all image points.
%
%           cameras is a 3x4xC array, where cameras(:,:,1) is the first and 
%           cameras(:,:,2) is the second camera matrix.
% 
% Output:   points3d 4xN matrix of all 3d points.


function points3d = reconstruct_point_cloud( cameras, points2d )

%------------------------------
% TODO: FILL IN THIS PART
points3d = zeros(4,size(points2d,2));

m1 = cameras(:,:,1);
m2 = cameras(:,:,2);

for i = 1:size(points2d,2)
    
    x1 = points2d(1,i,1);y1 = points2d(2,i,1);
    x2 = points2d(1,i,2);y2 = points2d(2,i,2);
    
%     % normalize the points
%     x1 = x1./norm(x1);
%     x2 = x2./norm(x2);
   
    Wup   = [x1;y1] * m1(3,:) - m1(1:2,:);
    Wdown = [x2;y2] * m2(3,:) - m2(1:2,:);
    W = [Wup; Wdown];
    
    [U, S, V] = svd(W);
    point = V(:,end);
    
    normfactor = 1/point(4);
%     points3d(:,i) = point.*1;
    points3d(:,i) = point.*normfactor;
    
end

    
    


