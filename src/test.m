
%   mine
addpath 'C:\Users\You\Documents\GitHub\SpeechR\src\feature';
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

% [heart_scale_label, heart_scale_inst] = libsvmread('heart_scale');
% model = libsvmtrain(heart_scale_label, heart_scale_inst, '-c 1 -g 0.07');
% [predict_label, accuracy, dec_values] = libsvmpredict(heart_scale_label, heart_scale_inst, model);
clear
clc
load('../data/feature.mat');
tfeature = PCA(feature')';
size(tfeature)
result = [];
for i = 10:10:200
feature = tfeature(:, 1:i);
load('../data/label.mat');
index = randperm(size(label, 1));
train_index = 1:2400;
test_index = 2401:3200;
% train_index = 1:2800;
% test_index = 2800:3200;
train_feature = feature(train_index, :);
test_feature = feature(test_index, :);
train_label = label(train_index, :);
test_label = label(test_index, :);
model = libsvmtrain(train_label * 1.0, train_feature, '-s 0 -c 0.1 -t 0');
[predict_label, accuracy, dec_values] = libsvmpredict(test_label * 1.0, test_feature, model);
result = [result, accuracy];
end
plot(result(1, :));