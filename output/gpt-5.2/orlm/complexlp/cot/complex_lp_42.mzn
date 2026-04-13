% Parameters (with values embedded)
int: N = 7;
set of int: W = 1..N;

array[W] of int: initial = [57, 180, 288, 255, 477, 222, 314];
array[W] of int: required = [499, 173, 293, 158, 15, 78, 278];

% cost[i,j] = cost to move 1 unit from warehouse i to warehouse j
array[W, W] of int: cost =
[| 0, 36, 36, 48, 10, 20, 48
 | 28, 0, 16, 18, 36, 42, 12
 | 6, 40, 0, 49, 31, 1, 46
 | 14, 22, 4, 0, 9, 12, 1
 | 50, 44, 7, 48, 0, 7, 25
 | 26, 9, 33, 38, 8, 0, 30
 | 8, 9, 2, 13, 8, 49, 0 |];

% Variables
% flow[i,j] = units moved from i to j (no self-moves)
array[W, W] of var 0..max(initial): flow;

% Constraints
constraint forall(i in W)(flow[i,i] = 0);

% Flow conservation to meet exact required amounts:
% initial[i] - outflow(i) + inflow(i) = required[i]
constraint
  forall(i in W)(
    initial[i]
    - sum(j in W)(flow[i,j])
    + sum(j in W)(flow[j,i])
    = required[i]
  );

% Objective
var int: total_cost = sum(i in W, j in W)(cost[i,j] * flow[i,j]);

solve minimize total_cost;