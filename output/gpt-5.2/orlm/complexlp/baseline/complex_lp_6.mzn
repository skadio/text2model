% Diet / meal prep optimization: minimize cost while meeting nutrition minimums.
% All data embedded.

int: n = 5;
set of int: FOODS = 1..n;

array[FOODS] of int: protein = [10, 3, 17, 6, 20];
array[FOODS] of int: carbs   = [22, 4, 10, 13, 5];
array[FOODS] of int: calories= [80, 189, 153, 232, 204];
array[FOODS] of int: cost    = [2, 8, 4, 1, 8];

int: min_protein  = 74;
int: min_carbs    = 102;
int: min_calories = 1564;

% Decision: number of servings of each food (nonnegative integers).
% Upper bound chosen safely based on the tightest requirement (calories) and smallest calories per serving.
int: max_servings = ceil(int2float(min_calories) / int2float(min(calories))) + 50;
array[FOODS] of var 0..max_servings: x;

constraint sum(i in FOODS)(protein[i] * x[i])  >= min_protein;
constraint sum(i in FOODS)(carbs[i] * x[i])    >= min_carbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= min_calories;

var int: total_cost = sum(i in FOODS)(cost[i] * x[i]);

solve minimize total_cost;

output [
  "Minimum cost: $", show(total_cost), "\n",
  "Servings:\n",
  concat([ "  Food_", show(i), ": ", show(x[i]), "\n" | i in FOODS ]),
  "Totals:\n",
  "  Protein:  ", show(sum(i in FOODS)(protein[i] * x[i])), "\n",
  "  Carbs:    ", show(sum(i in FOODS)(carbs[i] * x[i])), "\n",
  "  Calories: ", show(sum(i in FOODS)(calories[i] * x[i])), "\n"
];