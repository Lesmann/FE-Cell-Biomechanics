function [ ch ] = return2base( base )

% This function checks if current Matlab's source-directory is the path
% defined by 'base'. 
% if not, this function initializes is to 'base'.
% This function returns a boolean variable 'ch'.
% in case the source-directory was changed back to 'base', the function returns
% False. in case the source-directory is already set to 'base', thif function
% returns True.

[~, CO] = system('cd', '-echo'); % get Matlab's current source-directory
isbase = strcmp(CO, base);
if ~isbase
    cd(base); % initialize Matlab's path to base
    ch = true;
else
    ch = false;
end


end

