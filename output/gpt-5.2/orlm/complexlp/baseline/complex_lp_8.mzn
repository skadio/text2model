% Diet problem: minimize cost while meeting minimum nutrition requirements
int: n = 9;
set of int: FOODS = 1..n;

array[FOODS] of int: cost = [10, 2, 7, 8, 4, 9, 2, 9, 9];
array[FOODS] of int: protein = [7, 12, 14, 9, 11, 10, 10, 9, 8];
array[FOODS] of int: carbs   = [17, 12, 27, 6, 19, 23, 6, 16, 25];
array[FOODS] of int: calories= [95, 233, 134, 109, 202, 148, 184, 136, 229];

int: min_protein = 71;
int: min_carbs   = 107;
int: min_calories= 1623;

% Upper bounds sufficient for feasibility search
int: max_units = 50;

array[FOODS] of var 0..max_units: x;

constraint sum(i in FOODS)(protein[i] * x[i]) >= min_protein;
constraint sum(i in FOODS)(carbs[i]   * x[i]) >= min_carbs;
constraint sum(i in FOODS)(calories[i]* x[i]) >= min_calories;

var int: total_cost = sum(i in FOODS)(cost[i] * x[i]);

solve minimize total_cost;

output [ show(total_cost) ];