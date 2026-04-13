% Parameters (with values embedded)
int: N = 4;
set of int: Cities = 1..N;

array[Cities, Cities] of int: cost =
  [|  0, 17, 25, 31
   | 17,  0, 93, 45
   | 25, 93,  0, 95
   | 31, 45, 95,  0 |];

% Variables
array[Cities] of var Cities: succ;          % successor city in the tour
array[Cities] of var 0..1: arc[Cities, Cities]; % arc[i,j] = 1 iff go from i to j
var 0..100000: total_cost;

% Constraints
constraint
  forall(i in Cities) (
    succ[i] != i
  );

constraint
  circuit(succ);

constraint
  forall(i in Cities, j in Cities) (
    arc[i,j] = bool2int(succ[i] == j)
  );

constraint
  total_cost = sum(i in Cities, j in Cities)(cost[i,j] * arc[i,j]);

% Objective
solve minimize total_cost;