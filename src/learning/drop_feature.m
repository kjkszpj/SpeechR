function result = drop_feature(data, train_label, test_label);
train_feature = data(train_label, :);
test_feature = data(test_label, :);
temp = mean(train_feature, 1) - mean(test_feature, 1);
temp = temp .* temp;
var1 = sqrt(var(train_feature, [], 1));
var2 = sqrt(var(test_feature, [], 1));
temp = (temp ./ var1) ./var2;
[u, index] = sort(temp, 2, 'descend');
cnt = 0;
while index(1, 1) > 1.2 && cnt < 2
%     temp(1, index(1, 1))
%     index(1, 1)
    index = index(1, 2:end);
    cnt = cnt + 1;
%     input('...');
end
index = sort(index);
result = data(:, index);
end