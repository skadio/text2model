% Parameters
int: n;
array[0..n-1] of int: demand;

int: full_time_pay;
int: part_time_pay;

int: full_time_shift;
int: part_time_shift;

% Variables
array[0..n-1] of var 0..max(demand): start_full;
array[0..n-1] of var 0..max(demand): start_part;

array[0..n-1] of var 0..(2*max(demand)): staff_full;
array[0..n-1] of var 0..(2*max(demand)): staff_part;

% Constraints
constraint full_time_shift >= 0 /\ full_time_shift <= n;
constraint part_time_shift >= 0 /\ part_time_shift <= n;

constraint forall(d in 0..n-1) (
  staff_full[d] =
    sum(s in 0..n-1 where ((d - s + n) mod n) < full_time_shift) (start_full[s])
);

constraint forall(d in 0..n-1) (
  staff_part[d] =
    sum(s in 0..n-1 where ((d - s + n) mod n) < part_time_shift) (start_part[s])
);

constraint forall(d in 0..n-1) (
  staff_full[d] + staff_part[d] >= demand[d]
);

% Objective
solve minimize
  sum(d in 0..n-1) (full_time_pay * staff_full[d] + part_time_pay * staff_part[d]);