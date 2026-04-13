% Parameters
int: n_foods = 4;                         % number of food items
set of int: FOODS = 1..n_foods;           % index set for foods

array[FOODS] of int: cost     = [7, 7, 10, 2];      % cost per unit of each food
array[FOODS] of int: protein  = [19, 4, 3, 8];      % grams of protein per unit
array[FOODS] of int: carbs    = [9, 16, 11, 7];     % grams of carbohydrates per unit
array[FOODS] of int: calories = [83, 166, 71, 56];  % calories per unit

int: min_protein  = 84;                   % minimum required protein
int: min_carbs    = 132;                  % minimum required carbohydrates
int: min_calories = 1990;                 % minimum required calories


% Variables
array[FOODS] of var 0..1000: buy;         % units of each food to purchase (nonnegative integers)
var int: total_cost;                      % total cost of purchased foods


% Constraints
% Compute total cost from purchased quantities
constraint TotalCostDefinition:
  total_cost = sum(f in FOODS)(cost[f] * buy[f]);

% Meet minimum protein requirement
constraint MinProteinRequirement:
  sum(f in FOODS)(protein[f] * buy[f]) >= min_protein;

% Meet minimum carbohydrate requirement
constraint MinCarbsRequirement:
  sum(f in FOODS)(carbs[f] * buy[f]) >= min_carbs;

% Meet minimum calorie requirement
constraint MinCaloriesRequirement:
  sum(f in FOODS)(calories[f] * buy[f]) >= min_calories;


% Objective
solve minimize total_cost;