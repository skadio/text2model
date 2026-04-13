% Parameters
int: n_foods = 4;                               % number of available foods
set of int: FOODS = 1..n_foods;                 % index set for foods

array[FOODS] of int: protein  = [2, 11, 19, 17];   % grams of protein per unit of each food
array[FOODS] of int: carbs    = [9, 29, 16, 9];    % grams of carbohydrates per unit of each food
array[FOODS] of int: calories = [165, 230, 68, 258]; % calories per unit of each food
array[FOODS] of int: cost     = [3, 3, 6, 9];      % cost per unit of each food

int: min_protein  = 88;                          % minimum required protein
int: min_carbs    = 107;                         % minimum required carbohydrates
int: min_calories = 1944;                        % minimum required calories

% Variables
array[FOODS] of var int: x;                      % number of units chosen for each food (nonnegative integer)
var int: total_cost;                             % total cost of the chosen meal

% Constraints
% Nonnegativity for decision variables
constraint forall(f in FOODS) (x[f] >= 0);

% Define total cost
constraint total_cost = sum(f in FOODS)(cost[f] * x[f]);

% Meet minimum protein requirement
constraint sum(f in FOODS)(protein[f] * x[f]) >= min_protein;

% Meet minimum carbohydrate requirement
constraint sum(f in FOODS)(carbs[f] * x[f]) >= min_carbs;

% Meet minimum calorie requirement
constraint sum(f in FOODS)(calories[f] * x[f]) >= min_calories;

% Objective
solve minimize total_cost;