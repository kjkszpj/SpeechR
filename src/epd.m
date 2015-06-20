function [i_start, i_end] = epd(data)
%   end point detection
%   data: row vector, 8000 point per second

%   get rid of hardware issue(see ypj & wqf for example)
if max(data(1, 1:2000)) > 0.7
	data(1, 1:2700) = data(1, 31001-2700:31000);
end
data = data / max(abs(data));  

window_len = 240;   %����С(Ӧ��Ҫ��)
step_len = 80;      %���ƶ�����

%   short term energy
t = data .* data;
energy = enframe(t, hamming(window_len,'periodic'), step_len);
energy = sum(energy, 2);

%   zero cross rate(ZCR)
eps = 0.01;
tmp1  = enframe(data(1:end-1), hamming(window_len,'periodic'), step_len);
tmp2  = enframe(data(2:end), hamming(window_len,'periodic'), step_len);
signs = (tmp1.*tmp2)<0;
diffs = (tmp1 -tmp2)>eps;
zcr   = sum(signs.*diffs, 2);  

%   energy / zcr
mvz = energy ./ zcr;

%   ���ò���
%   ������������
energy1 = 0.2 * max(energy);%��ʼ��ʱ����������  
energy2 = 0.23 * energy1;%��ʼ��ʱ����������  
zcr1 = 0.2 * max(zcr);%��ʼ��ʱ�����ʸ�����  
zcr2 = 0.23 * zcr1;%��ʼ��ʱ�����ʵ�����  
%   ���þ������Ⱥ���������
maxsilence = 15;  % 8*10ms  = 80ms  
minlen  = 20;    % 15*10ms = 150ms  

%   ��ʼ���
x1 = 0;
x2 = 0;
count = 0;
silence = 0;
status = 0;
result = [];
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
                if (silence < 3)
                    silence = 0;
                end
                count = count + 1;
            else
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
            count = count-silence/2; 
            x2 = x1 + count -1;  
            x1 = max(x1 - 5, 1);
            result = [result; x1, x2];
            x1 = 0;
            x2 = 0;
            count = 0;
            silence = 0;
            status = 0;
    end
end
if (status == 2 || status == 3)
    count = count-silence/2; 
    x2 = x1 + count -1;  
    x1 = max(x1 - 5, 1);
    result = [result; x1, x2];
    x1 = 0;
    x2 = 0;
    count = 0;
    silence = 0;
    status = 0;
end
%   ��ʼplot
%   plot origin speech
subplot(311)    %subplot(3,1,1)��ʾ��ͼ�ų�3��1�У�����һ��1��ʾ����Ҫ����1��ͼ  
plot(data)  
axis([1 length(data) -1 1])    %�����е��ĸ������ֱ��ʾxmin,xmax,ymin,ymax������ķ�Χ  
ylabel('Speech');  
for i = 1:size(result, 1)
    line([result(i, 1) * step_len, result(i, 1) * step_len], [-1, 1], 'Color', 'red');  
    line([result(i, 2) * step_len + window_len, result(i, 2) * step_len + window_len], [-1, 1], 'Color', 'red');
end

%   plot energy
subplot(312)     
plot(energy);  
axis([1 length(energy) 0 max(energy)])  
ylabel('Energy');  
for i = 1:size(result, 1)
    line([result(i, 1), result(i, 1)], [min(energy), max(energy)], 'Color', 'red');  
    line([result(i, 2), result(i, 2)], [min(energy), max(energy)], 'Color', 'red');
end
line([1 length(energy)], [energy1 ,energy1], 'Color', 'c');  
line([1 length(energy)], [energy2 ,energy2], 'Color', 'green');  

%   plot zcr
subplot(313)  
plot(zcr);  
axis([1 length(zcr) 0 max(zcr)])  
ylabel('ZCR');  
for i = 1:size(result, 1)
    line([result(i, 1), result(i, 1)], [min(zcr), max(zcr)], 'Color', 'red');  
    line([result(i, 2), result(i, 2)], [min(zcr), max(zcr)], 'Color', 'red');
end
line([1 length(zcr)], [zcr1 ,zcr1], 'Color', 'c');  
line([1 length(zcr)], [zcr2 ,zcr2], 'Color', 'green');   
result
end