% Diet optimization (all data embedded)

include "globals.mzn";

int: nFoods = 5;
set of int: FOODS = 1..nFoods;

array[FOODS] of string: name = ["Steak","Apples","Eggs","Chicken","Tofu"];

% Nutrient content per unit
array[FOODS] of int: protein = [1, 7, 6, 20, 8];
array[FOODS] of int: carbs   = [3, 22, 18, 6, 4];
array[FOODS] of int: calories= [210, 96, 189, 132, 75];

% Cost per unit
array[FOODS] of int: cost    = [6, 1, 1, 3, 1];

% Minimum requirements
int: minProtein  = 87;
int: minCarbs    = 135;
int: minCalories = 1926;

% Decision variables: number of units of each food
% Safe upper bound: worst-case for calories is 75 (tofu), so 1926/75 <= 25.68 -> 26
int: UB = 26;
array[FOODS] of var 0..UB: x;

% Nutrition constraints
constraint sum(i in FOODS)(protein[i] * x[i])  >= minProtein;
constraint sum(i in FOODS)(carbs[i]   * x[i])  >= minCarbs;
constraint sum(i in FOODS)(calories[i]* x[i])  >= minCalories;

% Objective: minimize total cost
var int: totalCost = sum(i in FOODS)(cost[i] * x[i]);

solve minimize totalCost;

output [
  "Total cost = $", show(totalCost), "\n",
  "Quantities:\n",
  concat([ name[i] ++ ": " ++ show(x[i]) ++ "\n" | i in FOODS ]),
  "Totals:\n",
  "Protein  = ", show(sum(i in FOODS)(protein[i] * x[i])), "\n",
  "Carbs    = ", show(sum(i in FOODS)(carbs[i]   * x[i])), "\n",
  "Calories = ", show(sum(i in FOODS)(calories[i]* x[i])), "\n"
];