% Parameters
int: T = 6; % number of 4-hour periods / start times
set of int: PERIODS = 1..T;
set of int: STARTS = 1..T;

array[PERIODS] of int: demand = [10, 15, 25, 20, 18, 12];

int: shift_len_periods = 2; % 8 hours = 2 periods of 4 hours
int: reg_cost_per_hour = 10;
int: con_cost_per_hour = 15;
int: hours_per_period = 4;
int: hours_per_shift = shift_len_periods * hours_per_period; % = 8

int: max_demand = max(demand);
int: max_staff_per_start = max_demand; % sufficient upper bound per start batch

% Variables
array[STARTS] of var 0..max_staff_per_start: reg_start;
array[STARTS] of var 0..max_staff_per_start: con_start;

var 0..(max_demand * T): total_reg;
var 0..(max_demand * T): total_con;

var 0..( (reg_cost_per_hour + con_cost_per_hour) * hours_per_shift * max_demand * T ): total_cost;

% Constraints
constraint
  total_reg = sum(s in STARTS)(reg_start[s]);

constraint
  total_con = sum(s in STARTS)(con_start[s]);

% Coverage: each period p is covered by starts at p and previous period (cyclic)
constraint
  forall(p in PERIODS)(
    let {
      int: prev = if p = 1 then T else p - 1 endif
    } in
      reg_start[p] + con_start[p] + reg_start[prev] + con_start[prev] >= demand[p]
  );

constraint
  total_cost =
    hours_per_shift * (
      reg_cost_per_hour * total_reg +
      con_cost_per_hour * total_con
    );

% Objective
solve minimize total_cost;