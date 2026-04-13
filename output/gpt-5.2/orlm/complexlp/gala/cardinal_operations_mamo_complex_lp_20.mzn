% Diet / nutrition minimization (embedded data)

include "globals.mzn";

set of int: FOODS = 1..4;
array[FOODS] of string: foodName = ["Chicken","Cheese","Rice","Beans"];

% Nutrients per unit
array[FOODS] of int: protein = [16, 10, 12, 13];
array[FOODS] of int: carbs   = [22,  4, 21, 14];
array[FOODS] of int: calories= [292,82,207,81];

% Cost per unit
array[FOODS] of int: cost = [5, 9, 2, 1];

% Requirements (minimum totals)
int: reqProtein = 94;
int: reqCarbs   = 191;
int: reqCalories= 2271;

% Decision variables: number of units of each food
% Safe upper bound based on calories requirement and smallest calories/item = 81
int: maxUnits = 30;  % 2271/81 ~= 28.05, so 30 is safe
array[FOODS] of var 0..maxUnits: x;

% Nutrient constraints
constraint sum(i in FOODS)(protein[i] * x[i]) >= reqProtein;
constraint sum(i in FOODS)(carbs[i]   * x[i]) >= reqCarbs;
constraint sum(i in FOODS)(calories[i]* x[i]) >= reqCalories;

% Objective: minimize total cost
var int: totalCost = sum(i in FOODS)(cost[i] * x[i]);

solve minimize totalCost;

output [
  "Min cost = $", show(totalCost), "\n",
  "Units: ", show([x[i] | i in FOODS]), "\n",
  "Breakdown:\n"
] ++
[
  foodName[i] ++ ": " ++ show(x[i]) ++ "\n"
  | i in FOODS
] ++
[
  "Totals: protein=" ++ show(sum(i in FOODS)(protein[i]*x[i])) ++
  ", carbs=" ++ show(sum(i in FOODS)(carbs[i]*x[i])) ++
  ", calories=" ++ show(sum(i in FOODS)(calories[i]*x[i])) ++ "\n"
];