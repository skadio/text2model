% Diet optimization: minimize cost while meeting nutrient minimums

set of int: FOODS = 1..5;
int: CHICKEN = 1;
int: PASTA   = 2;
int: APPLES  = 3;
int: TUNA    = 4;
int: RICE    = 5;

array[FOODS] of int: protein = [8, 10, 3, 16, 4];
array[FOODS] of int: carbs   = [8, 30, 10, 29, 24];
array[FOODS] of int: calories= [118, 131, 151, 235, 101];
array[FOODS] of int: cost    = [6, 10, 1, 9, 4];

int: min_protein  = 93;
int: min_carbs    = 181;
int: min_calories = 1620;

% Upper bounds sufficient for feasibility search
array[FOODS] of int: ub = [203, 203, 540, 203, 203];

array[FOODS] of var 0..max(ub): x;

constraint sum(i in FOODS)(protein[i]  * x[i]) >= min_protein;
constraint sum(i in FOODS)(carbs[i]    * x[i]) >= min_carbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= min_calories;

var int: total_cost = sum(i in FOODS)(cost[i] * x[i]);

solve minimize total_cost;

output [ show(total_cost) ];