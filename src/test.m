for i = 1:1:400
    i
    y = x.total(i, 3:end);
    % audio_player
    t(y);
    pause(1.2)
end