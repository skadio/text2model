% Diet minimization (unbounded integer knapsack-style LP)
include "globals.mzn";

% Foods: 1=Chicken, 2=Rice, 3=Broccoli, 4=Tofu, 5=Beans
int: nFoods = 5;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: cost    = [4, 8, 7, 10, 1];
array[FOODS] of int: protein = [18, 12, 13,  5, 10];
array[FOODS] of int: carbs   = [ 6, 28, 19, 16, 20];
array[FOODS] of int: calories= [142,88,137,141,150];

int: reqProtein  = 56;
int: reqCarbs    = 194;
int: reqCalories = 2012;

% Decision: number of servings of each food (nonnegative integers)
% Upper bound chosen large enough to never restrict feasibility.
% Using the best-per-unit foods gives small maximum counts; 0..100 is safe.
array[FOODS] of var 0..100: x;

% Nutritional requirements (at least)
constraint sum(i in FOODS)(protein[i]  * x[i]) >= reqProtein;
constraint sum(i in FOODS)(carbs[i]    * x[i]) >= reqCarbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= reqCalories;

var int: totalCost = sum(i in FOODS)(cost[i] * x[i]);

solve minimize totalCost;

output [
  "Servings (Chicken,Rice,Broccoli,Tofu,Beans) = ", show(x), "\n",
  "Total cost = ", show(totalCost), "\n",
  "Protein  = ", show(sum(i in FOODS)(protein[i]*x[i])), "\n",
  "Carbs    = ", show(sum(i in FOODS)(carbs[i]*x[i])), "\n",
  "Calories = ", show(sum(i in FOODS)(calories[i]*x[i])), "\n"
];