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

tmp1  = enframe(data(1:end-1), window_len, step_len);%��֡�����þ���Ϊfix����x(1:end-1)-FrameLen+FrameInc��/FrameInc��*FrameLen  
tmp2  = enframe(data(2:end)  , window_len, step_len);%��֡�����þ���Ϊfix����x(2:end)-FrameLen+FrameInc��/FrameInc��*FrameLen  
signs = (tmp1.*tmp2)<0;%tmp1.*tmp2���þ���С�ڵ�����ĸ�ֵΪ1��������ĸ�ֵΪ0  
diffs = (tmp1 -tmp2)>0.01;%tmp1-tmp2���þ���С��0.02�ĸ�ֵΪ0�����ڵ���0.02�ĸ�ֵΪ1  
zcr   = sum(signs.*diffs, 2);  
% plot(zcr);
% n = input('continue....');
% plot(s_zero);
% n = input('continue....');
mvz = s_energy ./ zcr;
% plot(mvz);

%   ��ʼplot
subplot(311)    %subplot(3,1,1)��ʾ��ͼ�ų�3��1�У�����һ��1��ʾ����Ҫ����1��ͼ  
plot(data)  
axis([1 length(data) -1 1])    %�����е��ĸ������ֱ��ʾxmin,xmax,ymin,ymax������ķ�Χ  
ylabel('Speech');  
% line([x1*FrameInc x1*FrameInc], [-1 1], 'Color', 'red');  
%��������Ϊ��ֱ�߻��������ε������յ㣬��������ֱ�ۡ���һ��[]�е���������Ϊ����ֹ��ĺ����꣬  
%�ڶ���[]�е���������Ϊ����ֹ��������ꡣ������������������ߵ���ɫ��  
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