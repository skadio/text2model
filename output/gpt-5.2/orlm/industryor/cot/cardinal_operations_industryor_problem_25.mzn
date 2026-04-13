% Parameters (with values embedded)
int: N = 6; % number of 4-hour periods / possible shift start times

set of int: P = 1..N; % periods: 1=2-6, 2=6-10, 3=10-14, 4=14-18, 5=18-22, 6=22-2
array[P] of int: demand = [10, 15, 25, 20, 18, 12];

% Each shift lasts 8 hours = 2 consecutive 4-hour periods.
% Coverage matrix: cover[p,s] = 1 if a shift starting at s covers period p.
array[P, P] of int: cover =
[
  % s=1 2 3 4 5 6
    1, 0, 0, 0, 0, 1,   % p=1 (2-6) covered by shifts starting at 2 and 22
    1, 1, 0, 0, 0, 0,   % p=2 (6-10) covered by shifts starting at 2 and 6
    0, 1, 1, 0, 0, 0,   % p=3 (10-14) covered by shifts starting at 6 and 10
    0, 0, 1, 1, 0, 0,   % p=4 (14-18) covered by shifts starting at 10 and 14
    0, 0, 0, 1, 1, 0,   % p=5 (18-22) covered by shifts starting at 14 and 18
    0, 0, 0, 0, 1, 1    % p=6 (22-2) covered by shifts starting at 18 and 22
];

% Variables
array[P] of var 0..sum(demand): x; % x[s] = number of salespeople starting at time s

% Constraints
constraint
  forall(p in P) (
    sum(s in P)(cover[p,s] * x[s]) >= demand[p]
  );

% Objective
solve minimize sum(s in P)(x[s]);