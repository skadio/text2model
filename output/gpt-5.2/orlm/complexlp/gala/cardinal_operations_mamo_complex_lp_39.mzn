include "globals.mzn";

% Diet / meal planning as an integer linear optimization problem.
% Choose nonnegative integer servings of each food to meet minimum nutrition
% requirements at minimum cost.

int: nFoods = 9;
set of int: FOODS = 1..nFoods;

array[FOODS] of string: name = [
  "Chicken Breast", "Tofu", "Brown Rice", "Salmon", "Greek Yogurt",
  "Steak", "Avocado", "Eggs", "Quinoa"
];

array[FOODS] of int: cost    = [3, 2, 2, 6, 6, 10, 7, 5, 2];
array[FOODS] of int: protein = [17, 15,  1,11,15, 12, 4,16,11];
array[FOODS] of int: carbs   = [28, 11, 11, 3,27,  3, 8,25,20];
array[FOODS] of int: calories= [136,198, 93,269,121,80,300,99,87];

int: minProtein  = 72;
int: minCarbs    = 158;
int: minCalories = 1896;

% Upper bound on servings: tight enough for search but safely large.
% (Meeting calories alone with cheapest-per-calorie item would need <= 1896/80 = 24 servings)
int: maxServings = 30;

array[FOODS] of var 0..maxServings: x;  % servings chosen

var int: totalCost     = sum(i in FOODS)(cost[i] * x[i]);
var int: totalProtein  = sum(i in FOODS)(protein[i] * x[i]);
var int: totalCarbs    = sum(i in FOODS)(carbs[i] * x[i]);
var int: totalCalories = sum(i in FOODS)(calories[i] * x[i]);

constraint totalProtein  >= minProtein;
constraint totalCarbs    >= minCarbs;
constraint totalCalories >= minCalories;

solve minimize totalCost;

output [
  "Minimum cost = $", show(totalCost), "\n",
  "Total protein  = ", show(totalProtein),  " (>= ", show(minProtein), ")\n",
  "Total carbs    = ", show(totalCarbs),    " (>= ", show(minCarbs), ")\n",
  "Total calories = ", show(totalCalories), " (>= ", show(minCalories), ")\n\n",
  "Servings chosen:\n"
] ++
[
  if fix(x[i]) > 0 then
    "  " ++ name[i] ++ ": " ++ show(x[i]) ++ "\n"
  else
    ""
  endif
  | i in FOODS
];