addpath 'C:\Users\You\Documents\GitHub\SpeechR\src\lib\voicebox';

for i = 1:1:400
    i
    y = x.total(i, 3:end);
    % audio_player
    epd(y);
    pause(0.2);
end