include "globals.mzn";

/* Data (embedded as required) */
int: nFoods = 4;
set of int: FOODS = 1..nFoods;

array[FOODS] of string: name = ["Eggs","Rice","Chicken","Broccoli"];

array[FOODS] of int: cost     = [6, 10, 1, 7];
array[FOODS] of int: protein  = [4, 1, 10, 8];
array[FOODS] of int: carbs    = [13, 13, 29, 26];
array[FOODS] of int: calories = [238, 85, 146, 139];

int: minProtein  = 93;
int: minCarbs    = 165;
int: minCalories = 1553;

/* A safe finite upper bound on servings (never needed larger in an optimum):
   using the cheapest item (Chicken) to cover each requirement */
int: maxServ =
  max( max(ceil(minProtein / min(protein)), ceil(minCarbs / min(carbs))),
       ceil(minCalories / min(calories)) );

/* Decision variables: number of servings of each food */
array[FOODS] of var 0..maxServ: x;

/* Nutrition constraints */
constraint sum(i in FOODS)(protein[i]  * x[i]) >= minProtein;
constraint sum(i in FOODS)(carbs[i]    * x[i]) >= minCarbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= minCalories;

/* Objective: minimize total cost */
var int: totalCost = sum(i in FOODS)(cost[i] * x[i]);

solve minimize totalCost;

output [
  "Servings = [",
  concat([ if i > 1 then ", " else "" endif ++ name[i] ++ "=" ++ show(x[i]) | i in FOODS ]),
  "]\n",
  "Total cost = ", show(totalCost), "\n",
  "Total protein = ", show(sum(i in FOODS)(protein[i]*x[i])), "\n",
  "Total carbs = ", show(sum(i in FOODS)(carbs[i]*x[i])), "\n",
  "Total calories = ", show(sum(i in FOODS)(calories[i]*x[i])), "\n"
];