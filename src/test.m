for i = 1:7:400
    i
    y = x.total(i, 3:end);
    % audio_player
    epd(y);
    pause(1.2)
end