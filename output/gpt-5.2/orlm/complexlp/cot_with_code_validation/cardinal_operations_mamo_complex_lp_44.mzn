% Parameters
int: N = 7;
set of int: R = 1..N;

array[R] of int: supply = [318, 349, 129, 381, 430, 52, 124];
array[R] of int: demand = [309, 9, 279, 71, 365, 233, 483];

array[R, R] of int: cost =
[| 0,  2, 26, 19, 16, 26, 36
 | 27, 0, 26,  4, 15, 43, 25
 | 17, 45, 0, 18, 36, 37, 39
 | 19, 16, 14, 0,  5, 35,  9
 | 44, 47,  4, 3,  0,  2,  4
 | 30, 12, 28, 10, 16,  0, 25
 | 19, 16, 10, 2, 50,  4,  0
|];

% Variables: shipment from i to j
int: max_ship = sum(i in R)(supply[i]);
array[R, R] of var 0..max_ship: x;

% Constraints
constraint forall(i in R) (x[i,i] = 0);

% Outgoing shipments cannot exceed available supply
constraint forall(i in R) (
  sum(j in R) (x[i,j]) <= supply[i]
);

% Final stock in each region must meet demand:
% final_i = supply[i] + incoming - outgoing
constraint forall(i in R) (
  supply[i] + sum(j in R) (x[j,i]) - sum(j in R) (x[i,j]) >= demand[i]
);

% Objective
solve minimize sum(i in R, j in R) (cost[i,j] * x[i,j]);