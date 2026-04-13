% Parameters (with values embedded)
int: N = 8;
set of int: FOODS = 1..N;

array[FOODS] of string: food_name = [
  "Chicken breast","Tofu","Spinach","Beef steak","Eggs","Brown rice","Bananas","Quinoa"
];

array[FOODS] of int: cost = [7, 7, 1, 9, 6, 7, 2, 6];
array[FOODS] of int: protein = [12, 10, 11, 8, 16, 4, 4, 4];
array[FOODS] of int: carbs   = [5,  1,  30, 26, 9,  25, 16, 20];
array[FOODS] of int: calories= [231,210,295,211,232,146,255,205];

int: req_protein = 91;
int: req_carbs   = 136;
int: req_calories= 1563;

% Safe upper bound: meeting each requirement using the best single item
int: maxP = max([ (req_protein + protein[i] - 1) div protein[i] | i in FOODS ]);
int: maxC = max([ (req_carbs   + carbs[i]   - 1) div carbs[i]   | i in FOODS ]);
int: maxK = max([ (req_calories+ calories[i]- 1) div calories[i]| i in FOODS ]);
int: U = max([maxP, maxC, maxK]);

% Variables
array[FOODS] of var 0..U: x; % number of servings of each food (integer)

% Constraints
constraint sum(i in FOODS)(protein[i] * x[i]) >= req_protein;
constraint sum(i in FOODS)(carbs[i]   * x[i]) >= req_carbs;
constraint sum(i in FOODS)(calories[i]* x[i]) >= req_calories;

% Objective
var int: total_cost = sum(i in FOODS)(cost[i] * x[i]);
solve minimize total_cost;

output [show(total_cost)];