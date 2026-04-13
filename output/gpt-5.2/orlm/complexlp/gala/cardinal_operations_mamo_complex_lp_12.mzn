% Diet planning / minimum cost nutrition problem
% All data embedded as requested.

include "globals.mzn";

int: nFoods = 4;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: protein = [2, 11, 19, 17];
array[FOODS] of int: carbs   = [9, 29, 16, 9];
array[FOODS] of int: cal     = [165, 230, 68, 258];
array[FOODS] of int: price   = [3, 3, 6, 9];

int: reqProtein = 88;
int: reqCarbs   = 107;
int: reqCal     = 1944;

% Decision variables: how many servings of each food (nonnegative integers)
% Upper bound chosen safely: enough to meet calories with cheapest-per-calorie food (food 1: 165 cal)
int: maxServ = 20; % 1944/165 < 12, so 20 is plenty
array[FOODS] of var 0..maxServ: x;

% Nutrition constraints
constraint sum(i in FOODS)(protein[i] * x[i]) >= reqProtein;
constraint sum(i in FOODS)(carbs[i]   * x[i]) >= reqCarbs;
constraint sum(i in FOODS)(cal[i]     * x[i]) >= reqCal;

% Objective: minimize total cost
var int: totalCost = sum(i in FOODS)(price[i] * x[i]);

solve minimize totalCost;

output [
  "Servings x = ", show(x), "\n",
  "Total protein = ", show(sum(i in FOODS)(protein[i] * x[i])), "\n",
  "Total carbs   = ", show(sum(i in FOODS)(carbs[i] * x[i])), "\n",
  "Total calories= ", show(sum(i in FOODS)(cal[i] * x[i])), "\n",
  "Total cost    = $", show(totalCost), "\n"
];