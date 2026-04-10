% Parameters
% Cost coefficients (units per allocation)
int: cost_training  = 5;  % cost per training hour
int: cost_equipment = 3;  % cost per unit of equipment
int: cost_nutrition = 2;  % cost per unit of nutrition

% Constraint constants
int: max_train_plus_equip = 50;  % training + equipment <= 50
int: min_train_plus_nutri = 30;  % training + nutrition >= 30
int: max_equip_minus_nutri = 10; % |equipment - nutrition| <= 10

% Variables
% Decision variables (whole numbers; bounded for practicality)
var 0..max_train_plus_equip: training_hours;
var 0..max_train_plus_equip: equipment_cost;
var 0..max_train_plus_equip: nutrition_cost;

% Objective variable (linear total cost score)
var int: total_cost_score;

% Constraints
% Define total cost score from decision variables (linear aggregation)
constraint
  total_cost_score =
    cost_training  * training_hours +
    cost_equipment * equipment_cost +
    cost_nutrition * nutrition_cost;

% Budget cap: training + equipment cannot exceed the maximum allowed
constraint
  training_hours + equipment_cost <= max_train_plus_equip;

% Balanced program requirement: training + nutrition must meet a minimum
constraint
  training_hours + nutrition_cost >= min_train_plus_nutri;

% Harmony requirement: equipment and nutrition allocations must be within 10 units
constraint
  abs(equipment_cost - nutrition_cost) <= max_equip_minus_nutri;

% Objective
solve minimize total_cost_score;