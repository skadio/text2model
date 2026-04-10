% Parameters (with values embedded)
int: training_cost_per_unit = 5;
int: equipment_cost_per_unit = 3;
int: nutrition_cost_per_unit = 2;

int: max_training_plus_equipment = 50;
int: min_training_plus_nutrition = 30;
int: max_equipment_minus_nutrition = 10;

% Variables
var 0..50: training_hours;
var 0..50: equipment_cost;
var 0..50: nutrition_cost;

var 0..(training_cost_per_unit*50 + equipment_cost_per_unit*50 + nutrition_cost_per_unit*50): total_cost_score;

% Constraints
constraint training_hours + equipment_cost <= max_training_plus_equipment;
constraint training_hours + nutrition_cost >= min_training_plus_nutrition;
constraint equipment_cost - nutrition_cost <= max_equipment_minus_nutrition;

constraint total_cost_score =
  training_cost_per_unit * training_hours +
  equipment_cost_per_unit * equipment_cost +
  nutrition_cost_per_unit * nutrition_cost;

% Objective
solve minimize total_cost_score;