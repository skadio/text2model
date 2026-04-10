include "globals.mzn";

/***** Data (embedded) *****/
int: nFoods = 5;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: protein = [10,  3, 17,  6, 20];
array[FOODS] of int: carbs   = [22,  4, 10, 13,  5];
array[FOODS] of int: calories= [80,189,153,232,204];
array[FOODS] of int: cost    = [ 2,  8,  4,  1,  8];

int: reqProtein  = 74;
int: reqCarbs    = 102;
int: reqCalories = 1564;

/***** Decision variables *****/
% number of servings/units of each food (unbounded above in theory; a safe upper bound is used)
int: maxUnits = 1000;
array[FOODS] of var 0..maxUnits: x;

/***** Constraints *****/
constraint sum(i in FOODS)(protein[i]  * x[i]) >= reqProtein;
constraint sum(i in FOODS)(carbs[i]    * x[i]) >= reqCarbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= reqCalories;

/***** Objective *****/
var 0..maxUnits * max(cost): totalCost = sum(i in FOODS)(cost[i] * x[i]);
solve minimize totalCost;

/***** Output *****/
output [
  "Minimum cost = $", show(totalCost), "\n",
  "Units chosen x = ", show(x), "\n",
  "Total protein  = ", show(sum(i in FOODS)(protein[i]  * x[i])), "\n",
  "Total carbs    = ", show(sum(i in FOODS)(carbs[i]    * x[i])), "\n",
  "Total calories = ", show(sum(i in FOODS)(calories[i] * x[i])), "\n"
];