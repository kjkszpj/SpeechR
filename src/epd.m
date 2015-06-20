function [i_start, i_end] = epd(data)
%   end point detection
%   data: row vector
if max(data(1, 1:2000)) > 0.7
	data(1, 1:2700) = data(1, 31001-2700:31000);
end
data = data ./ max(data);
% plot(data);
% n = input('continue....');
len = size(data, 2);
window_len = 240;
step_len = 80;
t1 = 0;
t2 = 0;

t = data .* data;
s_energy = enframe(t, window_len, step_len);
s_energy = sum(s_energy, 2);
% plot(s_energy);
% n = input('continue....');

eps = 0.0005;
for i = 1:1:len - 1
    t(i) = (data(i) > eps && data(i + 1) < -eps) || (data(i) < -eps && data(i + 1) > eps);
end
s_zero = enframe(t, window_len, step_len);
s_zero = sum(s_zero, 2);
mvz = zeros(size(s_zero));
size(mvz);

tmp1  = enframe(data(1:end-1), window_len, step_len);%分帧，所得矩阵为fix（（x(1:end-1)-FrameLen+FrameInc）/FrameInc）*FrameLen  
tmp2  = enframe(data(2:end)  , window_len, step_len);%分帧，所得矩阵为fix（（x(2:end)-FrameLen+FrameInc）/FrameInc）*FrameLen  
signs = (tmp1.*tmp2)<0;%tmp1.*tmp2所得矩阵小于等于零的赋值为1，大于零的赋值为0  
diffs = (tmp1 -tmp2)>0.01;%tmp1-tmp2所得矩阵小于0.02的赋值为0，大于等于0.02的赋值为1  
zcr   = sum(signs.*diffs, 2);  
% plot(zcr);
% n = input('continue....');
% plot(s_zero);
% n = input('continue....');
mvz = s_energy ./ zcr;
% plot(mvz);

%   开始plot
subplot(311)    %subplot(3,1,1)表示将图排成3行1列，最后的一个1表示下面要画第1幅图  
plot(data)  
axis([1 length(data) -1 1])    %函数中的四个参数分别表示xmin,xmax,ymin,ymax，即轴的范围  
ylabel('Speech');  
% line([x1*FrameInc x1*FrameInc], [-1 1], 'Color', 'red');  
%这里作用为用直线画出语音段的起点和终点，看起来更直观。第一个[]中的两个参数为线起止点的横坐标，  
%第二个[]中的两个参数为线起止点的纵坐标。最后两个参数设置了线的颜色。  
% line([x2*FrameInc x2*FrameInc], [-1 1], 'Color', 'red');  
subplot(312)     
plot(mvz);  
axis([1 length(mvz) 0 max(mvz)])  
ylabel('Energy');  
% line([x1 x1], [min(s_energy),max(s_energy)], 'Color', 'red');  
% line([x2 x2], [min(s_energy),max(s_energy)], 'Color', 'red');  
subplot(313)  
plot(zcr);  
axis([1 length(zcr) 0 max(zcr)])  
ylabel('ZCR');  
% line([x1 x1], [min(zcr),max(zcr)], 'Color', 'red');  
% line([x2 x2], [min(zcr),max(zcr)], 'Color', 'red');  
end