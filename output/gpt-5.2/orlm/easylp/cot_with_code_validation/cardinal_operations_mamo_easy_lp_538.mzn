% Parameters
int: cost_labor = 5;
int: cost_material = 3;
int: cost_equipment = 2;

int: max_4L_plus_M = 1000;
int: min_2L_plus_3E = 500;
int: M_minus_E = 100;

% Variables
var 0..max_4L_plus_M div 4: labor;
var 0..max_4L_plus_M: material;
var 0..(max_4L_plus_M + M_minus_E): equipment;

var int: total_cost;

% Constraints
constraint 4 * labor + material <= max_4L_plus_M;

constraint 2 * labor + 3 * equipment >= min_2L_plus_3E;

constraint material - equipment = M_minus_E;

constraint total_cost = cost_labor * labor + cost_material * material + cost_equipment * equipment;

% Objective
solve minimize total_cost;