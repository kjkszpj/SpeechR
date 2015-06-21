addpath 'C:\Users\You\Documents\GitHub\SpeechR\src\feature';
addpath 'C:\Users\You\Documents\GitHub\SpeechR\src\learning';
addpath 'C:\Users\You\Documents\GitHub\SpeechR\src\lib\voicebox';
addpath 'C:\Users\You\Documents\GitHub\SpeechR\src\preprocess';
addpath 'C:\Users\You\Documents\GitHub\SpeechR\src\tools';

result = [];
for i = 1:1:400
    i
    y = x.total(i, 3 : end);
    % audio_player
    [u, u, y] = epd(y, false);
    spgrambw(y, 8000, 'PJcwm', 50, [0 2333]);
 	pause(1.2);
end