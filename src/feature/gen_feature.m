function result = gen_feature(data, ep, train_label, test_label)
fprintf('start generating...');
% default value

% fill ep
n = size(data, 1);
total = [];
f_mfcc = [];
for i = 1:n
    if mod(i, 100) == 0
        fprintf('\t%d\n', i);
    end
    feature = [];
    y = data_cut(data(i, :), ep(i, 1), ep(i, 2));
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
f_mfcc = PCA(f_mfcc')';
f_mfcc = drop_feature(f_mfcc, train_label, test_label);
total = [total, f_mfcc];
total = PCA(total')';
total = drop_feature(total, train_label, test_label);
result = total;
end