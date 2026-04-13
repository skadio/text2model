include "globals.mzn";

% Diet problem (all data embedded)

int: nFoods = 6;

set of int: FOODS = 1..nFoods;

array[FOODS] of int: protein = [15, 16,  3, 19, 11, 10];
array[FOODS] of int: carbs   = [10, 25,  8, 20,  8,  9];
array[FOODS] of int: calories= [163,108,198,141,105,199];
array[FOODS] of int: cost    = [10,  4,  1,  7,  6,  8];

% Requirements (as stated)
int: reqProtein = 88;
int: reqCarbs   = 144;
int: reqCalories= 1900;

% Decision: number of servings of each food (nonnegative integers)
% Upper bounds chosen safely large (calorie requirement is the binding one).
array[FOODS] of var 0..100: x;

% Meet requirements (at least)
constraint sum(i in FOODS)(protein[i] * x[i]) >= reqProtein;
constraint sum(i in FOODS)(carbs[i]   * x[i]) >= reqCarbs;
constraint sum(i in FOODS)(calories[i]* x[i]) >= reqCalories;

var int: totalCost = sum(i in FOODS)(cost[i] * x[i]);

solve minimize totalCost;

output [
  "Servings x = ", show(x), "\n",
  "Total cost = ", show(totalCost), "\n",
  "Protein  = ", show(sum(i in FOODS)(protein[i]*x[i])), " (>= ", show(reqProtein), ")\n",
  "Carbs    = ", show(sum(i in FOODS)(carbs[i]*x[i])),   " (>= ", show(reqCarbs), ")\n",
  "Calories = ", show(sum(i in FOODS)(calories[i]*x[i])), " (>= ", show(reqCalories), ")\n"
];