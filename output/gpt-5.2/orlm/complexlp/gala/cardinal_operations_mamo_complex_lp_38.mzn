include "globals.mzn";

% Diet problem: choose nonnegative integer servings of each food to meet minimum
% protein, carbs, and calories at minimum total cost.

set of int: FOODS = 1..6;
array[FOODS] of string: name =
  ["ChickenBreast","BrownRice","Tofu","Spinach","Almonds","Salmon"];

% Cost per serving ($)
array[FOODS] of int: cost = [4, 10, 6, 1, 8, 6];

% Nutrition per serving
array[FOODS] of int: protein = [14, 11, 20, 6, 9, 20];
array[FOODS] of int: carbs   = [4, 17, 12, 20, 11, 19];
array[FOODS] of int: calories= [275,151,155,106,279, 93];

% Daily minimum requirements
int: req_protein = 78;
int: req_carbs   = 140;
int: req_cal     = 1537;

% Upper bound for servings (safe, derived from minimum calorie density = 93)
int: max_serv = ceil(int2float(req_cal) / 93.0) + 30;

array[FOODS] of var 0..max_serv: x;  % servings chosen

var int: total_cost = sum(i in FOODS)(cost[i] * x[i]);
var int: total_protein = sum(i in FOODS)(protein[i] * x[i]);
var int: total_carbs   = sum(i in FOODS)(carbs[i] * x[i]);
var int: total_cal     = sum(i in FOODS)(calories[i] * x[i]);

constraint total_protein >= req_protein;
constraint total_carbs   >= req_carbs;
constraint total_cal     >= req_cal;

solve minimize total_cost;

output [
  "Minimum cost = $", show(total_cost), "\n",
  "Servings:\n"
] ++
[
  "  ", name[i], " = ", show(x[i]), "\n"
  | i in FOODS
] ++
[
  "\nTotals:\n",
  "  protein  = ", show(total_protein), " (>= ", show(req_protein), ")\n",
  "  carbs    = ", show(total_carbs),   " (>= ", show(req_carbs), ")\n",
  "  calories = ", show(total_cal),     " (>= ", show(req_cal), ")\n"
];