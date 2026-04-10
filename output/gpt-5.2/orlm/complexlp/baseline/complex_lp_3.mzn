% Diet problem: minimize cost while meeting nutrition requirements.
% All data embedded.

int: n = 6;
set of int: FOODS = 1..n;

array[FOODS] of int: cost = [4, 2, 6, 2, 6, 8];
array[FOODS] of int: protein = [17, 4, 7, 14, 13, 1];
array[FOODS] of int: carbs   = [8, 24, 27, 16, 1, 13];
array[FOODS] of int: calories= [237, 213, 133, 118, 136, 225];

int: req_protein = 76;
int: req_carbs   = 173;
int: req_calories= 1751;

% Upper bounds sufficient for feasibility:
int: max_items = 100; % safe global cap

array[FOODS] of var 0..max_items: x; % number of servings of each food

constraint sum(i in FOODS)(protein[i] * x[i]) >= req_protein;
constraint sum(i in FOODS)(carbs[i]   * x[i]) >= req_carbs;
constraint sum(i in FOODS)(calories[i]* x[i]) >= req_calories;

var int: total_cost = sum(i in FOODS)(cost[i] * x[i]);

solve minimize total_cost;

output [
  "Minimum cost: $", show(total_cost), "\n",
  "Servings:\n",
  concat([ "  Food_", show(i), ": ", show(x[i]), "\n" | i in FOODS ]),
  "Totals:\n",
  "  Protein: ", show(sum(i in FOODS)(protein[i] * x[i])), " g\n",
  "  Carbs:   ", show(sum(i in FOODS)(carbs[i] * x[i])), " g\n",
  "  Calories:", show(sum(i in FOODS)(calories[i] * x[i])), "\n"
];