% Parameters (with values embedded)
int: nFoods = 5;
set of int: FOODS = 1..nFoods;

array[FOODS] of string: foodName = ["Chicken","Pasta","Rice","Beans","Cheese"];

array[FOODS] of int: protein = [5, 3, 11, 10, 4];
array[FOODS] of int: carbs   = [13,23, 27, 27,18];
array[FOODS] of int: calories= [121,274,251,259,199];
array[FOODS] of int: cost    = [7, 10, 7, 9, 7];

int: minProtein  = 60;
int: minCarbs    = 146;
int: minCalories = 1727;

% Upper bounds (safe, derived from requirements and per-item minimum contributions)
int: maxUnitsProtein  = max([ (minProtein  + protein[i]  - 1) div protein[i]  | i in FOODS ]);
int: maxUnitsCarbs    = max([ (minCarbs    + carbs[i]    - 1) div carbs[i]    | i in FOODS ]);
int: maxUnitsCalories = max([ (minCalories + calories[i] - 1) div calories[i] | i in FOODS ]);
int: maxUnits = max(maxUnitsProtein, max(maxUnitsCarbs, maxUnitsCalories));

% Variables
array[FOODS] of var 0..maxUnits: x;  % number of servings/units of each food
var 0..(maxUnits * sum(i in FOODS)(cost[i])): totalCost;

% Constraints
constraint sum(i in FOODS)(protein[i] * x[i])  >= minProtein;
constraint sum(i in FOODS)(carbs[i]   * x[i])  >= minCarbs;
constraint sum(i in FOODS)(calories[i]* x[i])  >= minCalories;

constraint totalCost = sum(i in FOODS)(cost[i] * x[i]);

% Objective
solve minimize totalCost;

output [
  "Total cost = $", show(totalCost), "\n",
  "Servings:\n"
] ++
[
  "  ", foodName[i], ": ", show(x[i]), "\n" | i in FOODS
];