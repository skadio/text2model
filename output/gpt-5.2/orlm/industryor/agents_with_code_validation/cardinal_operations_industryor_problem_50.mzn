% Parameters
int: n_batches = 6; % number of possible shift start times (batches)
set of int: B = 1..n_batches; % batch indices

int: n_periods = 6; % number of 4-hour demand periods in 24 hours
set of int: P = 1..n_periods; % period indices

array[P] of int: demand = [10, 15, 25, 20, 18, 12]; % required nurses per period

int: shift_length_hours = 8; % each nurse works 8 hours continuously
int: period_length_hours = 4; % each demand period is 4 hours
int: periods_covered_by_shift = shift_length_hours div period_length_hours; % = 2

int: regular_pay_per_hour = 10; % yuan/hour for regular nurses
int: contract_pay_per_hour = 15; % yuan/hour for contract nurses

int: max_staff_per_batch = sum(demand); % safe upper bound per batch for decision vars

% coverage matrix: cover[p,b] = 1 if batch b covers period p (wrap-around), else 0
array[P, B] of int: cover = array2d(P, B,
[
  % b=1  b=2  b=3  b=4  b=5  b=6
     1,   0,   0,   0,   0,   1,  % p=1 (2-6): covered by 2:00 and 22:00 starts
     1,   1,   0,   0,   0,   0,  % p=2 (6-10): covered by 2:00 and 6:00
     0,   1,   1,   0,   0,   0,  % p=3 (10-14): covered by 6:00 and 10:00
     0,   0,   1,   1,   0,   0,  % p=4 (14-18): covered by 10:00 and 14:00
     0,   0,   0,   1,   1,   0,  % p=5 (18-22): covered by 14:00 and 18:00
     0,   0,   0,   0,   1,   1   % p=6 (22-2): covered by 18:00 and 22:00
]);

% Variables
array[B] of var 0..max_staff_per_batch: regular_nurses_start;  % regular nurses starting at each batch
array[B] of var 0..max_staff_per_batch: contract_nurses_start; % contract nurses starting at each batch

array[P] of var 0..(2 * max_staff_per_batch): regular_on_duty;  % regular nurses working in each period
array[P] of var 0..(2 * max_staff_per_batch): contract_on_duty; % contract nurses working in each period

var 0..(n_batches * max_staff_per_batch): total_contract_nurses; % total contract nurses hired (sum across batches)

var 0..( (n_batches * max_staff_per_batch) * shift_length_hours * contract_pay_per_hour
       + (n_batches * max_staff_per_batch) * shift_length_hours * regular_pay_per_hour ): total_cost; % total wage cost


% Constraints

% Link "on duty" counts to the start decisions via the coverage matrix
constraint
  forall(p in P) (
    regular_on_duty[p] =
      sum(b in B) (cover[p,b] * regular_nurses_start[b])
  );

constraint
  forall(p in P) (
    contract_on_duty[p] =
      sum(b in B) (cover[p,b] * contract_nurses_start[b])
  );

% Demand satisfaction: total (regular + contract) on duty must meet or exceed demand each period
constraint
  forall(p in P) (
    regular_on_duty[p] + contract_on_duty[p] >= demand[p]
  );

% Total number of contract nurses hired equals the sum of contract starts across all batches
constraint
  total_contract_nurses = sum(b in B) (contract_nurses_start[b]);

% Total cost accounting: each nurse works shift_length_hours and is paid per hour by type
constraint
  total_cost =
    shift_length_hours * regular_pay_per_hour * sum(b in B) (regular_nurses_start[b])
  + shift_length_hours * contract_pay_per_hour * sum(b in B) (contract_nurses_start[b]);


% Objective
solve minimize total_cost;