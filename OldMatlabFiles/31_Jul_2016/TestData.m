function [ s_td, td ] = TestData( str, n, r, rho, E, s)

%% Generate Test Data

% Generate 2 curves (linear or non-linear) intersecting (0, 0) with slopes m1 and m2.

% Paremeters: 

% str = stress-strain relationship: 'bi-linear'=bi-linear, 'WLC'=none-linear.
% n = number of data pts to generate.
% r = stress range value.
% rho = ratio between bi-linear curves (1 - linear, 0.1 - buckling).
% E = Young's modulus.
% s = 'ne' for 'normal-elastic' elements, 'we' for 'weak-elastic' elements.
% fn = path for generated .csv file.

if strcmp(str, 'WLC')
    display(' SORRY!, WLC test data is currently UNDER CONSTRUCTION :-( ');
    return;
end

itvl = r/n; % get appropriate interval

% string of choice to generate bi-linear\non-linear test-data

sts1 = -r : itvl : 0; % create stress vector for compression, starting at 
sts2 = itvl : itvl : r; % create stress vector for tension

stn1 = -r : itvl : 0; % create strain vector for compression
stn2 = itvl : itvl : r; % create strain vector for tension

m2=1;

% m2 = r/abs(max(stn2));
% stn2 = m2*stn2;
% % s1 = s1./abs(min(s1))*r;

if strcmp(str, 'bi-linear')
    m1 = rho*m2; % rho would equal 0.1, meaning that sts1 would be the 10 times smaller comapred with stn1
    sts1 = m1*stn1;
% else
%     stn2 = power(stn1, -1/2);
%     stn1 = stn1(1 : end-1);
end
% s2 = s2./abs(max(s2))*r;

sts = [sts1, sts2];
stress = sts.*str2double(E);
strain = [stn1,stn2]; % Conjugated lines
plot(strain, stress);
xlabel('strain'), ylabel('stress [MPa]')
td = [stress; strain]';
path = 'E:\Ran\Cell-ECM model 2D 1 cell\csvFiles\';
fileName = 'TestData.csv';
fp = strcat(path, fileName);
csvwrite(fp, td);

% Prepare test-data string
if strcmp(s, 'ne')
    m = 'Normal Elastic';
else
    m = 'Weak Elastic';
end
str = '\n**\n*Material, name="';
str = strcat(str, m);
str = strcat(str, '"\n*Hyperelastic, marlow\n*Uniaxial Test Data\n');
s_td = fileread(fp);
s_td = strcat(str, s_td);
path = 'E:\Ran\Cell-ECM model 2D 1 cell\csvFiles\';
fn = strcat(s, 'td.txt');
fp = strcat(path, fn);
fid = fopen( fp, 'wt' );
fprintf(fid, s_td);
fclose(fid);

end