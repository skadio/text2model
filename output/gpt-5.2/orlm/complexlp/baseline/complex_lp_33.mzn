% Diet optimization: minimize cost while meeting nutrient requirements.
% Data embedded directly in the model.

set of int: FOODS = 1..5;

array[FOODS] of string: name = ["Chicken","Rice","Beans","Broccoli","Fruit"];

array[FOODS] of int: protein = [12, 12, 19, 19, 4];
array[FOODS] of int: carbs   = [ 2, 24, 18,  7,27];
array[FOODS] of int: calories= [186,250,134, 84,104];
array[FOODS] of int: cost    = [ 6,  6,  6,  7,  9];

int: req_protein  = 97;
int: req_carbs    = 163;
int: req_calories = 2217;

% Decision variables: number of servings of each food (nonnegative integers)
array[FOODS] of var 0..1000: x;

constraint sum(i in FOODS)(protein[i]  * x[i]) >= req_protein;
constraint sum(i in FOODS)(carbs[i]    * x[i]) >= req_carbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= req_calories;

var int: total_cost = sum(i in FOODS)(cost[i] * x[i]);

solve minimize total_cost;

output [
  "Minimum cost = $", show(total_cost), "\n",
  "Servings:\n",
  concat([ name[i] ++ ": " ++ show(x[i]) ++ "\n" | i in FOODS ]),
  "Totals:\n",
  "Protein: " ++ show(sum(i in FOODS)(protein[i] * x[i])) ++ " g\n",
  "Carbs: " ++ show(sum(i in FOODS)(carbs[i] * x[i])) ++ " g\n",
  "Calories: " ++ show(sum(i in FOODS)(calories[i] * x[i])) ++ " kcal\n"
];