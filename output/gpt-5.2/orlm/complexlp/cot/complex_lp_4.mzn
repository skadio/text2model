% Parameters (with values embedded)
int: n = 6;
set of int: FOODS = 1..n;

array[FOODS] of string: food_name = ["Chicken","Oats","Tofu","Rice","Beef","Salmon"];

array[FOODS] of int: protein = [14,11,8,1,16,19];
array[FOODS] of int: carbs   = [1,6,12,17,11,13];
array[FOODS] of int: calories= [164,210,98,92,211,211];
array[FOODS] of int: cost    = [6,2,9,3,7,9];

int: req_protein = 70;
int: req_carbs = 117;
int: req_calories = 1837;

% Variables
array[FOODS] of var 0..25: x; % servings of each food (bounded for search)

var int: total_cost = sum(i in FOODS)(cost[i]*x[i]);

% Constraints
constraint sum(i in FOODS)(protein[i]*x[i]) >= req_protein;
constraint sum(i in FOODS)(carbs[i]*x[i]) >= req_carbs;
constraint sum(i in FOODS)(calories[i]*x[i]) >= req_calories;

% Objective
solve minimize total_cost;

output [show(total_cost)];