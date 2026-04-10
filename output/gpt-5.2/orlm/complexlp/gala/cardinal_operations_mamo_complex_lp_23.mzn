% Diet / meal planning: minimize cost while meeting minimum nutrition requirements
include "globals.mzn";

int: nFoods = 8;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: protein = [1, 18, 19, 19, 3, 8, 15, 3];
array[FOODS] of int: carbs   = [4, 2, 26, 10, 24, 26, 27, 30];
array[FOODS] of int: calories= [93, 219, 155, 105, 255, 182, 173, 191];
array[FOODS] of int: cost    = [6, 4, 4, 3, 2, 7, 3, 3];

int: reqProtein  = 98;
int: reqCarbs    = 113;
int: reqCalories = 1768;

% Decision: number of servings of each food (nonnegative integers)
% A safe upper bound: if only the best calorie item were used, 1768/255 < 7,
% but other constraints may force more; 100 is plenty.
int: maxServ = 100;
array[FOODS] of var 0..maxServ: x;

% Nutrient constraints
constraint sum(i in FOODS)(protein[i]  * x[i]) >= reqProtein;
constraint sum(i in FOODS)(carbs[i]    * x[i]) >= reqCarbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= reqCalories;

% Objective: minimize total cost
var int: totalCost = sum(i in FOODS)(cost[i] * x[i]);

solve minimize totalCost;

output [
  "Servings x = ", show(x), "\n",
  "Total cost = ", show(totalCost), "\n",
  "Protein  = ", show(sum(i in FOODS)(protein[i]  * x[i])), " (>= ", show(reqProtein), ")\n",
  "Carbs    = ", show(sum(i in FOODS)(carbs[i]    * x[i])), " (>= ", show(reqCarbs), ")\n",
  "Calories = ", show(sum(i in FOODS)(calories[i] * x[i])), " (>= ", show(reqCalories), ")\n"
];