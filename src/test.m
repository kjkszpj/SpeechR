addpath 'C:\Users\You\Documents\GitHub\SpeechR\src\feature';
addpath 'C:\Users\You\Documents\GitHub\SpeechR\src\learning';
addpath 'C:\Users\You\Documents\GitHub\SpeechR\src\lib\voicebox';
addpath 'C:\Users\You\Documents\GitHub\SpeechR\src\preprocess';
addpath 'C:\Users\You\Documents\GitHub\SpeechR\src\tools';

for i = 1:1:8
    for j = 1:1:20
        [i, j]
    y = x.data(i * 400 - 400 + j, 3 : end);
    % audio_player
    [u, u, y] = epd(y, false);
    u = sample_mfcc(y);
%     spgrambw(y, 8000, 'PJcwm', 50, [0 2333]);
	pause(0.7);
    end
    audio_player
    input('continue...');
end