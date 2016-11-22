% This script runs existing model-files (inp files) automatically through windows
% command line and hanldes errors that occur during run-time.

clc, clear all, close all

dest = '\QA_models\'; % destination directory
src = 'E:\Ran\Cell-ECM_model_2D_1_cell\'; % source directory
fp = strcat(src, dest); % full path
files = dir(fp); % get path's details
lf = length(files);
base = 'C:\ '; % base path for primary initialization

% allocate runtime parameters
Completed = {};
notCompleted = {};
nc=1;
c=1;

[stat, CO] = system('cd', '-echo'); % get Matlab's current path
lcd = length(CO);
isbase = lcd == 4;
if ~isbase
    cd 'C:\'; % initialize Matlab's path to base (C:\)
end

for i = 1 : lf
    
    isinp = strfind(files(i).name, '.inp');
    % skip none-files or none-inp-files
    if files(i).isdir == 1 || isempty(isinp)
        continue;
    end
    
    % initiate Matlab's path to full path
    cd(fp)
    [stat, CO] = system('cd', '-echo'); % verify path
    
    input = files(i).name; % get inp file names
    job = strrep(input, '.inp', ''); % define matching jobs
    
    % 1. construct and run job
    cmdinp = ['abaqus job=', input, ' analysis' ];
    [stat_inp, cmdab] = system(cmdinp, '-echo');
    tic
    % 2. wait for the submitted job to finish
    % a. wait for 2 seconds
    pause(2);
    logfile = strcat(job, '.log');
    msgFile = strcat(job, '.msg');
    complete = [];
    error = [];
    compstr = ['Abaqus JOB ', job, ' COMPLETED'];
    errstr = 'error';
    % check status every 2 seconds
    while isempty(complete) && isempty(error)
        % b. read log file
        log = fileread(logfile);
        if toc < 5
            pause(15);
        end
        msg = fileread(msgFile);
        % c. update on status
        complete = strfind(log, compstr);
        error = strfind(log, errstr);
        % in case no status has been found, wait 5 more seconds and try
        % again
        pause(2)
    end
    
    % 3. if not completed, handle run-time errors (under construction)
    if ~isempty(error)
        csvFile = strcat(input, '.csv');
        csvFile = strcat(fp, csvFile);
        delete(csvFile);
        convergence_failure = 'TIME INCREMENT REQUIRED IS LESS THAN THE MINIMUM SPECIFIED';
        % a. get error(s)
        % if error is a convergence error
        conv_error = strfind(msg, convergence_failure);
        % b. handle error(s)
        if ~isempty(conv_error)
            
            % apply damping factor of 0.05
            fn = strcat(fp, input);
            inp = fileread(input);
            str1 = '*Step, name=Step-1, nlgeom=YES, inc=1000';
            str2 = '0.01, 1., 1e-08, 1.';
            stabilize = '*Static, stabilize, factor=0.05, allsdtol=0, continue=NO';
            Splt_n_Push(fn, inp, stabilize, str1, str2);
            [stat_inp, cmdab] = system(cmdinp, '-echo');
            
            % 2. wait for the submitted job to finish
            % a. wait for 2 seconds
            pause(2);
            logfile = strcat(job, '.log');
            complete = [];
            error = [];
            compstr = ['Abaqus JOB ', job, ' COMPLETED'];
            errstr = 'error';
            % check status every 2 seconds
            while isempty(complete) && isempty(error)
                % b. read log file
                log = fileread(logfile);
                % c. update on status
                complete = strfind(log, compstr);
                error = strfind(log, errstr);
                % in case no status has been found, wait 5 more seconds and try
                % again
                pause(2)
            end
        end
        % c. re-run inp
        
        % no platfrom was yet developed to handle errors. instead, the code will continue to the next job
        notCompleted{nc} = job;
        nc=nc+1;
        display(['Abaqus JOB ', job, ' FAILED']);
        continue;
        
        
        % possible errors: nlgeom value,
    end
    
    % 4. if job analysis is completed, open Abaqus viewer
    if ~isempty(complete)
        Completed{c} = job;
        c=c+1;
        % 5. open abaqus viewer session(optional - eliminates the running Matlab session)
        % cfview = strcat('database=', currFile);
        % opv = 'abaqus viewer j';
        % cmdview = strrep(opv, 'j', cfview);
        % [stat_vi, cmdvi] = system(cmdview, '-echo');
        
        % 6. access field outputs.
        
        % a .execute odb file
        odbfile = strcat(job, '.odb');
        exec_odb = ['abaqus job=', job, ' convert=odb'];
        [stat_odb, cmdodb] = system(exec_odb, '-echo');
        cmdreport = ['abaqus odbreport job=', job, ' field=U', ' mode=csv'];
        [stat_rep, cmdrep] = system(cmdreport, '-echo');
        
    end
    
    % 7. run analysis script and generate graphs
    if ~isbase
        cd 'C:\'; % initialize Matlab's path to base (C:\)
    end
    mp = 'E:\Ran\Cell-ECM_model_2D_1_cell\';
    cd(mp)
    
end

[mUr] = Autorunalysis(fp);
RunTime = struct('Completed', Completed, 'NotCompleted', notCompleted);
