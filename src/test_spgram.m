addpath 'C:\Users\You\Documents\GitHub\SpeechR\src\lib\voicebox';
result = [];
for i = 1:6:400
    i
    y = x.total(i, 3 : end);
    % audio_player
    [u, u, y] = epd(y);
    spgrambw(y, 8000, 'PJcwm', 50, [0 2333]);
	pause(1.2);
end