% Parameters
int: N = 6;
set of int: FOODS = 1..N;

array[FOODS] of string: food_name = ["Eggs","Chicken","Tofu","Salmon","Brown Rice","Spinach"];

array[FOODS] of int: protein = [1, 4, 13, 8, 7, 8];
array[FOODS] of int: carbs   = [13,10,  9, 3,13,16];
array[FOODS] of int: calories= [211,256,273,54,93,52];
array[FOODS] of int: cost    = [10, 9,  2,10, 8, 1];

int: min_protein  = 60;
int: min_carbs    = 122;
int: min_calories = 2028;

% Safe upper bounds derived from requirements (tighten domains)
int: UB_protein  = max([ (min_protein  div protein[i])  + (if min_protein  mod protein[i]  > 0 then 1 else 0 endif) | i in FOODS ]);
int: UB_carbs    = max([ (min_carbs    div carbs[i])    + (if min_carbs    mod carbs[i]    > 0 then 1 else 0 endif) | i in FOODS ]);
int: UB_calories = max([ (min_calories div calories[i]) + (if min_calories mod calories[i] > 0 then 1 else 0 endif) | i in FOODS ]);
int: UB = max([UB_protein, UB_carbs, UB_calories]);

% Variables
array[FOODS] of var 0..UB: x;          % servings/units of each food item (integer)
var 0..(UB * sum(cost)): total_cost;

% Constraints
constraint total_cost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i]  * x[i]) >= min_protein;
constraint sum(i in FOODS)(carbs[i]    * x[i]) >= min_carbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= min_calories;

% Objective
solve minimize total_cost;