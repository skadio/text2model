include "globals.mzn";

% Diet / meal planning MILP as a pure integer model

int: nFoods = 4;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: protein = [19, 4, 3, 8];
array[FOODS] of int: carbs   = [ 9,16,11, 7];
array[FOODS] of int: calories= [83,166,71,56];
array[FOODS] of int: cost    = [ 7, 7,10, 2];

int: reqProtein  = 84;
int: reqCarbs    = 132;
int: reqCalories = 1990;

% Decision variables: number of units purchased of each food item (nonnegative integers)
% Upper bound chosen safely; not tight but sufficient.
int: UB = 1000;
array[FOODS] of var 0..UB: x;

% Nutrient constraints
constraint sum(i in FOODS)(protein[i]  * x[i]) >= reqProtein;
constraint sum(i in FOODS)(carbs[i]    * x[i]) >= reqCarbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= reqCalories;

% Objective: minimize total cost
var 0..(UB * sum(i in FOODS)(cost[i])): totalCost = sum(i in FOODS)(cost[i] * x[i]);

solve minimize totalCost;

output [
  "x = ", show(x), "\n",
  "Total cost = $", show(totalCost), "\n",
  "Protein  = ", show(sum(i in FOODS)(protein[i]  * x[i])), " (>= ", show(reqProtein), ")\n",
  "Carbs    = ", show(sum(i in FOODS)(carbs[i]    * x[i])), " (>= ", show(reqCarbs), ")\n",
  "Calories = ", show(sum(i in FOODS)(calories[i] * x[i])), " (>= ", show(reqCalories), ")\n"
];