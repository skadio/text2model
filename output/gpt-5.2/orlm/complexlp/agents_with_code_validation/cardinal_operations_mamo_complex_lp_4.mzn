% Parameters
int: nFoods = 6;                         % number of foods
set of int: FOODS = 1..nFoods;           % food index set

array[FOODS] of int: protein  = [14, 11, 8, 1, 16, 19];      % grams protein per unit
array[FOODS] of int: carbs    = [1,  6, 12, 17, 11, 13];     % grams carbs per unit
array[FOODS] of int: calories = [164,210,98, 92, 211,211];   % calories per unit
array[FOODS] of int: cost     = [6,  2,  9,  3,  7,  9];     % cost per unit

int: minProtein  = 70;     % minimum required protein
int: minCarbs    = 117;    % minimum required carbs
int: minCalories = 1837;   % minimum required calories

% Variables
array[FOODS] of var 0..20: qty;          % integer servings/units of each food
var 0..10000: totalCost;                 % total cost to minimize

% Constraints
% Link total cost to chosen quantities
constraint totalCost = sum(f in FOODS)(cost[f] * qty[f]);

% Meet minimum nutrient requirements
constraint sum(f in FOODS)(protein[f]  * qty[f]) >= minProtein;
constraint sum(f in FOODS)(carbs[f]    * qty[f]) >= minCarbs;
constraint sum(f in FOODS)(calories[f] * qty[f]) >= minCalories;

% Objective
solve minimize totalCost;

output [ show(totalCost) ];