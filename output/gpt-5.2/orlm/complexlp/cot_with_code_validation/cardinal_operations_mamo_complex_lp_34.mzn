% Parameters
int: N = 7;
set of int: FOODS = 1..N;

array[FOODS] of string: food_name = ["Chicken","Tuna","Eggs","Beef","Rice","Apples","Bread"];

array[FOODS] of int: protein = [18,12,7,17,3,4,4];
array[FOODS] of int: carbs   = [23,30,16,26,30,6,23];
array[FOODS] of int: calories= [217,182,79,295,264,160,141];
array[FOODS] of int: cost    = [3,10,10,7,4,6,5];

int: req_protein  = 59;
int: req_carbs    = 160;
int: req_calories = 1809;

int: max_servings = 100;

% Variables
array[FOODS] of var 0..max_servings: x;
var 0..sum(i in FOODS)(cost[i]*max_servings): total_cost;

% Constraints
constraint total_cost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i] * x[i])  >= req_protein;
constraint sum(i in FOODS)(carbs[i]   * x[i])  >= req_carbs;
constraint sum(i in FOODS)(calories[i]* x[i])  >= req_calories;

% Objective
solve minimize total_cost;