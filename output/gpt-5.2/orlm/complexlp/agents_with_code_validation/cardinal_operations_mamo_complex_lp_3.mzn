% Parameters
int: nFoods = 6;                            % number of available food items
set of int: FOODS = 1..nFoods;              % index set of food items

array[FOODS] of int: cost     = [4, 2, 6, 2, 6, 8];                 % cost per unit
array[FOODS] of int: protein  = [17, 4, 7, 14, 13, 1];              % grams protein per unit
array[FOODS] of int: carbs    = [8, 24, 27, 16, 1, 13];             % grams carbs per unit
array[FOODS] of int: calories = [237, 213, 133, 118, 136, 225];     % calories per unit

int: minProtein  = 76;                      % minimum required protein
int: minCarbs    = 173;                     % minimum required carbohydrates
int: minCalories = 1751;                    % minimum required calories


% Variables
array[FOODS] of var 0..1000: qty;           % units chosen for each food item (non-negative integer)

var 0..1000000: totalCost;                  % total cost
var 0..1000000: totalProtein;               % total protein
var 0..1000000: totalCarbs;                 % total carbohydrates
var 0..1000000: totalCalories;              % total calories


% Constraints
% Link aggregate totals to chosen quantities
constraint totalCost = sum(f in FOODS)(cost[f] * qty[f]);
constraint totalProtein = sum(f in FOODS)(protein[f] * qty[f]);
constraint totalCarbs = sum(f in FOODS)(carbs[f] * qty[f]);
constraint totalCalories = sum(f in FOODS)(calories[f] * qty[f]);

% Meet minimum nutritional requirements
constraint totalProtein >= minProtein;
constraint totalCarbs >= minCarbs;
constraint totalCalories >= minCalories;


% Objective
solve minimize totalCost;