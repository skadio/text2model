% Diet optimization: minimize cost while meeting minimum nutrition requirements.
% All data embedded.

set of int: FOODS = 1..4;
array[FOODS] of string: food = ["Chicken","Tofu","Rice","Avocado"];

array[FOODS] of int: protein = [2, 18, 2, 18];
array[FOODS] of int: carbs   = [4, 17, 28, 27];
array[FOODS] of int: calories= [218, 290, 298, 158];
array[FOODS] of int: cost    = [3, 6, 1, 10];

int: min_protein = 86;
int: min_carbs   = 120;
int: min_calories= 2435;

% Decision variables: number of servings of each food (nonnegative integers).
% Upper bound chosen safely using the cheapest-per-calorie item (Rice) to meet calories.
int: MAX_SERV = 3000;
array[FOODS] of var 0..MAX_SERV: x;

var int: total_cost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i]  * x[i]) >= min_protein;
constraint sum(i in FOODS)(carbs[i]    * x[i]) >= min_carbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= min_calories;

solve minimize total_cost;

output [
  "Minimum cost = $", show(total_cost), "\n",
  "Servings:\n"
] ++
[
  food[i] ++ ": " ++ show(x[i]) ++ "\n" | i in FOODS
] ++
[
  "\nTotals:\n",
  "Protein: ", show(sum(i in FOODS)(protein[i]*x[i])), " g\n",
  "Carbs:   ", show(sum(i in FOODS)(carbs[i]*x[i])), " g\n",
  "Calories:", show(sum(i in FOODS)(calories[i]*x[i])), "\n"
];