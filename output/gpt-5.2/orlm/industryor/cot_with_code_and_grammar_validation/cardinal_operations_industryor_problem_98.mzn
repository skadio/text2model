% Parameters
int: N = 3;                         % number of component types
int: Smax = 5;                      % maximum number of spares allowed per component (0..5)

set of int: COMP = 1..N;
set of int: SPARES = 0..Smax;

int: budget_limit = 150;
int: weight_limit = 20;

array[COMP] of int: price = [20, 30, 40];
array[COMP] of int: weight = [2, 4, 6];

array[COMP, SPARES] of float: rel = array2d(COMP, SPARES,
[
  0.5, 0.6, 0.7, 0.8, 0.9, 1.0,   % component 1, spares 0..5
  0.6, 0.75,0.95,1.0, 1.0, 1.0,   % component 2, spares 0..5
  0.7, 0.9, 1.0, 1.0, 1.0, 1.0    % component 3, spares 0..5
]);

% Variables
array[COMP] of var SPARES: s;       % number of spares installed for each component

var 0..budget_limit: total_cost;
var 0..weight_limit: total_weight;

var float: sys_rel;

% Constraints
constraint
  total_cost = sum(c in COMP)(price[c] * s[c]);

constraint
  total_weight = sum(c in COMP)(weight[c] * s[c]);

constraint total_cost <= budget_limit;
constraint total_weight <= weight_limit;

constraint
  sys_rel = product(c in COMP)(rel[c, s[c]]);

% Objective
solve maximize sys_rel;