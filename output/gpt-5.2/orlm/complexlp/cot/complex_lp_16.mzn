% Parameters (with values embedded)
int: N = 4;
set of int: FOODS = 1..N;

array[FOODS] of string: name = ["Chicken","Broccoli","Beef","Rice"];

array[FOODS] of int: protein = [10, 4, 13, 15];
array[FOODS] of int: carbs   = [17, 3,  8, 25];
array[FOODS] of int: calories= [159,126,230,112];
array[FOODS] of int: cost    = [5,  5,  8,  3];

int: min_protein  = 66;
int: min_carbs    = 101;
int: min_calories = 1701;

% Variables
array[FOODS] of var 0..1701: x;  % number of servings of each food (nonnegative integer)

var 0..(1701 * max(cost)): total_cost;

% Constraints
constraint total_cost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i] * x[i])  >= min_protein;
constraint sum(i in FOODS)(carbs[i] * x[i])    >= min_carbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= min_calories;

% Objective
solve minimize total_cost;