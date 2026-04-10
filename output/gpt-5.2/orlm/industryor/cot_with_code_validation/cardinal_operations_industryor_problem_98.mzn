% Parameters
int: C = 3;                 % number of component types
int: S = 6;                 % number of spare-count levels (0..5)
set of int: COMP = 1..C;
set of int: SP = 0..5;

int: budget = 150;
int: weight_limit = 20;

array[COMP] of int: price = [20, 30, 40];
array[COMP] of int: weight = [2, 4, 6];

% reliability table r[component, spares]
array[COMP, SP] of float: rel = array2d(COMP, SP, [
  0.5, 0.6, 0.7, 0.8, 0.9, 1.0,   % component 1, spares 0..5
  0.6, 0.75,0.95,1.0, 1.0, 1.0,   % component 2, spares 0..5
  0.7, 0.9, 1.0, 1.0, 1.0, 1.0    % component 3, spares 0..5
]);

% Variables
array[COMP] of var SP: x;         % number of spares installed for each component type
var 0.0..1.0: sys_rel;

% Constraints
constraint
  sum(c in COMP)(price[c] * x[c]) <= budget;

constraint
  sum(c in COMP)(weight[c] * x[c]) <= weight_limit;

constraint
  sys_rel = product(c in COMP)(rel[c, x[c]]);

% Objective
solve maximize sys_rel;