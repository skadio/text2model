% Diet meal plan / minimum cost to satisfy nutrition requirements
% Data is embedded as required.

include "globals.mzn";

int: nFoods = 6;
set of int: FOODS = 1..nFoods;

array[FOODS] of string: name = ["Steak","Tofu","Chicken","Broccoli","Rice","Spinach"];

array[FOODS] of int: protein = [14, 2, 17, 3, 15, 2];
array[FOODS] of int: carbs   = [23,13, 13, 1, 23, 8];
array[FOODS] of int: calories= [63,162,260,55,231,297];
array[FOODS] of int: cost    = [4, 6, 6, 8, 8, 5];

int: reqProtein  = 83;
int: reqCarbs    = 192;
int: reqCalories = 2089;

% Decision variables: number of servings of each food (nonnegative integers)
% Upper bounds: enough to cover each requirement if using only one food.
array[FOODS] of int: ub = [
  max( ceil(reqProtein/protein[1]), ceil(reqCarbs/carbs[1]), ceil(reqCalories/calories[1]) ),
  max( ceil(reqProtein/protein[2]), ceil(reqCarbs/carbs[2]), ceil(reqCalories/calories[2]) ),
  max( ceil(reqProtein/protein[3]), ceil(reqCarbs/carbs[3]), ceil(reqCalories/calories[3]) ),
  max( ceil(reqProtein/protein[4]), ceil(reqCarbs/carbs[4]), ceil(reqCalories/calories[4]) ),
  max( ceil(reqProtein/protein[5]), ceil(reqCarbs/carbs[5]), ceil(reqCalories/calories[5]) ),
  max( ceil(reqProtein/protein[6]), ceil(reqCarbs/carbs[6]), ceil(reqCalories/calories[6]) )
];

array[FOODS] of var 0..max(ub): x;

% Nutrition constraints
constraint sum(i in FOODS)(protein[i]  * x[i]) >= reqProtein;
constraint sum(i in FOODS)(carbs[i]    * x[i]) >= reqCarbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= reqCalories;

% Objective: minimize total cost
var int: totalCost = sum(i in FOODS)(cost[i] * x[i]);

solve minimize totalCost;

output
[
  "Minimum cost = $", show(totalCost), "\n",
  "Servings:\n"
] ++
[
  name[i] ++ " = " ++ show(x[i]) ++ "\n"
  | i in FOODS
] ++
[
  "\nTotals:\n",
  "Protein  = ", show(sum(i in FOODS)(protein[i]  * x[i])), "\n",
  "Carbs    = ", show(sum(i in FOODS)(carbs[i]    * x[i])), "\n",
  "Calories = ", show(sum(i in FOODS)(calories[i] * x[i])), "\n"
];