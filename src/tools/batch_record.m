for person=22:22
    for index=17:20%sds
        for id=1:20
            name='';
            if (id==1) name='dakai'; 
            elseif (id==2) name='guanbi';
            elseif (id==3) name='shanchu';
            elseif (id==4) name='wenjian';
            elseif (id==5) name='yuyin';
            elseif (id==6) name='tuxiang';
            elseif (id==7) name='xinhao';
            elseif (id==8) name='jisuanji';
            elseif (id==9) name='shanghai';
            elseif (id==10) name='beijing';
            elseif (id==11) name='open';
            elseif (id==12) name='close';
            elseif (id==13) name='delete';
            elseif (id==14) name='file';
            elseif (id==15) name='speech';
            elseif (id==16) name='image';
            elseif (id==17) name='signal'; 
            elseif (id==18) name='computer'; 
            elseif (id==19) name='henan'; 
            elseif (id==20) name='hebei';  end;            
            ar = audiorecorder(8000,16,1);
            %record 4 seconds
            disp('Start speaking');
            fprintf('%s %d\n',name,index);
            recordblocking(ar,4.0);
            disp('End of Recording.');
            fprintf('%s %d\n',name,index);
            ar.pause;
            %get data 
            x = getaudiodata(ar); 
            plot(x);
            %ar.play;
            %save data. And you should rename filename everytime!!
            speechname=sprintf('%s%d%s%s%s%d%s','f:\\speechpj\\d\\data0',person,'\\',name,'_',index,'.mat');
            save(speechname,'x');           
        end
    end
end
%2015_Fundamentals_of_Speech_Recognition
%Please use matlab 2012b or any latest version such as 2014b. 
%It might go wrong in early version.