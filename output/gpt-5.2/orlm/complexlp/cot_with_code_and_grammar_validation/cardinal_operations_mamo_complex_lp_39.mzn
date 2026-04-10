% Parameters
int: n = 9;
set of int: FOODS = 1..n;

array[FOODS] of int: cost = [3, 2, 2, 6, 6, 10, 7, 5, 2];
array[FOODS] of int: protein = [17, 15, 1, 11, 15, 12, 4, 16, 11];
array[FOODS] of int: carbs = [28, 11, 11, 3, 27, 3, 8, 25, 20];
array[FOODS] of int: calories = [136, 198, 93, 269, 121, 80, 300, 99, 87];

int: minProtein = 72;
int: minCarbs = 158;
int: minCalories = 1896;

% Variable bounds (safe upper bounds from requirements)
int: ub_x = max(
  (minProtein div min(protein) + 1),
  max((minCarbs div min(carbs) + 1), (minCalories div min(calories) + 1))
);

% Variables
array[FOODS] of var 0..ub_x: x;

var int: totalCost;
var int: totalProtein;
var int: totalCarbs;
var int: totalCalories;

% Constraints
constraint totalCost = sum(i in FOODS)(cost[i] * x[i]);
constraint totalProtein = sum(i in FOODS)(protein[i] * x[i]);
constraint totalCarbs = sum(i in FOODS)(carbs[i] * x[i]);
constraint totalCalories = sum(i in FOODS)(calories[i] * x[i]);

constraint totalProtein >= minProtein;
constraint totalCarbs >= minCarbs;
constraint totalCalories >= minCalories;

% Objective
solve minimize totalCost;