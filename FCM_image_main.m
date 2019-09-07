function [accuracy,iter_FCM,run_time,Vpc]=FCM_image_main(filename, num, K)
%num：第几层，K：聚类数
%[accuracy,iter_FCM,run_time]=FCM_image_main('t1_icbm_normal_1mm_pn0_rf0.rawb', 100, 4)
[data_load, label_load]=main(filename, num);  %原图像
[m,n]=size(data_load);
X=reshape(data_load,m*n,1);   %(m*n)*1
real_label=reshape(label_load,m*n,1)+ones(m*n,1);
Ground_truth(num, K);  %标准分割结果，进行渲染
t0=cputime;
[label_1,~,iter_FCM,responsivity,X_num]=My_FCM(X,K);

run_time=cputime-t0;
while iter_FCM<30||iter_FCM>40
    t0=cputime;
[label_1,~,iter_FCM,responsivity,X_num]=My_FCM(X,K);
run_time=cputime-t0;
end
[label_new,accuracy,Vpc]=succeed(real_label,K,label_1, responsivity,X_num);
label_2=reshape(label_new,m, n); 
rendering_image(label_2, K);  %聚类结果