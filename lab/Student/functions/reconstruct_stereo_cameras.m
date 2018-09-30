% function [cams, cam_centers] = reconstruct_stereo_cameras(E, K1, K2, data); 
%
% Method:   Calculate the first and second camera matrix. 
%           The second camera matrix is unique up to scale. 
%           The essential matrix and 
%           the internal camera matrices are known. Furthermore one 
%           point is needed in order solve the ambiguity in the 
%           second camera matrix.
%
%           Requires that the number of cameras is C=2.
%
% Input:    E is a 3x3 essential matrix with the singular values (a,a,0).
%
%           K is a 3x3xC array storing the internal calibration matrix for
%           each camera.
%
%           points2d is a 3xC matrix, storing an image point for each camera.
%
% Output:   cams is a 3x4x2 array, where cams(:,:,1) is the first and 
%           cams(:,:,2) is the second camera matrix.
%
%           cam_centers is a 4x2 array, where (:,1) is the first and (:,2) 
%           the second camera center.
%

function [cams, cam_centers] = reconstruct_stereo_cameras( E, K, points2d )

%------------------------------
% TODO: FILL IN THIS PART

%     % SVD decomposition and get t
%     [U, S, V] = svd(E);
%     t = V(:,end);
%     % rotation matrix
%     W = [0,-1,0;1,0,0;0,0,1];
%     
%     % Calculate R1 and R2 and handle mirroring
%     R1 = U*W*V';    R1 = sign(det(R1)).*R1;
%     R2 = U*W'*V';   R2 = sign(det(R2)).*R2;
%     
%     % Ma calculation
%     Ma = K(:,:,1) * [1,0,0,0;0,1,0,0;0,0,1,0];
%     % Mb has 4 possible solutions repect to 
% %     Mb = zeros(3,4,4);
% %     Mb(:,:,1) = K(:,:,2) * [R1, t];
% %     Mb(:,:,2) = K(:,:,2) * [R1, -t];
% %     Mb(:,:,3) = K(:,:,2) * [R2, t];
% %     Mb(:,:,4) = K(:,:,2) * [R2, -t];
%     Mb(:,:,1) = K(:,:,2) * R1 * [eye(3), t];
%     Mb(:,:,2) = K(:,:,2) * R1 * [eye(3), -t];
%     Mb(:,:,3) = K(:,:,2) * R2 * [eye(3), t];
%     Mb(:,:,4) = K(:,:,2) * R2 * [eye(3), -t];
%     
%     % in order to check which Mb is correct
%     % construct a 3D point point cloud
%     cameras = zeros(3,4,2);
%     
%     cameras(:,:,1) = Ma; cameras(:,:,2) = Mb(:,:,1);
%     points3d_test1 = reconstruct_point_cloud( cameras, points2d );
%     
%     cameras(:,:,1) = Ma; cameras(:,:,2) = Mb(:,:,2);
%     points3d_test2 = reconstruct_point_cloud( cameras, points2d );
%     
%     cameras(:,:,1) = Ma; cameras(:,:,2) = Mb(:,:,3);
%     points3d_test3 = reconstruct_point_cloud( cameras, points2d );
%     
%     cameras(:,:,1) = Ma; cameras(:,:,2) = Mb(:,:,4);
%     points3d_test4 = reconstruct_point_cloud( cameras, points2d );
%     
%     % for 1st solution
%     a_3d_1 = [1,0,0,0;0,1,0,0;0,0,1,0] * points3d_test1;
%     za_1 = a_3d_1(3);
% %     b_3d_1 = [R1, t] * points3d_test1;
%     b_3d_1 = R1 *[eye(3), t] * points3d_test1;
%     zb_1 = b_3d_1(3);
%     
%     % for 2nd solution
%     a_3d_2 = [1,0,0,0;0,1,0,0;0,0,1,0] * points3d_test2;
%     za_2 = a_3d_2(3);
% %     b_3d_2 = [R1, -t] * points3d_test2;
%     b_3d_2 = R1 *[eye(3), -t] * points3d_test2;
%     zb_2 = b_3d_2(3);
%     
%     % for 3th solution
%     a_3d_3 = [1,0,0,0;0,1,0,0;0,0,1,0] * points3d_test3;
%     za_3 = a_3d_3(3);
% %     b_3d_3 = [R2, t] * points3d_test3;
%     b_3d_3 = R2 *[eye(3), t] * points3d_test3;
%     zb_3 = b_3d_3(3);
%     
%     % for 4th solution
%     a_3d_4 = [1,0,0,0;0,1,0,0;0,0,1,0] * points3d_test4;
%     za_4 = a_3d_4(3);
% %     b_3d_4 = [R2, -t] * points3d_test4;
%     b_3d_4 = R2 *[eye(3), -t] * points3d_test4;
%     zb_4 = b_3d_4(3);
% 
%     % za_3 and zb_3 are all positive
%     % so index = 3
%     cams(:,:,1) = Ma;
%     cams(:,:,2) = Mb(:,:,3);
%     cam_centers = zeros(4,2);
%     cam_centers(:,1) = [0;0;0;1];
%     cam_centers(:,2) = [-t;1];
%     







                    % calculate translation vector t
                    [U, S, V] = svd(E);
                    t = V(:,end);

                    % calculate the rotation matrix R
                    W = [[0,-1,0];[1,0,0];[0,0,1]];
                    R1 = U * W * V';
                    R2 = U * W' * V';

                    if det(R1) == -1
                        R1 = R1* -1;
                    end

                    if det(R2) == -1
                        R2 = R2* -1;
                    end

                    Ma = K(:,:,1) *[eye(3),[0;0;0]];

                    Rbt = zeros(size(Ma,1),size(Ma,2),4);
%                     Rbt(:,:,1) = [R1,t]; 
%                     Rbt(:,:,2) = [R1,-t];
%                     Rbt(:,:,3) = [R2,t];
%                     Rbt(:,:,4) = [R2,-t];
                    Rbt(:,:,1) = R1*[eye(3),t];
                    Rbt(:,:,2) = R1*[eye(3),-t];
                    Rbt(:,:,3) = R2*[eye(3),t];
                    Rbt(:,:,4) = R2*[eye(3),-t];




                    % reconstruct 3d points for 4 possible camera2
                    % the first four means 4-dim
                    points3 = zeros(4,4);
                    % the matrix contrains Ma and Mb
                    cameras = zeros(size(Ma,1),size(Ma,2),2);
                    cameras(:,:,1) = Ma;
                    for i = 1:size(Rbt,3)
                        cameras(:,:,2) = K(:,:,2) * Rbt(:,:,i);
                        points3(:,i) = reconstruct_point_cloud( cameras, points2d);
                    end

                    % the rotation matrix of camera a
                    Rat = [ones(3,3),[0;0;0]];
                    cam_a = zeros(3,4);
                    cam_b = zeros(3,4);
                    for i = 1: size(Rbt,3)
                        cam_a(:,i) = Rat * points3(:,i);
                        cam_b(:,i) = Rbt(:,:,i) * points3(:,i);
                    end

                    index = find(cam_a(end,:)>= 0 & cam_b(end,:) >= 0);
                %     temp = cam_a .* cam_b;
                %     temp = temp(end,:);
                %     [~, index] = find(temp >= 0);

                    cams(:,:,1) = Ma;
                    cams(:,:,2) = K(:,:,2) * Rbt(:,:,index);
                    cam_centers = zeros(4,2);
                    cam_centers(:,1) = [0;0;0;1];
                    if index==1 || index == 3
                        cam_centers(:,2) = [-t;1];
                    else
                        cam_centers(:,2) = [t;1];
                    end
end
