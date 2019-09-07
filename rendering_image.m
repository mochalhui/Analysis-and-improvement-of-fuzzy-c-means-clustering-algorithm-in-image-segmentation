function rendering_image(label,K)
%对分割结果进行渲染,4类,label:1、2、3、4
[m, n]=size(label);
read_new=zeros(m,n);
for i=1:m   %行
    for j=1:n    %列
        for k=1:K
            if label(i,j)==k
                read_new(i,j)=floor(255/K)*(k-1);               
            end
        end
    end
end
% 旋转90°并显示出来 
figure(3); 
cluster_image=imrotate(read_new, 90); 
imshow(uint8(cluster_image)); 
title('分割后');