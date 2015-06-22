function result = sample_mfcc(x, d, l, m, demo)
%   mfcc itself is VARLEN data, uniform sample it to get a d * l dimension
%   vector
if nargin < 2
    d = 50;
end
if nargin < 3
    l = 16;
end
if nargin < 4
    m = 20;
end
if nargin < 5
    demo = true;
end

result = zeros(d * l, 1);
t = mfcc(x, m, l, false);
if size(t, 1) < 1
    return;
end
index = linspace(1, size(t, 1), d);
index = round(index);
result = t(index, :);
if demo
    subplot(211);
    imagesc(result');
end
result = reshape(result, d * l, 1);
end