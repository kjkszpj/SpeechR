batch_name = {'data_1_ypj', 'data_2_wqf', 'data_3_zzd', 'data_5_wwy', 'data_6_zmy', 'data_7_lq', 'data_8_zjd', 'data_9_sb1'};
batch_cnt = size(batch_name, 2);
data = [];
for i = 1:1:batch_cnt
    load(['../data/', batch_name{i}]);
    size(total)
    word_flag = total(:, 1);
    total = total(:, 2:end);
    size(total);
    miu = 1 ./ max(total');
    total = total' * diag(miu);
    total = total';
    name_flag = ones(size(word_flag, 1), 1) * i;
    total = [name_flag, word_flag, total];
    data = [data; total];
    pause(0.01);
end
save('../data/data_total.mat', 'data')
