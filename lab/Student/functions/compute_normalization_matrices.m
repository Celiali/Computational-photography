% Method:   compute all normalization matrices.  
%           It is: point_norm = norm_matrix * point. The norm_points 
%           have centroid 0 and average distance = sqrt(2))
% 
%           Let N be the number of points and C the number of cameras.
%
% Input:    points2d is a 3xNxC array. Stores un-normalized homogeneous
%           coordinates for points in 2D. The data may have NaN values.
%        
% Output:   norm_mat is a 3x3xC array. Stores the normalization matrices
%           for all cameras, i.e. norm_mat(:,:,c) is the normalization
%           matrix for camera c.

function norm_mat = compute_normalization_matrices( points2d )
%     meanpoints2d;

    % initialize the Nc matrices
    norm_mat = zeros(3,3,size(points2d, 3));

    for c=1:size(points2d, 3)

        % 1. preprocess and filter to get the visible points in one camera
        % set of points in one camera
        mmm=points2d(:,:,c);
        % number of not-null <=> number of visible points
        numVisible = sum(sum(~isnan(mmm)))/3;
        % filter and get the set of visible points
        filterpoints = reshape(mmm(~isnan(mmm)), 3, numVisible);
        
        % 2. get the centroid of selected points in camera c
        centerP = mean(filterpoints,2);
        % compute the average distance of selected points to the centroid
        % in camera c, use L2 distance
        dc = filterpoints-centerP;
        % distance from every points to the centriod
        dc = sqrt(sum((dc).^2));
        % ave dist in every camera
        dc = mean(dc);
        norm_mat(:,:,c) = sqrt(2)/dc * [[1,0,0]', [0,1,0]', [-centerP(1:2);dc/sqrt(2)]];
    end
    
%-------------------------
% TODO: FILL IN THIS PART