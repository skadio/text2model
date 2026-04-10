% Diet cost minimization with embedded data

set of int: FOODS = 1..6;
array[FOODS] of string: name = [
  "Chicken Breast",
  "Brown Rice",
  "Tofu",
  "Spinach",
  "Almonds",
  "Salmon"
];

array[FOODS] of int: cost     = [4, 10, 6, 1, 8, 6];
array[FOODS] of int: protein  = [14, 11, 20, 6, 9, 20];
array[FOODS] of int: carbs    = [4, 17, 12, 20, 11, 19];
array[FOODS] of int: calories = [275, 151, 155, 106, 279, 93];

int: req_protein  = 78;
int: req_carbs    = 140;
int: req_calories = 1537;

% Decision variables: number of servings of each food (nonnegative integers)
array[FOODS] of var 0..1000: x;

constraint sum(f in FOODS)(protein[f] * x[f])  >= req_protein;
constraint sum(f in FOODS)(carbs[f] * x[f])    >= req_carbs;
constraint sum(f in FOODS)(calories[f] * x[f]) >= req_calories;

var int: total_cost = sum(f in FOODS)(cost[f] * x[f]);

solve minimize total_cost;

output [
  "Minimum cost = $", show(total_cost), "\n",
  "Servings:\n"
] ++
[
  "  " ++ name[f] ++ ": " ++ show(x[f]) ++ "\n"
  | f in FOODS
] ++
[
  "\nTotals:\n",
  "  Protein:  " ++ show(sum(f in FOODS)(protein[f] * x[f])) ++ " g\n",
  "  Carbs:    " ++ show(sum(f in FOODS)(carbs[f] * x[f])) ++ " g\n",
  "  Calories: " ++ show(sum(f in FOODS)(calories[f] * x[f])) ++ " kcal\n"
];