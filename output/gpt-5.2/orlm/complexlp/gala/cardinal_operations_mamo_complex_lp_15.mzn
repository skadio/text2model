include "globals.mzn";

% ----- Data (embedded) -----
int: nFoods = 6;
set of int: FOODS = 1..nFoods;

array[FOODS] of string: name =
  ["Eggs","Chicken","Tofu","Salmon","Brown Rice","Spinach"];

array[FOODS] of int: protein = [1, 4, 13, 8, 7, 8];
array[FOODS] of int: carbs   = [13,10,  9, 3,13,16];
array[FOODS] of int: cal     = [211,256,273,54,93,52];
array[FOODS] of int: cost    = [10, 9,  2,10, 8, 1];

int: reqProtein = 60;
int: reqCarbs   = 122;
int: reqCal     = 2028;

% Safe upper bound (unbounded integer program otherwise):
% Using the cheapest-per-calorie item (Tofu: 273 cal) gives at most ceil(2028/52)=39-ish,
% but allow slack for other constraints.
int: maxQty = 100;

% ----- Decision variables -----
array[FOODS] of var 0..maxQty: qty;   % number of servings of each food item

% ----- Constraints -----
constraint sum(i in FOODS)(protein[i] * qty[i]) >= reqProtein;
constraint sum(i in FOODS)(carbs[i]   * qty[i]) >= reqCarbs;
constraint sum(i in FOODS)(cal[i]     * qty[i]) >= reqCal;

% ----- Objective -----
var int: totalCost = sum(i in FOODS)(cost[i] * qty[i]);
solve minimize totalCost;

% ----- Output -----
output [
  "Minimum cost = $", show(totalCost), "\n",
  "Quantities:\n",
  concat([ name[i] ++ ": " ++ show(qty[i]) ++ "\n" | i in FOODS ]),
  "Totals:\n",
  "Protein = ", show(sum(i in FOODS)(protein[i]*qty[i])), "\n",
  "Carbs   = ", show(sum(i in FOODS)(carbs[i]*qty[i])), "\n",
  "Calories= ", show(sum(i in FOODS)(cal[i]*qty[i])), "\n"
];