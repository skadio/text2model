% Parameters
int: nFoods = 5;
set of int: FOODS = 1..nFoods;

% Food indices (for readability)
int: STEAK   = 1;
int: RICE    = 2;
int: CHICKEN = 3;
int: LETTUCE = 4;
int: ALMONDS = 5;

% Nutrition and cost per serving for each food (indexed by FOODS)
array[FOODS] of int: protein  = [20, 6, 17, 1, 10];
array[FOODS] of int: carbs    = [12, 29, 26, 8, 2];
array[FOODS] of int: calories = [167, 275, 112, 148, 286];
array[FOODS] of int: cost     = [7, 8, 2, 8, 2];

% Minimum daily requirements
int: minProtein  = 83;
int: minCarbs    = 128;
int: minCalories = 1686;

% Safe upper bound on servings per food to keep the model bounded
int: maxServingsPerFood = minCalories;

% Variables
array[FOODS] of var 0..maxServingsPerFood: servings; % integer servings of each food
var 0..(maxServingsPerFood * sum(cost)): totalCost;  % total cost to minimize

% Constraints
% --- Nutrition minimum requirements ---
constraint
  sum(i in FOODS)(protein[i] * servings[i]) >= minProtein;

constraint
  sum(i in FOODS)(carbs[i] * servings[i]) >= minCarbs;

constraint
  sum(i in FOODS)(calories[i] * servings[i]) >= minCalories;

% --- Total cost definition ---
constraint
  totalCost = sum(i in FOODS)(cost[i] * servings[i]);

% Objective
solve minimize totalCost;

output [
  "totalCost=", show(totalCost), "\n",
  "servings=", show(servings), "\n"
];