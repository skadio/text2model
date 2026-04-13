% Parameters
int: P = 6; % number of 4-hour periods / possible shift start times
set of int: PERIODS = 1..P;

array[PERIODS] of int: demand = [10, 15, 25, 20, 18, 12]; % required staff per period

int: shift_len_periods = 2; % 8 hours = 2 periods of 4 hours

% Variables
array[PERIODS] of var 0..sum(demand): x; % x[p] = staff starting at period p

var 0..sum(demand): total_staff = sum(p in PERIODS)(x[p]);

% Constraints
constraint
  forall(p in PERIODS) (
    x[p] + x[((p - 2 + P) mod P) + 1] >= demand[p]
  );

% Objective
solve minimize total_staff;