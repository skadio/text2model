% Diet optimization (min-cost) with embedded data
% Units:
%  - cost: dollars per serving
%  - protein/carbs: grams per serving
%  - calories: kcal per serving

include "globals.mzn";

int: nFoods = 9;
set of int: FOODS = 1..nFoods;

array[FOODS] of string: name =
  ["Beef","Pasta","Broccoli","Chicken","Apple","Pork","Lentils","Eggs","Cheese"];

array[FOODS] of int: cost     = [5,6,5,4,1,6,1,2,7];
array[FOODS] of int: protein  = [18,2,7,20,5,13,15,20,9];
array[FOODS] of int: carbs    = [13,25,30,16,6,9,18,18,14];
array[FOODS] of int: calories = [233,251,191,231,111,275,99,210,74];

int: minProtein = 68;
int: minCarbs   = 151;
int: minCal     = 1900;

% Decision: number of servings of each food (nonnegative integers)
% Upper bound chosen conservatively (enough to reach calorie target with lowest-cal item)
int: maxServ = 30;
array[FOODS] of var 0..maxServ: servings;

var int: totalCost = sum(i in FOODS)(cost[i] * servings[i]);
var int: totalProtein = sum(i in FOODS)(protein[i] * servings[i]);
var int: totalCarbs   = sum(i in FOODS)(carbs[i] * servings[i]);
var int: totalCal     = sum(i in FOODS)(calories[i] * servings[i]);

constraint totalProtein >= minProtein;
constraint totalCarbs   >= minCarbs;
constraint totalCal     >= minCal;

solve minimize totalCost;

output [
  "Minimum cost = $", show(totalCost), "\n",
  "Total protein = ", show(totalProtein), " g\n",
  "Total carbs   = ", show(totalCarbs), " g\n",
  "Total calories= ", show(totalCal), " kcal\n\n",
  "Servings:\n"
] ++
[
  if fix(servings[i]) > 0 then
    "  " ++ name[i] ++ ": " ++ show(servings[i]) ++ "\n"
  else
    ""
  endif
  | i in FOODS
];