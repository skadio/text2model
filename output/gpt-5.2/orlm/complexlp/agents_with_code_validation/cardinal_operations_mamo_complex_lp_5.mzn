% Parameters
int: nFoods = 9; % number of available food items
set of int: FOODS = 1..nFoods;

array[FOODS] of int: protein  = [15, 1, 1, 6, 3, 17, 18, 12, 2];  % grams protein per unit
array[FOODS] of int: carbs    = [18, 25, 21, 3, 7, 13, 27, 17, 30]; % grams carbohydrates per unit
array[FOODS] of int: calories = [300, 267, 266, 119, 166, 129, 216, 76, 258]; % calories per unit
array[FOODS] of int: cost     = [4, 2, 5, 10, 2, 8, 10, 9, 4]; % dollars per unit

int: minProtein  = 90;
int: minCarbs    = 105;
int: minCalories = 1805;

% Variables
array[FOODS] of var 0..100: qty; % number of units chosen of each food (bounded)

var int: totalCost;     % total dollars spent
var int: totalProtein;  % total protein obtained
var int: totalCarbs;    % total carbohydrates obtained
var int: totalCalories; % total calories obtained

% Constraints
% Compute total nutrition and cost from chosen quantities
constraint totalCost     = sum(f in FOODS)(cost[f] * qty[f]);
constraint totalProtein  = sum(f in FOODS)(protein[f] * qty[f]);
constraint totalCarbs    = sum(f in FOODS)(carbs[f] * qty[f]);
constraint totalCalories = sum(f in FOODS)(calories[f] * qty[f]);

% Meet minimum daily nutritional requirements
constraint totalProtein  >= minProtein;
constraint totalCarbs    >= minCarbs;
constraint totalCalories >= minCalories;

% Objective
solve minimize totalCost;