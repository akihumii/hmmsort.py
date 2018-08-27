function [] = transferHippocampusData()
%TRANSFERHIPPOCAMPUSDATA To be called in the hmmsort_pbs.py to be sumitted
%as a job onto PBS queue.
%
%   Detailed explanation goes here

cwd = pwd;

dataName = strrep(cwd,filesep,'_');
fileName = [dataName,'.tar.gz']; % tar.gz name

indexDay = strfind(cwd,'2018');

picassoDir = fullfile(filesep,'volume1','Hippocampus','Data','picasso');
dayStr = cwd(indexDay:indexDay+7);
dayToChStr = cwd(indexDay : end);
targetDir = [fullfile(picassoDir, dayToChStr),filesep];

sshHippocampus = 'ssh -p 8398 hippocampus@cortex.nus.edu.sg';

[flag, count] = resetFlags;
while flag && count < 100
    try
        system(['ssh -p 8398 hippocampus@cortex.nus.edu.sg mkdir -p ',targetDir]);
        flag = system(['scp -P 8398 -r ./* hippocampus@cortex.nus.edu.sg:',targetDir]);
        disp(['Secured copied files to target directory...']);
        if ~flag
            fid = fopen(fullfile(cwd,'transferred.txt'),'w'); % to mark the channel has been successfully transferred
            fclose(fid);
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

