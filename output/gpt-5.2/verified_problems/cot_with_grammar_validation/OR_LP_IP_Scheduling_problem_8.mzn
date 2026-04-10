% Parameters
int: n;
array[0..n-1] of int: demand;

int: full_time_pay;
int: part_time_pay;

int: full_time_shift;
int: part_time_shift;

% Variables
array[0..n-1] of var int: start_full;
array[0..n-1] of var int: start_part;

var int: total_cost;

% Constraints
constraint forall(d in 0..n-1) (start_full[d] >= 0);
constraint forall(d in 0..n-1) (start_part[d] >= 0);

constraint full_time_shift >= 0 /\ full_time_shift <= n;
constraint part_time_shift >= 0 /\ part_time_shift <= n;

constraint forall(d in 0..n-1) (
  sum(s in 0..n-1) (start_full[s] * bool2int(((d - s + n) mod n) < full_time_shift)) +
  sum(s in 0..n-1) (start_part[s] * bool2int(((d - s + n) mod n) < part_time_shift))
  >= demand[d]
);

constraint total_cost =
  full_time_pay * full_time_shift * sum(d in 0..n-1)(start_full[d]) +
  part_time_pay * part_time_shift * sum(d in 0..n-1)(start_part[d]);

% Objective
solve minimize total_cost;