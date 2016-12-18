% Dynamic Remodelling Algorithm

% This script run the algorithm for dynamic FE remodelling.
% The idea is to move\exchange the cell's nodes with each iteration.

% Define number of steps (NOF) (i.e. number of "frames")
% If desired number of steps is not reached:

% 1. Contruct and run first model (store nodes#.csv and config#.m and rename (for frame numbering))
% 2. Get results
% 3. Remodel (store nodes#.csv and config#.m and rename (for frame numbering))
% 4. Run new model
% 5. Promote NOF

