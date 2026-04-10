% Diet problem: minimize cost while meeting nutrition requirements

int: nFoods = 6;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: protein = [15, 16, 3, 19, 11, 10];
array[FOODS] of int: carbs   = [10, 25, 8, 20, 8, 9];
array[FOODS] of int: cal     = [163,108,198,141,105,199];
array[FOODS] of int: cost    = [10, 4, 1, 7, 6, 8];

int: reqProteinMin = 88;
int: reqCarbsMin   = 144;
int: reqCalMin     = 1900;

% Decision: integer number of servings of each food (nonnegative)
% Upper bound chosen large enough to allow feasibility.
array[FOODS] of var 0..200: x;

constraint sum(i in FOODS)(protein[i] * x[i]) >= reqProteinMin;
constraint sum(i in FOODS)(carbs[i]   * x[i]) >= reqCarbsMin;
constraint sum(i in FOODS)(cal[i]     * x[i]) >= reqCalMin;

var int: totalCost = sum(i in FOODS)(cost[i] * x[i]);

solve minimize totalCost;

output [
  "Minimum cost = $", show(totalCost), "\n",
  "Servings:\n",
  concat([ "  Food ", show(i), ": ", show(x[i]), "\n" | i in FOODS ]),
  "Totals:\n",
  "  Protein = ", show(sum(i in FOODS)(protein[i]*x[i])), " g\n",
  "  Carbs   = ", show(sum(i in FOODS)(carbs[i]*x[i])), " g\n",
  "  Calories= ", show(sum(i in FOODS)(cal[i]*x[i])), "\n"
];