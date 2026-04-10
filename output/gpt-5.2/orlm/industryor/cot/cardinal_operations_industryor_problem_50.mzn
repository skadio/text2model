% Parameters (with values embedded)
int: B = 6; % number of shift start batches / time periods
set of int: Batches = 1..B;

% Periods: [2-6], [6-10], [10-14], [14-18], [18-22], [22-2]
array[Batches] of int: demand = [10, 15, 25, 20, 18, 12];

int: shift_length_periods = 2; % 8 hours = 2 consecutive 4-hour periods

int: wage_regular_per_hour = 10;
int: wage_contract_per_hour = 15;
int: hours_per_shift = 8;

int: cost_regular_shift = wage_regular_per_hour * hours_per_shift;   % 80
int: cost_contract_shift = wage_contract_per_hour * hours_per_shift; % 120

% Variables
array[Batches] of var 0..sum(demand): R; % regular nurses starting at each batch
array[Batches] of var 0..sum(demand): C; % contract nurses starting at each batch

% Constraints
% Coverage: each period is covered by nurses who started this period or previous period (cyclic wrap)
constraint
  forall(t in Batches) (
    let {
      int: prev = if t = 1 then B else t - 1 endif
    } in
      (R[t] + C[t] + R[prev] + C[prev] >= demand[t])
  );

% Objective
var int: total_cost = sum(t in Batches)(cost_regular_shift * R[t] + cost_contract_shift * C[t]);
solve minimize total_cost;