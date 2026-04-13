% Diet / nutrition minimum-cost problem with all data embedded.

set of int: FOODS = 1..8;

array[FOODS] of string: name =
["Chicken","Rice","Eggs","Beans","Spinach","Corn","Beef","Broccoli"];

array[FOODS] of int: protein = [5, 8, 18, 16, 3, 3, 6, 17];
array[FOODS] of int: carbs   = [15,17, 20, 15,28,19,24, 9];
array[FOODS] of int: calories= [162,282,234, 85,194,153,167,192];
array[FOODS] of int: cost    = [8, 4,  1,  4,  7,  2,  9,  3];

int: req_protein  = 68;
int: req_carbs    = 189;
int: req_calories = 1840;

% Decision variables: number of servings/units of each food (nonnegative integers).
array[FOODS] of var 0..100: x;

constraint sum(i in FOODS)(protein[i]  * x[i]) >= req_protein;
constraint sum(i in FOODS)(carbs[i]    * x[i]) >= req_carbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= req_calories;

var int: total_cost = sum(i in FOODS)(cost[i] * x[i]);

solve minimize total_cost;

output [
  "Minimum cost: $", show(total_cost), "\n",
  "Chosen quantities:\n"
] ++
[
  name[i] ++ ": " ++ show(x[i]) ++ "\n" | i in FOODS
] ++
[
  "\nTotals:\n",
  "Protein: " ++ show(sum(i in FOODS)(protein[i]*x[i])) ++ "\n",
  "Carbs: " ++ show(sum(i in FOODS)(carbs[i]*x[i])) ++ "\n",
  "Calories: " ++ show(sum(i in FOODS)(calories[i]*x[i])) ++ "\n"
];