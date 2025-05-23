include "globals.mzn";

% Number of departments
int: K;
% Number of possible locations
int: L;

% Benefit of department k being located at location l
array[1..K, 1..L] of int: Benefit;
% Communication costs between departments k and j
array[1..K, 1..K] of float: Communication;
% Cost of locating at location l with requirement m
array[1..L, 1..L] of int: Cost;

% Decision variable: location of each department
array[1..K] of var 1..L: location;

% Constraint: None of the cities (including London) may be the location for more than three of the departments
constraint forall(l in 1..L) (
  sum(k in 1..K) (location[k] = l) <= 3
);

% Objective: Minimize overall yearly cost
var float: total_cost;
constraint total_cost = sum(k in 1..K, l in 1..L) (
  if location[k] = l then -Benefit[k, l] else 0 endif
) + sum(k in 1..K, j in 1..K, l in 1..L, m in 1..L) (
  if location[k] = l /\ location[j] = m then Communication[k, j] * Cost[l, m] else 0 endif
);
solve minimize total_cost;

% Output
output [ "Department " ++ show(k) ++ " should be located in city " ++ show(location[k]) ++ "\n" | k in 1..K ];