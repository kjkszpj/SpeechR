load('../data/data_total.mat');
load('../data/ep_total.mat');
data = data(:, 3:end);
% 
% % epd DONE
total = [];
f_mfcc = [];
for i = 1:1:3200
    feature = [];
    y = data(i, ep(i, 1) : ep(i, 2));
    feature = [feature, f_energy(y)];
    feature = [feature, f_len(y)];
    if (feature(2) == 0)
        feature(2) = 1;
    end
    feature = [feature, f_energy(y) / f_len(y)];
    feature = [feature];
    f_mfcc = [f_mfcc; sample_mfcc(y)'];
    total = [total; feature];
end
f_mfcc = PCA(f_mfcc')';
f_mfcc = f_mfcc(:, [1, 3:end]);
total = [total, f_mfcc];