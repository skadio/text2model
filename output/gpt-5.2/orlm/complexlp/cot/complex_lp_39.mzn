% Parameters (with values embedded)
int: n = 9;
set of int: FOODS = 1..n;

array[FOODS] of string: food_name = [
  "Chicken Breast", "Tofu", "Brown Rice", "Salmon", "Greek Yogurt",
  "Steak", "Avocado", "Eggs", "Quinoa"
];

array[FOODS] of int: cost =    [3, 2, 2, 6, 6, 10, 7, 5, 2];
array[FOODS] of int: protein = [17,15, 1,11,15, 12, 4,16,11];
array[FOODS] of int: carbs =   [28,11,11, 3,27,  3, 8,25,20];
array[FOODS] of int: calories=[136,198,93,269,121,80,300,99,87];

int: min_protein = 72;
int: min_carbs = 158;
int: min_calories = 1896;

% Variables
array[FOODS] of var 0..100: x;  % number of servings of each food (nonnegative integer)
var 0..10000: total_cost;

% Constraints
constraint total_cost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i] * x[i]) >= min_protein;
constraint sum(i in FOODS)(carbs[i] * x[i]) >= min_carbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= min_calories;

% Objective
solve minimize total_cost;