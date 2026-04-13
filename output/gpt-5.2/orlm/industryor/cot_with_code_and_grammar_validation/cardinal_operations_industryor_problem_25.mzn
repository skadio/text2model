% Parameters
int: T = 6;
set of int: TIMES = 1..T;

array[TIMES] of int: req = [10, 15, 25, 20, 18, 12];  % required staff per 4-hour period

int: shift_len = 2; % 8 hours = 2 consecutive 4-hour periods

% Variables
array[TIMES] of var 0..max(req): start; % number starting at each time

var 0..sum(req): total_staff;

% Constraints
constraint total_staff = sum(t in TIMES)(start[t]);

% Coverage: each period t is covered by those starting at t and the previous period
constraint forall(t in TIMES)(
  start[t] + start[ if t = 1 then T else t - 1 endif ] >= req[t]
);

% Objective
solve minimize total_staff;