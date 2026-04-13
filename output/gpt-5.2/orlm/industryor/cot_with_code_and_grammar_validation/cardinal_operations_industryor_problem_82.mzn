% Parameters
int: N = 6; % number of 4-hour demand periods in 24 hours
set of int: P = 1..N;

% Demand per 4-hour period (2-6, 6-10, 10-14, 14-18, 18-22, 22-2)
array[P] of int: demand = [4, 8, 10, 7, 12, 4];

% A shift is 8 hours = 2 consecutive 4-hour periods
int: L = 2;

% Variables
array[P] of var 0..sum(demand): x; % x[p] = number of waiters starting at period p
var 0..sum(demand): total_waiters = sum(p in P)(x[p]);

% Constraints
constraint
  forall(p in P)(
    x[p] >= 0
  );

% Coverage: for each period p, those who started in p or in previous period (cyclic) cover it
constraint
  forall(p in P)(
    x[p] + x[ if p = 1 then N else p - 1 endif ] >= demand[p]
  );

% Objective
solve minimize total_waiters;