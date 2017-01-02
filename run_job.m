function runtime = run_job(file)

% This function imports the input file 'file' to Abaqus and return its
% run-time information

cmdinp = ['abaqus job=', file, ' analysis' ];
[ stat_inp, cmdab ] = system(cmdinp, '-echo');

% 2. wait for the submitted job to finish
% a. wait for 2 seconds
pause(2);
logfile = [file, '.log'];
complete = [];
error = [];
compstr = ['Abaqus JOB ', file, ' COMPLETED'];
errstr = 'error';
% check status every 2 seconds
while isempty(complete) && isempty(error)
    % b. read log file
    runtime.log = fileread(logfile);
    % c. update on status
    complete = strfind(runtime.log, compstr);
    error = strfind(runtime.log, errstr);
    % in case no status has been found, wait 5 more seconds and try
    % again
    pause(2)
end

% 3. if not completed, handle run-time errors - under construction
if ~isempty(error)
    
    % a. get error(s)
    % b. handle error(s)
    % c. re-run inp
    
    % no platfrom was yet developed to handle errors. instead, the code will continue to the next job
    runtime.stat = 'Failed';
    display(['Abaqus JOB ', file, ' FAILED']);
    
else
    
    runtime.stat = 'Completed';
    display(['Abaqus JOB ', file, ' COMPLETED']);
    
    % Open abaqus viewer session- under construction
    % view.stat = open_view(file);
    
end
   
end

