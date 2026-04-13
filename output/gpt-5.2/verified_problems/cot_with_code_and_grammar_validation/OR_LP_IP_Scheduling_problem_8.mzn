% Parameters
int: n;
array[0..n-1] of int: demand;

int: full_time_pay;
int: part_time_pay;

int: full_time_shift;
int: part_time_shift;

set of int: DAYS = 0..n-1;

% Variables
array[DAYS] of var 0..max(demand): start_full;
array[DAYS] of var 0..max(demand): start_part;

array[DAYS] of var 0..(2 * max(demand)): working_full;
array[DAYS] of var 0..(2 * max(demand)): working_part;

var 0..(n * max(demand) * max(full_time_pay, part_time_pay)): total_cost;

% Constraints
constraint full_time_shift >= 1 /\ full_time_shift <= n;
constraint part_time_shift >= 1 /\ part_time_shift <= n;

constraint
forall(d in DAYS) (
  working_full[d] =
    sum(s in DAYS where ((d - s + n) mod n) < full_time_shift)( start_full[s] )
);

constraint
forall(d in DAYS) (
  working_part[d] =
    sum(s in DAYS where ((d - s + n) mod n) < part_time_shift)( start_part[s] )
);

constraint
forall(d in DAYS) (
  working_full[d] + working_part[d] >= demand[d]
);

constraint
total_cost =
  full_time_pay * sum(d in DAYS)(working_full[d]) +
  part_time_pay * sum(d in DAYS)(working_part[d]);

% Objective
solve minimize total_cost;