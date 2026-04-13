% Parameters (with values embedded)
int: N = 5;
set of int: FOODS = 1..N;

array[FOODS] of string: food_name = ["Chicken","Pasta","Apples","Tuna","Rice"];

array[FOODS] of int: protein = [8, 10, 3, 16, 4];
array[FOODS] of int: carbs   = [8, 30, 10, 29, 24];
array[FOODS] of int: calories= [118,131,151,235,101];
array[FOODS] of int: cost    = [6, 10, 1, 9, 4];

int: req_protein  = 93;
int: req_carbs    = 181;
int: req_calories = 1620;

% Variable bounds (safe upper bounds derived from requirements and per-item nutrients)
int: ub_protein  = req_protein;   % if choosing only the best protein item (16)
int: ub_carbs    = req_carbs;     % if choosing only the best carb item (30)
int: ub_calories = req_calories;  % if choosing only the best calorie item (235)
int: UB = max(ub_protein, max(ub_carbs, ub_calories)); % generic, conservative cap

% Variables
array[FOODS] of var 0..UB: x; % number of servings of each food (nonnegative integers)

var int: total_cost = sum(i in FOODS)(cost[i] * x[i]);

% Constraints
constraint sum(i in FOODS)(protein[i]  * x[i]) >= req_protein;
constraint sum(i in FOODS)(carbs[i]    * x[i]) >= req_carbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= req_calories;

% Objective
solve minimize total_cost;

output [show(total_cost)];