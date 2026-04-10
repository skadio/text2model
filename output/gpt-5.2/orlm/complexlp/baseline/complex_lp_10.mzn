% Diet optimization: minimize cost while meeting nutrient requirements

int: n = 5;
set of int: FOODS = 1..n;

array[FOODS] of string: name = ["Steak","Rice","Chicken","IcebergLettuce","Almonds"];

array[FOODS] of int: protein = [20, 6, 17, 1, 10];
array[FOODS] of int: carbs   = [12,29, 26, 8,  2];
array[FOODS] of int: calories= [167,275,112,148,286];
array[FOODS] of int: cost    = [7,  8,  2,  8,  2];

int: req_protein = 83;
int: req_carbs   = 128;
int: req_calories= 1686;

% Integer number of servings of each food (unbounded, but bounded above for search)
array[FOODS] of var 0..200: x;

constraint sum(i in FOODS)(protein[i] * x[i])  >= req_protein;
constraint sum(i in FOODS)(carbs[i]   * x[i])  >= req_carbs;
constraint sum(i in FOODS)(calories[i]* x[i])  >= req_calories;

var int: total_cost = sum(i in FOODS)(cost[i] * x[i]);

solve minimize total_cost;

output [
  "optimal_cost=", show(total_cost), "\n",
  "servings:\n"
] ++ [ name[i] ++ "=" ++ show(x[i]) ++ (if i < n then "\n" else "\n" endif) | i in FOODS ];