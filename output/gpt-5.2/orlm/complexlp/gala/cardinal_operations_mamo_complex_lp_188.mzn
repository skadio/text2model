include "globals.mzn";

% Data (embedded from problem statement)
int: nFoods = 4;
set of int: FOODS = 1..nFoods;

array[FOODS] of string: name = ["Bread","Milk","Fish","Potato"];

array[FOODS] of int: protein = [4, 6, 20, 1];
array[FOODS] of int: carbs   = [7,10,  0,30];
array[FOODS] of int: calories= [130,120,150,70];
array[FOODS] of int: cost    = [3,  4,  8,  2];

int: minProtein = 40;
int: minCarbs   = 50;
int: minCal     = 450;

% Decision variables: number of servings of each food
% Upper bound chosen safely large enough for feasibility and optimality.
array[FOODS] of var 0..50: x;

% Nutrition constraints
constraint sum(f in FOODS)(protein[f]  * x[f]) >= minProtein;
constraint sum(f in FOODS)(carbs[f]    * x[f]) >= minCarbs;
constraint sum(f in FOODS)(calories[f] * x[f]) >= minCal;

% Objective: minimize total cost
var 0..10000: totalCost = sum(f in FOODS)(cost[f] * x[f]);

solve minimize totalCost;

output [
  "Servings:\n",
  concat([ name[f] ++ " = " ++ show(x[f]) ++ "\n" | f in FOODS ]),
  "Total protein = ", show(sum(f in FOODS)(protein[f]*x[f])), " g\n",
  "Total carbs   = ", show(sum(f in FOODS)(carbs[f]*x[f])), " g\n",
  "Total calories= ", show(sum(f in FOODS)(calories[f]*x[f])), "\n",
  "Total cost (rounded to nearest dollar) = $", show(totalCost), "\n"
];