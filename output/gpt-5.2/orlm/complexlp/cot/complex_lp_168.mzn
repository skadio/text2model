% Parameters (with values embedded)
int: NCenters = 4;
int: NOutlets = 4;

set of int: Centers = 1..NCenters;
set of int: Outlets = 1..NOutlets;

array[Centers] of int: open_cost = [151000, 192000, 114000, 171000];
array[Centers] of int: capacity  = [1547, 1656, 1274, 1882];
array[Outlets] of int: demand    = [859, 713, 421, 652];

array[Centers, Outlets] of int: trans_cost =
  [| 5, 5, 2, 3
   | 3, 3, 5, 4
   | 3, 5, 2, 4
   | 2, 4, 5, 1 |];

% Variables
array[Centers] of var 0..1: open;
array[Centers, Outlets] of var 0..max(demand): ship;

% Constraints
constraint
  forall(j in Outlets) (
    sum(i in Centers)(ship[i,j]) = demand[j]
  );

constraint
  forall(i in Centers) (
    sum(j in Outlets)(ship[i,j]) <= capacity[i] * open[i]
  );

% Objective
var int: total_cost =
  sum(i in Centers)(open_cost[i] * open[i]) +
  sum(i in Centers, j in Outlets)(trans_cost[i,j] * ship[i,j]);

solve minimize total_cost;