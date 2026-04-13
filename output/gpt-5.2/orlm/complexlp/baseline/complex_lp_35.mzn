% Weekly meal prep diet optimization (all data embedded)

int: nFoods = 7;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: cost     = [6, 2, 10, 6, 4, 1, 9];
array[FOODS] of int: protein  = [6, 16, 12, 9, 12, 12, 13];
array[FOODS] of int: carbs    = [3, 3, 17, 28, 17, 14, 20];
array[FOODS] of int: calories = [73, 181, 231, 160, 209, 184, 118];

int: minProtein  = 59;
int: minCarbs    = 179;
int: minCalories = 2414;

% Decision variables: number of servings of each food (nonnegative integers)
% Upper bound chosen safely large enough for feasibility.
array[FOODS] of var 0..100: x;

constraint sum(i in FOODS)(protein[i]  * x[i]) >= minProtein;
constraint sum(i in FOODS)(carbs[i]    * x[i]) >= minCarbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= minCalories;

var int: totalCost = sum(i in FOODS)(cost[i] * x[i]);

solve minimize totalCost;

output [
  "Minimum cost: $", show(totalCost), "\n",
  "Servings per food:\n",
  concat([ "Food_", show(i), " = ", show(x[i]), "\n" | i in FOODS ]),
  "Totals:\n",
  "Protein = ", show(sum(i in FOODS)(protein[i] * x[i])), " g\n",
  "Carbs = ", show(sum(i in FOODS)(carbs[i] * x[i])), " g\n",
  "Calories = ", show(sum(i in FOODS)(calories[i] * x[i])), "\n"
];