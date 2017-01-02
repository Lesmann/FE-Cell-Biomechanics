function job_info = simulate(paths, frame_str)

% This function runs the input job inp file 'job' in Abaqus and return a
% structure 'job_info' with all run-time results.

% job_info.log = run-time log file.
% job_info.status = boolean indicator for job simulation succsess/failure.
% job_info.error = error description in case of failure.

%% Initialize path

init_path(paths);

config = load(paths.src.config);
config = config.config; % fix
job = strrep(config.fn, '.inp', ''); % define matching jobs
% job = [file, '#', frame_str];
% job_info.runtime.file = file;

%% Construct and run job

job_info.runtime = run_job(job);
    
    %% Export field outputs.
    
    % fo_stat = export_fo(job);
    
    % a .export odb file
    odbfile = strcat(job, '.odb');
    exec_odb = ['abaqus job=', odbfile, ' convert=odb'];
    [job_info.odb.stat_odb, job_info.odb.cmdodb] = system(exec_odb, '-echo');
    cmdreport = ['abaqus odbreport job=', job, ' field=U', ' mode=csv'];
    [job_info.report.stat_rep, job_info.report.cmdrep] = system(cmdreport, '-echo');
    % find out how to export unique nodal output fields!!
    
    % copy field output from runtime directory to DCR field output
    % destination
    FO_file = [job, '#', frame_str, '.csv'];
    FO_src = [paths.dest.run_time, job, '.csv'];
    FO_dest = [paths.dest.FO, FO_file];
    copyfile(FO_src, FO_dest);
    
end