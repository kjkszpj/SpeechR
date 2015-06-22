function result = sample_mfcc(x, d, l, m, demo)
%   mfcc itself is VARLEN data, uniform sample it to get a d * l dimension
%   vector
if nargin < 2
    d = 20;
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

t = mfcc(x, m, l, false);
index = linspace(1, size(t, 1), d);
index = round(index);
result = t(index, :);
if demo
    imagesc(result);
end
result = reshape(result, d * l, 1);
end