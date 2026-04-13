% Diet cost minimization (unbounded integer servings of each food)
include "globals.mzn";

set of int: FOODS = 1..8;

array[FOODS] of string: name =
  ["Chicken","Rice","Eggs","Beans","Spinach","Corn","Beef","Broccoli"];

array[FOODS] of int: protein = [5, 8, 18, 16, 3, 3, 6, 17];
array[FOODS] of int: carbs   = [15,17, 20, 15,28,19,24, 9];
array[FOODS] of int: calories= [162,282,234, 85,194,153,167,192];
array[FOODS] of int: cost    = [8, 4,  1,  4,  7,  2,  9,  3];

int: minProtein = 68;
int: minCarbs   = 189;
int: minCalories= 1840;

% Decision variables: number of servings of each food (unbounded above, but
% a safe upper bound is derived from minimum requirements)
array[FOODS] of int: ub =
  [ max( (minProtein + protein[i] - 1) div protein[i],
         max( (minCarbs + carbs[i] - 1) div carbs[i],
              (minCalories + calories[i] - 1) div calories[i])) | i in FOODS ];

array[FOODS] of var 0..max(ub): x;

% Nutritional constraints
constraint sum(i in FOODS)(protein[i] * x[i]) >= minProtein;
constraint sum(i in FOODS)(carbs[i]   * x[i]) >= minCarbs;
constraint sum(i in FOODS)(calories[i]* x[i]) >= minCalories;

% Objective: minimize total cost
var int: totalCost = sum(i in FOODS)(cost[i] * x[i]);

solve minimize totalCost;

output [
  "Total cost = $", show(totalCost), "\n",
  "Servings:\n"
] ++
[ name[i] ++ ": " ++ show(x[i]) ++ "\n" | i in FOODS ] ++
[
  "\nTotals:\n",
  "Protein = ", show(sum(i in FOODS)(protein[i] * x[i])), "\n",
  "Carbs   = ", show(sum(i in FOODS)(carbs[i] * x[i])), "\n",
  "Calories= ", show(sum(i in FOODS)(calories[i] * x[i])), "\n"
];