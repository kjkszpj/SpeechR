function result = normalize_data(data)
%   get rid of hardware issue(see ypj & wqf for example)
result = data;
for i = 1:size(data, 1)
    if mod(i, 100) == 0
        fprintf('....%d\n', i);
    end
    if max(result(i, 1:2000)) > 0.7
        result(i, 1:2700) = result(i, 31001-2700:31000);
    end
    if max(abs(result(i, :))) > 0
%   TODO, 不应该除以最大值？
        result(i, :) = result(i, :) / max(abs(result(i, :)));
    end
end
end