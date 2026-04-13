% Parameters (with values embedded)
int: n = 4;
set of int: Cities = 1..n;

int: Alpha = 1;
int: Bravo = 2;
int: Charlie = 3;
int: Delta = 4;

array[Cities, Cities] of int: cost =
  [| 0, 41, 55, 22
   | 41, 0, 47, 47
   | 55, 47, 0, 35
   | 22, 47, 35, 0 |];

% Variables
array[Cities] of var Cities: succ;   % successor city in the tour
array[Cities] of var Cities: pred;   % predecessor city in the tour
var int: total_cost;

% Constraints
constraint inverse(succ, pred);
constraint circuit(succ);

constraint total_cost = sum(i in Cities)(cost[i, succ[i]]);

% Objective
solve minimize total_cost;