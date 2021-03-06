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

function F = compute_F_matrix( points2d )
%------------------------------
% TODO: FILL IN THIS PART

    % normalize the points using the normalization matrix first
    norm_mat = compute_normalization_matrices( points2d );
    for c=1:size(points2d,3)
        points2d_norm(:,:,c) =  norm_mat(:,:,c)*points2d(:,:,c);
    end
    numPoint = size(points2d_norm,2);
    p_a_norm = points2d_norm(:,:,1);
    p_b_norm = points2d_norm(:,:,2);
    
    % construct W matrix by using the normalized points
    W = zeros(numPoint,9);
    for i = 1:numPoint
    %     W(i,:) = [p_a(:,i).*p_b(1,i); p_a(:,i).*p_b(2,i);  p_a(:,i)]';
        x1 = p_a_norm(1,i);y1 = p_a_norm(2,i);
        x2 = p_b_norm(1,i);y2 = p_b_norm(2,i);
        W(i,:) = [x2*x1, x2*y1, x2, y2*x1, y2*y1, y2, x1, y1, 1]';
    end
    % use svd decomposition to solve Wh=0 to get h
    [U, S, V] = svd(W);
    f = V(:,end);
    F = reshape(f,3,3)';
    F = norm_mat(:,:,2)'*F*norm_mat(:,:,1);
    [Ue, Se, Ve] = svd(F);
    Fcorrect1 = Se(1,1);
    Fcorrect2 = Se(2,2);
    F = Ue * [[Fcorrect1,0,0];[0,Fcorrect2,0];[0,0,0]] * Ve';
end