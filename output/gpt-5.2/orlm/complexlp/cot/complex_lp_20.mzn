% Parameters (with values embedded)
int: nFoods = 4;
set of int: FOODS = 1..nFoods;

array[FOODS] of string: foodName = ["Chicken","Cheese","Rice","Beans"];

array[FOODS] of int: protein = [16, 10, 12, 13];
array[FOODS] of int: carbs   = [22,  4, 21, 14];
array[FOODS] of int: calories= [292, 82, 207, 81];
array[FOODS] of int: cost    = [5,   9,  2,   1];

int: minProtein  = 94;
int: minCarbs    = 191;
int: minCalories = 2271;

% Variables
% x[f] = number of servings/units of food f to buy (nonnegative integers)
array[FOODS] of var 0..10000: x;

% Constraints
constraint sum(f in FOODS)(protein[f] * x[f]) >= minProtein;
constraint sum(f in FOODS)(carbs[f]   * x[f]) >= minCarbs;
constraint sum(f in FOODS)(calories[f]* x[f]) >= minCalories;

% Objective
var int: totalCost = sum(f in FOODS)(cost[f] * x[f]);
solve minimize totalCost;

output [
  "Total cost = $", show(totalCost), "\n",
  "Servings:\n"
] ++
[
  foodName[f] ++ ": " ++ show(x[f]) ++ "\n"
  | f in FOODS
];