function result = normalize_data(data)
    %   get rid of hardware issue(see ypj & wqf for example)
    %   TODO, 不应该除以最大值？
    result = data;
    if max(result(1, 1:2000)) > 0.7
        result(1, 1:2700) = result(1, 31001-2700:31000);
    end
    result = result / max(abs(result));  
%     eps = 0.0222;
%     for i = 1:length(result)
%         if abs(result(i)) < eps
%             result(i) = 0;
%         end
%     end
end