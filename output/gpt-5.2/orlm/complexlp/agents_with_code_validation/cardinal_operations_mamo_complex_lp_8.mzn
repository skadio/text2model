% Parameters
int: nFoods = 9;                                 % number of food items
set of int: FOODS = 1..nFoods;                   % index set for foods

array[FOODS] of int: cost     = [10, 2, 7, 8, 4, 9, 2, 9, 9];                     % $ per unit
array[FOODS] of int: protein  = [7, 12, 14, 9, 11, 10, 10, 9, 8];                 % grams per unit
array[FOODS] of int: carbs    = [17, 12, 27, 6, 19, 23, 6, 16, 25];               % grams per unit
array[FOODS] of int: calories = [95, 233, 134, 109, 202, 148, 184, 136, 229];     % kcal per unit

int: minProtein  = 71;                          % required minimum protein (g)
int: minCarbs    = 107;                         % required minimum carbohydrates (g)
int: minCalories = 1623;                        % required minimum calories (kcal)

% Variables
array[FOODS] of var 0..18: x;                   % units selected of each food (bounded upper bound)
var int: totalCost;                             % total cost to minimize

% Constraints
constraint totalCost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i] * x[i])  >= minProtein;
constraint sum(i in FOODS)(carbs[i] * x[i])    >= minCarbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= minCalories;

% Objective
solve minimize totalCost;

output [ show(totalCost) ];