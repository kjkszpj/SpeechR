%   mine
addpath 'C:\Users\You\Documents\GitHub\SpeechR\src\feature';
addpath 'C:\Users\You\Documents\GitHub\SpeechR\src\final';
addpath 'C:\Users\You\Documents\GitHub\SpeechR\src\learning';
addpath 'C:\Users\You\Documents\GitHub\SpeechR\src\preprocess';
addpath 'C:\Users\You\Documents\GitHub\SpeechR\src\tools';
%   third party
addpath 'C:\Users\You\Documents\GitHub\SpeechR\src\lib\voicebox';
addpath 'C:\Users\You\Documents\GitHub\SpeechR\src\lib\libsvm\windows';

% total_feature = [];
% for i = 61:1:3200
%     i
%     y = x.data(i, ep.ep(i, 1) : ep.ep(i, 2));
%     % audio_player
%     subplot(211);
%     feature = sample_mfcc(y)';
% %     total_feature = [total_feature; feature];
%     subplot(212);
%     melcepst(y, 8000);
%     pause(0.7);
% end

clear
clc
load('../data/feature_n.mat');
load('../data/label.mat');
tfeature = PCA(feature')';
tfeature = tfeature(:, [1:end]);
size(tfeature)
result = [];
index = randperm(size(label, 1));
[train_index, test_index] = data_split(index);
% 3d data display
for i = 10:5:100
    feature = tfeature(:, 1:i);
    %   drop the 2nd pc(person related)
    train_feature = feature(train_index, [1:end]);
    test_feature =  feature(test_index, [1:end]);
    hold on
    plot3(train_feature(:, 1), train_feature(:, 3), train_feature(:, 4), 'b.');
    plot3(test_feature(:, 1), test_feature(:, 3), test_feature(:, 4), 'ro');
    input('continue...');
    train_label = label(train_index, :);
    test_label = label(test_index, :);
    model = libsvmtrain(train_label * 1.0, train_feature, '-s 0 -c 0.01 -t 0 -m 64');
    [predict_label, accuracy, dec_values] = libsvmpredict(test_label * 1.0, test_feature, model);
    result = [result, accuracy];
end
hold on;
plot(10:5:100, result(1, :), 'b');
