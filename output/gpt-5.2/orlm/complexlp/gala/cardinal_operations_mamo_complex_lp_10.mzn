include "globals.mzn";

% Foods: 1=Steak, 2=Rice, 3=Chicken, 4=IcebergLettuce, 5=Almonds
int: nFoods = 5;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: protein = [20, 6, 17, 1, 10];
array[FOODS] of int: carbs   = [12, 29, 26, 8, 2];
array[FOODS] of int: calories= [167, 275, 112, 148, 286];
array[FOODS] of int: cost    = [7, 8, 2, 8, 2];

int: reqProtein  = 83;
int: reqCarbs    = 128;
int: reqCalories = 1686;

% Decision: number of servings of each food (nonnegative integers)
% Upper bound: safe big-M based on cheapest calories (112) -> 1686/112 < 16
array[FOODS] of var 0..50: x;

var int: totalCost = sum(f in FOODS)(cost[f] * x[f]);

constraint sum(f in FOODS)(protein[f]  * x[f]) >= reqProtein;
constraint sum(f in FOODS)(carbs[f]    * x[f]) >= reqCarbs;
constraint sum(f in FOODS)(calories[f] * x[f]) >= reqCalories;

solve minimize totalCost;

output [
  show(totalCost)
];