% Parameters
int: N = 5;
set of int: R = 1..N;

array[R] of int: supply = [120, 330, 400, 400, 600];
array[R] of int: demand = [150, 200, 600, 200, 400];

% Cost matrix (0 on diagonal; large number for disallowed arcs)
int: BIG = 1000000;
array[R, R] of int: cost =
  array2d(R, R,
  [
    0,   BIG, 13, 11, 28,
    BIG, 0,   18, 8,  46,
    BIG, BIG, 0,  9,  27,
    BIG, BIG, BIG, 0,  20,
    BIG, BIG, BIG, BIG, 0
  ]);

% Allowed arcs: only i<j as given in statement
array[R, R] of bool: allowed =
  array2d(R, R,
  [
    false, false, true,  true,  true,
    false, false, true,  true,  true,
    false, false, false, true,  true,
    false, false, false, false, true,
    false, false, false, false, false
  ]);

int: total_supply = sum(i in R)(supply[i]);
int: total_demand = sum(i in R)(demand[i]);

% Variables
array[R, R] of var 0..max(total_supply, total_demand): x;

var 0..(max(cost) * max(total_supply, total_demand) * N * N): total_cost;

% Constraints
constraint total_supply = total_demand;

constraint
  forall(i in R, j in R)(
    (not allowed[i,j]) -> (x[i,j] = 0)
  );

constraint
  forall(i in R)(
    supply[i] + sum(j in R)(x[j,i]) - sum(j in R)(x[i,j]) = demand[i]
  );

constraint
  total_cost = sum(i in R, j in R)(cost[i,j] * x[i,j]);

% Objective
solve minimize total_cost;