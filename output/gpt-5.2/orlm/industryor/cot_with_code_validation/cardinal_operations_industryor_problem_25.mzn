% Parameters
int: P = 6; % number of 4-hour periods in 24 hours
set of int: PERIODS = 1..P;

array[PERIODS] of int: demand = [10, 15, 25, 20, 18, 12]; % required staff per period

int: shift_len_periods = 2; % 8 hours = 2 periods of 4 hours

% Variables
array[PERIODS] of var 0..sum(demand): start; % number starting at each shift start time

var 0..sum(demand): total_staff = sum(p in PERIODS)(start[p]);

% Constraints
constraint
  forall(p in PERIODS)(
    start[p] >= 0
  );

constraint
  forall(p in PERIODS)(
    start[p] + start[ if p = 1 then P else p - 1 endif ] >= demand[p]
  );

% Objective
solve minimize total_staff;