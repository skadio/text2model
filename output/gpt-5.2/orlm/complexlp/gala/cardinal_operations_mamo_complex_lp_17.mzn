% Diet / meal planning: minimize cost while meeting nutrition minimums
include "globals.mzn";

% Foods: 1=Lentils, 2=Rice, 3=Chicken, 4=Beef, 5=Tofu
int: nFoods = 5;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: cost    = [7, 6, 6, 10, 2];
array[FOODS] of int: protein = [13, 2, 7, 18, 12];
array[FOODS] of int: carbs   = [21, 30, 13, 8, 28];
array[FOODS] of int: calories= [284, 55, 276, 204, 160];

int: minProtein  = 79;
int: minCarbs    = 170;
int: minCalories = 1699;

% Upper bounds: enough to cover the minimum if only that food were chosen
array[FOODS] of int: ub = [
  (minCalories div calories[1]) + 1,
  (minCalories div calories[2]) + 1,
  (minCalories div calories[3]) + 1,
  (minCalories div calories[4]) + 1,
  (minCalories div calories[5]) + 1
];

array[FOODS] of var 0..max(ub): x; % number of units/servings of each food

constraint sum(f in FOODS)(protein[f] * x[f])  >= minProtein;
constraint sum(f in FOODS)(carbs[f]   * x[f])  >= minCarbs;
constraint sum(f in FOODS)(calories[f]* x[f])  >= minCalories;

var int: totalCost = sum(f in FOODS)(cost[f] * x[f]);

solve minimize totalCost;

output [ show(totalCost) ];