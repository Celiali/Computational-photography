% function E = compute_E_matrix( points1, points2, K1, K2 );
%
% Method:   Calculate the E matrix between two views from
%           point correspondences: points2^T * E * points1 = 0
%           we use the normalize 8-point algorithm and 
%           enforce the constraint that the three singular 
%           values are: a,a,0. The data will be normalized here. 
%           Finally we will check how good the epipolar constraints:
%           points2^T * E * points1 = 0 are fullfilled.
% 
%           Requires that the number of cameras is C=2.
% 
% Input:    points2d is a 3xNxC array storing the image points.
%
%           K is a 3x3xC array storing the internal calibration matrix for
%           each camera.
%
% Output:   E is a 3x3 matrix with the singular values (a,a,0).

function E = compute_E_matrix( points2d, K )

%------------------------------
% TODO: FILL IN THIS PART


version = 1

if version == 1
    % normalize the points from two different views
    p_a = pinv(K(:,:,1))*points2d(:,:,1);
    p_b = pinv(K(:,:,2))*points2d(:,:,2);
    % p_a = points2d(:,:,1);
    % p_b = points2d(:,:,2);

    p_ab = zeros(size(points2d));
    p_ab(:,:,1) = p_a;
    p_ab(:,:,2) = p_b;
%     [F,NormMat,points2d_norm] = compute_F_matrix( p_ab );

    norm_mat_test = compute_normalization_matrices( p_ab );
    for c=1:size(p_ab,3)
        points2d_norm(:,:,c) =  norm_mat_test(:,:,c)*p_ab(:,:,c);
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

    E = norm_mat_test(:,:,2)'*F*norm_mat_test(:,:,1);
    [Ue, Se, Ve] = svd(E);
    Scorrect = (Se(1,1) + Se(2,2))/2;
    E = Ue * [[Scorrect,0,0];[0,Scorrect,0];[0,0,0]] * Ve';
%     
%     % check the correctness of E
%     numPoint = size(points2d_norm,2);
%     for i=1:numPoint
%         fprintf("For %d pair of data, pb'*E*pa = %f. \n", [i, p_b(:,i)'*E* p_a(:,i)])
% %         fprintf("For %d pair of data, pb'*E*pa = %f. \n", [i, points2d(:,i,2)'*E* points2d(:,i,1)])
%     end
else
    p_a = pinv(K(:,:,1))*points2d(:,:,1);
    p_b = pinv(K(:,:,2))*points2d(:,:,2);
    % the number of correspondences
    numPoint = size(points2d,2);

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
    e = V(:,end);
    E = reshape(e,3,3)';

%     % check the correctness of E
%     for i=1:numPoint
%     %     p_b(:,i)'*E* p_a(:,i)
%         fprintf("For %d pair of data, pb'*E*pa' = %f. \n", [i, p_b(:,i)'*E* p_a(:,i)])
%     end
end


