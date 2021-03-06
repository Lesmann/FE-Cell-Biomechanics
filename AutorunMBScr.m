% This script runs existing model-files (inp files) automatically through windows
% command line and hanldes errors that occur during run-time.

clc, clear all, close all

frame = 1; % initialize configuration to set initial model generation for first time

%% Set source and destination paths

paths = DCR_set_paths();

display('Set Dynamic Simulation Configuration');
NOF = input('Number of frames: ');
FOP = input(' Remodelling Field Out (U=displacement; RF=Reaction Force; S=Stress(von-Mises);): ', 's');

while frame < NOF
    
    frame_str = num2str(frame);
    
    %% Create Initial model
    
    if frame == 1
        
        init_model(paths, frame_str);
        
    end
    
    job_info = simulate(paths, frame_str);
    
    %%  Remodel Last Frame According to Field Output
    
    [frame, newnodes{frame}] = Remodel(FOP, frame, paths);
    
end
