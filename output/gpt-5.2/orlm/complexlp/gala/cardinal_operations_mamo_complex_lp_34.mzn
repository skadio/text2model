% Diet / meal-planning as an integer linear optimization problem
% Minimize total cost while meeting minimum weekly nutrient requirements.

include "globals.mzn";

int: nFoods = 7;
set of int: FOODS = 1..nFoods;

array[FOODS] of string: name =
  ["Chicken","Tuna","Eggs","Beef","Rice","Apples","Bread"];

array[FOODS] of int: protein = [18,12,7,17,3,4,4];
array[FOODS] of int: carbs   = [23,30,16,26,30,6,23];
array[FOODS] of int: cal     = [217,182,79,295,264,160,141];
array[FOODS] of int: cost    = [3,10,10,7,4,6,5];

int: reqProtein = 59;
int: reqCarbs   = 160;
int: reqCal     = 1809;

% Decision: number of servings/units of each food over the week
% Upper bound chosen safely large (can be tightened if desired).
array[FOODS] of var 0..200: x;

constraint sum(i in FOODS)(protein[i] * x[i]) >= reqProtein;
constraint sum(i in FOODS)(carbs[i]   * x[i]) >= reqCarbs;
constraint sum(i in FOODS)(cal[i]     * x[i]) >= reqCal;

var int: totalCost = sum(i in FOODS)(cost[i] * x[i]);

solve minimize totalCost;

output [
  "Minimum cost = $", show(totalCost), "\n",
  "Quantities (servings):\n"
] ++
[
  name[i] ++ ": " ++ show(x[i]) ++ "\n"
  | i in FOODS
] ++
[
  "\nTotals:\n",
  "Protein = ", show(sum(i in FOODS)(protein[i]*x[i])), " (>= ", show(reqProtein), ")\n",
  "Carbs   = ", show(sum(i in FOODS)(carbs[i]*x[i])),   " (>= ", show(reqCarbs), ")\n",
  "Calories= ", show(sum(i in FOODS)(cal[i]*x[i])),     " (>= ", show(reqCal), ")\n"
];