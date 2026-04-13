% Parameters
int: cost_labor = 5;
int: cost_material = 3;
int: cost_equipment = 2;

int: max_4labor_plus_material = 1000;
int: min_2labor_plus_3equipment = 500;
int: material_minus_equipment = 100;

% Variables
var 0..1000: labor;
var 0..1000: material;
var 0..1000: equipment;

var 0..(cost_labor*1000 + cost_material*1000 + cost_equipment*1000): total_cost;

% Constraints
constraint 4 * labor + material <= max_4labor_plus_material;
constraint 2 * labor + 3 * equipment >= min_2labor_plus_3equipment;
constraint material - equipment = material_minus_equipment;

constraint total_cost = cost_labor * labor + cost_material * material + cost_equipment * equipment;

% Objective
solve minimize total_cost;