% Diet minimization problem (all data embedded)

int: n = 9;
set of int: FOODS = 1..n;

array[FOODS] of int: cost     = [10, 2, 7, 8, 4, 9, 2, 9, 9];
array[FOODS] of int: protein  = [ 7,12,14, 9,11,10,10, 9, 8];
array[FOODS] of int: carbs    = [17,12,27, 6,19,23, 6,16,25];
array[FOODS] of int: calories = [95,233,134,109,202,148,184,136,229];

int: req_protein  = 71;
int: req_carbs    = 107;
int: req_calories = 1623;

% Decision: how many units of each food to buy (nonnegative integers)
% Safe upper bound: if you only bought the best calorie item (233), need at most ceil(1623/233)=7
int: UB = 20;
array[FOODS] of var 0..UB: x;

constraint sum(i in FOODS)(protein[i]  * x[i]) >= req_protein;
constraint sum(i in FOODS)(carbs[i]    * x[i]) >= req_carbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= req_calories;

var int: total_cost = sum(i in FOODS)(cost[i] * x[i]);

solve minimize total_cost;

output [ show(total_cost) ];