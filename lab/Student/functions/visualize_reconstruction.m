% function visualize_reconstruction( points3d, camera_centers, ...
%                                    points2d_reference, image_reference )
%
% Visualize a reconstructed model.
%
% Let N be the number of points and C the number of cameras.
%
% points3d          4xN matrix of all 3d points.
%
% camera_centers    4xC array, storing the camera center for each camera.
%
% points2d          3xN array, storing all image points in a reference view.
%
% texture           Image representing the texture of the model. If the
%                   function receives an empty argument, texture=[], then
%                   the model is not drawn with any texture. This is useful
%                   for synthetic data without texture.

function visualize_reconstruction( points3d, camera_centers, ...
                                   points2d_reference, texture )

% Convert homogeneous coordinates to cartesian coordinates:
points3d_cartesian          = homogeneous_to_cartesian( points3d );
camera_centers_cartesian    = homogeneous_to_cartesian( camera_centers );
points2d_cartesian          = homogeneous_to_cartesian( points2d_reference );

X = points3d_cartesian(1,:);
Y = points3d_cartesian(2,:);
Z = points3d_cartesian(3,:);

camx = camera_centers_cartesian(1,:);
camy = camera_centers_cartesian(2,:);
camz = camera_centers_cartesian(3,:);

% Draw points and camera centers:
figure(1)
hold on
plot3( X, Y, Z, '.');
plot3( camx, camy, camz, 'ro' );
view(126,20)
axis equal
	
grid on

hold off;
% ------------------------
% TODO: FILL IN THIS PART
figure(2)
hold on;
view(126,20)
axis equal
axis vis3d
grid on
% triang = delaunay(X,Y,Z);
% trisurf(triang,X,Y);
triang = delaunay(points2d_cartesian(1,:),points2d_cartesian(2,:));
trisurf(triang,X,Y,Z,ones(size(Y)));
hold off;

% map the texture

if ~isempty( texture )
    figure(3)
    hold on;
    view(126,20)
    axis equal
    axis vis3d
    grid on
    draw_textured_triangles( triang, X, Y, Z, points2d_cartesian(1,:), points2d_cartesian(2,:), texture', 32 )
end
hold off;

end

