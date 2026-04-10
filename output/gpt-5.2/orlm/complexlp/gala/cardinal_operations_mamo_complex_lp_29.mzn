% Diet / nutrition minimum-cost problem (all data embedded)

include "globals.mzn";

set of int: FOODS = 1..4;
array[FOODS] of string: name = ["Chicken","Tofu","Rice","Avocado"];

% Nutrition and cost per unit serving
array[FOODS] of int: protein = [ 2, 18,  2, 18];
array[FOODS] of int: carbs   = [ 4, 17, 28, 27];
array[FOODS] of int: cal     = [218,290,298,158];
array[FOODS] of int: cost    = [ 3,  6,  1, 10];

% Requirements (at least)
int: reqProtein = 86;
int: reqCarbs   = 120;
int: reqCal     = 2435;

% Decision: number of servings of each food (nonnegative integers)
% Upper bounds chosen safely large enough for feasibility.
array[FOODS] of var 0..200: x;

var int: totalProtein = sum(i in FOODS)(protein[i] * x[i]);
var int: totalCarbs   = sum(i in FOODS)(carbs[i]   * x[i]);
var int: totalCal     = sum(i in FOODS)(cal[i]     * x[i]);
var int: totalCost    = sum(i in FOODS)(cost[i]    * x[i]);

constraint totalProtein >= reqProtein;
constraint totalCarbs   >= reqCarbs;
constraint totalCal     >= reqCal;

solve minimize totalCost;

output [
  "Servings:\n",
  concat([ name[i] ++ " = " ++ show(x[i]) ++ "\n" | i in FOODS ]),
  "\nTotals:\n",
  "Protein = ", show(totalProtein), " (>= ", show(reqProtein), ")\n",
  "Carbs   = ", show(totalCarbs),   " (>= ", show(reqCarbs), ")\n",
  "Cal     = ", show(totalCal),     " (>= ", show(reqCal), ")\n",
  "\nMinimum cost = $", show(totalCost), "\n"
];