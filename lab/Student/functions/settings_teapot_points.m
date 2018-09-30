aa1=load("data_teapot_v1.mat")

aa2=load("data_teapot_v3.mat")
aa3=load("data_teapot_v4.mat")
aa5=load("data_teapot_v5.mat")

final=zeros(3,127+57,2);
final(:,1:57,:)=aa1.points2d;
final(:,58:end,:)=aa3.points2d;
save('../data/data_teapot_final.mat','points2d');

final=zeros(3,25+127,2);
final(:,1:25,:)=aa2.points2d;
final(:,26:end,:)=aa3.points2d;
points2d=final;
save('../data/data_teapot_final.mat','points2d');

final=zeros(3,25+57,2);
final(:,1:25,:)=aa2.points2d;
final(:,26:end,:)=aa1.points2d;
points2d=final;
save('../data/data_teapot_final.mat','points2d');



aa1=load("data_teapot_v1.mat")
aa2=load("data_teapot_v2.mat")
aa3=load("data_teapot_v3.mat")
aa4=load("data_teapot_v4.mat")
aa5=load("data_teapot_v5.mat")
aa6=load("data_teapot_v6.mat")
aa7=load("data_teapot_v7.mat") % 
aa8=load("data_teapot_v8.mat") % 373
final=[aa1.points2d,aa2.points2d,aa3.points2d,aa4.points2d,aa5.points2d,aa6.points2d,aa7.points2d,aa8.points2d];
points2d=final;
save('../data/data_teapot_final.mat','points2d');


aa3=load("data_teapot_v3.mat")
aa6=load("data_teapot_v6.mat")
aa7=load("data_teapot_v7.mat")
final=[aa3.points2d,aa6.points2d,aa7.points2d];
points2d=final;
save('../data/data_teapot_final.mat','points2d');
size(points2d)


aa2=load("data_teapot_v2.mat")
aa8=load("data_teapot_v8.mat")
final=[aa2.points2d,aa8.points2d];
points2d=final;
save('../data/data_teapot_final.mat','points2d');