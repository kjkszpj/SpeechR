function result = speech(x, fs, data, test_label, dim)
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
if nargin < 3
    fprintf('load training data...\n');
    load('../data/data_total.mat');
    fprintf('DONE\n')
end
if nargin < 4
    test_label = zeros(size(x, 1), 1);
end
if nargin < 5
    dim = 66
end

n = size(x, 1);
ep = [];
% end point
for i = 1:n
    [i_start, i_end] = epd(x(i, :));
%     plot(x(i, i_start:i_end));
%     pause(0.1);
%     if i_end - i_start > 6000
%         input('...');
%     end
    ep = [ep; i_start, i_end];
end
x = normalize_data(x);
data = normalize_data(data);
% combine with training data
index = 1:3200;
t = load('../data/ep_total.mat');
load('../data/label.mat');
data = data(index, 3:end);
ep = [ep; t.ep];
fprintf('loading done, ready to generate feature\n');
[train_label, test_label] = data_split(label);
feature = gen_feature([x; data], ep, train_label, test_label);
save('gogo.mat', 'feature');
% feature = load('gogo.mat');
% feature = feature.feature;
feature = feature(:, 1:dim);
size(feature)
test_feature = feature(test_label, :);
train_feature = feature(train_label, :);

plot3(train_feature(:, 1), train_feature(:, 2), train_feature(:, 3), 'b.');
hold on
plot3(test_feature(:, 1), test_feature(:, 2), test_feature(:, 3), 'r.');

model = libsvmtrain(label(train_label), train_feature, '-s 0 -c 0.01 -t 0 -m 64');
% load('model.mat');
result = libsvmpredict(label(test_label), test_feature, model);
result = [];
end