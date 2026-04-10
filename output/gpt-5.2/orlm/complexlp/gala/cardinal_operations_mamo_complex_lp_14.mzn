% Diet optimization: choose quantities of 8 foods to meet minimum nutrition at minimum cost
include "globals.mzn";

% Data (embedded as required)
int: nFoods = 8;
set of int: FOODS = 1..nFoods;

array[FOODS] of string: name =
  ["Eggs","Grains","Berries","Nuts","Salmon","Vegetables","Rice","Meat"];

array[FOODS] of int: cost    = [4, 3, 2, 4, 9, 3, 6, 6];
array[FOODS] of int: protein = [2, 7, 6, 16, 20, 6, 6, 5];
array[FOODS] of int: carbs   = [4, 9, 18, 3, 11, 27, 30, 1];
array[FOODS] of int: calories= [282,104, 71,116,175,132,251, 74];

int: minProtein  = 84;
int: minCarbs    = 195;
int: minCalories = 1941;

% Decision variables: number of units/servings of each food (nonnegative integers)
% Upper bound chosen safely (large enough for feasibility, small enough for solving)
int: maxUnits = 200;
array[FOODS] of var 0..maxUnits: x;

% Derived totals
var 0..(maxUnits * sum(protein)):  totProtein  = sum(i in FOODS)(protein[i] * x[i]);
var 0..(maxUnits * sum(carbs)):    totCarbs    = sum(i in FOODS)(carbs[i] * x[i]);
var 0..(maxUnits * sum(calories)): totCalories = sum(i in FOODS)(calories[i] * x[i]);
var 0..(maxUnits * sum(cost)):     totCost     = sum(i in FOODS)(cost[i] * x[i]);

% Nutrition constraints
constraint totProtein  >= minProtein;
constraint totCarbs    >= minCarbs;
constraint totCalories >= minCalories;

% Objective: minimize cost
solve minimize totCost;

output [
  "Minimum cost = $", show(totCost), "\n",
  "Totals: protein=", show(totProtein), "g, carbs=", show(totCarbs),
  "g, calories=", show(totCalories), "\n",
  "Chosen units:\n"
] ++
[
  name[i] ++ ": " ++ show(x[i]) ++ "\n"
  | i in FOODS
];