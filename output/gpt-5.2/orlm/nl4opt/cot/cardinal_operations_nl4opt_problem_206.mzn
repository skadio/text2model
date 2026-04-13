% Parameters (with values embedded)
int: n = 2;
set of int: SUPP = 1..n;

array[SUPP] of int: calcium_per_serv = [30, 60];   % A, B
array[SUPP] of int: magnesium_per_serv = [50, 10]; % A, B
array[SUPP] of int: cost_per_serv = [14, 25];      % A, B

int: req_calcium = 400;
int: req_magnesium = 50;

% Variables
var 0..1000: servings_A;
var 0..1000: servings_B;

% Constraints
constraint
  calcium_per_serv[1] * servings_A + calcium_per_serv[2] * servings_B >= req_calcium;

constraint
  magnesium_per_serv[1] * servings_A + magnesium_per_serv[2] * servings_B >= req_magnesium;

% Objective
var int: total_cost = cost_per_serv[1] * servings_A + cost_per_serv[2] * servings_B;
solve minimize total_cost;