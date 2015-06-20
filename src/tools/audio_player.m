data = y;
if max(data(1, 1:2000)) > 0.7
	data(1, 1:2500) = data(1, 31001-2500:31000);
end
data = data ./ max(data);
re = audioplayer(data,8000);
re.play;