% Parameters (with values embedded)
int: nFoods = 5;
set of int: FOODS = 1..nFoods;

array[FOODS] of string: foodName = ["Steak","Apples","Eggs","Chicken","Tofu"];

array[FOODS] of int: protein = [1, 7, 6, 20, 8];
array[FOODS] of int: carbs   = [3, 22, 18, 6, 4];
array[FOODS] of int: calories= [210, 96, 189, 132, 75];
array[FOODS] of int: cost    = [6, 1, 1, 3, 1];

int: reqProtein = 87;
int: reqCarbs   = 135;
int: reqCalories= 1926;

% Safe upper bounds (any feasible solution need not exceed these per item)
array[FOODS] of int: ub = [
  (reqProtein div max(1,protein[1])) + 1,
  (reqProtein div max(1,protein[2])) + 1,
  (reqProtein div max(1,protein[3])) + 1,
  (reqProtein div max(1,protein[4])) + 1,
  (reqProtein div max(1,protein[5])) + 1
];

% Variables
array[FOODS] of var 0..max(ub): x;  % number of servings of each food
var 0..100000: totalCost;

% Constraints
constraint totalCost = sum(i in FOODS)(cost[i] * x[i]);

constraint sum(i in FOODS)(protein[i]  * x[i]) >= reqProtein;
constraint sum(i in FOODS)(carbs[i]    * x[i]) >= reqCarbs;
constraint sum(i in FOODS)(calories[i] * x[i]) >= reqCalories;

% Objective
solve minimize totalCost;

output [
  "Minimum cost = $", show(totalCost), "\n",
  "Servings:\n"
] ++
[
  foodName[i] ++ ": " ++ show(x[i]) ++ "\n"
  | i in FOODS
] ++
[
  "Totals: protein=", show(sum(i in FOODS)(protein[i]*x[i])),
  " carbs=", show(sum(i in FOODS)(carbs[i]*x[i])),
  " calories=", show(sum(i in FOODS)(calories[i]*x[i])), "\n"
];