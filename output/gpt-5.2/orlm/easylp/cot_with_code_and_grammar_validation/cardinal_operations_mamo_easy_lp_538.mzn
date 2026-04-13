% Parameters
int: cost_labor = 5;
int: cost_material = 3;
int: cost_equipment = 2;

int: limit_4L_plus_M = 1000;
int: min_2L_plus_3E = 500;
int: diff_M_minus_E = 100;

% Variables
var 0..1000: labor;
var 0..1000: material;
var 0..1000: equipment;

var 0..(cost_labor*1000 + cost_material*1000 + cost_equipment*1000): total_cost;

% Constraints
constraint 4 * labor + material <= limit_4L_plus_M;
constraint 2 * labor + 3 * equipment >= min_2L_plus_3E;
constraint material - equipment = diff_M_minus_E;

constraint total_cost = cost_labor * labor + cost_material * material + cost_equipment * equipment;

% Objective
solve minimize total_cost;