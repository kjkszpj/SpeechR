function [train_label, test_label] = data_split(index)
train_label = [1:2400, 2801:3200];
test_label = [];
for i = 1:3200
    if sum(train_label == i) == 0
        test_label = [test_label, i];
    end
end
end