% Parameters
int: rows; % Number of programmers
int: cols; % Number of jobs
array[1..rows, 1..cols] of int: cost; % Cost matrix

% Variables
array[1..rows, 1..cols] of var 0..1: x; % Binary matrix representing the assignment of programmers to jobs

% Constraints
% Each programmer is assigned to exactly one job
constraint forall(i in 1..rows)(sum(j in 1..cols)(x[i,j]) = 1);

% Each job is assigned to exactly one programmer
constraint forall(j in 1..cols)(sum(i in 1..rows)(x[i,j]) = 1);

% Objective
% Minimize the sum of the preferences of the programmers to the jobs they are assigned
solve minimize sum(i in 1..rows, j in 1..cols)(x[i,j]*cost[i,j]);