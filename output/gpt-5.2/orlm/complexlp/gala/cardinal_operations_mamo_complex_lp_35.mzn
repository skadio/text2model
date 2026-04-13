include "globals.mzn";

% Data (embedded as required)
int: nFoods = 7;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: cost     = [6, 2, 10, 6, 4, 1, 9];
array[FOODS] of int: protein  = [6, 16, 12, 9, 12, 12, 13];
array[FOODS] of int: carbs    = [3, 3, 17, 28, 17, 14, 20];
array[FOODS] of int: calories = [73, 181, 231, 160, 209, 184, 118];

int: reqProtein  = 59;
int: reqCarbs    = 179;
int: reqCalories = 2414;

% Decision variables: how many units of each food to buy (unbounded, but safely capped)
% Upper bounds computed from worst-case needs to keep model finite.
int: maxQty =
  max( (reqProtein  div min(protein))  + 1,
  max( (reqCarbs    div min(carbs))    + 1,
       (reqCalories div min(calories)) + 1));

array[FOODS] of var 0..maxQty: x;

% Nutritional constraints
constraint sum(i in FOODS)(protein[i]  * x[i]) >= reqProtein;
constraint sum(i in FOODS)(carbs[i]    * x[i]) >= reqCarbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= reqCalories;

% Objective: minimize total cost
var int: totalCost = sum(i in FOODS)(cost[i] * x[i]);
solve minimize totalCost;

output [
  "Quantities x = ", show(x), "\n",
  "Total cost = ", show(totalCost), "\n",
  "Protein  = ", show(sum(i in FOODS)(protein[i]  * x[i])), "\n",
  "Carbs    = ", show(sum(i in FOODS)(carbs[i]    * x[i])), "\n",
  "Calories = ", show(sum(i in FOODS)(calories[i] * x[i])), "\n"
];