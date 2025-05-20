% Parameters
int: rows; % Number of programmers
int: cols; % Number of jobs
array[1..rows, 1..cols] of int: cost; % Cost matrix where each cell represents the preference value of the programmer for the job

% Variables
array[1..rows, 1..cols] of var 0..1: x; % Binary matrix representing the assignment of programmers to jobs

% Constraints

% Each programmer is assigned to exactly one job
constraint forall(i in 1..rows) (
  sum(j in 1..cols) (x[i,j]) = 1
);

% Each job is assigned to exactly one programmer
constraint forall(j in 1..cols) (
  sum(i in 1..rows) (x[i,j]) = 1
);

% The preference value of the programmer for the job is taken into account
constraint forall(i in 1..rows, j in 1..cols) (
  x[i,j] * cost[i,j] = cost[i,j]
);

% Objective
solve minimize sum(i in 1..rows, j in 1..cols) (x[i,j] * cost[i,j]);