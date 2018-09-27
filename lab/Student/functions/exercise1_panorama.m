
% Method:   Generate one image out of multiple images. All images are from
%           a camera with the same (!) center of projection. All the images 
%           are registered to one reference view.

clear all                   % Remove all old variables
close all                   % Close all figures
clc                         % Clear the command window
addpath( genpath( '../' ) );% Add paths to all subdirectories of the parent directory

LOAD_DATA           = true; % defaultly false
USE_NORMALIZE       = true;
USE_SMALL           = true;
REFERENCE_VIEW      = 3;
CAMERAS             = 3;

%%  from here
if USE_SMALL
    image_names_file    = '../images/names_images_kthsmall.txt';
    name_panorama       = '../images/panorama_image.jpg';
    points2d_file       = '../data/data_kth.mat';
else
    image_names_file    = '../images/names_images_kth.txt';
    name_panorama       = '../images/panorama_image_large.jpg';
    points2d_file       = '../data/data_kth_large.mat';
end


[images, name_loaded_images] = load_images_grey( image_names_file, CAMERAS );

% Load the clicked points if they have been saved,
% or click some new points:
if LOAD_DATA
    load( points2d_file );
else
    points2d = click_multi_view( images ); %, C, data, 0 ); % for clicking and displaying data
    save( points2d_file, 'points2d' );
end

% % if use larger image, multiply 4 for the points
% points2d(1:2,:,:) = points2d(1:2,:,:)*4


if USE_NORMALIZE
    
    fprintf('Use normalized selected points to calculate H\n');
    
    %% 1 if it used normalized selected points
    % 1-1. normalize the selected data points
    % calculate the normalization matrix
    norm_mat_test = compute_normalization_matrices( points2d );
    for c=1:CAMERAS
        points2d_norm(:,:,c) =  norm_mat_test(:,:,c)*points2d(:,:,c);
    end


    % 1-2. Compute homographies for normalized data points
    % Determine all homographies to a reference view. We have:
    % point in REFERENCE_VIEW = homographies(:,:,c) * point in image c.
    % Remember, you have to set homographies{REFERENCE_VIEW} as well.
    homographies = zeros(3,3,CAMERAS); 
    homographies_norm = zeros(3,3,CAMERAS); 

    for c=1:CAMERAS
    %     % for unnormalized selected points
    %     points_ref = points2d(:,:,REFERENCE_VIEW);
    %     points_c   = points2d(:,:,c);
    %     homographies(:,:,c) = compute_homography( points_ref, points_c );

        % for normalized selected points
        points__ref_norm = points2d_norm(:,:,REFERENCE_VIEW);
        points_c_norm   = points2d_norm(:,:,c);
        homographies_norm(:,:,c) = compute_homography( points__ref_norm, points_c_norm );

    end

    % 1-3. calculate the homography for unnormalized points from the normalized homographies
    for c=1:CAMERAS
        homographies(:,:,c) = pinv(norm_mat_test(:,:,REFERENCE_VIEW))*homographies_norm(:,:,c)*norm_mat_test(:,:,c);
    end
    
else
    fprintf('Use unnormalized selected points to calculate H\n');
    %% 2. if without normalization, calculate the homographies directly from
    % the unnormalized data points
    homographies = zeros(3,3,CAMERAS); 
    for c=1:CAMERAS
        % for unnormalized selected points
        points_ref = points2d(:,:,REFERENCE_VIEW);
        points_c   = points2d(:,:,c);
        homographies(:,:,c) = compute_homography( points_ref, points_c );
    end
end
    
    

%% 3. Feed the homographies to generate the panorama image
for c = 1:CAMERAS
    
    [error_mean error_max] = check_error_homographies( ...
      homographies(:,:,c), points2d(:,:,c), points2d(:,:,REFERENCE_VIEW) );
 
    fprintf( 'Between view %d and ref. view; ', c );
    fprintf( 'average error: %5.2f; maximum error: %5.2f \n', error_mean, error_max );
end


%%  to here

%% Generate, draw and save panorama

panorama_image = generate_panorama( images, homographies );

figure;  
show_image_grey( panorama_image );
save_image_grey( name_panorama, panorama_image );
