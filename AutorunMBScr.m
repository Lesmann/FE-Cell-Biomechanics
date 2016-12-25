% This script runs existing model-files (inp files) automatically through windows
% command line and hanldes errors that occur during run-time.

clc, clear all, close all

%% allocate runtime parameters
Completed = {};
notCompleted = {};
nc=1;
c=1;
frame = 1; % initialize configuration to set initial model generation for first time

%% Set source and destination paths

% paths = set_paths();

dest = 'DCR_Runtime\'; % runtime destination directory
src = 'E:\Ran\Cell-ECM_model_2D_1_cell\DataBase\DCR\'; % DCR source directory
DCR_runtime_dest = [src, dest];

config_src = 'E:\Ran\Cell-ECM_model_2D_1_cell\LastConfig\config.mat';
inp_src = 'E:\Ran\Cell-ECM_model_2D_1_cell\QA_models\';
ne_src = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\';
nodes_src = [ne_src, 'nodes.csv'];
elements_src = [ne_src, 'elements.csv'];

DCR_config_dest = [src, 'DCR_Config\'];
DCR_inp_dest = [src, 'DCR_inp\'];
DCR_nodes_dest = [src, 'DCR_nodes\'];
DCR_elements_dest = [src, 'DCR_elements\'];
DCR_FO_dest = [src, 'DCR_Field_Outputs\'];

base = 'E:\ '; % base path for primary initialization

display('Set Dynamic Simulation Configuration');
NOF = input('Number of frames: ');
FOP = input(' Remodelling Field Out (U=displacement; RF=Reaction Force; S=Stress(von-Mises);): ', 's');

while frame < NOF
    frame_str = num2str(frame);
    
    %% Create Initial model
    
    if frame == 1
        
        % init_model();
        
        % Create initial model (first frame)
        run modelcreation_mainscript.m
        
        % Copy configuration structure to appropriate dynamic model path and update its file
        % name by frame number (currently all similar - done for further possible use).
        
        curr_config_file = 'config#1.mat';
        DCR_config_dest = [DCR_config_dest, curr_config_file];
        copyfile(config_src, DCR_config_dest);
        
        % Copy model inp file to appropriate dynamic model path and update its file
        % name by frame number.
        
        % General path input file
        inp_src = [inp_src, config.fn];
        inp_file = strrep(config.fn, '.inp', '');
        inp_file = [inp_file, '#1.inp']; % rename model file according to frame number
        inp_dest = [DCR_inp_dest, inp_file];
        runtime_dest = [DCR_runtime_dest, inp_file];
        copyfile(inp_src, inp_dest);
        copyfile(inp_src, runtime_dest);
        
        % Copy nodes and elements to appropriate dynamic model path and update its file
        % name by frame number.
        nodes_file = 'nodes#1.csv';
        nodes_dest = [DCR_nodes_dest, nodes_file];
        copyfile(nodes_src, nodes_dest);
        
        elements_file = 'elements#1.csv';
        elements_dest = [DCR_elements_dest, elements_file];
        copyfile(elements_src, elements_dest);
        
    end
    
    %  job = simulate(job)
    
    [~, CO] = system('cd', '-echo'); % get Matlab's current path
    lcd = length(CO); % I need to generalize this
    isbase = lcd == 4;
    if ~isbase
        cd 'C:\'; % initialize Matlab's path to base (C:\)
    end
    
    % initiate Matlab's path to full path
    cd(DCR_runtime_dest)
    [stat, CO] = system('cd', '-echo'); % verify path
    
    job = strrep(config.fn, '.inp', ''); % define matching jobs
    job = [job, '#', frame_str];
    runtime_file = [job, '.inp'];
    % runtime_dest = [DCR_runtime_dest, runtime_file];
    
    % 1. construct and run job
    cmdinp = ['abaqus job=', runtime_file, ' analysis' ];
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
    
    % 3. if not completed, handle run-time errors (under construction)
    if ~isempty(error)
        % a. get error(s)
        % b. handle error(s)
        % c. re-run inp
        
        % no platfrom was yet developed to handle errors. instead, the code will continue to the next job
        notCompleted{nc} = job;
        nc=nc+1;
        display(['Abaqus JOB ', job, ' FAILED']);
        continue;
        
        % possible errors: nlgeom value
    end
    
    % 4. if job analysis is completed, open Abaqus viewer
    if ~isempty(complete)
        Completed{c} = job;
        c=c+1;
        % 5. open abaqus viewer session(optional - eliminates the
        % running Matlab session) - under construction
        % cfview = strcat('database=', currFile);
        % opv = 'abaqus viewer j';
        % cmdview = strrep(opv, 'j', cfview);
        % [stat_vi, cmdvi] = system(cmdview, '-echo');
        
        % 6. access field outputs.
        
        % a .execute odb file
        odbfile = strcat(job, '.odb');
        exec_odb = ['abaqus job=', job, ' convert=odb'];
        [stat_odb, cmdodb] = system(exec_odb, '-echo');
        cmdreport = ['abaqus odbreport job=', job, ' field=U', 'frame=', ' mode=csv'];
        [stat_rep, cmdrep] = system(cmdreport, '-echo');
        % find out how to export unique nodal output fields!!
        
        % copy field output from runtime directory to DCR field output
        % destination
        FO_file = [job, '.csv'];
        FO_src = [DCR_runtime_dest, FO_file];
        FO_dest = [DCR_FO_dest, FO_file];
        copyfile(FO_src, FO_dest);
        
    end
    
    %%  Remodel Last Frame According to Field Output
    
    [frame, newnodes{frame}] = Remodel(FOP, frame, config);
    
    if ~isbase
        cd 'C:\'; % initialize Matlab's path to base (C:\)
    end
    mp = 'E:\Ran\Cell-ECM_model_2D_1_cell\';
    cd(mp)
    
end
