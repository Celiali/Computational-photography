% H = compute_homography(points1, points2)
%
% Method: Determines the mapping H * points2 = points1
%           H*pointsb -> pointsa; H*points2->points1
%           a is ref, points1 is ref
% 
% Input:  points1, points2 are of the form (3,n) with 
%         n is the number of points.
%         The points should be normalized for 
%         better performance.
% 
% Output: H 3x3 matrix 
%

function H = compute_homography( points1, points2 )

    % initialize the H matrix
    h = zeros(1,9)';
    % initialize Q
    pairnum = 0;
    for i=1:size(points2,2)
        if ~isnan(points2(1,i))
            pairnum = pairnum + 1;
        end
    end
    Q = zeros(9,2*pairnum);
    
    % find all the pairs (using nan infor) and construct alpha, beta
    % matrices
    alpha = [];
    beta = [];
    for i=1:size(points2,2)
        if ~isnan(points2(1,i))
            alpha = [alpha, [points2(:,i); [0;0;0]; -points1(1,i).*points2(:,i)] ];
            beta =  [beta,  [[0;0;0]; points2(:,i); -points1(2,i).*points2(:,i)] ];
        end
    end
    
    % use the infor to construct alpha beta vectors and Q matrix
    Q = [alpha, beta]';
    
    % use QT*Q matrix to calculate the eigenvectors and eigenvalues
    % M = Q'*Q;
    [U, S, V] = svd(Q);
    % pick the eigenvector correspond to the minimum eigenvalue
    h = V(:, end);
    
    % reshape the h to H and return
    H = reshape(h,3,3)';
    
    
    
%-------------------------
% TODO: FILL IN THIS PART
