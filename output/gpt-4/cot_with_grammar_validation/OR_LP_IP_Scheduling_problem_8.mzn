% Parameters
int: n;
array[0..n-1] of int: demand;
int: full_time_pay;
int: part_time_pay;
int: full_time_shift;
int: part_time_shift;

% Variables
array[0..n-1] of var 0..n: full_time_workers;
array[0..n-1] of var 0..n: part_time_workers;

% Constraints
constraint forall(i in 0..n-1) (
  sum(j in max(0, i-full_time_shift+1)..i) (full_time_workers[j]) +
  sum(j in max(0, i-part_time_shift+1)..i) (part_time_workers[j]) >= demand[i]
);

% Objective
var int: total_cost = sum(i in 0..n-1) (full_time_workers[i]*full_time_pay + part_time_workers[i]*part_time_pay);
solve minimize total_cost;