function result = mfcc(x, m, l, demo)
%   MFCC
%   procedure: normalize-->enframe-->STFT(FFT)-->mel_filtering-->IDCT

% fill the parameter
% number of mel filter
if (nargin < 2)
    m = 20;
end
% dimension of MFCC
if (nargin < 3)
    l = 16;
end
% demo or not
if (nargin < 4)
    demo = true;
end

% normalize & enframe
x = normalize_data(x);
[u, u, x] = epd(x);
%   TODO, window size? 20ms-40ms
window_len = 240;
step_len = 80;
x = enframe(x, hamming(window_len, 'periodic'), step_len);

% FFT & energy spectrum
cnt_fft = 2^nextpow2(size(x, 2));
x = fft(x, cnt_fft, 2);
x = abs(x);
x = x .* x;
% x = x(:, 1:cnt_fft / 2);
% plot
f = 8000*linspace(0,1,cnt_fft);

if demo 
    plot(f, 2*abs(x(1, :)));
end

% mel filtering
% generate mel filter
% Hz:300-4000, uniform in mel
% 4000hz for 8000hz sample rate(采样定理？)
min_freq = frq2mel(50);
max_freq = frq2mel(4000);
key_f = linspace(min_freq, max_freq, m + 2);
key_f = mel2frq(key_f);
% generate filter matrix
fil = zeros(cnt_fft, m);
for j = 1:m
    for i = 1:cnt_fft
        temp_f = f(i);
        temp = 0;
        if (temp_f >= key_f(j) && temp_f <= key_f(j + 1)) temp = (temp_f - key_f(j)) / (key_f(j + 1) - key_f(j));
        end
        if (temp_f >= key_f(j + 1) && temp_f <= key_f(j + 2)) temp = (key_f(j + 2) - temp_f) / (key_f(j + 2) - key_f(j + 1));
        end
        fil(i, j) = temp;
    end
end
size(x);
size(fil);
y = log(x * fil);
size(y)

% IDFT
% TODO question here!!!
dctm = ones(m, l);
for i = 1:m
    dctm(i, :) = dctm(i, :) * (i - 0.5);
end
for i = 1:l
    dctm(:, i) = dctm(:, i) * i;
end
dctm = cos(dctm * pi / m);
result = y * dctm;

% if demo
%     for i = 1:size(mfcc, 1)
%         plot(mfcc(i, :));
%         axis([1 l -20 50]);
%         pause(0.3);
%     end
% end
end