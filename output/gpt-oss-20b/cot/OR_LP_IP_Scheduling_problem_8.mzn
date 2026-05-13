% Parameters
int: n;
array[0..n-1] of int: demand;
int: full_time_pay;
int: part_time_pay;
int: full_time_shift;
int: part_time_shift;

% Variables
array[0..n-1] of var 0..max(demand) : full_start;
array[0..n-1] of var 0..max(demand) : part_start;

% Constraints
constraint
  forall(d in 0..n-1) (
    sum(s in 0..n-1 where s <= d /\ d < s + full_time_shift) full_start[s] +
    sum(s in 0..n-1 where s <= d /\ d < s + part_time_shift) part_start[s] >= demand[d]
  );

% Objective
solve minimize
  sum(d in 0..n-1) (
    full_start[d] * full_time_pay * full_time_shift +
    part_start[d] * part_time_pay * part_time_shift
  );