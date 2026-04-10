% Diet / meal plan optimization (all data embedded)

set of int: FOODS = 1..7;
array[FOODS] of string: name = ["Chicken","Tuna","Eggs","Beef","Rice","Apples","Bread"];

array[FOODS] of int: protein = [18, 12, 7, 17, 3, 4, 4];
array[FOODS] of int: carbs   = [23, 30,16, 26,30, 6,23];
array[FOODS] of int: calories= [217,182,79,295,264,160,141];
array[FOODS] of int: cost    = [3,  10, 10, 7,  4,  6,  5];

int: target_protein  = 59;
int: target_carbs    = 160;
int: target_calories = 1809;

% Decision: number of servings of each food item (nonnegative integers)
array[FOODS] of var 0..100: x;

constraint sum(i in FOODS)(protein[i]  * x[i]) >= target_protein;
constraint sum(i in FOODS)(carbs[i]    * x[i]) >= target_carbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= target_calories;

var int: total_cost = sum(i in FOODS)(cost[i] * x[i]);

solve minimize total_cost;

output [
  "Minimum total cost = $", show(total_cost), "\n",
  "Servings:\n"
] ++
[
  name[i] ++ ": " ++ show(x[i]) ++ "\n" | i in FOODS
] ++
[
  "\nTotals:\n",
  "Protein  = ", show(sum(i in FOODS)(protein[i]  * x[i])), "\n",
  "Carbs    = ", show(sum(i in FOODS)(carbs[i]    * x[i])), "\n",
  "Calories = ", show(sum(i in FOODS)(calories[i] * x[i])), "\n"
];