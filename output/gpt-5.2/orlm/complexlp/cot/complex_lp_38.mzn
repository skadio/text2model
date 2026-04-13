% Parameters (with values embedded)
int: nFoods = 6;
set of int: FOODS = 1..nFoods;

array[FOODS] of string: foodName =
  ["ChickenBreast","BrownRice","Tofu","Spinach","Almonds","Salmon"];

array[FOODS] of int: cost = [4, 10, 6, 1, 8, 6];
array[FOODS] of int: protein = [14, 11, 20, 6, 9, 20];
array[FOODS] of int: carbs   = [4, 17, 12, 20, 11, 19];
array[FOODS] of int: calories= [275,151,155,106,279,93];

int: reqProtein = 78;
int: reqCarbs = 140;
int: reqCalories = 1537;

% Variables
% Integer number of servings of each food
array[FOODS] of var 0..100: x;

var int: totalCost;

% Constraints
constraint totalCost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i] * x[i]) >= reqProtein;
constraint sum(i in FOODS)(carbs[i]   * x[i]) >= reqCarbs;
constraint sum(i in FOODS)(calories[i]* x[i]) >= reqCalories;

% Objective
solve minimize totalCost;

output [
  "Total cost = $", show(totalCost), "\n",
  "Servings:\n"
] ++
[
  foodName[i] ++ ": " ++ show(x[i]) ++ "\n"
  | i in FOODS
] ++
[
  "\nTotals:\n",
  "Protein = ", show(sum(i in FOODS)(protein[i]*x[i])), " g\n",
  "Carbs   = ", show(sum(i in FOODS)(carbs[i]*x[i])), " g\n",
  "Calories= ", show(sum(i in FOODS)(calories[i]*x[i])), "\n"
];