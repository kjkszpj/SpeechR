clc
dict = {'beijing', 'close', 'computer', 'dakai', 'delete', 'file', 'guanbi', 'hebei', 'henan', 'image', 'jisuanji', 'open', 'shanchu', 'shanghai', 'signal', 'speech', 'tuxiang', 'wenjian', 'xinhao', 'yuyin'};
fprintf('OK, dictionary size %d\nclc', size(dict, 2));
total = [];
for k = 1:1:20
    word = dict{k};
    fprintf('now working on %s\n', word);
    for i = 0:1:20
        id = num2str(i);
        while (size(id, 2) < 2)
        	id = ['0', id];
        end
        inf_name = ['E:\Dataset\data_4_lzj\', word, '\', word '_', id, '.mat'];
        fprintf('now fetching file name %s...\n', inf_name);
        try
            load(inf_name);
            x = x';
            while (size(x, 2) < 32000) x = [x, 0];
            end
            x = [k, x];    
            total = [total; x];
            size(total)
%             plot(x(3:end));
        catch
            fprintf('\tunable to open file %s.', inf_name);
            u = input('enter to continue...');
        end
%         pause(0.4);
    end
end
size(total)
n = input('continue...');
save('../data/data_4_lzj.mat', 'total')