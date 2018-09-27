% function F = compute_F_matrix(points1, points2);
%
% Method:   Calculate the F matrix between two views from
%           point correspondences: points2^T * F * points1 = 0
%           We use the normalize 8-point algorithm and 
%           enforce the constraint that the three singular 
%           values are: a,b,0. The data will be normalized here. 
%           Finally we will check how good the epipolar constraints:
%           points2^T * F * points1 = 0 are fullfilled.
% 
%           Requires that the number of cameras is C=2.
% 
% Input:    points2d is a 3xNxC array storing the image points.
%
% Output:   F is a 3x3 matrix where the last singular value is zero.

function [F,norm_mat_test, points2d_norm] = compute_F_matrix( points2d )
%------------------------------
% TODO: FILL IN THIS PART

norm_mat_test = compute_normalization_matrices( points2d );
for c=1:size(points2d,3)
    points2d_norm(:,:,c) =  norm_mat_test(:,:,c)*points2d(:,:,c);
end

numPoint = size(points2d_norm,2);

p_a = points2d_norm(:,:,1);
p_b = points2d_norm(:,:,2);

% construct W matrix by using the normalized points
W = zeros(numPoint,9);
for i = 1:numPoint
%     W(i,:) = [p_a(:,i).*p_b(1,i); p_a(:,i).*p_b(2,i);  p_a(:,i)]';
    x1 = p_a(1,i);y1 = p_a(2,i);
    x2 = p_b(1,i);y2 = p_b(2,i);
    
%     W(i,:) = [x1*x2, x1*y2, y1*x2, y1*y2, x1, y1, x2, y2, 1]';
    W(i,:) = [x2*x1, x2*y1, x2, y2*x1, y2*y1, y2, x1, y1, 1]';
end

% use svd decomposition to solve Wh=0 to get h
[U, S, V] = svd(W);
f = V(:,end);
F = reshape(f,3,3)';

% % check the correctness of E
% numPoint = size(points2d_norm,2);
% for i=1:numPoint
%     fprintf("For %d pair of data, pb_norm'*E*pa_norm' = %f. \n", [i, points2d_norm(:,i,2)'*F* points2d_norm(:,i,1)])
% end

