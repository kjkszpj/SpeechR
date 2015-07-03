function result = speech(x, fs, data)
%   mine
addpath 'C:\Users\You\Documents\GitHub\SpeechR\src\feature';
addpath 'C:\Users\You\Documents\GitHub\SpeechR\src\final';
addpath 'C:\Users\You\Documents\GitHub\SpeechR\src\learning';
addpath 'C:\Users\You\Documents\GitHub\SpeechR\src\preprocess';
addpath 'C:\Users\You\Documents\GitHub\SpeechR\src\tools';
%   third party
addpath 'C:\Users\You\Documents\GitHub\SpeechR\src\lib\voicebox';
addpath 'C:\Users\You\Documents\GitHub\SpeechR\src\lib\libsvm\windows';

% default value
if nargin < 2
    fs = 8000;
end
n = size(x, 1);
ep = [];
% end point
for i = 1:n
    [i_start, i_end] = epd(x(i, :));
    ep = [ep; i_start, i_end];
end
% combine with training data
index = 1:2800;
% load('../data/data_total.mat');
t = load('../data/ep_total.mat');
load('../data/label.mat');
data = data(index, 3:end);
ep = [ep; t.ep];
% label = label(index);
fprintf('loading done, ready to generate feature\n');
% feature
% feature = gen_feature([x; data], ep);
% save('gogo.mat', 'feature');
feature = load('gogo.mat');
feature = feature.feature;
size(feature)
test_feature = feature(1:n, :);
train_feature = feature((n + 1):end, :);
model = libsvmtrain(label(1:2800), train_feature, '-s 0 -c 0.01 -t 0 -m 64');
% load('model.mat');
result = libsvmpredict(label(2801:3200), test_feature, model);
end