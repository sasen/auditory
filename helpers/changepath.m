dirname = '~/toolboxes/';  % directory to add to matlab path WITH SUBDIRECTORIES
ptbox = genpath(dirname); % generate subdirectories, separated by pathsep
path(path,ptbox);  % gets current path, appends new stuff
successflag = savepath  % save for next time