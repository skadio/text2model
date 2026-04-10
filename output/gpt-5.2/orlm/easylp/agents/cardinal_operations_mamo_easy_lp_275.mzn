% Parameters
% Cost coefficients
int: cost_training  = 5;        % cost units per training hour
int: cost_equipment = 3;        % cost units per equipment unit
int: cost_nutrition = 2;        % cost units per nutrition unit

% Constraint bounds
int: max_train_plus_equip = 50;  % training + equipment <= 50
int: min_train_plus_nutri = 30;  % training + nutrition >= 30
int: max_equip_minus_nutri = 10; % |equipment - nutrition| <= 10

% Derived bounds for decision variables (non-negative, bounded for safety)
int: max_allocation = max(max_train_plus_equip, min_train_plus_nutri);

% Variables
var 0..max_allocation: training_hours;  % whole number of training hours
var 0..max_allocation: equipment_cost;  % whole number equipment allocation
var 0..max_allocation: nutrition_cost;  % whole number nutrition allocation

var int: total_cost_score;              % objective value (integer)

% Constraints
% Define objective expression
constraint
  total_cost_score =
    cost_training  * training_hours +
    cost_equipment * equipment_cost +
    cost_nutrition * nutrition_cost;

% Budget cap: training + equipment cannot exceed the maximum allowed
constraint
  training_hours + equipment_cost <= max_train_plus_equip;

% Minimum balanced program: training + nutrition must meet at least the minimum required
constraint
  training_hours + nutrition_cost >= min_train_plus_nutri;

% Harmony constraint: equipment and nutrition allocations must be within 10 units (absolute difference)
constraint
  abs(equipment_cost - nutrition_cost) <= max_equip_minus_nutri;

% Objective
solve minimize total_cost_score;