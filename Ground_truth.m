function Ground_truth(num, K)
%标准分割结果
%Ground_truth(100, 4)
mark=Mark('phantom_1.0mm_normal_crisp.rawb',num);  %0、1、2、3
m=181;
n=217;
read_new=zeros(m,n);
mark=mark+ones(m, n);  %标签：1、2、3、4
for i=1:m   %行
    for j=1:n    %列
        for k=1:K
            if mark(i,j)==k
                read_new(i,j)=floor(255/K)*(k-1);               
            end
        end
    end
end
% 旋转90°并显示出来
figure(2)
truth_image=imrotate(read_new, 90); 
imshow(uint8(truth_image)); 
title('标准分割结果');