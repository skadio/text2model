% Parameters
int: nFoods = 4;                          % number of available food items
set of int: FOODS = 1..nFoods;            % index set for foods

array[FOODS] of int: cost     = [7, 7, 10, 2];      % cost per unit of each food item ($)
array[FOODS] of int: protein  = [19, 4, 3, 8];      % grams of protein per unit
array[FOODS] of int: carbs    = [9, 16, 11, 7];     % grams of carbohydrates per unit
array[FOODS] of int: calories = [83, 166, 71, 56];  % calories per unit

int: minProtein  = 84;                     % minimum required protein (g)
int: minCarbs    = 132;                    % minimum required carbohydrates (g)
int: minCalories = 1990;                   % minimum required calories

% Variables
array[FOODS] of var 0..1000: buy;         % number of units to purchase of each food (non-negative integer)

var 0..1000000: totalCost;                % total cost ($)
var 0..1000000: totalProtein;             % total protein (g)
var 0..1000000: totalCarbs;               % total carbohydrates (g)
var 0..1000000: totalCalories;            % total calories

% Constraints
% Compute totals from purchased quantities
constraint totalCost     = sum(f in FOODS)(cost[f] * buy[f]);
constraint totalProtein  = sum(f in FOODS)(protein[f] * buy[f]);
constraint totalCarbs    = sum(f in FOODS)(carbs[f] * buy[f]);
constraint totalCalories = sum(f in FOODS)(calories[f] * buy[f]);

% Nutritional minimum requirements
constraint totalProtein  >= minProtein;
constraint totalCarbs    >= minCarbs;
constraint totalCalories >= minCalories;

% Objective
solve minimize totalCost;

% Optional output for inspection
output [
  "buy = ", show(buy), "\n",
  "totalCost = ", show(totalCost), "\n",
  "totalProtein = ", show(totalProtein), "\n",
  "totalCarbs = ", show(totalCarbs), "\n",
  "totalCalories = ", show(totalCalories), "\n"
];