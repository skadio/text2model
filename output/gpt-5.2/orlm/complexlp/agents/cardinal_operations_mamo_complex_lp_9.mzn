% Parameters
int: n_foods = 8;                      % number of available food items
set of int: FOODS = 1..n_foods;        % index set for foods

array[FOODS] of int: cost =            % cost ($) per unit of each food
  [7, 7, 1, 9, 6, 7, 2, 6];

array[FOODS] of int: protein =         % protein (g) per unit of each food
  [12, 10, 11, 8, 16, 4, 4, 4];

array[FOODS] of int: carbs =           % carbohydrates (g) per unit of each food
  [5, 1, 30, 26, 9, 25, 16, 20];

array[FOODS] of int: calories =        % calories per unit of each food
  [231, 210, 295, 211, 232, 146, 255, 205];

int: req_protein = 91;                 % required protein (g)
int: req_carbs = 136;                  % required carbohydrates (g)
int: req_calories = 1563;              % required calories


% Variables
array[FOODS] of var 0..100: qty;       % integer number of units of each food to select (bounded)

var int: total_cost;                   % total cost of selected foods
var int: total_protein;                % total protein achieved
var int: total_carbs;                  % total carbs achieved
var int: total_calories;               % total calories achieved


% Constraints
% Compute totals from selected quantities (linear definitions)
constraint total_cost =
  sum(f in FOODS)(cost[f] * qty[f]);

constraint total_protein =
  sum(f in FOODS)(protein[f] * qty[f]);

constraint total_carbs =
  sum(f in FOODS)(carbs[f] * qty[f]);

constraint total_calories =
  sum(f in FOODS)(calories[f] * qty[f]);

% Meet (or exceed) daily nutritional requirements
constraint total_protein >= req_protein;
constraint total_carbs >= req_carbs;
constraint total_calories >= req_calories;


% Objective
solve minimize total_cost;