function result = normalize_data(data)
    %   get rid of hardware issue(see ypj & wqf for example)
    %   TODO, ��Ӧ�ó������ֵ��
    result = data;
    if max(result(1, 1:2000)) > 0.7
        result(1, 1:2700) = result(1, 31001-2700:31000);
    end
    result = result / max(abs(result));  
end