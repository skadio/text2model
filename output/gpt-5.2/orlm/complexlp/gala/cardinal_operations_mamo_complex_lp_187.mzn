include "globals.mzn";

% Foods: 1=Bread, 2=Milk, 3=Fish, 4=Potato
int: nFoods = 4;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: protein = [4, 6, 20, 1];
array[FOODS] of int: carbs   = [7, 10, 0, 30];
array[FOODS] of int: calories= [130, 120, 150, 70];
array[FOODS] of int: cost    = [3, 4, 8, 2];

int: reqProtein  = 30;
int: reqCarbs    = 40;
int: reqCalories = 400;

% Decision variables: number of servings of each food (assume integer servings)
% Upper bound chosen safely; no need for huge domains.
array[FOODS] of var 0..20: x;

constraint sum(f in FOODS)(protein[f] * x[f]) >= reqProtein;
constraint sum(f in FOODS)(carbs[f]   * x[f]) >= reqCarbs;
constraint sum(f in FOODS)(calories[f]* x[f]) >= reqCalories;

var int: totalCost = sum(f in FOODS)(cost[f] * x[f]);

solve minimize totalCost;

output [
  "Servings (Bread, Milk, Fish, Potato) = ", show([x[1], x[2], x[3], x[4]]), "\n",
  "Total protein   = ", show(sum(f in FOODS)(protein[f]*x[f])), " g\n",
  "Total carbs     = ", show(sum(f in FOODS)(carbs[f]*x[f])), " g\n",
  "Total calories  = ", show(sum(f in FOODS)(calories[f]*x[f])), "\n",
  "Total cost ($)  = ", show(totalCost), "\n"
];