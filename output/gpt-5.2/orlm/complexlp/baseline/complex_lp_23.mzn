% Diet problem: minimize cost while meeting nutrition requirements

int: n = 8;
set of int: FOODS = 1..n;

array[FOODS] of int: protein = [1, 18, 19, 19, 3, 8, 15, 3];
array[FOODS] of int: carbs   = [4,  2,  26, 10, 24, 26, 27, 30];
array[FOODS] of int: calories= [93, 219, 155,105,255,182,173,191];
array[FOODS] of int: cost    = [6,  4,   4,  3,  2,  7,  3,  3];

int: req_protein = 98;
int: req_carbs   = 113;
int: req_calories= 1768;

% Decision variables: number of servings of each food item
int: max_servings = 1000;
array[FOODS] of var 0..max_servings: x;

constraint sum(i in FOODS)(protein[i] * x[i]) >= req_protein;
constraint sum(i in FOODS)(carbs[i]   * x[i]) >= req_carbs;
constraint sum(i in FOODS)(calories[i]* x[i]) >= req_calories;

var int: total_cost = sum(i in FOODS)(cost[i] * x[i]);

solve minimize total_cost;

output [
  "Servings:\n",
  concat([ "Food_", show(i), " = ", show(x[i]), "\n" | i in FOODS ]),
  "Total protein  = ", show(sum(i in FOODS)(protein[i]*x[i])), "\n",
  "Total carbs    = ", show(sum(i in FOODS)(carbs[i]*x[i])), "\n",
  "Total calories = ", show(sum(i in FOODS)(calories[i]*x[i])), "\n",
  "Minimum cost   = ", show(total_cost), "\n"
];