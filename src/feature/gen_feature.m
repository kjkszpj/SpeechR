function result = gen_feature(data, ep, dim, saved);
% default value
if nargin < 3
    dim = 66;
end
if nargin < 4
    saved = false;
end

% fill ep
n = size(data, 1);
total = [];
f_mfcc = [];
for i = 1:n
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
fprintf('feature generate......DONE\n');
if saved
    f_mfcc = load_PCA(f_mfcc', 'mPCA.mat')';
    f_mfcc = f_mfcc(:, [1, 3:end]);
    total = [total, f_mfcc];
    total = load_PCA(total', 'fPCA.mat')';
    total = total(:, 1:dim);
else
    f_mfcc = PCA(f_mfcc')';
    f_mfcc = f_mfcc(:, [1, 3:end]);
    total = [total, f_mfcc];
    total = PCA(total')';
    total = total(:, 1:dim);
end
result = total;
end