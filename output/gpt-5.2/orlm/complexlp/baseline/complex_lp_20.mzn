% Diet optimization: minimize cost while meeting nutrient minimums

set of int: FOODS = 1..4;
int: CHICKEN = 1;
int: CHEESE  = 2;
int: RICE    = 3;
int: BEANS   = 4;

array[FOODS] of string: food_name = ["Chicken","Cheese","Rice","Beans"];

array[FOODS] of int: cost     = [5, 9, 2, 1];
array[FOODS] of int: protein  = [16,10,12,13];
array[FOODS] of int: carbs    = [22, 4,21,14];
array[FOODS] of int: calories = [292,82,207,81];

int: min_protein  = 94;
int: min_carbs    = 191;
int: min_calories = 2271;

% Number of servings for each food (nonnegative integers).
% Upper bounds chosen safely based on calorie minimum vs smallest calories per serving (81).
array[FOODS] of var 0..100: x;

constraint sum(i in FOODS)(protein[i]  * x[i]) >= min_protein;
constraint sum(i in FOODS)(carbs[i]    * x[i]) >= min_carbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= min_calories;

var int: total_cost = sum(i in FOODS)(cost[i] * x[i]);

solve minimize total_cost;

output [
  "Minimum cost = $", show(total_cost), "\n",
  "Servings:\n"
] ++
[
  "  " ++ food_name[i] ++ ": " ++ show(x[i]) ++ "\n"
  | i in FOODS
] ++
[
  "Totals:\n",
  "  Protein  = ", show(sum(i in FOODS)(protein[i]  * x[i])), " g\n",
  "  Carbs    = ", show(sum(i in FOODS)(carbs[i]    * x[i])), " g\n",
  "  Calories = ", show(sum(i in FOODS)(calories[i] * x[i])), "\n"
];