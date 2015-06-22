addpath 'C:\Users\You\Documents\GitHub\SpeechR\src\feature';
addpath 'C:\Users\You\Documents\GitHub\SpeechR\src\learning';
addpath 'C:\Users\You\Documents\GitHub\SpeechR\src\lib\voicebox';
addpath 'C:\Users\You\Documents\GitHub\SpeechR\src\preprocess';
addpath 'C:\Users\You\Documents\GitHub\SpeechR\src\tools';

for i = 1:10:3200
    i
    y = x.data(i, 3 : end);
    % audio_player
    imagesc(mfcc(y));
    pause(1.2);
    [u, u, y] = epd(y, false);
%     spgrambw(y, 8000, 'PJcwm', 50, [0 2333]);
	pause(0.3);
end