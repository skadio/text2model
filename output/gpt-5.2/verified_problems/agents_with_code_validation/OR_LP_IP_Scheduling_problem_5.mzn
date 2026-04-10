% Parameters
int: rows; % Number of programmers
int: cols; % Number of jobs

set of int: PROGRAMMERS = 1..rows; % Index set for programmers
set of int: JOBS = 1..cols;        % Index set for jobs

array[PROGRAMMERS, JOBS] of int: cost; % Preference/cost matrix (1 = most preferred)

% Variables
array[PROGRAMMERS, JOBS] of var 0..1: x; % x[p,j] = 1 if programmer p is assigned to job j
var int: total_preference;               % Total sum of preferences for the chosen assignments

% Constraints
% Each programmer is assigned to exactly one job
constraint forall(p in PROGRAMMERS) (
  sum(j in JOBS)(x[p, j]) = 1
);

% Each job is assigned to exactly one programmer
constraint forall(j in JOBS) (
  sum(p in PROGRAMMERS)(x[p, j]) = 1
);

% Define total preference as the sum of chosen assignment costs
constraint total_preference =
  sum(p in PROGRAMMERS, j in JOBS) (cost[p, j] * x[p, j]);

% Objective
solve minimize total_preference;