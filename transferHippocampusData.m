function [] = transferHippocampusData()
%TRANSFERHIPPOCAMPUSDATA To be called in the hmmsort_pbs.py to be sumitted
%as a job onto PBS queue.
%
%   Detailed explanation goes here

cwd = pwd;
disp(['Processing ',cwd,'...']);

indexDay = strfind(cwd,'2018');

picassoDir = fullfile(filesep,'volume1','Hippocampus','Data','picasso');
dayToChStr = cwd(indexDay : end);
targetDir = [fullfile(picassoDir, dayToChStr),filesep];


[flag, count] = resetFlags;
while flag && count < 100
    try
        system(['ssh -p 8398 hippocampus@cortex.nus.edu.sg mkdir -p ',targetDir]);
        flag = system(['scp -P 8398 -r ./* hippocampus@cortex.nus.edu.sg:',targetDir]);
        disp('Secured copied files to target directory...');
        if ~flag
            fid = fopen(fullfile(cwd,'transferred.txt'),'w'); % to mark the channel has been successfully transferred
            fclose(fid);
	    disp('removing all the things in current directory...')
	    system('rm -rv *');
        end
    catch
        disp('Retrying...')
    end
end
disp(' ');

end

function [flag, count] = resetFlags()
flag = 1;
count = 1;
end

