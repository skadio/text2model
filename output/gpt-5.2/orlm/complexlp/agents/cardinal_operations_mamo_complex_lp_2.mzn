% Parameters
int: n_foods = 5;                         % number of food items
set of int: FOODS = 1..n_foods;           % index set of foods

array[FOODS] of int: cost = [9, 9, 2, 9, 5];                 % cost per unit of each food
array[FOODS] of int: protein = [3, 17, 16, 8, 6];            % grams of protein per unit
array[FOODS] of int: carbs = [16, 24, 27, 16, 6];            % grams of carbohydrates per unit
array[FOODS] of int: calories = [96, 182, 114, 208, 236];    % calories per unit

int: min_protein = 100;                   % minimum total protein required
int: min_carbs = 180;                     % minimum total carbohydrates required
int: min_calories = 1796;                 % minimum total calories required

% Variables
array[FOODS] of var 0..(max([min_protein, min_carbs, min_calories])): x;
% x[i] = number of units of food i (bounded non-negative integer)

var int: total_cost;                      % total cost of chosen foods
var int: total_protein;                   % total protein achieved
var int: total_carbs;                     % total carbohydrates achieved
var int: total_calories;                  % total calories achieved

% Constraints
% Compute total nutritional intake from chosen quantities
constraint total_protein  = sum(i in FOODS)(protein[i] * x[i]);
constraint total_carbs    = sum(i in FOODS)(carbs[i] * x[i]);
constraint total_calories = sum(i in FOODS)(calories[i] * x[i]);

% Compute total cost from chosen quantities
constraint total_cost = sum(i in FOODS)(cost[i] * x[i]);

% Enforce minimum nutritional requirements
constraint total_protein  >= min_protein;
constraint total_carbs    >= min_carbs;
constraint total_calories >= min_calories;

% Objective
solve minimize total_cost;