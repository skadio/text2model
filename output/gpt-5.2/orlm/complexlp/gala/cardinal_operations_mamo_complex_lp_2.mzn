% Diet optimization (integer quantities of each food) - data embedded
include "globals.mzn";

int: nFoods = 5;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: protein = [3, 17, 16, 8, 6];
array[FOODS] of int: carbs   = [16, 24, 27, 16, 6];
array[FOODS] of int: calories= [96, 182, 114, 208, 236];
array[FOODS] of int: cost    = [9, 9, 2, 9, 5];

int: minProtein  = 100;
int: minCarbs    = 180;
int: minCalories = 1796;

% Safe upper bounds: enough items of any single food to meet each minimum
function int: ceil_div(int: a, int: b) = (a + b - 1) div b;

array[FOODS] of int: ub = [
  max( max(ceil_div(minProtein,  protein[i]), ceil_div(minCarbs, carbs[i])),
       ceil_div(minCalories, calories[i]) )
  | i in FOODS
];

array[FOODS] of var 0..max(ub): x;   % servings/count of each food item

% Nutritional constraints
constraint sum(i in FOODS)(protein[i]  * x[i]) >= minProtein;
constraint sum(i in FOODS)(carbs[i]    * x[i]) >= minCarbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= minCalories;

var int: totalCost = sum(i in FOODS)(cost[i] * x[i]);

solve minimize totalCost;

output [
  "Servings x = ", show(x), "\n",
  "Total cost = ", show(totalCost), "\n",
  "Protein  = ", show(sum(i in FOODS)(protein[i]  * x[i])), "\n",
  "Carbs    = ", show(sum(i in FOODS)(carbs[i]    * x[i])), "\n",
  "Calories = ", show(sum(i in FOODS)(calories[i] * x[i])), "\n"
];