% Diet optimization: minimize cost while meeting nutrition targets.

int: nFoods = 4;
set of int: FOODS = 1..nFoods;

array[FOODS] of int: cost = [4, 4, 2, 4];          % Chicken, Rice, Beans, Avocado
array[FOODS] of int: protein = [14, 5, 9, 10];
array[FOODS] of int: carbs   = [7, 13, 26, 14];
array[FOODS] of int: cal     = [208, 140, 280, 199];

int: targetProtein = 74;
int: targetCarbs   = 166;
int: targetCal     = 2210;

% Servings are nonnegative integers
array[FOODS] of var 0..500: x;

constraint sum(i in FOODS)(protein[i] * x[i]) >= targetProtein;
constraint sum(i in FOODS)(carbs[i]   * x[i]) >= targetCarbs;
constraint sum(i in FOODS)(cal[i]     * x[i]) >= targetCal;

var int: totalCost = sum(i in FOODS)(cost[i] * x[i]);

solve minimize totalCost;

output [ show(totalCost) ];