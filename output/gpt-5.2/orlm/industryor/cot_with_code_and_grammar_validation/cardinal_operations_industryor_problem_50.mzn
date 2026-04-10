% Parameters
int: P = 6; % number of 4-hour demand periods / shift start times
set of int: PERIODS = 1..P;

array[PERIODS] of int: demand = [10, 15, 25, 20, 18, 12]; % required nurses per period

int: shift_len_periods = 2; % 8 hours = 2 demand periods of 4 hours each
int: wage_regular = 10;     % yuan/hour
int: wage_contract = 15;    % yuan/hour
int: hours_per_period = 4;
int: hours_per_shift = 8;

% Upper bound: in worst case, meet each period demand with starts in that period alone
int: ub_start = max(demand);

% Variables
array[PERIODS] of var 0..ub_start: reg_start;
array[PERIODS] of var 0..ub_start: con_start;

array[PERIODS] of var 0..(2*ub_start): total_on_duty;

var int: total_cost;

% Constraints
constraint
  forall(p in PERIODS) (
    total_on_duty[p] =
      reg_start[p] + con_start[p] +
      reg_start[ if p = 1 then P else p-1 endif ] +
      con_start[ if p = 1 then P else p-1 endif ]
  );

constraint
  forall(p in PERIODS) (
    total_on_duty[p] >= demand[p]
  );

constraint
  total_cost =
    (wage_regular * hours_per_shift) * sum(p in PERIODS)(reg_start[p]) +
    (wage_contract * hours_per_shift) * sum(p in PERIODS)(con_start[p]);

% Objective
solve minimize total_cost;