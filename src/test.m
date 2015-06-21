addpath 'C:\Users\You\Documents\GitHub\SpeechR\src\lib\voicebox';
result = [];
for i = 1:1:3200
    i
    y = x.data(i, 4:end);
    % audio_player
    [st, fi] = epd(y);
    result = [result; st, fi];
end