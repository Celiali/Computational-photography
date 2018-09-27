function lab1_part1
    % 3x4xC C different camera matrix, The c-th camera matrix: Mc = cameras(:,:,c)
    cameras 
    
    % 4xN N different 3D point, The n-th 3D point: Pn = model(:,n)
    model
    
    % 3xNxC all image points, pcn = data(:,n,c); data(:,n,:); data(:,:,c)
    data
    
    % grey scale image
    % image: images = cell(C,1)
    % x,y pixel in c-th images: pixel = images{c}(y,x)
end