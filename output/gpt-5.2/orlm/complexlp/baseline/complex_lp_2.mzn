% Diet optimization: minimize cost while meeting nutritional requirements

int: n = 5;
set of int: FOODS = 1..n;

array[FOODS] of int: protein = [3, 17, 16, 8, 6];
array[FOODS] of int: carbs   = [16, 24, 27, 16, 6];
array[FOODS] of int: calories= [96, 182, 114, 208, 236];
array[FOODS] of int: cost    = [9, 9, 2, 9, 5];

int: req_protein  = 100;
int: req_carbs    = 180;
int: req_calories = 1796;

% Decision variables: number of servings of each food (nonnegative integers)
% Upper bound chosen safely based on the tightest requirement with the smallest contribution.
array[FOODS] of var 0..600: x;

constraint sum(i in FOODS)(protein[i] * x[i]) >= req_protein;
constraint sum(i in FOODS)(carbs[i]   * x[i]) >= req_carbs;
constraint sum(i in FOODS)(calories[i]* x[i]) >= req_calories;

var int: total_cost = sum(i in FOODS)(cost[i] * x[i]);

solve minimize total_cost;

output [
  "Total cost = $", show(total_cost), "\n",
  "Servings:\n",
  concat([ "  Food_", show(i), " = ", show(x[i]), "\n" | i in FOODS ]),
  "Totals:\n",
  "  Protein  = ", show(sum(i in FOODS)(protein[i]*x[i])), " g\n",
  "  Carbs    = ", show(sum(i in FOODS)(carbs[i]*x[i])), " g\n",
  "  Calories = ", show(sum(i in FOODS)(calories[i]*x[i])), "\n"
];