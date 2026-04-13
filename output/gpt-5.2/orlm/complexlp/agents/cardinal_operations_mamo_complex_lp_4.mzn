% Parameters
int: nFoods = 6;                         % number of food items
set of int: FOODS = 1..nFoods;           % index set for foods

array[FOODS] of string: foodName =
  ["Chicken","Oats","Tofu","Rice","Beef","Salmon"];

array[FOODS] of int: protein  = [14, 11,  8,  1, 16, 19];   % grams protein per unit
array[FOODS] of int: carbs    = [ 1,  6, 12, 17, 11, 13];   % grams carbs per unit
array[FOODS] of int: calories = [164,210, 98, 92,211,211];  % calories per unit
array[FOODS] of int: cost     = [  6,  2,  9,  3,  7,  9];  % dollars per unit

int: minProtein  = 70;                     % required minimum protein
int: minCarbs    = 117;                    % required minimum carbs
int: minCalories = 1837;                   % required minimum calories

% Variable bounds (safe upper bounds derived from minima / smallest contribution)
int: maxUnits = max([
  (minProtein  + min(protein)  - 1) div min(protein),
  (minCarbs    + min(carbs)    - 1) div min(carbs),
  (minCalories + min(calories) - 1) div min(calories)
]);

% Variables
array[FOODS] of var 0..maxUnits: x;        % number of units selected for each food
var int: totalCost;                        % total dollar cost

% Constraints

% Define total cost from chosen food units
constraint totalCost = sum(f in FOODS)(cost[f] * x[f]);

% Meet minimum protein requirement
constraint sum(f in FOODS)(protein[f] * x[f]) >= minProtein;

% Meet minimum carbohydrates requirement
constraint sum(f in FOODS)(carbs[f] * x[f]) >= minCarbs;

% Meet minimum calories requirement
constraint sum(f in FOODS)(calories[f] * x[f]) >= minCalories;

% Objective
solve minimize totalCost;

output [ show(totalCost) ];