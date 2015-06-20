function [i_start, i_end] = epd(data)
%   end point detection
%   data: row vector, 8000 point per second

%   get rid of hardware issue(see ypj & wqf for example)
if (sum(data) == 0)
    return
end
if max(data(1, 1:2000)) > 0.7
	data(1, 1:2700) = data(1, 31001-2700:31000);
end
data = data / max(abs(data));  

window_len = 240;   %窗大小(应该要改)
step_len = 80;      %窗移动距离

%   short term energy
t = data .* data;
energy = enframe(t, hamming(window_len,'periodic'), step_len);
energy = sum(energy, 2);

%   zero cross rate(ZCR)
eps = 0.02;
tmp1 = enframe(data(1 : end - 1), hamming(window_len,'periodic'), step_len);
tmp2 = enframe(data(2 : end), hamming(window_len,'periodic'), step_len);
signs = (tmp1 .* tmp2) < 0;
diffs = (tmp1 - tmp2) > eps;
zcr = sum(signs .* diffs, 2);  

%   energy / zcr
mvz = energy ./ zcr;

%   设置参数
%   设置两个门限
energy1 = 0.2 * max(energy);%初始短时能量高门限  
energy2 = 0.23 * energy1;%初始短时能量低门限  
if max(zcr(1:5)) > 0.2 * max(zcr)
    zcr1 = 0.3 * max(zcr);%初始短时过零率高门限  
else
    zcr1 = 0.17 * max(zcr);
end
zcr2 = 0.23 * zcr1;%初始短时过零率低门限  
%   设置静音长度和语音长度
maxsilence = 20;  % 8*10ms  = 80ms  
minlen  = 30;    % 15*10ms = 150ms  

%   开始检测
x1 = 0;
x2 = 0;
count = 0;
silence = 0;
status = 0;
result = [];
cnt_reset = 0;
for i = 1:1:length(zcr)
    switch status
        case {0, 1}
            if (energy(i) > energy1 || zcr(i) > zcr1)
                x1 = max(i - count + 1, 1);
                status = 2;
                silence = 0;
                count = count + 1;
            elseif (energy(i) > energy2 || zcr(i) > zcr2)
                status = 1;
                count = count + 1;
            else
                status = 0;
                count = 0;
            end
            continue
        case {2}
            if energy(i) > energy1 || zcr(i) > zcr1
                silence = 0;
            end
            if energy(i) > energy2 || zcr(i) > zcr2
                if (cnt_reset < 3)
                    silence = 0;
                end
                count = count + 1;
            else
                cnt_reset  = cnt_reset + 1;
                silence = silence + 1;
                if (silence < maxsilence)
                    count = count + 1;
                else
                    if (count < minlen)
                        count = 0;
                        status = 0;
                        silence = 0;
                    else
                        status = 3;
                    end
                end
            end
            continue
        case {3}
            count = count - silence / 1.618; 
            x2 = min(x1 + count - 1, length(energy));
            x1 = max(x1 - 5, 1);
            result = [result; x1, x2];
            x1 = 0;
            x2 = 0;
            count = 0;
            silence = 0;
            status = 0;
            cnt_reset = 0;
    end
end
if (status == 2 || status == 3)
    count = count - silence / 2; 
    x2 = min(x1 + count - 1, length(energy));
    x1 = max(x1 - 5, 1);
    result = [result; x1, x2];
    x1 = 0;
    x2 = 0;
    count = 0;
    silence = 0;
    status = 0;
end
%   开始plot
%   plot origin speech
subplot(311)    %subplot(3,1,1)表示将图排成3行1列，最后的一个1表示下面要画第1幅图  
plot(data)  
axis([1 length(data) -1 1])    %函数中的四个参数分别表示xmin,xmax,ymin,ymax，即轴的范围  
ylabel('Speech');  
% for i = 1:size(result, 1)
%     line([result(i, 1) * step_len, result(i, 1) * step_len], [-1, 1], 'Color', 'red');  
%     line([result(i, 2) * step_len + window_len, result(i, 2) * step_len + window_len], [-1, 1], 'Color', 'red');
% end
%   plot energy
subplot(312)     
plot(energy);  
axis([1 length(energy) 0 max(energy)])  
ylabel('Energy');  
% for i = 1:size(result, 1)
%     line([result(i, 1), result(i, 1)], [min(energy), max(energy)], 'Color', 'red');  
%     line([result(i, 2), result(i, 2)], [min(energy), max(energy)], 'Color', 'red');
% end
line([1 length(energy)], [energy1 ,energy1], 'Color', 'c');  
line([1 length(energy)], [energy2 ,energy2], 'Color', 'green');  
%   plot zcr
subplot(313)  
plot(zcr);  
axis([1 length(zcr) 0 max(zcr)])  
ylabel('ZCR');  
% for i = 1:size(result, 1)
%     line([result(i, 1), result(i, 1)], [min(zcr), max(zcr)], 'Color', 'red');  
%     line([result(i, 2), result(i, 2)], [min(zcr), max(zcr)], 'Color', 'red');
% end
line([1 length(zcr)], [zcr1 ,zcr1], 'Color', 'c');  
line([1 length(zcr)], [zcr2 ,zcr2], 'Color', 'green');   

%   计算比例
batch_cnt = size(result, 1);
par = zeros(1, batch_cnt);
for i = 1:1:batch_cnt
    x1 = result(i, 1);
    x2 = result(i, 2);
    par(1, i) = sum(energy(x1 : x2)) + sum(zcr(x1 : x2));
end
par = par ./ sum(par);
[u, index] = max(par);

%   开始合并区间
i_start = result(index, 1);
i_end = result(index, 2);
i = index - 1;
while i >= 1
    if par(1, i) >= 0.12
        %   force merge
        i_start = min(i_start, result(i, 1));
        i = i - 1;
    elseif par(1, i) >= 0.08
        %   doubt merge
        if (i_end - min(i_start, result(i, 1)) > 150)
            break
        end
        i_start = min(i_start, result(i, 1));
        i = i - 1;
    else
        break;
    end
end 
i = index + 1;
while i <= batch_cnt
    if par(1, i) >= 0.12
        %   force merge
        i_end = max(i_end, result(i, 2));
        i = i + 1;
    elseif par(1, i) >= 0.08
        %   doubt merge
        if (max(i_end, result(i, 2)) - i_start > 150)
            break
        end
        i_end = max(i_end, result(i, 2));
        i = i + 1;
    else
        break;
    end
end
subplot(311);
line([i_start * step_len, i_start * step_len], [-1, 1], 'Color', 'black');  
line([i_end * step_len + window_len, i_end * step_len + window_len], [-1, 1], 'Color', 'black');
subplot(313);
line([i_start, i_start], [min(zcr), max(zcr)], 'Color', 'black');  
line([i_end, i_end], [min(zcr), max(zcr)], 'Color', 'black');
if batch_cnt > 1
    subplot(312);
    bar(par);
    u = input('continue...');
end
end