function [] = Splt_n_Push( fn, inp, data, str1, str2 )

% Split and parse .inp file into 2 halves

Half1 = strsplit(inp, str1);
if length(Half1)~=2
    display('Half1: multiple strings or no strings at all of the form:')
    display( [str1, ' has been found in: ', fn]);
    dbstop in Splt_n_Push;
end
str1 = strcat('\n', str1);
str1 = strcat(str1, '\n');
Half1 = strcat(Half1{1}, str1);

%% Push nodes into 1st half

Half1 = strcat(Half1, data); 
Half2 = strsplit(inp, str2);
if length(Half2)~=2
    display('Half1: multiple strings or no strings at all of the form:')
    display( [str1, ' has been found in: ', fn]);
    dbstop in Splt_n_Push;
end
str2 = strcat('\n', str2);
Half2 = strcat(str2, Half2{2});

%% Assemble 2nd half

newInp = strcat(Half1, Half2);
fid = fopen(fn, 'wt');
fprintf(fid, newInp); % write nodes into file
fclose(fid);

end

