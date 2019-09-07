function [read_new, mark]=main(filename, num)
%将真实脑图像中的0、1、2、3拿出来，其余像素为0.
%函数main(filename, num)中的第一个参数filename是欲读取的rawb文件的文件名，第二个参数num就是第多少张。
%例如：main('t1_icbm_normal_1mm_pn0_rf0.rawb',100)
mark=Mark('phantom_1.0mm_normal_crisp.rawb',num);
read=readrawb(filename, num);
[row, col]=size(read);
read_new=zeros(row, col);
for i=1:row   %行
    for j=1:col    %列
        if mark(i,j)==0
            read_new(i,j)=0;
        else
            read_new(i,j)=read(i,j);   %将第0、1、2、3类拿出来，其余类为0
        end
    end
end
%旋转90°并显示出来
figure(1);  
init_image=imrotate(read_new, 90); 
imshow(uint8(init_image)); 
title('原图像');